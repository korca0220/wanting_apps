# 컴포넌트: 칩 (Chip)

## 개요
카테고리·필터·선택 가능한 태그용 인터랙티브 라벨. Badge가 정적 표시라면 Chip은 클릭 가능하고 active 토글 상태를 가집니다. 4개 사이즈(`xsmall`/`small`/`medium`/`large`) × 2 variant(`solid`/`outlined`).

> **Harness Principle:** Chip의 active 토글은 단순 시각 상태 — 그룹 단일 선택/다중 선택 로직은 상위 `ChipGroup`(또는 그에 준하는 컨테이너) 컴포넌트가 담당.

---

## 🎨 디자인 기준

### 1. 독창성 및 톤앤매너
- 4단계 사이즈로 컴팩트한 필터 UI(xsmall)부터 강조 카테고리(large)까지 한 시스템으로 커버.
- Active 시 outlined → solid 톤 전환으로 위계 점프 명확.

### 2. 크래프트
- Solid + Active → `color/primary/normal` 배경, Outlined + Active → 보더 색만 `color/primary/normal`.
- Leading/Trailing 슬롯에 아이콘 들어갈 때 padding 미세 조정 자동.

### 3. 기능성
- `disableInteraction`은 `disabled`와 다름 — 시각적으로는 enabled처럼 보이지만 클릭 불가 (예: 필터 적용 중 잠금).

---

## 디자인 토큰 매핑

| 사이즈 | 폰트 | 패딩 | 보더 반경 |
|---|---|---|---|
| xsmall | `text/caption2` (11px) | `spacing/2` × `spacing/8` | `radius/full` |
| small | `text/caption1` (12px) | 4px × `spacing/10` | `radius/full` |
| medium | `text/label2` (13px) | `spacing/6` × `spacing/12` | `radius/full` |
| large | `text/label1` (14px) | `spacing/8` × `spacing/14` | `radius/full` |

> Chip은 **항상 pill 모양** (`radius/full`).

---

## 변형 (Variant × Active)

### Solid (Default)
| 상태 | 배경 | 텍스트 | 보더 |
|---|---|---|---|
| Inactive | `color/fill/normal` | `color/label/normal` | 없음 |
| Active | `color/primary/normal` | `color/static/white` | 없음 |

### Outlined
| 상태 | 배경 | 텍스트 | 보더 |
|---|---|---|---|
| Inactive | `transparent` | `color/label/normal` | `1px color/line/normal/neutral` |
| Active | `transparent` | `color/primary/normal` | `1px color/primary/normal` |

---

## 상태 (State) 및 인터랙션

| 상태 | 시각 표현 / 변경 토큰 | 모션 토큰 |
|---|---|---|
| Default (Inactive) | 변형별 기본 | — |
| Hover | 배경/보더 한 단계 진하게 | `motion/transition/colors` |
| Focus | `shadow/focus` (필수) | — |
| Active (toggle on) | 변형별 active 토큰 | `motion/transition/colors` |
| Disabled | 텍스트 `color/label/disable`, 배경/보더 `color/interaction/disable`, `pointer-events: none` | — |

---

## 접근성 (Accessibility)
- `role="button"` (또는 native `<button>`) + `aria-pressed={active}`.
- 그룹의 단일 선택은 `role="radiogroup"` 컨테이너 내 `role="radio"` 변형 검토.
- 키보드: Space/Enter로 toggle.

---

## Figma Make 프롬프트

```
Wanted Montage Chip 컴포넌트:

Sizes: xsmall(11px caption2), small(12px caption1), medium(13px label2), large(14px label1)
Variants: solid | outlined
States: inactive(default), active, hover, focus, disabled

모양: 항상 pill (radius full)
패딩: 사이즈별 (xsmall 2×8 → large 8×14)

Solid:
- inactive: bg fill/normal, text label/normal
- active: bg #0066FF, text white

Outlined:
- inactive: transparent + 1px line/normal/neutral border, text label/normal
- active: transparent + 1px primary/normal border, text primary/normal

leading/trailing slots (아이콘): gap 4px

네이밍: Chip / Solid / Medium / Inactive, Chip / Outlined / Large / Active
```

---

## API (Flutter)

| Prop | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `label` | `String` | required | Chip 텍스트. |
| `onTap` | `VoidCallback?` | `null` | 탭 콜백. `null`이면 비인터랙티브. |
| `active` | `bool` | `false` | 토글 상태(선택됨). 그룹 단일/다중 선택 로직은 부모 책임. |
| `size` | `WdsChipSize` | `medium` | `xsmall`/`small`/`medium`/`large`. 폰트·패딩이 변동, radius는 항상 full. |
| `variant` | `WdsChipVariant` | `solid` | `solid`/`outlined`. |
| `leading` / `trailing` | `Widget?` | `null` | Icon/Avatar 슬롯. 14px IconTheme이 자동 적용. |
| `disabled` | `bool` | `false` | 비활성. solid는 `interactionDisable`, outlined는 `lineNormalAlternative` 보더. |

선택 그룹은 `Wrap` + 부모 state로 구성 권장. 본 컴포넌트는 단일 칩의 토글 상태만 시각화.
