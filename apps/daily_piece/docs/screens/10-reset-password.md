---
name: Reset Password
extends: design_system
imports: []
source:
  type: figma
  url: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece
  node_id: "2:856"
  link: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece?node-id=2-856&t=2SsB9yTpe6fjdj7N-4
  spec_basis: screenshot
viewport:
  primary: mobile
  responsive: [mobile]
---

# Screen: Reset Password

## 개요

비밀번호 재설정 링크 요청 화면. 백 버튼 + 큰 헤더 + 이메일 1 필드(헬퍼 텍스트 포함) + Send Reset Link primary + Sign In 복귀 링크 + 하단 도움말 안내.

---

## 1. Skeleton

```
Page (viewport: mobile, no BottomNav)
├── Region: TopBar
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
│   │   ├── Slot: input
│   │   │   ↳ component: design_system/docs/components/02-text-field.md
│   │   └── Slot: helperText
│   │       ↳ component: design_system/docs/components/16-label.md
│   ├── Slot: sendResetLinkButton
│   │   ↳ component: design_system/docs/components/01-button.md
│   └── Section: SignInHint                 # "Remember your password? Sign In"
│       ├── Slot: hintText
│       └── Slot: signInLink
└── Region: SupportFooter                   # 화면 하단, "Need help? Contact our support team"
    └── Slot: supportText
        ↳ component: design_system/docs/components/16-label.md
```

---

## 2. Bindings

### Region: TopBar

- height: 56
- padding-x: `spacing/16`
- background: transparent
- 좌측 정렬

**Slot: backButton**

- icon: `chevron-left`
- aria-label: `뒤로`
- on-tap: `screen-flow → pop` (← 09 Welcome Back)

### Region: Header

- container-padding: `spacing/24`
- gap: `spacing/8`
- top-padding: `spacing/16`

**Slot: title**

- text-variant: `text/title1` (Inter Bold ~32px)
- color: `color/label/strong`
- content: `Reset Password`

**Slot: subtitle**

- text-variant: `text/body1`
- color: `color/label/alternative`
- content: `Enter your email to receive a reset link`

### Region: Form

- container-padding: `spacing/24`
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

**Slot: helperText**

- text-variant: `text/caption1`
- color: `color/label/alternative`
- content: `We'll send a password reset link to this email`
- 위치: input 아래, gap `spacing/8`

#### Slot: sendResetLinkButton

- ref: `01-button.md`
- variant: `solid`
- color: `primary`
- size: `large`
- fullWidth: `true`
- content: `Send Reset Link`
- top-margin: `spacing/24`
- disabled: `{{!form.email || form.errors.email}}`
- loading: `{{state.submitting}}`
- on-tap: `api: POST /auth/reset-password (email) → screen-flow → confirmation view (옵션) 또는 inline 성공 메시지`

#### Section: SignInHint

- top-margin: `spacing/16`
- align: center
- layout: 가로, gap `spacing/4`

**Slot: hintText**

- text-variant: `text/body2`
- color: `color/label/alternative`
- content: `Remember your password?`

**Slot: signInLink**

- text-variant: `text/body2`
- color: `color/primary/normal`
- weight: bold
- content: `Sign In`
- on-tap: `screen-flow → pop` (또는 09 Welcome Back로 명시 이동)

### Region: SupportFooter

- 화면 하단 고정
- align: center
- padding: `spacing/24`

**Slot: supportText**

- text-variant: `text/caption1`
- color: `color/label/alternative`
- content: `Need help? Contact our support team`
- "support team" 부분 underline + tappable (mailto: 또는 인앱 라우트)

---

## 3. Intent

### 사용자 의도

비밀번호를 잊어 로그인 못 할 때, 이메일로 재설정 링크 요청.

### 진입 / 이탈

- **진입**: 09 Welcome Back의 Forgot password? 링크
- **이탈**:
  - Send Reset Link 성공 → 안내 메시지 (이번 화면 그대로 또는 별도 confirmation 화면)
  - Sign In 링크 → pop (← 09 Welcome Back)
  - back → pop
  - Support 링크 → 외부 (메일 / 도움말)

### 핵심 액션 우선순위

1. **Send Reset Link**
2. Sign In (로그인 화면 복귀)
3. Support (보조)

### 접근성

- **포커스 순서**: backButton → title → subtitle → email → Send Reset Link → Sign In link → supportText
- **에러 표시**: 잘못된 이메일 형식 / 미존재 계정 → 일반화된 메시지 권장 (보안: 계정 존재 여부 노출 회피)
- **터치 타겟**: 입력 ≥ 48, 버튼 large

### Reactive Behavior

- **제출 중**: button loading + 입력 disabled
- **성공**: confirmation 메시지 — "We've sent a reset link to {email}" (이 화면에 inline 표시 또는 separate confirmation screen)
- **실패**: Snackbar variant=error 또는 인라인. 보안상 "If an account exists, an email has been sent" 같은 일반화 권장

---

## 검증 체크리스트

- [x] frontmatter / 위계
- [x] BottomNav 없음 (인증 흐름)
- [x] EmailField + helperText
- [x] SupportFooter 추가 (이전 명세 누락분)
- [ ] 성공 후 화면 전환 정책 (inline vs confirmation 화면) 결정
- [ ] supportText 링크 처리 정책 (mailto / 인앱 도움말 라우트) 결정

---

## 구현 갭

| 항목       | 명세                                    | 현 구현 |
| ---------- | --------------------------------------- | ------- |
| 화면 자체  | Reset Password                          | 없음    |
| 라우트     | `/reset-password`                       | 미정    |
| Repository | `authRepository.resetPassword(email)`   | 미구현 — Supabase `auth.resetPasswordForEmail`로 1:1 매핑 가능 |
