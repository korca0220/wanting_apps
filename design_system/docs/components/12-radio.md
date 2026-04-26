# 컴포넌트: 라디오 (Radio)

## 개요
단일 선택 폼 요소. 동일 `name`을 공유하는 그룹 내에서 하나만 선택 가능. 2가지 size(`medium`/`small`), invalid 상태, `tight` 정렬 옵션.

---

## 디자인 토큰 매핑

| 토큰 | 값 |
|---|---|
| 라벨 폰트 | `text/body2` |
| 라디오 크기 (medium) | 20px |
| 라디오 크기 (small) | 16px |
| 보더 (unchecked) | `1px color/line/normal/neutral` |
| 보더 (checked) | `5px color/primary/normal` (medium) / `4px` (small) — inner ring |
| 배경 (unchecked) | `transparent` |
| 배경 (checked) | `color/static/white` (안쪽) |
| 보더 반경 | `radius/full` (원형) |
| Gap (라디오 ↔ 라벨) | `spacing/8` |
| 트랜지션 | `motion/transition/colors` |

> Radio는 항상 원형 (`radius/full`).

---

## 상태 (State) 및 인터랙션

| 상태 | 시각 표현 | 모션 |
|---|---|---|
| Default (unchecked) | 보더만 | — |
| Hover | 보더 진하게, 배경 `color/fill/alternative` | `motion/transition/colors` |
| Focus | `shadow/focus` (필수) | — |
| Checked | 보더 `color/primary/normal`, 안쪽 흰색 dot | `motion/transition/colors` |
| Disabled | 보더/배경 `color/interaction/disable` | — |
| Invalid | 보더 `color/status/negative @ 28%` | — |

---

## 접근성
- `<input type="radio">` 시맨틱. 동일 `name` 그룹은 RadioGroup wrapper로 묶음 (`role="radiogroup"`).
- `aria-checked={checked}` 자동.
- 키보드: 화살표(↑↓ 또는 ←→)로 그룹 내 이동, Space로 선택.
- 라벨은 `<label htmlFor>` 필수, 클릭 영역에 라벨 포함.

---

## Figma Make 프롬프트
```
Radio: 원형, 2 sizes (20/16px)
- unchecked: 1px line border
- checked: primary/normal 보더 + inner white dot
- hover: line/normal/normal 진한 보더
- focus ring 필수
- group: 동일 name 공유, 단일 선택
- 라벨 gap 8px (medium), 6px (small)
네이밍: Radio / Medium / Unchecked, Radio / Small / Checked
```
