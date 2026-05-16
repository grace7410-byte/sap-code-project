# 📂 Decisions (Architecture & PM Decisions)

프로젝트 진행 중 시스템 아키텍처, 테이블 구조, 정유 도메인 비즈니스 로직 및 PM 일정 관리 차원에서 발생한 **주요 의사결정 사항(Architecture Decisions)을** 기록합니다.



## 🛠️ Development Phase Decisions (개발 단계)
> 본격적인 ABAP/Fiori 구현, UI/UX 표준화, 데이터 스케일 최적화 및 평가 피드백 반영 사항입니다.

### 📌 [DR-005] 1st Midterm Evaluation 피드백 반영 및 파생 개발 가동 (2026-05-08)
- **결정 사항**: 평가위원 피드백(Validation Check 강화, 메시지 가독성 개선) 수령 즉시 반영 및 후속 프로그램 3개 이상 빌드업 주말 마감.
- **PM 영향**: 5/22(금) 통합 시나리오 프로그램 개발 전면 마감(Freeze) 및 5/25(월) 전사 데이터 적재 개시 일정 확정.
- **상세 보기**: [Decision 문서 링크](2026-05-08-midterm-feedback-milestone.md)

### 📌 [DR-004] MM-LE 인터페이스 최적화를 위한 구매오더 구조 전면 리팩토링 (2026-04-30)
- **결정 사항**: LE 모듈의 부분 운송 프로세스를 수용하기 위해 구매오더 헤더의 `POSTAT` 필드를 삭제하고, 아이템 단위 상태 관리로 전환 후 CDS 뷰 재설계.
- **도메인 로직**: 고유가 시황 마진 왜곡 방지를 위해 MM 원유 도입가를 75~85 USD 선으로 고정 설계 전환, SD 모듈 일자별 MOPS 실가격 매핑.
- **상세 보기**: [Decision 문서 링크](2026-04-30-crude-price-po-status.md)

### 📌 [DR-003] 1st 중간평가 대상 핵심 프로그램 스펙 Freeze (2026-04-24)
- **결정 사항**: 모듈별 조회 1개, 트랜잭션 1개를 1차 중간평가 대상 후보군으로 최종 필터링 및 리스크 점검 완료.
- **상세 보기**: [Decision 문서 링크](2026-04-24-midterm-schedule-and-spec-scope-fix.md)

### 📌 [DR-002] UI/UX 표준화 및 개발 우선순위 조정 (2026-04-16)
- **결정 사항**: 전사 공통 UI/UX 표준(초록/노란 하이라이트, Read-Only, SH 필수) 수립 및 5/4 시연 대비 Happy Path 위주 개발 전환.
- **상세 보기**: [Decision 문서 링크](2026-04-16-ui-ux-standardization-and-priority-realignment.md)

### 📌 [DR-001] 전사 통합 데이터 스케일 및 물량 기준 확정 (2026-04-08)
- **결정 사항**: 구매(격주 40만 bbl), 생산(일 2만 bbl) 등 모듈 간 데이터 단절 방지를 위한 수량 기준 통일 및 손익 추적 최적화를 위한 금액 규모 하향 조정.
- **상세 보기**: [Decision 문서 링크](2026-04-08-data-scale-optimization-and-dev-transition.md)

---

## 📐 Design Phase Decisions (기획 및 아키텍처 설계 단계)
> 비즈니스 모델(BM) 수립, 정유 프로세스 정립, 모듈 간 E2E 데이터 인터페이스 설계 사항입니다.

### 📌 Technical Ground Rules & E2E Process Integration (2026-04-03)
- **결정 사항**: CDS View 선행 설계, Fiori 핵심 요건(Popup, SH, Chart 등) 정의 및 수요 예측(FC)-생산(PIR)-물류-회계 연계 인터페이스 확정.
- **상세 보기**: [Decision 문서 링크](2026-04-03-technical-rule-and-e2e-integration.md)

### 📌 Portfolio-Oriented Design & Domain Logic Enhancement (2026-04-02)
- **결정 사항**: 모듈별 고유 페인포인트(SD 마진율 레포트, MM 증발 로스 551 전표, PP 수율 BOM 및 1/N 배분) 로직 반영 및 ABAP-Fiori 역할 분담 확정.
- **상세 보기**: [Decision 문서 링크](2026-04-02-portfolio-oriented-design.md)

### 📌 Import Process & Production Variance Logic (2026-04-01)
- **결정 사항**: 선적 입고 물량 기반 송장 검증(IV) 정산 및 생산 오더(예측 값)와 자재 이동(실적 값) 매핑을 통한 CO 수율/원가 차이 도출 연동.
- **상세 보기**: [Decision 문서 링크](2026-04-01-import-and-production-logic.md)

