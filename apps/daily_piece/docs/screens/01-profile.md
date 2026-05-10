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

사용자 본인의 프로필을 확인하고, 데이터 내보내기·테마·계정 관리(로그아웃·삭제)를 수행하는 화면. DailyPiece v1.0.0의 4개 메인 탭 중 하나(My Pieces / Calendar / Search / **Profile**).

본 명세는 Figma `2:4` 풀 디자인 컨텍스트로 재작성되었다. 이전 sparse 추정과 차이점 — Sign Out / Delete Account가 **Button이 아니라 ListItem**, 세 영역이 모두 **rounded-card 컨테이너**, ThemeRow trailing이 **Switch가 아니라 라벨 + 자물쇠 아이콘**.

---

## 1. Skeleton

```
Page (viewport: mobile, 375×918)
├── Region: Header                        # 65px, bottom-border
│   └── Slot: title
│       ↳ component: design_system/docs/components/16-label.md
├── Region: Content                       # 24px padding, 카드 3개 + 버전 풋터
│   ├── Section: ProfileCard              # rounded-16 elevated card
│   │   ├── Section: Identity
│   │   │   ├── Slot: avatar              # 80×80 circle, primary ring + subtle bg
│   │   │   │   ↳ <Custom name="ProfileAvatar">
│   │   │   ├── Slot: name
│   │   │   │   ↳ component: design_system/docs/components/16-label.md
│   │   │   └── Slot: email
│   │   │       ↳ component: design_system/docs/components/16-label.md
│   │   └── Section: MemberSince          # top-divider, space-between row
│   │       ├── Slot: caption
│   │       │   ↳ component: design_system/docs/components/16-label.md
│   │       └── Slot: value
│   │           ↳ component: design_system/docs/components/16-label.md
│   ├── Section: SettingsCard             # rounded-16 elevated card
│   │   ├── Slot: groupHeader             # 57px row + bottom-border
│   │   │   ↳ component: design_system/docs/components/16-label.md
│   │   ├── Section: ExportRow            # ListItem with leading icon-tile
│   │   │   ↳ component: design_system/docs/components/24-list-item.md
│   │   └── Section: ThemeRow             # ListItem with leading icon-tile + trailing label
│   │       ↳ component: design_system/docs/components/24-list-item.md
│   ├── Section: AccountCard              # rounded-16 elevated card
│   │   ├── Slot: groupHeader
│   │   │   ↳ component: design_system/docs/components/16-label.md
│   │   ├── Section: SignOutRow           # ListItem (no caption, title centered)
│   │   │   ↳ component: design_system/docs/components/24-list-item.md
│   │   └── Section: DeleteAccountRow     # ListItem (negative-tinted)
│   │       ↳ component: design_system/docs/components/24-list-item.md
│   └── Section: VersionFooter
│       └── Slot: version
│           ↳ component: design_system/docs/components/16-label.md
└── Region: Footer (BottomNav, 105px)
    ↳ component: design_system/docs/components/23-bottom-navigation.md
    └── (반복) items × 4
```

---

## 2. Bindings

### Region: Header

#### Layout 토큰

- background: `color/background/normal/normal`
- height: 65
- bottom-border: `1px color/line/normal/neutral`
- padding-x: `spacing/24`

**Slot: title**

- ref: `design_system/docs/components/16-label.md`
- text-variant: `text/title2` (Inter Bold 24px, leading 32, tracking -0.26)
- color: `color/label/strong`
- content: `Profile`

---

### Region: Content

#### Layout 토큰

- container-padding: `spacing/24`
- card-gap: `spacing/24`

#### Section: ProfileCard

- container: rounded-16 card
- background: `color/background/elevated/normal`
- border: `1px color/line/normal/neutral`
- padding: `spacing/24`
- height: 183

##### Section: Identity

- layout: 가로 배치 (avatar 좌, 텍스트 우)
- gap: `spacing/16`

**Slot: avatar**

- ref: `<Custom name="ProfileAvatar">`
- size: 80×80
- shape: circle
- background: `color/primary/subtle` (rgba(51,133,255,0.2))
- ring: `2px color/primary/normal`
- inner-icon: person glyph
- inner-icon-color: `color/primary/normal`
- src: `{{user.avatarUrl}}` (있으면 이미지로 대체)
- alt: `{{user.name}}`

> ⚠️ DS의 `15-avatar.md`는 사진 표시용. Figma의 "primary subtle bg + ring + inner icon"은 별도 패턴이라 `<Custom>`으로 두고 합류 후보로 검토.

**Slot: name**

- text-variant: `text/heading2` (Inter SemiBold 20px, leading 28, tracking -0.30)
- color: `color/label/strong`
- content: `{{user.name}}` (예: "Sarah Johnson")

**Slot: email**

- text-variant: `text/body2` (Inter Regular 14px, leading 20, tracking -0.22)
- color: `color/label/alternative`
- content: `{{user.email}}`

##### Section: MemberSince

