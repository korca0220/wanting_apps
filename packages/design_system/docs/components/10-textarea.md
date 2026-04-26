# 컴포넌트: 텍스트에어리어 (Text Area)

## 개요
멀티라인 텍스트 입력. `minRows`/`maxRows`로 자동 높이 조정, `maxLength` + characterCounter slot으로 글자수 제한 표시. TextField와 동일한 시각 언어를 따름.

---

## 디자인 토큰 매핑

| 토큰 | 값 |
|---|---|
| 폰트 | `text/body1` |
| 배경 | `color/background/transparent/normal` |
| 보더 | `inset 0 0 0 1px color/line/normal/neutral` |
| 그림자 | `shadow/normal/xsmall` |
| 보더 반경 | `radius/lg` (12px) |
| 패딩 | `spacing/12` |
| Backdrop | `blur(32px)` |
| 트랜지션 | `motion/transition/shadow` |
| Resize | 자동 (minRows~maxRows 범위) |

---

## 상태 (State) 및 인터랙션

| 상태 | 시각 표현 | 모션 |
|---|---|---|
| Default | 기본 | — |
| Hover | 보더 한 단계 진하게 | `motion/transition/shadow` |
| Focus | 보더 `color/primary/normal` 또는 `color/line/normal/strong` | `motion/transition/shadow` |
| Disabled | 배경 `color/fill/alternative`, blur 해제 | — |
| Invalid | 보더 `color/status/negative @ 28%` | `motion/transition/colors` |

---

## 합성 슬롯
- `<TextAreaContent variant>`: custom / button / characterCounter / badge / chip / icon / icon-button
- characterCounter: 우하단 `text/caption1`, 한도 초과 시 `color/status/negative`

---

## 접근성
- `<textarea>` 시맨틱 유지. `aria-invalid`, `aria-describedby={counterId}` 자동 연결.
- `maxLength` 도달 시 스크린리더 알림 (`aria-live="polite"`).

---

## Figma Make 프롬프트
```
TextArea: TextField와 동일 외형 + 멀티라인. resize handle은 hide.
characterCounter slot 우하단 (caption1).
States: default/focus/invalid/disabled.
네이밍: TextArea / Default, TextArea / Invalid
```
