---
name: Search
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

# Screen: Search

## 개요

Search는 사용자가 저장한 한 줄 기록을 키워드로 찾는 화면이다. v1 검색은 로컬 텍스트 포함 검색으로 제한하며, 복잡한 필터나 추천 검색어는 제공하지 않는다.

---

## 1. Skeleton

```
Page (viewport: mobile)
├── Region: Header
│   └── Slot: topNavigation
│       ↳ component: design_system/docs/components/25-top-navigation.md
├── Region: SearchInput
│   ├── Slot: queryField
│   │   ↳ component: design_system/docs/components/02-text-field.md
│   └── Slot: clearButton
│       ↳ component: design_system/docs/components/09-icon-button.md
├── Region: SearchState
│   ├── Slot: helperText
│   │   ↳ component: design_system/docs/components/16-label.md
│   ├── Slot: resultCard
│   │   ↳ component: design_system/docs/components/06-card.md
│   ├── Slot: emptyResult
│   │   ↳ component: design_system/docs/components/22-fallback-view.md
│   └── Slot: initialState
│       ↳ component: design_system/docs/components/22-fallback-view.md
└── Region: Footer
    └── Slot: bottomNavigation
        ↳ component: design_system/docs/components/23-bottom-navigation.md
```

---

## 2. Bindings

### Region: Header

**Slot: topNavigation**
- ref: `design_system/docs/components/25-top-navigation.md`
- title: `Search`
- title-color: `color/label/strong`
- background: `color/background/normal/normal`

### Region: SearchInput

#### Layout 토큰
- container-padding: `spacing/24`
- field-gap: `spacing/8`
- background: `color/background/normal/normal`

**Slot: queryField**
- ref: `design_system/docs/components/02-text-field.md`
- placeholder: `Search your lines`
- value: `{{query}}`
- leading-icon: `search`
- trailing: `clearButton` when `{{query.length > 0}}`
- on-change: `state-update → query`

**Slot: clearButton**
- ref: `design_system/docs/components/09-icon-button.md`
- state: visible when `{{query.length > 0}}`
- icon: `x`
- aria-label: `Clear search`
- on-tap: `state-update → query = ""`

### Region: SearchState

#### Layout 토큰
- container-padding: `spacing/24`
- section-gap: `spacing/12`
- bottom-padding: `spacing/96`

**Slot: helperText**
- ref: `design_system/docs/components/16-label.md`
- text-variant: `text/caption1`
- color: `color/label/alternative`
- content when query exists: `{{results.length}} results for “{{query}}”`
- content when query empty: `단어를 입력하면 저장된 한 줄에서 찾아드려요.`

**Slot: resultCard**
- ref: `design_system/docs/components/06-card.md`
- state: visible when `{{query.length > 0 && results.length > 0}}`
- repeat: `{{results}}`
- background: `color/background/elevated/normal`
- radius: `radius/lg`
- on-tap: `screen-flow → 06-edit-entry.md (date: entry.date)`
- title: `{{entry.date | format("MMM d, yyyy")}}`
- body: `{{entry.text | highlight(query)}}`
- highlight-color: `color/primary/normal`

**Slot: emptyResult**
- ref: `design_system/docs/components/22-fallback-view.md`
- state: visible when `{{query.length > 0 && results.length == 0}}`
- title: `No matching lines`
- description: `다른 단어로 검색해보세요.`
- action: none

**Slot: initialState**
- ref: `design_system/docs/components/22-fallback-view.md`
- state: visible when `{{query.length == 0}}`
- title: `Find a past line`
- description: `기억나는 단어를 입력해 예전 기록을 찾아보세요.`
- action: none

### Region: Footer

**Slot: bottomNavigation**
- ref: `design_system/docs/components/23-bottom-navigation.md`
- variant: `with-label`
- active: `Search`
- items: `Today`, `Calendar`, `Entries`, `Search`, `Settings`

---

## 3. Intent

### 사용자 의도

사용자는 특정 단어가 들어간 과거 기록을 빠르게 찾고, 해당 기록을 다시 열어 확인하거나 수정한다.

### 진입 / 이탈

- **진입**: 하단 탭 Search 선택
- **이탈**: 검색 결과 탭 → `06-edit-entry.md`; 하단 탭 선택 → 다른 주요 화면

### 핵심 액션 우선순위

1. 검색어 입력
2. 결과 확인
3. 결과 기록 열기

### 접근성

- **포커스 순서**: topNavigation → queryField → clearButton → helperText → resultCard 목록 → bottomNavigation
- **스크린리더 의도**: 검색어 입력 상태와 결과 개수를 즉시 전달한다.
- **Reduced motion**: 검색 결과 갱신은 애니메이션 없이도 목록 변화로 이해 가능해야 한다.
- **터치 타겟**: 결과 카드는 전체 선택 영역이다.

### Reactive Behavior

- 검색 중: 짧은 지연 중에도 입력 필드는 유지하고 결과 영역만 갱신
- 초기 상태: `22-fallback-view.md`로 검색 목적 안내
- 결과 없음: `22-fallback-view.md`로 대체 검색 안내
- 에러: 로컬 검색 실패 시 `08-snackbar.md` error 메시지

---

## 검증 체크리스트

- [x] 초기/결과/결과 없음 상태가 분리됨
- [x] 검색 결과에서 편집 시트로 이동하는 흐름이 명시됨
- [x] v1 검색 범위가 로컬 텍스트 검색으로 제한됨
