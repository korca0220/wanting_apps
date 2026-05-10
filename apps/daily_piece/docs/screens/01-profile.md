---
name: Profile
extends: design_system
imports: []
source:
  type: figma
  url: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece
  node_id: 2:4
  link: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece?node-id=2-4&t=2SsB9yTpe6fjdj7N-4
viewport:
  primary: mobile
  responsive: [mobile]
---

# Screen: Profile

## 개요

사용자 본인의 프로필을 확인하고, 데이터 내보내기·테마·계정 관리(로그아웃·삭제)를 수행하는 설정 화면. DailyPiece v1.0.0의 4개 메인 탭 중 하나.

> ⚠️ **본 명세는 sparse metadata 기반의 시범 작성**입니다. Figma `get_design_context` 응답이 응답 크기 한도로 잘려 (a) 정확한 색상 매핑은 추정값, (b) 일부 슬롯의 실제 컴포넌트 형태는 wds 카탈로그와의 휴리스틱 매칭. 정확도를 위해선 sub-layer별 추가 콜 필요.

---

## 1. Skeleton (구조 골격)

```
Page (viewport: mobile, 375×918)
├── Region: Header
│   └── Section: TopBar
│       ├── Slot: title
│       │   ↳ component: design_system/docs/components/16-label.md
│       └── (검수 필요) — 좌/우 액션 버튼 미식별
├── Region: Content (스크롤 가능, 24px padding)
│   ├── Section: ProfileHeader
│   │   ├── Slot: avatar
│   │   │   ↳ component: design_system/docs/components/15-avatar.md
│   │   ├── Slot: name
│   │   │   ↳ component: design_system/docs/components/16-label.md
│   │   ├── Slot: email
│   │   │   ↳ component: design_system/docs/components/16-label.md
│   │   └── Section: MemberSince
│   │       ├── Slot: caption
│   │       │   ↳ component: design_system/docs/components/16-label.md
│   │       └── Slot: value
│   │           ↳ component: design_system/docs/components/16-label.md
│   ├── Section: SettingsGroup
│   │   ├── Slot: groupTitle
│   │   │   ↳ component: design_system/docs/components/16-label.md
│   │   ├── Slot: divider
│   │   │   ↳ component: design_system/docs/components/17-divider.md
│   │   ├── Section: ExportRow
│   │   │   ↳ component: design_system/docs/components/24-list-item.md (variant: nested-action)
│   │   └── Section: ThemeRow
│   │       ↳ component: design_system/docs/components/24-list-item.md (variant: with-control)
│   ├── Section: AccountGroup
│   │   ├── Slot: groupTitle
│   │   │   ↳ component: design_system/docs/components/16-label.md
│   │   ├── Slot: signOutButton
│   │   │   ↳ component: design_system/docs/components/01-button.md
│   │   └── Slot: deleteButton
│   │       ↳ component: design_system/docs/components/01-button.md
│   └── Section: VersionFooter
│       └── Slot: version
│           ↳ component: design_system/docs/components/16-label.md
└── Region: Footer (BottomNav, 화면 하단 고정)
    ↳ component: design_system/docs/components/23-bottom-navigation.md
    └── (반복) items × 4 (slot: items)
```

---

## 2. Bindings (구체값 결합)

### Region: Header

#### Section: TopBar

**Slot: title**

- ref: `design_system/docs/components/16-label.md`
- text-variant: `text/heading2`
- color: `color/label/normal`
- content: `Profile`

#### Layout 토큰 (TopBar)

- height: 65 (Figma 추정 — 검수 필요)
- padding-x: `spacing/16`

---

### Region: Content

#### Layout 토큰 (Content)

- container-padding: `spacing/24`
- region-gap: `spacing/24`
- section-gap: `spacing/16`

#### Section: ProfileHeader

**Slot: avatar**

- ref: `design_system/docs/components/15-avatar.md`
- variant: `person`
- size: `xlarge` (~80px)
- src: `{{user.avatarUrl}}`
- alt: `{{user.name}}`

