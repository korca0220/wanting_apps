# wanting_apps — Production Repo

## 🎯 목적
1개의 디자인 시스템을 토대로 여러 앱을 만드는 **Flutter 모노레포**.

- **`packages/design_system/`** — 모든 앱이 패키지로 의존하는 디자인 시스템 (Wanted Montage 기반 fork). Flutter package + 명세 docs.
- **`apps/{app_name}/`** — 개별 Flutter 앱. `docs/screens/`(framework-neutral .md) + `lib/` 등 Flutter 코드.

워크스페이스는 **pub workspaces** 위에 **Melos**로 운영됨. 명세(.md)와 구현(Flutter 코드)이 같은 패키지 안에 공존.

---

## 🧭 디렉토리 맵

| 경로 | 내용 |
|---|---|
| `pubspec.yaml` | pub workspace 루트 (`workspace:` 멤버 + `melos:` 스크립트 정의) |
| [`packages/design_system/docs/`](packages/design_system/docs/) | DS 명세 (foundations, components, adr, exec-plans, quality_report, contrast_pairs) |
| `packages/design_system/lib/` | DS Flutter 구현 (`package:design_system`) |
| [`apps/daily_piece/docs/screens/`](apps/daily_piece/docs/screens/) | DailyPiece 앱 — 화면 명세 (framework-neutral .md) |
| `apps/daily_piece/lib/` | DailyPiece Flutter 구현 |
| `apps/{another_app}/...` | 향후 다른 앱들 |

---

## 🔌 외부 의존: skills

본 레포는 **스킬을 자체 보유하지 않습니다.** 스킬은 sibling 레포에 있고 필요 시 외부에서 호출:

```
../design-system-gen/skills/
├── design-system-gen/    ← DS 생성·보강 워크플로우
└── screen-spec-gen/      ← 스크린 명세 워크플로우 + 검증 스크립트
```

### 자주 쓰는 호출 (현재 디렉토리: `wanting_apps/`)

```bash
# 스크린 명세 검증
python3 ../design-system-gen/skills/screen-spec-gen/scripts/validate_screen.py \
  --ds-root packages/design_system/docs \
  --repo-root . \
  apps/daily_piece/docs/screens/

# 명암비 검증
python3 ../design-system-gen/skills/design-system-gen/scripts/check_contrast.py \
  packages/design_system/docs/contrast_pairs.txt
```

### 스킬 sync 모델
- 스킬 업데이트는 `design-system-gen`에서 진행. 본 레포는 외부 참조라 자동 반영됨.
- DS는 한 번 fork된 이후 본 레포에서 독립 진화. `design-system-gen/design-systems/wanted`의 변경은 자동 sync 안 됨 — **의도된 분기**.

---

## 📜 작업 흐름

### 새 컴포넌트 추가
1. `packages/design_system/docs/components/NN-name.md` 작성 (TEMPLATE 참조)
2. `packages/design_system/docs/components/00-INDEX.md` 갱신 (Tier 매핑)
3. 영향 받는 화면 명세에 component 참조 추가
4. (필요 시) `packages/design_system/lib/`에 Flutter 구현 추가

### 새 화면 추가
1. `apps/{app}/docs/screens/TEMPLATE.md` 복제 → `NN-name.md`
2. frontmatter `extends: design_system` 명시
3. Skeleton → Bindings → Intent 순서로 채움
4. `apps/{app}/docs/screens/00-INDEX.md`에 항목 추가
5. `validate_screen.py`로 검증

### 새 앱 추가
1. `flutter create --org com.wanting --platforms=ios,android apps/{new_app}` 실행
2. `apps/{new_app}/pubspec.yaml`에 `resolution: workspace` 추가, `dependencies`에 `design_system: any` 추가 (pub workspace가 sibling 자동 해결)
3. 루트 `pubspec.yaml`의 `workspace:` 목록에 `apps/{new_app}` 추가
4. `apps/{new_app}/docs/screens/`에 `TEMPLATE.md`, `README.md` 복사 (DailyPiece의 것 참조)
5. `melos bootstrap` 실행
6. 첫 화면 작성 → 검증 → 진화

---

## 🛡️ 핵심 불변 규칙

1. **단일 DS**: 본 레포는 1개 DS만 사용. 여러 DS 믹스가 필요해지면 별도 검토(스크린 frontmatter `imports`로 해결 가능).
2. **Semantic Token Only**: 모든 컴포넌트 명세와 스크린 Bindings는 `packages/design_system/docs/foundations/`의 Semantic Token만 참조. raw hex/픽셀 금지.
3. **Framework-Neutral 명세**: `docs/screens/*.md`는 프레임워크 중립 유지 (Flutter 키워드 금지). 구현은 `lib/`에서 한다.
4. **검증 통과**: `validate_screen.py` 종료 코드 0이어야 production-ready.

---

## 🔧 Melos 명령어

```bash
melos bootstrap        # 의존성 설치 + 패키지 링킹
melos run analyze      # 전체 패키지 dart analyze
melos run format       # 전체 dart format
melos run test         # 전체 flutter test
melos run clean        # 전체 flutter clean
melos run run:dp       # DailyPiece 앱 실행
```

---

## 🧬 출처

- **DS 출처**: [Wanted Montage](https://github.com/wanteddev/montage-web) (MIT). `wds-theme` + `wds` 패키지를 .md 명세로 fork.
- **DS 생성 스킬**: `../design-system-gen/skills/design-system-gen/`
- **스크린 명세 스킬**: `../design-system-gen/skills/screen-spec-gen/`
