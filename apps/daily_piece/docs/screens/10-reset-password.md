---
name: Reset Password
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

# Screen: Reset Password

## 개요
비밀번호 재설정 요청 화면. "Enter your email to receive a reset link" 안내 + 이메일 입력 → 링크 전송. "We'll send a password reset link to this email" 보조 안내.

> ⚠️ 추정 명세 (node 2:513 frame 안의 sub-screen).

---

## 1. Skeleton

```
Page (viewport: mobile, 375×840)
├── Region: Header
│   ├── Slot: backButton
│   │   ↳ component: design_system/docs/components/09-icon-button.md
│   ├── Slot: title
│   │   ↳ component: design_system/docs/components/16-label.md
│   └── Slot: subtitle
│       ↳ component: design_system/docs/components/16-label.md
├── Region: Content
│   └── Section: EmailField
│       ├── Slot: label
│       │   ↳ component: design_system/docs/components/16-label.md
│       ├── Slot: input
│       │   ↳ component: design_system/docs/components/02-text-field.md
│       └── Slot: helperText
│           ↳ component: design_system/docs/components/16-label.md
└── Region: Footer
    └── Slot: submitButton
        ↳ component: design_system/docs/components/01-button.md
```

---

## 2. Bindings

### Region: Header

#### Layout 토큰
- container-padding: `spacing/24`
- gap: `spacing/12`

**Slot: backButton**
- ref: `design_system/docs/components/09-icon-button.md`
- icon: `chevron-left`
- aria-label: `뒤로`
- on-tap: `screen-flow back`

**Slot: title**
- text-variant: `text/title2`
- color: `color/label/strong`
- content: `Reset Password`

**Slot: subtitle**
- text-variant: `text/body2`
- color: `color/label/alternative`
- content: `Enter your email to receive a reset link`

### Region: Content

#### Layout 토큰
- container-padding: `spacing/16`

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

**Slot: helperText**
- text-variant: `text/caption1`
- color: `color/label/alternative`
- content: `We'll send a password reset link to this email`

### Region: Footer

#### Layout 토큰
- container-padding: `spacing/16`

**Slot: submitButton**
- ref: `design_system/docs/components/01-button.md`
- variant: `solid`
- color: `primary`
- size: `large`
- fullWidth: `true`
- content: `Reset Password` (또는 `Send Link`)
- disabled: `{{!form.email.valid}}`
- loading: `{{state.submitting}}`
- on-tap: `api: POST /auth/reset-password { email } → snackbar variant=success "Reset link 전송됐어요" → screen-flow back → 09-welcome-back.md`

---

## 3. Intent

### 사용자 의도
비밀번호를 잊었을 때 이메일 한 줄로 reset link를 받는다. 단순한 1-필드 화면.

### 진입 / 이탈
- **진입**: Welcome Back 화면의 "Forgot password?" 링크
- **이탈**:
  - Submit 성공 → Welcome Back 화면 + 성공 Snackbar
  - Back → Welcome Back

### 핵심 액션 우선순위
1. **Reset Password** (제출)
2. Email 입력
3. Back

### 접근성
- **포커스 순서**: backButton → title → subtitle → email label → email input → helperText → Reset button
- **에러 처리**: 가입되지 않은 이메일이라도 보안상 동일 성공 메시지 (이메일 존재 여부 노출 금지)
- **터치 타겟**: ≥ 48px

### Reactive Behavior
- **제출 중**: submitButton loading=true
- **성공**: Snackbar variant=success "Reset link를 이메일로 보냈어요" → 자동 직전 화면 복귀
- **유효성 실패**: invalid 이메일 형식이면 EmailField invalid=true
- **네트워크 에러**: Snackbar variant=error, 재시도

---

## 검증 체크리스트
- [x] 위계 / Slot 종결 / Bindings Semantic
- [x] 보안 친화 에러 메시지 (이메일 존재 여부 미노출)
- [x] 단순한 1-필드 흐름
