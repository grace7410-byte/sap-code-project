# Features

본 프로젝트에서 구현하는 모듈별 핵심 비즈니스 로직 및 프로그램 리스트를 관리하는 폴더입니다.

## Structure
각 프로그램은 정유 산업의 End-to-End 프로세스를 구성하는 최소 기능 단위로 정의되며, 크게 **물류(MM/SD), 생산(PP), 재무/원가(FI/CO)로** 구분됩니다.

### 구현 프로그램의 특징
- **도메인 특화**: 정유 산업의 부피 측정, 증발 로스, MOPS 기반 가격 산정 로직 반영
- **기술 스택**: ABAP RAP 모델 및 Fiori Elements 기반의 UI 구현
- **연동성**: 물류 트랜잭션 발생 시 FI/CO 전표 자동 인터페이스 구현

## Contents

현재 개발 진행 중인 주요 기능 리스트는 **[feature-list.md](./feature-list.md)에서** 통합 관리하며, 상세 로직은 개별 문서로 작성됩니다. (`feature-list.md`는 v1(4/22, 초기 전체 기능 백로그)과 v2(4/29, 중간평가 기준 확정 리스트)가 한 파일에 함께 보관되어 있습니다 — v2가 최신 기준입니다.)

- **Procurement**: 구매오더, 서비스 엔트리, 선적 입고
- **Manufacturing**: 자재-공정 연결, MRP 실행, 생산 전표
- **Sales**: 주문 관리, 출고 관리, 판매 분석
- **Finance**: 전표 통합 대시보드, 모듈별 전표 연동

### 01_procurement/

- [01_service-order-creation.md](01_procurement/01_service-order-creation.md)
- [02_volume-measurement.md](01_procurement/02_volume-measurement.md)
- [03_inventory-management.md](01_procurement/03_inventory-management.md)
- [cf_service-po-spec.md](01_procurement/cf_service-po-spec.md)

### 02_manufacturing/

- [01_mrp-execution.md](02_manufacturing/01_mrp-execution.md)
- [02_production-management.md](02_manufacturing/02_production-management.md)

### 03_sales/

- [01_material-replenishment-planning.md](03_sales/01_material-replenishment-planning.md)
- [02_product-pricing.md](03_sales/02_product-pricing.md)
- [03_sales-order-creation.md](03_sales/03_sales-order-creation.md)

### 04_finance/

- [01_ap-clearing.md](04_finance/01_ap-clearing.md)
- [02_document-dashboard.md](04_finance/02_document-dashboard.md)
- [03_production-document-creation.md](04_finance/03_production-document-creation.md)
- [04_ar-clearing.md](04_finance/04_ar-clearing.md)
- [05_product-costing.md](04_finance/05_product-costing.md)
- [06_profitability-analysis.md](04_finance/06_profitability-analysis.md)

`images/` — 기능별 화면 스크린샷
