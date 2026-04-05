# Integrated Data Mapping & Product Costing Logic Decision

Date: 2026-03-31

## Decision

**1. MM-FI Import Accounting (1 PO - 2 Invoice)**
- 수입 시 원유 대금(Vendor)과 관세/부가세(세관) 전표를 각각 발행함.
- 동일한 구매오더(PO) 번호를 참조하되, 공급업체별 관리 투명성을 위해 송장 문서와 회계 전표를 이원화함.

**2. SD Inventory Management Strategy**
- 일자별/거점별 온도 보정 계수 테이블을 미사용함. 
- 대신 저장위치 테이블(`MARD`)에 관리되는 '15℃ 환산 부피'를 판매 단위로 그대로 사용하여 프로세스를 간소화함.

**3. PP-CO Costing Calculation Formula**
- 제품 원가 = [1차 공정 표준비 + 간접비] + [제품별 선택적 2차 공정비(FCC, 탈황 등)].
- BOM 구조와 수율 데이터를 일치시켜 공정별 가동 단가를 실제 원가 테이블(`ZTB1CO0011`)에 자동 반영함.

## Reason
- 수입 거래 시 실제 대금 지급 대상이 다수(해외 공급사, 국내 세관)인 실무 요건을 충구히 반영하기 위함임.
- 복잡한 온도 보정 계산으로 인한 시스템 부하를 줄이고 데이터 일관성을 확보하기 위함임.
- 정유 공정의 병렬적 특성을 반영하여 제품별로 상이한 가공비를 정확히 추적하기 위함임.
