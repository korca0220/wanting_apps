# DailyPiece (데일리피스) — 앱 진입점

상위 규약: [`apps/AGENTS.md`](../AGENTS.md). 레포 진입점: [`/AGENTS.md`](../../AGENTS.md). DS: [`packages/design_system/`](../../packages/design_system/).

---

## 🎯 도메인

**라이프스타일 / 퍼스널 아카이빙 (Personal Archiving)** 영역의 미니멀 라이프 로깅 앱. 유저의 파편화된 일상을 시각적으로 수집하고 기록한다.

### 도메인 모델

| 개념 | 정의 |
|---|---|
| **Piece** | 하루의 가장 빛나는 순간을 담은 사진 1장 + 50자 이내 코멘트. 기록의 최소 단위. |
| **Collection** | 흩어진 Piece들이 모여 만드는 개인 타임라인. |
| **Minimalism** | 일기 쓰기 부담을 줄이기 위한 도메인 규칙: **"하루 한 장"** 제약. |

### 핵심 도메인 규칙

- **하루 한 Piece**: 같은 날짜에 2개 이상의 Piece를 만들 수 없다. 도메인 invariant.
- **Piece 구성요소**: 사진(필수) + 코멘트(필수, ≤ 50자) + 날짜(자동 또는 사용자 지정).
- **타임라인**: Collection은 시간순(역순 또는 정순) 표시가 기본.

> 추가 도메인 규칙(태그/감정/장소 등 메타데이터, 비공개/공개 모델, 멀티 디바이스 동기화 등)은 ADR로 결정한 뒤 본 문서에 반영.

---

## 📂 앱 구조

