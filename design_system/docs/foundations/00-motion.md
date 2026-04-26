# 파운데이션: 모션 (Motion)

## 개요
**원본 wds-theme에는 명시적 motion 토큰이 없습니다.** 컴포넌트별로 inline transition/animation을 사용 중이며, 본 문서는 [heuristics_html_css.md](../../../skills/design-system-gen/references/heuristics_html_css.md)의 모션 환원 규칙으로 4단계 + 키프레임 표준으로 정리한 결과입니다.

---

## 🏗️ 하네스 설계 원칙

> **Harness Principle:** 모든 transition/animation은 본 토큰의 duration·easing 조합을 참조해야 합니다. 직접 시간 값(`200ms`)이나 곡선(`ease-in-out`)을 컴포넌트에 인라인하지 마세요.
>
> **추정 토큰 표시**: Inferred from inline 패턴. 디자이너 검수 권장.

---

## Duration 토큰

| 토큰 | 값 | 사용처 |
|---|---|---|
| `motion/duration/instant` | `0ms` | 변화 없음 (감속 비활성 환경) |
| `motion/duration/fast` | `150ms` | 호버, 미세 변화 (opacity 등) |
| `motion/duration/base` | `200ms` | 기본 — 그림자/투명도/색상 트랜지션 |
| `motion/duration/slow` | `300ms` | 패널 등장, 모달 fade-in |
| `motion/duration/page` | `400ms` | 라우트 전환, 풀스크린 시트 |

---

## Easing 토큰

| 토큰 | 값 | 의미 |
|---|---|---|
| `motion/easing/standard` | `ease` (CSS 기본) | 일반 transition |
| `motion/easing/decelerate` | `ease-out` | 등장 (in) |
| `motion/easing/accelerate` | `ease-in` | 퇴장 (out) |
| `motion/easing/in-out` | `ease-in-out` | 양방향 (toggle) |
| `motion/easing/spring` | `cubic-bezier(0.5, 0, 0.5, 1)` | 로딩 스피너용 |
| `motion/easing/sharp` | `cubic-bezier(0.8, 0, 0.2, 1)` | 강한 가속/감속 (loading bounce) |

---

## 표준 Transition 조합

자주 쓰는 조합을 토큰화:

| 토큰 | 조합 | 사용처 |
|---|---|---|
| `motion/transition/opacity` | `opacity 150ms ease` | Hover fade |
| `motion/transition/shadow` | `box-shadow 200ms ease` | Hover lift |
| `motion/transition/transform` | `transform 200ms ease` | 미세한 scale/translate |
| `motion/transition/colors` | `background-color 200ms ease, color 200ms ease, border-color 200ms ease` | 상태 변화 색상 동기 |
| `motion/transition/animation-mount` | `200ms ease-in-out` | 컴포넌트 mount/unmount (Tooltip 등) |

---

## 표준 Keyframe (이름)

`AnimationPresence` 컴포넌트에서 사용되는 표준 등장/퇴장 키프레임. 컴포넌트는 키프레임 *이름*만 참조합니다.

| 토큰 | 동작 |
|---|---|
| `motion/keyframe/fade-in` | opacity 0 → 1 |
| `motion/keyframe/fade-out` | opacity 1 → 0 |
| `motion/keyframe/slide-up` | translateY(8px) → 0 + fade-in |
| `motion/keyframe/slide-down` | translateY(-8px) → 0 + fade-in |
| `motion/keyframe/scale-in` | scale(0.95) → 1 + fade-in |
| `motion/keyframe/scale-out` | scale(1) → 0.95 + fade-out |

---

## 사용 원칙

1. **모든 인터랙티브 컴포넌트는 transition 필수**: Hover/Focus/Active 변화에 적어도 `motion/transition/colors`.
2. **Reduced Motion 대응**: OS의 `prefers-reduced-motion: reduce` 시 모든 duration을 `instant`로 폴백. CSS `@media` 쿼리로 일괄 처리.
3. **모션 거부 영역**: 콘텐츠 위치 변동(layout shift)은 모션으로도 정당화되지 않습니다. transform/opacity만 사용.
4. **추정 토큰의 한계**: 본 토큰은 wds-theme 원본이 아닌 휴리스틱 추정이므로, 디자이너가 명시적 매핑을 결정하면 우선.

---

## Figma Make 프롬프트

```
Wanted Montage Motion 시스템을 Figma 프로토타입 옵션으로 매핑해줘:

Duration: instant(0), fast(150), base(200), slow(300), page(400)
Easing: standard(ease), decelerate(ease-out), accelerate(ease-in), in-out, spring, sharp

표준 키프레임 (각 200ms ease-out 권장):
- fade-in / fade-out
- slide-up / slide-down (translateY ±8px)
- scale-in / scale-out (scale 0.95 ↔ 1)

OS reduced-motion 환경에서는 모든 motion을 instant로 폴백.
```
