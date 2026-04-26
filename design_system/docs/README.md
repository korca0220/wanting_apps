# Wanted Montage Design System

이 프로젝트는 **Wanted Montage (#0066FF)** 브랜딩을 기반으로 한 제품 디자인 시스템입니다. 일관된 시각적 언어와 고품질의 사용자 경험을 제공하기 위해 파운데이션(Tokens)과 컴포넌트(UI Elements)로 구성되어 있습니다.

## 🏗️ 프로젝트 구조

- **[foundations/](./foundations/)**: 디자인 시스템의 원재료인 디자인 토큰(Color, Typography, Spacing, Shadow, Border Radius, Motion)이 정의되어 있습니다.
- **[components/](./components/)**: 파운데이션 토큰을 조합하여 만든 재사용 가능한 UI 컴포넌트 명세입니다.
- **[docs/](./docs/)**: 시스템 설계 결정 내역(ADR) 및 작업 계획서가 기록됩니다.

## 🎨 핵심 아이덴티티
- **Brand Color**: `Wanted Blue (#0066FF)` — atomic.blue.50
- **Typography**: `Pretendard JP` (한국어/일본어 최적화 산세리프)
- **Design Philosophy**: 정보 위계가 명확하고 라이트/다크 모드를 모두 1급 시민으로 다루는, 채용·이력 도메인을 위한 정직하고 차분한 디자인.

## 🔗 출처 (Source)
- **입력 종류**: code (TypeScript / React)
- **소스 레포**: https://github.com/wanteddev/montage-web (MIT)
- **분석 패키지**: `@wanteddev/wds-theme`, `@wanteddev/wds`
- **공식 사이트**: https://montage.wanted.co.kr

## 🛠️ 기여 가이드
새로운 컴포넌트나 파운데이션을 추가할 때는 각 디렉토리의 `TEMPLATE.md`를 참조하여 일관된 형식으로 작성하십시오. 모든 컴포넌트는 반드시 `foundations`에 정의된 **Semantic Token**만을 사용하여 스타일링되어야 합니다.
