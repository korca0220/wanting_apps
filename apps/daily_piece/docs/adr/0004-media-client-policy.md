# ADR 0004 — Media Client Policy

- Status: Accepted
- Date: 2026-05-10
- Scope: `apps/daily_piece` — Today flow upload pipeline.

## Context

Piece 1개 = 사진 1장 + ≤50자 코멘트. 사진은 Supabase Storage (`pieces` 버킷, 무료 1GB) 에 보관한다.

원본 그대로 올리면 한 장 3–8MB가 흔하고, 1GB 한도는 ~150–300장에서 소진된다. DailyPiece 사용 패턴(하루 1장)으로 1년이 안 가서 막힌다. 클라이언트에서 리사이즈/압축으로 자르는 게 유일한 현실적 방어선.

추가로:
- iPhone 사진은 GPS 좌표·디바이스 정보를 EXIF에 포함 → 의도치 않은 위치 노출 위험.
- iOS/Android 카메라는 센서 native orientation으로 저장하고 EXIF의 `Orientation` 태그로 회전 의도를 표현 → EXIF를 통째로 날리면 사진이 옆으로 누울 수 있음. 리사이즈 라이브러리가 디코드 단계에서 회전을 적용한 뒤 픽셀 자체를 정자세로 저장하면 EXIF는 안 남겨도 안전.

## Decision

업로드 전 클라이언트에서 다음 파이프라인을 항상 적용:

| 단계 | 결정 |
|---|---|
| 픽 | `image_picker` (camera + gallery). |
| 리사이즈 | 긴 변 **1080px**로 다운스케일. 짧은 변은 비율 유지. 원본이 더 작으면 업스케일하지 않음. |
| 인코딩 | **JPEG, quality = 80**. PNG/HEIC 입력도 JPEG로 통일. |
| EXIF | **전체 제거** (GPS/디바이스/타임스탬프 포함). 라이브러리가 픽셀 회전을 baked-in해 정자세 저장. |
| 라이브러리 | **`flutter_image_compress`** (native iOS/Android). |
| Storage 경로 | `{user_id}/{piece_id}.jpg` (확장자 고정). |

**예상 파일 크기**: 1080px × q80 ≈ 150–300KB → 1GB로 ~4,000장. 1인 사용자 11년치.

**날짜 처리**: Piece의 `date` 컬럼은 사용자 입력(또는 "오늘") 기반. EXIF의 촬영 시각에 의존하지 않으므로 EXIF 제거가 도메인 손실을 만들지 않음.

## Consequences

**Pros**
- Storage 무료 한도 안에서 장기 운영 가능.
- 위치 정보 유출 위험 0 — 사용자가 따로 인지하지 않아도 안전.
- 업로드 트래픽도 ~10배 감소 → 모바일 데이터 사용/지연 개선.
- 정자세 저장으로 클라이언트마다 회전 보정 코드 분기할 필요 없음.

**Cons**
- 원본 보관 안 함. 사용자가 "원본 다시 받기" 같은 기능을 원해도 불가 — 본 앱은 personal archiving이지 backup tool이 아니므로 수용.
- HEIC → JPEG 변환은 파일 크기를 약간 키울 수 있음(HEIC가 더 효율적). 다만 표시/공유 호환성, Storage 일관성을 위해 JPEG 단일 포맷 채택.
- `flutter_image_compress`는 native 의존성 → 데스크톱/웹 타깃 추가 시 fallback (`image` 패키지) 필요. 현재 모바일 타깃 한정이라 무이슈.

**대안 기각 사유**
- **원본 그대로 업로드**: 1GB 한도 ~150장. 즉시 막힘.
- **1440px 또는 2048px**: 1GB 한도가 각각 ~2,500장 / ~1,000장으로 빠르게 줄어듦. 긴 변 1080은 모바일 풀스크린에서도 충분히 선명.
- **순수 Dart `image` 패키지**: 큰 사진(8000×6000) 디코드/인코드가 느리고 메모리 spike 큼. native가 더 안전.
- **EXIF 부분 보존(GPS만 제거, orientation 유지)**: 라이브러리가 디코드 시 회전을 적용한 뒤 픽셀에 baked-in 하면 어차피 orientation 태그 불필요. "전체 제거"가 더 단순하고 안전.

## Implementation notes

### 의존성
```yaml
# pubspec.yaml
dependencies:
  image_picker: ^1.1.2
  flutter_image_compress: ^2.3.0
```

### iOS Info.plist 권한
```xml
<key>NSCameraUsageDescription</key>
<string>Take a photo for your daily Piece.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Choose a photo for your daily Piece.</string>
```

### Android
`image_picker` 1.x는 별도 manifest 권한 불필요(SAF 기반). 카메라 사용 시 `<uses-permission android:name="android.permission.CAMERA"/>` 추가.

### 파이프라인 (의사코드)
`lib/features/today/media_pipeline.dart` (예정):

```dart
Future<Uint8List> processForUpload(XFile picked) async {
  return await FlutterImageCompress.compressWithFile(
    picked.path,
    minWidth: 1080,
    minHeight: 1080,        // 라이브러리는 긴 변 기준으로 fit, 짧은 변은 비율 유지
    quality: 80,
    keepExif: false,        // EXIF 전체 제거 — 픽셀 회전은 디코드 단계에서 baked-in
    format: CompressFormat.jpeg,
  );
}
```

업로드:
```dart
final pieceId = const Uuid().v4();
final path = '${userId}/$pieceId.jpg';
await Supabase.instance.client.storage
    .from('pieces')
    .uploadBinary(path, bytes,
        fileOptions: const FileOptions(contentType: 'image/jpeg'));
```

### 검증 (테스트 시점)
- 단위: 5MB JPEG 입력 → 출력 ≤500KB, 긴 변 ≤1080.
- 단위: EXIF 포함 입력 → 출력의 EXIF 블록 없음 (`exif` 패키지로 검증).
- 단위: 세로/가로 양쪽 입력 → 출력이 정자세 (`image` 패키지로 width/height 비율 검증).

### 향후 확장 포인트
- 압축 실패 시 원본을 그대로 올리지 않고 사용자에게 에러 표시 — Storage 정책 보호.
- 무료 한도 80% 도달 시 사용자 경고 (별도 ADR로 다룰 만한 사이즈).
