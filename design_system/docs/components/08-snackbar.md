# 컴포넌트: 스낵바 (Snackbar)

## 개요
일시적 시스템 피드백용 알림. 화면 가장자리(보통 하단 중앙)에 등장해 일정 duration 후 자동 dismiss. 텍스트 + 선택적 액션 버튼 + 닫기 버튼 슬롯 구조.

> Toast와 거의 동일하지만 Wanted Montage는 두 컴포넌트를 분리: **Snackbar는 액션 가능, Toast는 단순 알림**. 본 명세는 Snackbar.

> **Harness Principle:** Snackbar의 lifecycle은 **글로벌 region store**에서 관리 (`region-store`). 컴포넌트는 단일 인스턴스 시각만 담당.

---

## 🎨 디자인 기준

### 1. 독창성 및 톤앤매너
- 다크 톤(`color/inverse/background`) 기본 — 라이트 모드에서도 강한 대비로 즉시 인식.
- variant별로 leading 아이콘이 자동 매핑되어 시각 일관성 유지.

### 2. 크래프트
- Region store가 등장 순서·duration·rate limiting을 일괄 관리 — 여러 snackbar 동시 호출 시 큐잉.
- forceMount로 애니메이션 디버깅 시 보존 가능.

### 3. 기능성
- Action 버튼은 1개만 권장 (한 줄 안에 들어가야 함).
- onAnimationEnd 콜백으로 등장/퇴장 동기화 가능 (예: focus 이동, analytics).

---

## 디자인 토큰 매핑

| 토큰 | 값 (Semantic) |
|---|---|
| 배경 | `color/inverse/background` |
| 텍스트 | `color/inverse/label` |
| Heading 폰트 | `text/label1` × `font/weight/bold` |
| Description 폰트 | `text/label2` × `font/weight/regular` |
| 보더 반경 | `radius/lg` (12px) |
| 그림자 | `shadow/normal/large` |
| 패딩 | `spacing/12` × `spacing/16` |
| Gap (자식들) | `spacing/8` |
| Min-width | 280px |
| Max-width | 480px |
| 트리거 위치 | bottom-center, 페이지 하단에서 `spacing/24` 위 |
| 트랜지션 | `motion/transition/transform` + `motion/keyframe/slide-up` |

---

## 변형 (Variant)

| Variant | Leading Icon | 사용처 |
|---|---|---|
| `info` (기본) | ℹ️ | 일반 알림 |
| `success` | ✓ | 작업 완료 |
| `warning` | ⚠️ | 주의 필요 |
| `error` | ✕ | 실패/오류 |

> Region store의 `RegionSnackbarItem` 타입이 variant를 받아 자동 매핑.

---

## 상태 (State) 및 인터랙션

| 상태 | 시각 표현 / 변경 토큰 | 모션 토큰 |
|---|---|---|
| Hidden | unmount | — |
| Entering | 하단에서 슬라이드 업 + fade-in | `motion/keyframe/slide-up` 300ms ease-out |
| Visible | duration 동안 유지 (기본 ~3-5초) | — |
| Action Hover | Action 버튼 텍스트 색 강조 | `motion/transition/colors` |
| Closing (auto) | duration 만료 후 fade-out + slide-down | `motion/keyframe/fade-out` 200ms |
| Closing (manual) | 닫기 버튼 클릭 시 즉시 퇴장 | `motion/keyframe/fade-out` 150ms |

---

## 합성 슬롯

| 컴포넌트 | 역할 |
|---|---|
| `<Snackbar>` | 외곽 컨테이너 + lifecycle 관리 |
| `<SnackbarContent>` | 본문 컨테이너 (FlexBox) |
| `<SnackbarHeading>` | 제목 (Typography) |
| `<SnackbarDescription>` | 설명 (Typography) |
| `<SnackbarExtraContent>` | 추가 컨텐츠 슬롯 |
| `<SnackbarAction>` | 액션 버튼 (TextButton 기반) |
| `<SnackbarCloseButton>` | 닫기 버튼 (IconButton 기반) |

---

## 접근성 (Accessibility)
- `role="status"` (또는 `role="alert"` for error variant) — 스크린리더가 자동 읽음.
- `aria-live="polite"` (info/success), `aria-live="assertive"` (warning/error).
- 키보드: Action 버튼 포커스 가능. Esc로 닫기 (선택).
- Reduced motion: 애니메이션 비활성, 즉시 표시/숨김.

---

## Figma Make 프롬프트

```
Wanted Montage Snackbar 컴포넌트:

Variants: info / success / warning / error (각 leading icon 다름)

외형:
- bg: inverse/background (다크 톤)
- text: inverse/label
- radius: 12px
- shadow: shadow/normal/large
- padding: 12px 16px
- min-width 280px, max-width 480px

위치: 페이지 하단 중앙, bottom: 24px

Slots:
- leading icon (variant별)
- Heading (label1 bold) + Description (label2 regular)
- Action button (TextButton, 1개만)
- Close button (IconButton)

Animation:
- entering: slide-up + fade-in 300ms ease-out
- closing (auto): fade-out 200ms after duration
- closing (manual): fade-out 150ms

duration default: 3000-5000ms (variant별)

접근성:
- role=status (info/success), role=alert (warning/error)
- aria-live polite/assertive

네이밍: Snackbar / Info, Snackbar / Success, Snackbar / Error
```
