# 컴포넌트: [컴포넌트명] (Component Name)

## 개요
[컴포넌트의 목적과 주요 역할을 서술합니다. 다른 컴포넌트와의 관계성이나 제약 조건을 명시하세요.]
> **Harness Principle (P6 Layered):** 이 컴포넌트는 UI 레이어에 속하며, 비즈니스 로직(Service/Repo)을 직접적으로 포함하거나 우회해서는 안 됩니다.

---

## 🎨 디자인 기준 (Frontend Quality Criteria)

Harness Engineering 프론트엔드 4대 기준에 따라 다음 항목을 준수하여 설계합니다.

### 1. 독창성 및 톤앤매너 (Design Quality & Originality)
- [브랜드 정체성, "AI Slop" 패턴을 탈피한 독창적 선택, 고유한 시각적 무드 등 서술]

### 2. 크래프트 (Craft)
- [타이포그래피 위계, 간격 일관성, 색상 조화, 명암비 등 기술적 실행 완성도]

### 3. 기능성 및 사용성 (Functionality)
- [기능적 목적성 명확성, 주요 액션 발견 용이성, 상태 변화에 따른 피드백]

---

## 디자인 토큰 매핑

| 토큰 | 값 (Semantic) |
|---|---|
| 폰트 | `text/label-md` |
| 배경 | `color/surface/1` |
| 보더 | `color/border/default` |
| 반경 | `radius/button` |

---

## 상태 (State) 및 인터랙션

| 상태 | 시각 표현 / 변경 토큰 | 모션 토큰 |
|---|---|---|
| Default | 기본 렌더링 상태 | — |
| Hover | [예: `color/surface/2`] | `motion/hover` |
| Active/Pressed | [예: `color/primary/active`] | `motion/press` |
| Focus | `shadow/focus` (필수) | — |
| Disabled | [불투명도 적용 또는 색상 변경] | — |

---

## 변형 (Variant)

### [변형 이름 (예: Primary)]
- **조건**: [사용처나 맥락 설명]
- **배경**: [토큰명]
- **텍스트**: [토큰명]

---

## 접근성 (Accessibility)
- [키보드 포커스 제어 규칙, WAI-ARIA 역할, 최소 터치 영역 등 명시]

---

## Figma Make 프롬프트

```
다음 스펙으로 [컴포넌트명] 컴포넌트를 만들어줘:

[여기에 구체적인 수치, 크기, 변형 및 상태 명세 작성]

네이밍 규칙: [컴포넌트] / {변형} / {크기} 등
```