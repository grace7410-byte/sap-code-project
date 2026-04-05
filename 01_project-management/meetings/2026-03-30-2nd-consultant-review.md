# 2nd Consultant Review & Process Optimization Meeting

## Date
2026-03-30

## Participants
PM, PL, CL, Team Members (Total 7)

## Agenda
- SD/MM/PP 프로세스 현실성 및 석유 산업 특화 로직 검토
- FI/CO 원가 및 전표 구조 고도화
- 모듈 간 R&R 및 데이터 연동 상세 설계

## Key Discussion

### 1. SD/MM/PP Logistics Feasibility
- 복잡한 여신 관리 대신 판가 승인 및 고액 오더 결재 위주로 간소화 권고.
- 온도/부피 보정(Net 단위) 처리를 위한 인바운드 딜리버리 필드 확장.

### 2. FI/CO Costing & Document Structure
- FI 테이블 내 원가 집계 필드를 활용한 심플한 데이터 구조 제안.
- 부분 반제 추적을 위한 헤더/아이템 테이블 분리 설계 확정.

### 3. Production Monitoring R&R
- CO에서 관리하던 공정 실적 데이터를 PP로 이관하여 실제 수율 데이터와의 정합성 강화.

---
## Conclusion
- 물류 프로세스 단일화 및 Bottom-up 원가 산출 로직을 최종 채택하여 시스템 설계의 불확실성을 제거함.

---

## Next Action
- 수정된 수입/생산 로직 기반 통합 Flow Map 보정.
- 모듈별 DB ERD(FI 반제, SD 여신 필드 등) 최종 모델링 반영.
