# Module Integration Data Verification Meeting

## Date
2026-03-31

## Participants
PM, PL, CL, Team Members (Total 7)

## Agenda
- 모듈 통합 테이블(FI 전표 중심) 데이터 매핑 및 정합성 검증
- 수입 물류 1오더-2송장 프로세스 확정
- 제품별 공정 수율 및 원가 산출 산식 검토
- 재공품(WIP) 회계 처리 방식 논의

## Key Discussion

### 1. FI-Centric Data Mapping Analysis
- 입고(GR), 생산 오더 확정, 매출 발생 시 각각의 데이터가 `BSEG` 테이블에 어떻게 매핑되는지 전수 검토함.
- 원가 추적성을 위해 구매/생산/판매 오더 번호가 전표 아이템 레벨에서 정확히 연동되어야 함을 확인함.

### 2. SD/MM Logistics Process Refinement
- 원유 구매 시 API 기반 환율 적용 로직과 세금 코드 참조를 통한 세관 송장 자동 생성 트리거를 정의함.
- SD 부피 보정 제외에 따른 가용 재고 점검(ATP) 로직의 단순화 방안을 확정함.

### 3. WIP & Manufacturing Cost Issue
- 생산 투입(261)과 입고(101) 사이의 재공품 계정 반영에 대해 FI와 물류 모듈 간 이견이 발생함.
- 이동 유형 매핑 테이블(`T030`)을 통한 자동 계정 결정 방식과 실시간 자산 전표 발행의 장단점을 비교 분석함.

---
## Conclusion
- 주요 프로세스에 대한 예시 데이터 매핑을 통해 설계 정합성을 입증하였으며, 재공품 처리 방식을 제외한 대부분의 로직을 확정함.

---

## Next Action
- FI-MM-PP 재공품 처리 방식 타협안 도출 (4/1 오전).
- 확정된 테이블 구조를 기반으로 한 상세 ERD 시각화 및 개발 명세서 작성 시작.
- CO 활동 단가 테이블(`ZTB1CO0014`) 내 실제 운영 수치 최종 보정.
