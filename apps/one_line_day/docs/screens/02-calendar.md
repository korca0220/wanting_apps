---
name: Calendar
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

# Screen: Calendar

## 개요

Calendar는 월 단위로 기록한 날과 비어 있는 날을 보여준다. 사용자는 날짜를 선택해 해당 날짜의 한 줄을 읽거나 새로 작성한다.

---

## 1. Skeleton

```
Page (viewport: mobile)
├── Region: Header
│   └── Slot: topNavigation
│       ↳ component: design_system/docs/components/25-top-navigation.md
├── Region: MonthControl
│   ├── Slot: previousMonth
│   │   ↳ component: design_system/docs/components/09-icon-button.md
│   ├── Slot: currentMonth
│   │   ↳ component: design_system/docs/components/16-label.md
│   └── Slot: nextMonth
│       ↳ component: design_system/docs/components/09-icon-button.md
├── Region: CalendarGrid
│   ├── Slot: weekdayLabel
│   │   ↳ component: design_system/docs/components/16-label.md
│   └── Slot: dayCell
│       ↳ <Custom name="OneLineDayCell">
├── Region: SelectedDatePreview
│   ├── Slot: previewCard
│   │   ↳ component: design_system/docs/components/06-card.md
│   ├── Slot: emptyDateView
│   │   ↳ component: design_system/docs/components/22-fallback-view.md
│   └── Slot: dateAction
│       ↳ component: design_system/docs/components/01-button.md
└── Region: Footer
    └── Slot: bottomNavigation
        ↳ component: design_system/docs/components/23-bottom-navigation.md
```

---

## 2. Bindings

### Region: Header

**Slot: topNavigation**
- ref: `design_system/docs/components/25-top-navigation.md`
- title: `Calendar`
- title-color: `color/label/strong`
- background: `color/background/normal/normal`

### Region: MonthControl

#### Layout 토큰
- container-padding: `spacing/24`
- section-gap: `spacing/12`
- background: `color/background/normal/normal`

**Slot: previousMonth**
- ref: `design_system/docs/components/09-icon-button.md`
- icon: `chevron-left`
- aria-label: `Previous month`
- on-tap: `state-update → visibleMonth.previous()`

**Slot: currentMonth**
- ref: `design_system/docs/components/16-label.md`
- text-variant: `text/heading1`
- color: `color/label/strong`
- content: `{{visibleMonth | format("MMMM yyyy")}}`

**Slot: nextMonth**
- ref: `design_system/docs/components/09-icon-button.md`
- icon: `chevron-right`
- aria-label: `Next month`
- on-tap: `state-update → visibleMonth.next()`

### Region: CalendarGrid

#### Layout 토큰
- container-padding: `spacing/24`
- weekday-gap: `spacing/8`
- row-gap: `spacing/8`

**Slot: weekdayLabel**
- ref: `design_system/docs/components/16-label.md`
- repeat: `Sun`, `Mon`, `Tue`, `Wed`, `Thu`, `Fri`, `Sat`
- text-variant: `text/caption1`
- color: `color/label/assistive`
- alignment: center

**Slot: dayCell**
- ref: `<Custom name="OneLineDayCell">`
- repeat: `{{visibleMonth.calendarDays}}`
- state variants: `outside-month`, `empty`, `has-entry`, `today`, `selected`
- label: `{{day.number}}`
- entry-indicator-color when has-entry: `color/primary/normal`
- selected-background: `color/primary/subtle`
- selected-label-color: `color/primary/normal`
- normal-label-color: `color/label/normal`
- disabled-label-color: `color/label/disable`
- on-tap: `state-update → selectedDate = day.date`

### Region: SelectedDatePreview

#### Layout 토큰
- container-padding: `spacing/24`
- top-padding: `spacing/16`
- card-gap: `spacing/12`

**Slot: previewCard**
- ref: `design_system/docs/components/06-card.md`
- state: visible when `{{selectedEntry != null}}`
- background: `color/background/elevated/normal`
- radius: `radius/lg`
- title: `{{selectedDate | format("MMM d, yyyy")}}`
- body: `{{selectedEntry.text}}`
- on-tap: `screen-flow → 06-edit-entry.md (date: selectedDate)`

**Slot: emptyDateView**
- ref: `design_system/docs/components/22-fallback-view.md`
- state: visible when `{{selectedEntry == null}}`
- title: `No line for this day`
- description: `선택한 날짜에 한 줄을 남길 수 있어요.`

**Slot: dateAction**
- ref: `design_system/docs/components/01-button.md`
- variant: `solid-primary`
- label when empty: `Write for this day`
- label when saved: `Edit line`
- on-tap: `screen-flow → 06-edit-entry.md (date: selectedDate)`

### Region: Footer

**Slot: bottomNavigation**
- ref: `design_system/docs/components/23-bottom-navigation.md`
- variant: `with-label`
- active: `Calendar`
- items: `Today`, `Calendar`, `Entries`, `Search`, `Settings`

---

## 3. Intent

### 사용자 의도

사용자는 기록이 쌓인 날짜를 월 단위로 확인하고, 비어 있는 날짜에는 새 기록을 추가한다.

### 진입 / 이탈

- **진입**: 하단 탭 Calendar 선택
- **이탈**: 날짜 액션 → `06-edit-entry.md`; 하단 탭 선택 → 다른 주요 화면

### 핵심 액션 우선순위

1. 날짜별 기록 여부 확인
2. 선택 날짜 기록 작성/수정
3. 이전/다음 달 이동

### 접근성

- **포커스 순서**: topNavigation → previousMonth → currentMonth → nextMonth → weekdayLabel → dayCell → previewCard/dateAction → bottomNavigation
- **스크린리더 의도**: 각 날짜가 오늘인지, 선택됨인지, 기록이 있는지 전달한다.
- **Reduced motion**: 월 전환 애니메이션 없이도 달 변경이 명확해야 한다.
- **터치 타겟**: 날짜 셀과 월 이동 버튼은 DS 접근성 기준을 따른다.

### Reactive Behavior

- 데이터 로딩 중: CalendarGrid에 `21-skeleton.md` 기반 월 그리드 placeholder 표시
- 빈 월: 날짜 셀은 유지하고 SelectedDatePreview에서 작성 CTA 제공
- 에러: `08-snackbar.md` error 메시지와 월 데이터 재시도

---

## 검증 체크리스트

- [x] 날짜 상태 variant가 정의됨
- [x] 빈 날짜와 작성된 날짜의 액션이 모두 정의됨
- [x] Custom day cell은 DS 토큰만 참조함
