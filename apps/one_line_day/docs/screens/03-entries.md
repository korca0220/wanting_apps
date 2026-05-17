---
name: Entries
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

# Screen: Entries

## 개요

Entries는 저장된 모든 한 줄 기록을 최신순으로 보여준다. 사용자는 전체 기록을 빠르게 훑고 특정 기록을 선택해 수정하거나 삭제한다.

---

## 1. Skeleton

```
Page (viewport: mobile)
├── Region: Header
│   └── Slot: topNavigation
│       ↳ component: design_system/docs/components/25-top-navigation.md
├── Region: Summary
│   ├── Slot: totalCount
│   │   ↳ component: design_system/docs/components/16-label.md
│   └── Slot: monthChip
│       ↳ component: design_system/docs/components/04-chip.md
├── Region: EntryList
│   ├── Section: MonthGroup
│   │   ├── Slot: monthLabel
│   │   │   ↳ component: design_system/docs/components/16-label.md
│   │   └── Slot: entryCard
│   │       ↳ component: design_system/docs/components/06-card.md
│   └── Slot: emptyView
│       ↳ component: design_system/docs/components/22-fallback-view.md
├── Region: AdSlot
│   └── Slot: bannerReserve
│       ↳ <Custom name="AdBannerReserve">
└── Region: Footer
    └── Slot: bottomNavigation
        ↳ component: design_system/docs/components/23-bottom-navigation.md
```

---

## 2. Bindings

### Region: Header

**Slot: topNavigation**
- ref: `design_system/docs/components/25-top-navigation.md`
- title: `Entries`
- title-color: `color/label/strong`
- background: `color/background/normal/normal`

### Region: Summary

#### Layout 토큰
- container-padding: `spacing/24`
- section-gap: `spacing/12`

**Slot: totalCount**
- ref: `design_system/docs/components/16-label.md`
- text-variant: `text/body2`
- color: `color/label/neutral`
- content: `{{entries.length}} lines saved`

**Slot: monthChip**
- ref: `design_system/docs/components/04-chip.md`
- repeat: `{{availableMonths}}`
- variant: `assistive`
- selected-variant: `primary`
- label: `{{month | format("MMM yyyy")}}`
- on-tap: `state-update → selectedMonth = month`

### Region: EntryList

#### Layout 토큰
- container-padding: `spacing/24`
- group-gap: `spacing/24`
- card-gap: `spacing/12`
- bottom-padding: `spacing/96`

**Slot: monthLabel**
- ref: `design_system/docs/components/16-label.md`
- repeat: `{{entries | groupByMonth}}`
- text-variant: `text/heading2`
- color: `color/label/strong`
- content: `{{group.month | format("MMMM yyyy")}}`

**Slot: entryCard**
- ref: `design_system/docs/components/06-card.md`
- repeat: `{{group.entries}}`
- background: `color/background/elevated/normal`
- radius: `radius/lg`
- on-tap: `screen-flow → 06-edit-entry.md (date: entry.date)`
- title: `{{entry.date | format("EEE, MMM d")}}`
- body: `{{entry.text}}`
- body-text-variant: `text/body1`
- body-color: `color/label/normal`
- meta: `{{entry.updatedAt | relativeTime}}`
- meta-color: `color/label/assistive`

**Slot: emptyView**
- ref: `design_system/docs/components/22-fallback-view.md`
- state: visible when `{{entries.length == 0}}`
- title: `No lines yet`
- description: `Today 탭에서 첫 한 줄을 저장해보세요.`
- action-label: `Go to Today`
- action-ref: `design_system/docs/components/01-button.md`
- on-action: `screen-flow → 01-today.md`

### Region: AdSlot

**Slot: bannerReserve**
- ref: `<Custom name="AdBannerReserve">`
- state: visible when `{{ads.enabled && entries.length > 0}}`
- placement: `entries.bottom`
- reserved-background: `color/background/normal/alternative`
- separator-color: `color/line/normal/normal`

### Region: Footer

**Slot: bottomNavigation**
- ref: `design_system/docs/components/23-bottom-navigation.md`
- variant: `with-label`
- active: `Entries`
- items: `Today`, `Calendar`, `Entries`, `Search`, `Settings`

---

## 3. Intent

### 사용자 의도

사용자는 기록을 시간순으로 다시 읽고, 필요한 기록을 선택해 수정한다.

### 진입 / 이탈

- **진입**: 하단 탭 Entries 선택
- **이탈**: 기록 카드 탭 → `06-edit-entry.md`; 빈 상태 CTA → `01-today.md`; 하단 탭 선택 → 다른 주요 화면

### 핵심 액션 우선순위

1. 전체 기록 훑기
2. 특정 기록 열기
3. 월 필터로 범위 좁히기

### 접근성

- **포커스 순서**: topNavigation → totalCount → monthChip 목록 → monthLabel → entryCard 목록 → AdSlot → bottomNavigation
- **스크린리더 의도**: 각 기록의 날짜와 본문을 하나의 선택 가능한 항목으로 전달한다.
- **Reduced motion**: 월 필터 변경 시 목록 변화가 텍스트와 선택 상태로도 전달되어야 한다.
- **터치 타겟**: 카드 전체가 선택 영역이다.

### Reactive Behavior

- 데이터 로딩 중: `21-skeleton.md` 기반 카드 placeholder 표시
- 빈 상태: `22-fallback-view.md`와 Today 이동 CTA 표시
- 에러: `08-snackbar.md` error 메시지와 재시도 안내

---

## 검증 체크리스트

- [x] 전체 목록과 빈 상태가 모두 명시됨
- [x] 광고 슬롯이 목록 하단으로 제한됨
- [x] 기록 카드 탭 플로우가 정의됨
