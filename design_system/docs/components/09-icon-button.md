# 컴포넌트: 아이콘 버튼 (Icon Button)

## 개요
아이콘 전용 인터랙티브 트리거. 4가지 variant(`normal`/`background`/`outlined`/`solid`), 2가지 size(`small`/`medium`) + number 직접 지정. 일반 Button의 `iconOnly`와 별도 컴포넌트로 존재 — 아이콘 컬러 트랜지션을 1급 시민으로 다루기 위함.

> **Harness Principle (P6 Layered):** 시각 형태만 제공. 트리거 의미는 항상 `aria-label` 필수.

---

## 디자인 토큰 매핑

| 토큰 | 값 |
|---|---|
| 아이콘 색 (default) | prop `color` (기본 `color/label/normal`) |
| 아이콘 색 (interaction) | prop `interactionColor` (지정 시 hover/active에 적용) |
| 보더 반경 | `radius/full` (Pill, IconButton의 시그니처) |
| 사이즈 (medium) | 40×40px |
| 사이즈 (small) | 32×32px |
| 트랜지션 | `motion/transition/colors` |

---

## 변형 (Variant)

| Variant | 배경 | 보더 | 용도 |
|---|---|---|---|
| `normal` | transparent | 없음 | 가장 약한 시각 |
| `background` | `color/fill/normal` (alternative=true 시 dark) | 없음 | 배경 위 떠 있는 느낌 |
| `outlined` | transparent | `1px color/line/normal/neutral` | 보조 액션 |
| `solid` | `color/primary/normal` | 없음 | 강한 CTA |

---

## 상태 (State) 및 인터랙션

| 상태 | 시각 표현 | 모션 |
|---|---|---|
| Default | variant별 기본 | — |
| Hover | 배경/색상 한 단계 진하게 | `motion/transition/colors` |
| Focus | `shadow/focus` (필수) | — |
| Active / Pressed | `interactionColor` 적용 | `motion/transition/colors` |
| Disabled | `color/label/disable`, `color/interaction/disable`, `pointer-events: none` | — |

---

## 접근성
- HTML `<button>` 사용. **`aria-label` 필수** (visible 텍스트가 없으므로).
- 최소 터치 영역: small=32px → 모바일에선 medium 이상 권장.
- 키보드: Enter/Space로 activate.

---

## Figma Make 프롬프트
```
IconButton: 4 variants (normal/background/outlined/solid) × 2 sizes (32/40px) × pill shape
- color/interactionColor props로 hover 변색
- aria-label 필수
- 네이밍: IconButton / Solid / Medium / Default
```
