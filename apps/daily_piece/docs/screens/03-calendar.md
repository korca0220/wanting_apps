---
name: Calendar
extends: design_system
imports: []
source:
  type: figma
  url: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece
  node_id: "2:209"
  link: https://www.figma.com/design/ThGKok9Zm1OzXpsKTyo7hN/DailyPiece?node-id=2-209&t=2SsB9yTpe6fjdj7N-4
  spec_basis: screenshot
viewport:
  primary: mobile
  responsive: [mobile]
---

# Screen: Calendar

## 개요

BottomNav의 **Calendar 탭**. 현재 월 그리드(Sun~Sat) + piece가 있는 날에 점 표시 + 오늘 표시(외곽선 강조). 셀 탭 → piece 있으면 05 Details, 없으면 07 New Piece. 하단 안내 카드("Your Daily Journey")로 사용 패턴 안내.

---

## 1. Skeleton

```
Page (viewport: mobile)
├── Region: TopBar
│   ├── Slot: prevMonthButton
│   │   ↳ component: design_system/docs/components/09-icon-button.md
│   ├── Slot: monthLabel
│   │   ↳ component: design_system/docs/components/16-label.md
│   ├── Slot: nextMonthButton
│   │   ↳ component: design_system/docs/components/09-icon-button.md
│   └── Slot: todayLink                     # 우측 정렬 link
│       ↳ component: design_system/docs/components/16-label.md
├── Region: Content (24 padding)
│   ├── Section: WeekdayHeader
│   │   └── (반복) Slot: dayName × 7
│   │       ↳ component: design_system/docs/components/16-label.md
│   ├── Section: DateGrid                   # 7-column, 6 rows max
│   │   └── (반복) <Custom name="CalendarDayCell"> × 42
│   └── Section: InfoCard                   # rounded-12 card with icon + title + body
│       ├── Slot: leadingTile
│       ├── Slot: title
│       │   ↳ component: design_system/docs/components/16-label.md
│       └── Slot: body
│           ↳ component: design_system/docs/components/16-label.md
└── Region: Footer (BottomNav)
    ↳ component: design_system/docs/components/23-bottom-navigation.md
```

---

## 2. Bindings

### Region: TopBar

- height: 56
- background: `color/background/normal/normal`
- bottom-border: `1px color/line/normal/neutral`
- layout: 좌(prev + monthLabel + next) ↔ 우(Today)
- padding-x: `spacing/16`

**Slot: prevMonthButton**

- icon: `chevron-left`
- aria-label: `이전 달`
- on-tap: `state: visibleMonth = prev`

**Slot: monthLabel**

- text-variant: `text/heading2` (Inter SemiBold ~20px)
- color: `color/label/strong`
- content: `{{state.visibleMonth | format("MMMM yyyy")}}` (예: "March 2026")

**Slot: nextMonthButton**

- icon: `chevron-right`
- aria-label: `다음 달`
- on-tap: `state: visibleMonth = next`

**Slot: todayLink**

- text-variant: `text/label1`
- color: `color/primary/normal`
- content: `Today`
- on-tap: `state: visibleMonth = thisMonth, selectedDate = today`

### Region: Content

#### Section: WeekdayHeader

- 7-column, equal width
- padding-y: `spacing/8`

**Slot: dayName** (반복)

- text-variant: `text/caption1`
- color: `color/label/alternative`
- content: `Sun | Mon | Tue | Wed | Thu | Fri | Sat`
- align: center

#### Section: DateGrid

- 7-column grid, gap `spacing/8`
- 셀 높이: ~44 (정사각 또는 height 고정)
- 표시 범위: 해당 월 1일이 포함된 주의 첫째 일 ~ 마지막 일이 포함된 주의 마지막 일 (이전/다음 달 일자 포함, dim)

##### `<Custom name="CalendarDayCell">`

상태 분기:

- **Default (이번 달, piece 없음)**: 숫자만, `text/body1`, `color/label/normal`, 배경 없음 (또는 ghost circle)
- **Has piece**: 숫자 + 하단에 `color/primary/normal` 작은 점 (4×4 circle)
- **Today** (현재 일자): 숫자 + 외곽선(circle border, 1px `color/primary/normal`), 텍스트 `color/primary/normal`
- **Selected** (사용자가 탭한 일자): 외곽선 또는 채움. 스크린샷 기준 day 10이 선택+today로 둘 다 적용된 모습.
- **Other month** (이전/다음 달): `color/label/disable`
- **Today + Has piece**: 외곽선 + 점 동시

