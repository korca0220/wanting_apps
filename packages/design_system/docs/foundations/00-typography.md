# 파운데이션: 타이포그래피 (Typography)

## 개요
Wanted Montage의 타이포그래피는 **Pretendard JP**를 기반으로 19개의 사이즈 variant × 3개 weight를 정의합니다. iOS Human Interface와 비슷한 위계(Display/Title/Heading/Headline/Body/Label/Caption)를 따르며, 본문 가독성을 위해 일부 variant에 별도의 reading 변형을 둡니다.

> **풍부한 위계는 의도된 디자인 결정**: 19단계는 일반 권장(5~9단계)보다 많지만, 채용·이력·일기 같은 *읽는 경험* 중심 도메인에서 본문/설명/캡션의 미세한 위계를 표현하기 위해 의도적으로 풍부하게 둡니다. (예: `body1` vs `body1-reading`은 동일 사이즈지만 라인하이트만 달라 긴 글에서 가독성↑.) 단, 한 화면에서 이 모든 단계를 사용하는 게 아니라, 컨텍스트별로 3~5단계만 골라 쓰는 게 원칙.

---

## 🏗️ 하네스 설계 원칙

> **Harness Principle:** 폰트 사이즈/라인하이트/letter-spacing은 직접 px/rem 값으로 컴포넌트에 적지 말고 본 토큰의 variant 이름을 참조하세요. 모든 사이즈는 1rem = 16px 기준의 rem 단위입니다.

---

## 폰트 패밀리

| 토큰 | 값 |
|---|---|
| `font/family/primary` | `Pretendard JP` (한국어/일본어 최적화 산세리프) |

> Fallback: `system-ui, -apple-system, "Apple SD Gothic Neo", "Hiragino Sans", "Noto Sans CJK KR", sans-serif`

---

## 타이포 Variant (사이즈 × 라인하이트 × letter-spacing)

| 토큰 | font-size | line-height | letter-spacing | px 환산 (size/line) |
|---|---|---|---|---|
| `text/display1` | 3.5rem | 4.5rem | -0.0319em | 56 / 72 |
| `text/display2` | 2.5rem | 3.25rem | -0.0282em | 40 / 52 |
| `text/display3` | 2.25rem | 3rem | -0.027em | 36 / 48 |
| `text/title1` | 2rem | 2.75rem | -0.0253em | 32 / 44 |
| `text/title2` | 1.75rem | 2.375rem | -0.0236em | 28 / 38 |
| `text/title3` | 1.5rem | 2rem | -0.023em | 24 / 32 |
| `text/heading1` | 1.375rem | 1.875rem | -0.0194em | 22 / 30 |
| `text/heading2` | 1.25rem | 1.75rem | -0.012em | 20 / 28 |
| `text/headline1` | 1.125rem | 1.625rem | -0.002em | 18 / 26 |
| `text/headline2` | 1.0625rem | 1.5rem | 0em | 17 / 24 |
| `text/body1` | 1rem | 1.5rem | 0.0057em | 16 / 24 |
| `text/body1-reading` | 1rem | 1.625rem | 0.0057em | 16 / 26 |
| `text/body2` | 0.9375rem | 1.375rem | 0.0096em | 15 / 22 |
| `text/body2-reading` | 0.9375rem | 1.5rem | 0.0096em | 15 / 24 |
| `text/label1` | 0.875rem | 1.25rem | 0.0145em | 14 / 20 |
| `text/label1-reading` | 0.875rem | 1.375rem | 0.0145em | 14 / 22 |
| `text/label2` | 0.8125rem | 1.125rem | 0.0194em | 13 / 18 |
| `text/caption1` | 0.75rem | 1rem | 0.0252em | 12 / 16 |
| `text/caption2` | 0.6875rem | 0.875rem | 0.0311em | 11 / 14 |

---

## Weight

| 토큰 | font-weight | 비고 |
|---|---|---|
| `font/weight/regular` | 400 | 기본 |
| `font/weight/medium` | 500 | 강조 |
| `font/weight/bold` | 700 (Display/Title), 600 (그 외) | variant에 따라 자동 매핑 |

> **Bold 자동화 규칙**: `display1~3`, `title1~3`은 700, 그 외 variant는 600을 적용합니다 (wds 패키지 `getWeightMap`).

---

## 사용 원칙

1. **위계는 컴포넌트 의도로 결정**: 화면의 첫 헤더라고 무조건 `display1`이 아닙니다. 정보 위계와 화면 레이아웃을 고려해 위에서 아래로 위계를 짭니다.
2. **Reading 변형은 본문 길이 ≥ 3줄**일 때 사용: 라인하이트가 더 넓어 가독성 우위.
3. **Letter-spacing 음수**(-em)는 큰 사이즈에서 더 두드러집니다. 직접 수정하지 마세요.
4. **Caption은 보조 정보 전용**: 11~12px로 작아 본문 텍스트로 사용 금지.
5. **다크 모드 가독성**: dark에서 `font-weight 400`은 가늘어 보일 수 있으므로 본문은 `medium` 권장 검토.

---

## Figma Make 프롬프트

```
다음 스펙으로 Wanted Montage 타이포그래피 시스템을 Figma Text Styles로 구성해줘:

Font: Pretendard JP

Style 이름 = 위 표의 토큰 마지막 segment (display1, body1-reading 등).
각 스타일에 size/line-height/letter-spacing 적용.
Weight 변형은 같은 사이즈 내에서 Regular/Medium/Bold 3종.

Hierarchy:
- display1~3: 가장 큰 헤더 (랜딩 등)
- title1~3: 페이지 제목
- heading1~2: 섹션 제목
- headline1~2: 카드/모듈 제목
- body1~2 + reading: 본문
- label1~2: 폼 라벨, 버튼 텍스트
- caption1~2: 보조/메타 정보
```
