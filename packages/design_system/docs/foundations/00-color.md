# 파운데이션: 컬러 시스템 (Color)

## 개요
Wanted Montage의 컬러 시스템은 **Atomic(Primitive)**과 **Semantic** 두 계층으로 구성되며 라이트/다크 모드를 모두 1급 시민으로 지원합니다. Primary는 신뢰감 있는 `#0066FF` Blue를 채택했고, 텍스트·배경·라인은 `coolNeutral` 군에서, 채도가 강한 강조는 별도의 `accent` 카테고리로 분리합니다.

---

## 🏗️ 하네스 설계 원칙

> **Harness Principle (P3 Invariant & P4 Convention):** 컴포넌트 설계 시 하드코딩된 값을 배제하고 오직 Semantic 토큰만을 참조해야 합니다. 모든 Primitive 값은 여기서 중앙 관리됩니다.

---

## 디자인 토큰 — Primitive (Atomic)

라이트/다크 모드와 무관하게 변하지 않는 시스템의 원재료입니다. 각 컬러 패밀리는 hue를 고정한 채 lightness 단계로 분리됩니다 (낮은 숫자 = 어두움, 높은 숫자 = 밝음).

### Common
| 토큰 | 값 |
|---|---|
| `color/common/0` | `#000000` |
| `color/common/100` | `#FFFFFF` |

### Brand — Blue
| 토큰 | 값 | 비고 |
|---|---|---|
| `color/blue/10` | `#001536` | |
| `color/blue/20` | `#002966` | |
| `color/blue/30` | `#003E9C` | |
| `color/blue/40` | `#0054D1` | |
| `color/blue/45` | `#005EEB` | |
| `color/blue/50` | `#0066FF` | **Brand Key** |
| `color/blue/55` | `#1A75FF` | |
| `color/blue/60` | `#3385FF` | |
| `color/blue/65` | `#4F95FF` | |
| `color/blue/70` | `#69A5FF` | |
| `color/blue/80` | `#9EC5FF` | |
| `color/blue/90` | `#C9DEFE` | |
| `color/blue/95` | `#EAF2FE` | |
| `color/blue/99` | `#F7FBFF` | |

### Cool Neutral (Text/Surface 기반)
| 토큰 | 값 |
|---|---|
| `color/coolNeutral/5` | `#0F0F10` |
| `color/coolNeutral/7` | `#141415` |
| `color/coolNeutral/10` | `#171719` |
| `color/coolNeutral/15` | `#1B1C1E` |
| `color/coolNeutral/17` | `#212225` |
| `color/coolNeutral/20` | `#292A2D` |
| `color/coolNeutral/22` | `#2E2F33` |
| `color/coolNeutral/23` | `#333438` |
| `color/coolNeutral/25` | `#37383C` |
| `color/coolNeutral/30` | `#46474C` |
| `color/coolNeutral/40` | `#5A5C63` |
| `color/coolNeutral/50` | `#70737C` |
| `color/coolNeutral/60` | `#878A93` |
| `color/coolNeutral/70` | `#989BA2` |
| `color/coolNeutral/80` | `#AEB0B6` |
| `color/coolNeutral/90` | `#C2C4C8` |
| `color/coolNeutral/95` | `#DBDCDF` |
| `color/coolNeutral/96` | `#E1E2E4` |
| `color/coolNeutral/97` | `#EAEBEC` |
| `color/coolNeutral/98` | `#F4F4F5` |
| `color/coolNeutral/99` | `#F7F7F8` |

### Status
| Family | 키 단계 (50) | 사용처 |
|---|---|---|
| `color/red/*` | `#FF4242` | negative / danger |
| `color/green/*` | `#00BF40` | positive / success |
| `color/orange/*` | `#FF9200` | cautionary / warning |

### Accent
강조용 액센트 패밀리 7종(라이트 단계 50, 다크 단계 60 사용): `redOrange`, `lime`, `cyan`, `lightBlue`, `violet`, `purple`, `pink`. 그리고 텍스트용 추가 hue: `red`, `orange`, `green`, `blue`. 각 패밀리는 wds-theme의 `atomic/{name}.ts` 파일과 1:1 대응합니다.