on-tap (셀):

- piece 존재 → `screen-flow → 05-piece-details.md (pieceId: piecesByDate[date])`
- piece 없음 → `screen-flow → 07-new-piece.md (date: date)` — 시트로 열림, 시트에 미리 채울 수 있는 date param 전달
- other-month: visibleMonth 전환

데이터:

```
{
  visibleMonth: "2026-03",
  today: "2026-03-10",
  selectedDate: "2026-03-10",
  piecesByDate: {
    "2026-03-01": { id: ... },
    "2026-03-05": { id: ... },
    "2026-03-07": { id: ... },
    "2026-03-10": { id: ... },
    ...
  }
}
```

#### Section: InfoCard

- container: rounded-12, background `color/background/elevated/normal`, border `1px color/line/normal/neutral`
- padding: `spacing/16`
- layout: 가로 (leading 아이콘 타일 + 텍스트 영역), gap `spacing/12`
- top-margin: `spacing/24`

**Slot: leadingTile**

- 40×40 `radius/md` tile, bg `color/primary/subtle`
- inner: calendar 아이콘 (18, `color/primary/normal`)

**Slot: title**

- text-variant: `text/heading3`
- color: `color/label/strong`
- content: `Your Daily Journey`

**Slot: body**

- text-variant: `text/body2`
- color: `color/label/alternative`
- content: `Days with a blue dot have a piece. Tap any day to view or add a piece for that date.`

### Region: Footer (BottomNav)

- 4-탭, 활성: **Calendar**

---

## 3. Intent

### 사용자 의도

월별 시점에서 자신의 일상 흐름을 한눈에 보고, 비어있는 날을 채우거나 기존 piece를 찾아 들어간다.

### 진입 / 이탈

- **진입**: BottomNav의 Calendar 탭
- **이탈**:
  - 점 있는 날 탭 → 05 Piece Details
  - 빈 날 탭 → 07 New Piece (시트, 해당 날짜로 prefill)
  - prev/next 버튼 → 같은 화면 (state.visibleMonth 변경)
  - Today 링크 → state 리셋
  - 다른 BottomNav 탭

### 핵심 액션 우선순위

1. 셀 탭 (점 있는 날) → 상세 (정상 사용 흐름)
2. 빈 날 탭 → 새 piece 작성
3. prev/next/today (네비게이션 보조)

### 접근성

- **포커스 순서**: prev → monthLabel → next → today → weekday 첫 → 그리드 첫 셀 → ... → InfoCard → BottomNav
- **셀 라벨**: aria-label에 "{날짜}, piece 있음/없음, today/선택됨" 같이 상태 명시
- **키보드 네비**: 화살표로 셀 이동 (좌/우/상/하), Enter로 탭
- **Reduced motion**: 월 전환 애니메이션 즉시 표시

### Reactive Behavior

- **데이터 로딩 중**: DateGrid에 Skeleton (셀 placeholder) — 또는 점만 늦게 표시
- **빈 월**: 점 0개. InfoCard는 그대로 (안내 의도)
- **에러**: Snackbar variant=error, 재시도

---

## 검증 체크리스트

- [x] frontmatter / 위계
- [x] CalendarDayCell 5개 상태 명시
- [x] Today 링크 → state 리셋
- [x] 빈 날 탭 → New Piece 시트로 (날짜 prefill)
- [ ] DS에 CalendarDayCell 합류 후보 (도메인 특화 — 일단 Custom 유지 권장)
- [ ] 월 전환 시 데이터 prefetch 정책 (인접 월 미리 로드 vs lazy)

---

## 구현 갭

| 항목         | 명세                                                  | 현 구현 |
| ------------ | ----------------------------------------------------- | ------- |
| 화면 자체    | Calendar 탭, 월 그리드 + 점 + InfoCard                | 없음 (`features/calendar/` 미생성)   |
| 라우트       | `/calendar`                                           | 미정     |
| 데이터       | `piecesByDate` 맵 — 월 단위 fetch                      | 미정 — 새 repository 메서드 필요 |
