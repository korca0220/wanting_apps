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

## 구현 상태

| 영역 | 상태 | 비고 |
|---|---|---|
| Core domain (Entry entity + repository interface) | ✅ | `core/domain/` |
| Hive CE 저장소 구현 | ✅ | `core/data/` — key: `yyyy-MM-dd`, `entries` / `settings` box |
| Riverpod AllEntries notifier (save/delete) | ✅ | `core/providers/all_entries_provider.dart` |
| ThemeModeController | ✅ | Hive `settings` box 영속 |
| 5-탭 라우터 + MainShellPage | ✅ | `app/router.dart`, `app/shell/` |
| Today 화면 | ✅ 코드 | 오늘 기록 있음/없음 분기, EditEntry 시트 진입 |
| EditEntry 시트 | ✅ 코드 | 저장/삭제/취소. WdsAlert 삭제 확인 |
| Calendar 화면 | ✅ 코드 | 월 그리드 + dot map + 날짜 탭 → EditEntry 시트 |
| Entries 화면 | ✅ 코드 | 전체 기록 최신순 목록 |
| Search 화면 | ✅ 코드 | 클라이언트 사이드 키워드 검색 |
| Settings 화면 | ✅ 코드 | System/Light/Dark 테마 선택 |
| 실기 검증 | ❌ | golden path 미검증 |
| AdMob 광고 슬롯 | ❌ TBD | Today + Entries 하단 배너 예정 |
| 앱 아이콘 | ❌ | 플레이스홀더 |

## 현재 구조

```text
apps/one_line_day/
├── docs/screens/        # 화면 명세
├── android/             # Android 기본 프로젝트
├── ios/                 # iOS 기본 프로젝트
├── lib/
│   ├── main.dart
│   ├── app/             # app.dart, router.dart, shell/
│   ├── core/
│   │   ├── domain/      # Entry entity + EntryRepository interface
│   │   ├── data/        # EntryRecord (Hive), HiveEntryRepository
│   │   ├── providers/   # AllEntries notifier
│   │   ├── theme/       # ThemeModeController
│   │   └── utils/       # dateKey()
│   └── features/
│       ├── today/        # TodayPage + providers
│       ├── edit_entry/   # EditEntrySheet (바텀시트)
│       ├── calendar/     # CalendarPage + providers
│       ├── entries/      # EntriesPage
│       ├── search/       # SearchPage + providers
│       └── settings/     # SettingsPage
└── test/
```

## 명령어

루트에서 아래 명령을 사용한다.

```bash
melos bootstrap
melos run analyze
melos run test
```
