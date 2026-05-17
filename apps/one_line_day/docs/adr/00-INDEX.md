# OneLine Day — ADR Index

- Scope: `apps/one_line_day`
- Last updated: 2026-05-17

## DailyPiece ADR 재사용 기준

### 그대로 재사용

- ADR 템플릿 구조 (Context / Decision / Consequences / Implementation notes)
- Riverpod 기반 상태관리 방향
- go_router 기반 라우팅 방향
- Clean Architecture 디렉토리 규칙

### 수정 후 재사용

- 데이터 계층 구현 세부: Supabase 중심 설명 제거, 로컬 저장소 기준으로 치환
- 화면/도메인 예시: DailyPiece 용어를 OneLine Day(`Entry`)로 치환

### 제외

- Backend(Supabase) 전제 ADR
- Media 업로드/압축 정책 ADR

## ADR 상태

| ADR | Title | Status |
|---|---|---|
| 0001 | State Management: Riverpod | Accepted |
| 0002 | Routing: go_router | Accepted |
| 0003 | Local Persistence: Hive CE | Accepted |
| 0004 | Clean Architecture Layout | Accepted |