**Slot: name**

- ref: `design_system/docs/components/16-label.md`
- text-variant: `text/heading2`
- color: `color/label/normal`
- content: `{{user.name}}` (예: "Sarah Johnson")

**Slot: email**

- ref: `design_system/docs/components/16-label.md`
- text-variant: `text/body2`
- color: `color/label/alternative`
- content: `{{user.email}}`

##### Section: MemberSince

**Slot: caption**

- text-variant: `text/label2`
- color: `color/label/alternative`
- content: `Member since`

**Slot: value**

- text-variant: `text/label1`
- color: `color/label/normal`
- content: `{{user.joinedAt | format("MMMM yyyy")}}` (예: "January 2026")

#### Section: SettingsGroup

**Slot: groupTitle**

- ref: `design_system/docs/components/16-label.md`
- text-variant: `text/label1`
- color: `color/label/alternative`
- content: `Settings`

**Slot: divider**

- ref: `design_system/docs/components/17-divider.md`
- color: `color/line/normal/neutral`
- thickness: `1px`

##### Section: ExportRow

- ref: `design_system/docs/components/24-list-item.md`
- variant: `nested-action`
- on-tap: `api: GET /export → state: downloading=true`

ListItem 슬롯 바인딩:

- **leading**: (없음)
- **content title**: `Export Data` (text/body1, color/label/normal)
- **content caption**: `Download your archive` (text/label2, color/label/alternative)
- **trailing**: IconButton (variant=normal, size=medium, icon=chevron-right, aria-label="Export Data")

##### Section: ThemeRow

- ref: `design_system/docs/components/24-list-item.md`
- variant: `with-control`

ListItem 슬롯 바인딩:

- **leading**: (없음)
- **content title**: `App Theme`
- **content caption**: `Dark Mode (locked)` (현재 화면에서 잠긴 상태)
- **trailing**: Switch (size=medium, value={{settings.darkMode}}, disabled=true)
- on-change: `state: settings.darkMode = $value` (Switch 토글 시)

#### Section: AccountGroup

**Slot: groupTitle**

- text-variant: `text/label1`
- color: `color/label/alternative`
- content: `Account`

**Slot: signOutButton**

- ref: `design_system/docs/components/01-button.md`
- variant: `outlined`
- color: `assistive`
- size: `medium`
- fullWidth: `true`
- content: `Sign Out`
- on-tap: `api: POST /auth/signout → screen-flow → app-init`

**Slot: deleteButton**

- ref: `design_system/docs/components/01-button.md`
- variant: `outlined`
- color: `assistive` # 시각적 secondary, 위험 인지는 Alert 다이얼로그에서 처리
- size: `medium`
- fullWidth: `true`
- content: `Delete Account`
- caption: `Permanently remove your data` (버튼 하단 보조 텍스트)
- on-tap: `screen-flow → confirm: components/18-alert.md (variant=negative)`

#### Section: VersionFooter

**Slot: version**

- text-variant: `text/caption1`
- color: `color/label/assistive`
- content: `DailyPiece v1.0.0`

---

### Region: Footer (BottomNav)

- ref: `design_system/docs/components/23-bottom-navigation.md`
- variant: `with-label`

#### (반복) items × 4

각 아이템 (My Pieces / Calendar / Search / Profile):

- bindings (per item, BottomNavigationItem 슬롯):
  - icon: `{{item.icon}}`
  - activeIcon: `{{item.activeIcon}}`
  - label: `{{item.label}}`
  - route: `{{item.route}}`
  - active: `{{item.route === currentRoute}}`
  - on-tap: `screen-flow → {{item.route}}`

데이터:

```
[
  { icon: 'image-stack',  activeIcon: 'image-stack-fill', label: 'My Pieces', route: 'my-pieces' },
  { icon: 'calendar',     activeIcon: 'calendar-fill',    label: 'Calendar',  route: 'calendar'  },
  { icon: 'search',       activeIcon: 'search-fill',      label: 'Search',    route: 'search'    },
  { icon: 'user-circle',  activeIcon: 'user-circle-fill', label: 'Profile',   route: 'profile'   },   // current
]
```

