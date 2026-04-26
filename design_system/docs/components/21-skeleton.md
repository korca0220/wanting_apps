# 컴포넌트: 스켈레톤 (Skeleton)

## 개요
로딩 중 콘텐츠 자리 표시자. 3가지 variant(`text`/`circle`/`rectangle`)로 다양한 콘텐츠 형태에 매칭. shimmer 또는 pulse 애니메이션.

> **Harness Principle:** Skeleton은 로딩 시 *형태*를 미리 채워 layout shift 0을 보장. 빈 화면 + 스피너보다 인지 부담이 낮음.

---

## 디자인 토큰 매핑

| 토큰 | 기본값 |
|---|---|
| 색상 | `color/fill/normal` (변경 가능 — `color` prop) |
| 알파 | `opacity` prop (기본 100%) |
| 보더 반경 (text) | `radius/sm` (6px) |
| 보더 반경 (circle) | `radius/full` |
| 보더 반경 (rectangle) | `radius/md` (8px, prop으로 변경) |
| 애니메이션 | shimmer 1.5초 ease-in-out infinite, 또는 opacity pulse |

### Shimmer Keyframe
```css
@keyframes skeleton-shimmer {
  0% { background-position: -200% 0; }
  100% { background-position: 200% 0; }
}
```
배경 그라데이션 (`color/fill/normal` → `color/fill/alternative` → `color/fill/normal`)이 가로로 이동.

---

## 변형 (Variant)

| Variant | 형태 | 용도 |
|---|---|---|
| `text` | 가로 가는 직사각형 | 본문 텍스트 라인 |
| `circle` | 원형 | Avatar 자리 |
| `rectangle` | 사각형 | 썸네일, 카드 |

각 variant는 `width`/`height` prop으로 사이즈 자유 조정. text는 height 기본 1em.

---

## 상태
| 상태 | 시각 표현 | 모션 |
|---|---|---|
| Animated (default) | shimmer 또는 pulse | `motion/keyframe/skeleton-shimmer` 1.5s infinite |
| Static (animation=false) | 단색 plate | — |

---

## 접근성
- `aria-busy="true"`, `aria-live="polite"` (영역 단위로).
- 콘텐츠 로드 후 즉시 unmount → 스크린리더가 새 콘텐츠 자동 인지.
- Reduced motion: shimmer 비활성, 정적 회색 plate로 폴백.

---

## Figma Make 프롬프트
```
Skeleton:
Variants:
- text: 가로 직사각형 (text 라인용), radius 6
- circle: 원형 (avatar용), radius full
- rectangle: 사각형 (thumbnail/card), radius 8 (prop 가능)

색상: fill/normal + opacity prop
애니메이션: shimmer (gradient 좌→우 이동, 1.5s ease-in-out infinite) 또는 opacity pulse
animation=false 시 정적 plate

aria-busy=true on parent 영역

네이밍: Skeleton / Text, Skeleton / Circle, Skeleton / Rectangle
```
