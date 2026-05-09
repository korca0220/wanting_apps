# ADR 0001 — State Management: Riverpod

- Status: Accepted
- Date: 2026-05-10
- Scope: `apps/daily_piece`

## Context

DailyPiece는 Personal Archiving 도메인 앱이다. 다루는 상태는 (1) 오늘의 Piece 작성 폼(임시 사진 + ≤50자 코멘트), (2) Collection 타임라인 페이지네이션/캐시, (3) "하루 한 개" 불변식 검증, (4) 인증/세션, (5) 미디어 업로드 진행률 정도다. 다수 화면이 같은 도메인 객체(오늘의 Piece, 사용자, 컬렉션 캐시)를 공유하지만, 화면 간 결합은 헐겁다.

요구사항:

- 컴파일 타임에 의존성이 잡혀야 함 (`provider`의 `BuildContext` 누락 같은 런타임 실패 회피)
- DI와 상태가 같은 메커니즘으로 표현돼 테스트 시 override 쉬움
- 보일러플레이트 적당 — 1인 개발 페이스
- 비동기 상태(`AsyncValue`) first-class

## Decision

**Riverpod** (`flutter_riverpod` + `riverpod_annotation` codegen).

- 모든 의존성/상태는 Provider로 노출. `ref.read` / `ref.watch` 일원화.
- codegen (`@riverpod`) 사용 — 타입 안전 + 보일러플레이트 감축.
- 테스트는 `ProviderContainer` 또는 `ProviderScope(overrides: [...])`로 격리.

## Consequences

**Pros**
- 컴파일 타임 안전, runtime DI 실패 없음
- `AsyncValue<T>` 패턴이 로딩/에러/데이터를 자연스럽게 표현 — Collection 페이지네이션과 잘 맞음
- 화면/위젯에서 Provider override만으로 위젯 테스트 가능
- Riverpod 생태계 (`riverpod_lint`, devtools) 활용

**Cons**
- codegen 도입으로 빌드 단계(`build_runner`) 추가
- 신규 멤버는 `ref` mental model 학습 필요 (1인 팀이라 부담 작음)

**대안 기각 사유**
- **Bloc**: 1인 페이스에 비해 이벤트/상태 클래스 보일러플레이트 과다. 명확한 이벤트-소싱 요구 없음.
- **ValueNotifier + InheritedWidget**: Collection 캐시 같은 cross-screen 공유 상태를 직접 wire-up하면 곧 한계.
- **signals_flutter**: 가볍지만 생태계/문서/lint 지원이 Riverpod 대비 얇음.

## Implementation notes

- `pubspec.yaml` 추가: `flutter_riverpod`, `riverpod_annotation`. dev: `build_runner`, `riverpod_generator`, `custom_lint`, `riverpod_lint`.
- `main.dart`를 `ProviderScope`로 감쌈.
- Provider는 feature 디렉토리에 co-locate (예: `lib/features/today/today_piece_provider.dart`).
- 테스트는 `flutter_test` + `ProviderContainer`로 작성. 위젯 테스트는 `ProviderScope(overrides: [...])`.
