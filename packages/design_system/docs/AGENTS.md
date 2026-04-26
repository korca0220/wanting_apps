# 🗺️ 에이전트 가이드 (AGENTS.md)

이 문서는 AI 에이전트가 `Wanted Montage Design System` 프로젝트를 탐색하고 작업하기 위한 최상위 지도입니다.

## 🧭 프로젝트 맵 (Map)

이 레포지토리의 정보를 파악할 때는 다음 순서를 따르세요.

1. **지식 저장소 가이드**: [docs/README.md](docs/README.md) — 전체 문서 구조 및 운영 규칙 안내
2. **파운데이션(Tokens)**: [foundations/](foundations/) — 색상, 간격, 섀도우 등 디자인 시스템의 기본 단위
3. **컴포넌트(Components)**: [components/](components/) — 실제 UI 구성 요소의 명세

## 📜 디자인 시스템 필수 불변 규칙 (Invariants)

작업 시 다음 규칙을 절대 어겨서는 안 됩니다.

1. **Semantic Token 사용**: 컴포넌트 명세 작성 시 원시 값(Hex Code, Pixel 등)을 직접 사용하지 마세요. 반드시 `foundations`에 정의된 **Semantic Token**(`color/primary/default`, `spacing/component-md` 등)을 사용해야 합니다.
2. **계층적 문서화**: 모든 새로운 설계 결정은 `docs/adr/`에 기록하고, 대규모 작업 전에는 `docs/exec-plans/`에서 계획을 먼저 수립하십시오.
3. **고품질 프론트엔드 기준**:
    - **Originality**: 일반적인 AI 패턴을 지양하고, **Wanted Montage** 고유의 시각적 무드를 유지하세요.
    - **Craft**: 타이포그래피 위계와 간격의 일관성, 접근성(Contrast Ratio)을 엄격히 준수하세요.

## 🚀 다음 단계

작업 요청을 받으면 `docs/exec-plans/`에 계획을 먼저 작성하거나, 기존의 `TEMPLATE.md`를 바탕으로 `foundations` 또는 `components`를 업데이트하세요.
