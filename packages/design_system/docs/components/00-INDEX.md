# Component Index

이 문서는 외부 스킬 `../design-system-gen/skills/design-system-gen/references/component_checklist.md`의 표준 카탈로그에 대한 본 인스턴스의 결정 결과 보고입니다.

## 📊 요약
- **Tier 1 (필수)**: 21 / 21 ✅ Documented
- **Tier 2 (권장)**: 6 / 12 ✅ Documented (Chip, BottomNavigation, ListItem, TopNavigation, Tabs, **ImageUploader**)
- **Tier 3 (선택)**: 모두 ⛔ N/A 또는 ⏳ Pending

---

## Tier 1 — 필수

| # | Component | Status | File |
|---|---|---|---|
| 01 | Button | ✅ Documented | [01-button.md](01-button.md) |
| 09 | Icon Button | ✅ Documented | [09-icon-button.md](09-icon-button.md) |
| 02 | Text Field (Input) | ✅ Documented | [02-text-field.md](02-text-field.md) |
| 10 | Textarea | ✅ Documented | [10-textarea.md](10-textarea.md) |
| 11 | Select / Dropdown | ✅ Documented | [11-select.md](11-select.md) |
| 03 | Checkbox | ✅ Documented | [03-checkbox.md](03-checkbox.md) |
| 12 | Radio | ✅ Documented | [12-radio.md](12-radio.md) |
| 13 | Toggle / Switch | ✅ Documented | [13-switch.md](13-switch.md) |
| 14 | Badge / Tag | ✅ Documented | [14-content-badge.md](14-content-badge.md) |
| 15 | Avatar | ✅ Documented | [15-avatar.md](15-avatar.md) |
| 16 | Label | ✅ Documented | [16-label.md](16-label.md) |
| 17 | Divider | ✅ Documented | [17-divider.md](17-divider.md) |
| 18 | Alert | ✅ Documented | [18-alert.md](18-alert.md) |
| 08 | Toast / Snackbar | ✅ Documented | [08-snackbar.md](08-snackbar.md) |
| 19 | Spinner | ✅ Documented | [19-spinner.md](19-spinner.md) |
| 20 | Progress Bar / Tracker | ✅ Documented | [20-progress-tracker.md](20-progress-tracker.md) |
| 21 | Skeleton | ✅ Documented | [21-skeleton.md](21-skeleton.md) |
| 22 | Empty State | ✅ Documented | [22-fallback-view.md](22-fallback-view.md) |
| 06 | Card | ✅ Documented | [06-card.md](06-card.md) |
| 07 | Modal / Dialog | ✅ Documented | [07-modal.md](07-modal.md) |
| 05 | Tooltip | ✅ Documented | [05-tooltip.md](05-tooltip.md) |

---

## Tier 2 — 권장

| Component | Status | wds 원본 | Note |
|---|---|---|---|
| 04 Chip | ✅ Documented | `components/chip` | [04-chip.md](04-chip.md) |
| 23 BottomNavigation | ✅ Documented | `components/bottom-navigation` | [23-bottom-navigation.md](23-bottom-navigation.md) — DailyPiece 5/10 화면에서 사용 |
| 24 ListItem | ✅ Documented | `components/list` | [24-list-item.md](24-list-item.md) — Settings Row, 메뉴 행 등 광범위 |
| 25 TopNavigation | ✅ Documented | `components/top-navigation` | [25-top-navigation.md](25-top-navigation.md) — 모든 화면 헤더 표준 |
| 26 Tabs | ✅ Documented | `components/tab` | [26-tabs.md](26-tabs.md) — underline/pills variant |
| 27 ImageUploader | ✅ Documented (합성) | `components/image-base` 활용 | [27-image-uploader.md](27-image-uploader.md) — empty/preview 양 모드, DailyPiece New Piece + Edit Piece 적용 |
| Drawer / Sheet | ⏳ Pending | (Modal `bottom` variant로 일부 커버) | wds Modal/bottom + handle이 sheet 역할 |
| Accordion / Disclosure | ⏳ Pending | `components/accordion` | |
| Popover | ⏳ Pending | `components/popover`, `popper` | |
| Breadcrumb | ⏳ Pending | (없음) | wds에 직접 컴포넌트 없음 |
| Pagination | ⏳ Pending | `components/pagination`, `pagination-dots`, `page-counter` | |
| Menu / Dropdown Menu | ⏳ Pending | `components/menu` | |
| Table | ⏳ Pending | `components/table` | |
| Stat Card | ⏳ Pending | (없음) | Card 합성으로 표현 가능 |

---

## Tier 3 — 선택

wds 원본에 존재하는 도메인 특화 컴포넌트:

| Component | Status | wds 원본 |
|---|---|---|
| Date Picker | ⏳ Pending | `date-picker`, `date-calendar`, `date-range-picker`, `date-range-calendar` |
| Time Picker | ⏳ Pending | `time-picker`, `time-view` |
| Slider | ⏳ Pending | `slider` |
| Stepper | ⏳ Pending | `stepper` |
| Segmented Control | ⏳ Pending | `segmented-control` |
| Search Field | ⏳ Pending | `search-field` |
| File Uploader | ⛔ N/A | wds에 없음, 도메인 무관 |
| Command Palette | ⛔ N/A | wds에 없음 |
| Code Block | ⛔ N/A | 도메인 무관 |
| Kbd | ⛔ N/A | 도메인 무관 |
| Tree View | ⛔ N/A | wds에 없음 |
| Calendar | ⏳ Pending | `date-calendar` (위 Date Picker에서 커버) |

---

## Completeness 등급

본 카탈로그 내 결정 가능한 항목 기준:
- Tier 1: 21 / 21 = 100%
- Tier 2: 6 / 12 = 50% (Chip, BottomNavigation, ListItem, TopNavigation, Tabs, ImageUploader ✅, 나머지 6 ⏳)
- Tier 3 (분모 제외 항목): N/A 4개를 분모에서 제외, 나머지 ⏳

종합 (Tier 1만 가중치 100%, Tier 2를 50%로 가중치 적용 시): **~75%**

[quality_rubric.md의 Completeness 등급](../../../skills/design-system-gen/references/quality_rubric.md#-completeness-점수-부분-처리-인스턴스용) 기준 → **High** 등급 (≥ 80% 초과 시 Full).

> Tier 1 완전 달성으로 production-ready 핵심은 충족. Tier 2 보강은 후속 작업.
