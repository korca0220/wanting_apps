# 컴포넌트: 탭 (Tabs)

## 개요
같은 컨테이너 안에서 콘텐츠 섹션을 전환하는 탭 네비게이션. 2가지 variant: `underline`(전체 너비 + 활성 보더) / `pills`(둥근 컨테이너 + 활성 fill). wds `tab` 패키지 기반.

> **Harness Principle:** Tabs는 *시각 + 키보드* 동작만 제공. 콘텐츠 패널 표시는 외부 라우팅/state로.

---

## 🎨 디자인 기준

### 1. 독창성 및 톤앤매너
- underline은 전통적이지만 **2px 인디케이터 + Primary 색**으로 절제.
- pills는 흰 카드 + subtle shadow로 떠 있는 듯한 입체감.

### 2. 크래프트
- 활성 인디케이터의 transition (slide 또는 fade)으로 탭 전환의 *지속성* 신호.
- font-weight 변화(regular → semibold)로 활성 강조 — 색상만으론 부족할 수 있음.

### 3. 기능성
- 탭이 많아 가로 넘침 발생 시 가로 스크롤 또는 dropdown 폴백.
- 키보드 화살표로 탭 사이 이동 — focus가 자동 이동하나 selection은 별도 (W3C ARIA 패턴).

---

## 디자인 토큰 매핑

### Underline Variant (기본)

#### Container
| 토큰 | 값 |
|---|---|
| 배경 | `transparent` |
| 하단 보더 | `1px color/line/normal/neutral` (전체 너비) |
| 패딩 | `0` |

#### Tab Item
| 토큰 | 값 (Inactive) | 값 (Active) |
|---|---|---|
| 폰트 | `text/label1` × `font/weight/medium` | `text/label1` × `font/weight/semibold` |
| 텍스트 색 | `color/label/alternative` | `color/primary/normal` (라이트) / `color/primary/normal` (다크 매핑됨) |
| Hover 텍스트 | `color/label/normal` | (활성 색 유지) |
| 패딩 | `spacing/10` × `spacing/16` | 동일 |
| 인디케이터 | 없음 | `2px solid color/primary/normal` 하단 |
| 트랜지션 | `motion/transition/colors` (150ms ease-out) | 동일 + 인디케이터 slide |

### Pills Variant

#### Container (둥근 박스)
| 토큰 | 값 |
|---|---|
| 배경 | `color/fill/normal` |
| 보더 반경 | `radius/md` (8px) |
| 패딩 | `spacing/4` |

#### Tab Item
| 토큰 | 값 (Inactive) | 값 (Active) |
|---|---|---|
| 폰트 | `text/label2` × `font/weight/medium` | `text/label2` × `font/weight/semibold` |
| 텍스트 색 | `color/label/alternative` | `color/label/normal` |
| 배경 (Inactive) | `transparent` | `color/background/elevated/normal` |
| 그림자 (Active) | 없음 | `shadow/normal/xsmall` |
| 보더 반경 | `radius/sm` (6px) | `radius/sm` (6px) |
| 패딩 | `spacing/6` × `spacing/14` | 동일 |
| 트랜지션 | `motion/transition/colors` | 동일 + bg fade |

---

## 변형 (Variant)

| Variant | 사용처 |
|---|---|
| `underline` (기본) | 페이지 메인 섹션 전환 (가독성 ↑) |
| `pills` | 좁은 영역, 카드 안 토글, 옵션 그룹 |

추가 옵션:
- `fullWidth: true` — 탭들이 컨테이너 너비를 균등 분할 (모바일 권장)
- `scrollable: true` — 탭이 많아 가로 스크롤 (보통 underline에서)

---

## 상태 (State) 및 인터랙션

> ⚠️ 컨테이너 컴포넌트 — 명시적 상태 표 필수.

