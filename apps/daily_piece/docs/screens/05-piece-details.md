---
name: Piece Details
extends: design_system
imports: []
source:
  type: figma
  url: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece
  node_id: "2:412"
  link: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece?node-id=2-412&t=2SsB9yTpe6fjdj7N-4
  spec_basis: screenshot
viewport:
  primary: mobile
  responsive: [mobile]
---

# Screen: Piece Details

## 개요

특정 piece의 상세. 큰 사진 + 캡션 + 작성 일시 카드, 그 아래 Edit/Delete 액션 행, 마지막에 안내 텍스트. 인증된 메인 흐름의 read-first 화면이며 이 화면의 액션 진입으로 04 Edit Piece가 열린다.

---

## 1. Skeleton

```
Page (viewport: mobile)
├── Region: TopBar
│   ├── Slot: backButton
│   │   ↳ component: design_system/docs/components/09-icon-button.md
│   ├── Slot: title
│   │   ↳ component: design_system/docs/components/16-label.md
│   └── Slot: overflowMenu
│       ↳ component: design_system/docs/components/09-icon-button.md
├── Region: Content (vertical scroll, 24 padding)
│   ├── Section: PieceCard                  # rounded-16 elevated card
│   │   ├── Slot: photo
│   │   │   ↳ <Custom name="DailyPiecePhoto">
│   │   ├── Slot: caption
│   │   │   ↳ component: design_system/docs/components/16-label.md
│   │   └── Section: MetaRow                # date + time
│   │       ├── Slot: dateChip
│   │       │   ↳ component: design_system/docs/components/16-label.md  (icon + text 합성)
│   │       └── Slot: timeChip
│   │           ↳ component: design_system/docs/components/16-label.md
│   ├── Section: EditAction                 # rounded-12 row
│   │   ↳ component: design_system/docs/components/24-list-item.md (variant: with-leading-tile)
│   ├── Section: DeleteAction               # rounded-12 row, negative tint
│   │   ↳ component: design_system/docs/components/24-list-item.md (variant: with-leading-tile)
│   └── Section: InfoNote                   # icon + body text
│       ├── Slot: infoIcon
│       └── Slot: noteText
│           ↳ component: design_system/docs/components/16-label.md
└── Region: Footer (BottomNav)
    ↳ component: design_system/docs/components/23-bottom-navigation.md
```

---

## 2. Bindings

### Region: TopBar

- height: 56
- background: `color/background/normal/normal`
- bottom-border: `1px color/line/normal/neutral`
- layout: 좌(back) / 중(title) / 우(menu)

**Slot: backButton**

- icon: `chevron-left` (또는 `arrow-left`)
- aria-label: `뒤로`
- on-tap: `screen-flow → pop`

**Slot: title**

- text-variant: `text/heading2`
- color: `color/label/strong`
- content: `Piece Details`
- align: center

**Slot: overflowMenu**

- icon: `more-vertical` (3-dot)
- aria-label: `더 보기`
- on-tap: `screen-flow → action sheet (TBD: Share / Report 등 후속 결정)`

### Region: Content

- container-padding: `spacing/24`
- section-gap: `spacing/16`

#### Section: PieceCard

- container: rounded-16 card, background `color/background/elevated/normal`, border `1px color/line/normal/neutral`
- padding: `spacing/16`

**Slot: photo**

- ref: `<Custom name="DailyPiecePhoto">`
- aspect-ratio: 4:5 또는 3:4 (스크린샷 기준 약간 세로 길어 보임 — 1:1보다 큼)
- shape: `radius/md` 안쪽 모서리
- src: `{{piece.imageUrl}}`
- alt: `{{piece.caption}}`

**Slot: caption**

- text-variant: `text/heading3`
- color: `color/label/strong`
- content: `{{piece.caption}}`
- max-lines: 무제한 (스크롤 컨테이너 안)

#### Section: MetaRow

- layout: `space-between` (좌측 date / 우측 time)
- top-padding: `spacing/12`

**Slot: dateChip**

- leading-icon: `calendar` (16, `color/label/alternative`)
- text-variant: `text/body2`
- color: `color/label/alternative`
- content: `{{piece.date | format("MMMM d, yyyy")}}` (예: "March 10, 2026")
- gap: `spacing/8`

