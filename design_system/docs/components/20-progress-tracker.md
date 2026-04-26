# 컴포넌트: 진행 트래커 (Progress Tracker)

## 개요
다단계 진행 상태 시각화. 회원가입·이력서 작성 같은 multi-step 폼이나 결제 플로우용. `horizontal`/`vertical` 방향, 각 step에 label/completedLabel/labelContent 슬롯 제공.

> 단순 % 진행률 바는 별도 `ProgressIndicator`(미명세). 본 컴포넌트는 **discrete steps**용.

---

## 디자인 토큰 매핑

### Track (스텝 사이 연결선)
| 토큰 | 값 |
|---|---|
| 색상 (incomplete) | `color/line/normal/neutral` |
| 색상 (complete) | `color/primary/normal` |
| 두께 | 2px |
| 트랜지션 | `motion/transition/colors` (300ms ease-out) |

### Step Indicator (원형 마커)
| 상태 | 시각 표현 |
|---|---|
| Incomplete | 보더 `1px color/line/normal/neutral`, 배경 `color/background/normal/normal` |
| Active (current) | 보더 `2px color/primary/normal`, 배경 `color/background/normal/normal`, 안쪽 dot |
| Complete | 배경 `color/primary/normal`, 흰 체크 아이콘 |

| 토큰 | 값 |
|---|---|
| Indicator 크기 | 24px (default), responsive 가능 |
| Label 폰트 | `text/label2` |
| Label 색 (incomplete) | `color/label/alternative` |
| Label 색 (active/complete) | `color/label/normal` |

---

## 상태 (State) 및 인터랙션

| 상태 | 시각 표현 | 모션 |
|---|---|---|
| Incomplete | 회색 보더, 회색 라벨 | — |
| Active (current step) | Primary 보더 + dot, 강조 라벨 | `motion/transition/colors` |
| Complete | Primary fill + 체크, 일반 라벨 | `motion/transition/colors` |
| Hover (clickable step) | 보더 한 단계 진하게 | `motion/transition/colors` |
| Focus | `shadow/focus` (필수, 클릭 가능 시) | — |
| Disabled (future step) | opacity 0.4 또는 `color/interaction/disable` | — |

---

## 변형
- Direction: `horizontal` (default) / `vertical`
- Vertical은 좌측 indicator + 우측 labelContent 슬롯 가능 (badge / caption / custom)

---

## 합성 슬롯
- `<ProgressTracker value direction>`: 컨테이너
- `<ProgressTrackerItem value label completedLabel>`: 개별 스텝
- `<ProgressTrackerLabelContent variant>`: 라벨 보조 슬롯 (vertical만)

---

## 접근성
- `role="list"` (또는 ordered `<ol>`), 각 item `<li>`.
- 클릭 가능 스텝은 `<button>` 시맨틱 + `aria-current={isActive ? 'step' : undefined}`.
- 완료된 스텝의 시각 신호 외에 텍스트로도 "(완료)" 명시 권장 (스크린리더).

---

## Figma Make 프롬프트
```
ProgressTracker:
Directions: horizontal / vertical
Step states: incomplete / active / complete

Indicator (24px circle):
- incomplete: 1px line/normal/neutral border, white bg
- active: 2px primary/normal border + center dot
- complete: bg primary/normal + 흰 check 아이콘

Track (사이 연결선):
- 2px, color line/normal/neutral (or primary/normal if step before is complete)

Label: label2, color label/alternative (incomplete) or label/normal (active/complete)

Vertical: 우측에 labelContent slot (badge/caption/custom)

aria-current=step on active

네이밍: ProgressTracker / Horizontal, ProgressTrackerItem / Active, /Complete, /Incomplete
```
