# design_system — 패키지 진입점

상위 레포 규약: [`/AGENTS.md`](../../AGENTS.md). 이 패키지는 모든 앱이 공유하는 Flutter 디자인 시스템(`package:design_system`)입니다.

## 작업 범위

| 경로 | 역할 |
|---|---|
| [`lib/`](lib/) | Flutter theme/token/component 구현 |
| [`docs/`](docs/) | framework-neutral 디자인 시스템 명세 |
| [`example/`](example/) | DS 쇼케이스 앱 |
| [`test/`](test/) | 컴포넌트/골든 테스트 |
| [`fonts/`](fonts/) | Pretendard 폰트 asset |

## 핵심 규칙

1. 앱 구현에서 직접 raw 색상/간격/반경을 쓰지 않도록 public API는 semantic token 중심으로 유지합니다.
2. `docs/` 명세를 수정할 때는 [`docs/AGENTS.md`](docs/AGENTS.md)의 더 구체적인 규칙을 따릅니다.
3. public export surface는 [`lib/design_system.dart`](lib/design_system.dart)에 모으고, primitive 구현 상세는 가능한 `lib/src/` 내부에 둡니다.
4. 시각 변경이 있는 컴포넌트 수정은 가능한 한 골든 테스트를 함께 갱신하거나, 갱신하지 못한 이유를 PR에 남깁니다.

## 자주 쓰는 명령어

레포 루트에서 실행합니다.

```bash
melos run analyze
melos run test
melos run test:golden
melos run test:golden-update
melos run run:ds-example
```
