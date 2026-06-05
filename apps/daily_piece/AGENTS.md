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
| [`docs/screens/`](docs/screens/) | 화면 명세 11개 (framework-neutral .md) — Profile, MyPieces, Calendar, EditPiece, PieceDetails, NewPiece, CreateAccount, WelcomeBack, ResetPassword, Welcome, Search |
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
- **라우팅**: go_router — [ADR 0002](docs/adr/0002-routing.md). 라우터 정의는 `lib/app/router.dart` 단일 진입. 4-탭 shell은 `StatefulShellRoute.indexedStack` — 탭 전환 후 복귀 시 각 브랜치의 back stack 유지. 라우트: `/welcome`, `/sign-in`, `/sign-up`, `/reset-password`(비인증 공개), `/my-pieces`(+ `/:pieceId` + `/:pieceId/edit`), `/piece/:pieceId`(+ `/edit`), `/calendar`, `/search`, `/profile`(인증 전용).
- **레이어 컨벤션**: Clean Architecture — [ADR 0006](docs/adr/0006-clean-architecture-layout.md). 각 피처 / `core/` 하위는 `data / domain / presentation` 3-레이어로 분리하고, 그 아래는 역할별 디렉토리 (`entities / repositories / exceptions / datasources / pages / widgets / providers` …)로 나눈다. cross-feature 공유는 `lib/core/` (피스 도메인은 여러 화면에서 쓰이므로 여기에 둠).
- **DIP**: 도메인은 `repositories/` 아래 abstract 인터페이스만 둠. 데이터 레이어가 구현 + Riverpod provider를 노출하고, 프레젠테이션은 abstract 타입으로 받는다. 인터페이스 mock이 필요하기 전엔 fake provider override로 충분.
- **Use case 클래스는 미도입**. Riverpod provider가 use case 역할을 하므로 trivial wrapper UseCase는 만들지 않는다. 도메인 규칙이 여러 provider에 걸쳐 흐트러질 때 도입을 재평가.
- **위젯 1파일 1클래스 + 빈 줄 그루핑** — [`apps/AGENTS.md`의 코드 컨벤션 섹션](../AGENTS.md#-코드-컨벤션-모든-앱)에서 상속.
- **private widget class 금지(강제)**: `_Foo extends StatelessWidget/ConsumerWidget/...` 형태는 `pages/` 파일 내부에 두지 않고 반드시 `presentation/widgets/*.dart`로 분리. (`_FooPageState` 같은 state 보일러플레이트만 예외)

현 스켈레톤:

```
lib/
├── main.dart            # ProviderScope + Supabase.initialize + MaterialApp.router
├── app/
│   ├── app.dart         # MaterialApp.router widget
│   ├── router.dart      # GoRouter + redirect 가드 (auth 기반)
│   └── shell/
│       └── main_shell_page.dart  # 4-탭 BottomNav (StatefulShellRoute 호스트)
├── core/
│   ├── auth/            # isSignedInProvider (router redirect용 derived provider)
│   ├── domain/
│   │   ├── entities/        # Piece 등 도메인 엔티티 (프레임워크 free)
│   │   ├── repositories/    # abstract Port (Piece/Auth/Preferences Repository)
│   │   └── exceptions/      # PieceAlreadyExistsToday, AuthFailure 등 도메인 예외
│   ├── data/
│   │   ├── datasources/     # Supabase 호출만 하는 thin pipe (Piece/Auth/Preferences)
│   │   ├── repositories/    # *Impl + Riverpod provider, mapping/에러 변환
│   │   ├── cache/           # signed URL 캐시 (ADR 0005)
│   │   └── media/           # media_pipeline.dart + photo_picker.dart (ADR 0004)
│   ├── theme/           # themeModeProvider (SharedPreferences 영속)
│   └── env/             # envied 기반 SUPABASE_URL/ANON_KEY (.env)
└── features/
    ├── auth/            # Sign in / Sign up / Reset password (authRepository 경유)
    ├── welcome/         # 비인증 진입점 — 로그인/회원가입 CTA
    ├── my_pieces/       # 전체 Piece 피드 (full-width 카드, keyset 페이지네이션) + FAB → NewPiece
    ├── new_piece/       # 바텀시트 (NewPieceSheet) — My Pieces FAB / Calendar 빈 셀 탭
    ├── calendar/        # 월 그리드 — dot map, ±1개월 prefetch, 빈 셀 탭 → NewPieceSheet
    ├── search/          # 서버사이드 검색 — caption ilike + month 범위 필터
    ├── piece_detail/    # Piece 상세 read-only (/piece/:pieceId, /my-pieces/:pieceId)
    ├── edit_piece/      # Piece 편집 (/piece/:pieceId/edit, /my-pieces/:pieceId/edit) — 사진 교체 + 코멘트
    └── profile/         # 프로필 카드 + 설정 (테마, 로그아웃)
```

`features/<feature>/`는 모두 같은 골격: `presentation/{pages,widgets,providers}/` + 필요 시 `data/` + 필요 시 `domain/`. `new_piece`는 라우트 없이 바텀시트만 노출하므로 `pages/` 없이 `widgets/`만 존재한다.

`PieceRepository`(abstract)와 `pieceRepositoryProvider`는 [`core/`](lib/core/) 아래 공유 — My Pieces/Calendar/Search/PieceDetail이 같은 `pieces` 애그리거트를 다루므로 피처별 분산 대신 도메인 레이어로 끌어올렸다. 신규 도메인 작업 시 `core/data/datasources/` + `core/data/repositories/`에 메서드를 추가하고, 피처는 그 인터페이스만 의존한다.

---

## 🌐 외부 의존

| 카테고리 | 현 상태 |
|---|---|
| 백엔드 / DB / 스토리지 | **Supabase** ([ADR 0003](docs/adr/0003-backend.md)) — Postgres + Auth + Storage. SDK: `supabase_flutter`. |
| 인증 | Supabase Auth — 이메일/비밀번호 + Google OAuth. 세션은 `sessionProvider` (`@Riverpod(keepAlive: true)` Stream). dev 프로젝트는 **Confirm email = OFF** (가입 즉시 세션 발급), 운영은 ON 예정. |
| 미디어 스토리지 (사진) | Supabase Storage (`pieces` 버킷, `{user_id}/{piece_id}.jpg`). 클라이언트 파이프라인: 긴 변 1080px / JPEG q80 / EXIF 전체 제거 — [ADR 0004](docs/adr/0004-media-client-policy.md). 라이브러리: `flutter_image_compress`. |
| 로컬 캐시 / 오프라인 | In-memory signed URL 캐시 + Flutter `ImageCache`에 위임 — [ADR 0005](docs/adr/0005-local-cache-policy.md). 디스크 캐시 / 로컬 DB / 재시도 큐는 통증 보고되기 전까지 도입하지 않음. |
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

# private widget class 점검 (state class 제외 규칙은 리뷰에서 판정)
rg -n "class\\s+_\\w+\\s+extends\\s+(StatelessWidget|StatefulWidget|ConsumerWidget|ConsumerStatefulWidget)" lib

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
| `pieces` 테이블 + RLS | ✅ | [`supabase/migrations/0001`](supabase/migrations/0001_create_pieces_table.sql). dev 프로젝트에 적용됨 |
| `pieces` Storage bucket + policies | ✅ | [`supabase/migrations/0002`](supabase/migrations/0002_create_pieces_bucket.sql). private, owner-only |
| `profiles` 테이블 + RLS | ✅ | [`supabase/migrations/0003`](supabase/migrations/0003_create_profiles_table.sql). `display_name`, `avatar_url` 보관 |
| Sign in / Sign up (이름 저장 포함) | ✅ 코드 | `authRepository` 경유. `AuthFailure(message)`로 도메인 예외 단일화. 회원가입 시 이름 → user metadata 저장 |
| Welcome / WelcomeBack / Reset Password | ✅ 코드 | `/welcome` 비인증 진입점. `/sign-in`, `/sign-up`, `/reset-password` |
| My Pieces 피드 | ✅ 코드 | `date desc` keyset 페이지네이션, 전체 너비 카드, 빈 상태 CTA, FAB → NewPieceSheet |
| New Piece (바텀시트) | ✅ 코드 | `NewPieceSheet` — pick → compress → upload → INSERT. My Pieces FAB / Calendar 빈 셀 탭에서 호출 |
| Calendar 화면 | ✅ 코드 | 월 그리드 + dot map. `monthPiecesProvider(keepAlive: true)` — ±1개월 prefetch. 빈 셀 탭 → NewPieceSheet(forDate) |
| Search 화면 | ✅ 코드 | 서버사이드 caption ilike + month 범위 필터. `pieceMonths`로 month 칩 렌더링 |
| Piece detail 화면 | ✅ 코드 | `/piece/:pieceId`(공용) + `/my-pieces/:pieceId`(탭 내부). `pieceByIdProvider(family)` → 큰 사진 + 코멘트 + 날짜. 없는 row → "찾을 수 없어요" CTA |
| Edit Piece 화면 | ✅ 코드 | `/piece/:pieceId/edit`(공용) + `/my-pieces/:pieceId/edit`(탭 내부). 사진 교체 + 코멘트 수정. 날짜 변경은 deferred (UNIQUE 제약) |
| Profile 화면 | ✅ 코드 | 프로필 카드(이름/이메일/아바타) + 테마(System/Light/Dark) + 로그아웃. 이름/아바타는 `profiles` 우선 조회, 없으면 auth metadata 폴백 |
| Bottom navigation (My Pieces / Calendar / Search / Profile) | ✅ 코드 | `StatefulShellRoute.indexedStack` 4-탭. 탭 재탭 시 브랜치 루트로 pop |
| Google OAuth (Sign in with Google) | ✅ 코드 | Sign In / Sign Up 화면. `google_sign_in_button.dart` + `google_mark.dart` 위젯 분리. |
| OAuth 콜백 딥링크 (iOS / Android) | ✅ | `apps/daily_piece/ios/Runner/Info.plist` URL Scheme + `AndroidManifest.xml` intent-filter 등록. Supabase OAuth redirect 처리. |
| 앱 아이콘 (iOS / Android) | ✅ | iOS: `AppIcon.appiconset` 전 사이즈. Android: adaptive icon (`ic_launcher_foreground.png` + `ic_launcher.xml`). 소스: `assets/app_icon/`. |
| UI 언어 | ✅ 영문화 완료 | 모든 화면 텍스트·에러 메시지 영어로 통일 (2026-05-25). 한국어 리터럴 제거. |
| 카메라 캡처 | ✅ 실기 검증 완료 | 갤러리/카메라 chooser 바텀시트. iOS `NSCameraUsageDescription`만 선언. Android는 권한 불요 — image_picker가 `ACTION_IMAGE_CAPTURE`로 카메라 앱에 위임하므로 `CAMERA` permission 제거. 헬퍼: [`core/data/media/photo_picker.dart`](lib/core/data/media/photo_picker.dart) |
| Android 갤러리 권한 | ✅ 권한 불요 확정 | image_picker가 시스템 Photo Picker / `ACTION_GET_CONTENT`로 위임 → `READ_MEDIA_IMAGES` 불필요. 매니페스트 권한은 `INTERNET` 단일. |
| 오류 snackbar 통일 | ✅ | `WdsSnackbar`로 transport 에러 단일 노출 |
| 위젯 테스트 | 🟡 router redirect 2개만 | feature 단위 테스트는 의도적 미도입 (출시 범위 제외) |
| ADR 0005 (캐시 정책) | ✅ Accepted | [ADR 0005](docs/adr/0005-local-cache-policy.md). `signedUrlCacheProvider` 1h TTL → ImageCache 히트. 디스크 캐시/로컬 DB/재시도 큐는 보류 |

### 데이터 레이어 정책 (현 시점)
[ADR 0005](docs/adr/0005-local-cache-policy.md). Piece 메타데이터는 Riverpod in-memory provider가 watch되는 동안 유지. 사진은 path 기준 signed URL 캐시(1h TTL, `signedUrlCacheProvider`) → Flutter ImageCache가 같은 URL = 같은 키로 히트. Calendar는 `monthPiecesProvider(keepAlive: true)`로 ±1개월 warm 유지. 디스크 캐시 / 로컬 DB / 오프라인 큐는 추가 통증 보고되기 전까지 보류.

### 출시 상태

전체 흐름 실기 sweep(가입 → My Pieces → New Piece 갤러리/카메라 → Calendar → Search → Edit/Delete → Profile)을 실기기에서 검증 완료. **v1 출시 범위 기능은 완료.**

**의도적 출시 범위 제외** (필요 시점에 재평가):
- **크래시 리포팅 / 분석** (Sentry / Firebase Crashlytics 등) — v1 미도입.
- **feature 단위 테스트** — v1은 router redirect smoke 2개만 유지.

### 선택 (출시 후여도 됨)
- **딥링크 매니페스트** — iOS Universal Links / Android App Links. OAuth 콜백 딥링크는 이미 동작, 콘텐츠 딥링크는 별개. ADR 0002 후속으로 분리.
- **Supabase CLI 부트스트랩** — `supabase init/link/db pull`로 SQL-파일 기반 마이그레이션 관리. (현재는 MCP `apply_migration` + 수동 `supabase/migrations/*.sql` 보관 중.)

---

## 🧬 출처

- **디자인 출처**: [Figma — DailyPiece](https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece) (node-id 8:2 = 디자인 보드 전체)
- **분석 시점**: 2026-04-26
