# 파운데이션: 간격 (Spacing)

## 개요
Wanted Montage의 간격 시스템은 **2px 기반의 dense 스케일**입니다. 일반적인 4px/8px 그리드보다 더 촘촘한 단계(0.5/1/2/4/6/8/10/12/14/16/20/24...)를 제공해 컴팩트한 인터페이스에서 정밀한 위계를 표현할 수 있게 했습니다.

---

## 🏗️ 하네스 설계 원칙

> **Harness Principle:** 컴포넌트의 padding/margin/gap은 반드시 본 토큰의 단계 값을 참조해야 합니다. 매그닉 넘버(예: `padding: 13px`) 금지.

---

## 디자인 토큰 — Primitive

토큰명은 단계 = px 값을 직접 사용 (`spacing[16]` = 16px).

| 토큰 | 값 | 단계 |
|---|---|---|
| `spacing/0` | 0px | None |
| `spacing/0.5` | 0.5px | Hairline |
| `spacing/1` | 1px | Border-tier |
| `spacing/2` | 2px | Micro |
| `spacing/4` | 4px | XXS |
| `spacing/6` | 6px | XS |
| `spacing/8` | 8px | SM |
| `spacing/10` | 10px | SM+ |
| `spacing/12` | 12px | MD |
| `spacing/14` | 14px | MD+ |
| `spacing/16` | 16px | LG (기본 컴포넌트 내부) |
| `spacing/20` | 20px | LG+ |
| `spacing/24` | 24px | XL (컴포넌트 사이) |
| `spacing/32` | 32px | 2XL |
| `spacing/40` | 40px | 3XL |
| `spacing/48` | 48px | 섹션 SM |
| `spacing/56` | 56px | 섹션 MD |
| `spacing/64` | 64px | 섹션 LG |
| `spacing/72` | 72px | 섹션 XL |
| `spacing/80` | 80px | 섹션 2XL |

---

## Semantic 권장 매핑

| Semantic | Primitive | 일반 사용처 |
|---|---|---|
| `spacing/component-xs` | `spacing/4` | 아이콘-텍스트 인접 |
| `spacing/component-sm` | `spacing/8` | 버튼 내부 가로 패딩 |
| `spacing/component-md` | `spacing/12` | 입력 필드 내부 |
| `spacing/component-lg` | `spacing/16` | 카드 내부 패딩 |
| `spacing/component-xl` | `spacing/24` | 큰 카드/섹션 내부 |
| `spacing/layout-sm` | `spacing/32` | 컴포넌트 사이 |
| `spacing/layout-md` | `spacing/48` | 작은 섹션 사이 |
| `spacing/layout-lg` | `spacing/64` | 큰 섹션 사이 |
| `spacing/layout-xl` | `spacing/80` | 페이지 헤더 여백 |

> Semantic은 시스템 단위에서 합의되면 컴포넌트 작성 시 일괄 적용합니다.

---

## 사용 원칙

1. **0.5px / 1px / 2px**는 보더, 디바이더, 미세 정렬용으로만 사용. 컴포넌트 padding으로 사용 금지.
2. **수직 ≠ 수평**: 같은 컴포넌트라도 수직 padding과 수평 padding이 다를 수 있습니다 (예: 버튼 `10px 16px`).
3. **gap 우선**: flex/grid에서 자식 사이 간격은 `margin`보다 `gap` 사용을 우선.
4. **반응형 점프**: 데스크탑에서 `spacing/24`, 모바일에서 `spacing/16`처럼 단계를 한 칸 줄이는 패턴이 자연스럽습니다.

---

## Figma Make 프롬프트

```
다음 스펙으로 Wanted Montage 간격 시스템을 Figma Variables (Number Collection)로 구성해줘:

Collection — Spacing:
0, 0.5, 1, 2, 4, 6, 8, 10, 12, 14, 16, 20, 24, 32, 40, 48, 56, 64, 72, 80

Variable 이름은 단계 그대로 사용 (예: spacing/16).
모든 컴포넌트의 padding/gap은 이 토큰을 alias로 참조하도록 강제.
```
