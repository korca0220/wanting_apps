# 파운데이션: 접근성 (Accessibility)

## 개요
컴포넌트 명세는 **framework-neutral**이고, 접근성도 ARIA 용어로 적혀 있는 경우가 많습니다 (`role="button"`, `aria-disabled`, `aria-label`). Flutter 구현(`packages/design_system/lib/`)에서는 `Semantics` 위젯과 위젯의 표준 매개변수로 동일 의미를 표현합니다. 본 문서는 그 매핑 규칙을 1차 출처로 정의합니다.

---

## 🏗️ 하네스 설계 원칙

> **Harness Principle:** 컴포넌트 .md의 접근성 절은 ARIA 용어를 유지합니다 (다른 프레임워크 포팅에 재사용). Flutter 구현 시 **본 문서의 매핑 표를 거쳐** 동등 처리해야 합니다.

---

## ARIA → Flutter 매핑

| ARIA / 웹 | Flutter |
|---|---|
| `role="button"` (비-`<button>` 트리거) | `Semantics(button: true, child: ...)` |
| `<button disabled>` / `aria-disabled="true"` | `onPressed: null` (Material) 또는 `Semantics(enabled: false)` |
| `aria-label="…"` | `Semantics(label: '…')` |
| `aria-labelledby` | 부모 `Semantics`로 묶기 + label 직접 전달 |
| `aria-describedby` | `Semantics(value: '…')` 또는 `tooltip` |
| `aria-pressed` (toggle) | `Semantics(toggled: bool)` |
| `aria-expanded` | `Semantics(expanded: bool)` |
| `aria-checked` | `Semantics(checked: bool)` (또는 `Checkbox`/`Switch` 자체) |
| `aria-live="polite"` | `SemanticsService.announce(msg, dir)` |
| Focus visible (WCAG 2.4.7) | `Focus`/`FocusNode` + `WidgetState.focused` 분기 |
| 키보드 Enter/Space | Material 위젯 자동 처리. 커스텀 위젯은 `Shortcuts`+`Actions` |
| Focus trap (Modal) | `FocusScope` + `autofocus`, `showDialog`가 자동 처리 |
| Esc to dismiss | `Shortcuts({SingleActivator(LogicalKeyboardKey.escape): DismissIntent()})` |
| Scroll lock (Modal) | `showDialog`/`showModalBottomSheet`가 자동 처리 |
| Touch target ≥ 44×44 | `MaterialTapTargetSize.padded`(기본) 또는 `Padding` 보장 |

---

## 명세 작성 규칙

1. **컴포넌트 .md의 접근성 절은 그대로 ARIA로 유지.** 다른 프레임워크 포팅에서도 재사용 가능.
2. **Flutter 구현이 위 매핑을 벗어나야 한다면**, 컴포넌트 .md에 `## Accessibility (Flutter notes)` 절을 추가해 차이를 명시.
3. **`Semantics` 위젯 사용은 명시적 의미 부여가 필요할 때만.** Material/Cupertino 표준 위젯은 자체적으로 적절한 시맨틱을 제공하므로 중복 래핑 금지.
4. **다이내믹 콘텐츠 변화** (예: 폼 검증 메시지 등장)는 `SemanticsService.announce`로 알림.

---

## 검증

- 위젯 테스트: `expect(tester.getSemantics(...), matchesSemantics(...))`로 의미 트리 검증 (필요한 컴포넌트에 한해).
- 수동 검증: iOS VoiceOver / Android TalkBack로 example/ 쇼케이스를 한 번 통과.
