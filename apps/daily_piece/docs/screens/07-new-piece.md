---
name: New Piece
extends: design_system
imports: []
source:
  type: figma
  url: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece
  node_id: "2:513"
  link: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece?node-id=2-513&t=2SsB9yTpe6fjdj7N-4
  spec_basis: screenshot
viewport:
  primary: mobile
  responsive: [mobile]
---

# Screen: New Piece (Bottom Sheet)

## 개요

오늘의 piece를 작성하는 **모달 바텀시트**. My Pieces / Calendar의 FAB·빈 날 탭에서 진입. 사진 1장 + 50자 이하 캡션 → Save Piece. 현재 화면(=직전 화면)이 시트 위에 일부 보임 (dimming + dragging affordance).

---

## 1. Skeleton

```
ModalBottomSheet (375×~640, 직전 화면 위 dim overlay)
└── Region: Sheet (rounded-top, padding 24)
    ├── Section: Header
    │   ├── Slot: title
    │   │   ↳ component: design_system/docs/components/16-label.md
    │   └── Slot: closeButton
    │       ↳ component: design_system/docs/components/09-icon-button.md
    ├── Section: PhotoPicker
    │   ↳ component: design_system/docs/components/27-image-uploader.md (variant: empty)
    │   └── 안 슬롯들:
    │       ├── icon (camera glyph)
    │       ├── primaryText
    │       └── secondaryText
    ├── Section: CaptionField
    │   ├── Slot: label
    │   │   ↳ component: design_system/docs/components/16-label.md
    │   └── Slot: textarea
    │       ↳ component: design_system/docs/components/10-textarea.md
    │       └── trailingCounter (자체 슬롯 또는 helper text)
    └── Section: PrimaryAction
        └── Slot: saveButton
            ↳ component: design_system/docs/components/01-button.md
```

---

## 2. Bindings

### 시트 컨테이너

- background: `color/background/elevated/normal`
- top-radius: `radius/lg` (16px) — 좌우 상단만 둥글게
- padding: `spacing/24`
- behind-dim: `color/material/dimmer`
- drag-affordance: 상단 손잡이 (4×40 capsule, `color/line/normal/neutral`) — 선택 적용

### Section: Header

- layout: `space-between`, align center

**Slot: title**

- text-variant: `text/title2` (Inter Bold ~24px)
- color: `color/label/strong`
- content: `New Piece`

**Slot: closeButton**

- ref: `design_system/docs/components/09-icon-button.md`
- variant: `normal`
- size: `medium`
- icon: `x` (close)
- aria-label: `닫기`
- on-tap: `screen-flow → dismiss sheet (return to caller)`

### Section: PhotoPicker (empty 상태)

- ref: `design_system/docs/components/27-image-uploader.md` variant: `empty`
- aspect-ratio: 1
- border: `1px dashed color/line/normal/neutral`
- radius: `radius/lg`
- background: `color/background/elevated/alternative`
- padding-y: `spacing/40`
- align: center, gap `spacing/12`

내부 슬롯:

- **icon**: 48×48 circle 배경 (`color/fill/alternative`) + 카메라 글리프(24, `color/label/alternative`)
- **primaryText**: `Tap to select a photo` — `text/heading3`, `color/label/strong`
- **secondaryText**: `Share your moment of the day` — `text/body2`, `color/label/alternative`

상태 전환:

- on-tap: `pickAndProcessPhoto(context)` (갤러리/카메라 chooser → image_picker → ADR 0004 압축)
- 파일 픽 완료 시 → `27-image-uploader.md` variant: `preview` (선택된 사진 표시 + 교체/삭제 액션)

### Section: CaptionField

**Slot: label**

- text-variant: `text/label1`
- color: `color/label/normal`
- content: `Caption`

**Slot: textarea**

- ref: `design_system/docs/components/10-textarea.md`
- placeholder: `Write a short caption (max 50 chars)...`
- maxLength: `50`
- value: `{{form.caption}}`
- on-change: `state: form.caption = $value`
- trailing helper: `{{form.caption.length}}/50` — `text/caption1`, `color/label/alternative`, right-aligned

### Section: PrimaryAction

- top-padding: `spacing/16`

**Slot: saveButton**

- ref: `design_system/docs/components/01-button.md`
- variant: `solid`
- color: `primary`
- size: `large`
- fullWidth: `true`
- content: `Save Piece`
- disabled: `{{!form.canSubmit}}` — 사진 + 캡션 ≥ 1자 모두 만족할 때만 활성
- loading: `{{state.saving}}`
- on-tap: `api: upload(photo) → INSERT pieces row → screen-flow → dismiss sheet → invalidate(myPiecesFeed/todayPiece)`

---

## 3. Intent

### 사용자 의도

오늘의 piece를 빠르게 작성. 사진 → 캡션 → 저장. 시트 형태라 직전 화면 위에서 빠르게 들어왔다 나갈 수 있음.

### 진입 / 이탈

- **진입**:
  - 06 My Pieces FAB
  - 03 Calendar 빈 날 셀 탭
  - (가능) 다른 화면의 + 액션
- **이탈**:
  - 닫기 X / 시트 외부 탭 / pull-to-dismiss → 작성 취소
  - Save Piece 성공 → 시트 dismiss + 이전 화면 invalidate (My Pieces 피드 갱신)

### 핵심 액션 우선순위

1. PhotoPicker 탭 (사진 선택)
2. Caption 입력
3. Save Piece

### 접근성

- **포커스 순서**: title → closeButton → PhotoPicker → caption textarea → saveButton
- **시트 핸들**: drag handle 영역에도 닫기 의도 부여 (semantics)
- **터치 타겟**: closeButton ≥ 44, PhotoPicker 카드 전체, saveButton large
- **키보드**: caption 입력 시 시트가 키보드 위로 적응(insets) — 스크롤 보장

### Reactive Behavior

- **사진 처리 중**: PhotoPicker 영역에 spinner 오버레이
- **저장 중**: Save Piece 버튼 loading + 모든 입력 disabled
- **이미 오늘의 Piece 존재**: 서버 unique 위반 → 에러 메시지 inline (Save 버튼 위/아래 또는 snackbar). UNIQUE(user_id, date)는 도메인 invariant이므로 미리 클라이언트에서 가드(My Pieces 피드의 최근 piece 날짜로 판단) 권장.
- **취소 보호**: 이미 입력한 내용이 있으면 dismiss 시 confirm 다이얼로그(선택)

---

## 검증 체크리스트

- [x] frontmatter / 시트 컨테이너 토큰 / 위계
- [x] 27-image-uploader empty/preview 두 상태 명시
- [x] textarea maxLength 50 + counter
- [ ] DS의 `27-image-uploader.md` 양 상태 합의 — preview 모드의 교체/삭제 액션 정의 확인
- [ ] DS의 `10-textarea.md`에 trailing counter 슬롯 또는 helper text 패턴 존재 여부 확인
