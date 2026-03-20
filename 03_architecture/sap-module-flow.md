# SAP Integrated Module Flow (To-Be)

Date: 2026-03-18 ~ 2026-03-20

## 1. 개요
C-nergy 프로젝트의 핵심인 '수요 기반 최적 수율 생산' 로직을 구현하기 위한 모듈 간 통합 데이터 흐름도입니다.

## 2. 모듈 간 연결 구조 (The Synergy Integration)

### [MM] Procurement -> [PP] Production
* **원유 도입**: MM에서 PO/GR 처리된 원유(Crude Oil) 재고 데이터가 PP의 생산 가동을 위한 가용 자재로 연동.
* **PR 자동 생성**: MRP 실행 결과에 따라 부족한 원재료에 대한 구매요청(PR)이 MM으로 전달.

### [SD] Sales -> [PP] Production (CBO Trigger)
* **생산 요청 트리거**: SD의 출고(PGI) 시점에 재고가 안전 재고 이하로 하락할 경우, 생산팀으로 즉시 '생산 요청 알림' 데이터 전송. (Standard MRP 외 커스텀 인터페이스)

### [FI/CO] Finance -> [PP] Production (Yield Optimization)
* **시황 데이터 연동**: 외부 싱가포르 시황 정보가 FI/CO를 통해 시스템에 반영되면, 최적 마진을 계산하여 PP의 후공정 레시피(Recipe) 선택 로직에 영향.

### [PP/SD] Logistics -> [FI/CO] Finance
* **자동 전표 생성**: 출고(PGI), 생산 입고(GR), 대금 청구(Billing) 시점에 OBYC/VKOA 설정을 통해 실시간 회계 전표 및 원가 데이터가 FI/CO로 전송.

---

## 3. 데이터 흐름 요약 (Step-by-Step)

| 단계 | 발생 모듈 | 전송 데이터 | 수신 모듈 | 연동 방식 |
| :--- | :--- | :--- | :--- | :--- |
| **판매/출고** | SD | 출고 수량 및 재고 변동 | PP | Trigger 로직 |
| **생산 요청** | PP | 생산 오더 및 투입 원재료 | MM | MRP/Reservation |
| **원가 정산** | PP/MM | 실제 발생 비용 (에너지/촉매) | CO | Actual Costing |
| **수익 인식** | SD | 매출액 및 운송비 | FI | Billing Interface |
| **시황 반영** | FI/CO | 제품별 기대 마진/임계점 | PP | Recipe Optimizer |
