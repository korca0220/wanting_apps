# 컴포넌트: 이미지 업로더 (Image Uploader)

## 개요
사용자가 이미지를 선택·미리보기·교체할 수 있는 합성 컴포넌트. **빈 상태(empty)**와 **이미지 있는 상태(preview)** 두 모드를 한 컴포넌트가 처리하며, 시스템 이미지 픽커와 연동됩니다. New Piece 작성, Edit Piece, 프로필 사진 변경 등 광범위 적용.

> **Harness Principle (P6 Layered):** 시스템 이미지 픽커 호출과 파일 업로드 자체는 외부 콜백으로 처리. 본 컴포넌트는 *시각 + state 표시*만.

---

## 🎨 디자인 기준

### 1. 독창성 및 톤앤매너
- 빈 상태의 dashed border + 안내 텍스트가 "탭해서 선택하기" 신호를 자연스럽게 전달.
- preview 상태에서 우상단 작은 IconButton(연필/X)으로 교체/제거 액션 명확.

### 2. 크래프트
- 양쪽 모드의 외곽 사이즈(aspect ratio)가 동일해 mode 전환 시 layout shift 0.
- 업로드 중 progress overlay가 이미지 위에 자연스럽게 fade.

### 3. 기능성
- aspect prop으로 1:1 / 4:3 / 16:9 / free 자유 지정 — 도메인별 가이드.
- multi mode 지원 (선택 옵션) — 갤러리 픽커.

---

## 디자인 토큰 매핑

### Container (공통)
| 토큰 | 값 |
|---|---|
| 보더 반경 | `radius/lg` (12px, prop으로 변경 가능) |
| 트랜지션 | `motion/transition/colors` |
| Min-height | `120px` (small) / 자유 (aspect 따름) |

### Empty 모드 (사진 미선택)
| 토큰 | 값 |
|---|---|
| 배경 | `color/fill/alternative` |
| 보더 | `2px dashed color/line/normal/neutral` |
| 아이콘 | 카메라/플러스 아이콘, `color/label/alternative`, 32~48px |
| Hint 폰트 | `text/body1` × `font/weight/medium`, `color/label/normal` |
| Subhint 폰트 | `text/body2`, `color/label/alternative` |
| 정렬 | center (수직·수평) |
| Gap (icon ↔ text) | `spacing/8` |

### Preview 모드 (사진 선택됨)
| 토큰 | 값 |
|---|---|
| 배경 | `color/coolNeutral/95` (이미지 로딩 중 placeholder) |
| 이미지 fit | `cover` (기본) 또는 `contain` |
| 우상단 액션 IconButton | `variant=background, size=small`, 16px offset |
| Replace 버튼 (외부) | 컴포넌트 외부 슬롯에서 추가 가능 |

---

## Props 스키마

| Prop | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `value` | `string \| File \| null` | `null` | 현재 이미지 (URL 또는 파일) |
| `aspect` | `'1:1' \| '4:3' \| '16:9' \| 'free'` | `'1:1'` | 종횡비 |
| `size` | `'small' \| 'medium' \| 'large'` | `'medium'` | 외형 크기 |
| `disabled` | `boolean` | `false` | 비활성 |
| `loading` | `boolean` | `false` | 업로드 진행 중 |
| `multi` | `boolean` | `false` | 다중 선택 모드 |
| `accept` | `string` | `'image/*'` | 파일 타입 필터 |
| `maxSize` | `number` (bytes) | — | 파일 크기 제한 |
| `hint` | `string` | `'Tap to select a photo'` | empty 모드 메인 텍스트 |
| `subhint` | `string` | (없음) | empty 모드 보조 텍스트 |
| `onChange` | `(file) => void` | — | 선택 시 콜백 |
| `onRemove` | `() => void` | — | 제거 시 콜백 (있으면 우상단 X 노출) |

---

## 변형 (Variant)

