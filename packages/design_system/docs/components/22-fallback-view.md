# 컴포넌트: 폴백 뷰 (Fallback View / Empty State)

## 개요
빈 결과·에러·미가입 등 "비어있는 상태"를 안내하는 컴포넌트. 일러스트/아이콘 + 제목 + 설명 + 액션 버튼 슬롯 합성. `platform`(desktop/mobile), `padding`(normal/compact) 옵션.

---

## 디자인 토큰 매핑

| 토큰 | 값 |
|---|---|
| 컨테이너 정렬 | center (수직·수평) |
| 패딩 (normal) | `spacing/40` 사방 |
| 패딩 (compact) | `spacing/24` 사방 |
| Image 크기 | 120px (desktop), 88px (mobile) |
| Title 폰트 | `text/heading2` × `font/weight/bold` |
| Description 폰트 | `text/body2` × `font/weight/regular` |
| Description 색 | `color/label/alternative` |
| Gap (image ↔ text) | `spacing/16` |
| Gap (text ↔ button) | `spacing/24` |
| Max-width (text) | 400px (가독성 라인 길이) |

---

## 합성 슬롯
- `<FallbackView>`: 외곽 컨테이너 (FlexBox 기반)
- `<FallbackViewImage>`: 일러스트/아이콘 영역
- `<FallbackViewContent>`: 텍스트 그룹
- `<FallbackViewText title description>`: Typography 기반 텍스트
- `<FallbackViewButton>`: 액션 (Button 기반, 1개 권장)

---

## 변형 (Platform × Padding)

| Platform | 일러스트 사이즈 | Description 정렬 |
|---|---|---|
| desktop | 120px | center |
| mobile | 88px | center |

| Padding | 사방 |
|---|---|
| normal | 40px |
| compact | 24px (네스티드 컨테이너 등) |

---

## 상태
| 상태 | 시각 표현 |
|---|---|
| Default | 위 토큰 매핑 |

> 정적 — 인터랙션은 슬롯 내부 버튼만.

---

## 접근성
- 시맨틱: 대부분 `<div>`. Title은 적절한 heading level (`<h2>` 등).
- 일러스트/아이콘에 `alt` 또는 `aria-hidden` (장식 목적이면).
- 액션 버튼은 명확한 텍스트 ("다시 시도", "프로필 작성하기" 등) — 시각만으로 의미 전달 금지.

---

## Figma Make 프롬프트
```
FallbackView (Empty State):
Platforms: desktop (image 120px) / mobile (image 88px)
Paddings: normal (40px) / compact (24px)

레이아웃 (FlexBox column, center 정렬):
- Image (slot): 일러스트 또는 아이콘
- gap 16px
- Title (heading2 bold)
- Description (body2 regular, label/alternative)
- gap 24px
- Button (Solid Primary 권장, 1개)

Description max-width 400px (가독성)

용도:
- 빈 검색 결과
- 에러 페이지
- 데이터 로드 실패
- 미가입/권한 부족

네이밍: FallbackView / Desktop / Normal, FallbackView / Mobile / Compact
```
