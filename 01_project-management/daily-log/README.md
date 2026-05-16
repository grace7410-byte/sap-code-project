
##  Development Phase Logs (04.04 ~ 05.08)

2주간의 설계 검토를 마치고 본격적인 ABAP/Fiori 개발 단계로 진입하였습니다.

###  Week 1: Development Kick-off (04.06 ~ 04.10)
- **Status:** 전 모듈 CBO 테이블 생성 및 CDS View 기초 설계 완료.
- **Milestone:** 04.08 전체 개발 착수 회의를 통해 모듈별 인터페이스 필드 확정.
- **Log:** 개인별 개발 일지(04.10)를 통해 초기 환경 세팅 및 CUD 로직 구현 기록.

###  Week 2: Logic Implementation & Mentoring (04.13 ~ 04.18)
- **Status:** 핵심 프로그램 1차 완성(MM PO, SD 주문관리, PP Routing, FI 전표조회).
- **Mentoring (04.16):** 강사님 미팅을 통해 모듈 통합(Integration) 로직 교정 및 UI 가독성 개선 가이드 수립.
- **Integration:** 물류-회계 연동(MM-FI, SD-FI)을 위한 BAPI/Function Interface 설계 착수.
- **Log:** 주간 개발 진척도 업데이트 및 개인별 트러블슈팅 기록(04.17).

###  Week 3: Core Optimization & Integration (04.20 ~ 04.24)
- **Status:** 모듈별 조회성/트랜잭션 프로그램 기능 고도화 및 데이터 동기화.
- **Integration:** 정유 도메인 특화 로직(부피 환산 및 온도 보정 알고리즘)의 백엔드 기능 반영 및 모듈 간 데이터 흐름 검증.
- **Log:** 1차 중간평가 대상 프로그램 선정을 위한 모듈별 자체 진척도 필터링 및 리스크 점검.

###  Week 4: Architecture Refactoring & Deliverables (04.27 ~ 05.01)
- **Status:** 1차 평가 대상 프로그램(조회성 1, 트랜잭션 1) 마감 및 필수 산출물 제출 완료.
- **Refactoring (04.30):** SD 모듈의 오피넷 싱가포르 국제 제품가(MOPS) 일자별 변동 실가격 반영 및 6개 유종 매핑 기준 확정. 고유가 시황에 따른 CO 마진 왜곡을 방지하기 위해 MM 모듈의 원유 도입가를 기존 75~85 USD 선으로 고정 설계 전환. LE 모듈의 아이템 단위 부분 운송 프로세스를 수용하기 위해 구매오더 헤더의 `POSTAT` 필드를 삭제하고 아이템 기준으로 단일화하는 DB/CDS View 전면 리팩토링 단행.
- **Deliverables:** 테이블 정의서 최종 업데이트, 개별 프로그램 스펙서 및 전체 개발 프로그램 리스트 최종 취합본 제출 완료.

###  Week 5: 1st Midterm Evaluation & Milestone Reset (05.04 ~ 05.08)
- **Status:** 아카데미 일정에 따른 단기 휴무(5/5~5/6) 반영 및 1차 중간평가 개별 수행 완료.
- **Evaluation (05.07):** 구현 완료된 핵심 프로그램(조회 1, 트랜잭션 1)에 대한 사내강사 및 평가위원 1:1 대면 평가 진행 및 UI/UX 편의성, 유효성 검증(Validation Check) 보완 피드백 수령.
- **Milestone (05.08):** 평가 주간 가이드에 따라 개발일지 제출을 차주로 이행. 평가 피드백을 반영한 프로그램 복사/파생 개발 착수(진척률 50%). PM-팀원 간 조율을 통해 **5/22(금) 통합 시나리오 프로그램 전면 마감(Freeze)** 및 **5/25(월) 전사 통합 데이터 적재 개시**로 향후 타임라인 최종 재정렬.
