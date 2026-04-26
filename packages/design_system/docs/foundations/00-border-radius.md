# 파운데이션: 보더 반경 (Border Radius)

## 개요
**원본 wds-theme에는 명시적 radius 토큰이 없습니다.** 컴포넌트별로 inline 값(6/8/12/14/16/20px)을 사용 중인데, 본 문서는 [heuristics_html_css.md](../../../skills/design-system-gen/references/heuristics_html_css.md)의 군집화 규칙(차이 ≤ 2px 동일 단계)으로 표준 5단계로 환원한 결과입니다.

---

## 🏗️ 하네스 설계 원칙

> **Harness Principle:** 컴포넌트는 본 토큰의 **Semantic 단계**를 참조해야 합니다. inline 픽셀 값은 마이그레이션 대상이며, 신규 컴포넌트 작성 시 새로 추가하지 마세요.
>
> **추정 토큰 표시**: 본 파운데이션은 wds-theme 원본이 아닌 **Inferred (휴리스틱 추정)** 토큰입니다. 디자이너 검수 권장.

---

## 디자인 토큰 — Primitive

| 토큰 | 값 | 비고 |
|---|---|---|
| `radius/none` | `0px` | 보더 반경 없음 |
| `radius/sm` | `6px` | 작은 배지/툴팁 |
| `radius/md` | `8px` | 기본 (버튼, 페이지네이션, 컨텐츠 배지) |
| `radius/lg` | `12px` | 카드, 썸네일 |
| `radius/xl` | `16px` | 모달 내부 모듈 |
| `radius/2xl` | `20px` | 큰 모달, 시트 |
| `radius/full` | `9999px` | Pill, Avatar |

> 14px 같은 중간값은 `framed-style.ts`에서 컨텍스트별 미세 조정용으로 사용. 표준 단계는 6/8/12/16/20px의 5단계 + full로 처리.

---

## Semantic 권장 매핑

| Semantic | Primitive | 사용처 |
|---|---|---|
| `radius/badge` | `radius/md` (8px) | 배지, 칩, 컨텐츠 배지 |
| `radius/button` | `radius/md` (8px) | 버튼, 텍스트 버튼 |
| `radius/input` | `radius/md` (8px) | 입력 필드, 셀렉트 |
| `radius/tooltip` | `radius/sm` (6px) | 툴팁 작은 변형 |
| `radius/card` | `radius/lg` (12px) | 카드, 카드 리스트 항목 |
| `radius/thumbnail` | `radius/lg` (12px) | 썸네일 |
| `radius/modal` | `radius/xl` (16px) ~ `radius/2xl` (20px) | 모달/드로어 |
| `radius/avatar` | `radius/full` | 아바타 (원형) |
| `radius/pill` | `radius/full` | 토글, 스위치 |

---

## 사용 원칙

1. **inline 값 금지**: `border-radius: 8px` 직접 작성 → `radius/button` 또는 `radius/md` 참조로 마이그레이션.
2. **중첩 컨테이너 규칙**: 부모가 `radius/lg`(12px)이면 자식은 같거나 작은 단계. 자식이 부모보다 크면 시각적 어색.
3. **모서리 일부만 둥글리기 (예: 시트 상단)**: `radius/2xl 20px` 적용은 `border-top-left-radius`/`border-top-right-radius`만 사용.
4. **추정 토큰의 한계**: 본 토큰은 wds-theme 원본이 아닌 휴리스틱 추정이므로, 디자이너가 명시적 매핑을 결정하면 우선합니다.

---

## Figma Make 프롬프트

```
다음 스펙으로 Wanted Montage Border Radius를 Figma Variables (Number)로 구성해줘:

Collection — Radius:
none(0), sm(6), md(8), lg(12), xl(16), 2xl(20), full(9999)

Semantic alias:
- button, input, badge, tooltip → md
- card, thumbnail → lg
- modal → xl 또는 2xl
- avatar, pill → full

이미 wds 컴포넌트 코드의 inline 값을 이 토큰으로 마이그레이션하는 작업이 후속으로 필요.
```