**Slot: timeChip**

- leading-icon: `clock` (16, `color/label/alternative`)
- text-variant: `text/body2`
- color: `color/label/alternative`
- content: `{{piece.createdAt | format("h:mm a")}}` (예: "6:42 PM")

#### Section: EditAction

- ref: `24-list-item.md` variant `with-leading-tile`
- container: rounded-12, background `color/background/elevated/normal`, border `1px color/line/normal/neutral`
- on-tap: `screen-flow → 04-edit-piece.md (pieceId: piece.id)`

ListItem 슬롯:

- **leading**: 40×40 `radius/md` tile, bg `color/primary/subtle`, inner edit/pencil glyph 18, color `color/primary/normal`
- **title**: `Edit Piece` — `text/heading3`, `color/label/strong`
- **caption**: (없음)
- **trailing**: chevron-right (`color/label/alternative`)

#### Section: DeleteAction

- ref: `24-list-item.md` variant `with-leading-tile`
- container: rounded-12, background `color/background/elevated/normal`, border `1px color/line/normal/neutral`
- on-tap: `screen-flow → confirm: 18-alert.md (variant=negative)` → 확인 시 `api: DELETE /pieces/{id}` → `pop → invalidate(myPiecesFeed)`

ListItem 슬롯:

- **leading**: 40×40 `radius/md` tile, bg `color/status/negative-subtle`, inner trash glyph 18, color `color/status/negative`
- **title**: `Delete Piece` — `text/heading3`, **color: `color/status/negative`**
- **caption**: (없음)
- **trailing**: chevron-right (`color/label/alternative`)

#### Section: InfoNote

- top-padding: `spacing/16`
- top-border: `1px color/line/normal/neutral` (선택)
- layout: 가로 — 아이콘 + 텍스트, gap `spacing/8`, align top

**Slot: infoIcon**

- icon: `info` (16, `color/label/alternative`)

**Slot: noteText**

- text-variant: `text/caption1`
- color: `color/label/alternative`
- content: `This piece was captured on {{piece.date | format("MMMM d, yyyy")}}. You can edit the caption or delete this entry at any time.`

### Region: Footer (BottomNav)

- 4-탭, 활성: **My Pieces** (이 화면이 My Pieces 흐름의 자식이라)

---

## 3. Intent

### 사용자 의도

저장한 piece를 큰 사진 + 풀 캡션으로 다시 만나고, 필요한 경우 edit / delete 액션 트리거.

### 진입 / 이탈

- **진입**: 06 My Pieces 카드 탭 / 03 Calendar의 piece 있는 날 탭 / 02 Search 결과 탭
- **이탈**:
  - back → 직전 화면
  - Edit Piece → 04-edit-piece.md
  - Delete Piece → confirm → 삭제 후 직전 화면 pop
  - 다른 BottomNav 탭

### 핵심 액션 우선순위

1. 콘텐츠 읽기 (사진 + 캡션 + 일시)
2. Edit Piece
3. Delete Piece (위험, Alert 보호)

### 접근성

- **포커스 순서**: backButton → title → overflowMenu → 카드(사진+캡션+meta) → Edit Piece → Delete Piece → InfoNote → BottomNav
- **사진 alt**: caption + date
- **Delete 보호**: Alert outsideClick 닫기 비활성

### Reactive Behavior

- **로딩**: 카드 영역에 Skeleton(rectangle photo + 3 text lines)
- **삭제 중**: Delete Action busy 상태 + 다이얼로그 버튼 loading
- **존재하지 않는 piece (404 / RLS)**: FallbackView "Piece를 찾을 수 없어요" + 컬렉션 복귀 버튼

---

## 검증 체크리스트

- [x] frontmatter / 위계
- [x] PieceCard rounded card 컨테이너
- [x] MetaRow의 date/time icon + text 합성
- [x] Edit/Delete 모두 ListItem with-leading-tile (Button 아님)
- [x] InfoNote 명시
- [ ] 24-list-item에 caption 없는 variant 정의 (이미 있을 가능성)
