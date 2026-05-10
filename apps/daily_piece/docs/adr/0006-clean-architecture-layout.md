# ADR 0006 — Clean Architecture Layout

- Status: Accepted
- Date: 2026-05-10
- Scope: `apps/daily_piece`

## Context

초기 스켈레톤은 features-first co-location이었다 (`lib/features/<feature>/` 안에 widget + provider + repository를 같이 두는 구조). Today 흐름이 한 피처라 잘 맞았지만, Collection / PieceDetail이 같은 `pieces` 애그리거트를 다루기 시작하면서 한계가 드러났다:

- **PieceRepository를 누가 소유하는가?** Today에 두면 Collection이 cross-feature import를 해야 하고, 피처별로 쪼개면 같은 Supabase 호출을 중복 작성하게 된다.
- **레이어 경계 모호**. `today_page.dart` 안에서 `Supabase.instance.client`로 직접 들어가는 길이 막혀 있지 않아 시간이 지나면 표면이 새어나간다.
- **테스트 가능성**. 위젯 테스트에서 fake repository로 갈아끼우려면 인터페이스 경계가 필요한데, 구체 클래스 직접 의존 시 mock-friendly 하지 않다.

## Decision

피처와 `core/` 모두 **Clean Architecture 3-레이어**(`data` / `domain` / `presentation`)로 분리하고, 그 아래는 역할별 디렉토리(`entities` / `repositories` / `exceptions` / `datasources` / `pages` / `widgets` / `providers`)로 한 단계 더 나눈다.

```
lib/
├── core/
│   ├── domain/
│   │   ├── entities/         # framework-free 도메인 객체
│   │   ├── repositories/     # abstract Port
│   │   └── exceptions/       # 도메인 예외
│   ├── data/
│   │   ├── datasources/      # Supabase 등 외부 호출 thin pipe
│   │   └── repositories/     # *Impl + Riverpod provider, 매핑/에러 변환
│   └── ...
└── features/<feature>/
    ├── data/                 # 피처 전용 데이터 (e.g. media 전처리)
    ├── domain/               # 피처 전용 도메인 (필요 시)
    └── presentation/
        ├── pages/
        ├── widgets/
        └── providers/
```

**여러 피처가 공유하는 도메인(현재 `Piece` 애그리거트)은 `core/`로 끌어올린다.** 피처 안에 두면 cross-feature import 또는 중복 구현을 강요하게 된다. 피처 전용 데이터(예: Today의 `media_pipeline.dart`)만 `features/<feature>/data/`에 둔다.

**프레젠테이션 → 도메인 인터페이스 의존**(DIP). 구현 클래스는 `core/data/`에서 Riverpod provider로 노출하되, 노출되는 provider 타입은 abstract repository로 선언한다 — 위젯/프로바이더는 인터페이스만 본다.

## Consequences

**Pros**
- 피처 추가가 결정 트리 따라 기계적: 도메인 메서드는 `core/domain/repositories/`에, 구현은 `core/data/repositories/`에, 페이지는 `features/<f>/presentation/pages/`에.
- 위젯 테스트에서 `pieceRepositoryProvider.overrideWith(...)` 한 줄로 fake 주입.
- Supabase 의존이 `core/data/`에 격리 — 백엔드 교체 시 영향 범위가 명확.
- 매핑 로직(row → entity)이 데이터 레이어에만 존재 → 도메인은 framework-free 유지.

**Cons**
- 파일 수와 디렉토리 깊이 증가. 1인 페이스에서 약간의 ceremony.
- 상호참조 경로가 길어짐 (`../../../../core/...`). 도메인이 안정되면 barrel export로 완화 가능.

## What we deliberately did NOT add

- **UseCase 클래스**. Riverpod provider가 이미 use case 역할을 한다. trivial wrapper UseCase는 없는 것이 낫고, 도메인 규칙이 여러 provider에 흩어지기 시작할 때 재평가한다.
- **데이터 레이어 모델(DTO)**. 현재 Supabase row shape이 도메인 형태와 거의 1:1이라 `_mapRow`만으로 충분. row가 도메인과 의미적으로 달라지면 그때 `data/models/PieceDto`로 분리한다.
- **AuthRepository abstract 분리**. `auth/` 피처는 아직 flat 구조. `signIn`/`signUp`이 두 화면에서만 쓰이는 단발성 호출이라 우선순위 낮음. 공유 지점이 늘면 같은 패턴으로 분리한다.

## Implementation notes

- 기존 `lib/core/domain/piece.dart`는 `lib/core/domain/entities/piece.dart`로 이동. `Piece.fromJson`은 제거하고 매핑은 `core/data/repositories/piece_repository_impl.dart`의 `_mapRow`가 담당.
- `pieceRepositoryProvider`는 `core/data/repositories/piece_repository_impl.dart`에 선언. 반환 타입은 abstract `PieceRepository`.
- `PieceRemoteDataSource`는 raw Map / driver 예외만 반환. `PostgrestException 23505` → `PieceAlreadyExistsToday` 변환은 repository 레이어에서.
- 신규 피처는 `presentation/{pages,widgets,providers}/` 패턴으로 시작하고, 피처 전용 데이터가 생기면 `data/`를, 피처 한정 도메인 규칙이 생기면 `domain/`을 채운다.

## Related

- ADR 0001 — Riverpod (provider 위치 변경: feature root → `presentation/providers/`).
- ADR 0003 — Supabase backend (의존이 `core/data/datasources/`로 격리됨).