> **Neutral**과 `coolNeutral`은 별도 패밀리입니다. 그림자 색은 `neutral.10` 기반.

---

## 디자인 토큰 — Semantic (라이트/다크 매핑)

컴포넌트가 실제로 참조하는 의미 토큰입니다. 라이트/다크별로 각각 다른 Primitive를 가리키므로 컴포넌트는 모드 전환을 의식할 필요가 없습니다.

### Primary (브랜드 강조)
| 토큰 | Light | Dark | 사용처 |
|---|---|---|---|
| `color/primary/normal` | `blue/50` | `blue/60` | 기본 CTA, 링크 |
| `color/primary/strong` | `blue/45` | `blue/55` | Hover |
| `color/primary/heavy` | `blue/40` | `blue/50` | Active/Pressed |
| `color/primary/subtle` | `blue/95` | `blue/20` | 선택 상태 배경, 강조 칩 배경 (텍스트는 `color/primary/normal`로) |

### On-Primary (Primary 위 전경색)
| 토큰 | Light | Dark | 사용처 |
|---|---|---|---|
| `color/onPrimary` | `common/100` | `coolNeutral/10` | Solid Primary 위에 올라가는 텍스트/아이콘 색 |

> **Why this exists:** wds 원본은 다크 모드에서도 `color: white`을 `primary/normal`(blue/60) 위에 사용해 명암비 3.54:1로 AA 미달이었습니다 (`quality_report.md` 외부 결함). 본 인스턴스는 `color/onPrimary`를 신설해 다크에서 검은 톤으로 전환, AA 통과. `01-button.md` Solid Primary 텍스트는 이 토큰을 참조합니다.

### Label (텍스트)
| 토큰 | Light | Dark |
|---|---|---|
| `color/label/normal` | `coolNeutral/10` | `coolNeutral/99` |
| `color/label/strong` | `common/0` | `common/100` |
| `color/label/neutral` | `coolNeutral/22 @ 88%` | `coolNeutral/90 @ 88%` |
| `color/label/alternative` | `coolNeutral/25 @ 61%` | `coolNeutral/80 @ 61%` |
| `color/label/assistive` | `coolNeutral/25 @ 28%` | `coolNeutral/80 @ 28%` |
| `color/label/disable` | `coolNeutral/25 @ 16%` | `coolNeutral/70 @ 16%` |

### Background
| 토큰 | Light | Dark |
|---|---|---|
| `color/background/normal/normal` | `common/100` | `coolNeutral/15` |
| `color/background/normal/alternative` | `coolNeutral/99` | `coolNeutral/5` |
| `color/background/elevated/normal` | `common/100` | `coolNeutral/17` |
| `color/background/elevated/alternative` | `coolNeutral/99` | `coolNeutral/7` |
| `color/background/transparent/normal` | `common/100 @ 8%` | `coolNeutral/17 @ 61%` |
| `color/background/transparent/alternative` | `common/100 @ 28%` | `coolNeutral/17 @ 61%` |

### Interaction
| 토큰 | Light | Dark | 사용처 |
|---|---|---|---|
| `color/interaction/inactive` | `coolNeutral/70` | `coolNeutral/40` | 비활성 인터랙티브 |
| `color/interaction/disable` | `coolNeutral/98` | `coolNeutral/22` | 비활성 배경 |

### Line (보더)
| 토큰 | Light | Dark |
|---|---|---|
| `color/line/normal/normal` | `coolNeutral/50 @ 22%` | `coolNeutral/50 @ 32%` |
| `color/line/normal/neutral` | `coolNeutral/50 @ 16%` | `coolNeutral/50 @ 28%` |
| `color/line/normal/alternative` | `coolNeutral/50 @ 8%` | `coolNeutral/50 @ 22%` |
| `color/line/solid/normal` | `coolNeutral/96` | `coolNeutral/25` |
| `color/line/solid/neutral` | `coolNeutral/97` | `coolNeutral/23` |
| `color/line/solid/alternative` | `coolNeutral/98` | `coolNeutral/22` |

