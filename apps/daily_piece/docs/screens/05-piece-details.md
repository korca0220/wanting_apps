---
name: Piece Details
extends: design_system
imports: []
source:
  type: figma
  url: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece
  node_id: "2:412"
viewport:
  primary: mobile
  responsive: [mobile]
---

# Screen: Piece Details

## 개요
단일 daily piece의 상세 화면. 큰 사진 + 캡션 + 날짜·시각 + Edit/Delete 액션 + 안내 메시지. 일기처럼 한 항목에 집중하는 detail view.

> ⚠️ sparse metadata 기반 시범 명세. 화면 height 1164으로 다른 화면보다 길어 스크롤 가능.

---

## 1. Skeleton

```
Page (viewport: mobile, 375×1164, 스크롤)
├── Region: Header
│   └── Section: TopBar
│       ├── Slot: backButton
│       │   ↳ component: design_system/docs/components/09-icon-button.md
│       └── Slot: title
│           ↳ component: design_system/docs/components/16-label.md
├── Region: Content
│   ├── Section: PhotoHero
│   │   └── Slot: photo
│   │       ↳ <Custom name="DailyPiecePhoto">
│   ├── Section: Meta
│   │   ├── Slot: date
│   │   │   ↳ component: design_system/docs/components/16-label.md
│   │   └── Slot: time
│   │       ↳ component: design_system/docs/components/16-label.md
│   ├── Section: CaptionBlock
│   │   └── Slot: caption
│   │       ↳ component: design_system/docs/components/16-label.md
│   ├── Section: ActionRow
│   │   ├── Slot: editButton
│   │   │   ↳ component: design_system/docs/components/01-button.md
│   │   └── Slot: deleteButton
│   │       ↳ component: design_system/docs/components/01-button.md
│   └── Section: Note
│       └── Slot: noteText
│           ↳ component: design_system/docs/components/16-label.md
└── Region: Footer (BottomNav)
    ↳ component: design_system/docs/components/23-bottom-navigation.md
    └── (반복) items × 4 (slot: items)
```

---

## 2. Bindings

### Region: Header

#### Section: TopBar

**Slot: backButton**
- ref: `design_system/docs/components/09-icon-button.md`
- variant: `normal`
- size: `medium`
- icon: `chevron-left`
- aria-label: `뒤로`
- on-tap: `screen-flow back`

**Slot: title**
- text-variant: `text/heading2`
- color: `color/label/normal`
- content: `Piece Details`

### Region: Content

#### Layout 토큰
- section-gap: `spacing/24`

#### Section: PhotoHero

**Slot: photo**
- ref: `<Custom name="DailyPiecePhoto">`
- src: `{{piece.imageUrl}}`
- alt: `{{piece.caption}}`
- aspect: `1:1` (검수 필요)
- radius: `radius/none` (full-bleed) 또는 `radius/lg` (인셋)

#### Section: Meta

#### Layout 토큰 (Meta)
- container-padding-x: `spacing/16`
- gap: `spacing/4`

**Slot: date**
- text-variant: `text/headline2`
- color: `color/label/normal`
- content: `{{piece.date | format("MMMM d, yyyy")}}` (예: "March 10, 2026")

**Slot: time**
- text-variant: `text/body2`
- color: `color/label/alternative`
- content: `{{piece.createdAt | format("h:mm a")}}` (예: "6:42 PM")

#### Section: CaptionBlock

**Slot: caption**
- text-variant: `text/body1-reading`
- color: `color/label/normal`
- content: `{{piece.caption}}` (긴 텍스트 가능 — body1-reading variant로 가독성)

#### Section: ActionRow

#### Layout 토큰
- container-padding-x: `spacing/16`
- gap: `spacing/12`

**Slot: editButton**
- ref: `design_system/docs/components/01-button.md`
- variant: `outlined`
- color: `primary`
- size: `medium`
- fullWidth: `true`
- content: `Edit Piece`
- leadingContent: `icon: edit-pencil`
- on-tap: `screen-flow → 04-edit-piece.md (pieceId: piece.id)`

**Slot: deleteButton**
- ref: `design_system/docs/components/01-button.md`
- variant: `outlined`
- color: `assistive`
- size: `medium`
- fullWidth: `true`
- content: `Delete Piece`
- leadingContent: `icon: trash`
- on-tap: `screen-flow → confirm: components/18-alert.md (variant=negative, body="이 piece를 영구 삭제할까요?") → API DELETE /pieces/{id} → snackbar success → screen-flow back to my-pieces`

#### Section: Note

#### Layout 토큰
- container-padding-x: `spacing/16`
- bg-color: `color/fill/alternative`
- padding: `spacing/12`
- radius: `radius/md`

**Slot: noteText**
- text-variant: `text/caption1`
- color: `color/label/alternative`
- content: `This piece was captured on {{piece.date | format("MMMM d, yyyy")}}. You can edit the caption or delete this entry at any time.`

### Region: Footer (BottomNav)

(01-profile.md와 동일 — 현재 활성 없음, My Pieces가 표시되어야 자연스러움)

---

## 3. Intent

### 사용자 의도
한 piece에 집중해 사진과 캡션을 음미하고, 필요시 편집하거나 삭제한다. 일기 회상 시나리오.

### 진입 / 이탈
- **진입**: My Pieces / Calendar에서 카드/날짜 탭
- **이탈**: BackButton → 직전 화면 / Edit → 04-edit-piece.md / Delete → confirm Alert → 삭제 후 02-my-pieces.md

### 핵심 액션 우선순위
1. 콘텐츠 음미 (정적 — 인터랙션 없음)
2. **Edit Piece** (수정)
3. **Delete Piece** (위험 — Alert로 보호)

### 접근성
- **포커스 순서**: backButton → title → (PhotoHero는 alt만, 포커스 X) → date → time → caption → Edit → Delete → BottomNav
- **PhotoHero alt**: 캡션 그대로 사용 — 시각 장애인이 piece 내용을 텍스트로 인지
- **Delete 보호**: Alert 다이얼로그 outsideClick 닫기 비활성, focus는 Cancel 버튼에 기본
- **터치 타겟**: 모든 버튼 ≥ 44px

### Reactive Behavior
- **로딩**: PhotoHero / Meta / Caption 영역 Skeleton 표시
- **삭제 중**: deleteButton loading=true
- **에러**: Snackbar variant=error
- **사진 로드 실패**: PhotoHero 영역에 placeholder + alt 텍스트 표시

---

## 검증 체크리스트
- [x] 5단계 위계 / Slot 종결
- [x] Bindings Semantic
- [x] Delete 위험 액션을 Alert(18-alert.md)로 보호
- [x] body1-reading variant로 긴 캡션 가독성 보장
