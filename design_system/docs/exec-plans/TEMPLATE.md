# Sprint Contract: [작업명 (Task Name)]

## 📅 일자: YYYY-MM-DD
## 👤 담당: [사람/에이전트 이름]
## 🏷️ 상태: [대기 | 진행중 | 완료]

---

## 🎯 목표 (What)
[해결하고자 하는 문제나 구현할 비즈니스/시스템 기능 명시]

---

## 🛠️ 구현 계획 (How)
Harness Engineering의 아키텍처 제약(P6: Layered)을 준수하며 각 레이어별 수정/생성 계획을 명시합니다.

- **Types / Config**: [데이터 모델 변경점]
- **Repo**: [데이터 접근 및 영속성 계층 변경점]
- **Service**: [비즈니스 로직 변경점]
- **Runtime**: [진입점, 라우팅 변경점]
- **UI**: [프론트엔드 뷰, 컴포넌트 추가 - Design Quality / Originality 준수]

---

## ✅ 검증 기준 (Criteria)
- [ ] 요구사항 1 기능적 동작 확인
- [ ] 아키텍처 경계(Linter) 규칙 통과 확인 (P8 Observability)
- [ ] [프론트엔드 작업인 경우] UI Design Quality & Craft 기준 만족
- [ ] 이 변경으로 인해 드리프트된 문서 업데이트 반영 (P7 Garbage Collection)
