# 컴포넌트: 버튼 (Button)

## 개요
사용자 액션을 트리거하는 가장 기본적인 인터랙티브 컴포넌트. `solid`/`outlined` 두 variant × `primary`/`assistive` 두 색상 × `small`/`medium`/`large` 세 사이즈 매트릭스로 제공되며, 로딩·아이콘 전용 모드를 지원합니다.

> **Harness Principle (P6 Layered):** 이 컴포넌트는 UI 레이어. 비즈니스 로직(Service/Repo)을 직접 포함하지 않으며, `onClick` 핸들러를 통해서만 상위 레이어와 소통합니다.

---

## 🎨 디자인 기준 (Frontend Quality Criteria)

### 1. 독창성 및 톤앤매너
- Primary 버튼은 솔리드 블루(`color/primary/normal`)로 강한 존재감. Assistive는 fill만 적용해 배경에 자연스럽게 녹아듦 — *blur(32px) backdrop-filter*가 시그니처 디테일.
- Outlined Primary는 흰 배경 위에서도 `inset 0 0 0 1px line/normal/neutral`로 절제된 보더만 사용 (그림자/배경색 없음).

### 2. 크래프트
- 폰트 굵기 자동화: `assistive`는 medium(500), `primary`는 bold(600). Solid Primary의 시각 무게가 항상 더 강하도록.
- 사이즈별 padding/border-radius 동기화: small(7px 14px / 8px) → medium(9px 20px / 10px) → large(12px 28px / 12px). 4px 그리드 정합.

### 3. 기능성
- `loading` 시 자식 요소를 `visibility: hidden`으로 숨기고 spinner를 절대 위치 중앙. 버튼 width 점프 방지.
- `iconOnly` 모드에서 padding이 정사각형이 되어 시각 균형 유지.

---

## 디자인 토큰 매핑

| 토큰 | 값 (Semantic) |
|---|---|
| 폰트 (large primary) | `text/body1` × `font/weight/bold` |
| 폰트 (medium primary) | `text/body2` × `font/weight/bold` |
| 폰트 (small primary) | `text/label2` × `font/weight/bold` |
| 폰트 (assistive) | 위와 동일 사이즈 × `font/weight/medium` |
| 보더 반경 (large) | `radius/lg` (12px) |
| 보더 반경 (medium) | 10px (Inferred — 토큰화 후보) |
| 보더 반경 (small) | `radius/md` (8px) |
| 패딩 (large) | `spacing/12` × `spacing/24` ~ 28px |
| 패딩 (medium) | `spacing/8`+ × `spacing/20` |
| 패딩 (small) | 7px × `spacing/14` |
| Gap (leading/trailing) | `spacing/4` ~ `spacing/6` |

---

## 변형 (Variant × Color)

### Solid Primary (기본 CTA)
| 토큰 | 값 |
|---|---|
| 배경 | `color/primary/normal` |
| 텍스트 | `color/static/white` |
| 보더 | 없음 |

### Solid Assistive (보조 액션)
| 토큰 | 값 |
|---|---|
| 배경 | `color/fill/normal` |
| 텍스트 | `color/label/neutral` |
| 추가 | `backdrop-filter: blur(32px)` |

### Outlined Primary (강조 보조)
| 토큰 | 값 |
|---|---|
| 배경 | `transparent` |
| 텍스트 | `color/primary/normal` |
| 보더 | `inset 0 0 0 1px color/line/normal/neutral` |

### Outlined Assistive (가장 약한 액션)
| 토큰 | 값 |
|---|---|
| 배경 | `transparent` |
| 텍스트 | `color/label/normal` |
| 보더 | `inset 0 0 0 1px color/line/normal/neutral` |

---

## 상태 (State) 및 인터랙션

| 상태 | 시각 표현 / 변경 토큰 | 모션 토큰 |
|---|---|---|
| Default | 변형별 기본값 | — |
| Hover | 배경 1단계 어둡게 (Solid Primary → `color/primary/strong`) | `motion/transition/colors` |
| Focus | `shadow/focus` 또는 outline 2px (필수) | — |
| Active / Pressed | 배경 1단계 더 어둡게 (Solid Primary → `color/primary/heavy`) | `motion/transition/colors` |
| Disabled | 텍스트 `color/label/assistive`, 배경 `color/interaction/disable`, `pointer-events: none` | — |
| Loading | 자식 hidden + spinner 중앙, `cursor: wait` | — |

---

## 접근성 (Accessibility)
- HTML `<button>` 사용. 비-`<button>` 트리거에는 `role="button"` + `tabindex="0"` + Enter/Space 핸들러.
- `disabled`와 `aria-disabled="true"`를 모두 다룸 (loading은 `aria-disabled`만).
- Focus는 키보드 포커스 시 가시적 outline 필수 (WCAG 2.4.7).
- 최소 터치 영역 44×44px — small 사이즈는 모바일 터치 영역에서 검토 필요.

---

## Figma Make 프롬프트

```
다음 스펙으로 Wanted Montage 버튼 컴포넌트를 만들어줘:

Variants: solid | outlined
Colors: primary | assistive
Sizes: small | medium | large
States: default, hover, active, disabled, loading

색상 매핑:
- Solid Primary: bg #0066FF, text white
- Solid Assistive: bg fill/normal (반투명 회색), text label/neutral, backdrop-filter blur(32px)
- Outlined Primary: bg transparent, text #0066FF, 1px inset border
- Outlined Assistive: bg transparent, text label/normal, 1px inset border

사이즈 (radius / padding / font):
- small: 8px / 7px 14px / label2 (13px)
- medium: 10px / 9px 20px / body2 (15px)
- large: 12px / 12px 28px / body1 (16px)

Font weight: assistive=medium(500), primary=bold(600)

iconOnly 변형: padding을 정사각으로(예: medium 10px), 아이콘 사이즈 += 2-4px
loading: spinner 절대 위치 중앙, 자식 hidden (width 유지)

네이밍: Button / Solid-Primary / Large, Button / Outlined-Assistive / Small ...
```
