# 컴포넌트: 툴팁 (Tooltip)

## 개요
호버·포커스·클릭 트리거로 나타나는 작은 보조 정보 패널. 3가지 mode(`hover`/`always`/`click`), 2가지 size(`small`/`medium`), 4방향 위치, 단축키(shortcut) 슬롯 지원. Floating UI 기반 자동 위치 조정.

> **Harness Principle:** 툴팁은 **포커스 가능한 자식을 포함하지 않습니다** — 키보드 사용자가 툴팁 안 콘텐츠에 접근할 방법이 없어 접근성 함정. action/closeButton props는 deprecated.

---

## 🎨 디자인 기준

### 1. 독창성 및 톤앤매너
- 페이지 배경의 **반전 톤**(라이트에서는 어두운 배경, 다크에서는 밝은 배경) — 강한 대비로 즉시 인식 가능.
- Shortcut 슬롯에 `⌘C`처럼 키 표기 가능 — 데스크톱 제품 친화.

### 2. 크래프트
- Floating UI offset/position 자동 처리. 화면 가장자리 도달 시 자동 flip.
- 200ms ease-in-out mount/unmount keyframe — 너무 느리지도 빠르지도 않은 자연스러움.

### 3. 기능성
- `enterDelay`/`leaveDelay`로 의도치 않은 hover trigger 방지 (기본 ~500ms).
- `TooltipGroup`으로 묶인 형제 툴팁들은 빠른 전환 시 delay skip — 메뉴바 같은 시나리오에 적합.

---

## 디자인 토큰 매핑

| 토큰 | 값 (small) | 값 (medium) |
|---|---|---|
| 폰트 | `text/caption1` (12px) | `text/label2` (13px) |
| 배경 | `color/inverse/background` | `color/inverse/background` |
| 텍스트 색 | `color/inverse/label` | `color/inverse/label` |
| 패딩 | `spacing/4` × `spacing/8` | `spacing/6` × `spacing/10` |
| 보더 반경 | `radius/sm` (6px) | `radius/md` (8px) |
| 그림자 | `shadow/normal/medium` | `shadow/normal/medium` |
| 트리거 간격 (offset) | 8px | 8px |
| Shortcut 텍스트 | `text/caption2` × `font/weight/medium` | `text/caption1` × `font/weight/medium` |

---

## 상태 (State) 및 인터랙션

> ⚠️ 컨테이너 컴포넌트는 명시적 상태 표 필수.

| 상태 | 시각 표현 / 변경 토큰 | 모션 토큰 |
|---|---|---|
| Hidden | 렌더되지 않음 (forceMount false 시 unmount) | — |
| Visible (Hover) | `enterDelay` 후 등장 | `motion/keyframe/fade-in` 200ms ease-in-out |
| Visible (Focus) | 즉시 등장 (mode=hover + focus) | `motion/keyframe/fade-in` 200ms |
| Visible (Click) | 토글, dismissable layer | `motion/keyframe/fade-in` 200ms |
| Visible (Always) | 항상 표시, dismissable layer | — |
| Closing | leaveDelay 후 퇴장, 또는 outside click 시 즉시 | `motion/keyframe/fade-out` 200ms ease-in-out |
| Position Flip | 화면 가장자리 도달 시 자동 반대 방향 | — |

---

## 접근성 (Accessibility)
- `role="tooltip"` 자동 적용. 트리거에 `aria-describedby` 자동 연결.
- 키보드 포커스로 표시 (mode=hover + disableOpenOnFocus=false).
- Esc로 즉시 닫기 (focus는 트리거에 유지).
- **포커스 가능한 자식 금지**: action/closeButton 사용 금지. 그런 UI가 필요하면 Popover로 변경.
- Reduced motion: 모든 keyframe 비활성, 즉시 표시/숨김.

---

## Figma Make 프롬프트

```
Wanted Montage Tooltip 컴포넌트:

Sizes: small(12px caption1) / medium(13px label2)
Modes: hover, always, click

외형:
- 배경: inverse/background (라이트=어두운 회색, 다크=밝은 회색)
- 텍스트: inverse/label (배경 반전 색)
- 패딩 small: 4px 8px / medium: 6px 10px
- radius small: 6px / medium: 8px
- shadow/normal/medium

Position: top, right, bottom, left (자동 flip)
- offset 8px from trigger
- 화살표는 선택적 (디폴트 없음)

Shortcut 슬롯: 우측에 caption2 medium으로 표시 (예: ⌘C)

Animation:
- mount: fade-in 200ms ease-in-out
- unmount: fade-out 200ms ease-in-out

상태:
- hover mode: enterDelay 500ms + leaveDelay 200ms
- click mode: 토글, outside click으로 닫힘

접근성:
- role="tooltip", aria-describedby on trigger
- 포커스 가능 자식 없음

네이밍: Tooltip / Small / Top, Tooltip / Medium / Bottom
```