| Variant | 사용처 |
|---|---|
| `default` | 카드형 영역 (정사각/4:3) |
| `inline` | 폼 안 작은 인라인 (avatar 같은) |
| `cover` | 풀폭 hero 이미지 (border 없음, radius 0~lg 자유) |

---

## 상태 (State) 및 인터랙션

> ⚠️ 모드 전환이 핵심이라 명시적 상태 표 필수.

| 상태 | 시각 표현 / 변경 토큰 | 모션 토큰 |
|---|---|---|
| Empty (default) | dashed border + icon + hint | — |
| Empty Hover | 보더 `color/line/normal/normal`, 배경 `color/fill/normal` | `motion/transition/colors` |
| Empty Focus | `shadow/focus` + dashed primary 색 | — |
| Empty Pressed | 배경 `color/fill/strong` | `motion/transition/colors` |
| Preview | 이미지 표시 + 우상단 액션 | `motion/keyframe/fade-in` (mode 전환 시) |
| Preview Hover | 우상단 액션 부각 (그림자 강화 등) | `motion/transition/colors` |
| Loading | 이미지 또는 placeholder 위 progress overlay | `motion/transition/opacity` |
| Error | 보더 `color/status/negative @ 28%`, 인라인 에러 메시지 | `motion/transition/colors` |
| Disabled | opacity 0.4, pointer-events: none | — |

---

## 합성 슬롯

| 컴포넌트 | 역할 |
|---|---|
| `<ImageUploader>` | 외곽 컨테이너 + state 관리 |
| `<ImageUploaderEmpty>` (내부) | empty 모드 렌더 — icon/hint/subhint 슬롯 |
| `<ImageUploaderPreview>` (내부) | preview 모드 렌더 — 이미지 + actions |
| `<ImageUploaderAction>` | 우상단 액션 IconButton (X/edit) |

---

## 접근성
- empty 모드: `<button>` 또는 `role="button"` + `aria-label="이미지 선택"`. 키보드 Enter/Space로 활성화.
- preview 모드: 이미지에 `alt` (사용자 제공 또는 `"선택된 이미지"`).
- 우상단 액션: `aria-label="이미지 제거"` 또는 `"이미지 변경"`.
- 키보드 Tab: empty 트리거 → preview 모드 전환 시 우상단 액션으로 포커스 자동 이동 권장.
- 파일 선택 다이얼로그는 OS native — 추가 처리 불필요.
- 에러 발생 시 `aria-live="polite"`로 메시지 안내.

---

## Figma Make 프롬프트

```
ImageUploader 합성 컴포넌트:

두 모드 (한 컴포넌트가 처리):
- Empty: 사진 미선택
- Preview: 사진 선택됨

Empty 외형:
- bg: fill/alternative
- border: 2px dashed line/normal/neutral
- radius: 12 (radius/lg)
- 중앙 정렬: 카메라/플러스 아이콘 (32~48px, label/alternative) + hint(body1 medium) + subhint(body2 alternative)
- gap 8

Preview 외형:
- 이미지 cover, radius 12
- placeholder bg coolNeutral/95 (로딩 중)
- 우상단 IconButton (variant=background, size=small) — 16px offset
  - X 아이콘 (제거) 또는 edit 아이콘 (교체)

Aspects: 1:1 (default) / 4:3 / 16:9 / free
Sizes: small (120px+) / medium / large

Variants: default (카드형) / inline (폼 안) / cover (풀폭 hero)

States:
- empty default / hover (line stronger + fill/normal bg) / focus (ring) / pressed (fill/strong bg)
- preview default / hover (action 부각)
- loading: progress overlay fade-in over image
- error: status/negative 28% 보더 + 인라인 메시지
- disabled: opacity 0.4

Mode 전환: 200ms fade-in/out

aria-label="이미지 선택" (empty) / "이미지 제거"|"이미지 변경" (preview action)

네이밍: ImageUploader / Empty / Default, ImageUploader / Preview / Hover, ImageUploader / Loading
```
