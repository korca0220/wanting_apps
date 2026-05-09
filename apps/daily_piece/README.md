# DailyPiece

미니멀 라이프 로깅 앱. 하루 한 장 사진 + 50자 코멘트로 일상을 기록한다.

→ 진입점: [`AGENTS.md`](AGENTS.md)
→ 화면 명세: [`docs/screens/`](docs/screens/)
→ 결정 기록: [`docs/adr/`](docs/adr/)

## 실행

Supabase URL/anonKey를 `--dart-define`으로 주입해야 한다 (없으면 시작 시 assert 실패):

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://<your-ref>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<your-anon-key>
```

또는 melos 스크립트를 쓰고 싶다면 위 두 변수를 환경에 노출시킨 뒤:

```bash
melos run run:dp -- \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
```

키는 절대 커밋하지 말 것. 로컬 개발 키는 `~/.zshrc` 등 셸 환경에 두고, CI는 GitHub Secrets에서 주입한다.
