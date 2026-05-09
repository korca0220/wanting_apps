# Material — Blur / Surface Effects

## 개요

웹 명세는 `backdrop-filter: blur(...)`로 일부 표면(특히 `WdsTextField`)에 미세한 깊이감을 부여한다. 본 페이지는 그 토큰과, Flutter 포팅 시의 대체 결정을 기록한다.

원본 웹 토큰은 `material/blur/{name}` 네임스페이스로 분류한다.

## Semantic 토큰

| 토큰 | 값 | 사용 |
|---|---|---|
| `material/blur/standard` | `blur(32px)` | TextField 시그니처 배경 (web). |
| `material/blur/dim` | `blur(12px)` | Modal 백드롭 위 가벼운 디포커스 (web). |

> Flutter에 직접 매핑되는 토큰 클래스를 만들지 않는다. 아래 "Flutter 포팅" 항목 참고.

## Flutter 포팅

Flutter의 `BackdropFilter(filter: ImageFilter.blur(...))`는 **반투명 조상 위에서만** 의미가 있다. DailyPiece의 화면 토폴로지는 대부분 불투명 surface (`backgroundElevatedNormal` 등) 위에서 동작하므로 `blur(32px)`을 켜도 시각 차이가 없거나, 오히려 GPU 비용만 발생한다.

따라서 **현 시점에는 `material/blur/*` 토큰을 Dart로 노출하지 않는다.** 대신:

- `WdsTextField`: 배경을 `backgroundElevatedNormal` (불투명)로 그린다. blur 시그니처는 포기. 시각 깊이는 `lineNormalNeutral` 보더 + radius로 표현. — `lib/src/components/text_field/wds_text_field.dart`의 docstring에 동일 결정 명시됨.
- `WdsModal`: backdrop은 `materialDimmer` (semi-transparent overlay)만 사용. blur 미적용.
- 향후 hero/glass 표면이 도입되면 그 컴포넌트 단위에서 `BackdropFilter`를 opt-in 하고, 그때 `material/blur/standard` 상수를 `Duration`/`Curve`처럼 `lib/src/foundations/wds_material.dart`에 추가한다.

## 결정 요약

| Web 시그니처 | Flutter 결정 |
|---|---|
| `backdrop-filter: blur(32px)` (TextField 배경) | 미적용 — 불투명 surface로 대체 |
| `backdrop-filter: blur(12px)` (Modal dim) | 미적용 — `materialDimmer` 단독 사용 |

> 본 결정은 명세-구현 갭이 아닌 **의도적 포팅 선택**이다. 명세 텍스트에 `blur(...)`가 등장하면 Flutter 측 노트(이 페이지)를 따라 해석한다.
