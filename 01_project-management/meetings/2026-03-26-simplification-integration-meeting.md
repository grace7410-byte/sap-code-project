# Process Simplification & FI-MM Auto-Posting Meeting

## Date
2026-03-26

## Participants
PM, PL, CL, Team Members (Total 7)

## Agenda
생산 공정 단순화 전략 수립 및 물류-회계 자동 연동(T030) 설계

---

## Key Discussion

### 1. Production Process Simplification
- 복잡한 정유 공정을 상압(CDU)과 고도화(FCC 등) 공정 두 그룹으로 단순화하여 시스템 구현 난이도 조정.
- 단순화된 공정에 맞춰 BOM(STKO/PO) 및 공정(PLKO/PO) 테이블 구조 조정안 검토.
- 공정 단순화에 따른 원가 중심점(Cost Center) 재배치 및 가중치 적용 방식 확인.

### 2. FI-MM Interface Design (T030)
- 자재 유형별 평가 클래스 정의 및 계정 매핑 데이터 초안 작성.
- 이동유형(T156) 발생 시 실시간으로 G/L 계정이 호출되어 자동 전표가 생성되는 규칙 확정.
- 운송비 등 부대비용 관리를 위한 EKKO/EKPO 기반 서비스 입고 로직 상세화.

### 3. Material Code Management Strategy
- 제품별 수십 개의 하위 코드를 운영할 경우 발생하는 영업 및 재고 관리의 비효율성 논의.
- 전략적 판단 하에 핵심 제품군 중심으로 자재 코드를 통합하여 오더 입력 프로세스 간소화.

---

## Conclusion
완벽한 공정 상세화보다는 '작동 가능한 시스템'을 구축하기 위해 공정을 단순화하고, 회계와의 실시간 연결(FI-MM)을 위한 자동 매핑 구조를 완성함.

---

## Next Action
- 모듈별 테이블 정의서 상세 설계 고도화 및 최종 취합.
- 확정된 T030 매핑 데이터를 바탕으로 모의 전표 테스트 시나리오 준비.
