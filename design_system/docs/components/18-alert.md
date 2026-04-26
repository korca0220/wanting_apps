# 컴포넌트: 얼럿 (Alert)

## 개요
**확인 또는 위험 액션 다이얼로그.** wds의 Alert는 일반 인라인 알림이 아닌 **modal-style confirmation dialog** (Radix Alert Dialog 기반). 일반 인라인 메시지는 `SectionMessage`(별도 컴포넌트) 또는 `Snackbar` 사용.

> **Harness Principle:** Alert는 사용자 응답이 필수인 시나리오 (예: 데이터 삭제 확인). 단순 알림은 Snackbar로.

---

## 디자인 토큰 매핑

기본적으로 Modal과 동일한 시각 토큰 (`07-modal.md` 참조). 차이점:
- 사이즈: 보통 small (~400px max-width)
- 항상 백드롭 + Focus Trap (disable 옵션 있지만 비권장)
- ActionAreaButton variant: `normal` / `assistive` / `negative` (negative는 위험 액션 강조)

---

## 변형 (ActionAreaButton variant)

| Variant | 시각 표현 |
|---|---|
| `normal` | 기본 Primary 텍스트 |
| `assistive` | 약한 회색 텍스트 (취소용) |
| `negative` | `color/status/negative` 텍스트 — 삭제/위험 |

---

## 상태 (State) 및 인터랙션

> ⚠️ 컨테이너 컴포넌트 — 명시적 상태 표 필수.

| 상태 | 시각 표현 | 모션 |
|---|---|---|
| Closed | unmount | — |
| Open | 중앙 표시 + 백드롭 | `motion/keyframe/scale-in` 200ms ease-out |
| Closing | scale-out + 백드롭 fade-out | `motion/keyframe/scale-out` 200ms |
| Focus Trap | Alert 내부 포커스 가능 요소 사이만 순환 | — |
| Backdrop | `color/material/dimmer` | `motion/keyframe/fade-in` 200ms |

---

## 합성 슬롯

| 컴포넌트 | 역할 |
|---|---|
| `<Alert>` | Open state 컨테이너 |
| `<AlertTrigger>` | 트리거 wrapping (Slot) |
| `<AlertContainer>` | 시각 컨테이너 |
| `<AlertDimmer>` | 백드롭 |
| `<AlertContent>` | 본문 영역 |
| `<AlertHeading>` | 제목 |
| `<AlertDescription>` | 설명 |
| `<AlertActionArea>` | 버튼 그룹 영역 |
| `<AlertActionAreaButton variant>` | normal/assistive/negative 버튼 |

---

## 접근성
- `role="alertdialog"`, `aria-modal="true"`, AlertHeading과 `aria-labelledby` 자동 연결.
- AlertDescription은 `aria-describedby`로 자동 연결.
- **Focus Trap**: Open 시 첫 포커스 가능 요소(보통 액션 버튼)로 이동.
- **Esc 닫기**: 기본 활성 (위험한 액션이면 disableEscapeKeyDownClose 검토).
- **Outside Click 닫기**: 위험 액션이면 disableOutsideClickClose=true 권장 (의도치 않은 dismiss 방지).

---

## Figma Make 프롬프트
```
Alert: Confirmation Dialog (Modal과 유사하나 작고 액션 강제형)
- 외형: Modal popup small (~400px) — bg elevated, radius xl, shadow large
- 백드롭: material/dimmer
- 슬롯: Heading (title3 bold) → Description (body2) → ActionArea (buttons)
- ActionAreaButton variants:
  - normal: primary 색
  - assistive: label/neutral 회색 (취소)
  - negative: status/negative (삭제 등 위험 액션)
- 위험 액션 시 outside click 닫기 비활성 권장
- role=alertdialog, focus trap 필수

네이밍: Alert / Default, Alert / Negative-Action
```
