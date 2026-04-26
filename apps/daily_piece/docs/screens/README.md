# DailyPiece — Screen Specifications

이 디렉토리는 **DailyPiece** 모바일 앱의 스크린 명세 모음입니다. 각 .md 파일은 framework-neutral한 형식으로 작성되어 React/Flutter/SwiftUI 등 어떤 코드 생성기로도 동일하게 변환됩니다.

## 🎨 베이스 디자인 시스템
- **Primary**: `design_system` (→ [`design_system/docs/`](../../../../design_system/docs/))
- **Imports**: 없음 (단일 DS 사용)

## 📂 스크린 인덱스
- [00-INDEX.md](00-INDEX.md) — 전체 화면 흐름과 통계

## 🔗 출처 (Source)
- **종류**: figma
- **소스 URL**: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece (node-id 8:2 = 디자인 보드 전체)
- **분석 시점**: 2026-04-26

## 🛠️ 새 스크린 추가
1. `TEMPLATE.md`를 복사해 `NN-screen-name.md`로 작성
2. frontmatter의 `extends: design_system` 명시
3. Skeleton → Bindings → Intent 순서로 채움
4. `00-INDEX.md`에 항목 추가

## ⚠️ 데이터 한도 주의
DailyPiece 파일은 10개 스크린이 한 보드(node 8:2)에 모여있고, 단일 `get_design_context` 콜로는 sparse metadata만 받을 수 있습니다 (응답 크기 한도 초과). 스크린별로 sub-layer ID에 별도 콜이 필요한데 호출 한도(6/월) 제약이 있어, 본 인스턴스는 **시범 1개 화면**만 처리됐습니다. 나머지는 한도 정리 후 진행.
