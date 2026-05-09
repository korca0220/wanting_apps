# DailyPiece

미니멀 라이프 로깅 앱. 하루 한 장 사진 + 50자 코멘트로 일상을 기록한다.

→ 진입점: [`AGENTS.md`](AGENTS.md)
→ 화면 명세: [`docs/screens/`](docs/screens/)
→ 결정 기록: [`docs/adr/`](docs/adr/)

## 처음 셋업 (1회)

```bash
# 1. Supabase URL / anonKey를 .env에 채움
cp .env.example .env
$EDITOR .env   # SUPABASE_URL, SUPABASE_ANON_KEY 입력

# 2. envied 코드 생성 (.env → 난독화된 typed Env)
melos run gen
```

`.env`는 git에 올라가지 않는다. 키 값은 1Password 등에 보관.

`.env`나 `pubspec.yaml`을 수정하면 `melos run gen`을 다시 돌려야 한다.

## 실행

```bash
melos run run:dp
```

(내부적으로 `flutter run` — `--dart-define`은 더 이상 필요 없음)

## CI

GitHub Actions는 진짜 키 없이 컴파일한다. `.env.example`을 `.env`로 복사한 뒤 `melos run gen`을 돌려 빈 값으로 빌드 — analyze/test에는 문제 없음. 실제 배포 잡이 생기면 GitHub Secrets에서 진짜 키를 주입.