- layout: top-divider + 단일 행, `space-between`
- top-border: `1px color/line/normal/neutral`
- height: 37
- padding-top: `spacing/16`

**Slot: caption**

- text-variant: `text/body2`
- color: `color/label/alternative`
- content: `Member since`

**Slot: value**

- text-variant: `text/label1` (Inter SemiBold 14px, leading 20, tracking -0.36)
- color: `color/label/strong`
- content: `{{user.joinedAt | format("MMMM yyyy")}}` (예: "January 2026")

---

#### Section: SettingsCard

- container: rounded-16 card (background `color/background/elevated/normal`, border `1px color/line/normal/neutral`)
- height: 208

**Slot: groupHeader**

- height: 57
- bottom-border: `1px color/line/normal/neutral`
- padding-left: `spacing/24`
- padding-y: `spacing/16`
- text-variant: `text/heading3` (Inter SemiBold 16px, leading 24, tracking -0.34)
- color: `color/label/strong`
- content: `Settings`

##### Section: ExportRow

- ref: `design_system/docs/components/24-list-item.md`
- variant: `with-leading-tile` (icon-tile + title + caption + trailing chevron)
- height: 74
- padding-x: `spacing/24`
- on-tap: `api: GET /export → state: downloading=true`

ListItem 슬롯 바인딩:

- **leading**: 40×40 square `radius/lg`(12px) tile, bg `color/primary/subtle`, inner SVG (download glyph 18×18, color `color/primary/normal`)
- **title**: `Export Data` — `text/heading3`, `color/label/strong`
- **caption**: `Download your archive` — `text/caption1` (Inter Regular 12px, leading 16, tracking -0.26), `color/label/alternative`
- **trailing**: chevron-right icon (8.75×14, color `color/label/alternative`)

##### Section: ThemeRow

- ref: `design_system/docs/components/24-list-item.md`
- variant: `with-leading-tile`
- height: 75
- top-border: `1px color/line/normal/neutral`
- background: `color/background/elevated/alternative` (rgba(33,34,37,0.5)) — locked 시각적 차이
- padding-x: `spacing/24`
- on-tap: 잠금 상태에선 비활성. 향후 활성 시 ThemePicker 시트 / 라우트.

ListItem 슬롯 바인딩:

- **leading**: 40×40 `radius/lg` tile, bg `color/fill/alternative` (rgba(55,56,60,0.3)), inner SVG (moon glyph)
- **title**: `App Theme` — `text/heading3`, `color/label/strong`
- **caption**: `Dark Mode (locked)` — `text/caption1`, `color/label/alternative`
- **trailing**: 라벨 "Dark" (`text/body2`, `color/label/alternative`) + lock 아이콘 (12.25×14, color `color/label/alternative`)

---

#### Section: AccountCard

- container: rounded-16 card (background `color/background/elevated/normal`, border `1px color/line/normal/neutral`)
- height: 206

**Slot: groupHeader**

- 동일 스타일(57 height + bottom-border)
- content: `Account`

##### Section: SignOutRow

- ref: `design_system/docs/components/24-list-item.md`
- variant: `with-leading-tile-centered` (caption 없음, title 중앙 정렬)
- height: 72
- on-tap: `api: POST /auth/signout → state: auth.session=null → screen-flow → 11-welcome.md`

ListItem 슬롯 바인딩:

- **leading**: 40×40 `radius/lg` tile, bg `color/primary/subtle`, inner SVG (logout glyph 18×18, color `color/primary/normal`)
- **title**: `Sign Out` — `text/heading3`, `color/label/strong`, **center 정렬** (행 가운데)
- **caption**: (없음)
- **trailing**: chevron-right

##### Section: DeleteAccountRow

- ref: `design_system/docs/components/24-list-item.md`
- variant: `with-leading-tile`
- height: 75
- top-border: `1px color/line/normal/neutral`
- on-tap: `screen-flow → confirm: 18-alert.md (variant=negative)` → 확인 시 `api: DELETE /auth/account → screen-flow → 11-welcome.md`

ListItem 슬롯 바인딩:

- **leading**: 40×40 `radius/lg` tile, bg `color/status/negative-subtle` (rgba(239,68,68,0.1)), inner SVG (trash glyph 15.75×18, color `color/status/negative`)
- **title**: `Delete Account` — `text/heading3`, **`color/status/negative`**
- **caption**: `Permanently remove your data` — `text/caption1`, `color/label/alternative`
- **trailing**: chevron-right

---

#### Section: VersionFooter

- height: 40
- align: center
- padding-y: `spacing/16`

**Slot: version**

- text-variant: `text/caption1`
- color: `color/label/alternative`
- content: `DailyPiece v1.0.0`

---

### Region: Footer (BottomNav)

- ref: `design_system/docs/components/23-bottom-navigation.md`
- variant: `with-label`
- height: 105 (105 = 80 inner + bottom safe-area + paddings)
- background: `color/background/elevated/normal`
- top-border: `1px color/line/normal/neutral`

#### items × 4

