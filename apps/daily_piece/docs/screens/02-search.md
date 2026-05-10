---
name: Search
extends: design_system
imports: []
source:
  type: figma
  url: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece
  node_id: "2:126"
  link: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece?node-id=2-126&t=2SsB9yTpe6fjdj7N-4
  spec_basis: screenshot
viewport:
  primary: mobile
  responsive: [mobile]
---

# Screen: Search

## 개요

BottomNav의 **Search 탭**. 상단 풀폭 검색 입력(돋보기 leading) + 가로 스크롤 월 필터 칩(All / January / February / March …) + 결과 카드 리스트(가로 레이아웃 — 정사각 썸네일 + 캡션 + 날짜). 사용자가 자신의 piece를 캡션 텍스트나 월 범위로 빠르게 찾는 화면.

06 My Pieces와의 차이:
- **검색 입력 + 월 칩**으로 능동 필터링
- 카드가 가로 레이아웃 (정사각 썸네일 좌, 텍스트 우)
- FAB 없음

---

## 1. Skeleton

```
Page (viewport: mobile)
├── Region: Header                          # 검색 + 필터, 24 padding
│   ├── Section: SearchBar
│   │   └── Slot: searchInput
│   │       ↳ component: design_system/docs/components/02-text-field.md
│   └── Section: MonthFilter                # 가로 스크롤 칩
│       └── (반복) Slot: chip × N
│           ↳ component: design_system/docs/components/04-chip.md
├── Region: Content (vertical scroll, 24 padding)
│   └── (반복) Section: ResultCard × N
│       ↳ component: design_system/docs/components/06-card.md
│           ├── Slot: thumbnail
│           │   ↳ <Custom name="DailyPieceThumbnail">
│           ├── Slot: caption
│           │   ↳ component: design_system/docs/components/16-label.md
│           └── Slot: date
│               ↳ component: design_system/docs/components/16-label.md
└── Region: Footer (BottomNav)
    ↳ component: design_system/docs/components/23-bottom-navigation.md
```

---

## 2. Bindings

### Region: Header

- container-padding: `spacing/24` (horizontal)
- top-padding: `spacing/16`
- gap: `spacing/16` (SearchBar ↔ MonthFilter)

#### Section: SearchBar

**Slot: searchInput**

- ref: `02-text-field.md`
- variant: `filled` (배경 채움 형태)
- background: `color/background/elevated/normal`
- border: 없음 (또는 매우 약한)
- shape: `radius/lg` (12~16px)
- height: 48
- leadingIcon: `search` (20, `color/label/alternative`)
- placeholder: `Search captions...`
- placeholder-color: `color/label/alternative`
- value: `{{state.query}}`
- on-change: `state: query = $value → debounce(300ms) → filter(pieces)`
- on-clear: 입력값 있을 때 trailing X (component clearable=true) 노출 (옵션)

#### Section: MonthFilter

- 가로 스크롤 (overflow-x), gap `spacing/8`
- 칩 데이터:
  ```
  [
    { label: "All",      value: "all" },
    { label: "January",  value: "2026-01" },
    { label: "February", value: "2026-02" },
    { label: "March",    value: "2026-03" },
    ...    // 사용자의 piece가 존재하는 월 동적 추가
  ]
  ```

**Slot: chip** (반복)

- ref: `04-chip.md`
- variant:
  - 활성: `solid`, color `primary`, 배경 `color/primary/normal`, 텍스트 `color/static/white`
  - 비활성: `outlined`, border `color/line/normal/neutral`, 텍스트 `color/label/normal`
- size: `medium`
- content: `{{item.label}}`
- selected: `{{item.value === state.selectedMonth}}`
- on-tap: `state: selectedMonth = item.value → filter(pieces)`

### Region: Content

- container-padding: `spacing/24` (horizontal)
- card-gap: `spacing/12`
- top-padding: `spacing/16`

#### (반복) Section: ResultCard

- ref: `06-card.md`
- 형태: 가로 레이아웃 (썸네일 좌, 텍스트 우)
- container: rounded-12 card, background `color/background/elevated/normal`, border `1px color/line/normal/neutral`
- padding: `spacing/12`
- gap: `spacing/12`
- on-tap: `screen-flow → 05-piece-details.md (pieceId: piece.id)`

**Slot: thumbnail**

- ref: `<Custom name="DailyPieceThumbnail">`
- size: 80×80 (정사각)
- shape: `radius/md`
- src: `{{piece.imageUrl}}`
- alt: `{{piece.caption}}`

**Slot: caption**

- text-variant: `text/heading3`
- color: `color/label/strong`
- content: `{{piece.caption}}`
- max-lines: 2 (overflow ellipsis)

**Slot: date**

- text-variant: `text/caption1`
- color: `color/label/alternative`
- content: `{{piece.date | format("MMM d, yyyy")}}` (예: "Mar 1, 2026")
- 위치: caption 아래

데이터 예시:

```
[
  { id: 1, caption: "Beautiful sunset over the mountains today", date: "2026-03-01" },
  { id: 2, caption: "Morning coffee with a view",                date: "2026-03-03" },
  { id: 3, caption: "Peaceful walk through the forest trail",    date: "2026-03-05" },
  { id: 4, caption: "Golden hour at the beach",                  date: "2026-03-07" },
]
```

### Region: Footer (BottomNav)

- 4-탭, 활성: **Search** (`color/primary/normal`)

---

## 3. Intent

### 사용자 의도

자신의 piece를 캡션 텍스트나 시점 범위(월)로 빠르게 좁혀 찾고, 결과 탭으로 상세 진입.

### 진입 / 이탈

- **진입**: BottomNav의 Search 탭
- **이탈**:
  - 카드 탭 → 05 Piece Details
  - 다른 BottomNav 탭

### 핵심 액션 우선순위

1. 검색 입력 (SearchBar)
2. 월 필터 칩
3. 결과 카드 탭

### 접근성

- **포커스 순서**: searchInput → 첫 chip → 마지막 chip → 첫 result → … → BottomNav
- **검색 결과 announce**: aria-live region으로 결과 수 알림 ("4 results", "0 results")
- **터치 타겟**: chip ≥ 36 (medium), card 행 전체
- **키보드**: searchInput Enter는 키보드 dismiss + scroll-to-top

### Reactive Behavior

- **검색 중**: searchInput trailing에 spinner (텍스트 입력 후 debounce 동안)
- **빈 상태 (전체)**: `<FallbackView>` "아직 저장된 piece가 없어요" + CTA "오늘의 첫 piece 만들기"
- **검색 결과 없음**: `<FallbackView>` "'{query}'에 대한 결과가 없어요"
- **에러**: Snackbar variant=error + 재시도

---

## 검증 체크리스트

- [x] frontmatter / 위계
- [x] SearchBar filled variant + leading 돋보기
- [x] 월 필터 가로 스크롤 + 활성/비활성 분기
- [x] ResultCard 가로 레이아웃 (썸네일 + 캡션 + 날짜)
- [x] BottomNav 활성 = Search
- [ ] 04-chip의 solid/outlined 분기 명세 확인
- [ ] 02-text-field에 filled variant + leadingIcon 슬롯 확인

---

## 구현 갭

| 항목       | 명세                                          | 현 구현 |
| ---------- | --------------------------------------------- | ------- |
| 화면 자체  | Search 탭 — 검색 + 월 칩 + 결과 리스트         | 없음    |
| 라우트     | `/search`                                     | 미정    |
| 데이터     | piece 텍스트 검색 + 월 필터                    | 미구현  |