| 상태 | 시각 표현 / 변경 토큰 | 모션 토큰 |
|---|---|---|
| Default (Inactive) | variant별 inactive 토큰 | — |
| Hover | 텍스트 진하게 (`color/label/normal`) | `motion/transition/colors` |
| Focus | `shadow/focus` 또는 outline (필수, 키보드 진입) | — |
| Selected (Active) | variant별 active 토큰 + 인디케이터 | `motion/transition/colors` + 인디케이터 slide |
| Disabled | 텍스트 `color/label/disable`, pointer-events: none | — |

---

## 합성 슬롯

| 컴포넌트 | 역할 |
|---|---|
| `<Tabs variant value onChange>` | 외곽 컨테이너 + state 관리 |
| `<TabList>` | 탭 목록 wrapper (role=tablist) |
| `<Tab value>` | 개별 탭 (role=tab) |
| `<TabPanel value>` | 콘텐츠 패널 (role=tabpanel, 활성 탭과 매칭 시 노출) |

---

## 접근성

WAI-ARIA Tabs 패턴 (자동 처리):
- Container: `role="tablist"`, `aria-orientation="horizontal"`
- Tab: `role="tab"`, `aria-selected={active}`, `aria-controls={panelId}`, `tabindex={active ? 0 : -1}`
- TabPanel: `role="tabpanel"`, `aria-labelledby={tabId}`

키보드:
- **←/→**: 이전/다음 탭으로 포커스 이동
- **Home/End**: 첫/마지막 탭
- **Enter/Space**: 활성화 (manual activation 모드)
- **자동 활성화 모드**: 화살표만 누르면 자동 selection (대부분 권장)

---

## Figma Make 프롬프트

```
Tabs 컴포넌트:

Variants: underline | pills

Underline (기본):
- 컨테이너: 하단 1px line/normal/neutral, padding 0
- Tab inactive: label1 medium, color label/alternative, padding 10×16
- Tab active: label1 semibold, color primary/normal, 하단 2px primary/normal 인디케이터
- Tab hover: color label/normal
- 인디케이터 transition slide 150ms ease-out

Pills:
- 컨테이너: bg fill/normal, radius 8 (radius/md), padding 4
- Tab inactive: label2 medium, color label/alternative, transparent bg, radius 6
- Tab active: label2 semibold, color label/normal, bg background/elevated/normal, shadow xsmall
- Tab padding: 6×14

옵션:
- fullWidth: 탭 균등 분할
- scrollable: 가로 스크롤 (underline 위주)

States:
- inactive (default), hover, focus (ring), active/selected, disabled

접근성: WAI-ARIA tabs 패턴 — role=tablist, role=tab, aria-selected, ←/→ 키보드 이동

네이밍: Tabs / Underline, Tabs / Pills, Tab / Active, Tab / Inactive
```

---

## API (Flutter)

`WdsTabs`는 제네릭 `T`로 식별되는 탭 그룹입니다.

| Prop | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `value` | `T` | required | 현재 선택된 탭의 식별자. |
| `onChanged` | `ValueChanged<T>` | required | 선택 변경 콜백. 패널 렌더는 호출자 책임. |
| `tabs` | `List<WdsTabItem<T>>` | required | 각 탭의 `value`/`label`/`disabled`. |
| `variant` | `WdsTabsVariant` | `underline` | `underline` / `pills`. |
| `fullWidth` | `bool` | `false` | 탭이 컨테이너 너비를 균등 분할. |
| `scrollable` | `bool` | `false` | 가로 스크롤(주로 underline). |

구현 메모:
- 활성 인디케이터(underline 2px 바, pills elevated 배경)는 `GlobalKey`로 선택 탭의 RenderBox 위치를 측정 후 `AnimatedPositioned`로 200ms slide.
- 첫 프레임에는 인디케이터가 그려지지 않을 수 있음 (post-frame measure 후 setState로 표시).
- 키보드 ←/→ 자동 이동은 미구현 — 표준 Tab/Enter만 동작. 후속.
