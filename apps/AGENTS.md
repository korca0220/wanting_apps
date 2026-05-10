# apps/ — 앱 트리 공통 규약

이 디렉토리는 `wanting_apps` 모노레포의 **개별 Flutter 앱들**이 들어가는 곳이다. 어떤 앱이든 이 문서의 규약을 따른다.

상위 진입점: [`/AGENTS.md`](../AGENTS.md). 디자인 시스템: [`packages/design_system/AGENTS.md`](../packages/design_system/AGENTS.md).

---

## 🛡️ 모든 앱이 따르는 불변 규칙

상위 [`/AGENTS.md`](../AGENTS.md)의 핵심 불변 규칙을 앱 관점에서 재명시한다.

1. **단일 DS**: 색·타이포·간격·반경·그림자·모션 토큰은 **반드시** `package:design_system`의 semantic 토큰만 사용. raw hex/픽셀 직접 사용 금지.
2. **Framework-Neutral 화면 명세**: `apps/{app}/docs/screens/*.md`는 프레임워크 중립 유지. Flutter 키워드(Widget, BuildContext 등) 금지. 구현은 `lib/`에서.
3. **검증 통과**: 화면 명세는 `validate_screen.py` exit 0이어야 production-ready (스킬은 sibling 레포 `../design-system-gen/`).
4. **앱별 진입점 의무화**: 모든 앱은 `AGENTS.md`와 `README.md`를 자기 디렉토리에 가진다. 없으면 그 앱은 미완성 상태.

---

## ✍️ 코드 컨벤션 (모든 앱)

`lib/` 내부 구조·상태관리·라우팅은 앱별 자유지만, 아래 두 규칙은 모든 앱이 공통으로 따른다.

### 1. 위젯 1파일 1클래스

`presentation/pages/`의 page 파일은 **라우팅·구성에만 집중**한다. 같은 파일에 정의된 sub-widget(에러 뷰, 빈 상태, 그리드 등)은 모두 `presentation/widgets/` 하위에 **각자 별도 파일**로 분리한다.

분리 시 public(언더스코어 제거)으로 노출 — Dart `_`는 library-scope라 다른 파일에서 못 본다.

```
features/<feature>/presentation/
├── pages/
│   └── foo_page.dart           # AsyncValue 분기 + Scaffold 정도만
└── widgets/
    ├── error_view.dart
    ├── empty_view.dart
    └── ...                     # 각 위젯 한 파일
```

같은 이름의 위젯이 여러 피처에 등장(예: 피처별 `ErrorView`)해도 OK. 진짜 중복이 보이면 그때 `lib/core/`로 promote 또는 design system 합류 검토.

### 2. 빈 줄 그루핑

가까운 관계의 코드 라인은 붙여 쓰고, 관계가 약해지는 지점에 **빈 줄 1개**로 시각적 그루핑을 만든다. dart format은 빈 줄을 손대지 않으므로 사람이 의식해서 넣어야 한다.

```dart
// 같은 객체에서 파생된 보조 변수는 붙여 쓴다
final spacing = context.wdsSpacing;
final padding = EdgeInsets.all(spacing.componentMd);
final gap = spacing.componentSm;

return CustomScrollView(...);   // 변수 준비 → 반환 사이는 빈 줄
```

```dart
@override
void initState() {
  super.initState();             // boilerplate

  _scroll.addListener(_onScroll); // 실제 셋업
}
```

- 빈 줄을 연속 2줄 이상 쓰지 않는다 (메서드/클래스 분리는 dart format이 처리).
- 짧은 메서드(2~3줄, 모두 강하게 연관)에는 빈 줄을 넣지 않는다 — 인위적 분리는 가독성을 해친다.

---

## 📁 앱 디렉토리 구조 (의무 + 권장)

### 의무

| 경로 | 역할 |
|---|---|
| `apps/{app}/AGENTS.md` | 앱 진입점 — 도메인, lib 구조, 외부 의존, 명령어 |
| `apps/{app}/README.md` | 1-2줄 소개 + AGENTS.md 포인터 |
| `apps/{app}/pubspec.yaml` | `resolution: workspace`, `design_system: any` |
| `apps/{app}/lib/` | Flutter 구현 |
| `apps/{app}/test/` | 테스트 (위젯/유닛/통합) |
| `apps/{app}/docs/screens/` | 화면 명세 (framework-neutral .md, [TEMPLATE](daily_piece/docs/screens/TEMPLATE.md) 사용) |

### 권장 (앱이 자라면 추가)

