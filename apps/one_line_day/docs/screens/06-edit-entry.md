---
name: Edit Entry
extends: design_system
imports: []
source:
  type: code
  url: apps/one_line_day/docs/screens/00-INDEX.md
  node_id: null
viewport:
  primary: mobile
  responsive: [mobile]
---

# Screen: Edit Entry

## 개요

Edit Entry는 특정 날짜의 한 줄을 작성하거나 수정하는 시트형 화면이다. Today, Calendar, Entries, Search에서 공통으로 호출되며, 날짜당 하나의 기록만 저장한다.

---

## 1. Skeleton

```
Sheet (viewport: mobile)
├── Region: SheetHeader
│   ├── Slot: title
│   │   ↳ component: design_system/docs/components/16-label.md
│   └── Slot: closeButton
│       ↳ component: design_system/docs/components/09-icon-button.md
├── Region: EntryForm
│   ├── Slot: dateLabel
│   │   ↳ component: design_system/docs/components/16-label.md
│   ├── Slot: entryTextarea
│   │   ↳ component: design_system/docs/components/10-textarea.md
│   ├── Slot: characterCount
│   │   ↳ component: design_system/docs/components/16-label.md
│   └── Slot: validationMessage
│       ↳ component: design_system/docs/components/16-label.md
├── Region: Actions
│   ├── Slot: saveButton
│   │   ↳ component: design_system/docs/components/01-button.md
│   ├── Slot: deleteButton
│   │   ↳ component: design_system/docs/components/01-button.md
│   └── Slot: cancelButton
│       ↳ component: design_system/docs/components/01-button.md
└── Region: ConfirmDelete
    └── Slot: deleteAlert
        ↳ component: design_system/docs/components/18-alert.md
```

---

## 2. Bindings

### Region: SheetHeader

#### Layout 토큰
- container-padding: `spacing/24`
- section-gap: `spacing/12`
- background: `color/background/elevated/normal`

**Slot: title**
- ref: `design_system/docs/components/16-label.md`
- text-variant: `text/heading1`
- color: `color/label/strong`
- content when new: `Write a line`
- content when existing: `Edit line`

**Slot: closeButton**
- ref: `design_system/docs/components/09-icon-button.md`
- icon: `x`
- aria-label: `Close`
- on-tap: `screen-flow → dismiss sheet`

### Region: EntryForm

#### Layout 토큰
- container-padding: `spacing/24`
- field-gap: `spacing/12`

**Slot: dateLabel**
- ref: `design_system/docs/components/16-label.md`
- text-variant: `text/body2`
- color: `color/label/neutral`
- content: `{{date | format("EEEE, MMMM d, yyyy")}}`

**Slot: entryTextarea**
- ref: `design_system/docs/components/10-textarea.md`
- placeholder: `오늘을 한 줄로 적어보세요.`
- value: `{{draft.text}}`
- max-length: `200`
- min-lines: `3`
- max-lines: `5`
- autofocus: true
- on-change: `state-update → draft.text`

**Slot: characterCount**
- ref: `design_system/docs/components/16-label.md`
- text-variant: `text/caption1`
- color when valid: `color/label/assistive`
- color when over-limit: `color/status/negative`
- content: `{{draft.text.length}} / 200`

**Slot: validationMessage**
- ref: `design_system/docs/components/16-label.md`
- state: visible when `{{validationError != null}}`
- text-variant: `text/caption1`
- color: `color/status/negative`
- content: `{{validationError}}`

### Region: Actions

#### Layout 토큰
- container-padding: `spacing/24`
- button-gap: `spacing/8`
- bottom-padding: `spacing/24`

**Slot: saveButton**
- ref: `design_system/docs/components/01-button.md`
- variant: `solid-primary`
- label: `Save`
- disabled: `{{draft.text.trim().length == 0 || draft.text.length > 200}}`
- on-tap: `data-action → upsertEntry(date, draft.text)`
- on-success: `screen-flow → dismiss sheet and refresh previous screen`

**Slot: deleteButton**
- ref: `design_system/docs/components/01-button.md`
- state: visible when `{{existingEntry != null}}`
- variant: `ghost-danger`
- label: `Delete`
- on-tap: `screen-flow → confirm-delete-entry alert`

**Slot: cancelButton**
- ref: `design_system/docs/components/01-button.md`
- variant: `ghost`
- label: `Cancel`
- on-tap: `screen-flow → dismiss sheet`

### Region: ConfirmDelete

**Slot: deleteAlert**
- ref: `design_system/docs/components/18-alert.md`
- state: visible when `{{confirmDelete == true}}`
- title: `Delete this line?`
- description: `삭제한 기록은 되돌릴 수 없어요.`
- cancel-label: `Cancel`
- destructive-label: `Delete`
- on-confirm: `data-action → deleteEntry(date)`
- on-success: `screen-flow → dismiss sheet and refresh previous screen`

---

## 3. Intent

### 사용자 의도

사용자는 선택한 날짜에 남길 문장을 빠르게 작성하고 저장하거나, 기존 기록을 안전하게 수정/삭제한다.

### 진입 / 이탈

- **진입**: Today의 Edit/Save 흐름, Calendar 날짜 선택, Entries 카드 선택, Search 결과 선택
- **이탈**: Save/Delete/Cancel/Close → 이전 화면으로 복귀

### 핵심 액션 우선순위

1. 한 줄 작성 또는 수정
2. 저장
3. 기존 기록 삭제

### 접근성

- **포커스 순서**: title → closeButton → dateLabel → entryTextarea → characterCount → saveButton → deleteButton → cancelButton
- **스크린리더 의도**: 현재 날짜, 입력 글자 수, 저장 가능 여부를 전달한다.
- **Reduced motion**: 시트 진입/닫힘 애니메이션이 없어도 상위 화면 복귀가 명확해야 한다.
- **터치 타겟**: 모든 버튼은 DS 접근성 기준을 따른다.

### Reactive Behavior

- 저장 중: saveButton loading 상태, 중복 탭 방지
- 빈 입력: saveButton disabled, validationMessage는 제출 시도 후 표시
- 글자 수 초과: characterCount와 validationMessage에 negative 상태 표시
- 삭제 확인: `18-alert.md`로 파괴적 액션 재확인
- 에러: `08-snackbar.md` error 메시지와 현재 입력 유지

---

## 검증 체크리스트

- [x] 작성/수정/삭제가 하나의 시트 흐름으로 정의됨
- [x] 날짜당 1개 기록 제약이 반영됨
- [x] 파괴적 삭제 액션은 alert 확인을 거침
