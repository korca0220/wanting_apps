# 컴포넌트: 스피너 (Spinner / Loading)

## 개요
비동기 처리 중 사용자에게 진행 상태를 알리는 회전 인디케이터. 2가지 variant: `wanted`(브랜드 시그니처) / `circular`(범용 원형).

> **Harness Principle:** 결정성 있는 진행률은 `ProgressTracker` 사용. 끝나는 시점 모르는 indeterminate 상태에만 Spinner.

---

## 디자인 토큰 매핑

| 토큰 | 값 |
|---|---|
| 기본 size | 24px (변경 가능, `size` prop) |
| 색상 | `currentColor` (부모 텍스트 색 상속) |
| 두께 | size의 ~10% (예: 24px → 2.4px stroke) |
| 회전 속도 | 1초 / cycle (linear infinite) |
| Easing (color rotate) | `cubic-bezier(0.5, 0, 0.5, 1)` |

---

## 변형 (Variant)

### `wanted` (시그니처)
브랜드 색상으로 더 풍부한 색 변화 사이클. 4단계 색상이 회전하며 점진적으로 바뀜:
- 단계 1: `color/primary/normal`
- 단계 2: `color/accent/foreground/lightBlue`
- 단계 3: `color/accent/foreground/violet`
- 단계 4: `color/accent/foreground/blue`

각 단계 ~1초 fade transition. 총 4초 한 사이클.

### `circular` (범용)
단색 회전. `color`/`currentColor` 한 가지로 80~360도 호 회전.

---

## 상태
| 상태 | 시각 표현 | 모션 |
|---|---|---|
| Visible | 회전 중 (variant별 motion) | `animation: rotate infinite` |

> Spinner는 항상 motion. Reduced motion 환경에선 회전 비활성 + opacity pulse로 폴백.

---

## 접근성
- `role="status"`, `aria-live="polite"`로 "로딩 중" 상태 자동 안내.
- `aria-label="로딩 중"` 또는 인접 visually-hidden 텍스트.
- Reduced motion: 회전 비활성, opacity 0.4 → 1.0 pulse 1초 cycle로 대체.

---

## Figma Make 프롬프트
```
Spinner:
- Variant `wanted`: 4색 사이클 (primary → lightBlue → violet → blue), 1초씩 페이드, 동시 회전
- Variant `circular`: 단색 회전 호, currentColor
- Default size 24px, 변경 가능
- Stroke width ~size×0.1
- 회전: 1초 cycle linear infinite
- Reduced motion: opacity pulse로 폴백

role=status, aria-live=polite, aria-label="로딩 중"

네이밍: Spinner / Wanted / Default, Spinner / Circular / Default
```
