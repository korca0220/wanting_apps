# OneLine Day — Screen Specifications

이 디렉토리는 **OneLine Day** 모바일 앱의 화면 명세 모음입니다. 각 `.md` 파일은 framework-neutral한 형식으로 작성하며, 구현 기술보다 사용자 의도·구조·디자인 시스템 바인딩을 먼저 고정합니다.

## 베이스 디자인 시스템

- **Primary**: `design_system` → [`packages/design_system/docs/`](../../../../packages/design_system/docs/)
- **Imports**: 없음. 단일 DS만 사용합니다.

## 스크린 인덱스

- [00-INDEX.md](00-INDEX.md) — 전체 화면 흐름과 MVP 범위
- [01-today.md](01-today.md) — 오늘 한 줄 작성
- [02-calendar.md](02-calendar.md) — 월간 기록 탐색
- [03-entries.md](03-entries.md) — 전체 기록 목록
- [04-search.md](04-search.md) — 텍스트 검색
- [05-settings.md](05-settings.md) — 설정과 앱 정보
- [06-edit-entry.md](06-edit-entry.md) — 날짜별 작성/수정 시트

## 출처

- **종류**: product planning
- **작성 시점**: 2026-05-17
- **기준 앱**: DailyPiece의 문서화 우선 워크플로우와 화면 패턴

## 새 스크린 추가

1. `TEMPLATE.md`를 복사해 `NN-screen-name.md`로 작성
2. frontmatter의 `extends: design_system` 명시
3. Skeleton → Bindings → Intent 순서로 채움
4. `00-INDEX.md`에 항목 추가
5. 스크린 검증 스크립트가 사용 가능한 환경에서 검증
