# ADR 0001 — State Management: Riverpod

- Status: Accepted
- Date: 2026-05-17
- Scope: `apps/one_line_day`

## Context

OneLine Day는 `Today`, `Calendar`, `Entries`, `Search`, `Settings`의 5탭 구조이며 공통으로 `Entry`와 앱 설정 상태를 읽고 갱신한다.

요구사항:

- 의존성과 상태를 컴파일 타임에 안전하게 관리
- 테스트에서 저장소/서비스를 override 가능
- 비동기 상태를 단일 패턴으로 관리

## Decision

**Riverpod** (`flutter_riverpod` + `riverpod_annotation` codegen)을 사용한다.

- 의존성과 상태는 Provider로 노출한다.
- `@riverpod` codegen으로 보일러플레이트를 줄인다.
- 테스트에서는 `ProviderScope(overrides: [...])`를 기본 전략으로 사용한다.

## Consequences

**Pros**
- 상태/DI 경로가 단일화되어 화면별 중복 상태 관리 방식을 피할 수 있다.
- `AsyncValue<T>` 패턴으로 로딩/에러/데이터 표현이 일관된다.
- 위젯/유닛 테스트에서 저장소 대체가 쉽다.

**Cons**
- codegen 단계(`build_runner`)가 필요하다.

## Implementation notes

- `main.dart`를 `ProviderScope`로 감싼다.
- 피처 provider는 `lib/features/<feature>/presentation/providers/`에 둔다.
- 공유 저장소 provider는 `lib/core/data/repositories/`에 둔다.