| 경로 | 역할 |
|---|---|
| [`docs/screens/`](docs/screens/) | 화면 명세 11개 (framework-neutral .md) — Profile, MyPieces, Calendar, EditPiece, PieceDetails, Home, NewPiece, CreateAccount, WelcomeBack, ResetPassword |
| [`docs/screens/00-INDEX.md`](docs/screens/00-INDEX.md) | 화면 인덱스 + 통계 |
| [`docs/screens/TEMPLATE.md`](docs/screens/TEMPLATE.md) | 새 화면 템플릿 |
| `lib/` | Flutter 구현 — [구현 상태](#-구현-상태) 참고 |
| `supabase/migrations/` | 백엔드 스키마 SQL (replay 가능). README는 폴더 안에. |
| `test/` | 위젯/유닛 테스트 (현재 router redirect smoke만) |
| `analysis_options.yaml` | 앱 lint (현재 `flutter_lints` 기본) |
| `pubspec.yaml` | 의존성 |

### lib/ 구조

확정된 결정:

- **상태관리 / DI**: Riverpod (`flutter_riverpod` + `riverpod_annotation` codegen) — [ADR 0001](docs/adr/0001-state-management.md). 신규 provider는 `@Riverpod(...)` 함수/클래스로 작성. `riverpod_lint`가 `custom_lint` 플러그인으로 활성화돼 있어 forgot-to-watch / 누락된 keepAlive 등을 잡아준다.
- **라우팅**: go_router — [ADR 0002](docs/adr/0002-routing.md). 라우터 정의는 `lib/app/router.dart` 단일 진입.
- **레이어 컨벤션**: Clean Architecture. 각 피처 / `core/` 하위는 `data / domain / presentation` 3-레이어로 분리하고, 그 아래는 역할별 디렉토리 (`entities / repositories / exceptions / datasources / pages / widgets / providers` …)로 나눈다. cross-feature 공유는 `lib/core/` (피스 도메인은 여러 화면에서 쓰이므로 여기에 둠).
- **DIP**: 도메인은 `repositories/` 아래 abstract 인터페이스만 둠. 데이터 레이어가 구현 + Riverpod provider를 노출하고, 프레젠테이션은 abstract 타입으로 받는다. 인터페이스 mock이 필요하기 전엔 fake provider override로 충분.
- **Use case 클래스는 미도입**. Riverpod provider가 use case 역할을 하므로 trivial wrapper UseCase는 만들지 않는다. 도메인 규칙이 여러 provider에 걸쳐 흐트러질 때 도입을 재평가.

현 스켈레톤:

```
lib/
├── main.dart            # ProviderScope + Supabase.initialize + MaterialApp.router
├── app/
│   ├── app.dart         # MaterialApp.router widget
│   └── router.dart      # GoRouter + redirect 가드 (auth 기반)
├── core/
│   ├── auth/            # session_provider.dart (@Riverpod, keepAlive)
│   ├── domain/
│   │   ├── entities/        # Piece 등 도메인 엔티티 (프레임워크 free)
│   │   ├── repositories/    # abstract Port (PieceRepository)
│   │   └── exceptions/      # PieceAlreadyExistsToday 등 도메인 예외
│   ├── data/
│   │   ├── datasources/     # Supabase 호출만 하는 thin pipe
│   │   └── repositories/    # *Impl + Riverpod provider, mapping/에러 변환
│   └── env/                 # envied 기반 SUPABASE_URL/ANON_KEY (.env)
└── features/
    ├── auth/            # Sign in / Sign up (구현됨, CA 미분리 — 후속 정리)
    ├── today/           # 아래 today/ 내부 구조 참고
    ├── collection/      # 타임라인 (stub)
    ├── piece_detail/    # Piece 상세 (stub)
    └── settings/        # 설정 (stub)
```

### today/ 내부 구조

```
features/today/
├── data/
│   └── media/
│       └── media_pipeline.dart  # ADR 0004 — 1080px / JPEG q80 / EXIF strip
└── presentation/
    ├── pages/
    │   └── today_page.dart      # AsyncValue 분기 → loading / error / Compose / View
    ├── widgets/
    │   ├── compose_view.dart    # Pick → preview → comment → save 상태머신
    │   └── piece_view.dart      # 저장된 Piece read-only (signed URL FutureBuilder)
    └── providers/
        └── today_piece_provider.dart  # @riverpod Future<Piece?>, pieceRepository 위임
```

`PieceRepository`(abstract)와 `pieceRepositoryProvider`는 [`core/`](lib/core/) 아래 공유 — Today/Collection/PieceDetail이 같은 `pieces` 애그리거트를 다루므로 피처별 분산 대신 도메인 레이어로 끌어올렸다. 신규 도메인 작업(예: Collection 페이지네이션) 시 `core/data/datasources/` + `core/data/repositories/`에 메서드를 추가하고, 피처는 그 인터페이스만 의존한다.

---

## 🌐 외부 의존

| 카테고리 | 현 상태 |
|---|---|
| 백엔드 / DB / 스토리지 | **Supabase** ([ADR 0003](docs/adr/0003-backend.md)) — Postgres + Auth + Storage. SDK: `supabase_flutter`. |
| 인증 | Supabase Auth — 이메일/비밀번호 (OAuth 미적용). 세션은 `sessionProvider` (`@Riverpod(keepAlive: true)` Stream). dev 프로젝트는 **Confirm email = OFF** (가입 즉시 세션 발급), 운영은 ON 예정. |
| 미디어 스토리지 (사진) | Supabase Storage (`pieces` 버킷, `{user_id}/{piece_id}.jpg`). 클라이언트 파이프라인: 긴 변 1080px / JPEG q80 / EXIF 전체 제거 — [ADR 0004](docs/adr/0004-media-client-policy.md). 라이브러리: `flutter_image_compress`. |
| 로컬 영속화 / 오프라인 | TBD ([ADR 0005] 예정 — drift / Hive / in-memory 결정) |
| 분석/크래시 리포팅 | TBD |
| 푸시 알림 | TBD |

> 비밀 키는 절대 `lib/`/docs에 두지 않는다. `SUPABASE_URL` / `SUPABASE_ANON_KEY`는 `apps/daily_piece/.env` (gitignored) → `envied`가 obfuscate해 컴파일 타임 상수로 노출. 로컬: `cp .env.example .env` 후 값 채움 → `melos run gen`. CI: GitHub Secrets에서 `.env` 시드 후 codegen.

---

## 🎨 디자인 시스템 사용

```dart
import 'package:design_system/design_system.dart';

MaterialApp(
  theme: WdsTheme.light(),
  darkTheme: WdsTheme.dark(),
  // ...
)
```

화면 안에서:

```dart
final colors = context.wdsColors;
final type = context.wdsType;
Container(
  color: colors.backgroundNormalNormal,
  padding: EdgeInsets.all(context.wdsSpacing.md),
  child: Text('Today', style: type.heading1),
);
```

**금지**: `Color(0xFF...)` 직접, `TextStyle(fontSize: 16)` 직접, raw px 패딩. 모두 `context.wds*`로 접근.

---

## 🔧 명령어

```bash
# 실행
melos run run:dp
# 또는
melos exec -c 1 --scope=daily_piece -- "flutter run"

# 분석/테스트
melos exec -c 1 --scope=daily_piece -- "flutter analyze"
melos exec -c 1 --scope=daily_piece -- "flutter test"

# 화면 명세 검증
python3 ../../../design-system-gen/skills/screen-spec-gen/scripts/validate_screen.py \
  --ds-root ../../packages/design_system/docs \
  --repo-root ../../ \
  docs/screens/
```

---

## 📜 작업 흐름

### 새 화면 추가

1. `docs/screens/TEMPLATE.md` 복제 → `NN-{name}.md`
2. frontmatter `extends: design_system` 명시
3. Skeleton → Bindings → Intent 순서로 채움
4. `docs/screens/00-INDEX.md`에 항목 추가
5. `validate_screen.py` 통과 확인
6. (구현 단계) `lib/`에 화면 widget 작성 — DS 토큰만 사용

### 새 도메인 규칙 추가

1. 본 문서 `🎯 도메인 → 핵심 도메인 규칙`에 한 줄 추가
2. 영향 받는 화면 명세의 Intent 섹션 갱신
3. 코드에 반영 시 가능한 한 타입/enum으로 표현 (e.g., `Piece.commentMaxLength`)

### 새 ADR 추가

1. `docs/adr/NNNN-{kebab-name}.md` 생성 (NNNN은 4자리 일련번호)
2. 결정 이유, 검토한 대안, 결정 시점, 영향을 명시
3. 본 AGENTS.md의 관련 섹션에 ADR 링크 추가

---

## 🛡️ 앱 단위 불변 규칙

[`apps/AGENTS.md`](../AGENTS.md)의 공통 불변 규칙에 더해, DailyPiece 한정:

1. **하루 한 Piece** — 동일 날짜의 Piece 중복 생성을 코드 레벨에서 차단 (UI 상태 + 데이터 레이어 양쪽에서).
2. **코멘트 ≤ 50자** — 입력 단에서 강제, 데이터 모델에서도 검증.
3. **사진 필수** — Piece는 사진 없이 생성 불가.

> 위 규칙은 `WdsTextField.maxLength`, 도메인 모델 validator, repository write 시점 검증 등 다층에서 강제한다.

---

## 📊 구현 상태

세션 간 컨텍스트 유지를 위한 핸드오프 보드. 코드 작성 ≠ 실기 검증임에 유의.

| 영역 | 상태 | 비고 |
|---|---|---|
| Supabase client bootstrap | ✅ | `main.dart`에서 `Supabase.initialize` |
| `pieces` 테이블 + RLS | ✅ | [`supabase/migrations/0001`](supabase/migrations/0001_create_pieces_table.sql). MCP로 dev 프로젝트에 적용됨 |
| `pieces` Storage bucket + policies | ✅ | [`supabase/migrations/0002`](supabase/migrations/0002_create_pieces_bucket.sql). private, owner-only |
| Sign in / Sign up | ✅ 코드, 🟡 실기 sweep 완료 (가입 → /today 도달 확인) | view 모드 (이메일 입력 + 비밀번호 + 에러 inline). Confirm email 분기 양쪽 코드만 검증 |
| Today: 작성 흐름 (compose) | ✅ 코드, ❌ 실기 미검증 | pick → compress → upload → INSERT. iOS 권한 다이얼로그 / 압축 결과 / Storage 업로드 결과 / view 모드 전환 모두 직접 sweep 필요 |
| Today: 조회 (view 모드) | ✅ 코드, ❌ 실기 미검증 | signed URL 이미지 로드 |
| Today: edit / delete | ❌ | view 모드는 read-only. UX 결정 후 추가 |
| 카메라 캡처 | ❌ | 갤러리만. `ImageSource.camera` 추가 시 iOS `NSCameraUsageDescription` + Android `CAMERA` permission 필요 |
| Collection 화면 | ❌ stub | 페이지네이션 + 썸네일 그리드 |
| Piece detail 화면 | ❌ stub | |
| Settings 화면 | ❌ stub | |
| Bottom navigation (Today ↔ Collection) | ❌ | DS의 `WdsBottomNavigation` 사용 가능 |
| 위젯 테스트 | 🟡 router redirect 2개만 | feature 단위 테스트 추가 필요 |
| ADR 0005 (영속 캐시 / 재시도 큐) | ❌ deferred | **데이터 레이어 임시 정책** 참고 |

### 데이터 레이어 임시 정책
Today/Collection 첫 컷은 **캐시 없이 Supabase 직결**. Riverpod이 watch되는 동안의 in-memory만으로 시작. 실제 UX 통증(앱 재시작 깜박임, 비행기모드 저장 실패 등)을 본 뒤에 ADR 0005에서 결정.

### 다음 합리적 단계 (권장 순서)

1. **Today 흐름 실기 sweep** (`melos run run:dp` → 사진 픽 → 저장 → view 모드 → 앱 재시작 시에도 view 모드 유지). 깨지는 지점 발견 시 그 자리에서 수정.
2. **Collection 화면 실구현** — 페이지네이션 (`pieces` 테이블 `created_at` 또는 `date` desc로 keyset/range). 썸네일은 signed URL 캐싱 정책 결정 필요 (signed URL 1h만 → screen 재진입 시 재발급).
3. **WdsBottomNavigation으로 Today ↔ Collection 전환** + 라우트 연결.
4. **Piece detail 화면** (`/collection/:pieceId`) — 큰 사진 + 코멘트.
5. ADR 0005 — 1~4 돌려보고 통증 기반으로 결정.

### 선택
- **Supabase CLI 부트스트랩** — `supabase init/link/db pull`로 SQL-파일 기반 마이그레이션 관리. (현재는 MCP `apply_migration` + 수동 `supabase/migrations/*.sql` 보관 중.)
- **카메라 캡처** — UX 결정과 묶어서.

---

## 🧬 출처

- **디자인 출처**: [Figma — DailyPiece](https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece) (node-id 8:2 = 디자인 보드 전체)
- **분석 시점**: 2026-04-26
