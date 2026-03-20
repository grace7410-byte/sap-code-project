# SAP Standard Practice

Date: 2026-03-20

## Purpose
모듈별(SD, PP, MM, FI) SAP Standard 트랜잭션 전 과정 실습 내용 및 주요 설정 개념 정리

---

## 1. SD (Sales & Distribution) 실습

### BP(Business Partner) 생성 및 Role 관리
* **Role 000000 (일반)**: 주소, 언어 등 기본적인 인적 사항 등록. 전표 생성이 불가능한 기초 단계.
* **Role FLCU00 (FI 고객)**: 회계 관리용 롤. 
    * [회사 코드] 탭에서 **조정 계정(14107000 - 국내 외상매출금)** 연결 필수. 
    * 해당 설정이 완료되어야 송장(Invoice) 발행 및 수금 처리가 가능함.
* **Role FLCU01 (고객-SD)**: 영업/물류 관리용 롤. 
    * 판매 조직(1010), 유통 경로(10), 제품군(00) 매핑. 
    * 출하 조건 및 지급 조건 설정을 통해 판매 오더(VA01) 생성 권한 부여.

### 주요 프로세스 및 테이블
1. **판매 오더 생성 (VA01)**: 고객의 주문 의사 등록 (Order Type: OR).
2. **출하 및 출고 (VL01N/VL02N)**: 피킹(Picking) 및 출고 전기(PGI) 수행. PGI 시점에 실물 재고 감소 및 매출원가 발생.
3. **대금 청구 (VF01)**: 세금계산서(Invoice) 발행 및 FI 모듈로 수익 데이터 전송.
4. **데이터 확인 (SE11)**:
    - VBAK/VBAP (판매 오더 헤더/아이템)
    - LIKP/LIPS (출하 헤더/아이템)
    - VBRK/VBRP (빌링 헤더/아이템)

---

## 2. PP/MM (Production & Material) 실습

### 생산 마스터 및 역BOM(Co-Product) 설정
* **CS01 (BOM)**: 원유(OIL1001) 투입 시 여러 연산품이 동시 생산되는 구조 구현. 
    - Component 항목에 원유를 입력하고, 생산될 제품(항공유 등) 수량을 **음수(-)로** 입력.
    - 품목 상세(F7)에서 **Co-Product(연산품)** 체크 필수.
* **CR01/CA01 (Work Center/Routing)**: 생산 거점 정의 및 공정 순서(기계/노동 시간) 설정.
* **CK11N/CK24 (Costing)**: 표준 원가 추정 및 단가 업데이트. 연산품 간 원가 분배 비율이 정합성을 가져야 함.

### 자재 및 구매 관리 (MM)
* **MM01 (Material Master)**: 자재 유형(FERT/ROH)별 뷰 생성. 특히 원가 및 구매 뷰 설정이 중요.
* **ME11 (PIR)**: 공급업체와 자재 간의 구매 조건(단가, 리드타임 등) 정보 레코드 생성.
* **ME21N (PO)**: 구매 오더 생성. 조직 데이터(구매조직 1010) 및 PIR 정보를 바탕으로 생성 완료.

---

## 3. FI (Finance) 연계 실습

### 자동 계정 결정 (OBYC / VKOA)
* **OBYC (Inventory)**: 자재 이동 시 발생하는 재고/원가 계정 자동 매핑 (BSX, GBB-VAY 등).
* **VKOA (Revenue)**: 빌링 시 매출 수익이 잡힐 G/L 계정(ERL) 매핑.
* **FBL5N (Customer Line Items)**: 고객별 미결 항목(Open Item) 및 반제 내역 실시간 조회.

---

## Notes
- 정유 산업 특성을 반영하여 PP-PI 기반의 연산품 구조와 SD의 출고 프로세스 연계 집중 실습.
- 모듈 간 데이터 인터페이스(OBYC, VKOA) 설정을 통해 End-to-End 흐름 검증 완료.
