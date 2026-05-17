# ADR 0004 — Clean Architecture Layout

- Status: Accepted
- Date: 2026-05-17
- Scope: `apps/one_line_day`

## Context

탭 기반 화면이 늘어나면 화면 코드와 데이터 접근 코드가 섞이기 쉽다. v1은 규모가 작지만, 초기부터 의존 경계를 고정해야 이후 기능(검색 고도화, export/import) 확장 비용이 줄어든다.

## Decision

`core`와 `features` 모두 `data / domain / presentation` 레이어를 사용한다.

```text
lib/
├── core/
│   ├── domain/
│   │   ├── entities/
│   │   ├── repositories/
│   │   └── exceptions/
│   └── data/
│       ├── datasources/
│       └── repositories/
└── features/<feature>/
    ├── data/
    ├── domain/
    └── presentation/
        ├── pages/
        ├── widgets/
        └── providers/
```

## Consequences

**Pros**
- 화면과 저장소 구현의 결합을 줄일 수 있다.
- 테스트에서 저장소 대체가 쉬워진다.
- 이후 저장소 교체(예: Hive → Drift) 영향 범위를 제한할 수 있다.

**Cons**
- 초기 파일 수가 늘어난다.

## Implementation notes

- `presentation` 레이어는 domain repository interface만 의존한다.
- concrete repository provider는 `core/data/repositories/`에서 노출한다.
- 피처 공용 도메인 모델(`Entry`)은 `core/domain/entities/`에 둔다.
