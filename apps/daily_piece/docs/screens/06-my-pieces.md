---
name: My Pieces
extends: design_system
imports: []
source:
  type: none
  note: BottomNav 첫 번째 탭이지만 8:2 프레임에 대응하는 화면 디자인이 없음. 디자인 미확정.
viewport:
  primary: mobile
  responsive: [mobile]
---

# Screen: My Pieces (디자인 미확정)

## 상태

본 화면은 **BottomNav 4개 탭(My Pieces / Calendar / Search / Profile) 중 첫 번째**로 라벨만 정의돼 있고, Figma `8:2` 프레임 어디에도 대응하는 화면 frame이 없다. 즉 디자인은 미확정 상태.

이전 명세에는 "Home" 또는 "My Pieces" 콘텐츠가 채워져 있었지만, 그건 sparse metadata 추정에서 비롯된 가설이었고 실제 Figma에는 **이 탭의 화면 디자인이 존재하지 않는다**.

---

## 결정 필요 사항

이 탭의 의도가 다음 중 어느 것인지 디자인 결정이 선행돼야 한다:

1. **Search 탭과 같은 콘텐츠 (캡션 검색 + 카드 리스트)** — 이 경우 02-search.md를 그대로 재사용하거나 `My Pieces`를 default 진입(검색어 비어있는 상태)로 해석.
2. **그리드 형태의 타임라인 (월별 구분 없이 모든 piece를 시각 위주로 보여줌)** — Search와 별도 화면으로 디자인 필요.
3. **"오늘의 흐름" 페이지** — 인증된 사용자가 처음 만나는 환영 페이지. 최근 piece 미니카드 + 빠른 New Piece 진입 등.

옵션 1이라면 본 문서는 폐기 가능. 옵션 2/3이라면 Figma에 새 frame을 추가하고 본 문서를 채워야 한다.

---

## 임시 구현 메모

코드 측은 현재 `features/collection/`(=캘린더 직전의 그리드 + 무한 스크롤)이 사실상 "My Pieces 같은 역할"을 한다. 디자인 결정 후 `features/collection/` ↔ My Pieces 매핑을 명확히 한다.
