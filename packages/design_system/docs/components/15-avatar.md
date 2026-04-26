# 컴포넌트: 아바타 (Avatar)

## 개요
사용자/엔티티 시각 표현. 5가지 size(`xsmall`/`small`/`medium`/`large`/`xlarge` + number), 3가지 variant(`person`/`company`/`academy`)로 도메인(채용·이력)별 의미 구분. 이미지 없을 때 자동 폴백.

> Wanted Montage의 도메인 특화: `person` 외에 `company`(회사 로고)/`academy`(교육기관)의 별도 variant — 일반 디자인 시스템보다 풍부한 분류.

---

## 디자인 토큰 매핑

| 사이즈 | 픽셀 | 권장 사용처 |
|---|---|---|
| xsmall | 20px | 인라인 아바타 (댓글 좌측) |
| small | 28px | 리스트 아이템 좌측 |
| medium | 40px | 카드 헤더 |
| large | 64px | 프로필 카드 |
| xlarge | 96px | 프로필 헤더 |
| number | custom | 수동 지정 |

| 토큰 | 값 |
|---|---|
| 보더 반경 (person) | `radius/full` (원형) |
| 보더 반경 (company/academy) | `radius/md` (8px) |
| 폴백 배경 (person) | `color/fill/normal` |
| 폴백 배경 (company) | `color/coolNeutral/95` |
| 폴백 아이콘 색 | `color/label/alternative` |

---

## 변형 (Variant)

| Variant | 보더 반경 | 폴백 아이콘 |
|---|---|---|
| `person` | full (원형) | 사람 실루엣 |
| `company` | md (8px 사각형) | 빌딩 아이콘 |
| `academy` | md (8px 사각형) | 학교 아이콘 |

---

## 상태
| 상태 | 시각 표현 |
|---|---|
| Default (with image) | `<img>` 표시 |
| Loading | Skeleton variant=circle 또는 rectangle |
| Failed (image error) | variant별 폴백 아이콘 |

> Avatar 자체는 비-인터랙티브. 클릭 가능 시 `AvatarButton` 별도 컴포넌트 사용.

---

## 접근성
- `<img>`의 `alt` 필수 (사람 이름 또는 엔티티명).
- 폴백 아이콘일 때도 `aria-label` 또는 visually hidden 텍스트로 의미 전달.
- 그룹: `AvatarGroup`은 overlap된 아바타들을 묶어 표시 — 첫 N개 + "+M" 카운터.

---

## Figma Make 프롬프트
```
Avatar:
Sizes: xsmall(20), small(28), medium(40), large(64), xlarge(96)
Variants:
- person: 원형 (radius/full)
- company: 사각 (radius/md 8px), bg coolNeutral/95
- academy: 사각 (radius/md 8px)

Fallback (이미지 없음): variant별 아이콘 + label/alternative 색
이미지 cover, 사이즈에 맞게 crop

네이밍: Avatar / Person / Medium, Avatar / Company / Large, Avatar / Group
```
