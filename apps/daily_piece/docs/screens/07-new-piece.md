---
name: New Piece
extends: design_system
imports: []
source:
  type: figma
  url: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece
  node_id: "2:513"
  link: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece?node-id=2-513&t=2SsB9yTpe6fjdj7N-4
viewport:
  primary: mobile
  responsive: [mobile]
---

# Screen: New Piece

## 개요

새로운 daily piece를 만드는 작성 화면. 사진 1장 선택 + 50자 이내 캡션 작성 → Save Piece. "Tap to select a photo" / "Share your moment of the day" 안내.

> ⚠️ 추정 명세 (node 2:513 frame 안의 sub-screen).

---

## 1. Skeleton

```
Page (viewport: mobile, 375×840)
├── Region: Header
│   └── Section: TopBar
│       ├── Slot: backButton
│       │   ↳ component: design_system/docs/components/09-icon-button.md
│       └── Slot: title
│           ↳ component: design_system/docs/components/16-label.md
├── Region: Content
│   ├── Section: PhotoPicker
│   │   ↳ component: design_system/docs/components/27-image-uploader.md (variant: default, mode: empty)
│   ├── Section: CaptionField
│   │   ├── Slot: label
│   │   │   ↳ component: design_system/docs/components/16-label.md
│   │   ├── Slot: textarea
│   │   │   ↳ component: design_system/docs/components/10-textarea.md
│   │   └── Slot: counter
│   │       ↳ component: design_system/docs/components/16-label.md
│   └── Section: TextToggleHint    # "Text" — 캡션만으로 piece 만들 수 있는 옵션 인지
│       └── Slot: textOnlyLink
│           ↳ component: design_system/docs/components/16-label.md
└── Region: Footer
    └── Section: ActionBar
        └── Slot: saveButton
            ↳ component: design_system/docs/components/01-button.md
```

---

## 2. Bindings

### Region: Header

#### Section: TopBar

**Slot: backButton**

- ref: `design_system/docs/components/09-icon-button.md`
- icon: `chevron-left`
- aria-label: `뒤로`
- on-tap: `screen-flow back (form dirty면 confirm)`

**Slot: title**

- text-variant: `text/heading2`
- color: `color/label/normal`
- content: `New Piece`

### Region: Content

#### Layout 토큰

- container-padding: `spacing/16`
- section-gap: `spacing/24`

#### Section: PhotoPicker

- ref: `design_system/docs/components/27-image-uploader.md`
- variant: `default`
- aspect: `1:1` (정사각형, 검수 필요)
- size: `medium`
- value: `{{form.photoFile}}`
- hint: `Tap to select a photo`
- subhint: `Share your moment of the day`
- onChange: `state: form.photoFile = $value` (이미지 선택 시 자동 preview 모드)
- onRemove: `state: form.photoFile = null` (preview 모드의 우상단 X)

> ImageUploader가 empty/preview 두 모드를 모두 처리. text-only 모드(`form.mode === "text-only"`)일 때 disabled=true 또는 영역 hidden.

#### Section: CaptionField

**Slot: label**

- text-variant: `text/label1`
- color: `color/label/normal`
- content: `Caption`

**Slot: textarea**

- ref: `design_system/docs/components/10-textarea.md`
- value: `{{form.caption}}`
- placeholder: `Write a short caption (max 50 chars)...`
- maxLength: `50`
- minRows: `2`
- maxRows: `4`
- on-change: `state: form.caption = $value`

**Slot: counter**

- text-variant: `text/caption1`
- color: `{{form.caption.length > 50 ? color/status/negative : color/label/alternative}}`
- align: `right`
- content: `{{form.caption.length}}/50`

#### Section: TextToggleHint

**Slot: textOnlyLink**

- text-variant: `text/label2` × `font/weight/medium`
- color: `color/primary/normal`
- content: `Text` (사진 없이 텍스트만으로 piece 만들기)
- on-tap: `state: form.mode = "text-only"` (사진 슬롯 숨김)

### Region: Footer (ActionBar)

#### Layout 토큰

- container-padding: `spacing/16`
- bg-color: `color/background/elevated/normal`
- border-top: `1px color/line/normal/neutral`

**Slot: saveButton**

- ref: `design_system/docs/components/01-button.md`
- variant: `solid`
- color: `primary`
- size: `large`
- fullWidth: `true`
- content: `Save Piece`
- disabled: `{{!form.canSave}}` # canSave = (photo OR text-only mode) AND caption.length 0~50
- loading: `{{state.saving}}`
- on-tap: `api: POST /pieces (form) → screen-flow back → snackbar variant=success "Piece가 저장됐어요"`

---

## 3. Intent

### 사용자 의도

오늘 하루의 한 순간을 빠르게 캡처(사진 또는 짧은 텍스트)하고 50자 이내 캡션과 함께 저장한다. 30초 이내 완료가 목표.

### 진입 / 이탈

- **진입**: Calendar에서 빈 셀 탭 / Empty Home의 "First Piece" CTA / FAB(있다면)
- **이탈**: Save 성공 → My Pieces / Cancel(back) → 직전 화면

### 핵심 액션 우선순위

1. **Save Piece** (가장 큰 버튼, solid primary)
2. **사진 선택** (tap target)
3. **캡션 작성**

### 접근성

- **포커스 순서**: backButton → title → photoPicker → caption label → textarea → counter → text-only link → saveButton
- **photoPicker aria-label**: "사진 선택. 탭해서 갤러리 열기" — 시각 장애인에 명확
- **textarea aria-describedby**: counter 연결, aria-invalid는 50자 초과
- **터치 타겟**: 모든 인터랙티브 ≥ 44px, photoPicker는 큰 영역으로 자연스럽게 충족

### Reactive Behavior

- **사진 선택 후**: photoPicker 영역이 PhotoPreview로 전환, hint/subhint 숨김 또는 변경
- **저장 중**: saveButton loading=true
- **에러**: Snackbar variant=error, 폼 값 보존
- **유효성 미달**: saveButton disabled, counter 색 변경(50자 초과 시)

---

## 검증 체크리스트

- [x] frontmatter / 위계 / 토큰
- [ ] PhotoPickerSlot은 wanted DS의 image-picker 합성 후보
- [x] 폼 유효성 / 에러 처리 명시