### Status (상태 색)
| 토큰 | Light | Dark |
|---|---|---|
| `color/status/positive` | `green/50` | `green/60` |
| `color/status/cautionary` | `orange/50` | `orange/60` |
| `color/status/negative` | `red/50` | `red/60` |

### Fill (오버레이 채움)
| 토큰 | Light | Dark | 사용처 |
|---|---|---|---|
| `color/fill/normal` | `coolNeutral/50 @ 8%` | `coolNeutral/50 @ 22%` | Hover 배경, 보조 영역 fill |
| `color/fill/strong` | `coolNeutral/50 @ 16%` | `coolNeutral/50 @ 28%` | Active/Pressed 배경 |
| `color/fill/alternative` | `coolNeutral/50 @ 5%` | `coolNeutral/50 @ 12%` | 노트/안내 박스, 비활성 컨테이너 |

### Inverse (반전 컨텍스트)
| 토큰 | Light | Dark | 사용처 |
|---|---|---|---|
| `color/inverse/primary` | `blue/60` | `blue/50` | 다크 톤 위 primary 액센트 |
| `color/inverse/background` | `coolNeutral/15` | `common/100` | Tooltip, Snackbar 배경 |
| `color/inverse/label` | `coolNeutral/99` | `coolNeutral/10` | inverse 배경 위 텍스트 |

### Material (백드롭)
| 토큰 | Light | Dark | 사용처 |
|---|---|---|---|
| `color/material/dimmer` | `coolNeutral/10 @ 52%` | `coolNeutral/10 @ 74%` | 모달/Drawer 백드롭 |

### Accent (강조 액센트)
- `color/accent/background/{redOrange | lime | cyan | lightBlue | violet | purple | pink}`
- `color/accent/foreground/{red | redOrange | orange | lime | green | cyan | lightBlue | blue | violet | purple | pink}`

각각 라이트/다크에서 다른 단계를 참조 (Light는 50/40대, Dark는 60대 위주).

---

## 사용 원칙

1. **컴포넌트는 Semantic만 참조**합니다. Primitive 직접 참조 금지.
2. **다크 모드는 옵션이 아닌 필수**: 모든 컴포넌트는 두 모드에서 모두 검증합니다.
3. **Alpha 값은 opacity 토큰 참조**: `color/label/neutral`처럼 알파가 필요한 경우 [00-spacing.md](00-spacing.md) 같은 별도 opacity 스케일을 사용 (5/8/12/16/22/28/35/43/52/61/74/88/97).
4. **Status vs Accent 구분**: 상태 표현은 `status/*` 3종만, 비상태 강조는 `accent/*`로 분리.

---

## Figma Make 프롬프트

```
다음 스펙으로 Wanted Montage 컬러 시스템을 Figma Variables로 구성해줘:

Collection — Atomic (Mode 없음):
- common: 0(#000000), 100(#FFFFFF)
- blue: 10~99 14단계 (50=#0066FF Brand)
- coolNeutral: 5~99 21단계
- neutral / red / green / orange / pink / purple / violet / lime / cyan / lightBlue / redOrange: 각 10~99 단계
  (각 패밀리의 단계는 wds-theme/src/theme/atomic/*.ts 참조)

Collection — Semantic (Mode: Light, Dark):
- primary: normal/strong/heavy → Light는 blue/50,45,40, Dark는 blue/60,55,50
- label: normal/strong/neutral/alternative/assistive/disable → coolNeutral 변형 (alpha 적용)
- background: normal{normal,alternative}, elevated{normal,alternative}, transparent{normal,alternative}
- line: normal{normal,neutral,alternative} (alpha), solid{normal,neutral,alternative}
- status: positive(green/50,60), cautionary(orange/50,60), negative(red/50,60)
- inverse, fill, material, accent.background, accent.foreground

각 Semantic은 Atomic을 Alias로 연결.
```
