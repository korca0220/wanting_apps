# 컴포넌트: 카드 (Card)

## 개요
관련 정보를 시각적으로 묶는 컨테이너. Wanted Montage의 Card는 **합성 가능(composable)** 구조 — 단일 박스가 아니라 `Card`, `CardThumbnail`, `CardTitle`, `CardCaption`, `CardContent`, `CardContentItem` 등 슬롯 컴포넌트들을 조합해 다양한 레이아웃 생성.

> **Harness Principle:** Card 자체는 시각 컨테이너만 제공. 클릭 액션이 필요하면 외곽을 `<button>` 또는 `<a>`로 감싸서 처리 — Card 컴포넌트는 시맨틱을 강제하지 않음 (의도된 유연성).

---

## 🎨 디자인 기준

### 1. 독창성 및 톤앤매너
- `platform` prop으로 desktop/mobile 가변 — 같은 데이터를 폼팩터에 맞게 다른 비율로 표시.
- Thumbnail 위 leading/trailing overlay 슬롯으로 배지·플레이 버튼 등을 자연스럽게 배치.

### 2. 크래프트
- Skeleton 변형(`CardThumbnailSkeleton`, `CardTitleSkeleton`, `CardCaptionSkeleton`)이 기본 제공 — 로딩 시 layout shift 0.
- Title/Caption은 `Typography` variant prop을 그대로 받음 → 컨텍스트별 위계 자유.

### 3. 기능성
- ResponsiveProps로 viewport별 다른 width/platform 지정 가능.
- ContentItem `position: 'top' | 'bottom'`으로 우선 배치 결정 — 작은 카드에서 메타 정보 위/아래 자유.

---

## 디자인 토큰 매핑

| 토큰 | 값 (Semantic) |
|---|---|
| 배경 | `color/background/elevated/normal` |
| 보더 | 없음 (또는 `1px color/line/normal/alternative` 선택적) |
| 그림자 | `shadow/normal/small` (Hover 시 `medium`) |
| 보더 반경 | `radius/lg` (12px) |
| 패딩 | 카드 내부 `spacing/16` (FlexBox로 자유 조정) |
| Gap (자식들) | `spacing/8` ~ `spacing/12` |
| Title 폰트 | 보통 `text/headline2` 또는 `text/heading2` |
| Caption 폰트 | `text/body2` 또는 `text/label2` |
| 트랜지션 | `motion/transition/transform` (Hover lift) |

---

## 상태 (State) 및 인터랙션

| 상태 | 시각 표현 / 변경 토큰 | 모션 토큰 |
|---|---|---|
| Default | 위 토큰 매핑 | — |
| Hover (clickable card) | `transform: translateY(-2px)`, 그림자 `shadow/normal/medium` | `motion/transition/transform` (200ms ease) |
| Focus (clickable card) | `shadow/focus` (필수) | — |
| Loading | Skeleton 컴포넌트 자식으로 대체 | `motion/keyframe/skeleton-shimmer` (별도 정의) |

> Card 자체는 비-인터랙티브가 기본. Hover/Focus 상태는 Card를 `<button>`/`<a>`로 wrapping한 경우만 적용.

---

## 합성 슬롯 (Slots)

| 컴포넌트 | 역할 |
|---|---|
| `<Card>` | 외곽 컨테이너 |
| `<CardThumbnail>` | 썸네일 영역 (leading/trailing overlay 가능) |
| `<CardThumbnailContent variant>` | text / toggle-icon / custom |
| `<CardTitle>` | Typography 기반 제목 |
| `<CardCaption>` | Typography 기반 보조 텍스트 |
| `<CardContent>` | 내부 컨텐츠 컨테이너 (FlexBox) |
| `<CardContentItem variant>` | badge / custom, position: top/bottom |
| `<CardThumbnailSkeleton>` 등 | 로딩 시 자리표시자 |

---

## 접근성 (Accessibility)
- 카드 자체는 시맨틱 없음 (`<div>`). 클릭 가능 시 외곽을 `<button>` 또는 `<a>`로 감싸 시맨틱 부여.
- Thumbnail의 alt 텍스트 필수 (`<img alt>`).
- Title은 적절한 heading level(`<h2>`, `<h3>` 등) 또는 Typography component prop.

---

## Figma Make 프롬프트

```
Wanted Montage Card 컴포넌트 (composable):

기본 외형:
- bg: background/elevated/normal
- border-radius: 12px (radius/lg)
- shadow: shadow/normal/small
- padding: 16px (자유 조정 가능한 FlexBox)

Slots:
- Thumbnail (top): 비율 자유, overlay 배지/버튼 슬롯
- Title: Typography (보통 headline2 또는 heading2)
- Caption: Typography (body2 또는 label2)
- ContentItem: badge 또는 custom, position top/bottom

Hover (clickable):
- translateY(-2px) + shadow/normal/medium, transition 200ms

Skeleton 변형:
- CardThumbnailSkeleton, CardTitleSkeleton, CardCaptionSkeleton (shimmer)

Platform variants: desktop / mobile (비율 다르게)

네이밍: Card / Default, Card / Skeleton, Card / Mobile
```
