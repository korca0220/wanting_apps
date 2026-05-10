---
name: Welcome Back
extends: design_system
imports: []
source:
  type: figma
  url: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece
  node_id: "2:812"
  link: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece?node-id=2-812&t=2SsB9yTpe6fjdj7N-4
  spec_basis: screenshot
viewport:
  primary: mobile
  responsive: [mobile]
---

# Screen: Welcome Back (Sign In)

## 개요

기존 사용자 로그인 폼. 백 버튼 + 큰 헤더 + 이메일/비밀번호 + Forgot password 링크 + Sign In primary + Create Account 링크 + 하단 ToS 안내.

---

## 1. Skeleton

```
Page (viewport: mobile)
├── Region: TopBar                          # 백 버튼만, transparent
│   └── Slot: backButton
│       ↳ component: design_system/docs/components/09-icon-button.md
├── Region: Header
│   ├── Slot: title
│   │   ↳ component: design_system/docs/components/16-label.md
│   └── Slot: subtitle
│       ↳ component: design_system/docs/components/16-label.md
├── Region: Form
│   ├── Section: EmailField
│   │   ├── Slot: label
│   │   │   ↳ component: design_system/docs/components/16-label.md
│   │   └── Slot: input
│   │       ↳ component: design_system/docs/components/02-text-field.md
│   ├── Section: PasswordField
│   │   ├── Slot: label
│   │   │   ↳ component: design_system/docs/components/16-label.md
│   │   ├── Slot: input
│   │   │   ↳ component: design_system/docs/components/02-text-field.md
│   │   └── Slot: forgotLink                # 우측 정렬, 비밀번호 입력 아래
│   │       ↳ component: design_system/docs/components/16-label.md
│   ├── Slot: signInButton
│   │   ↳ component: design_system/docs/components/01-button.md
│   └── Section: SignUpHint                 # "Don't have an account? Create Account"
│       ├── Slot: hintText
│       │   ↳ component: design_system/docs/components/16-label.md
│       └── Slot: createAccountLink
│           ↳ component: design_system/docs/components/16-label.md
└── Region: LegalFooter                     # 화면 하단 고정 또는 스크롤 끝
    └── Slot: termsText
        ↳ component: design_system/docs/components/16-label.md
```

---

## 2. Bindings

### Region: TopBar

- height: 56
- padding-x: `spacing/16`
- background: transparent (= `color/background/normal/normal`)
- 좌측 정렬

**Slot: backButton**

- icon: `chevron-left`
- aria-label: `뒤로`
- on-tap: `screen-flow → pop` (← 11 Welcome으로 복귀)

### Region: Header

- container-padding: `spacing/24` (horizontal)
- gap: `spacing/8`
- top-padding: `spacing/16`

**Slot: title**

- text-variant: `text/title1` (Inter Bold ~32px)
- color: `color/label/strong`
- content: `Welcome Back`

**Slot: subtitle**

- text-variant: `text/body1`
- color: `color/label/alternative`
- content: `Sign in to continue your journey`

### Region: Form

- container-padding: `spacing/24`
- field-gap: `spacing/16`
- top-padding: `spacing/32`

#### Section: EmailField

**Slot: label**

- text-variant: `text/label1`
- color: `color/label/normal`
- content: `Email`

**Slot: input**

- ref: `02-text-field.md`
- placeholder: `your@email.com`
- type: `email`
- keyboardType: `emailAddress`
- value: `{{form.email}}`
- on-change: `state: form.email = $value`
- invalid: `{{form.errors.email != null}}`

#### Section: PasswordField

**Slot: label**

- content: `Password`
- text-variant: `text/label1`
- color: `color/label/normal`

**Slot: input**

- ref: `02-text-field.md`
- placeholder: `Enter your password`
- type: `password`
- obscureText: `true`
- value: `{{form.password}}`
- on-change: `state: form.password = $value`
- invalid: `{{form.errors.password != null}}`

**Slot: forgotLink**

- text-variant: `text/label2`
- color: `color/primary/normal`
- align: `right`
- content: `Forgot password?`
- on-tap: `screen-flow → 10-reset-password.md`

#### Slot: signInButton

- ref: `01-button.md`
- variant: `solid`
- color: `primary`
- size: `large`
- fullWidth: `true`
- content: `Sign In`
- top-margin: `spacing/16`
- disabled: `{{!form.canSubmit}}` (이메일 + 비밀번호 비어있지 않음)
- loading: `{{state.submitting}}`
- on-tap: `api: POST /auth/signin → state: auth.session → screen-flow → 06-my-pieces.md`

#### Section: SignUpHint

- top-margin: `spacing/16`
- align: center
- layout: 가로, gap `spacing/4`

**Slot: hintText**

- text-variant: `text/body2`
- color: `color/label/alternative`
- content: `Don't have an account?`

**Slot: createAccountLink**

- text-variant: `text/body2`
- color: `color/primary/normal`
- weight: bold (또는 `text/label1`로 강조)
- content: `Create Account`
- on-tap: `screen-flow → 08-create-account.md`

### Region: LegalFooter

- 화면 하단 고정
- align: center
- padding: `spacing/24`

**Slot: termsText**

- text-variant: `text/caption1`
- color: `color/label/alternative`
- content: `By signing in, you agree to our Terms of Service and Privacy Policy`
- 링크 처리: "Terms of Service" / "Privacy Policy" 부분만 underline + tappable (web view 또는 인앱 라우트)

---

## 3. Intent

### 사용자 의도

기존 계정으로 빠르게 로그인. 2개 필드 + 보조 흐름 2개(forgot / create account).

### 진입 / 이탈

- **진입**:
  - 11 Welcome 화면의 "Sign In" 버튼
  - 08 Create Account의 "Already have an account? Sign In" 링크
  - 10 Reset Password 완료 후
- **이탈**:
  - Sign In 성공 → 06 My Pieces
  - Forgot password → 10 Reset Password
  - Create Account → 08 Create Account
  - back → 11 Welcome

### 핵심 액션 우선순위

1. **Sign In**
2. Forgot password (보조)
3. Create Account (보조)

### 접근성

- **포커스 순서**: backButton → title → subtitle → email → password → forgotLink → Sign In → Create Account link → termsText
- **에러 표시**: 비밀번호 오류는 일반화된 메시지 "Email or password is incorrect" — 보안
- **터치 타겟**: 입력 필드 ≥ 48
- **키보드**: email → password → submit (textInputAction)

### Reactive Behavior

- **로그인 중**: signInButton loading=true, 모든 필드 disabled
- **인증 실패**: 비밀번호 필드 invalid + Snackbar variant=error 또는 인라인 에러
- **네트워크 에러**: Snackbar + 재시도

---

## 검증 체크리스트

- [x] frontmatter / 위계 / 토큰 Semantic
- [x] forgotLink 우측 정렬 + primary color
- [x] LegalFooter 추가 (이전 명세 누락분)
- [ ] termsText 내부 링크 처리 정책 (in-app vs web view) 결정
