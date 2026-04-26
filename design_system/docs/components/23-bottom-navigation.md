# 컴포넌트: 바텀 네비게이션 (Bottom Navigation)

## 개요
모바일 화면 하단에 고정되는 주요 페이지 전환 네비게이션. 2~5개 탭을 균등 분포하며 현재 활성 탭을 시각적으로 강조. Wanted Montage의 `bottom-navigation` 패키지 기반.

> **Harness Principle (P6 Layered):** BottomNavigation은 라우팅 *시각*만 담당. 라우트 결정은 상위에서 onChange/href로 주입.

---

## 🎨 디자인 기준

### 1. 독창성 및 톤앤매너
- 모바일 OS 표준(iOS Tab Bar / Android BottomNav)을 따르되, label 색상에 wanted Primary 사용으로 브랜드 일관성 유지.
- 활성 표시는 **아이콘 fill 변경 + 라벨 색 변화**로 절제된 위계 (배경 강조 X — 현대적인 미니멀 톤).

### 2. 크래프트
- 하단 safe-area inset 자동 적용 (iOS notch / Android gesture bar).
- 아이콘과 라벨이 수직 정렬 + 균등 분포 (flex 1).
- 64~72px 표준 높이로 터치 타겟 보장.

### 3. 기능성
- 탭 전환은 즉시 (페이지 transition 미포함 — 라우팅 측 결정).
- Badge 표시 가능 (notification count). 

---

## 디자인 토큰 매핑

### Container (네비게이션 바)
| 토큰 | 값 |
|---|---|
| 배경 | `color/background/elevated/normal` |
| 상단 보더 | `1px color/line/normal/neutral` |
| 그림자 (선택) | `shadow/normal/xsmall` (위로 향한 미세 입체감) |
| 높이 | 64~72px (safe-area inset 별도) |
| z-index | 100 (모달 1300보다 낮게) |

### Item (개별 탭)
| 토큰 | 값 (Inactive) | 값 (Active) |
|---|---|---|
| 아이콘 색 | `color/label/alternative` | `color/primary/normal` |
| 아이콘 크기 | 24px | 24px |
| 아이콘 fill | outlined | filled (variant 차이) |
| 라벨 폰트 | `text/caption1` (12px) × `font/weight/medium` | 동일 + bold |
| 라벨 색 | `color/label/alternative` | `color/primary/normal` |
| Item gap (icon ↔ label) | `spacing/2` | `spacing/2` |
| Item padding | `spacing/8` × `spacing/4` | 동일 |
| 트랜지션 | `motion/transition/colors` (150ms) | 동일 |

### Badge (선택 — notification dot)
| 토큰 | 값 |
|---|---|
| 위치 | 아이콘 우상단, offset 2px |
| dot size | 8px (no count) / `auto` (with count) |
| 배경 | `color/status/negative` |
| 텍스트 (count) | `text/caption2` (11px) bold, `color/static/white` |

---

## 변형 (Variant)

| Variant | 사용처 |
|---|---|
| `with-label` (기본) | 아이콘 + 라벨 (모바일 표준) |
| `icon-only` | 라벨 생략 (아주 좁은 화면 또는 5+ 탭) |

탭 개수: 2~5개 권장. 6개 이상은 More 메뉴로 분리 권장.

---

## 상태 (State) 및 인터랙션

| 상태 | 시각 표현 / 변경 토큰 | 모션 토큰 |
|---|---|---|
| Inactive | 아이콘/라벨 `color/label/alternative` | — |
| Hover (데스크탑) | 아이콘/라벨 `color/label/normal` | `motion/transition/colors` |
| Focus | `shadow/focus` ring 또는 outline | — |
| Active (current route) | 아이콘 filled + `color/primary/normal`, 라벨 bold + `color/primary/normal` | `motion/transition/colors` |
| Pressed | 아이콘/라벨 약간 어두워지며 미세 scale(0.95) | 100ms |
| Disabled | 아이콘/라벨 `color/label/disable`, pointer-events: none | — |
| With Badge | 아이콘 우상단 dot 또는 count | — |

---

## 합성 슬롯

| 컴포넌트 | 역할 |
|---|---|
| `<BottomNavigation>` | 외곽 컨테이너 |
| `<BottomNavigationItem>` | 개별 탭 (icon + label + 선택적 badge) |

각 Item은 다음 props:
- `icon` (필수): 아이콘 ID
- `activeIcon` (선택): 활성 시 다른 아이콘 (filled variant 등)
- `label` (필수, with-label variant): 라벨 텍스트
- `route` 또는 `value` (필수): 식별자
- `active` (boolean): 현재 활성 여부
- `badge` (선택): notification dot 또는 count
- `on-tap` (필수): 탭 시 콜백

---

## 접근성
- `role="navigation"` 또는 `<nav>` 시맨틱.
- 각 Item: `<button>` 또는 `<a href>` (라우팅에 따라). `aria-current="page"`로 활성 탭 명시.
- 키보드: Tab으로 진입, 화살표(←→)로 Item 사이 이동, Enter로 활성화.
- 라벨 없는 variant는 `aria-label` 필수.
- Badge가 있을 때 `aria-label`에 카운트 포함 (예: "메시지 (3개 안 읽음)").
- 최소 터치 타겟: Item ≥ 48×48px.

---

## Figma Make 프롬프트

```
BottomNavigation 컴포넌트:

Container:
- height: 64~72px (mobile)
- bg: background/elevated/normal
- border-top: 1px line/normal/neutral
- safe-area-inset-bottom 자동 적용
- 화면 하단 fixed

Items: 2~5개 균등 분포 (flex: 1)
- Inactive: icon outlined + label/alternative 색, caption1 medium
- Active: icon filled + primary/normal 색, caption1 bold
- Pressed: 미세 scale(0.95) 100ms
- Hover (desktop): label/normal
- Focus: outline ring
- Disabled: label/disable

Item 내부 (column):
- icon 24×24
- gap 2px
- label 12px medium

Badge (선택):
- dot 8×8, status/negative bg, 아이콘 우상단
- count 표시: caption2 bold white on negative bg

네이밍: BottomNavigation / Default, BottomNavigationItem / Inactive, /Active, /WithBadge
```
