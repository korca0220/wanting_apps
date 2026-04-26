# 컴포넌트: 리스트 아이템 (List Item)

## 개요
리스트의 행 하나를 구성하는 합성 컴포넌트. **leading + content (title + 선택적 caption) + trailing** 3슬롯 구조로 설정 화면, 메뉴, 폼 행 등 광범위에 적용. wds `list` 패키지 기반.

> **Harness Principle (P6 Layered):** ListItem은 *시각 슬롯 컨테이너*만 제공. 실제 동작은 trailing 슬롯의 컴포넌트(Switch, IconButton 등) 또는 행 전체 on-tap에서.

---

## 🎨 디자인 기준

### 1. 독창성 및 톤앤매너
- 가벼운 hover/active 피드백으로 "터치 가능"을 자연스럽게 신호.
- divider는 외부 컨테이너에서 추가 (ListItem 자체는 분리선 없음 — 합성 자유도 ↑).

### 2. 크래프트
- 좌측 leading 영역 너비 고정(40 또는 56px)로 행간 정렬 일치.
- title/caption 사이 라인하이트가 viewport 높이에 자연스럽게 들어맞도록.

### 3. 기능성
- 행 전체가 인터랙티브일 때 터치 영역 ≥ 56px 높이 보장.
- trailing의 Switch 등 인터랙티브 컨트롤이 행 자체의 on-tap과 충돌하지 않도록 stopPropagation 패턴.

---

## 디자인 토큰 매핑

### Container
| 토큰 | 값 |
|---|---|
| 배경 | `transparent` (또는 `color/background/normal/normal`) |
| 패딩 | `spacing/12` × `spacing/16` |
| Min-height | 56px (단행) / 72px (caption 포함) |
| Gap (leading↔content) | `spacing/12` |
| Gap (content↔trailing) | `spacing/12` |

### Content (title + 선택적 caption)
| 토큰 | 값 |
|---|---|
| Title 폰트 | `text/body1` × `font/weight/regular` |
| Title 색 | `color/label/normal` |
| Caption 폰트 | `text/label2` |
| Caption 색 | `color/label/alternative` |
| Title↔Caption gap | `spacing/2` |

### Slots
| Slot | 일반적 컴포넌트 | 너비 |
|---|---|---|
| `leading` | Avatar, Icon, ContentBadge | 40~56px (고정) |
| `content` | Label (title + 선택적 caption) | 1fr (잔여) |
| `trailing` | IconButton, Switch, Chip, ContentBadge, chevron icon | auto |

---

## 변형 (Variant)

### `default` (기본)
- 행 전체 정적 또는 `on-tap`으로 전체 인터랙티브.

### `with-control`
- trailing에 Switch/Checkbox 등 폼 컨트롤. 행 자체의 on-tap은 비활성화하거나 trailing과 동일 콜백 매핑.

### `nested-action`
- trailing에 IconButton(예: 더보기 메뉴). 행 클릭과 별개로 trailing 클릭 시 다른 동작.

### `dense`
- min-height 48px, 패딩 `spacing/8` × `spacing/12`. 메뉴 등 좁은 컨텍스트.

---

## 상태 (State) 및 인터랙션

| 상태 | 시각 표현 / 변경 토큰 | 모션 토큰 |
|---|---|---|
| Default | container 토큰 그대로 | — |
| Hover (인터랙티브 행) | 배경 `color/fill/normal` | `motion/transition/colors` |
| Focus (키보드, 인터랙티브 행) | `shadow/focus` 또는 outline | — |
| Active / Pressed | 배경 `color/fill/strong` | `motion/transition/colors` |
| Selected | 배경 `color/primary/subtle`, 좌측 4px primary 보더 | `motion/transition/colors` |
| Disabled | 텍스트 `color/label/disable`, leading/trailing opacity 0.4, pointer-events: none | — |

> 정적 행(인터랙티브 아님)은 Hover/Focus/Active 상태 없음.

---

## 합성 슬롯 (자세히)

| 컴포넌트 | 역할 |
|---|---|
| `<ListItem>` | 외곽 컨테이너 (FlexBox row) |
| `<ListItemLeading>` | 좌측 슬롯 (avatar/icon) |
| `<ListItemContent>` | 중앙 슬롯 (title + caption) |
| `<ListItemTitle>` | 제목 (Typography 기반) |
| `<ListItemCaption>` | 보조 텍스트 (Typography 기반) |
| `<ListItemTrailing>` | 우측 슬롯 (control/chevron) |

각 슬롯은 child 컴포넌트를 프롭으로 받거나 children으로 받음.

---

## 접근성
- 행 전체가 인터랙티브일 때: `<button>` 또는 `<a>` 사용. 또는 div+`role="button"`+`tabindex="0"`.
- 키보드: Enter/Space로 활성화. trailing 컨트롤은 별개 포커스 스톱.
- 스크린리더 패턴: "{title}, {caption}, {trailing 의미}" 순으로 자연스럽게 읽힘.
- Selected 상태에 `aria-current="true"` 또는 `aria-selected="true"` (컨텍스트에 따라).
- 최소 터치 영역: ≥ 56px 높이 (default), 48px (dense는 모바일에서 비권장).

---

## Figma Make 프롬프트

```
ListItem 합성 컴포넌트:

레이아웃 (flex row, vertical center 정렬):
- leading slot (40~56px 고정 너비)
- content slot (flex 1) — title + 선택적 caption (column, gap 2)
- trailing slot (auto)
- gap: 12px (leading↔content, content↔trailing)
- padding: 12px 16px
- min-height: 56 (단행) / 72 (caption 포함)

Slots 일반 콘텐츠:
- leading: Avatar / Icon / Badge
- content title: body1 regular, label/normal
- content caption: label2 regular, label/alternative
- trailing: IconButton (chevron-right) / Switch / Chip

Variants:
- default: 정적 또는 on-tap 인터랙티브
- with-control: trailing에 Switch — 행 on-tap은 toggle과 동일
- nested-action: trailing에 IconButton (행 클릭과 별개 동작)
- dense: min-height 48, padding 8×12 (메뉴 등)

States (인터랙티브 행만):
- hover: bg fill/normal
- focus: outline ring
- active: bg fill/strong
- selected: bg primary/subtle + 좌측 4px primary 보더
- disabled: opacity 0.4, pointer-events none

네이밍: ListItem / Default, ListItem / WithControl, ListItem / Selected, ListItem / Dense
```
