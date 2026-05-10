---
name: My Pieces
extends: design_system
imports: []
source:
  type: screenshot
  note: 사용자 제공 스크린샷 기반. Figma 8:2 프레임에 별도 frame은 없음 — 다른 위치의 디자인이거나 미합류 상태.
viewport:
  primary: mobile
  responsive: [mobile]
---

# Screen: My Pieces

## 개요

인증된 사용자의 **메인 진입 화면이자 BottomNav 첫 번째 탭**. 사용자가 그동안 기록한 piece들을 시간순(역순)으로 큰 카드로 보여주는 비주얼 우선 피드. 상단에 앱 브랜드 + 현재 월 + 알림 진입, 우하단에 New Piece 진입 FAB.

Search 탭(02)과의 차이:
- 검색 입력 / 월 필터 칩 **없음**
- 카드가 더 크고 풀폭 (visual-first)
- FAB로 빠른 New Piece 진입

---

## 1. Skeleton

```
Page (viewport: mobile, 375×*)
├── Region: Header                          # 고정 (sticky 가능성)
│   ├── Section: Brand
│   │   ├── Slot: appName
│   │   │   ↳ component: design_system/docs/components/16-label.md
│   │   └── Slot: currentMonth
│   │       ↳ component: design_system/docs/components/16-label.md
│   └── Slot: notificationButton
│       ↳ component: design_system/docs/components/09-icon-button.md
├── Region: Content (vertical scroll)
│   └── (반복) PieceCard × N
│       ↳ component: design_system/docs/components/06-card.md
│           ├── Slot: photo
│           │   ↳ <Custom name="DailyPiecePhoto">
│           ├── Slot: caption
│           │   ↳ component: design_system/docs/components/16-label.md
│           └── Slot: date
│               ↳ component: design_system/docs/components/16-label.md
├── Region: Floating
│   └── Slot: fab                            # FAB, 우하단 BottomNav 위
│       ↳ component: design_system/docs/components/01-button.md (variant: fab)
└── Region: Footer (BottomNav)
    ↳ component: design_system/docs/components/23-bottom-navigation.md
```

---

## 2. Bindings

### Region: Header

#### Layout 토큰

- background: `color/background/normal/normal`
- padding: `spacing/24` (horizontal)
- padding-y: `spacing/16`
- layout: 좌측(브랜드 + 월) ↔ 우측(아이콘) `space-between`

**Slot: appName**

- text-variant: `text/title2` (Inter Bold ~24px)
- color: `color/label/strong`
- content: `DailyPiece`

**Slot: currentMonth**

- text-variant: `text/caption1`
- color: `color/label/alternative`
- content: `{{now | format("MMMM yyyy")}}` (예: "March 2026")
- 위치: appName 바로 아래, 같은 정렬 시작

**Slot: notificationButton**

- ref: `design_system/docs/components/09-icon-button.md`
- variant: `normal`
- size: `medium`
- icon: `bell`
- aria-label: `알림`
- on-tap: `screen-flow → notifications` (TBD — 알림 화면 미정)

---

### Region: Content

#### Layout 토큰

- container-padding: `spacing/24` (horizontal)
- card-gap: `spacing/24` (vertical between cards)
- top-padding: `spacing/16`
- bottom-padding: `spacing/96` (FAB + BottomNav를 가리지 않게)

#### (반복) PieceCard × N

- ref: `design_system/docs/components/06-card.md`
- 카드 구조: 풀폭 + 둥근 모서리 + 어두운 elevated 배경
- container: `radius/lg` (16px), background `color/background/elevated/normal`
- on-tap: `screen-flow → 05-piece-details.md (pieceId: piece.id)`

**Slot: photo**

- ref: `<Custom name="DailyPiecePhoto">`
- aspect-ratio: 1 (정사각)
- shape: `radius/lg` (카드 상단 모서리만 적용 / 카드 통째 wrap)
- src: `{{piece.imageUrl}}`
- alt: `{{piece.caption + piece.date}}`

**Slot: caption**

- text-variant: `text/heading3` (Inter Medium ~16px, leading 22)
- color: `color/label/strong`
- content: `{{piece.caption}}` (예: "Beautiful sunset over the mountains. Nature always finds a way to amaze me.")
- max-lines: 2 (overflow ellipsis)
- padding: `spacing/16` (카드 사진 하단)

**Slot: date**

- text-variant: `text/caption1`
- color: `color/label/alternative`
- content: `{{piece.date | format("MMM d")}}` (예: "Mar 10")
- caption 바로 아래, 같은 padding

데이터 예시:

```
[
  { id: 1, caption: "Beautiful sunset over the mountains. Nature always finds a way to amaze me.", date: "2026-03-10" },
  { id: 2, caption: "Morning coffee ritual. The best way to start the day.", date: "2026-03-09" },
  { id: 3, caption: "My furry companion enjoying the afternoon sun.", date: "2026-03-08" },
  ...
]
```

