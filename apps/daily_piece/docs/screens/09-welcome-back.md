---
name: Welcome Back
extends: design_system
imports: []
source:
  type: figma
  url: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece
  node_id: "2:513 (혼합 frame)"
viewport:
  primary: mobile
  responsive: [mobile]
---

# Screen: Welcome Back (Sign In)

## 개요
기존 사용자 로그인 폼. "Welcome Back" 헤더 + "Sign in to continue your journey" 부제. 이메일 + 비밀번호 입력 → Sign In. 비밀번호 재설정 링크.

> ⚠️ 추정 명세 (node 2:513 frame 안의 sub-screen).

---

## 1. Skeleton

```
Page (viewport: mobile, 375×840)
├── Region: Header
│   ├── Slot: title
│   │   ↳ component: design_system/docs/components/16-label.md
│   └── Slot: subtitle
│       ↳ component: design_system/docs/components/16-label.md
├── Region: Content (form)
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
│   │   └── Slot: forgotLink
│   │       ↳ component: design_system/docs/components/16-label.md
└── Region: Footer
    ├── Slot: signInButton
    │   ↳ component: design_system/docs/components/01-button.md
    └── Slot: createAccountLink
        ↳ component: design_system/docs/components/16-label.md
```

---

## 2. Bindings

### Region: Header

#### Layout 토큰
- container-padding: `spacing/24`
- gap: `spacing/8`
- align: `center`

**Slot: title**
- text-variant: `text/title2`
- color: `color/label/strong`
- content: `Welcome Back`

**Slot: subtitle**
- text-variant: `text/body2`
- color: `color/label/alternative`
- content: `Sign in to continue your journey`

### Region: Content

#### Layout 토큰
- container-padding: `spacing/16`
- field-gap: `spacing/16`

#### Section: EmailField

**Slot: label**
- content: `Email`
- text-variant: `text/label1`
- color: `color/label/normal`

**Slot: input**
- ref: `design_system/docs/components/02-text-field.md`
- placeholder: `your@email.com`
- type: `email`
- value: `{{form.email}}`
- invalid: `{{form.errors.email != null}}`
- on-change: `state: form.email = $value`

#### Section: PasswordField

**Slot: label**
- content: `Password`
- text-variant: `text/label1`

**Slot: input**
- ref: `design_system/docs/components/02-text-field.md`
- placeholder: `Enter your password`
- type: `password`
- value: `{{form.password}}`
- trailingContent: `<Custom name="PasswordVisibilityToggle">`
- invalid: `{{form.errors.password != null}}`
- on-change: `state: form.password = $value`

**Slot: forgotLink**
- text-variant: `text/label2`
- color: `color/primary/normal`
- align: `right`
- content: `Forgot password?`
- on-tap: `screen-flow → 10-reset-password.md`

### Region: Footer

#### Layout 토큰
- container-padding: `spacing/16`
- gap: `spacing/12`

**Slot: signInButton**
- ref: `design_system/docs/components/01-button.md`
- variant: `solid`
- color: `primary`
- size: `large`
- fullWidth: `true`
- content: `Sign In`
- disabled: `{{!form.canSubmit}}`
- loading: `{{state.submitting}}`
- on-tap: `api: POST /auth/signin (form) → state: auth.user → screen-flow → 06-home.md`

**Slot: createAccountLink**
- text-variant: `text/label2`
- color: `color/primary/normal`
- align: `center`
- content: `Create Account`
- on-tap: `screen-flow → 08-create-account.md`

---

## 3. Intent

### 사용자 의도
기존 계정으로 빠르게 로그인. 2개 필드 + 기억 가능한 한 줄 폼.

### 진입 / 이탈
- **진입**: 앱 첫 실행 (이전에 가입했으나 로그아웃 상태) / Create Account 화면의 "이미 계정 있음" 링크
- **이탈**:
  - Sign In 성공 → 06-home.md
  - Forgot password → 10-reset-password.md
  - Create Account 링크 → 08-create-account.md

### 핵심 액션 우선순위
1. **Sign In** (제출)
2. Forgot password (보조 흐름)
3. Create Account (보조 흐름)

### 접근성
- **포커스 순서**: title → subtitle → email → password → forgotLink → Sign In → Create Account link
- **폼 라벨 연결**: htmlFor 사용
- **에러 표시**: 비밀번호 오류는 일반화된 메시지 ("이메일 또는 비밀번호가 일치하지 않아요" — 보안)
- **터치 타겟**: 입력 필드 ≥ 48px

### Reactive Behavior
- **로그인 중**: signInButton loading=true, 필드 disabled
- **인증 실패**: Snackbar variant=error 또는 인라인 에러 (비밀번호 필드 invalid)
- **네트워크 에러**: Snackbar variant=error, 재시도

---

## 검증 체크리스트
- [x] 위계 / Slot 종결 / Bindings Semantic
- [x] Forgot password 흐름 명시
- [x] 보안 친화적 에러 메시지 가이드
