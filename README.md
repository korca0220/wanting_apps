# wanting_apps

Flutter 모노레포. 1개의 디자인 시스템 위에 여러 앱이 올라간다.

## 구조

| 경로 | 내용 |
|---|---|
| [`packages/design_system/`](packages/design_system/) | 모든 앱이 공유하는 DS (Wanted Montage 기반 fork). `package:design_system`으로 import. |
| [`apps/`](apps/) | 개별 Flutter 앱. 현재 [`daily_piece`](apps/daily_piece/) 1개. |

운영은 **pub workspaces + Melos**.

## 시작

```bash
flutter pub get        # 또는 melos bootstrap
melos run analyze
melos run test
melos run run:dp       # DailyPiece 실행
melos run run:ds-example   # DS 쇼케이스 실행
```

전체 melos 스크립트는 루트 [`pubspec.yaml`](pubspec.yaml) 참조.

## 더 읽기

- **에이전트/기여자 진입점**: [`AGENTS.md`](AGENTS.md) — 디렉토리 맵, 작업 흐름, 불변 규칙
- **앱 트리 공통 규약**: [`apps/AGENTS.md`](apps/AGENTS.md)
- **디자인 시스템**: [`packages/design_system/AGENTS.md`](packages/design_system/AGENTS.md)
