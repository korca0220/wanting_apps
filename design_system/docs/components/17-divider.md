# 컴포넌트: 디바이더 (Divider)

## 개요
콘텐츠 구분선. 가로/세로 양쪽 지원, 색상·길이·두께 모두 prop으로 조정.

---

## 디자인 토큰 매핑

| 토큰 | 기본값 |
|---|---|
| 색상 | `color/line/normal/neutral` (변경 가능 — `color` prop) |
| 두께 | `1px` (변경 가능 — `thickness` prop) |
| 길이 | `100%` (변경 가능 — `size` prop) |
| 방향 | horizontal (변경 가능 — `vertical` prop) |

---

## 변형 (Variant)

| Variant | 사용처 |
|---|---|
| Horizontal (default) | 섹션 사이, 리스트 아이템 사이 |
| Vertical | 인라인 요소 사이 (예: 버튼 그룹의 구분) |

색상 변형 (color prop):
- `color/line/normal/normal` — 일반 (기본보다 진함)
- `color/line/normal/neutral` — 약간 진함
- `color/line/normal/alternative` — 가장 약함
- `color/line/solid/*` — 알파 없는 솔리드 보더

---

## 상태
| 상태 | 시각 표현 |
|---|---|
| Default | 위 토큰 |

> 정적 — 인터랙션 없음.

---

## 접근성
- 시맨틱: `<hr>` (가로) 또는 `role="separator"` `aria-orientation` 명시.
- 시각만의 구분이라 스크린리더에 영향 없게 `aria-hidden="true"` 옵션.

---

## Figma Make 프롬프트
```
Divider:
- Horizontal (기본): 100% width × 1px height, color line/normal/neutral
- Vertical: 1px width × parent height
- color, thickness, size 모두 변경 가능

네이밍: Divider / Horizontal, Divider / Vertical
```
