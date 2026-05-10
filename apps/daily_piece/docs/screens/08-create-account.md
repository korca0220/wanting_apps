---
name: Create Account
extends: design_system
imports: []
source:
  type: figma
  url: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece
  node_id: "2:760"
  link: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece?node-id=2-760&t=2SsB9yTpe6fjdj7N-4
  spec_basis: screenshot
viewport:
  primary: mobile
  responsive: [mobile]
---

# Screen: Create Account (Sign Up)

## 개요

신규 사용자 가입 폼. 백 버튼 + 큰 헤더 + Name(Optional)/Email/Password/Confirm Password 4 필드 + Create Account primary + Sign In 링크 + 하단 ToS 안내.

---

## 1. Skeleton

```
Page (viewport: mobile)
├── Region: TopBar
│   └── Slot: backButton
│       ↳ component: design_system/docs/components/09-icon-button.md
├── Region: Header
│   ├── Slot: title
│   │   ↳ component: design_system/docs/components/16-label.md
│   └── Slot: subtitle
│       ↳ component: design_system/docs/components/16-label.md
├── Region: Form
│   ├── Section: NameField                  # Optional
│   │   ├── Slot: label
│   │   └── Slot: input
│   │       ↳ component: design_system/docs/components/02-text-field.md
│   ├── Section: EmailField
│   │   ├── Slot: label
│   │   └── Slot: input
│   │       ↳ component: design_system/docs/components/02-text-field.md
│   ├── Section: PasswordField
│   │   ├── Slot: label
│   │   └── Slot: input
│   │       ↳ component: design_system/docs/components/02-text-field.md
│   ├── Section: ConfirmPasswordField
│   │   ├── Slot: label
│   │   └── Slot: input
│   │       ↳ component: design_system/docs/components/02-text-field.md
│   ├── Slot: createAccountButton
│   │   ↳ component: design_system/docs/components/01-button.md
│   └── Section: SignInHint                 # "Already have an account? Sign In"
│       ├── Slot: hintText
│       └── Slot: signInLink
└── Region: LegalFooter
    └── Slot: termsText
```

---

## 2. Bindings

### Region: TopBar

(09-welcome-back.md TopBar와 동일)

**Slot: backButton**

- icon: `chevron-left`
- aria-label: `뒤로`
- on-tap: `screen-flow → pop` (← 11 Welcome)

### Region: Header

- container-padding: `spacing/24`
- gap: `spacing/8`
- top-padding: `spacing/16`

**Slot: title**

- text-variant: `text/title1` (Inter Bold ~32px)
- color: `color/label/strong`
- content: `Create Account`

**Slot: subtitle**

- text-variant: `text/body1`
- color: `color/label/alternative`
- content: `Start your daily photo journal`

### Region: Form

- container-padding: `spacing/24`
- field-gap: `spacing/16`
- top-padding: `spacing/32`

#### Section: NameField

**Slot: label**

- text-variant: `text/label1`
- color: `color/label/normal`
- content: `Name (Optional)`

**Slot: input**

- ref: `02-text-field.md`
- placeholder: `Enter your name`
- type: `text`
- value: `{{form.name}}`
- on-change: `state: form.name = $value`

#### Section: EmailField

- label: `Email`
- input placeholder: `your@email.com`, type `email`, keyboardType `emailAddress`
- value: `{{form.email}}`
- invalid: `{{form.errors.email != null}}`

#### Section: PasswordField

- label: `Password`
- input placeholder: `Minimum 8 characters`, type `password`, obscureText
- minLength validation: 8
- value: `{{form.password}}`
- invalid: `{{form.errors.password != null}}`

#### Section: ConfirmPasswordField

- label: `Confirm Password`
- input placeholder: `Re-enter your password`, type `password`, obscureText
- value: `{{form.confirmPassword}}`
- invalid: `{{form.password !== form.confirmPassword && form.confirmPassword.length > 0}}`

#### Slot: createAccountButton

- ref: `01-button.md`
- variant: `solid`
- color: `primary`
- size: `large`
- fullWidth: `true`
- content: `Create Account`
- top-margin: `spacing/16`
- disabled: `{{!form.canSubmit}}` (email + password ≥ 8 + confirm match)
- loading: `{{state.submitting}}`
- on-tap: `api: POST /auth/signup → state: auth.session → screen-flow → 06-my-pieces.md (Confirm email = OFF) | 또는 confirmation sent view (Confirm email = ON)`

#### Section: SignInHint

- top-margin: `spacing/16`
- align: center
- layout: 가로, gap `spacing/4`

**Slot: hintText**

- text-variant: `text/body2`
- color: `color/label/alternative`
- content: `Already have an account?`

**Slot: signInLink**

- text-variant: `text/body2`
- color: `color/primary/normal`
- weight: bold
- content: `Sign In`
- on-tap: `screen-flow → 09-welcome-back.md`

### Region: LegalFooter

- 화면 하단 고정
- align: center
- padding: `spacing/24`

**Slot: termsText**

- text-variant: `text/caption1`
- color: `color/label/alternative`
- content: `By creating an account, you agree to our Terms of Service and Privacy Policy`

---

## 3. Intent

### 사용자 의도

신규 가입. 4개 필드(Name 선택) + 비밀번호 강도 정책 8자 + 확인 일치.

### 진입 / 이탈

- **진입**:
  - 11 Welcome의 "Create Account" 버튼
  - 09 Welcome Back의 "Don't have an account? Create Account" 링크
- **이탈**:
  - Submit 성공 (Confirm email OFF) → 06 My Pieces
  - Submit 성공 (Confirm email ON) → 확인 메일 안내 뷰 (위치: 같은 화면 상태 전환 또는 별도 화면)
  - Sign In 링크 → 09 Welcome Back
  - back → 11 Welcome

### 핵심 액션 우선순위

1. **Create Account**
2. Sign In 링크 (이미 계정 있는 경우)

### 접근성

- **포커스 순서**: backButton → title → subtitle → name → email → password → confirmPassword → Create Account → Sign In link → termsText
- **에러 표시**: 비밀번호 정책(8자) 미달 시 비밀번호 필드 invalid + helper text "Minimum 8 characters" 강조
- **확인 비밀번호 미스매치**: ConfirmPassword 필드 invalid + helper text "Passwords don't match"
- **이메일 중복 (서버)**: 이메일 필드 invalid + 메시지

### Reactive Behavior

- **제출 중**: button loading + 모든 필드 disabled
- **Confirm email = ON**: 응답에 session 없으면 confirmation 안내 뷰로 전환
- **이메일 중복 / 약한 비밀번호 등 서버 거부**: 해당 필드 invalid 표시

---

## 검증 체크리스트

- [x] frontmatter / 위계 / 토큰 Semantic
- [x] Name (Optional) 명시
- [x] Confirm Password 일치 검증
- [x] LegalFooter 포함
- [ ] Confirm email ON 분기 — 별도 화면(`08a-confirmation-sent.md` 등) 명세 필요 여부 결정
