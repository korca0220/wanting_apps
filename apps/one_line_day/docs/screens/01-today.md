---
name: Today
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

# Screen: Today

## 개요

Today는 OneLine Day의 시작 화면이다. 사용자는 앱을 열자마자 오늘 날짜와 기록 상태를 확인하고, 아직 비어 있으면 한 줄을 작성하며, 이미 작성했다면 저장된 문장을 읽거나 수정한다.

---

## 1. Skeleton

```
Page (viewport: mobile)
├── Region: Header
│   └── Slot: topNavigation
│       ↳ component: design_system/docs/components/25-top-navigation.md
├── Region: TodayStatus
│   ├── Section: DateHero
│   │   ├── Slot: eyebrow
│   │   │   ↳ component: design_system/docs/components/16-label.md
│   │   ├── Slot: title
│   │   │   ↳ component: design_system/docs/components/16-label.md
│   │   └── Slot: helper
│   │       ↳ component: design_system/docs/components/16-label.md
│   └── Section: EntryCard
│       ├── Slot: emptyPrompt
│       │   ↳ component: design_system/docs/components/10-textarea.md
│       ├── Slot: savedLine
│       │   ↳ component: design_system/docs/components/06-card.md
│       ├── Slot: characterCount
│       │   ↳ component: design_system/docs/components/16-label.md
│       └── Slot: primaryAction
│           ↳ component: design_system/docs/components/01-button.md
├── Region: RecentEntries
│   ├── Slot: sectionTitle
│   │   ↳ component: design_system/docs/components/16-label.md
│   ├── Slot: recentEntryCard
│   │   ↳ component: design_system/docs/components/06-card.md
│   └── Slot: emptyRecent
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
- title: `OneLine Day`
- title-color: `color/label/strong`
- background: `color/background/normal/normal`
- trailing: none

### Region: TodayStatus

#### Layout 토큰
- container-padding: `spacing/24`
- section-gap: `spacing/20`
- card-gap: `spacing/12`
- background: `color/background/normal/normal`

**Slot: eyebrow**
- ref: `design_system/docs/components/16-label.md`
- text-variant: `text/caption1`
- color: `color/label/alternative`
- content: `{{today | format("EEEE")}}`

**Slot: title**
- ref: `design_system/docs/components/16-label.md`
- text-variant: `text/title2`
- color: `color/label/strong`
- content: `{{today | format("MMMM d")}}`

**Slot: helper**
- ref: `design_system/docs/components/16-label.md`
- text-variant: `text/body2`
- color: `color/label/neutral`
- content when empty: `오늘을 한 줄로 남겨보세요.`
- content when saved: `오늘의 한 줄이 저장되어 있어요.`

**Slot: emptyPrompt**
- ref: `design_system/docs/components/10-textarea.md`
- state: visible when `{{todayEntry == null}}`
- placeholder: `오늘은 어떤 하루였나요?`
- value: `{{draft.text}}`
- max-length: `200`
- on-change: `state-update → draft.text`

**Slot: savedLine**
- ref: `design_system/docs/components/06-card.md`
- state: visible when `{{todayEntry != null}}`
- background: `color/background/elevated/normal`
- radius: `radius/lg`
- on-tap: `screen-flow → 06-edit-entry.md (date: today)`
- content: `{{todayEntry.text}}`

**Slot: characterCount**
- ref: `design_system/docs/components/16-label.md`
- state: visible when editing inline
- text-variant: `text/caption1`
- color: `color/label/assistive`
- content: `{{draft.text.length}} / 200`

**Slot: primaryAction**
- ref: `design_system/docs/components/01-button.md`
- variant when empty: `solid-primary`
- variant when saved: `outline`
- label when empty: `Save today`
- label when saved: `Edit`
- disabled: `{{draft.text.trim().length == 0}}`
- on-tap when empty: `data-action → saveEntry(date: today, text: draft.text)`
- on-tap when saved: `screen-flow → 06-edit-entry.md (date: today)`

### Region: RecentEntries

#### Layout 토큰
- container-padding: `spacing/24`
- section-gap: `spacing/12`
- top-padding: `spacing/24`

**Slot: sectionTitle**
- ref: `design_system/docs/components/16-label.md`
- text-variant: `text/heading2`
- color: `color/label/strong`
- content: `Recent lines`

**Slot: recentEntryCard**
- ref: `design_system/docs/components/06-card.md`
- repeat: `{{recentEntries | limit(3)}}`
- background: `color/background/elevated/normal`
- radius: `radius/lg`
- on-tap: `screen-flow → 06-edit-entry.md (date: entry.date)`
- title: `{{entry.date | format("MMM d")}}`
- body: `{{entry.text}}`

**Slot: emptyRecent**
- ref: `design_system/docs/components/22-fallback-view.md`
- state: visible when `{{recentEntries.length == 0 && todayEntry == null}}`
- title: `아직 기록이 없어요`
- description: `오늘의 첫 한 줄부터 시작해보세요.`
- action: none

### Region: AdSlot

**Slot: bannerReserve**
- ref: `<Custom name="AdBannerReserve">`
- state: visible when `{{ads.enabled}}`
- placement: `today.bottom`
- reserved-background: `color/background/normal/alternative`
- separator-color: `color/line/normal/normal`

### Region: Footer

**Slot: bottomNavigation**
- ref: `design_system/docs/components/23-bottom-navigation.md`
- variant: `with-label`
- active: `Today`
- items: `Today`, `Calendar`, `Entries`, `Search`, `Settings`

---

## 3. Intent

### 사용자 의도

사용자는 앱을 열고 오늘의 기록 여부를 즉시 확인한 뒤, 비어 있다면 부담 없이 한 줄을 저장한다.

### 진입 / 이탈

- **진입**: 앱 시작 / 하단 탭 Today 선택
- **이탈**: Edit 선택 → `06-edit-entry.md`; 하단 탭 선택 → Calendar, Entries, Search, Settings

### 핵심 액션 우선순위

1. 오늘 한 줄 저장
2. 오늘 기록 수정
3. 최근 기록 다시 열기

### 접근성

- **포커스 순서**: topNavigation → DateHero → EntryCard → primaryAction → RecentEntries → AdSlot → bottomNavigation
- **스크린리더 의도**: 오늘 날짜, 작성 상태, 저장 또는 수정 가능 여부를 먼저 전달한다.
- **Reduced motion**: 저장 완료 상태 전환은 색/문구 변경으로도 이해 가능해야 한다.
- **터치 타겟**: 모든 인터랙티브 요소는 DS 접근성 기준을 따른다.

### Reactive Behavior

- 데이터 로딩 중: EntryCard와 RecentEntries에 `21-skeleton.md` 기반 placeholder 표시
- 빈 상태: RecentEntries에 `22-fallback-view.md` 표시
- 저장 성공: `08-snackbar.md` success 메시지 `Saved.`
- 에러: `08-snackbar.md` error 메시지와 재시도 안내

---

## 검증 체크리스트

- [x] 오늘 작성/수정의 핵심 루프가 명시됨
- [x] 광고 슬롯이 CTA와 분리됨
- [x] DS 컴포넌트 참조 경로가 명시됨
- [x] Bindings는 semantic token만 참조함
