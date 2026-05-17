# ADR 0003 — Local Persistence: Hive CE

- Status: Accepted
- Date: 2026-05-17
- Scope: `apps/one_line_day`

## Context

OneLine Day v1은 인증/서버 동기화 없이 로컬 저장만 지원한다. 핵심 도메인 제약은 `date` 당 `Entry` 1개이며, 앱 재시작 후에도 기록과 설정이 유지되어야 한다.

요구사항:

- 앱 재실행 후 즉시 읽기 가능한 영속 저장
- 날짜 단위 upsert/조회/삭제가 단순해야 함
- v1 범위에서 마이그레이션/운영 복잡도 최소화

## Decision

**Hive CE**를 기본 로컬 저장소로 사용한다.

- `entries` box: key=`yyyy-MM-dd`, value=`EntryRecord`
- `settings` box: key-value 형태로 테마/메타 저장
- `saveEntry(date)`는 upsert로 동작해 날짜당 1개 불변식을 저장소 레벨에서 강제한다.

## Consequences

**Pros**
- 설정/기록 저장을 빠르게 구현할 수 있다.
- key 설계로 `one line per day` 제약을 단순하게 유지할 수 있다.
- 오프라인 동작이 기본 보장된다.

**Cons**
- 서버 동기화/멀티 디바이스 확장 시 저장소 재설계가 필요할 수 있다.

## Implementation notes

- 저장소 인터페이스는 `core/domain/repositories/entry_repository.dart`에 둔다.
- Hive 구현체는 `core/data/repositories/hive_entry_repository.dart`에 둔다.
- 날짜 key 생성 규칙은 앱 전역에서 단일 유틸로 공유한다.