| index | label | icon (inactive) | activeIcon | route | active? |
|---|---|---|---|---|---|
| 0 | My Pieces | image-stack | image-stack-fill | `my-pieces` | — |
| 1 | Calendar | calendar | calendar-fill | `calendar` | — |
| 2 | Search | search | search-fill | `search` | — |
| 3 | Profile | user-circle | user-circle-fill | `profile` | ✓ (current) |

- inactive label color: `color/label/alternative`
- active label color: `color/primary/normal`
- on-tap: `screen-flow → {{item.route}}`

> ⚠️ **현재 구현은 3-탭** (Today / Collection / Settings) — 명세의 4-탭과 차이. 별도 결정 필요.

---

## 3. Intent

### 사용자 의도

본인 정보 확인 + 데이터 내보내기·테마·로그아웃·계정 삭제 같은 빈번하지 않지만 중요한 액션 트리거.

### 진입 / 이탈

- **진입**: BottomNav의 Profile 탭 클릭
- **이탈**:
  - Export Data → 인앱 다운로드 (현 화면 유지)
  - Sign Out → `11-welcome.md`로 전이
  - Delete Account → Alert(negative) → 확인 시 계정 삭제 → `11-welcome.md`
  - 다른 BottomNav 탭 → 해당 화면

### 핵심 액션 우선순위

1. **Export Data** (정상 사용자가 가장 자주 트리거)
2. **Sign Out**
3. **Delete Account** (가장 위험 — 빨강으로 시각적 경고, Alert로 보호)

(App Theme은 잠긴 상태라 우선순위 외)

### 접근성

- **포커스 순서**: Header title → ProfileCard (avatar→name→email→memberSince) → SettingsCard (Export → Theme) → AccountCard (Sign Out → Delete Account) → VersionFooter → BottomNav 4 items
- **스크린리더 의도**: "프로필. {사용자 이름}. {이메일}. 가입일 {날짜}. 설정과 계정."
- **터치 타겟**: 모든 행 ≥ 72px 높이 (Figma 실측 72~75) — 충분
- **Reduced motion**: 카드 등장 모션 등이 추가될 경우 prefers-reduced-motion 시 즉시 표시
- **Delete Account 보호**: Alert 다이얼로그(negative variant)에서 outsideClick 닫기 비활성

### Reactive Behavior

- **데이터 로딩 중**: ProfileCard Identity 영역에 Skeleton(circle 80 + text 2줄). Settings/Account는 정적이라 즉시 렌더.
- **빈 상태**: 해당 없음. 로그아웃 상태는 `11-welcome.md`로 라우팅됨.
- **에러**:
  - Export 실패 → Snackbar variant=error
  - Sign Out 네트워크 실패 → Snackbar variant=error + 재시도
- **잠긴 토글**: ThemeRow는 시각적으로 다른 배경 + 캡션 "(locked)" + trailing에 자물쇠. 탭 시 Tooltip / Snackbar.

---

## 검증 체크리스트

- [x] frontmatter 채워짐
- [x] Skeleton 위계 (Header / Content with 3 cards + footer / BottomNav)
- [x] 모든 Slot이 component 또는 `<Custom>`로 끝남
- [x] Sign Out / Delete Account가 ListItem (Button 오기 수정)
- [x] 세 영역 모두 rounded-card 컨테이너 명시
- [x] ThemeRow trailing이 라벨 + 자물쇠 (Switch 오기 수정)
- [x] 모든 ListItem leading 아이콘 타일 명시
- [x] 인터랙티브 슬롯에 on-tap/on-change 명시
- [ ] 사용된 모든 토큰이 design_system foundations에 존재 — `color/primary/subtle`, `color/fill/alternative`, `color/status/negative-subtle` 확인 필요
- [ ] DS의 `24-list-item.md` variants에 `with-leading-tile` / `with-leading-tile-centered` 정의 (없으면 합류 후보)

---

## 구현 갭 (현 코드 vs 본 명세)

| 항목 | 명세 | 현 구현 |
|---|---|---|
| 라우트 / 디렉토리 | `Profile` (`/profile`, `features/profile/`) | `Settings` (`/settings`, `features/settings/`) |
| BottomNav | 4-탭 (My Pieces / Calendar / Search / Profile) | 3-탭 (Today / Collection / Settings) |
| 프로필 카드 | 아바타 + 이름 + 이메일 + 가입일 | 없음 |
| Export Data | ListItem (icon-tile + chevron) | 없음 |
| ThemeRow | ListItem + locked 라벨 (Dark 고정) | RadioGroup 3-옵션 (System/Light/Dark) — 명세보다 풍부 |
| Sign Out | ListItem (icon-tile, center title, chevron) | ListTile + 확인 다이얼로그 |
| Delete Account | ListItem (red title + caption) | 없음 |
| VersionFooter | "DailyPiece v1.0.0" | 없음 |

> **핸드오프 결정 사항**: 위 갭 중 어느 것을 명세 쪽으로 가져갈지(혹은 명세를 현 구현에 맞춰 단순화할지)는 별도 결정.
