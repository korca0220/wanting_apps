# 컴포넌트: 모달 (Modal)

## 개요
사용자 집중을 요구하는 오버레이 컨테이너. **3가지 variant** 지원: `popup`(중앙), `bottom`(바텀 시트), `full`(풀스크린). bottom variant는 `handle`로 드래그 토글 가능, peekHeight로 부분 노출 상태도 제공. 4가지 size(`small`/`medium`/`large`/`xlarge`).

> **Harness Principle (P6 Layered):** 모달은 UI 레이어. 비즈니스 처리(예: form submit)는 모달 자식에서 일반 컴포넌트(Button 등)를 통해 상위 핸들러로 전달.

---

## 🎨 디자인 기준

### 1. 독창성 및 톤앤매너
- 3 variant로 데스크톱·모바일·풀스크린 시나리오 일관 처리. Variant 전환은 ResponsiveProps로 폼팩터별 자동.
- Bottom sheet의 `handle` 드래그는 모바일 친화 — peekHeight로 *부분 노출* 상태도 1급 시민.

### 2. 크래프트
- Radix UI 기반 시맨틱 + Focus Scope, RemoveScroll, AriaHiddenOthers를 모두 1급 옵션으로 노출.
- Sticky 모드: 내부 스크롤 시 ActionArea(하단 버튼)에 그라데이션, ModalNavigation에 배경 페이드 — 위계 손상 없이 컨텐츠 영역 확장.

### 3. 기능성
- `disablePortal`: SSR 호환성 옵션 (h2/div 같은 상위 스타일 충돌 방지).
- `forceMount`: 닫혀도 DOM에 유지 (애니메이션, 상태 보존용).

---

## 디자인 토큰 매핑

| 토큰 | 값 (Semantic) |
|---|---|
| 배경 | `color/background/elevated/normal` |
| 백드롭 | `color/material/dimmer` (라이트 `coolNeutral/10 @ 52%`, 다크 `@ 74%`) |
| 그림자 | `shadow/normal/large` |
| 보더 반경 (popup) | `radius/xl` (16px) |
| 보더 반경 (bottom 상단만) | `radius/2xl` (20px), `border-bottom-*-radius: 0` |
| 보더 반경 (full) | 0 |
| Z-Index | `zIndex/modal` (1300) |
| 패딩 (Heading/Summary) | `spacing/20` × `spacing/24` |
| 패딩 (Content) | `spacing/20` × `spacing/24` |
| Gap (Content) | `spacing/16` (커스터마이즈 가능 prop) |
| Heading 폰트 | `text/title3` × `font/weight/bold` |
| Description 폰트 | `text/body2` × `font/weight/regular` |

---

## 변형 (Variant × Size)

### Popup (중앙)
- 데스크톱 기본. 화면 중앙 정렬, 백드롭 위 떠있는 형태.
- Size별 max-width: small=400 / medium=560 / large=720 / xlarge=960 (px).

### Bottom (바텀 시트)
- 모바일 기본. 화면 하단에서 슬라이드 업.
- 상단 모서리 radius/2xl, 하단 모서리 0.
- `handle=true`: 상단에 grab 핸들 (drag로 dismiss 또는 peek 전환).

### Full (풀스크린)
- 모바일/태블릿에서 페이지 전체 차지. 보더 반경 0, 시스템 안전 영역 고려.

---

## 상태 (State) 및 인터랙션

> ⚠️ 컨테이너 컴포넌트는 명시적 상태 표 필수.

| 상태 | 시각 표현 / 변경 토큰 | 모션 토큰 |
|---|---|---|
| Closed | unmount (forceMount=false) 또는 visibility hidden | — |
| Open (popup) | 중앙 표시 + 백드롭 fade-in | `motion/keyframe/scale-in` 200ms ease-out |
| Open (bottom) | 하단에서 슬라이드 업 + 백드롭 fade-in | `motion/keyframe/slide-up` 300ms ease-out |
| Open (full) | 전체 차지 + 백드롭 즉시 표시 | `motion/keyframe/fade-in` 200ms |
| Peek (bottom + handle) | peekHeight 만큼 부분 노출, 드래그로 full 또는 dismiss | `motion/transition/transform` (drag follow) |
| Closing | 변형별 역애니메이션 | `motion/keyframe/scale-out` 200ms (popup) |
| Focus Trap | 모달 내부 포커스 가능 요소 사이만 순환 | — |
| Backdrop | `color/material/dimmer` | `motion/keyframe/fade-in` 200ms |
| Sticky Scroll | 내부 스크롤 시 ActionArea/Navigation 배경 추가 | `motion/transition/colors` |

---

## 합성 슬롯

| 컴포넌트 | 역할 |
|---|---|
| `<Modal>` | Open state 컨테이너 (Radix Dialog 기반) |
| `<ModalTrigger>` | 트리거 wrapping (Slot) |
| `<ModalContainer variant size>` | 시각 컨테이너 |
| `<ModalDimmer>` | 백드롭 (커스터마이즈 가능 — framer-motion 등) |
| `<ModalNavigation>` | 상단 네비게이션 (제목 + 닫기) |
| `<ModalClose>` | 닫기 버튼 |
| `<ModalContent gap>` | 본문 영역 |
| `<ModalHeading>`, `<ModalSummary>`, `<ModalDescription>` | 텍스트 슬롯 (Typography 기반) |
| `<ModalContentItem>` | 본문 내 그룹화 |

---

## 접근성 (Accessibility)
- `role="dialog"`, `aria-modal="true"`, ModalHeading과 `aria-labelledby` 자동 연결.
- **Focus Trap**: Open 시 첫 포커스 가능 요소로 이동, 모달 내부에서만 Tab/Shift+Tab 순환.
- **Esc 닫기**: 기본 활성, `disableEscapeKeyDownClose`로 비활성 가능.
- **Outside Click 닫기**: 기본 활성, `disableOutsideClickClose`로 비활성 가능.
- **배경 스크롤 락**: 기본 활성 (`disableRemoveScroll=false`).
- **Aria Hidden Others**: 모달 외 요소를 `aria-hidden=true` 처리 (스크린리더 격리).
- **이전 포커스 복원**: Close 시 트리거 요소로 자동 복귀.

---

## Figma Make 프롬프트

```
Wanted Montage Modal 컴포넌트:

Variants: popup(중앙) / bottom(바텀 시트) / full(풀스크린)
Sizes: small(400) / medium(560) / large(720) / xlarge(960)

공통 외형:
- bg: background/elevated/normal
- shadow: shadow/normal/large
- 백드롭: material/dimmer (rgba 검정 52%/74%)
- z-index: 1300

Popup:
- 중앙 정렬, max-width 사이즈별
- radius: 16px (xl)
- scale-in 200ms ease-out

Bottom Sheet:
- 하단 fixed, full width
- 상단 모서리 20px, 하단 0
- slide-up 300ms ease-out
- handle=true: 상단 grab bar, drag로 peek/dismiss

Full:
- 전체 차지, radius 0
- fade-in 200ms

Slots:
- ModalNavigation (top): 제목 + 닫기 버튼
- ModalContent: gap 자유, padding 20×24
- ModalActionArea (bottom, optional): 버튼 그룹
- sticky=true: 스크롤 시 navigation/actionarea 배경 fade-in

접근성:
- role=dialog, aria-modal, focus trap, esc 닫기, body scroll lock

네이밍: Modal / Popup / Medium, Modal / Bottom / Handle, Modal / Full
```
