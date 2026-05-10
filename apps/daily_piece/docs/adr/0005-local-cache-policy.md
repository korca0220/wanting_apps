# ADR 0005 — Local Cache Policy

- Status: Accepted
- Date: 2026-05-10
- Scope: `apps/daily_piece`

## Context

ADR 0003에서 백엔드(Supabase)는 결정했지만, 클라이언트 측 캐시·오프라인 정책은 1~4 화면을 실제로 돌려본 뒤 결정하기로 미뤘다. 5월 sweep에서 관찰된 실제 통증은 단 하나:

- **컬렉션 / 디테일 / Today에서 같은 사진이 매 화면 진입마다 다시 다운로드된다.**

원인: 매 호출마다 `signedPhotoUrl(path)`가 새 토큰/만료시각을 가진 URL을 발급한다. URL 문자열이 다르면 Flutter `ImageCache`(in-memory, default 100MB / 1000 entries)의 키가 달라져 캐시 미스가 일어나고, `Image.network`는 같은 사진을 다시 GET 한다.

다른 통증은 **현 시점 기준 관찰되지 않았다**:

- 앱 강제종료 → 재실행 시 그리드 깜박임: 미관찰 (사용자가 자주 강제종료하지 않음 + Riverpod feed가 미리 빠르게 채움).
- 비행기모드에서 저장 시도: 미관찰 (사용 시나리오에서 발생 빈도 낮음).
- signed URL 1h 만료 후 깨짐: 미관찰 (한 세션 안에서 1시간 머무는 케이스 드묾).

## Decision

**최소 캐시 — In-memory signed URL cache + Flutter ImageCache 위임.**

1. `core/data/cache/signed_url_cache_provider.dart` — `Map<photoPath, (url, expiresAt)>` 인메모리 캐시. `keepAlive: true`로 라이프타임은 앱 프로세스. TTL 1시간, 만료 5분 전부터 갱신. 동일 path에 대한 동시 요청은 in-flight Future 공유로 디듀프.
2. 모든 사진 표시 화면(`PieceThumbnail`, `PieceView`, `PieceDetailPage._DetailBody`)이 repository 직호출 대신 캐시 provider를 경유.
3. **이미지 바이트 캐시는 Flutter `ImageCache`에 위임**한다 — 같은 URL = 같은 키 = 메모리 히트. 별도 디스크 캐시(`cached_network_image` 등)는 도입하지 않음.

**도입 보류** (관찰된 통증 없음):

- **디스크 캐시** — 앱 재시작 시 그리드 깜박임이 통증으로 보고되면 그때 `cached_network_image` 또는 자체 디스크 캐시 도입. 현재는 ImageCache의 휘발성으로 충분.
- **로컬 DB(drift / Hive / sqflite)** — `pieces` 메타데이터 자체 캐시. Riverpod의 in-memory feed로 한 세션 동안은 충분하고, 30~수백 row 규모에서 재조회 비용도 작음. 오프라인 작성 큐 요구가 생기면 이때 같이 도입.
- **재시도 큐** — 비행기모드 저장 통증 미관찰. 등장 시 오프라인 큐와 함께 결정.

## Consequences

**Pros**
- 통증을 직접 일으키는 신호 — "매번 로딩" — 이 사라진다.
- 추가 의존성 없음. Flutter 기본 ImageCache + 작은 in-memory map.
- 위 캐시는 앱 종료 시 자동 휘발 → 영속 캐시의 stale 문제(파일 수정 후 옛 URL 노출 등)가 원천적으로 없다.
- 캐시 invalidate API 제공 → 향후 edit/delete 흐름에서 객체 교체/삭제 시 한 줄로 무효화.

**Cons**
- **앱 재시작 후 첫 진입은 여전히 다운로드.** 이걸 통증으로 본다면 후속 ADR로 디스크 캐시 결정.
- **메모리 압박 시 ImageCache가 LRU로 떨군다.** 30~수백 사진 규모에서는 경계까지 안 가지만, 사용자가 수천 Piece를 쌓는 시점이 오면 재방문.
- **오프라인 작성/조회 불가** — 의도된 비결정. 첫 컷의 단순함을 우선.

## What we deliberately did NOT add

- **`cached_network_image` 패키지** — 디스크 캐시는 stale URL 문제가 따라오고(서명 토큰이 만료되면 캐시된 응답이 의미 없어짐), 통증이 없는 상태에서 도입할 가치가 없다.
- **로컬 SQL/KV 스토어** — Piece 메타 캐시. 동기화 정책(언제 dirty? offline write 어떻게 머지?) 결정이 필요해 ROI가 낮다.
- **재시도 큐 / outbox 패턴** — 비행기모드 저장이 의미 있는 시나리오로 자리잡으면 그때.

## Implementation notes

- `signedUrlCacheProvider`는 `core/data/cache/`에 위치 — repository를 감싸는 캐시이므로 데이터 레이어. Repository abstract 인터페이스에는 노출하지 않는다(인터페이스는 도메인 의도, 캐시는 인프라 디테일).
- Repository의 `signedPhotoUrl` 자체는 그대로 둔다 — 캐시 무효화 시 fall-through 경로로 사용.
- `Image.network` 그대로 사용. `precacheImage`로 디테일 진입 직전에 워밍업하는 최적화는 통증 보고되면 추가.

## Related

- ADR 0003 — Supabase backend (서명 URL의 출처)
- ADR 0004 — Media client policy (업로드 측 정책 — 캐시와 직교)
