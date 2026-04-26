# 컴포넌트: 라벨 (Label)

## 개요
폼 필드 위/옆에 붙는 설명 텍스트. Typography 기반 + `required` prop으로 필수 표시(`*`).

> **Harness Principle:** Label은 polymorphic — Typography props를 모두 받아 size/weight/color 자유 조정. 폼 필드와의 연결(`htmlFor`)은 필수.

---

## 디자인 토큰 매핑

| 토큰 | 기본값 |
|---|---|
| 폰트 | `text/label1` (변경 가능) |
| 색상 | `color/label/normal` (변경 가능) |
| Required 표시 | `*` 문자, `color/status/negative` 또는 `color/primary/normal` |
| Required 위치 | 라벨 텍스트 우측, `spacing/2` 간격 |

---

## 상태
| 상태 | 시각 표현 |
|---|---|
| Default | Typography variant prop에 따름 |
| Required (`required=true`) | 텍스트 + ` *` |
| Disabled (연관 필드 disabled) | `color/label/disable` (수동 적용 권장) |

> Label 자체는 정적. 연관 필드의 상태에 따라 색상을 별도로 조정 (자동 동기 X).

---

## 접근성
- HTML `<label>` 또는 `<label htmlFor={id}>` 사용 — 클릭 시 연관 필드 포커스.
- 인풋과 레이아웃 분리된 케이스: `aria-labelledby={labelId}`로 연결.
- `required`는 시각 `*` + 인풋의 `required` prop 모두 적용 (스크린리더 자동 안내).

---

## Figma Make 프롬프트
```
Label: Typography 기반 (variant 자유)
- Default: label1 + label/normal
- required=true: " *" 추가, status/negative 색
- 폼 필드와 htmlFor 연결, gap 4px (수직 위) 또는 8px (수평 좌)

네이밍: Label / Default, Label / Required
```
