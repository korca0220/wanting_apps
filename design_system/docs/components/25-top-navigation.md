# 컴포넌트: 탑 네비게이션 (Top Navigation)

## 개요
화면 상단에 고정되는 헤더 네비게이션 바. **leading + title + trailing** 3슬롯. 뒤로가기 + 화면 제목 + 액션 버튼이 표준 패턴. wds `top-navigation` 패키지 기반.

> **Harness Principle:** TopNavigation은 *시각 컨테이너* + *제목 표시*. 뒤로가기 동작 자체는 leading 슬롯에 들어가는 IconButton이나 라우터 콜백.

---

## 🎨 디자인 기준

### 1. 독창성 및 톤앤매너
- 미니멀한 hairline 보더 (1px) — 무거운 그림자 대신 절제된 구분.
- title 중앙 정렬과 좌측 정렬 두 variant — 콘텐츠 위계에 따라.

### 2. 크래프트
- 좌우 슬롯 너비 동일하게 reserve해 title이 정확히 중앙 (centered variant).
- safe-area-inset-top 자동 적용 (status bar 영역 위로 확장).

### 3. 기능성
- title이 길면 ellipsis 또는 자동 축소.
- emphasized variant로 헤더에 colored bg 또는 큰 타이틀 (bottom sheet 헤더 등).

---

## 디자인 토큰 매핑

### Container
| 토큰 | 값 |
|---|---|
| 배경 | `color/background/elevated/normal` |
| 하단 보더 | `1px color/line/normal/neutral` |
| 그림자 | (선택) `shadow/normal/xsmall` 또는 sticky 스크롤에서만 |
| 높이 | 56px (default) / 72px (emphasized — 큰 타이틀) |
| 패딩-x | `spacing/4` (좌우 IconButton에 자연스러운 hit area) |
| safe-area-inset-top | 자동 적용 |
| z-index | 50 (모달 1300, BottomNav 100보다 낮게) |

### Title
| 토큰 | 값 (default) | 값 (emphasized) |
|---|---|---|
| 폰트 | `text/headline2` × `font/weight/bold` | `text/title3` × `font/weight/bold` |
| 색 | `color/label/normal` | `color/label/strong` |
| 정렬 | `centered` (기본) 또는 `leading` | `leading` |

### Slots
| Slot | 일반 컴포넌트 | 너비 |
|---|---|---|
| `leading` | IconButton (back), Button(text), 또는 비움 | 48~56px (centered variant 정렬용) |
| `title` | Label (또는 inline text) | 1fr 또는 auto |
| `trailing` | IconButton, Button, 또는 비움 | 48~56px |

---

## 변형 (Variant)

### `default` (centered title)
- 좌우 슬롯이 동일 너비로 reserve, title은 중앙 정렬.
- iOS 스타일.

### `leading` (left-aligned title)
- title이 leading 슬롯 우측에 좌측 정렬. 검색·필터 등의 헤더에 적합.

### `emphasized`
- 높이 72px, title이 큼(`text/title3`). bottom-sheet/full-modal 헤더에 자주 사용.
- 보통 leading 정렬 + scrollable 시 자동으로 default로 축소되는 collapsed pattern 가능.

### `transparent`
- 배경 투명, hero 영역 위에 overlay 시 사용. 텍스트 색은 컨텍스트에 따라.

---

## 상태 (State) 및 인터랙션

| 상태 | 시각 표현 / 변경 토큰 | 모션 토큰 |
|---|---|---|
| Default | container 토큰 | — |
| Sticky scroll | (sticky 모드에서) 내용 스크롤 시 그림자 fade-in | `motion/transition/shadow` |
| Emphasized → Default (collapse) | scroll 따라 높이/font-size 축소 | `motion/transition/transform` |

> 자체 인터랙션은 없음. 슬롯 안 컴포넌트의 hover/focus가 행동.

---

## 합성 슬롯

| 컴포넌트 | 역할 |
|---|---|
| `<TopNavigation variant>` | 외곽 컨테이너 |
| `<TopNavigationLeading>` | 좌측 슬롯 |
| `<TopNavigationTitle>` | 제목 (Typography) |
| `<TopNavigationTrailing>` | 우측 슬롯 |
| `<TopNavigationButton>` | 슬롯 안의 표준 버튼 (IconButton 유사하나 좌우 정렬 자동) |

---

## 접근성
- 시맨틱: `<header>` 또는 `<nav role="navigation">`.
- 좌측 IconButton(back)에 `aria-label="뒤로 가기"` 필수.
- title은 Heading 시맨틱(`<h1>` 또는 `<h2>`) 또는 `aria-level` 명시 — 화면의 첫 heading이 되도록.
- **포커스 순서**: leading → title (포커스는 보통 X) → trailing.
- 키보드: 표준 Tab 순서.
- safe-area-inset 자동 처리 (notch/status bar 영역 침범 방지).

---

## Figma Make 프롬프트

```
TopNavigation 컴포넌트:

Container:
- height: 56 (default) / 72 (emphasized)
- bg: background/elevated/normal
- border-bottom: 1px line/normal/neutral
- 화면 상단 fixed, safe-area-inset-top 자동
- z-index 50

Layout (flex row, vertical center):
- leading slot (48~56px reserved)
- title slot (flex 1, centered or leading-aligned)
- trailing slot (48~56px reserved)

Title:
- default: headline2 bold, label/normal, centered
- emphasized: title3 bold, label/strong, leading-aligned

Slots:
- leading: IconButton (back chevron) 또는 비움
- trailing: IconButton 또는 Button(text) 또는 비움

Variants: default | leading | emphasized | transparent

States:
- sticky scroll: 내용 위 스크롤 시 shadow/normal/xsmall fade-in
- emphasized → default: scroll에 따라 자동 collapse

접근성: <header>/<nav>, leading IconButton에 aria-label, title은 적절한 heading

네이밍: TopNavigation / Default, TopNavigation / Emphasized, TopNavigation / Transparent
```
