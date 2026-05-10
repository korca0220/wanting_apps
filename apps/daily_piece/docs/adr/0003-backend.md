# ADR 0003 — Backend: Supabase

- Status: Accepted
- Date: 2026-05-10
- Scope: `apps/daily_piece`

## Context

DailyPiece가 백엔드에 요구하는 것:

- **인증**: 이메일/비밀번호 + 비밀번호 재설정. 향후 소셜 로그인 옵션.
- **영속**: Piece (id, user_id, photo_uri, comment, date) + Collection 메타데이터.
- **미디어 스토리지**: 사진 1MB~10MB 단위, 1인 1일 1장 페이스.
- **쿼리**: 사용자별 타임라인(역순), 날짜 범위, 단일 Piece 조회.
- **운영 부담**: 1인 개발/운영. 인프라 학습/유지보수 시간을 도메인 작업으로 돌리고 싶음.

추가 고려:

- 로컬 캐시/오프라인은 별도 결정 (ADR 0005에서 다룸).
- "하루 한 Piece" 도메인 invariant는 DB 레벨에서도 강제하고 싶음 (서버 측 unique constraint).

## Decision

**Supabase** (`supabase_flutter` SDK).

- Postgres + Auth + Storage + Realtime이 단일 콘솔/프로젝트에 묶여 있어 1인 운영에 적합.
- Postgres → SQL/스키마/제약(unique, check, RLS)을 그대로 활용. "하루 한 Piece"는 `UNIQUE (user_id, date)` 제약으로 표현.
- Storage → 사진 업로드/CDN/서명 URL 내장.
- Auth → 이메일+비밀번호 즉시 사용. OAuth provider 추가는 콘솔 설정으로 끝.
- Realtime은 현 시점에 필수 아님(타임라인은 polling/refresh로 충분); 추후 필요 시 켤 수 있음.

## Consequences

**Pros**

- DB/인증/스토리지가 한 SDK로 통합 — 클라이언트 의존성 1개(`supabase_flutter`)로 시작
- Postgres 그대로 → 도메인 invariant를 DB constraint로 강제 (코드 + DB 다층 방어)
- RLS(Row Level Security)로 사용자별 격리를 정책으로 표현 — 클라이언트 권한 누수 방지
- 오픈소스 + self-host 가능 → 베ndor lock-in 리스크 완화
- 무료 티어로 MVP 단계 운영 가능

**Cons**

- Supabase 자체의 운영 가용성에 의존 (관리형이지만 외부 서비스)
- Realtime/Edge Functions 등 고급 기능을 깊게 쓰면 SQL/Deno/PostgREST 학습 필요
- 무료 티어 한도(스토리지 1GB, DB 500MB) 초과 시 유료 전환

**대안 기각 사유**

- **Firebase**: Flutter SDK 성숙하지만 NoSQL 모델링 + 제약 강제(예: 1일 1Piece) 클라이언트로 옮겨감. 쿼리 제약(복합 인덱스, 페이지네이션 awkward)이 타임라인에 비효율.
- **Custom REST/GraphQL**: 1인 운영에 인프라 부담 과대. 도메인 작업 시간을 잠식.
- **Local-only**: 멀티 디바이스 동기화/백업 불가. Personal Archiving 도메인에서 데이터 손실 리스크 큼.

## Implementation notes

### 의존성

```yaml
dependencies:
  supabase_flutter: ^2.8.0
```

### 부트스트랩

`main.dart`에서 `Supabase.initialize(url:, anonKey:)` 호출 → `ProviderScope` → `runApp`. URL/anonKey는 `--dart-define`으로 주입 (코드에 하드코딩 금지).

### 스키마 초벌

```sql
create table pieces (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users(id) on delete cascade,
  photo_path  text not null,                -- storage object key
  comment     varchar(50) not null,
  date        date not null,
  created_at  timestamptz not null default now(),
  unique (user_id, date)                    -- 하루 한 Piece invariant
);

alter table pieces enable row level security;

create policy "owner can read own pieces"
  on pieces for select using (auth.uid() = user_id);
create policy "owner can write own pieces"
  on pieces for insert with check (auth.uid() = user_id);
create policy "owner can update own pieces"
  on pieces for update using (auth.uid() = user_id);
create policy "owner can delete own pieces"
  on pieces for delete using (auth.uid() = user_id);
```

Storage 버킷: `pieces`(private). 업로드 경로는 `{user_id}/{piece_id}.{ext}`.

### Riverpod 통합

- `supabaseProvider`: `Supabase.instance.client` 노출 (Provider).
- `authProvider` (ADR 0001 stub) → `StreamProvider<Session?>`로 교체. `client.auth.onAuthStateChange` 구독.
- `piecesRepositoryProvider`: CRUD + 타임라인 페이지네이션.
- 라우터 redirect 가드(ADR 0002)는 `Session?` null/non-null로 판정.

### 환경 분리

URL/anonKey는 `apps/daily_piece/.env` 파일에 두고 [`envied`](https://pub.dev/packages/envied)로 난독화해 컴파일 — `--dart-define` 사용하지 않음. 워크플로:

```bash
cp apps/daily_piece/.env.example apps/daily_piece/.env
$EDITOR apps/daily_piece/.env       # 값 입력
melos run gen                       # env.g.dart 재생성
melos run run:dp                    # 그냥 flutter run
```

`.env`와 생성된 `*.g.dart`는 모두 gitignore. 진짜 키는 1Password 등에 보관. CI는 빈 `.env`로 컴파일하고, 배포 잡 도입 시 GitHub Secrets에서 실값 주입.

### 후속 ADR

- **ADR 0004 미디어 스토리지** — Supabase Storage 사용은 본 ADR로 결정됨; 0004는 클라이언트 측 캐시/리사이즈/EXIF 처리 정책에 한정.
- **ADR 0005 로컬 영속화** — 오프라인 캐시 (drift / Hive / 단순 메모리 캐시) 결정.
