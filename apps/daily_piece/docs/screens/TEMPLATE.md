---
name: {{Screen Name}}
extends: {{base-design-system}}    # design-systems/{brand}/ 의 brand 이름
imports: []                         # 다른 DS에서 빌려오는 컴포넌트 경로 (선택)
source:
  type: {{figma | screenshot | code}}
  url: {{Source URL or path}}
  node_id: {{Figma node id, Figma 입력일 때만}}
viewport:
  primary: {{mobile | tablet | desktop}}
  responsive: [{{mobile, tablet, desktop 중 지원 폼팩터}}]
---

# Screen: {{Screen Name}}

## 개요
{{이 화면이 사용자에게 무엇을 제공하는지, 한 문단으로 서술. 비즈니스 의도 + 핵심 사용자 액션.}}

---

## 1. Skeleton (구조 골격)

레이아웃의 위계 트리. 각 슬롯은 `↳ component: <DS path>` 또는 `↳ slot: <name>` 형식.

```
Page (viewport: {{mobile}})
├── Region: <Region 1 이름>          # 의미 단위 영역 (Header, Hero, Content...)
│   ├── Section: <섹션명>
│   │   ├── Slot: leading
│   │   │   ↳ component: design-systems/{{brand}}/components/15-avatar.md
│   │   ├── Slot: title
│   │   │   ↳ component: design-systems/{{brand}}/components/16-label.md
│   │   └── Slot: trailing
│   │       ↳ component: design-systems/{{brand}}/components/09-icon-button.md
│   └── Section: ...
├── Region: <Region 2 이름>
│   └── ...
└── Region: <Floating>                # 절대 위치 (FAB, Snackbar 등)
    └── ...
```

> **레이아웃 문법**은 [references/layout_grammar.md](../../skills/screen-spec-gen/references/layout_grammar.md) 참조.
> Custom 영역은 `↳ <Custom name="...">`로 표기.

---

## 2. Bindings (구체값 결합)

각 슬롯의 props/variant/state/content를 베이스 DS의 Semantic Token만 사용해 명시합니다.

### Region: <Region 1 이름>

#### Section: <섹션명>

**Slot: leading**
- ref: `design-systems/{{brand}}/components/15-avatar.md`
- variant: `person`
- size: `medium`
- src: `{{user.avatar_url}}`     # 데이터 바인딩은 `{{...}}`
- alt: `{{user.name}}`

**Slot: title**
- ref: `design-systems/{{brand}}/components/16-label.md`
- text-variant: `text/headline2`
- color: `color/label/normal`
- content: `{{user.name}}`

**Slot: trailing**
- ref: `design-systems/{{brand}}/components/09-icon-button.md`
- variant: `normal`
- size: `medium`
- icon: `more-vertical`           # 아이콘 ID는 DS의 아이콘 시스템에 정의
- aria-label: `더 보기`
- on-tap: `screen-flow → 02-detail.md`   # 흐름 전이

### Region: <Region 2 이름>

(동일 구조로 계속)

#### Layout 토큰
- container-padding: `spacing/16`
- region-gap: `spacing/24`
- section-gap: `spacing/12`

---

## 3. Intent (의도 / 접근성 / 플로우)

### 사용자 의도
{{이 화면에서 사용자가 달성하려는 목표를 1~2문장. 예: "오늘의 추천 콘텐츠를 빠르게 훑고, 마음에 드는 항목을 저장한다."}}

### 진입 / 이탈
- **진입**: {{앱 시작 시 / 홈 탭 클릭 시 / 로그인 직후 등}}
- **이탈**: {{콘텐츠 클릭 → detail / 우상단 메뉴 → settings / 뒤로가기 → 직전 화면}}

### 핵심 액션 우선순위
1. {{최상단 액션}}
2. {{2순위 액션}}
3. {{3순위 액션}}

### 접근성
- **포커스 순서**: <Region 1 leading → title → trailing → Region 2 first item → ...>
- **스크린리더 의도**: {{화면 목적이 음성으로 어떻게 전달되어야 하는지}}
- **Reduced motion**: {{스킵할 모션 또는 폴백}}
- **터치 타겟**: 모든 인터랙티브 요소 ≥ 44×44px

### Reactive Behavior
- 데이터 로딩 중: {{Skeleton 변형 또는 Spinner — 어느 영역에}}
- 빈 상태: {{FallbackView 사용 — 메시지/액션}}
- 에러: {{Snackbar variant=error — 표시 위치}}

---

## 검증 체크리스트
- [ ] 모든 `↳ component: ...` 참조가 실제 파일 경로에 존재
- [ ] 모든 `color/...`, `spacing/...`, `radius/...` 토큰이 베이스 DS foundations에 존재
- [ ] raw hex (`#xxxxxx`) / 픽셀 (`Npx`) 가 Bindings 섹션에 없음
- [ ] frontmatter의 `extends`가 유효 (해당 디렉토리 존재)
- [ ] viewport.primary가 viewport.responsive 안에 포함됨
- [ ] 각 인터랙티브 슬롯에 on-tap/on-change 등 트리거 명시
