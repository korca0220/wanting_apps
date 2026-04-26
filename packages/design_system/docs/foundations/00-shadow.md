# 파운데이션: 그림자 / Elevation (Shadow)

## 개요
Wanted Montage의 그림자는 **3종 × 5단계** 매트릭스로 구성됩니다. 일반 `box-shadow`(normal), 아이콘/그래픽용 `drop-shadow` 필터, 강조용 `spread`. 색상은 항상 `neutral.10` 기반의 검정 계열에 알파를 다르게 적용합니다.

---

## 🏗️ 하네스 설계 원칙

> **Harness Principle:** Elevation은 단순 픽셀 값이 아닌 **인지된 깊이**입니다. xsmall ~ xlarge는 컴포넌트의 시각적 위계를 따릅니다 — small=평면 카드, medium=드롭다운, large=모달, xlarge=풀스크린 오버레이.

---

## Shadow Normal (일반 box-shadow, 5단계)

대부분의 컴포넌트가 사용하는 기본 그림자입니다. Light/Dark 모두 동일 정의(검정 + 알파 조절).

| 토큰 | 값 |
|---|---|
| `shadow/normal/xsmall` | `0px 1px 2px -1px rgba(neutral.10, 0.10)` |
| `shadow/normal/small` | `0px 2px 4px -2px rgba(neutral.10, 0.06), 0px 4px 6px -1px rgba(neutral.10, 0.06)` |
| `shadow/normal/medium` | `0px 4px 6px -2px rgba(neutral.10, 0.07), 0px 10px 15px -3px rgba(neutral.10, 0.07)` |
| `shadow/normal/large` | `0px 6px 10px -4px rgba(neutral.10, 0.08), 0px 16px 24px -6px rgba(neutral.10, 0.08)` |
| `shadow/normal/xlarge` | `0px 10px 15px -5px rgba(neutral.10, 0.10), 0px 24px 38px -10px rgba(neutral.10, 0.12)` |

**권장 사용**:
- xsmall: 미세한 입체감 (Hover lift)
- small: Card, Dropdown trigger
- medium: Dropdown 패널, Tooltip
- large: Modal, Drawer
- xlarge: 풀스크린 오버레이

---

## Shadow Drop (drop-shadow 필터, 비직사각형용)

아이콘이나 비정형 SVG처럼 alpha가 있는 그래픽에 사용합니다. `box-shadow`는 박스 영역에만 작동하지만 `drop-shadow`는 실제 픽셀 형태를 따릅니다.

| 토큰 | 값 |
|---|---|
| `shadow/drop/xsmall` | `drop-shadow(0px 1px 0.5px rgba(neutral.10, 0.05))` |
| `shadow/drop/small` | `drop-shadow(0px 2px 1px rgba(neutral.10, 0.03)) drop-shadow(0px 4px 2.5px rgba(neutral.10, 0.03))` |
| `shadow/drop/medium` | `drop-shadow(0px 4px 2px rgba(neutral.10, 0.035)) drop-shadow(0px 10px 6px rgba(neutral.10, 0.035))` |
| `shadow/drop/large` | `drop-shadow(0px 6px 3px rgba(neutral.10, 0.04)) drop-shadow(0px 16px 9px rgba(neutral.10, 0.03))` |
| `shadow/drop/xlarge` | `drop-shadow(0px 10px 5px rgba(neutral.10, 0.05)) drop-shadow(0px 24px 14px rgba(neutral.10, 0.06))` |

---

## Shadow Spread (확산 강조용)

전체적인 발광/포커스 강조에 사용합니다. spread radius가 큰 단일 그림자.

| 토큰 | 값 |
|---|---|
| `shadow/spread/small` | `0px 0px 60px 0px rgba(neutral.10, 0.10)` |
| `shadow/spread/medium` | `0px 15px 75px 0px rgba(neutral.10, 0.16)` |

**권장 사용**: 풀스크린 모달의 장식적 발광, 강조 카드 등 Hero 영역.

---

## 사용 원칙

1. **모드 무관**: 본 그림자는 라이트/다크에서 동일 정의를 사용. 다크 모드에서 가독성이 부족하면 배경 명도로 보완.
2. **중첩 금지**: 한 컴포넌트에 normal + drop을 동시에 적용하지 마세요. 의미상 어색합니다.
3. **컬러 그림자는 별도 명세**: 브랜드 컬러 그림자 (예: 포커스 링)는 본 토큰이 아닌 [00-color.md](00-color.md)의 inverse/primary 계통과 결합해 별도 정의.

---

## Figma Make 프롬프트

```
다음 스펙으로 Wanted Montage Elevation을 Figma Effect Styles로 구성해줘:

5 levels × 3 types:
- Shadow / Normal / xsmall ~ xlarge (CSS box-shadow와 동일 spec)
- Shadow / Drop / xsmall ~ xlarge (drop-shadow 필터, 비정형 그래픽용)
- Shadow / Spread / small, medium (큰 spread radius)

색상은 모두 #171717 기반에 알파 조절.
적용 순서: shadow/drop은 svg/icon 레이어에, shadow/normal은 컨테이너 레이어에.
```
