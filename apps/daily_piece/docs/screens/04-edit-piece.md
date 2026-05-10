---
name: Edit Piece
extends: design_system
imports: []
source:
  type: figma
  url: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece
  node_id: "2:367"
  link: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece?node-id=2-367&t=2SsB9yTpe6fjdj7N-4
  spec_basis: screenshot
viewport:
  primary: mobile
  responsive: [mobile]
---

# Screen: Edit Piece

## 개요

기존 piece의 사진/캡션을 수정하는 화면. 모달 형태 — TopBar에 Cancel(좌) / Save(우) 텍스트 버튼이 있고 BottomNav 없음. 사진 위 floating "Replace Photo" 버튼으로 교체, 캡션은 기존 텍스트 prefill된 textarea, 카운터 0/50.

날짜는 수정 불가 (UNIQUE(user_id, date) 도메인 invariant).

---

## 1. Skeleton

```
Page (viewport: mobile, no BottomNav)
├── Region: TopBar
│   ├── Slot: cancelButton                  # 텍스트 버튼
│   │   ↳ component: design_system/docs/components/01-button.md (variant: text)
│   ├── Slot: title
│   │   ↳ component: design_system/docs/components/16-label.md
│   └── Slot: saveButton                    # 텍스트 버튼, primary 컬러
│       ↳ component: design_system/docs/components/01-button.md (variant: text)
├── Region: Content (24 padding, vertical scroll)
│   ├── Section: PhotoBlock
│   │   ├── Section: PhotoHeader
│   │   │   ├── Slot: label
│   │   │   │   ↳ component: design_system/docs/components/16-label.md
│   │   │   └── Slot: requiredBadge
│   │   │       ↳ component: design_system/docs/components/14-content-badge.md
│   │   ├── Section: PhotoFrame             # 사진 + floating action
│   │   │   ├── Slot: photo
│   │   │   │   ↳ <Custom name="DailyPiecePhoto">
│   │   │   └── Slot: replacePhotoButton    # absolute positioned
│   │   │       ↳ component: design_system/docs/components/01-button.md (variant: solid filled-tonal)
│   │   └── Section: InfoNote
│   │       ├── Slot: infoIcon
│   │       └── Slot: noteText
│   │           ↳ component: design_system/docs/components/16-label.md
│   └── Section: CaptionBlock
│       ├── Section: CaptionHeader
│       │   ├── Slot: label
│       │   │   ↳ component: design_system/docs/components/16-label.md
│       │   └── Slot: counter
│       │       ↳ component: design_system/docs/components/16-label.md
│       └── Slot: textarea
│           ↳ component: design_system/docs/components/10-textarea.md
└── (BottomNav 없음)
```

---

## 2. Bindings

### Region: TopBar

- height: 56
- padding-x: `spacing/16`
- background: `color/background/normal/normal`
- bottom-border: `1px color/line/normal/neutral`
- layout: 3-segment — 좌 / 중 / 우

**Slot: cancelButton**

- ref: `01-button.md` variant `text`
- size: `medium`
- color: `neutral` (`color/label/strong`)
- content: `Cancel`
- on-tap: `screen-flow → pop` (변경사항 있으면 confirm 후 pop)

**Slot: title**

- text-variant: `text/heading2`
- color: `color/label/strong`
- content: `Edit Piece`
- align: center

**Slot: saveButton**

- ref: `01-button.md` variant `text`
- size: `medium`
- color: `primary` (`color/primary/normal`)
- content: `Save`
- disabled: `{{!form.canSubmit}}` — 캡션이 비어있지 않거나 사진이 교체된 경우 활성
- loading: `{{state.saving}}`
- on-tap: `api: PATCH /pieces/{id} (photo? + caption) → screen-flow → pop → invalidate(piece detail/feed)`

### Region: Content

- container-padding: `spacing/24`
- block-gap: `spacing/24`

#### Section: PhotoBlock

##### Section: PhotoHeader

- layout: `space-between`, align center
- bottom-padding: `spacing/12`

**Slot: label**

- text-variant: `text/heading3`
- color: `color/label/strong`
- content: `Photo`

**Slot: requiredBadge**

- ref: `14-content-badge.md`
- variant: `subtle`
- color: `color/label/alternative`
- content: `Required`

> ℹ️ 스크린샷에선 텍스트형태로 보이지만 의미상 "필수" 인디케이터. DS에 어울리는 variant이 없으면 단순 label로 fallback 가능.

