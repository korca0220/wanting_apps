---
name: Home
extends: design_system
imports: []
source:
  type: figma
  url: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece
  node_id: "2:513 (혼합 frame)"
viewport:
  primary: mobile
  responsive: [mobile]
---

# Screen: Home

## 개요
앱 진입 직후 보이는 환영 페이지. 큰 DailyPiece 로고/타이틀 + 가장 최근 piece의 미니 카드. 사용자가 이미 인증되어 있고 데이터가 있을 때의 첫 화면.

> ⚠️ 본 명세는 sparse metadata에서 추출한 텍스트 기반 시범. 정확한 레이아웃은 추정. node 2:513 frame 안에 여러 sub-screen이 stack되어 있어 명확한 분리는 후속 콜에서 가능.

---

## 1. Skeleton

```
Page (viewport: mobile, 375×840)
├── Region: Hero
│   └── Section: BrandHeader
│       ├── Slot: appLogo
│       │   ↳ <Custom name="AppLogoMark">
│       └── Slot: appName
│           ↳ component: design_system/docs/components/16-label.md
├── Region: Content
│   ├── Section: MonthHeader
│   │   └── Slot: monthLabel
│   │       ↳ component: design_system/docs/components/16-label.md
│   └── Section: LatestPieceCard
│       ↳ component: design_system/docs/components/06-card.md
│           ├── ↳ slot: thumbnail
│           │   ↳ <Custom name="DailyPieceThumbnail">
│           ├── ↳ slot: caption
│           │   ↳ component: design_system/docs/components/16-label.md
│           └── ↳ slot: date
│               ↳ component: design_system/docs/components/16-label.md
└── Region: Footer (BottomNav)
    ↳ component: design_system/docs/components/23-bottom-navigation.md
    └── (반복) items × 4 (slot: items)
```

---

## 2. Bindings

### Region: Hero

#### Layout 토큰
- container-padding: `spacing/24`
- gap: `spacing/12`
- align: `center`

#### Section: BrandHeader

**Slot: appLogo**
- ref: `<Custom name="AppLogoMark">`
- size: `64×64`
- alt: `DailyPiece 로고`

**Slot: appName**
- text-variant: `text/title2`
- color: `color/label/strong`
- content: `DailyPiece`

### Region: Content

#### Layout 토큰
- container-padding: `spacing/16`
- gap: `spacing/16`

#### Section: MonthHeader

**Slot: monthLabel**
- text-variant: `text/headline2`
- color: `color/label/normal`
- content: `{{currentMonth | format("MMMM yyyy")}}` (예: "March 2026")

#### Section: LatestPieceCard

- ref: `design_system/docs/components/06-card.md`
- bindings:
  - thumbnail src: `{{latestPiece.imageUrl}}`
  - caption content: `{{latestPiece.caption}}` (예: "Beautiful sunset over the mountains. Nature always finds a way to amaze me.")
  - caption text-variant: `text/body2`
  - caption color: `color/label/normal`
  - date content: `{{latestPiece.date | format("MMM d")}}` (예: "Mar 10")
  - date text-variant: `text/caption1`
  - date color: `color/label/alternative`
  - on-tap: `screen-flow → 05-piece-details.md (pieceId: latestPiece.id)`

### Region: Footer (BottomNav)

(01-profile.md와 동일 — 현재 활성: My Pieces 또는 Home 탭)

---

## 3. Intent

### 사용자 의도
앱을 열어 가장 최근 자신의 piece를 즉시 본다. "오늘 또는 가장 가까운 날의 한 조각"에 빠르게 도달하는 게 목적.

### 진입 / 이탈
- **진입**: 앱 시작 (인증된 상태) / Splash 직후
- **이탈**: 카드 탭 → 05-piece-details.md / BottomNav 탭 → 다른 화면

### 핵심 액션 우선순위
1. 카드 탭 (가장 최근 piece 보기)
2. BottomNav 탭으로 다른 화면 진입

### 접근성
- **포커스 순서**: appLogo → appName → monthLabel → LatestPieceCard → BottomNav
- **카드 alt**: caption + date 조합
- **터치 타겟**: 카드 영역 ≥ 44px

### Reactive Behavior
- **로딩**: BrandHeader는 정적 즉시 표시, LatestPieceCard 영역만 Skeleton
- **빈 상태**: piece 0개면 → `<FallbackView>` ("첫 piece를 만들어보세요" + "New Piece 만들기" 버튼 → 07-new-piece.md)
- **에러**: Snackbar variant=error

---

## 검증 체크리스트
- [x] frontmatter / 5단계 위계
- [ ] AppLogoMark는 wanted DS에 없음 — 도메인 자산이라 별도
- [x] Bindings Semantic
- [ ] 본 frame의 sub-screen 분리는 sparse metadata로 어려움 — 후속 sub-tree 콜로 정확도 향상 가능