---

### Region: Floating

**Slot: fab**

- variant: `fab` (둥근 사각형, 고정 위치)
- color: `primary` (`color/primary/normal` 배경)
- size: 56×56 (또는 design system 토큰)
- icon: `plus` (24×24, color `color/static/white`)
- position: 우하단 — `right: spacing/16, bottom: spacing/16` (BottomNav 위)
- on-tap: `screen-flow → 07-new-piece.md`

---

### Region: Footer (BottomNav)

- ref: `design_system/docs/components/23-bottom-navigation.md`
- variant: `with-label`
- 4-탭, 활성: **My Pieces** (`color/primary/normal` 색)

| index | label     | route       | active? |
| ----- | --------- | ----------- | ------- |
| 0     | My Pieces | `my-pieces` | ✓       |
| 1     | Calendar  | `calendar`  | —       |
| 2     | Search    | `search`    | —       |
| 3     | Profile   | `profile`   | —       |

---

## 3. Intent

### 사용자 의도

자신이 기록한 piece들을 빠르게 훑어보고(시간 순서대로 시각적으로 인지), 마음에 드는 항목 탭 → 상세, 또는 우하단 + 버튼으로 새 piece 작성.

### 진입 / 이탈

- **진입**: 인증 완료 직후 / BottomNav의 My Pieces 탭
- **이탈**:
  - PieceCard 탭 → `05-piece-details.md`
  - FAB 탭 → `07-new-piece.md`
  - 알림 버튼 → notifications (미정)
  - 다른 BottomNav 탭

### 핵심 액션 우선순위

1. **카드 탭 → Piece Details** (가장 자연스러운 정보 소비 흐름)
2. **FAB → New Piece** (작성 진입, 우하단 thumb 위치 우선)
3. 다른 탭(Calendar / Search / Profile) 전환

### 접근성

- **포커스 순서**: appName → notificationButton → 첫 카드 → ... → 마지막 카드 → FAB → BottomNav 4 items
- **카드 의미**: 각 카드는 button 역할(`role="button"`), aria-label에 caption + date 포함
- **FAB 라벨**: 아이콘만 있으므로 `aria-label="새 Piece 만들기"`
- **터치 타겟**: 카드 전체 ≥ 44px 높이, FAB ≥ 56×56
- **빈 상태 키보드 접근**: 빈 상태에서도 FAB가 첫 진입 가능한 액션이어야 함

### Reactive Behavior

- **로딩**: 카드 영역에 Skeleton(square thumbnail + 2 text lines) × 3
- **빈 상태**: 헤더 + FAB는 그대로, 본문에 `<FallbackView>` ("아직 저장된 piece가 없어요" + "오늘의 첫 piece를 만들어보세요" + 본문 안 CTA로도 New Piece 진입)
- **무한 스크롤**: 키셋 페이지네이션. 끝 근처에서 다음 페이지 prefetch. 페이지 사이즈 ~10 (큰 카드라 그리드보다 적게)
- **에러**: Snackbar variant=error, 재시도

---

## 검증 체크리스트

- [x] frontmatter 채워짐 (source.type=screenshot으로 표기)
- [x] Skeleton 위계
- [x] BottomNav 활성 = My Pieces
- [x] FAB 명세 (위치, on-tap, 라벨)
- [ ] DS의 `06-card.md`에 "photo + caption + date" composite variant이 있는지 확인 (없으면 합류 후보)
- [ ] DS의 `01-button.md`에 `fab` variant이 있는지 확인 (없으면 wanted DS 보강 후보)
- [ ] 알림 화면 미정 — 후속 결정 필요

---

## 구현 갭 (현 코드 vs 본 명세)

| 항목       | 명세                                          | 현 구현                                     |
| ---------- | --------------------------------------------- | ------------------------------------------- |
| 라우트     | `/my-pieces`                                  | `/collection`                               |
| 디렉토리   | `features/my_pieces/`                         | `features/collection/`                      |
| 카드 형태  | 풀폭 큰 카드 (사진 + 캡션 + 날짜)             | 3-열 그리드 썸네일                          |
| FAB        | 우하단 + 버튼 → New Piece                     | 없음 — 작성은 Today 탭에서                  |
| Header     | 브랜드 + 현재 월 + 알림                       | "Collection" AppBar 타이틀만                |
| BottomNav  | 4-탭, My Pieces 활성                          | 3-탭, Collection 활성                       |
| 빈 상태    | 풀 화면 FallbackView + CTA                    | "오늘로 가기" 빈 상태 (Today 라우트로)      |

> 디자인 결정사항: My Pieces의 카드 형태(풀폭 vs 그리드)는 **풀폭으로 가는 것이 명세 의도**. 현 그리드 구현은 명세를 단순화한 결과 — 이제 명세 쪽으로 회귀해야 함.