##### Section: PhotoFrame

- container: relative positioning
- aspect-ratio: 4:5 또는 3:4
- shape: `radius/lg`
- overflow: clip

**Slot: photo**

- ref: `<Custom name="DailyPiecePhoto">`
- src: `{{piece.imageUrl}}` (편집 시작 시) / `{{state.pendingPhotoBytes}}` (교체 후)
- fit: cover

**Slot: replacePhotoButton**

- ref: `01-button.md` variant `solid filled-tonal`
- size: `small`
- background: `color/background/elevated/alternative` (rgba dark, semi-transparent)
- text color: `color/static/white` 또는 `color/label/strong`
- leading-icon: `camera` (16, color `color/primary/normal`)
- content: `Replace Photo`
- position: `absolute`, `right: spacing/16, bottom: spacing/16`
- shape: `radius/md` (~12px capsule-ish)
- on-tap: `pickAndProcessPhoto(context)` (camera/gallery chooser → image_picker → ADR 0004 압축) → state: `pendingPhotoBytes = bytes`

##### Section: InfoNote

- layout: 가로 (icon + text), gap `spacing/8`, align top
- top-padding: `spacing/12`

**Slot: infoIcon**

- icon: `info` (16, `color/label/alternative`)

**Slot: noteText**

- text-variant: `text/caption1`
- color: `color/label/alternative`
- content: `You can only have one photo per piece. Replacing will update this piece's photo.`

---

#### Section: CaptionBlock

##### Section: CaptionHeader

- layout: `space-between`, align center
- bottom-padding: `spacing/12`

**Slot: label**

- text-variant: `text/heading3`
- color: `color/label/strong`
- content: `Caption`

**Slot: counter**

- text-variant: `text/caption1`
- color: `color/label/alternative`
- content: `{{form.caption.length}}/50`
- align: right

##### Slot: textarea

- ref: `10-textarea.md`
- value: `{{form.caption}}` (initial: piece.caption)
- placeholder: `Write a short caption (max 50 chars)...`
- maxLength: `50`
- minLines: 4
- on-change: `state: form.caption = $value`
- background: `color/background/elevated/normal`
- border: `1px color/line/normal/neutral`
- shape: `radius/md`

---

## 3. Intent

### 사용자 의도

이미 저장한 piece의 사진/캡션을 수정. 날짜는 immutable.

### 진입 / 이탈

- **진입**: 05 Piece Details의 Edit Piece 행 탭
- **이탈**:
  - Cancel → 변경 있으면 confirm → pop
  - Save 성공 → pop + Detail 화면 invalidate
  - back gesture → Cancel과 동일 처리

### 핵심 액션 우선순위

1. **Save** (우상단 primary text 버튼)
2. Replace Photo (사진 위 floating)
3. Caption 편집 (textarea)
4. Cancel (좌상단)

### 접근성

- **포커스 순서**: cancelButton → title → saveButton → photo header → photo (replace 버튼) → infoNote → caption header (counter) → textarea
- **터치 타겟**: TopBar 버튼 ≥ 44, replacePhoto ≥ 44, textarea 자체로 큼
- **변경 보호**: 변경사항이 있는 상태에서 Cancel/back → confirm dialog ("Discard changes?")
- **카운터 변화**: 입력 시 counter live update — 50 도달 시 색상 강조 (옵션)

### Reactive Behavior

- **사진 교체 처리 중**: photoFrame 위 spinner 오버레이 + replacePhoto 버튼 disabled
- **저장 중**: saveButton loading + 모든 입력 disabled
- **저장 실패**: Snackbar variant=error + 재시도. saveButton 다시 활성.
- **캡션 비움**: Save 비활성 (캡션은 필수)

---

## 검증 체크리스트

- [x] frontmatter / 위계
- [x] TopBar 3-segment (Cancel / 제목 / Save text 버튼)
- [x] Photo `Required` 인디케이터
- [x] Replace Photo floating 버튼 (camera icon + 라벨)
- [x] Counter 0/50 우측 정렬
- [x] Textarea prefill + maxLength
- [x] BottomNav 없음 (모달/편집 모드)
- [ ] DS의 `01-button.md`에 text variant 정의 확인
- [ ] DS의 `14-content-badge.md`에 subtle variant 또는 대체 패턴 확인