### 📌 Integrated Data Mapping & Product Costing Logic (2026-03-31)
- **결정 사항**: 수입 대금 이원화(1 PO - 2 Invoice) 전표 발행 구조 수립, MARD 테이블 기반 15℃ 환산 부피 판매 단위 적용, 공정별 가동 단가 실제 원가 반영.
- **상세 보기**: [Decision 문서 링크](2026-03-31-integrated-data-mapping-and-costing-logic.md)

### 📌 Refinery-Specific Process & Module R&R Integration (2026-03-30)
- **결정 사항**: 수입 경로 통합 및 선적 로스 계정 처리, 실제 원가 추적 기반 기말 수량 비율 배분 로직 채택, PP(실행)-CO(분석) 역할 명확화.
- **상세 보기**: [Decision 문서 링크](2026-03-30-refinery-specific-process-integration.md)

### 📌 Dynamic Production Planning & Facilities Logic (2026-03-27)
- **결정 사항**: 설비 고장 시 가동 가능 설비로 물량을 배분하는 1/N 로직(CRHS/CRHI) 적용 및 MOPS 가격 기반 PIR 자동 조정 로직 수립.
- **상세 보기**: [Decision 문서 링크](2026-03-27-dynamic-production-logic.md)

### 📌 Process Simplification & FI-MM Integration (2026-03-26)
- **결정 사항**: 자재 마스터 과부하 방지를 위한 전체 공정의 1차(상압)/2차(고도화) 그룹화 및 T030 기반 실시간 FI-MM 자동 전표 연동 구현.
- **상세 보기**: [Decision 문서 링크](2026-03-26-process-simplification.md)

### 📌 Inventory Movement & Conversion Logic (2026-03-25)
- **결정 사항**: MM/PP/SD 공통의 재고 이동 H-I 테이블 설계 및 모든 시스템 내 재고의 '15℃ 환산량' 관리 원칙 수립 (실측 데이터 별도 보존).
- **상세 보기**: [Decision 문서 링크](2026-03-25-inventory-integration.md)

### 📌 Cost Accounting & Finance Base Structure (2026-03-24)
- **결정 사항**: 부대비용을 포함한 원유 도입 원가 자산화, 공정 복잡도에 따른 제품별 가공 원가 가중치 차등 부여 및 K4 Variant/통합 BP 구조 확정.
- **상세 보기**: [Decision 문서 링크](2026-03-24-cost-and-finance-base.md)

### 📌 Process Redesign & Inventory Logic (2026-03-23)
- **결정 사항**: MTS 기반 계절 수요 예측 생산 모델 전환, 물류센터 거점 추가를 통한 재고 이동 로직 도입 및 복잡한 해징(Hedging) 프로세스 삭제.
- **상세 보기**: [Decision 문서 링크](2026-03-23-process-pivot.md)

### 📌 System Architecture & Core Logic (2026-03-19)
- **결정 사항**: FI 선행 정의 후 MM/SD 확장 구조의 BP 설계, 실무 단위(BBL)-시스템 단위 변환 테이블 구축 및 공정별 Cost Center 세분화.
- **상세 보기**: [Decision 문서 링크](2026-03-19-system-architecture.md)

### 📌 C-nergy Project Key-Point & WBS (2026-03-18)
- **결정 사항**: 정유 도메인 4대 가치(의사결정 보조, 수익성 분석, 실손실 추적, 환리스크) 정의, 전체 WBS 일정 마감 조율 및 CL 리더십 구조 도입.
- **상세 보기**: [Decision 문서 링크](2026-03-18-key-points-wbs.md)

### 📌 Business Model & Master Data (2026-03-17)
- **결정 사항**: 연 매출 5,000억 중견 정유사 'C-nergy' 포지셔닝, 원유 3종/제품 6종 마스터 및 공정별 사용 촉매 조건 가이드 수립.
- **상세 보기**: [Decision 문서 링크](2026-03-17-biz-model-final.md)

### 📌 Project Topic Decision - 2nd (2026-03-16)
- **결정 사항**: 연속 공정 및 연산품 수율 구조의 특성을 가진 '정유 산업' 최종 선정 및 사명 'C-nergy(Code+Energy+Synergy)' 확정.
- **상세 보기**: [Decision 문서 링크](2026-03-16-project-topic.md)

### 📌 Project Topic Decision - 1st (2026-03-13)
- **결정 사항**: ERP 모듈 간 밀접한 E2E 통합 프로세스 설계 및 CBO 확장 개발 가능성이 높은 '석유 정제 및 제조 기업'을 1차 주제 후보로 선정.
- **상세 보기**: [Decision 문서 링크](2026-03-13-project-topic.md)
