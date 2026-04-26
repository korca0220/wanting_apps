# 컴포넌트: 체크박스 (Checkbox)

## 개요
다중 선택 또는 boolean toggle용 폼 요소. `medium`/`small` 두 사이즈, indeterminate 상태(트리 부분 선택 등) 지원, invalid 표기, 커스텀 아이콘 슬롯 제공.

> **Harness Principle (P6 Layered):** 체크 상태 변화는 `onCheckedChange` 콜백을 통해서만 상위로 전달. 컴포넌트 내부에서 비즈니스 결정 금지.

---

## 🎨 디자인 기준

### 1. 독창성 및 톤앤매너
- 표준 OS 체크박스보다 **모서리가 부드러운 사각형** + Primary 색 fill로 일관된 브랜드 표현.
- Indeterminate는 가로 막대(`–`)로 부분 선택의 시각 의미 명확.

### 2. 크래프트
- size별 정확한 그리드 정합: medium 20px, small 16px (4px 그리드).
- `tight` prop으로 좌우 패딩 제거 → 인접 요소 정렬 시 마이크로 조정 가능.

### 3. 기능성
- `bold` prop으로 라벨 강조 토글. 외부 `<label>` 텍스트의 weight를 medium → semibold로 일괄 전환.
- Native `<input type="checkbox">` 시맨틱 유지 (form submission 자동).

---

## 디자인 토큰 매핑

| 토큰 | 값 (Semantic) |
|---|---|
| 라벨 폰트 | `text/body2` (regular 또는 bold) |
| 체크박스 크기 (medium) | 20px |
| 체크박스 크기 (small) | 16px |
| 배경 (unchecked) | `transparent` |
| 보더 (unchecked) | `1px color/line/normal/neutral` |
| 배경 (checked) | `color/primary/normal` |
| 체크 아이콘 색 | `color/static/white` |
| 보더 반경 | `radius/sm` (6px) |
| Gap (체크박스 ↔ 라벨) | `spacing/8` |
| 트랜지션 | `motion/transition/colors` |

---

## 상태 (State) 및 인터랙션

| 상태 | 시각 표현 / 변경 토큰 | 모션 토큰 |
|---|---|---|
| Default (unchecked) | 보더만, 투명 배경 | — |
| Hover | 보더 `color/line/normal/normal`, 배경 `color/fill/alternative` | `motion/transition/colors` |
| Focus | `shadow/focus` 또는 outline 2px (필수) | — |
| Checked | 배경 `color/primary/normal`, 흰 체크 아이콘 | `motion/transition/colors` |
| Indeterminate | 배경 `color/primary/normal`, 흰 가로 막대 아이콘 | `motion/transition/colors` |
| Disabled | 보더/배경 `color/interaction/disable`, 라벨 `color/label/disable` | — |
| Invalid | 보더 `color/status/negative` (@ 28%), 라벨 `color/status/negative` 옵션 | — |
| Required | 라벨 옆에 `*` 표시 (Primary 색) | — |

---

## 접근성 (Accessibility)
- `<input type="checkbox">` 시맨틱 사용. 시각 체크박스는 `<input>` 위에 absolute positioned (input은 sr-only이지만 포커스 가능).
- `aria-checked={checked || (indeterminate ? 'mixed' : 'false')}` 자동 처리.
- 라벨은 항상 `<label htmlFor>` 또는 wrapping. 클릭 영역에 라벨 텍스트도 포함.
- 키보드: Space로 toggle. Tab으로 focus 이동.
- 최소 터치 영역 24×24px (체크박스만), 라벨까지 포함 시 44px 이상 권장.

---

## Figma Make 프롬프트

```
Wanted Montage Checkbox 컴포넌트:

Sizes: medium(20×20), small(16×16)
States: unchecked, checked, indeterminate, hover, focus, disabled, invalid

외형:
- border-radius: 6px (radius/sm)
- 보더: 1px line/normal/neutral (unchecked)
- 체크 시: bg #0066FF, 흰 체크 아이콘
- indeterminate: bg #0066FF, 흰 가로 막대(–) 아이콘
- 라벨 gap: 8px (medium), 6px (small)

Variants:
- bold=false: label2 regular
- bold=true: label2 semibold

invalid 보더: status/negative @ 28% (rgba)
disabled: 회색 fill, 라벨 disable

네이밍: Checkbox / Medium / Unchecked, Checkbox / Small / Checked, Checkbox / Indeterminate
```
