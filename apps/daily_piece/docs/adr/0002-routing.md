# ADR 0002 — Routing: go_router

- Status: Accepted
- Date: 2026-05-10
- Scope: `apps/daily_piece`

## Context

DailyPiece의 화면 토폴로지는 단순하다 — 진입(인증), 오늘의 Piece 작성, Collection 타임라인, Piece 상세, 설정 정도. 그러나 (1) 푸시 알림/딥링크로 특정 Piece 상세에 직진해야 하고, (2) 인증 가드(미인증 시 로그인으로 redirect)가 전역에 필요하며, (3) 향후 웹 빌드를 켤 가능성이 열려 있어 URL-addressable한 라우팅이 유리하다.

## Decision

**go_router** (Flutter 팀 공식 패키지).

- declarative route table + URL 매핑 + redirect 가드.
- Riverpod와 통합: 인증 상태 Provider를 `refreshListenable` 또는 `redirect`에서 구독해 미인증 시 `/sign-in`으로 보냄.
- typed-route는 `go_router`의 `GoRouteData` (선택적, 도입 결정 후속).

## Consequences

**Pros**

- Flutter 팀이 유지보수 — Material/Navigator 2.0 변화에 빠르게 대응
- URL 기반 → 딥링크/웹 무료
- redirect 패턴이 인증 가드를 한 곳에 집약
- `ShellRoute`로 BottomNav 같은 nested navigation 표현 명확

**Cons**

- typed-routes가 codegen 필요 (`auto_route`보다 형식 안전성 약간 약함, codegen 미도입 시)
- 깊은 중첩 네비게이션은 학습 곡선 있음

**대안 기각 사유**

- **auto_route**: typed routes는 매력적이지만 추가 codegen + 학습 비용. DailyPiece 화면 수가 적어 ROI 낮음.
- **Navigator 1.0**: 딥링크/redirect 가드를 직접 구현해야 함. 미래의 웹 빌드/푸시 알림을 막음.

## Implementation notes

- `pubspec.yaml` 추가: `go_router`.
- 라우터 정의는 `lib/app/router.dart` (또는 `lib/router/app_router.dart`)에 단일 진입.
- 라우터 자체를 Riverpod Provider로 노출 — `MaterialApp.router(routerConfig: ref.watch(appRouterProvider))`.
- 인증 redirect: `redirect: (ctx, state) => ref.read(authProvider).isSignedIn ? null : '/sign-in'`.
- 라우트 path는 도메인 명사로: `/today`, `/collection`, `/collection/:pieceId`, `/settings`, `/sign-in`.
- BottomNav는 `StatefulShellRoute.indexedStack`으로 구현 — 3 브랜치(Today / Collection / Settings) 각자 navigator를 보유해 탭 전환 후 복귀 시 sub-route 백스택이 유지된다. `/collection/:pieceId`는 Collection 브랜치 nested route라 detail에서 back 시 그리드로 자연 복귀.
- Auth 화면(`/sign-in`, `/sign-up`)은 shell 밖에 둔다 — 사인인 전엔 바텀바가 의미 없음.
- 딥링크 매니페스트(iOS Universal Links / Android App Links)는 추후 백엔드 결정 시 ADR로 분리.
