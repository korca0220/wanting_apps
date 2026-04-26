# wanting_apps — Production Repo

## 🎯 목적
1개의 디자인 시스템을 토대로 여러 앱을 만드는 **프로덕션 모노레포**.

- **`design_system/`** — 모든 앱이 공유하는 디자인 시스템 (Wanted Montage 기반 fork)
- **`apps/{app_name}/`** — 개별 앱. 각각 `docs/screens/`(framework-neutral .md)를 가지며, 향후 `apps/{app_name}/{flutter,web,...}` 같은 코드 디렉토리가 추가될 수 있음

본 레포는 "디자인 시스템 ↔ 화면 명세"의 **결과물**만 보관합니다. 생성·검증·진화는 sibling 레포 `../design-system-gen/`의 스킬을 외부에서 호출해 수행.

---

## 🧭 디렉토리 맵

| 경로 | 내용 |
|---|---|
| [`design_system/docs/`](design_system/docs/) | DS 명세 (foundations, components, adr, exec-plans, quality_report, contrast_pairs) |
| [`apps/daily_piece/docs/screens/`](apps/daily_piece/docs/screens/) | DailyPiece 앱 — 10개 화면 명세 |
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
  --ds-root design_system/docs \
  --repo-root . \
  apps/daily_piece/docs/screens/

# 명암비 검증
python3 ../design-system-gen/skills/design-system-gen/scripts/check_contrast.py \
  design_system/docs/contrast_pairs.txt
```

### 스킬 sync 모델
- 스킬 업데이트는 `design-system-gen`에서 진행. 본 레포는 외부 참조라 자동 반영됨.
- DS는 한 번 fork된 이후 본 레포에서 독립 진화. `design-system-gen/design-systems/wanted`의 변경은 자동 sync 안 됨 — **의도된 분기**.

---

## 📜 작업 흐름

### 새 컴포넌트 추가
1. `design_system/docs/components/NN-name.md` 작성 (TEMPLATE 참조)
2. `design_system/docs/components/00-INDEX.md` 갱신 (Tier 매핑)
3. 영향 받는 화면 명세에 component 참조 추가

### 새 화면 추가
1. `apps/{app}/docs/screens/TEMPLATE.md` 복제 → `NN-name.md`
2. frontmatter `extends: design_system` 명시
3. Skeleton → Bindings → Intent 순서로 채움
4. `apps/{app}/docs/screens/00-INDEX.md`에 항목 추가
5. `validate_screen.py`로 검증

### 새 앱 추가
1. `apps/{new_app}/docs/screens/`에 `TEMPLATE.md`, `README.md` 복사 (DailyPiece의 것 참조)
2. 첫 화면 작성 → 검증 → 진화

---

## 🛡️ 핵심 불변 규칙

1. **단일 DS**: 본 레포는 1개 DS만 사용. 여러 DS 믹스가 필요해지면 별도 검토(스크린 frontmatter `imports`로 해결 가능).
2. **Semantic Token Only**: 모든 컴포넌트 명세와 스크린 Bindings는 `design_system/docs/foundations/`의 Semantic Token만 참조. raw hex/픽셀 금지.
3. **Framework-Neutral**: 화면 명세에 React/Flutter/Vue 등 프레임워크 키워드/JSX 코드 작성 금지. .md는 어떤 프레임워크의 코드 생성기로도 변환되어야 함.
4. **검증 통과**: `validate_screen.py` 종료 코드 0이어야 production-ready.

---

## 🧬 출처

- **DS 출처**: [Wanted Montage](https://github.com/wanteddev/montage-web) (MIT). `wds-theme` + `wds` 패키지를 .md 명세로 fork.
- **DS 생성 스킬**: `../design-system-gen/skills/design-system-gen/`
- **스크린 명세 스킬**: `../design-system-gen/skills/screen-spec-gen/`
