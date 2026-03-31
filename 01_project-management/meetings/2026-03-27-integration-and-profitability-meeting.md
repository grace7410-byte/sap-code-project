# Integration and Profitability-based Production Meeting

## Date
2026-03-27

## Participants
PM, PL, CL, Team Members (Total 7)

## Agenda
전 모듈 테이블 최종 취합 및 수익성 기반 생산 계획 로직 확정

---

## Key Discussion

### 1. Module Integration & Data Consistency
- MM, SD, PP 모듈 간 중복 필드를 제거한 통합 테이블 리스트를 확정하고 SCM 통합 완료.
- SD의 대금 청구 필드와 FI 전표 필드 간의 최종 매핑 상태를 확인하여 전표 생성 자동화 기반 마련.
- FI-CO 인터페이스의 경우, 보다 정밀한 필드 단위 조율이 필요함을 확인하여 보완 작업 지시.

### 2. Profitability-Driven Production Logic (CO-PP)
- MOPS 가격 연동을 통한 수익성 분석 시나리오를 위해 ZCO_PROCESS_SCENARIO 테이블 11개 정의 완료.
- 시장가 변동에 따라 제품 생산 오더 수량을 동적으로 조정하는 원가 환류 체계의 구동 방식 확정.

### 3. Facility Failure Response (PP-PM)
- 특정 작업장(Work Center) 장애 발생 시 작업 물량을 타 설비로 배분하는 시뮬레이션 로직 검토.
- 가동률과 상태값을 실시간으로 반영하기 위한 테이블 구조 및 필드 설계 승인.

---

## Conclusion
설비 가동 상태와 시장 가격 변동을 시스템이 인지하여 생산과 원가에 즉각 반영하는 통합 구조를 완성하고, 전 모듈의 데이터 시트를 최종 승인함.

---

## Next Action
- 모듈별 테이블 정의서 최종 보완 및 문서화 완료.
- 필드 단위 조율이 필요한 FI-CO 인터페이스 상세 매핑 마무리.
