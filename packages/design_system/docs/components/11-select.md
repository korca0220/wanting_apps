# 컴포넌트: 셀렉트 (Select / Dropdown)

## 개요
옵션 리스트에서 단일 값을 선택. Trigger(input-like) + Menu Content(dropdown panel) 합성 구조. `enableMenuActionArea`로 "임시 선택 + 확인" 패턴(필터 같은 케이스)도 지원.

> **Harness Principle:** Select는 컨테이너 컴포넌트 — open/closed 상태 명시 표 필수.

---

## 디자인 토큰 매핑

### Trigger (Input-like)
| 토큰 | 값 |
|---|---|
| 외형 | TextField와 동일 (`02-text-field.md` 참조) |
| Trailing 화살표 | `caret-down` 아이콘, `color/label/alternative` |

### Menu Content (Dropdown Panel)
| 토큰 | 값 |
|---|---|
| 배경 | `color/background/elevated/normal` |
| 그림자 | `shadow/normal/medium` |
| 보더 반경 | `radius/lg` (12px) |
| 패딩 | `spacing/4` (옵션 사이 gap 0) |
| 옵션 폰트 | `text/body2` |
| 옵션 패딩 | `spacing/8` × `spacing/12` |
| 옵션 hover 배경 | `color/fill/normal` |
| 옵션 selected 배경 | `color/primary/subtle` (Light), `color/blue/20` (Dark) |
| 옵션 selected 텍스트 | `color/primary/normal` |

---

## 상태 (State) 및 인터랙션

> ⚠️ 컨테이너 컴포넌트 — 명시적 상태 표 필수.

| 상태 | 시각 표현 | 모션 |
|---|---|---|
| Closed | Trigger만 표시 | — |
| Hover (Trigger) | 보더 한 단계 진하게 | `motion/transition/shadow` |
| Focus (Trigger) | 보더 강조 | `motion/transition/shadow` |
| Open | Trigger 보더 강조 + Menu Content 등장 | `motion/keyframe/fade-in` 200ms |
| Closing | Menu Content 퇴장 | `motion/keyframe/fade-out` 150ms |
| Option Hover | 옵션 배경 `color/fill/normal` | `motion/transition/colors` |
| Option Selected | 배경 `color/primary/subtle`, 텍스트 `color/primary/normal` | — |
| Option Focus (키보드) | `shadow/focus` 또는 outline | — |
| Disabled | TextField와 동일 disabled 처리 | — |
| Invalid | 보더 `color/status/negative @ 28%` | — |

---

## 합성 슬롯
- `<Select>`: 컨테이너 + state
- `<Option>` (with leading/trailing 슬롯): 개별 옵션
- `<OptionGroup>`: 옵션 그룹 헤더
- `enableMenuActionArea` 시: 액션 버튼 영역(취소/확인) 하단 고정

---

## 접근성
- WAI-ARIA Listbox 패턴. `role="combobox"` (trigger), `role="listbox"` (menu).
- 키보드: 화살표(↑↓), Enter(선택), Esc(닫기), Home/End, type-ahead.
- `aria-activedescendant`로 키보드 포커스 관리.
- Open 시 첫 selected 옵션으로 자동 스크롤.

---

## Figma Make 프롬프트
```
Select: TextField 외형 trigger + dropdown menu panel
- Trigger: caret-down trailing
- Menu: bg elevated, shadow medium, radius 12, options padding 8×12 body2
- Option states: default/hover (fill/normal)/selected (primary/subtle bg + primary/normal text)
- Animation: fade-in 200ms ease-out
- enableMenuActionArea variant: 하단 액션 버튼 영역 추가
네이밍: Select / Closed, Select / Open, Option / Selected
```
