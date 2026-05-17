---
name: Settings
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

# Screen: Settings

## 개요

Settings는 앱 테마, 데이터 관리 진입점, 정책 링크, 버전 정보를 제공한다. v1은 계정이 없으므로 프로필이나 로그인 관리는 포함하지 않는다.

---

## 1. Skeleton

```
Page (viewport: mobile)
├── Region: Header
│   └── Slot: topNavigation
│       ↳ component: design_system/docs/components/25-top-navigation.md
├── Region: Preferences
│   ├── Slot: sectionTitle
│   │   ↳ component: design_system/docs/components/16-label.md
│   ├── Slot: themeModeItem
│   │   ↳ component: design_system/docs/components/24-list-item.md
│   └── Slot: divider
│       ↳ component: design_system/docs/components/17-divider.md
├── Region: Data
│   ├── Slot: sectionTitle
│   │   ↳ component: design_system/docs/components/16-label.md
│   ├── Slot: exportItem
│   │   ↳ component: design_system/docs/components/24-list-item.md
│   └── Slot: deleteAllItem
│       ↳ component: design_system/docs/components/24-list-item.md
├── Region: About
│   ├── Slot: privacyItem
│   │   ↳ component: design_system/docs/components/24-list-item.md
│   ├── Slot: termsItem
│   │   ↳ component: design_system/docs/components/24-list-item.md
│   └── Slot: versionLabel
│       ↳ component: design_system/docs/components/16-label.md
└── Region: Footer
    └── Slot: bottomNavigation
        ↳ component: design_system/docs/components/23-bottom-navigation.md
```

---

## 2. Bindings

### Region: Header

**Slot: topNavigation**
- ref: `design_system/docs/components/25-top-navigation.md`
- title: `Settings`
- title-color: `color/label/strong`
- background: `color/background/normal/normal`

### Region: Preferences

#### Layout 토큰
- container-padding: `spacing/24`
- section-gap: `spacing/12`

**Slot: sectionTitle**
- ref: `design_system/docs/components/16-label.md`
- text-variant: `text/caption1`
- color: `color/label/alternative`
- content: `Preferences`

**Slot: themeModeItem**
- ref: `design_system/docs/components/24-list-item.md`
- leading-icon: `moon`
- title: `App Theme`
- description: `{{settings.themeMode | label}}`
- trailing: `chevron-right`
- on-tap: `data-action → cycleThemeMode(system, light, dark)`

**Slot: divider**
- ref: `design_system/docs/components/17-divider.md`
- color: `color/line/normal/normal`

### Region: Data

#### Layout 토큰
- container-padding: `spacing/24`
- section-gap: `spacing/12`

**Slot: sectionTitle**
- ref: `design_system/docs/components/16-label.md`
- text-variant: `text/caption1`
- color: `color/label/alternative`
- content: `Data`

**Slot: exportItem**
- ref: `design_system/docs/components/24-list-item.md`
- leading-icon: `download`
- title: `Export Data`
- description: `v1.1 예정`
- trailing: `chevron-right`
- state: disabled in v1
- on-tap: none

**Slot: deleteAllItem**
- ref: `design_system/docs/components/24-list-item.md`
- leading-icon: `trash`
- title: `Delete All Lines`
- title-color: `color/status/negative`
- description: `기기에 저장된 기록을 모두 삭제합니다.`
- trailing: `chevron-right`
- on-tap: `screen-flow → confirm-delete-all alert`

### Region: About

#### Layout 토큰
- container-padding: `spacing/24`
- section-gap: `spacing/12`
- bottom-padding: `spacing/96`

**Slot: privacyItem**
- ref: `design_system/docs/components/24-list-item.md`
- leading-icon: `shield`
- title: `Privacy Policy`
- trailing: `external-link`
- on-tap: `external-flow → privacyPolicyUrl`

**Slot: termsItem**
- ref: `design_system/docs/components/24-list-item.md`
- leading-icon: `file-text`
- title: `Terms of Use`
- trailing: `external-link`
- on-tap: `external-flow → termsUrl`

**Slot: versionLabel**
- ref: `design_system/docs/components/16-label.md`
- text-variant: `text/caption1`
- color: `color/label/assistive`
- content: `OneLine Day {{app.version}}`

### Confirm delete all alert

- ref: `design_system/docs/components/18-alert.md`
- title: `Delete all lines?`
- description: `삭제한 기록은 되돌릴 수 없어요.`
- cancel-label: `Cancel`
- destructive-label: `Delete All`
- on-confirm: `data-action → deleteAllEntries()`

### Region: Footer

**Slot: bottomNavigation**
- ref: `design_system/docs/components/23-bottom-navigation.md`
- variant: `with-label`
- active: `Settings`
- items: `Today`, `Calendar`, `Entries`, `Search`, `Settings`

---

## 3. Intent

### 사용자 의도

사용자는 앱 사용 환경을 조정하고, 정책 정보와 데이터 관리 옵션을 확인한다.

### 진입 / 이탈

- **진입**: 하단 탭 Settings 선택
- **이탈**: 정책 링크 → 외부 문서; 하단 탭 선택 → 다른 주요 화면

### 핵심 액션 우선순위

1. 테마 변경
2. 개인정보/약관 확인
3. 전체 데이터 삭제 확인

### 접근성

- **포커스 순서**: topNavigation → Preferences items → Data items → About items → versionLabel → bottomNavigation
- **스크린리더 의도**: 각 설정 항목의 현재 상태와 비활성 여부를 읽어준다.
- **Reduced motion**: 테마 변경은 애니메이션 없이 즉시 반영되어도 이해 가능해야 한다.
- **터치 타겟**: 리스트 항목 전체가 선택 영역이다.

### Reactive Behavior

- 테마 변경 중: 즉시 상태 반영
- Export Data: v1에서는 disabled 상태 유지
- Delete All 성공: `08-snackbar.md` success 메시지 후 Today 빈 상태로 갱신
- Delete All 에러: `08-snackbar.md` error 메시지

---

## 검증 체크리스트

- [x] 계정 없는 설정 구조로 정의됨
- [x] 정책 링크와 AdMob 배포 준비 항목이 포함됨
- [x] 파괴적 액션은 alert 확인을 거침