---

## 3. Intent (의도 / 접근성 / 플로우)

### 사용자 의도

사용자는 본인 정보를 확인하고, 앱 데이터 내보내기·테마·로그아웃 등 **빈번하지 않지만 중요한** 계정 액션을 수행한다. 단순 정보 확인보다 작업 트리거 화면.

### 진입 / 이탈

- **진입**: BottomNav의 Profile 탭 클릭
- **이탈**:
  - Export Data 트리거 → 인앱 다운로드 (현재 화면 유지)
  - Sign Out → 로그인 화면으로 전이
  - Delete Account → Alert 다이얼로그 (negative variant) → 확인 시 계정 삭제
  - 다른 BottomNav 탭 → 해당 화면으로 전이

### 핵심 액션 우선순위

1. **Export Data** (정상 사용자가 가장 자주 트리거)
2. **App Theme 토글** (테마는 본 버전에서 잠겼으나 향후 활성)
3. **Sign Out** (계정 보호)
4. **Delete Account** (가장 위험 — 시각적으로 강조하지 않고 Account 그룹 하단에 배치)

### 접근성

- **포커스 순서**: Header title → ProfileHeader (avatar→name→email) → SettingsGroup (Export → Theme switch) → AccountGroup (SignOut → Delete) → BottomNav 4 items
- **스크린리더 의도**: "프로필 화면. {사용자 이름}. {이메일}. 가입일 {날짜}. 설정과 계정 관리." 같이 위계 그대로 읽힘
- **터치 타겟**: 모든 인터랙티브 요소 ≥ 44×44px. ExportRow의 chevron 트리거는 행 전체를 터치 영역으로.
- **Reduced motion**: BottomNav 탭 전환 시 transition 비활성, 즉시 표시.
- **Delete Account 보호**: Alert 다이얼로그(negative variant)에서 outsideClick 닫기 비활성 권장.

### Reactive Behavior

- **데이터 로딩 중**: ProfileHeader 영역에 Skeleton(circle 80px + text 2줄) 사용. SettingsGroup/AccountGroup은 정적이라 즉시 렌더 가능.
- **빈 상태**: 해당 없음 (Profile은 항상 데이터 있음. 로그아웃 상태는 별도 인증 화면).
- **에러**:
  - Export 실패 → Snackbar variant=error, 화면 하단 표시 (`color/status/negative` 톤)
  - Sign Out 네트워크 실패 → Snackbar variant=error, 재시도 버튼 슬롯
- **잠긴 토글**: ThemeRow의 disabled switch는 시각적으로 흐려보이고 (`opacity 0.4`), 탭 시 Tooltip 또는 Snackbar로 "현재 버전에선 다크 모드 고정입니다" 안내.

---

## 검증 체크리스트

- [x] frontmatter 채워짐 (extends=wanted)
- [x] Skeleton 5단계 위계 준수
- [x] 모든 Slot이 component 또는 `<Custom>`로 끝남
- [x] 컴포넌트 참조 경로가 실제 파일에 매칭 (15-avatar, 16-label, 17-divider, 09-icon-button, 13-switch, 01-button)
- [x] Bindings에 raw hex/픽셀 없음 (단, Header height 65, Avatar size ~80은 추정 metadata로 표기)
- [x] 인터랙티브 슬롯에 on-tap/on-change 모두 명시
- [ ] 사용된 모든 토큰이 wanted foundations에 존재 (대부분 ✓, 일부 추정 — `text/label2` `color/label/assistive` 등은 foundations 확인 필요)
- [x] 데이터 바인딩 `{{...}}` path 일관성

> ✅ **BottomNav 컴포넌트 명세 완료** ([23-bottom-navigation.md](../../design_system/docs/components/23-bottom-navigation.md)) — 본 화면이 첫 사용 사례.
