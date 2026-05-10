---
name: Create Account
extends: design_system
imports: []
source:
  type: figma
  url: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece
  node_id: "2:513 (혼합 frame)"
  link: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece?node-id=2-760&t=2SsB9yTpe6fjdj7N-4
viewport:
  primary: mobile
  responsive: [mobile]
---

# Screen: Create Account

## 개요

신규 사용자 가입 폼. 이름(선택) / 이메일 / 비밀번호(8자 이상) / 비밀번호 확인. 헤더 "Create Account" + 부제 "Start your daily photo journal".

> ⚠️ 추정 명세 (node 2:513 frame 안의 sub-screen).

---

## 1. Skeleton

```
Page (viewport: mobile, 375×840, 스크롤)
├── Region: Header
│   ├── Slot: title
│   │   ↳ component: design_system/docs/components/16-label.md
│   └── Slot: subtitle
│       ↳ component: design_system/docs/components/16-label.md
├── Region: Content (form)
│   ├── Section: NameField
│   │   ├── Slot: label
│   │   │   ↳ component: design_system/docs/components/16-label.md
│   │   └── Slot: input
│   │       ↳ component: design_system/docs/components/02-text-field.md
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
│   │   └── Slot: helperText
│   │       ↳ component: design_system/docs/components/16-label.md
│   └── Section: ConfirmPasswordField
│       ├── Slot: label
│       │   ↳ component: design_system/docs/components/16-label.md
│       └── Slot: input
│           ↳ component: design_system/docs/components/02-text-field.md
└── Region: Footer
    ├── Section: SubmitArea
    │   └── Slot: createButton
    │       ↳ component: design_system/docs/components/01-button.md
    └── Section: AltAuthLink
        └── Slot: signInLink
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
- content: `Create Account`

**Slot: subtitle**

- text-variant: `text/body2`
- color: `color/label/alternative`
- content: `Start your daily photo journal`

### Region: Content (form)

#### Layout 토큰

- container-padding: `spacing/16`
- field-gap: `spacing/16`

#### Section: NameField

**Slot: label**

- text-variant: `text/label1`
- color: `color/label/normal`
- content: `Name (Optional)`

**Slot: input**

- ref: `design_system/docs/components/02-text-field.md`
- placeholder: `Enter your name`
- value: `{{form.name}}`
- on-change: `state: form.name = $value`

#### Section: EmailField

**Slot: label**

- content: `Email`
- text-variant: `text/label1`

**Slot: input**

- ref: `design_system/docs/components/02-text-field.md`
- placeholder: `your@email.com`
- value: `{{form.email}}`
- type: `email` # 가상 키보드 힌트
- invalid: `{{form.errors.email != null}}`
- on-change: `state: form.email = $value, validate: form.email`

#### Section: PasswordField

**Slot: label**

- content: `Password`
- text-variant: `text/label1`

**Slot: input**

- ref: `design_system/docs/components/02-text-field.md`
- placeholder: ``
- type: `password`
- value: `{{form.password}}`
- invalid: `{{form.errors.password != null}}`
- trailingContent: `<Custom name="PasswordVisibilityToggle">`
- on-change: `state: form.password = $value`

**Slot: helperText**

- text-variant: `text/caption1`
- color: `{{form.errors.password ? color/status/negative : color/label/alternative}}`
- content: `Minimum 8 characters`

#### Section: ConfirmPasswordField

**Slot: label**

- content: `Confirm Password`

**Slot: input**

- ref: `design_system/docs/components/02-text-field.md`
- placeholder: `Re-enter your password`
- type: `password`
- value: `{{form.confirmPassword}}`
- invalid: `{{form.password !== form.confirmPassword && form.confirmPassword.length > 0}}`
- on-change: `state: form.confirmPassword = $value`

### Region: Footer

#### Layout 토큰

- container-padding: `spacing/16`
- gap: `spacing/12`

**Slot: createButton**

- ref: `design_system/docs/components/01-button.md`
- variant: `solid`
- color: `primary`
- size: `large`
- fullWidth: `true`
- content: `Create Account`
- disabled: `{{!form.canSubmit}}`
- loading: `{{state.submitting}}`
- on-tap: `api: POST /auth/signup (form) → state: auth.user → screen-flow → 06-home.md`

**Slot: signInLink**

- text-variant: `text/label2`
- color: `color/primary/normal`
- align: `center`
- content: `이미 계정이 있나요? 로그인` (또는 비슷한 한국어/영어 — 추정)
- on-tap: `screen-flow → 09-welcome-back.md`

---

## 3. Intent

### 사용자 의도

신규 가입 — 빠르고 마찰 적은 폼. 4개 필드(이름은 선택)로 30초 내 가입 완료.

### 진입 / 이탈

- **진입**: 앱 첫 실행 (미인증) / Welcome Back 화면의 "Create Account" 링크
- **이탈**:
  - Submit 성공 → 06-home.md
  - "Sign In" 링크 → 09-welcome-back.md
  - 시스템 백 → 폼 dirty면 confirm

### 핵심 액션 우선순위

1. **Create Account** (제출)
2. 이메일/비밀번호 입력
3. Sign In 링크 (이미 계정 있음)

### 접근성

- **포커스 순서**: title → subtitle → name → email → password → confirmPassword → Create button → Sign In link
- **폼 라벨 연결**: 모든 입력에 `<label htmlFor>` (Label 컴포넌트 사용)
- **PasswordVisibilityToggle**: aria-label "비밀번호 보기 토글"
- **에러 메시지**: aria-live="polite"로 실시간 안내
- **터치 타겟**: 입력 필드 ≥ 48px 높이

### Reactive Behavior

- **로딩**: 폼은 정적 즉시 표시
- **제출 중**: createButton loading=true, 모든 필드 disabled
- **유효성 실패**: 해당 필드 invalid=true (status/negative 보더), helperText 색 변경, errors.email 등에 메시지
- **이메일 중복**: API 응답 후 EmailField에 invalid + 메시지 ("이미 가입된 이메일")
- **에러 (네트워크)**: Snackbar variant=error

---

## 검증 체크리스트

- [x] 위계 / Slot 종결 / Bindings Semantic
- [x] 폼 유효성 / 보안(passwordToggle) 명시
- [ ] PasswordVisibilityToggle은 wanted DS에 없음 — IconButton 합성으로 표현 가능
