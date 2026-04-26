# 컴포넌트: 스위치 (Switch / Toggle)

## 개요
즉시 적용되는 boolean 토글. 폼 submit 없이 변경이 즉시 시스템에 반영되는 시나리오용. 2가지 size(`small`/`medium`).

> **Harness Principle:** Checkbox와 시맨틱 차이 — Checkbox는 *form value*, Switch는 *system state*. UI에서 즉시 적용되는 설정은 Switch.

---

## 디자인 토큰 매핑

| 토큰 | 값 (medium) | 값 (small) |
|---|---|---|
| Track 너비 | 44px | 32px |
| Track 높이 | 24px | 18px |
| Track 배경 (off) | `color/interaction/inactive` | 동일 |
| Track 배경 (on) | `color/primary/normal` | 동일 |
| Thumb 크기 | 20px | 14px |
| Thumb 색 | `color/static/white` | 동일 |
| Thumb 그림자 | `shadow/normal/xsmall` | 동일 |
| Track 패딩 | 2px | 2px |
| 보더 반경 | `radius/full` | `radius/full` |
| 트랜지션 | 150ms ease-out (track + thumb 동시) | 동일 |

---

## 상태 (State) 및 인터랙션

| 상태 | 시각 표현 | 모션 |
|---|---|---|
| Off (default) | Track `color/interaction/inactive`, Thumb 좌측 | — |
| Hover (Off) | Track 배경 한 단계 진하게 | `motion/transition/colors` |
| Focus | `shadow/focus` (필수) | — |
| On (checked) | Track `color/primary/normal`, Thumb 우측 슬라이드 | `motion/transition/transform` 150ms |
| Hover (On) | Track `color/primary/strong` | `motion/transition/colors` |
| Disabled | Track/Thumb opacity 0.4 또는 `color/interaction/disable` | — |

---

## 접근성
- `<input type="checkbox" role="switch">` 또는 `role="switch"` + `aria-checked`.
- 키보드: Space로 토글.
- 변화는 즉시 적용되므로 변경 후 confirm 다이얼로그 등 추가 절차 권장 (위험한 토글의 경우).
- `aria-label` 또는 인접 라벨 필수.

---

## Figma Make 프롬프트
```
Switch: 2 sizes (medium 44×24, small 32×18)
- Off: track interaction/inactive, thumb 좌측
- On: track primary/normal, thumb 우측 (slide 150ms ease-out)
- Thumb: white circle + xsmall shadow
- focus ring 필수
- role=switch, aria-checked
네이밍: Switch / Medium / Off, Switch / Small / On
```
