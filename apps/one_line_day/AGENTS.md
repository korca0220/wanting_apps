# OneLine Day — App Guide

## 목적

OneLine Day는 **하루에 한 줄**만 기록하는 개인용 데일리 로그 앱이다.

- 혼자 쓰는 앱이며 SNS, 팔로우, 댓글, 공유 피드를 만들지 않는다.
- v1은 인증, 서버 동기화, 사진 첨부를 제외한다.
- 수익화는 AdMob 배너를 우선하되 저장/삭제/탭 전환 같은 핵심 인터랙션 가까이에 광고를 두지 않는다.
- 모든 UI는 루트 디자인 시스템 `package:design_system` 및 `packages/design_system/docs/` 명세를 기반으로 한다.

## 제품 원칙

1. **One line per day**: 날짜당 기록은 1개만 허용한다.
2. **Low friction**: 앱 시작 후 오늘 기록까지의 거리를 최소화한다.
3. **Local first**: v1은 로컬 저장으로 완결한다.
4. **No social surface**: 타인에게 보이는 공개 프로필/피드/반응 기능을 두지 않는다.
5. **Ads stay calm**: 광고는 콘텐츠 하단이나 안전한 여백에만 배치한다.

## 문서 우선 작업 흐름

1. `docs/screens/00-INDEX.md`에서 화면 범위와 플로우를 먼저 확정한다.
2. 각 화면은 `docs/screens/TEMPLATE.md` 형식을 따라 Skeleton → Bindings → Intent 순서로 작성한다.
3. 화면 명세는 framework-neutral하게 유지한다.
4. 구현 단계에서는 `apps/AGENTS.md`의 앱 공통 규약을 따른다.

## 현재 구조

```text
apps/one_line_day/
├── docs/screens/        # 화면 명세
├── android/             # Android 기본 프로젝트
├── ios/                 # iOS 기본 프로젝트
├── lib/                 # Flutter 구현
└── test/                # 위젯 테스트
```

## 명령어

루트에서 아래 명령을 사용한다.

```bash
melos bootstrap
melos run analyze
melos run test
```
