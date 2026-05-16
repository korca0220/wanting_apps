# design_system

Wanting 앱들이 공유하는 Flutter 디자인 시스템 패키지입니다. Wanted Montage를 기반으로 fork한 문서 명세를 `packages/design_system/docs/`에 두고, 그 명세를 Flutter 위젯과 semantic token API로 구현합니다.

## 역할

- `package:design_system`으로 앱에서 공통 UI 컴포넌트와 테마를 import합니다.
- raw color/spacing/radius 값 대신 semantic token 기반 API를 제공합니다.
- DailyPiece를 포함한 앱 화면 명세가 참조하는 컴포넌트의 Flutter 구현을 포함합니다.

## 구성

| 경로 | 내용 |
|---|---|
| [`lib/design_system.dart`](lib/design_system.dart) | 패키지 public export surface |
| [`lib/src/theme/`](lib/src/theme/) | `WdsTheme`, semantic color/typography/spacing/radius/shadow/motion theme extensions |
| [`lib/src/components/`](lib/src/components/) | Button, TextField, Card, Modal, BottomNavigation, ImageUploader 등 DS 컴포넌트 |
| [`docs/`](docs/) | framework-neutral DS 명세, foundations, components, ADR, quality report |
| [`example/`](example/) | 디자인 시스템 쇼케이스 앱 |
| [`test/`](test/) | 컴포넌트/골든 테스트 |

## 사용 예시

```dart
import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;

    return Padding(
      padding: EdgeInsets.all(spacing.componentMd),
      child: WdsButton(
        onPressed: () {},
        child: const Text('Save'),
      ),
    );
  }
}
```

앱 루트에서는 `MaterialApp(theme: WdsTheme.light(), darkTheme: WdsTheme.dark())`로 DS token을 주입합니다. 자세한 public export는 [`lib/design_system.dart`](lib/design_system.dart)를 확인하세요.

## 개발 명령어

레포 루트에서 실행합니다.

```bash
melos run analyze
melos run test
melos run test:golden
melos run run:ds-example
```

## 문서

- 디자인 시스템 개요: [`docs/README.md`](docs/README.md)
- 컴포넌트 인덱스: [`docs/components/00-INDEX.md`](docs/components/00-INDEX.md)
- 품질 리포트: [`docs/quality_report.md`](docs/quality_report.md)
- 에이전트/기여자 가이드: [`AGENTS.md`](AGENTS.md)
