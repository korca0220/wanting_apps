# ADR 0002 — Routing: go_router

- Status: Accepted
- Date: 2026-05-17
- Scope: `apps/one_line_day`

## Context

OneLine Day는 탭 기반 탐색과 작성 시트(`Edit Entry`)를 함께 사용한다. 탭 전환 후 복귀 시 이전 탐색 맥락을 유지해야 하며, 단일 라우팅 테이블에서 화면 전이를 관리해야 한다.

## Decision

**go_router**를 사용한다.

- `StatefulShellRoute.indexedStack`로 5개 탭(`today`, `calendar`, `entries`, `search`, `settings`)을 구성한다.
- `edit-entry`는 각 탭에서 진입 가능한 서브 라우트로 둔다.
- 라우터 정의는 `lib/app/router.dart` 단일 진입점으로 유지한다.

## Consequences

**Pros**
- 탭별 백스택 유지가 명확하다.
- 선언형 route table로 화면 전이 규칙을 한 곳에서 관리할 수 있다.
- 추후 딥링크 추가 시 path 기반 확장이 쉽다.

**Cons**
- 중첩 라우팅 구조 학습 비용이 있다.

## Implementation notes

- `MaterialApp.router(routerConfig: ref.watch(appRouterProvider))` 패턴을 사용한다.
- 기본 path는 `/today`, `/calendar`, `/entries`, `/search`, `/settings`로 고정한다.
