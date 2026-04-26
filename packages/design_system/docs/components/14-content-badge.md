# 컴포넌트: 컨텐츠 배지 (Content Badge)

## 개요
정적 라벨 — 카테고리·상태·태그용. 인터랙티브하지 않으며 단순 표시 전용. 3가지 size(`xsmall`/`small`/`medium`), 2 variant(`solid`/`outlined`), 2 color group(`neutral`/`accent`).

> **Harness Principle:** Chip과 차이 — Badge는 *정적 표시*, Chip은 *인터랙티브 토글*. 클릭 가능하면 Chip으로 변경.

---

## 디자인 토큰 매핑

| 사이즈 | 폰트 | 패딩 | 보더 반경 |
|---|---|---|---|
| xsmall | `text/caption2` (11px) | `spacing/2` × `spacing/6` | `radius/sm` (6px) |
| small | `text/caption1` (12px) | `spacing/2` × `spacing/8` | `radius/sm` (6px) |
| medium | `text/label2` (13px) | 4px × `spacing/8` | `radius/md` (8px) |

> Chip과 달리 pill이 아닌 사각 보더 반경 (시각적 정적 신호).

---

## 변형 (Variant × Color)

### Solid
| Color | 배경 | 텍스트 |
|---|---|---|
| neutral (기본) | `color/fill/normal` | `color/label/normal` |
| neutral (color prop 지정) | prop의 `color/{name}/subtle` | prop의 `color/{name}/foreground` |
| accent (색상 그룹) | `color/accent/background/{redOrange|lime|cyan|...}` | `color/static/white` |

### Outlined
| Color | 배경 | 보더 | 텍스트 |
|---|---|---|---|
| neutral | `transparent` | `1px color/line/normal/neutral` | `color/label/normal` |
| accent | `transparent` | `1px color/accent/foreground/{name}` | `color/accent/foreground/{name}` |

---

## 상태
| 상태 | 시각 표현 |
|---|---|
| Default | 변형별 기본 |

> Badge는 정적 — Hover/Focus/Active 상태 없음. 인터랙션이 필요하면 `<Chip>` 사용.

---

## 접근성
- 시맨틱: `<span>` (또는 적절한 inline 요소). `role="status"`는 동적 업데이트가 있을 때만.
- 색만으로 의미를 전달하지 않음 (예: 상태 색 + 아이콘 또는 텍스트 라벨 함께).
- 색맹 친화: accent 7색은 명도 차이로 구분 가능 — 단, 텍스트 함께 권장.

---

## Figma Make 프롬프트
```
ContentBadge: 정적 라벨
Sizes: xsmall(11px caption2), small(12px caption1), medium(13px label2)
Variants: solid | outlined
Color groups: neutral | accent (redOrange/lime/cyan/lightBlue/violet/purple/pink)

Solid neutral: bg fill/normal, text label/normal
Solid accent: bg accent/background/{name}, text white
Outlined neutral: 1px line/normal/neutral, text label/normal
Outlined accent: 1px accent/foreground/{name}, text accent/foreground/{name}

Radius: 6/6/8 (size별)
인터랙션 없음 (Chip과 구분)

네이밍: ContentBadge / Solid / Neutral / Medium, ContentBadge / Outlined / Accent-Cyan / Small
```
