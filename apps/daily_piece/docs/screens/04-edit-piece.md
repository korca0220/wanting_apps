---
name: Edit Piece
extends: design_system
imports: []
source:
  type: figma
  url: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece
  node_id: "2:367"
viewport:
  primary: mobile
  responsive: [mobile]
---

# Screen: Edit Piece

## 개요
기존 daily piece의 사진과 캡션을 편집하는 폼 화면. 사진 교체(Replace Photo) + 캡션 수정 + Cancel/Save 액션. "You can only have one photo per piece. Replacing will update this piece's photo." 안내 포함.

> ⚠️ sparse metadata 기반 시범 명세.

---

## 1. Skeleton

```
Page (viewport: mobile, 375×772)
├── Region: Header
│   └── Section: TopBar
│       └── Slot: title
│           ↳ component: design_system/docs/components/16-label.md
├── Region: Content
│   ├── Section: PhotoField
│   │   ├── Slot: label
│   │   │   ↳ component: design_system/docs/components/16-label.md
│   │   ├── Slot: requiredBadge
│   │   │   ↳ component: design_system/docs/components/14-content-badge.md
│   │   ├── Slot: imageUploader
│   │   │   ↳ component: design_system/docs/components/27-image-uploader.md (mode: preview)
│   │   └── Slot: helperText
│   │       ↳ component: design_system/docs/components/16-label.md
│   └── Section: CaptionField
│       ├── Slot: label
│       │   ↳ component: design_system/docs/components/16-label.md
│       ├── Slot: textarea
│       │   ↳ component: design_system/docs/components/10-textarea.md
│       └── Slot: counter
│           ↳ component: design_system/docs/components/16-label.md
└── Region: Footer (액션 영역)
    └── Section: ActionBar
        ├── Slot: cancelButton
        │   ↳ component: design_system/docs/components/01-button.md
        └── Slot: saveButton
            ↳ component: design_system/docs/components/01-button.md
```

---

## 2. Bindings

### Region: Header

#### Section: TopBar

**Slot: title**
- text-variant: `text/heading2`
- color: `color/label/normal`
- content: `Edit Piece`

### Region: Content

#### Layout 토큰
- container-padding: `spacing/16`
- section-gap: `spacing/24`

#### Section: PhotoField

**Slot: label**
- text-variant: `text/label1`
- color: `color/label/normal`
- content: `Photo`

**Slot: requiredBadge**
- ref: `design_system/docs/components/14-content-badge.md`
- variant: `outlined`
- color: `accent`
- accentColor: `color/status/negative`
- size: `xsmall`
- content: `Required`

**Slot: imageUploader**
- ref: `design_system/docs/components/27-image-uploader.md`
- variant: `default`
- aspect: `1:1` (검수 필요 — 디자인에서 추정)
- size: `medium`
- value: `{{form.photoUrl}}` (preview 모드 진입)
- alt: `현재 piece 사진`
- onChange: `state: form.photoFile = $value` (Replace Photo 액션 — 우상단 edit IconButton 또는 영역 탭으로 시스템 픽커)
- onRemove: `(없음 — Edit Piece에선 사진 필수, 제거 불가)`

> 별도 "Replace Photo" 버튼 슬롯 불필요 — ImageUploader의 preview 모드 우상단 액션이 동일 역할 수행.

**Slot: helperText**
- text-variant: `text/caption1`
- color: `color/label/alternative`
- content: `You can only have one photo per piece. Replacing will update this piece's photo.`

#### Section: CaptionField

**Slot: label**
- text-variant: `text/label1`
- color: `color/label/normal`
- content: `Caption`

**Slot: textarea**
- ref: `design_system/docs/components/10-textarea.md`
- value: `{{form.caption}}`
- maxLength: `50`
- minRows: `3`
- maxRows: `5`
- on-change: `state: form.caption = $value`
- placeholder: `caption을 작성하세요...`

**Slot: counter**
- text-variant: `text/caption1`
- color: `{{form.caption.length > 50 ? color/status/negative : color/label/alternative}}`
- align: `right`
- content: `{{form.caption.length}}/50`

### Region: Footer (ActionBar)

#### Layout 토큰
- container-padding: `spacing/16`
- gap: `spacing/12`
- bg-color: `color/background/elevated/normal`
- border-top: `1px color/line/normal/neutral`

**Slot: cancelButton**
- ref: `design_system/docs/components/01-button.md`
- variant: `outlined`
- color: `assistive`
- size: `medium`
- content: `Cancel`
- on-tap: `state: form.dirty ? confirm: 변경 취소 → screen-flow back : screen-flow back`

**Slot: saveButton**
- ref: `design_system/docs/components/01-button.md`
- variant: `solid`
- color: `primary`
- size: `medium`
- content: `Save`
- disabled: `{{!form.valid || form.caption.length > 50}}`
- loading: `{{state.saving}}`
- on-tap: `api: PATCH /pieces/{id} (form) → screen-flow back → snackbar: variant=success "저장됐어요"`

---

## 3. Intent

### 사용자 의도
실수로 잘못 작성한 캡션을 빠르게 고치거나, 사진을 다른 것으로 바꾼다. 단순한 1단계 폼이지만 사진 1장 제약과 50자 제한을 명확히 인지시킨다.

### 진입 / 이탈
- **진입**: Piece Details(05)에서 Edit Piece 버튼 탭
- **이탈**:
  - Cancel → 직전 화면 (변경사항 있으면 confirm)
  - Save → API 성공 시 직전 화면 + 성공 Snackbar
  - 시스템 백 버튼 → Cancel과 동일

### 핵심 액션 우선순위
1. **Save** — 가장 중요, 솔리드 primary
2. **Replace Photo** — 자주 사용되진 않으나 폼의 핵심
3. **Cancel** — 약하게 노출

### 접근성
- **포커스 순서**: title → Photo label → Required badge → photo preview → Replace button → helperText → Caption label → textarea → counter → Cancel → Save
- **textarea**: aria-describedby로 helperText/counter 연결, aria-invalid는 50자 초과 시
- **터치 타겟**: 모든 버튼 ≥ 44px
- **키보드**: textarea에서 Tab 빠져나가기 가능, Esc는 Cancel과 동일

### Reactive Behavior
- **로딩**: PhotoPreview 영역 Skeleton variant=rectangle, textarea는 skeleton 없이 즉시 표시
- **저장 중**: Save 버튼 loading=true (자식 hidden + spinner)
- **에러**: Snackbar variant=error, 재시도 버튼
- **글자 수 초과**: counter 색이 `color/status/negative`로, textarea 보더 invalid 상태, Save 버튼 disabled

---

## 검증 체크리스트
- [x] 5단계 위계 / Slot 종결
- [ ] PhotoPreview는 wanted DS의 thumbnail 합성 컴포넌트로 매핑 가능 — 후속 합류 후보
- [x] Bindings Semantic 토큰
- [x] 폼 검증 + 에러 명시
