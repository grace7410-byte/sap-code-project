# Module Integration & Inventory Architecture Meeting

## Date
2026-03-25

## Participants
PM, PL, CL, Team Members (Total 7)

## Agenda
모듈별 테이블 정의서 공유 및 통합 재고 관리 로직 확정

---

## Key Discussion

### 1. Module Interface & Table Sharing
- SD, PP, MM 담당자가 작성 중인 테이블 정의서(40% 수준)를 공유하고 상호 연계 지점 확인.
- 개별 모듈의 출하/입고 정보를 통합 재고 이동 테이블로 단일화하여 관리 효율성 극대화.
- 상세 실측 정보는 기존 출고 H-I 테이블을 보완하여 연결 구조 설계.

### 2. Standardized Inventory Measurement
- 실제 SLoc에 반영되는 모든 수량 지표를 '보정된 환산량'으로 표준화.
- 실측 기록을 위한 별도 부피 측정 테이블의 스키마 정의 (부피, 온도, 밀도 필드 포함).
- 환산량만 관리할 경우 발생할 수 있는 데이터 누락 문제를 방지하기 위한 이중 기록 구조 확정.

### 3. Logistics & Service Process
- 공장 → 물류센터(DC) 이동 시 출고와 입고가 동시에 반영되는 프로세스 상세화.
- 물류센터 → 고객 구간은 외부 위탁 운송으로 간주, 서비스 PO(SES 기반) 프로세스 적용 (판매가 미포함).

---

## Conclusion
모듈별로 파편화되어 있던 재고 이동 구조를 통합하고, 환산량 기준의 재고 관리 원칙을 수립하여 시스템 전체의 데이터 정합성을 확보함.

---

## Next Action
- 모듈별 테이블 정의서 상세 설계 및 최종 취합 진행.
- PP 모듈: 21가지 이상의 연산품 발생 시 효율적인 자재 코드 관리 방안 도출.