| 경로 | 역할 |
|---|---|
| `apps/{app}/docs/architecture.md` | lib 레이어/모듈 도식, 의존 방향 |
| `apps/{app}/docs/adr/NNNN-name.md` | 앱 단위 의사결정 기록 (상태관리/라우팅/DI 선택 등) |
| `apps/{app}/analysis_options.yaml` | 앱별 lint 강화 (필요 시) |

### 자유 (앱마다 달라도 됨)

- `lib/` 내부 구조 (features/core/ui 패턴, layered, clean arch 등)
- 상태관리 (Riverpod / Bloc / Provider / setState)
- 라우팅 (go_router / auto_route / Navigator 1.0)
- DI 컨테이너 (get_it / Riverpod / 직접 주입)
- 테스트 스타일 (unit-heavy / widget-heavy / integration)

→ 앱별 ADR로 결정하고 그 앱 안에서만 일관되게 적용.

---

## 🆕 새 앱 추가 절차

1. **스캐폴드**

    ```bash
    flutter create --org com.wanting --platforms=ios,android apps/{new_app}
    ```

2. **워크스페이스 등록**

    `apps/{new_app}/pubspec.yaml`:
    ```yaml
    resolution: workspace
    dependencies:
      flutter:
        sdk: flutter
      design_system: any
    ```

    루트 `/pubspec.yaml`의 `workspace:` 목록에 `apps/{new_app}` 추가.

3. **의무 산출물 생성**

    - `apps/{new_app}/AGENTS.md` ← `apps/daily_piece/AGENTS.md` 참고해 작성
    - `apps/{new_app}/README.md` ← 1-2줄 + AGENTS 포인터
    - `apps/{new_app}/docs/screens/` ← `apps/daily_piece/docs/screens/{TEMPLATE.md, README.md}` 복사

4. **DS 적용**

    `lib/main.dart`에서 `MaterialApp(theme: WdsTheme.light(), darkTheme: WdsTheme.dark())`. 이외 색/타이포/간격은 `context.wdsColors` / `context.wdsType` 등으로만 접근.

5. **부트스트랩 + 첫 화면**

    ```bash
    melos bootstrap
    ```

    첫 화면 `01-{name}.md` 작성 → `validate_screen.py`로 검증 → 구현.

6. **(선택) melos 단축 명령 추가**

    루트 `/pubspec.yaml`의 `melos.scripts`에 `run:{short}` 추가하면 편함.

---

## ✅ 새 앱 합류 체크리스트

- [ ] `apps/{app}/AGENTS.md` 존재 — 도메인·lib 구조·외부 의존·명령어 채워짐
- [ ] `apps/{app}/README.md` 존재 — flutter create 스캐폴드 텍스트 제거됨
- [ ] `apps/{app}/pubspec.yaml`에 `resolution: workspace` + `design_system: any`
- [ ] 루트 `/pubspec.yaml`의 `workspace:`에 추가됨
- [ ] `apps/{app}/docs/screens/`에 최소 `TEMPLATE.md`, `README.md`, `00-INDEX.md`
- [ ] `melos bootstrap` 통과
- [ ] `melos run analyze` 통과
- [ ] `melos run test` 통과 (테스트가 있다면)

---

## 🔧 자주 쓰는 명령

```bash
melos bootstrap                    # 의존성 설치 + 패키지 링킹
melos run analyze                  # 모든 앱/패키지 dart analyze
melos run format                   # dart format
melos run format-check             # CI에서 format 검증
melos run test                     # 모든 패키지 flutter test
melos run run:dp                   # DailyPiece 실행
```

특정 앱만 작업할 때:

```bash
melos exec -c 1 --scope={app_name} -- "flutter test"
melos exec -c 1 --scope={app_name} -- "flutter analyze"
```

---

## 🧭 현재 앱 인벤토리

| 앱 | 상태 | 진입점 |
|---|---|---|
| `daily_piece` | 활성 (스캐폴드 단계) | [`daily_piece/AGENTS.md`](daily_piece/AGENTS.md) |

---

## 🔗 외부 스킬

화면 명세 검증·DS 보강은 sibling 레포의 스킬을 호출 (자세한 건 [`/AGENTS.md`](../AGENTS.md)의 `🔌 외부 의존: skills` 섹션):

```bash
python3 ../design-system-gen/skills/screen-spec-gen/scripts/validate_screen.py \
  --ds-root packages/design_system/docs \
  --repo-root . \
  apps/{app}/docs/screens/
```
