---
name: Search
extends: design_system
imports: []
source:
  type: figma
  url: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece
  node_id: "2:126"
  link: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece?node-id=2-126&t=2SsB9yTpe6fjdj7N-4
viewport:
  primary: mobile
  responsive: [mobile]
---

# Screen: My Pieces

## 개요

사용자의 일별 한 조각(daily piece) 콘텐츠를 시간순으로 보여주는 메인 피드. 상단에 검색 입력 + 월별 필터 칩, 본문에 콘텐츠 카드 리스트, 하단 BottomNav. 앱의 첫 진입 화면.

> ⚠️ sparse metadata 기반 시범 명세.

---

## 1. Skeleton

```
Page (viewport: mobile, 375×840)
├── Region: Header
│   ├── Section: SearchBar
│   │   └── Slot: searchInput
│   │       ↳ component: design_system/docs/components/02-text-field.md
│   └── Section: MonthFilter
│       └── (반복) Item × N
│           ↳ component: design_system/docs/components/04-chip.md
├── Region: Content (스크롤 가능)
│   └── (반복) Card × N
│       ↳ component: design_system/docs/components/06-card.md
│           ├── ↳ slot: thumbnail
│           │   ↳ <Custom name="DailyPieceThumbnail">
│           ├── ↳ slot: title
│           │   ↳ component: design_system/docs/components/16-label.md
│           └── ↳ slot: caption
│               ↳ component: design_system/docs/components/16-label.md
└── Region: Footer (BottomNav)
    ↳ component: design_system/docs/components/23-bottom-navigation.md
    └── (반복) items × 4 (slot: items)
```

---

## 2. Bindings

### Region: Header

#### Layout 토큰

- container-padding: `spacing/16`
- gap: `spacing/12`

#### Section: SearchBar

**Slot: searchInput**

- ref: `design_system/docs/components/02-text-field.md`
- placeholder: `Search captions...`
- leadingContent: `icon: search`
- on-change: `state: query = $value → filter(pieces)`

#### Section: MonthFilter

**Slot: filterChips** (반복: months)

- ref: `design_system/docs/components/04-chip.md`
- variant: `solid`
- size: `medium`
- bindings (per item):
  - content: `{{item.label}}` (예: All / January / February / March)
  - active: `{{item.value === state.selectedMonth}}`
  - on-tap: `state: selectedMonth = item.value → filter(pieces)`

데이터:

```
[
  { label: All,      value: "all" },
  { label: January,  value: "2026-01" },
  { label: February, value: "2026-02" },
  { label: March,    value: "2026-03" },
]
```

### Region: Content

#### Layout 토큰

- container-padding: `spacing/16`
- card-gap: `spacing/12`

#### (반복) Card × N

- ref: `design_system/docs/components/06-card.md`
- bindings (per piece):
  - thumbnail src: `{{piece.imageUrl}}`
  - title content: `{{piece.caption}}` (예: "Beautiful sunset over the mountains today")
  - title text-variant: `text/body1`
  - title color: `color/label/normal`
  - caption content: `{{piece.date | format("MMM d, yyyy")}}` (예: "Mar 1, 2026")
  - caption text-variant: `text/caption1`
  - caption color: `color/label/alternative`
  - on-tap: `screen-flow → 05-piece-details.md (pieceId: piece.id)`

데이터 예시:

```
[
  { id: 1, caption: "Beautiful sunset over the mountains today", date: "2026-03-01", imageUrl: "..." },
  { id: 2, caption: "Morning coffee with a view",                date: "2026-03-03", imageUrl: "..." },
  { id: 3, caption: "Peaceful walk through the forest trail",   date: "2026-03-05", imageUrl: "..." },
  { id: 4, caption: "Golden hour at the beach",                  date: "2026-03-07", imageUrl: "..." },
]
```

### Region: Footer (BottomNav, 4탭)

(01-profile.md와 동일 구조 — 현재 활성: My Pieces)

---

## 3. Intent

### 사용자 의도

사용자는 자신이 그동안 기록한 daily piece들을 빠르게 훑고, 특정 항목을 탭해 상세를 보거나 텍스트/월로 빠르게 필터링한다.

### 진입 / 이탈

- **진입**: 앱 시작 시 첫 화면 / BottomNav의 My Pieces 탭
- **이탈**: 카드 탭 → Piece Details / SearchBar 입력 → 결과 필터링 (현재 화면 유지) / 월 칩 → 필터링 / BottomNav 탭

### 핵심 액션 우선순위

1. 카드 탭 (콘텐츠 상세 진입)
2. 검색 (캡션 텍스트 검색)
3. 월별 필터 (시간 범위 좁히기)

### 접근성

- **포커스 순서**: SearchBar → 첫 month chip → ... → 마지막 chip → 첫 card → ... → BottomNav 4 items
- **스크린리더 의도**: "내 조각들. 검색 입력. 월 필터. 카드 N개." 위계대로
- **터치 타겟**: 카드 행 전체 ≥ 44px 높이. chip 크기 medium 권장.
- **카드 alt**: 썸네일은 `alt: caption + date`로 의미 부여.

### Reactive Behavior

- **로딩**: 카드 영역에 Skeleton(rectangle thumbnail + 2 text lines) × 4 표시
- **빈 상태**: `<FallbackView>` (caption: "아직 저장된 조각이 없어요" + 액션 버튼: "첫 Piece 만들기" → 07-new-piece.md)
- **검색 결과 없음**: `<FallbackView>` ("'{query}'에 대한 결과 없음")
- **에러**: Snackbar variant=error, 재시도 버튼

---

## 검증 체크리스트

- [x] frontmatter / 5단계 위계 / Slot→Component 종결 / 토큰 Semantic 사용
- [ ] 일부 영역(SearchBar의 leadingContent icon)은 wanted 아이콘 시스템에 매핑 필요

## Figma

https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece?node-id=2-513&t=2SsB9yTpe6fjdj7N-4
