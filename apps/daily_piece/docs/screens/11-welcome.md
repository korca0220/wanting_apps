---
name: Welcome
extends: design_system
imports: []
source:
  type: figma
  url: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece
  node_id: "2:738"
  link: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece?node-id=2-738&t=2SsB9yTpe6fjdj7N-4
viewport:
  primary: mobile
  responsive: [mobile]
---

# Screen: Welcome

## 개요

미인증 상태로 앱을 켰을 때 보이는 진입 화면. 로고 + 타이틀 + 태그라인 + 가입/로그인 두 버튼. 정적 splash가 아니라 사용자가 다음 흐름을 직접 선택하는 landing page.

---

## 1. Skeleton

```
Page (viewport: mobile, 375×840)
└── Region: Body                          # 풀 배경 (dark surface)
    ├── Region: Hero                      # 화면 중앙 정렬, vertical center
    │   ├── Slot: logoMark
    │   │   ↳ <Custom name="AppLogoMark">
    │   ├── Slot: title
    │   │   ↳ component: design_system/docs/components/16-label.md
    │   └── Slot: tagline
    │       ↳ component: design_system/docs/components/16-label.md
    └── Region: Footer                    # bottom-aligned 액션
        ├── Slot: createAccountButton
        │   ↳ component: design_system/docs/components/01-button.md
        └── Slot: signInButton
            ↳ component: design_system/docs/components/01-button.md
```

---

## 2. Bindings

### Region: Body

#### Layout 토큰

- background: `color/background/normal/normal`
- container-padding: `spacing/24` (horizontal)
- vertical-distribution: `space-between` (Hero center / Footer bottom)

### Region: Hero

#### Layout 토큰

- align: `center`
- gap: `spacing/24` (logo ↔ text block)
- inner-gap: `spacing/12` (title ↔ tagline)

**Slot: logoMark**

- ref: `<Custom name="AppLogoMark">`
- size: 80×80
- shape: `radius/xl` (20px 모서리 라운드)
- background: `color/primary/normal`
- inner-icon: 40×40 photo glyph
- inner-icon-color: `color/static/white`

**Slot: title**

- text-variant: `text/title1`
- color: `color/label/strong`
- content: `DailyPiece`
- align: `center`

**Slot: tagline**

- text-variant: `text/body1`
- color: `color/label/alternative`
- content: `One photo + one caption per day`
- align: `center`
- max-width: 256

### Region: Footer

#### Layout 토큰

- gap: `spacing/12`
- bottom-padding: `spacing/48`

**Slot: createAccountButton**

- ref: `design_system/docs/components/01-button.md`
- variant: `solid`
- color: `primary`
- size: `large`
- fullWidth: `true`
- content: `Create Account`
- on-tap: `screen-flow → 08-create-account.md`

**Slot: signInButton**

- ref: `design_system/docs/components/01-button.md`
- variant: `outlined`
- size: `large`
- fullWidth: `true`
- content: `Sign In`
- on-tap: `screen-flow → 09-welcome-back.md`

---

## 3. Intent

### 사용자 의도

이 앱이 무엇인지 한눈에 파악하고(One photo + one caption per day), 가입할지 / 기존 계정으로 들어갈지 한 탭으로 선택한다.

### 진입 / 이탈

- **진입**: 앱 시작 시 세션이 없을 때 (로그아웃 상태 / 첫 실행).
- **이탈**:
  - Create Account → 08-create-account.md
  - Sign In → 09-welcome-back.md

### 핵심 액션 우선순위

1. **Create Account** (primary — 신규 사용자가 디폴트)
2. Sign In (보조 — 기존 사용자)

### 접근성

- **포커스 순서**: title → tagline → Create Account → Sign In
- **스크린리더 의도**: "DailyPiece. 하루 한 장 사진 한 줄 코멘트. 가입하기 또는 로그인."
- **터치 타겟**: 두 버튼 ≥ 48px (large size)
- **Reduced motion**: 로고 등장 애니메이션이 추가될 경우 prefers-reduced-motion 시 즉시 표시.

### Reactive Behavior

- **로딩 중 스플래시 단계**: 세션 부트스트랩(`Supabase.initialize`)이 끝나기 전이라면 이 화면 자체가 가려진 상태. 부트스트랩 완료 후 router redirect가 본 화면 또는 `/today`로 분기.
- **상시 정적 화면**: 별도 데이터 페치 없음. 빈 상태 / 에러 상태 없음.

---

## 검증 체크리스트

- [x] 위계 / Slot 종결 / Bindings Semantic
- [x] 두 버튼 모두 large + fullWidth
- [x] 로고는 `<Custom name="AppLogoMark">` (도메인 자산 — DS 합류 후보 아님)
- [x] 화면 흐름 — Create Account → 08, Sign In → 09
