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
| `lib/` | Flutter 구현 (현재 `main.dart`만, 레이어 구조 미정) |
| `test/` | 위젯/유닛 테스트 (현재 default scaffold만) |
| `analysis_options.yaml` | 앱 lint (현재 `flutter_lints` 기본) |
| `pubspec.yaml` | 의존성 |

### lib/ 구조

확정된 결정:

- **상태관리 / DI**: Riverpod (`flutter_riverpod` + `riverpod_annotation`) — [ADR 0001](docs/adr/0001-state-management.md). DI는 Provider로 일원화 (별도 서비스 로케이터 없음).
- **라우팅**: go_router — [ADR 0002](docs/adr/0002-routing.md). 라우터 정의는 `lib/app/router.dart` 단일 진입.
- **레이어 컨벤션**: features-first. `lib/features/<feature>/` 안에 widget + provider + repository를 co-locate. cross-feature 공유는 `lib/core/` (auth, http client, domain models).

타깃 스켈레톤 (P1-#8에서 깔 예정):

```
lib/
├── main.dart            # ProviderScope + MaterialApp.router
├── app/
│   ├── app.dart         # MaterialApp.router widget
│   └── router.dart      # GoRouter + redirect 가드
├── core/
│   ├── auth/            # 인증 상태 Provider
│   ├── domain/          # Piece, Collection 등 도메인 모델
│   └── http/            # API 클라이언트 (백엔드 결정 후)
└── features/
    ├── today/           # 오늘의 Piece 작성
    ├── collection/      # 타임라인
    ├── piece_detail/    # Piece 상세
    └── settings/
```

---

## 🌐 외부 의존

| 카테고리 | 현 상태 |
|---|---|
| 백엔드 / DB / 스토리지 | **Supabase** ([ADR 0003](docs/adr/0003-backend.md)) — Postgres + Auth + Storage. SDK: `supabase_flutter`. |
| 인증 | Supabase Auth (이메일/비밀번호 시작; OAuth는 콘솔 추가). 세션은 `StreamProvider<Session?>` 노출 예정. |
| 미디어 스토리지 (사진) | Supabase Storage (`pieces` 버킷, `{user_id}/{piece_id}.{ext}`). 클라이언트 캐시/리사이즈 정책은 ADR 0004에서. |
| 로컬 영속화 / 오프라인 | TBD ([ADR 0005] 예정 — drift / Hive / in-memory 결정) |
| 분석/크래시 리포팅 | TBD |
| 푸시 알림 | TBD |

> 비밀 키는 절대 `lib/`/docs에 두지 않는다. URL/anonKey는 `--dart-define` 또는 CI Secrets에서 주입.

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

## 🧬 출처

- **디자인 출처**: [Figma — DailyPiece](https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece) (node-id 8:2 = 디자인 보드 전체)
- **분석 시점**: 2026-04-26
