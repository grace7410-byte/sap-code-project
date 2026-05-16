# 📂 Decisions (Architecture & PM Decisions)

프로젝트 진행 중 시스템 아키텍처, 테이블 구조, 정유 도메인 비즈니스 로직 및 PM 일정 관리 차원에서 발생한 **주요 의사결정 사항(Architecture Decisions)**을 기록합니다.

## 🎯 Key Decisions Log

### 📌 [DR-004] 1st Midterm Evaluation 피드백 반영 및 파생 개발 가동 (2026-05-08)
- **결정 사항**: 평가위원 피드백(Validation Check 강화, 메시지 가독성 개선) 수령 즉시 반영 및 후속 프로그램 3개 이상 빌드업 주말 마감.
- **PM 영향**: 5/22(금) 통합 시나리오 프로그램 개발 전면 마감(Freeze) 및 5/25(월) 전사 데이터 적재 개시 일정 확정.
- **상세 보기**: [Decision 문서 링크](2026-05-08-evaluation-feedback-milestone.md)

### 📌 [DR-003] MM-LE 인터페이스 최적화를 위한 구매오더 구조 전면 리팩토링 (2026-04-30)
- **결정 사항**: LE 모듈의 부분 운송 프로세스를 수용하기 위해 구매오더 헤더의 `POSTAT` 필드를 삭제하고, 아이템 단위 상태 관리로 전환 후 CDS 뷰 재설계.
- **도메인 로직**: 고유가 시황 마진 왜곡 방지를 위해 MM 원유 도입가를 75~85 USD 선으로 고정 설계 전환, SD 모듈 일자별 MOPS 실가격 매핑.
- **상세 보기**: [Decision 문서 링크](2026-04-30-mops-le-architecture.md)

### 📌 [DR-002] 1st 중간평가 대상 핵심 프로그램 스펙 Freeze (2026-04-24)
- **결정 사항**: 모듈별 조회 1개, 트랜잭션 1개를 1차 중간평가 대상 후보군으로 최종 필터링 및 리스크 점검 완료.
- **상세 보기**: [Decision 문서 링크](2026-04-24-midterm-target-freeze.md)

### 📌 [DR-001] 통합 시나리오 연계 로직 수립 및 BAPI/Function Interface 설계 (2026-04-16)
- **결정 사항**: 강사 멘토링 결과를 바탕으로 물류-회계 연동(MM-FI, SD-FI)을 위한 동적 데이터 전달 흐름 기술 표준 정의.
- **상세 보기**: [Decision 문서 링크](2026-04-16-integration-bapi-design.md)
