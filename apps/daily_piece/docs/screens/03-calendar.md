---
name: Calendar
extends: design_system
imports: []
source:
  type: figma
  url: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece
  node_id: "2:209"
viewport:
  primary: mobile
  responsive: [mobile]
---

# Screen: Calendar

## 개요

한 달 단위 캘린더 그리드 위에 daily piece가 등록된 날짜를 도트로 표시하는 화면. "Days with a blue dot have a piece. Tap any day to view or add a piece for that date." 안내 포함.

> ⚠️ sparse metadata 기반 시범 명세.

---

## 1. Skeleton

```
Page (viewport: mobile, 375×840)
├── Region: Header
│   └── Section: TopBar
│       ├── Slot: title
│       │   ↳ component: design_system/docs/components/16-label.md
│       └── Slot: monthLabel
│           ↳ component: design_system/docs/components/16-label.md
├── Region: Content
│   ├── Section: Intro
│   │   ├── Slot: heading
│   │   │   ↳ component: design_system/docs/components/16-label.md
│   │   └── Slot: description
│   │       ↳ component: design_system/docs/components/16-label.md
│   ├── Section: WeekHeader (요일 헤더)
│   │   └── (반복) Day × 7
│   │       ↳ component: design_system/docs/components/16-label.md
│   ├── Section: CalendarGrid
│   │   └── (반복) DayCell × 35~42
│   │       ↳ <Custom name="CalendarDayCell">
│   └── Section: TodayButton
│       └── Slot: button
│           ↳ component: design_system/docs/components/01-button.md
└── Region: Footer (BottomNav)
    ↳ component: design_system/docs/components/23-bottom-navigation.md
    └── (반복) items × 4 (slot: items)
```

---

## 2. Bindings

### Region: Header

#### Section: TopBar

**Slot: title**

- text-variant: `text/heading2`
- color: `color/label/normal`
- content: `Calendar`

**Slot: monthLabel**

- text-variant: `text/label1`
- color: `color/label/alternative`
- content: `{{state.viewMonth | format("MMMM yyyy")}}` (예: "March 2026")

### Region: Content

#### Layout 토큰

- container-padding: `spacing/16`
- section-gap: `spacing/16`

#### Section: Intro

**Slot: heading**

- text-variant: `text/headline2`
- color: `color/label/normal`
- content: `Your Daily Journey`

**Slot: description**

- text-variant: `text/body2`
- color: `color/label/alternative`
- content: `Days with a blue dot have a piece. Tap any day to view or add a piece for that date.`

#### Section: WeekHeader

**Slot: dayLabels** (반복: weekDays)

- text-variant: `text/caption1`
- color: `color/label/alternative`
- content: `{{day}}` (Sun / Mon / Tue / Wed / Thu / Fri / Sat)
- gap: `spacing/0` (등간격 grid)
- text-align: `center`

#### Section: CalendarGrid

**Slot: dayCells** (반복: monthDays — 일반적으로 35~42 셀, 인접 월 흐릿)

- ref: `<Custom name="CalendarDayCell">`
- bindings (per cell):
  - day-number: `{{cell.day}}` (1~31)
  - in-month: `{{cell.inCurrentMonth}}` (boolean — outside면 흐림)
  - has-piece: `{{cell.hasPiece}}` (boolean — true면 blue dot 표시)
  - is-today: `{{cell.isToday}}` (boolean — outline 또는 fill 강조)
  - on-tap: `{{cell.hasPiece ? screen-flow → 05-piece-details.md(date: cell.date) : screen-flow → 07-new-piece.md(date: cell.date)}}`

기본 토큰 (CalendarDayCell):

- size: 44×44 (touch target)
- text-variant: `text/body2`
- in-month color: `color/label/normal`
- out-of-month color: `color/label/disable`
- today bg: `color/primary/subtle` (또는 outline `color/primary/normal`)
- has-piece dot: 6px circle, `color/primary/normal`, 셀 하단 중앙

#### Section: TodayButton

**Slot: button**

- ref: `design_system/docs/components/01-button.md`
- variant: `outlined`
- color: `assistive`
- size: `small`
- content: `Today`
- on-tap: `state: viewMonth = currentMonth, scrollTo: today-cell`

### Region: Footer (BottomNav, 4탭)

(01-profile.md와 동일 — 현재 활성: Calendar)

---

## 3. Intent

### 사용자 의도

시간 흐름 위에서 자신의 daily piece 빈도/패턴을 한눈에 보고, 특정 날짜를 탭해 그 날의 piece를 보거나 새로 추가한다.

### 진입 / 이탈

- **진입**: BottomNav의 Calendar 탭
- **이탈**: 셀 탭 → 5번(있으면) 또는 7번(없으면) 화면 / Today → 현재 월 스크롤 / BottomNav 탭

### 핵심 액션 우선순위

1. 셀 탭 (날짜별 piece 진입/추가)
2. Today 버튼 (현재로 복귀)
3. 월 스와이프 (구현 시)

### 접근성

- **포커스 순서**: title → monthLabel → Intro → WeekHeader (7개) → CalendarGrid (셀) → Today 버튼 → BottomNav
- **셀 aria-label**: "3월 10일 — 1개 조각" 또는 "3월 11일 — 조각 없음" (스크린리더가 dot 의미를 텍스트로 전달)
- **키보드**: 화살표로 셀 이동, Enter로 활성화 (그리드 패턴)
- **터치 타겟**: 모든 day cell ≥ 44×44px

### Reactive Behavior

- **로딩**: 셀들을 Skeleton variant=rectangle 35개로 대체
- **빈 상태**: 그 달에 piece 0개여도 그리드는 표시 (셀 도트만 없음). 별도 empty state 불필요.
- **에러**: Snackbar variant=error

---

## 검증 체크리스트

- [x] 5단계 위계 / Slot 종결
- [ ] CalendarDayCell이 wanted DS 미명세 — 후속 합성 컴포넌트 추가 후보
- [x] Bindings 토큰 Semantic

## Figma

https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece?node-id=2-209&t=2SsB9yTpe6fjdj7N-4
