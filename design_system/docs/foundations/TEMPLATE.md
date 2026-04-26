# 파운데이션: [파운데이션명] (Foundation Name)

## 개요
[해당 파운데이션의 목적과 전체 시스템에서 차지하는 역할을 서술합니다. 예를 들어 '타이포그래피 시스템' 등]

---

## 🏗️ 하네스 설계 원칙 (Harness Design Principles)

> **Harness Principle (P3 Invariant & P4 Convention):** 컴포넌트 설계 시 하드코딩된 값을 배제하고 오직 Semantic 토큰만을 참조해야 합니다. 모든 Primitive 값은 여기서 중앙 관리됩니다.

---

## 디자인 토큰 — Primitive (원시 값)

라이트/다크 모드와 무관하게 변하지 않는 시스템의 원재료입니다.

| 토큰 | 값 | 비고 |
|---|---|---|
| `[카테고리]/[단계]` | [값] | [설명] |

---

## 디자인 토큰 — Semantic (의미론적 값)

컴포넌트에서 실질적으로 가져다 쓰는 의미 기반의 토큰입니다.

| 토큰 | 참조(Light) | 참조(Dark) | 사용처 |
|---|---|---|---|
| `[목적]/[이름]` | [Primitive 토큰] | [Primitive 토큰] | [예: CTA 버튼 배경] |

---

## 사용 원칙 (Convention)

1. [규칙 1: 예) 직접적인 Primitive 참조 금지]
2. [규칙 2: 예) 4px 배수 스페이싱 준수]

---

## Figma Make 프롬프트

```
다음 스펙으로 [파운데이션명] 시스템을 Figma Variables(또는 Styles)로 구성해줘:

Collection — [Collection 이름] (Mode: [없음/Light/Dark]):

Primitive:
[Primitive 값 목록]

Semantic (Primitive를 Alias로 연결):
[Semantic 값 목록 및 구조]
```