# 컴포넌트: 텍스트 필드 (Text Field)

## 개요
사용자 입력을 받는 폼 1차 요소. 단일 입력(`<input>`)을 wrapping하며, leading/trailing 슬롯에 아이콘·배지·타이머·텍스트 버튼을 자유롭게 조합할 수 있습니다. invalid/positive/disabled 상태와 reset 동작을 1급 시민으로 지원.

> **Harness Principle (P6 Layered):** 입력 검증은 비즈니스 로직(Service) 호출 결과의 *시각화*만 담당. 검증 자체는 상위에서 결정해 `invalid`/`positive` prop으로 내려줍니다.

---

## 🎨 디자인 기준

### 1. 독창성 및 톤앤매너
- 일반 input과 달리 **`background/transparent/normal` + `backdrop-filter: blur(32px)`**가 시그니처 — 떠 있는 듯한 미세한 깊이.
- 보더는 `box-shadow inset`으로 처리 (border가 아닌). Hover/Focus 시 두께 점프 없이 색상만 변화.

### 2. 크래프트
- xsmall 그림자(`shadow/normal/xsmall`)로 미세한 lift. 다른 컴포넌트와 위계 충돌 없음.
- trailing button이 붙으면 우측 모서리 radius 0으로 정확히 connect.

### 3. 기능성
- `onReset` 콜백으로 reset 버튼 동작. 빈 값일 때 자동 hidden.
- `EXCLUDE_TYPE`(date/month/week/datetime-local/time)에서는 invalid/positive/reset 슬롯 자동 숨김 — native picker UI 충돌 방지.

---

## 디자인 토큰 매핑

| 토큰 | 값 (Semantic) |
|---|---|
| 폰트 | `text/body1` (입력 본문) |
| 라벨 폰트 | `text/label1` |
| 배경 | `color/background/transparent/normal` |
| 보더 | `inset 0 0 0 1px color/line/normal/neutral` |
| 포커스 보더 | `inset 0 0 0 1px color/line/normal/normal` (한 단계 진하게) |
| 그림자 | `shadow/normal/xsmall` |
| 보더 반경 | `radius/lg` (12px) |
| 패딩 | `spacing/12` (12px 12px) |
| Backdrop | `blur(32px)` |
| 트랜지션 | `motion/transition/shadow` (200ms ease) |

---

## 상태 (State) 및 인터랙션

| 상태 | 시각 표현 / 변경 토큰 | 모션 토큰 |
|---|---|---|
| Default | 위 토큰 매핑 그대로 | — |
| Hover | 보더 `color/line/normal/normal` 약간 진하게 | `motion/transition/shadow` |
| Focus | 보더 `color/primary/normal` 또는 `color/line/normal/strong` (2단계 진하게) | `motion/transition/shadow` |
| Disabled | 배경 `color/fill/alternative`, blur 해제, 텍스트 `color/label/disable` | — |
| ReadOnly | 보더 동일, 커서 `default`, 배경 약간 회색 | — |
| Invalid | 보더 `color/status/negative @ 28%`, trailing에 negative 아이콘 | `motion/transition/colors` |
| Positive | 보더 `color/status/positive @ 28%`, trailing에 positive 아이콘 | `motion/transition/colors` |

---

## 변형 (Variant)

### TextFieldContent (leading/trailing 슬롯)
- variants: `custom` / `text` / `timer` / `badge` / `icon` / `icon-button` / `text-button`
- 각 variant는 콘텐츠 정렬·간격을 자동 조정 (예: timer는 `text/label2 monospace`)

### TextFieldButton (트레일링 버튼)
- variants: `normal` / `assistive`
- 우측에 붙어 input 우측 모서리 radius 0으로 join. 자체 loading prop 지원.

---

## 접근성 (Accessibility)
- `<input>` 시맨틱 유지. `aria-invalid="true"` 자동 동기 (`invalid={true}` 시).
- 라벨 연결: 외부 `<Label htmlFor>` 또는 wrapping `<label>` 권장.
- Reset 버튼은 `aria-label="입력 지우기"` 필수.
- 키보드: Enter는 폼 submit 트리거. Escape는 reset (선택).

---

## Figma Make 프롬프트

```
다음 스펙으로 Wanted Montage Text Field를 만들어줘:

기본 외형:
- 높이 auto, padding 12px (모든 방향)
- border-radius: 12px
- background: rgba(white, 0.08) + backdrop-filter blur(32px) (라이트)
- box-shadow: 1px-2px xsmall + inset 1px line/normal/neutral
- input 폰트: body1 (16px)

States:
- default: line/normal/neutral 보더
- focus: line/normal/strong 보더 (transition 200ms)
- invalid: status/negative @ 28% 보더
- positive: status/positive @ 28% 보더
- disabled: fill/alternative 배경, blur 해제, label/disable 텍스트
- readOnly: 커서 default

Slots:
- leading: 아이콘/badge/text/timer
- trailing: 아이콘/text/icon-button/text-button + reset 버튼 (자동 표시)
- TextFieldButton 우측 결합 시: 우측 radius 0

네이밍: TextField / Default, TextField / Invalid, TextField / Disabled
```
