# [Design] FI (재무 회계) 모듈 테이블 명세서

**최종 수정일**: 2026-07-01  
* **작성자:** 이상윤, 정나연
**상태**: 확정 (Approved)  
**버전**: v1.0

> 💡 **문서 연결 가이드**: 타 문서에서 특정 테이블로 링크를 걸 때는 본 파일 경로 뒤에 `#테이블명` 앵커를 사용  
> *예시: `[결산 테이블 스펙](04_design/04_fi_table_spec.md#ztb1fi0011)`*

---

## 테이블 목차 (Index)

| 순번 | 테이블명 | 설명 | 테이블 유형 |
| :--- | :--- | :--- | :--- |
| 1 | `ZTBF10001` | 회계 전표의 헤더 데이터를 저장하고, 전표 구분, 회계연도, 전기일자 등 기본 정보를 관리하기 위한 트랜잭션 테이블 | 트랜잭션 테이블 |
| 2 | `ZTBF10002` | 회계 전표의 개별 항목(라인 아이템) 데이터를 저장하고, 계정과목, 금액, 품목 등 세부 회계 내역을 관리하기 위한 트랜잭션 테이블 | 트랜잭션 테이블 |
| 3 | `ZTBF10003` | 회계 전표를 종류별로 구분하고 처리 규칙을 정의하기 위한 마스터 테이블 | 마스터 테이블 |
| 4 | `ZTBF10004` | 당사가 가지고 있는 회사 정보를 관리하기 위한 마스터 테이블 | 마스터 테이블 |
| 5 | `ZTBF10005` | G/L 마스터 테이블 | 마스터 테이블 |
| 6 | `ZTBF10006` | 회계연도를 월 및 개별 기간으로 나누지 및 달력연도 여부를 정의 (Fiscal Year Variant) | 설정 테이블 (Customizing Table) |
| 7 | `ZTBF10007` | 환율을 관리하는 용도 | 마스터 테이블 |
| 8 | `ZTBF10008` | 통화를 관리하는 용도 | 마스터 테이블 |
| 9 | `ZTBF10009` | MOPS를 관리하는 용도 | 마스터 테이블 |
| 10 | `ZTBF10010` | 반제 / 미반제를 관리하는 용도 | 테이블 |

---

## 1. ZTBF10001 (전표 헤더 테이블) <a id="ztb1fi0001"></a>

* **테이블명:** ZTBF10001
* **설명:** 회계 전표의 헤더 데이터를 저장하고, 전표 구분, 회계연도, 전기일자 등 기본 정보를 관리하기 위한 트랜잭션 테이블

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 |  |
| 2 | BUKRS | X | 회사 코드 | ZEBs1_FI_BUKRS | ZDB1_FI_BUKRS | CHAR | 4 | 1000 본사<br>2000 지사 |
| 3 | GJAHR | X | 회계 연도 | ZEBs1_FI_GJAHR | ZDB1_FI_GJAHR | NUMC | 4 | 2025 회계연도<br>2026 회계연도<br>(YYYY) |
| 4 | BELNR | X | 회계 전표 번호 | ZEBs1_FI_BELNR | ZDB1_FI_BELNR | CHAR | 10 | ex) 1000000001 |
| 5 | BLART |  | 회계 전표 유형 | ZEBs1_FI_BLART | ZDB1_FI_BLART | CHAR | 2 | 일반전표 : SA, 전기수정전표 : AB<br>매입(AP)전표 : KR, 지급전표 : KZ<br>매출(AR)전표 : DR, 입금전표 : DZ<br>생산(입고) : WE, 입고 : WA, 출고 : WL |
| 6 | BLDAT |  | 증빙일 | ZEBs1_FI_BLDAT | ZDB1_FI_BLDAT | DATS | 8 | 실제 영수증, 세금계산서, 계약서 등에 발행된 날짜 YYYYMMDD |
| 7 | BUDAT |  | 전표 전기일 | ZEBs1_FI_BUDAT | ZDB1_FI_BUDAT | DATS | 8 | 회계 장부(전표)에 공식적으로 기록되는 날짜 YYYYMMDD |
| 8 | MONAT |  | 전기기간 | ZEBs1_FI_MONAT | ZDB1_FI_MONAT | NUMC | 3 | 월 : 001~016<br>001 1월<br>002 2월<br>003 3월<br>004 4월<br>005 5월<br>006 6월 |
| 9 | BKPF_TXT |  | 헤더 텍스트 | ZEBs1_FI_BKPF_TXT | ZDB1_FI_BKPF_TXT | CHAR | 50 | (자유 입력, 최대 50자)ex) 3월 원자재 매입 |
| 10 | WAERS |  | 거래 통화 | ZEBs1_FI_WAERS | ZDB1_FI_WAERS | CUKY | 5 | 실제 송장에 적힌 통화 (국내 : KRW, 국외 : USD) |
| 11 | HWAER2 |  | 기능 통화 | ZEBs1_FI_HWAER2 | ZDB1_FI_HWAER2 | CUKY | 5 | KRW(회계 장부를 기록하고 성과 측정시 적용) |
| 12 | ZAWTYP |  | 참조타입 | ZEBs1_FI_ZAWTYP | ZDB1_FI_ZAWTYP | CHAR | 10 | '제어플래그'이 아니라 "업무 코드"로 설계 ex) ZSD_BILL |
| 13 | ZAWKEY |  | 참조문서번호(FI) | ZEBs1_FI_ZAWKEY | ZDB1_FI_ZAWKEY | CHAR | 10 | 여러 문서들의 번호가 온다. (추측됨) |
| 14 | STBLG |  | 역분개 전표번호 | ZEBs1_FI_STBLG | ZDB1_FI_STBLG | CHAR | 10 | (10자리 숫자) |
| 15 | STJAH |  | 역분개 회계 연도 | ZEBs1_FI_STJAH | ZDB1_FI_STJAH | NUMC | 4 | 2025 회계연도<br>2026 회계연도 |
| 16 | RESLPDAT |  | 역분개일자 | ZEBs1_FI_RESLPDAT | ZDB1_FI_RESLPDAT | DATS | 8 | YYYYMMDD |
| 17 | RESLPRK |  | 역분개 사유 | ZEBs1_FI_RESLPRK | ZDB1_FI_RESLPRK | CHAR | 100 | (역분개 사유, 최대 100자) |
| 18 | XREVERSAL |  | 역분개 플래그 | ZEBs1_FI_XREVERSAL | ZDB1_FI_XREVERSAL | CHAR | 1 | 전표가 역분개 전표 또는 역분개된 전표인지 지정 |
| 19 | LVORM |  | 삭제표시 | ZEBs1_FI_LVORM | ZDB1_FI_LVORM | CHAR | 1 | X |
| 20 | ERNAM |  | 작성자 | ZEBs1_FI_ERNAM | ZDB1_FI_ERNAM | CHAR | 12 | (사용자 이름(ID)) |
| 21 | ERDAT |  | 작성일 | ZEBs1_FI_ERDAT | ZDB1_FI_ERDAT | DATS | 8 | YYYYMMDD |
| 22 | ERZET |  | 생성시간 | ZEBs1_FI_ERZET | ZDB1_FI_ERZET | TIMS | 6 | HHMMSS |
| 23 | AENAM |  | 변경자 | ZEBs1_FI_AENAM | ZDB1_FI_AENAM | CHAR | 12 | (사용자 이름(ID)) |
| 24 | AEDAT |  | 변경일 | ZEBs1_FI_AEDAT | ZDB1_FI_AEDAT | DATS | 8 | YYYYMMDD |
| 25 | AEZET |  | 변경시간 | ZEBs1_FI_AEZET | ZDB1_FI_AEZET | TIMS | 6 | HHMMSS |

---

## 2. ZTBF10002 (전표 아이템 테이블) <a id="ztb1fi0002"></a>

* **테이블명:** ZTBF10002
* **설명:** 회계 전표의 개별 항목(라인 아이템) 데이터를 저장하고, 계정과목, 금액, 품목 등 세부 회계 내역을 관리하기 위한 트랜잭션 테이블

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | MANDT | X | 클라이언트 번호 | MANDT | MANDT | CLNT | 3 |  |
| 2 | BUKRS | X | 회사 코드 | ZEBs1_FI_BUKRS | ZDB1_FI_BUKRS | CHAR | 4 | 1000 본사<br>2000 지사 |
| 3 | GJAHR | X | 회계 연도 | ZEBs1_FI_GJAHR | ZDB1_FI_GJAHR | NUMC | 4 | 2025 회계연도<br>2026 회계연도<br>(YYYY) |
| 4 | BELNR | X | 회계 전표 번호 | ZEBs1_FI_BELNR | ZDB1_FI_BELNR | CHAR | 10 | 일반전표: 10, 역분개 전표: 11<br>매입전표: 20, 지급전표: 21<br>매출전표: 30, 입금전표: 31<br>생산: 40, 입고: 41, 출고: 42<br>(전표 번호와 연동 유발 자동채번 변경되도록) |
| 5 | BUZEI | X | 아이템 번호(라인번호) | ZEBs1_FI_BUZEI | ZDB1_FI_BUZEI | NUMC | 4 | 라인별 구분하는 번호 (0010, 0020...) 10단위로 데이터 수정 왜냐하면, 중간에 라인을 끼워 넣기 위해서다. |
| 6 | BSCHL |  | 전기키 | ZEBs1_FI_BSCHL | ZDB1_FI_BSCHL | NUMC | 2 | 메인 지정 설정된 전기<br>고객(D) : 01(차) / 11(대)<br>공급업체(K) : 21(차) / 31(대)<br>일반전표(S/G/L) : 40(차) / 50(대)<br>고정자산(A) : 70(차) / 75(대) |
| 7 | SAKNR |  | G/L 계정코드(계정과목, 계정내역) | ZEBs1_FI_SAKNR | ZDB1_FI_SAKNR | CHAR | 1 | 시작 번호 자산: 1, 부채: 2, 자본: 3, 수익: 4, 비용: 5 |
| 8 | KOART |  | 계정유형(계정타입) | ZEBs1_FI_KOART | ZDB1_FI_KOART | CHAR | 1 | G/L : S, 공급업체 : K, 고객 : D, 자산 : A |
| 9 | SHKZG |  | 차대변지시자 | ZEBs1_FI_SHKZG | ZDB1_FI_SHKZG | CHAR | 1 | 차변: S, 대변: H |
| 10 | HKONT |  | 총계정원장 | ZEBs1_FI_HKONT | ZDB1_FI_HKONT | CHAR | 8 | 111010 현금 (Cash) 자산 (Asset)<br>112010 보통예금 (Checking Account) 자산 (Asset)<br>211010 외상매입금 (Accounts Payable) 부채 (Liability)<br>411010 상품매출 (Sales Revenue) 수익 (Revenue)<br>511010 급여 (Salaries & Wages) 비용 (Expense)<br>811010 복리후생비 (Employee Benefits) 비용 (Expense) |
| 11 | DMBTR |  | 금액 | ZEBs1_FI_DMBTR | ZDB1_FI_DMBTR | CURR | 15.2 | 외화 금액 |
| 12 | UKURS |  | 환율값 | ZEBs1_FI_UKURS | ZDB1_FI_UKURS | DEC | 9(Dec.5) | 환율 값 |
| 13 | WRBTR |  | 거래금액 | ZEBs1_FI_WRBTR | ZDB1_FI_WRBTR | CURR | 15.2 | 원화 금액 |
| 14 | SGTXT |  | 적요내역 | ZEBs1_FI_SGTXT | ZDB1_FI_SGTXT | CHAR | 50 | (사용자 입력 텍스트 (최대 50자)) |
| 15 | KUNNR |  | 고객 | ZEBs1_FI_KUNNR | ZDB1_FI_KUNNR | CHAR | 10 | 거래처 식별(고객) |
| 16 | LIFNR |  | 공급업체 | ZEBs1_FI_LIFNR | ZDB1_FI_LIFNR | CHAR | 10 | 거래처 식별(공급업체) |
| 17 | ZAWKEY |  | 참조문서번호(FI) | ZEBs1_FI_ZAWKEY | ZDB1_FI_ZAWKEY | CHAR | 10 | 9가지 문서들의 번호가 온다. (확인 완료) |
| 18 | MWSKZ |  | 세금 코드 | ZEBs1_FI_MWSKZ | ZDB1_FI_MWSKZ | CHAR | 2 | AO 과세, 10% 10%<br>C0 면세<br>A1 영세율, 0% (영세) 0%<br>V0 면세 0% (매입 PO 생성시)<br>V1 (서비스 PO 생성시)<br>B1 수정부과세, 10% 10%<br>Z0 미과세 (비 매출이동) 0% |
| 19 | HWSTE |  | 세액 금액 | ZEBs1_FI_HWSTE | ZDB1_FI_HWSTE | CURR | 15.2 | (세액금액) |
| 20 | WAERS |  | 통화 | ZEBs1_FI_WAERS | ZDB1_FI_WAERS | CUKY | 5 | USD, KRW, EUR |
| 21 | MATNR |  | 자재(자산) 번호 | ZEBs1_FI_MATNR | ZDB1_FI_MATNR | CHAR | 40 |  |
| 22 | AUGBL |  | 반제 전표번호 | ZEBs1_FI_AUGBL | ZDB1_FI_AUGBL | CHAR | 10 | (전표번호 형식 (10자리 숫자), NULL = 미반제) |
| 23 | AUGBLDAT |  | 반제 일자 | ZEBs1_FI_AUGBLDAT | ZDB1_FI_AUGBLDAT | DATS | 8 | YYYYMMDD |
| 24 | VORNR |  | 생산공정번호 | ZEBs1_FI_VORNR | ZDB1_FI_VORNR | CHAR | 10 | 공정 A (1차공정) = 10... 공정 B(혼합공정) = 20 |
| 25 | MONEYDAT |  | 고객에게 입금받는 날짜 | ZEBs1_FI_MONEYDAT | ZDB1_FI_MONEYDAT | DATS | 8 | YYYYMMDD |
| 26 | CO_CENTER |  | 코스트 센터 | ZEBs1_FI_CO_CENTER | ZDB1_FI_CO_CENTER | CHAR | 10 |  |
| 27 | PROFIT_CENTER |  | 손익센터 | ZEBs1_FI_PROFIT_CENTER | ZDB1_FI_PROFIT_CENTER | CHAR | 20 |  |
| 28 | LVORM |  | 삭제표시 | ZEBs1_FI_LVORM | ZDB1_FI_LVORM | CHAR | 1 | X |
| 29 | ERNAM |  | 작성자 | ZEBs1_FI_ERNAM | ZDB1_FI_ERNAM | CHAR | 12 | (사용자 이름(ID)) |
| 30 | ERDAT |  | 작성일 | ZEBs1_FI_ERDAT | ZDB1_FI_ERDAT | DATS | 8 | YYYYMMDD |
| 31 | ERZET |  | 생성시간 | ZEBs1_FI_ERZET | ZDB1_FI_ERZET | TIMS | 6 | HHMMSS |
| 32 | AENAM |  | 변경자 | ZEBs1_FI_AENAM | ZDB1_FI_AENAM | CHAR | 12 | (사용자 이름(ID)) |
| 33 | AEDAT |  | 변경일 | ZEBs1_FI_AEDAT | ZDB1_FI_AEDAT | DATS | 8 | YYYYMMDD |
| 34 | AEZET |  | 변경시간 | ZEBs1_FI_AEZET | ZDB1_FI_AEZET | TIMS | 6 | HHMMSS |

---

## 3. ZTBF10003 (전표 유형 테이블) <a id="ztb1fi0003"></a>

* **테이블명:** ZTBF10003
* **설명:** 회계 전표를 종류별로 구분하고 처리 규칙을 정의하기 위한 마스터 테이블

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | MANDT | X | 클라이언트 번호 | MANDT | MANDT | CLNT | 3 |  |
| 2 | BLART | X | 전표유형 | ZEBs1_FI_BLART | ZDB1_FI_BLART | CHAR | 2 | SA: 총계정원장(G/L), KR: 매입송장, DR: 매출송장, RE: 송장접수(MM), KZ: 지급, DZ: 수금 |
| 3 | LTEXT |  | 전표유형 명 | ZEBs1_FI_LTEXT | ZDB1_FI_LTEXT | CHAR | 20 | G/L(SA) , 매입전표(KR) |
| 4 | NUMKR |  | 번호 범위 | ZEBs1_FI_NUMKR | ZDB1_FI_NUMKR | CHAR | 2 | SA : 01 = 10000~19999<br>KR : 02 = 20000~29999<br>DR : 03 = 30000~39999<br>RE : 04 = 40000~49999<br>KZ : 05 = 50000~59999<br>DZ : 06 = 60000~69999 |
| 5 | KOART |  | 계정 유형 허용 | ZEBs1_FI_KOART | ZDB1_FI_KOART | CHAR | 1 | S : G/L계정, D : 고객, K : 공급업체, A : 자산<br>(특정 문서유형에서 사용 가능한 계정유형을 제한하는 목적) |
| 6 | STBLA |  | 역분개 시 사용할 전표 유형 | ZEBs1_FI_STBLA | ZDB1_FI_STBLA | CHAR | 2 | SA: G/L전표, KR:매입 전표(공급업체 송장), KG:매입취소<br>DR: 매출 전표(고객 송장), DG: 매출 취소 |
| 7 | LVORM |  | 삭제표시 | ZEBs1_FI_LVORM | ZDB1_FI_LVORM | CHAR | 1 | X |
| 8 | ERNAM |  | 작성자 | ZEBs1_FI_ERNAM | ZDB1_FI_ERNAM | CHAR | 12 | (사용자 이름(ID)) |
| 9 | ERDAT |  | 작성일 | ZEBs1_FI_ERDAT | ZDB1_FI_ERDAT | DATS | 8 | YYYYMMDD |
| 10 | ERZET |  | 생성시간 | ZEBs1_FI_ERZET | ZDB1_FI_ERZET | TIMS | 6 | HHMMSS |
| 11 | AENAM |  | 변경자 | ZEBs1_FI_AENAM | ZDB1_FI_AENAM | CHAR | 12 | (사용자 이름(ID)) |
| 12 | AEDAT |  | 변경일 | ZEBs1_FI_AEDAT | ZDB1_FI_AEDAT | DATS | 8 | YYYYMMDD |
| 13 | AEZET |  | 변경시간 | ZEBs1_FI_AEZET | ZDB1_FI_AEZET | TIMS | 6 | HHMMSS |

---

## 4. ZTBF10004 (당사 정보 테이블) <a id="ztb1fi0004"></a>

* **테이블명:** ZTBF10004
* **설명:** 당사가 가지고 있는 회사 정보를 관리하기 위한 마스터 테이블

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | MANDT | X | 클라이언트 번호 | MANDT | MANDT | CLNT | 3 |  |
| 2 | BUKRS | X | 회사 코드 | ZEBs1_FI_BUKRS | ZDB1_FI_BUKRS | CHAR | 4 | 1000 본사<br>2000 지사 |
| 3 | BUTXT |  | 회사 명칭 | ZEBs1_FI_BUTXT | ZDB1_FI_BUTXT | CHAR | 25 | (주) C-NERGY |
| 4 | LAND1 |  | 국가코드 | ZEBs1_FI_LAND1 | ZDB1_FI_LAND1 | CHAR | 3 | KR<br>JP<br>SG |
| 5 | WAERS |  | 통화 | ZEBs1_FI_WAERS | ZDB1_FI_WAERS | CUKY | 5 | KRW<br>JPY<br>USD |
| 6 | STCEG |  | 사업자 등록번호 | ZEBs1_FI_STCEG | ZDB1_FI_STCEG | CHAR | 20 |  |
| 7 | ADRNR |  | 주소 | ZEBs1_FI_ADRNR | ZDB1_FI_ADRNR | CHAR | 100 |  |
| 8 | TELNO |  | 전화번호 | ZEBs1_FI_TELNO | ZDB1_FI_TELNO | CHAR | 20 |  |
| 9 | MAIL |  | 메일 | ZEBs1_FI_MAIL | ZDB1_FI_MAIL | CHAR | 50 |  |
| 10 | BANK |  | 은행 | ZEBs1_FI_BANK | ZDB1_FI_BANK | CHAR | 60 |  |
| 11 | ACCOUNT |  | 은행계좌 | ZEBs1_FI_ACCOUNT | ZDB1_FI_ACCOUNT | CHAR | 14 |  |
| 12 | LVORM |  | 삭제표시 | ZEBs1_FI_LVORM | ZDB1_FI_LVORM | CHAR | 1 | X |
| 13 | ERNAM |  | 작성자 | ZEBs1_FI_ERNAM | ZDB1_FI_ERNAM | CHAR | 12 | (사용자 이름(ID)) |
| 14 | ERDAT |  | 작성일 | ZEBs1_FI_ERDAT | ZDB1_FI_ERDAT | DATS | 8 | YYYYMMDD |
| 15 | ERZET |  | 생성시간 | ZEBs1_FI_ERZET | ZDB1_FI_ERZET | TIMS | 6 | HHMMSS |
| 16 | AENAM |  | 변경자 | ZEBs1_FI_AENAM | ZDB1_FI_AENAM | CHAR | 12 | (사용자 이름(ID)) |
| 17 | AEDAT |  | 변경일 | ZEBs1_FI_AEDAT | ZDB1_FI_AEDAT | DATS | 8 | YYYYMMDD |
| 18 | AEZET |  | 변경시간 | ZEBs1_FI_AEZET | ZDB1_FI_AEZET | TIMS | 6 | HHMMSS |

---

## 5. ZTBF10005 (GL 마스터 테이블) <a id="ztb1fi0005"></a>

* **테이블명:** ZTBF10005
* **설명:** GL 마스터 테이블

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 |  |
| 2 | BUKRS | X | 회사 코드 | ZEBs1_FI_BUKRS | ZDB1_FI_BUKRS | CHAR | 4 | 1000 본사<br>2000 지사 |
| 3 | SAKNR | X | 계정그룹코드 | ZEBs1_FI_SAKNR | ZDB1_FI_SAKNR | NUMC | 1 | 1: 자산, 2: 부채, 3: 자본, 4: 수익, 5: 비용 |
| 4 | HKONT | X | G/L 계정 번호 | ZEBs1_FI_HKONT | ZDB1_FI_HKONT | CHAR | 8 | Primary Key (아이템의 HKONT와 연결될 값인.)<br>111010 현금 (Cash) 자산 (Asset)<br>112010 보통예금 (Checking Account) 자산 (Asset)<br>211010 외상매입금 (Accounts Payable) 부채 (Liability)<br>411010 상품매출 (Sales Revenue) 수익 (Revenue)<br>511010 급여 (Salaries & Wages) 비용 (Expense)<br>811010 복리후생비 (Employee Benefits) 비용 (Expense) |
| 5 | TXT50 |  | 계정명 (한글) | ZEBs1_FI_TXT50 | ZDB1_FI_TXT50 | CHAR | 50 | 계정 설명 (표기용) |
| 6 | XINTB |  | 통합 계정 여부 | ZEBs1_FI_XINTB | ZDB1_FI_XINTB | CHAR | 1 | 보통 통합계정은 'X' [CO 연동 계정 (손익계정)], 부서별 소득 보고서나 프로젝트별 원가 보고서 등에 쓰일 예정 |
| 7 | XLOEV |  | 계정 폐기 여부 | ZEBs1_FI_XLOEV | ZDB1_FI_XLOEV | CHAR | 1 | 'X'일 경우 비활성화(사용 중지)하는 용도(SAP에서는 G/L 계정을 삭제할 수 없음. 회계는 과거 이력과 단절되면 안 되기 때문) |
| 8 | KONTS |  | 손익/대차 구분 | ZEBs1_FI_KONTS | ZDB1_FI_KONTS | CHAR | 1 | 'P' : 손익계정 / 'B' : 대차대조표 (=재무상태표). 계정이 태어날때부터 갖고있는 성격이라 g마스터테이블에 있는것임. |
| 9 | WAERS |  | 통화코드 (기본) | ZEBs1_FI_WAERS | ZDB1_FI_WAERS | CUKY | 5 | 외화 계정의 경우 필요 (계정에 항상 이전 통화만 쓰이도록 고정할지 설정하는 필드)<br>G/L 마스터의 WAERS의 값이 세팅돼 있다면, 전표 아이템의 WAERS의 값이 있다면 오류발생.<br>(SAP 오류 발생: "통화가 고정된 계정입니다") |
| 10 | GL_GROUP |  | 전기그룹 | ZEBs1_FI_GL_GROUP | ZDB1_FI_GL_GROUP | NUMC | 2 | 01: 고객계정 02: 공급업체계정 03: 자산계정 00: 일반계정<br>SAKNR의 데이터와 정합성이 맞게 들어가게 해야 한다. |
| 11 | LVORM |  | 삭제표시 | ZEBs1_FI_LVORM | ZDB1_FI_LVORM | CHAR | 1 | X |
| 12 | ERNAM |  | 작성자 | ZEBs1_FI_ERNAM | ZDB1_FI_ERNAM | CHAR | 12 | (사용자 이름(ID)) |
| 13 | ERDAT |  | 작성일 | ZEBs1_FI_ERDAT | ZDB1_FI_ERDAT | DATS | 8 | YYYYMMDD |
| 14 | ERZET |  | 생성시간 | ZEBs1_FI_ERZET | ZDB1_FI_ERZET | TIMS | 6 | HHMMSS |
| 15 | AENAM |  | 변경자 | ZEBs1_FI_AENAM | ZDB1_FI_AENAM | CHAR | 12 | (사용자 이름(ID)) |
| 16 | AEDAT |  | 변경일 | ZEBs1_FI_AEDAT | ZDB1_FI_AEDAT | DATS | 8 | YYYYMMDD |
| 17 | AEZET |  | 변경시간 | ZEBs1_FI_AEZET | ZDB1_FI_AEZET | TIMS | 6 | HHMMSS |

---

## 6. ZTBF10006 (회계연도 테이블) <a id="ztb1fi0006"></a>

* **테이블명:** ZTBF10006
* **설명:** 회계연도를 월 및 개별 기간으로 나누지 및 달력연도 여부를 정의 (Fiscal Year Variant)

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | MANDT | X | 클라이언트 번호 | MANDT | MANDT | CLNT | 3 |  |
| 2 | PERIV | X | 회계 연도 변형 Variant | ZEBs1_FI_PERIV | ZDB1_FI_PERIV | CHAR | 2 | 사용자 정의<br>(K4, V3 등) |
| 3 | XXALE |  | 달력 연도 여부 | ZEBs1_FI_XXALE | ZDB1_FI_XXALE | CHAR | 1 | Calendar Year |
| 4 | XJABH |  | 연도 종속 여부 | ZEBs1_FI_XJABH | ZDB1_FI_XJABH | CHAR | 1 | Year-dependent |
| 5 | ANZBP |  | 회계 (전기) 기간 수 | ZEBs1_FI_ANZBP | ZDB1_FI_ANZBP | NUMC | 3 | 001 ~ 016<br>(GP3가 보통 012개요)<br>이하도 가능 |
| 6 | ANZSP |  | 특별 기간 수 | ZEBs1_FI_ANZSP | ZDB1_FI_ANZSP | NUMC | 2 | - |
| 7 | XWEEK |  | 플래그 : 회계연도 시작일부터 회계 주수 계산 | ZEBs1_FI_XWEEK | ZDB1_FI_XWEEK | CHAR | 1 | X = 예<br>(공백) = 아니오 |
| 8 | FYOFB |  | 현재 회계연도 이전 회계연도 수 | ZEBs1_FI_FYOFB | ZDB1_FI_FYOFB | NUMC | 2 | - |
| 9 | FYOFE |  | 현재 회계연도 이후 회계연도 수 | ZEBs1_FI_FYOFE | ZDB1_FI_FYOFE | NUMC | 2 | - |
| 10 | XWEEKQUART |  | 플래그 : 주간 달력으로 사용되는 회계연도 변형 | ZEBs1_FI_XWEEKQUART | ZDB1_FI_XWEEKQUART | CHAR | 1 | X = 예<br>(공백) = 아니오 |
| 11 | XPERIODQUART |  | 플래그, 기간 기준 분기 계산 | ZEBs1_FI_XPERIODQUART | ZDB1_FI_XPERIODQUART | CHAR | 1 | X = 예<br>(공백) = 아니오 |
| 12 | LVORM |  | 삭제표시 | ZEBs1_FI_LVORM | ZDB1_FI_LVORM | CHAR | 1 | X |
| 13 | ERNAM |  | 작성자 | ZEBs1_FI_ERNAM | ZDB1_FI_ERNAM | CHAR | 12 | (사용자 이름(ID)) |
| 14 | ERDAT |  | 작성일 | ZEBs1_FI_ERDAT | ZDB1_FI_ERDAT | DATS | 8 | YYYYMMDD |
| 15 | ERZET |  | 생성시간 | ZEBs1_FI_ERZET | ZDB1_FI_ERZET | TIMS | 6 | HHMMSS |
| 16 | AENAM |  | 변경자 | ZEBs1_FI_AENAM | ZDB1_FI_AENAM | CHAR | 12 | (사용자 이름(ID)) |
| 17 | AEDAT |  | 변경일 | ZEBs1_FI_AEDAT | ZDB1_FI_AEDAT | DATS | 8 | YYYYMMDD |
| 18 | AEZET |  | 변경시간 | ZEBs1_FI_AEZET | ZDB1_FI_AEZET | TIMS | 6 | HHMMSS |

---

## 7. ZTBF10007 (환율 테이블) <a id="ztb1fi0007"></a>

* **테이블명:** ZTBF10007
* **설명:** 환율을 관리하는 용도

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | MANDT | X | 클라이언트 번호 | MANDT | MANDT | CLNT | 3 |  |
| 2 | FCURR | X | 기준 통화 | ZEBs1_FI_FCURR | ZDB1_FI_FCURR | CUKY | 5 | 01 KRW<br>02 JPY<br>03 USD |
| 3 | TCURR | X | 변환 통화 | ZEBs1_FI_TCURR | ZDB1_FI_TCURR | CUKY | 5 | KRW, USD, JPY |
| 4 | GDATU | X | 적용일자 | ZEBs1_FI_GDATU | ZDB1_FI_GDATU | DATS | 8 |  |
| 5 | KURST | X | 환율 유형 | ZEBs1_FI_KURST | ZDB1_FI_KURST | CHAR | 4 | 기준 환율(M): 일반적인 전표 입력용.<br>평균 환율(A): 기말 결산 시 수익/비용 환산용.<br>기말 환율(P): 외화 평가용(기말 시점 환율).<br>계획 환율(V): 연간 예산 수립 시 사용하는 고정 환율. |
| 6 | UKURS |  | 환율 값 | ZEBs1_FI_UKURS | ZDB1_FI_UKURS | DEC | 9(Dec.5) | 환율 값 |
| 7 | LVORM |  | 삭제표시 | ZEBs1_FI_LVORM | ZDB1_FI_LVORM | CHAR | 1 | X |
| 8 | ERNAM |  | 작성자 | ZEBs1_FI_ERNAM | ZDB1_FI_ERNAM | CHAR | 12 | (사용자 이름(ID)) |
| 9 | ERDAT |  | 작성일 | ZEBs1_FI_ERDAT | ZDB1_FI_ERDAT | DATS | 8 | YYYYMMDD |
| 10 | ERZET |  | 생성시간 | ZEBs1_FI_ERZET | ZDB1_FI_ERZET | TIMS | 6 | HHMMSS |
| 11 | AENAM |  | 변경자 | ZEBs1_FI_AENAM | ZDB1_FI_AENAM | CHAR | 12 | (사용자 이름(ID)) |
| 12 | AEDAT |  | 변경일 | ZEBs1_FI_AEDAT | ZDB1_FI_AEDAT | DATS | 8 | YYYYMMDD |
| 13 | AEZET |  | 변경시간 | ZEBs1_FI_AEZET | ZDB1_FI_AEZET | TIMS | 6 | HHMMSS |

---

## 8. ZTBF10008 (통화 테이블) <a id="ztb1fi0008"></a>

* **테이블명:** ZTBF10008
* **설명:** 통화를 관리하는 용도

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | MANDT | X | 클라이언트 번호 | MANDT | MANDT | CLNT | 3 |  |
| 2 | WAERS | X | 통화 | ZEBs1_FI_WAERS | ZDB1_FI_WAERS | CUKY | 5 | 01 KRW<br>02 JPY<br>03 USD<br>(Fixed Value) |
| 3 | LVORM |  | 삭제표시 | ZEBs1_FI_LVORM | ZDB1_FI_LVORM | CHAR | 1 | X |
| 4 | ERNAM |  | 작성자 | ZEBs1_FI_ERNAM | ZDB1_FI_ERNAM | CHAR | 12 | (사용자 이름(ID)) |
| 5 | ERDAT |  | 작성일 | ZEBs1_FI_ERDAT | ZDB1_FI_ERDAT | DATS | 8 | YYYYMMDD |
| 6 | ERZET |  | 생성시간 | ZEBs1_FI_ERZET | ZDB1_FI_ERZET | TIMS | 6 | HHMMSS |
| 7 | AENAM |  | 변경자 | ZEBs1_FI_AENAM | ZDB1_FI_AENAM | CHAR | 12 | (사용자 이름(ID)) |
| 8 | AEDAT |  | 변경일 | ZEBs1_FI_AEDAT | ZDB1_FI_AEDAT | DATS | 8 | YYYYMMDD |
| 9 | AEZET |  | 변경시간 | ZEBs1_FI_AEZET | ZDB1_FI_AEZET | TIMS | 6 | HHMMSS |

---

## 9. ZTBF10009 (MOPS 테이블) <a id="ztb1fi0009"></a>

* **테이블명:** ZTBF10009
* **설명:** MOPS를 관리하는 용도

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | 기본값 (예: 800) |
| 2 | MATNR | X | 자재번호 | ZEBs1_FI_MATNR | ZDB1_FI_MATNR | CHAR | 40 | mm에서 설정해서 넘겨준 값 |
| 3 | MEINS |  | 기본 단위 = 수량 | ZEBs1_FI_MEINS | ZDB1_FI_MEINS | UNIT | 3 |  |
| 4 | STPRS |  | 자재단가 = MOPS | ZEBs1_FI_STPRS | ZDB1_FI_STPRS | CURR | 15.2 | 우리가 받아온 MOPS 값 |
| 5 | WAERS1 |  | 단가용 통화 | ZEBs1_FI_WAERS1 | ZDB1_FI_WAERS1 | CUKY | 5 | 01 KRW<br>02 JPY<br>03 USD |
| 6 | DMBTR |  | 금액(원화) | ZEBs1_FI_DMBTR | ZDB1_FI_DMBTR | CURR | 15.2 | (원화 금액) |
| 7 | WAERS2 |  | 원화 금액용 통화 | ZEBs1_FI_WAERS2 | ZDB1_FI_WAERS2 | CUKY | 5 | 01 KRW<br>02 JPY<br>03 USD |
| 8 | LVORM |  | 삭제표시 | ZEBs1_FI_LVORM | ZDB1_FI_LVORM | CHAR | 1 | X |
| 9 | ERNAM |  | 작성자 | ZEBs1_FI_ERNAM | ZDB1_FI_ERNAM | CHAR | 12 | (사용자 이름(ID)) |
| 10 | ERDAT |  | 작성일 | ZEBs1_FI_ERDAT | ZDB1_FI_ERDAT | DATS | 8 | YYYYMMDD |
| 11 | ERZET |  | 생성시간 | ZEBs1_FI_ERZET | ZDB1_FI_ERZET | TIMS | 6 | HHMMSS |
| 12 | AENAM |  | 변경자 | ZEBs1_FI_AENAM | ZDB1_FI_AENAM | CHAR | 12 | (사용자 이름(ID)) |
| 13 | AEDAT |  | 변경일 | ZEBs1_FI_AEDAT | ZDB1_FI_AEDAT | DATS | 8 | YYYYMMDD |
| 14 | AEZET |  | 변경시간 | ZEBs1_FI_AEZET | ZDB1_FI_AEZET | TIMS | 6 | HHMMSS |

---

## 10. ZTBF10010 (반제/미반제 관리 테이블)  <a id="ztb1fi0010"></a>

* **테이블명:** ZTBF10010
* **설명:** 반제 / 미반제를 관리하는 용도

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | 기본값 (예: 800) |
| 2 | BUKRS | X | 회사 코드 | ZEBs1_FI_BUKRS | ZDB1_FI_BUKRS | CHAR | 4 | 1000 본사<br>2000 지사 |
| 3 | GJAHR | X | 회계 연도 | ZEBs1_FI_GJAHR | ZDB1_FI_GJAHR | NUMC | 4 | 2025 회계연도<br>2026 회계연도<br>(YYYY) |
| 4 | BELNR | X | 회계 전표 번호 | ZEBs1_FI_BELNR | ZDB1_FI_BELNR | CHAR | 10 | 일반전표: 10, 역분개 전표: 11<br>매입전표: 20, 지급전표: 21<br>매출전표: 30, 입금전표: 31<br>생산: 40, 입고: 41, 출고: 42<br>(전표 번호와 연동 유발 자동채번 변경되도록) |
| 5 | BUZEI | X | 아이템 번호(라인번호) | ZEBs1_FI_BUZEI | ZDB1_FI_BUZEI | NUMC | 4 | (라인별 구분하는 번호 (0010, 0020...) 10단위로 데이터 수정 왜냐하면, 중간에 라인을 끼워 넣기 위해서다. |
| 6 | STATUS |  | 반제 상태 | ZEBs1_FI_STATUS | ZDB1_FI_STATUS | CHAR | 1 | 'O'(Open), 'C'(Clear), 'R'(Reverse) |
| 7 | AUGBL |  | 반제 전표번호 | ZEBs1_FI_AUGBL | ZDB1_FI_AUGBL | CHAR | 10 |  |
| 8 | AUGBLDAT |  | 반제 일자 | ZEBs1_FI_AUGBLDAT | ZDB1_FI_AUGBLDAT | DATS | 8 | YYYYMMDD |
| 9 | BP_CODE |  | 거래처/고객 코드 | ZEBs1_FI_BP_CODE | ZDB1_FI_BP_CODE | CHAR | 10 | PK (LIFNR/KUNNR 통합) |
| 10 | HKONT |  | G/L 계정 번호 | ZEBs1_FI_HKONT | ZDB1_FI_HKONT | CHAR | 8 | Primary Key (아이템의 HKONT와 연결될 값인.)<br>111010 현금 (Cash) 자산 (Asset)<br>112010 보통예금 (Checking Account) 자산 (Asset)<br>211010 외상매입금 (Accounts Payable) 부채 (Liability)<br>411010 상품매출 (Sales Revenue) 수익 (Revenue)<br>511010 급여 (Salaries & Wages) 비용 (Expense)<br>811010 복리후생비 (Employee Benefits) 비용 (Expense) |
| 11 | BUDAT |  | 전표 전기일 | ZEBs1_FI_BUDAT | ZDB1_FI_BUDAT | DATS | 8 | 회계 장부(전표)에 공식적으로 기록되는 날짜 YYYYMMDD |
| 12 | WAERS |  | 통화 | ZEBs1_FI_WAERS | ZDB1_FI_WAERS | CUKY | 5 | USD, KRW, EUR |
| 13 | DMBTR |  | 금액(원화) | ZEBs1_FI_DMBTR | ZDB1_FI_DMBTR | CURR | 15.2 | 원화 금액 |
| 14 | SHKZG |  | 차대변지시자 | ZEBs1_FI_SHKZG | ZDB1_FI_SHKZG | CHAR | 1 | 차변: S, 대변: H |
| 15 | ZFBDT |  | 지급기일일자 | ZEBs1_FI_ZFBDT | ZDB1_FI_ZFBDT | DATS | 8 | 만기일(Aging) 계산의 기준 |
| 16 | ZTERM |  | 지급 조건 | ZEBs1_FI_ZTERM | ZDB1_FI_ZTERM | CHAR | 4 | 0001(즉시), 0002(30일) 등 |
| 17 | LVORM |  | 삭제표시 | ZEBs1_FI_LVORM | ZDB1_FI_LVORM | CHAR | 1 | X |
| 18 | ERNAM |  | 작성자 | ZEBs1_FI_ERNAM | ZDB1_FI_ERNAM | CHAR | 12 | (사용자 이름(ID)) |
| 19 | ERDAT |  | 작성일 | ZEBs1_FI_ERDAT | ZDB1_FI_ERDAT | DATS | 8 | YYYYMMDD |
| 20 | ERZET |  | 생성시간 | ZEBs1_FI_ERZET | ZDB1_FI_ERZET | TIMS | 6 | HHMMSS |
| 21 | AENAM |  | 변경자 | ZEBs1_FI_AENAM | ZDB1_FI_AENAM | CHAR | 12 | (사용자 이름(ID)) |
| 22 | AEDAT |  | 변경일 | ZEBs1_FI_AEDAT | ZDB1_FI_AEDAT | DATS | 8 | YYYYMMDD |
| 23 | AEZET |  | 변경시간 | ZEBs1_FI_AEZET | ZDB1_FI_AEZET | TIMS | 6 | HHMMSS |

## 11. ZTB1FI0011 (결산 테이블)  <a id="ztb1fi0011"></a>

* **테이블 용도**: 결산을 관리하는 용도
* **테이블 유형**: 트랜잭션 테이블

| 번호 | 필드 | PK | FK | Description | Data Element | Type | 길이 | Domain | Value range or 비고 |
| :--- | :--- | :-: | :-: | :--- | :--- | :--- | :-: | :--- | :--- |
| 1 | MANDT | X | | 클라이언트 | MANDT | CLNT | 3 | MANDT | 기본값 [예: 100] |
| 2 | BUKRS | X | | 회사 코드 | ZEB1_FI_BUKRS | CHAR | 4 | ZDB1_FI_BUKRS | 1000 본사<br>2000 지사 |
| 3 | GJAHR | X | | 회계 연도 | ZEB1_FI_GJAHR | NUMC | 4 | ZDB1_FI_GJAHR | 2025 회계연도<br>2026 회계연도 (YYYY) |
| 4 | MONAT | X | | 월 (Period) | ZEB1_FI_MONAT | NUMC | 3 | ZDB1_FI_MONAT | |
| 5 | WAERS | | | 통화 키 | ZEB1_FI_WAERS | CUKY | 5 | ZDB1_FI_WAERS | |
| 6 | DMBTR_FOR | | | 외화환산손익 | ZEB1_FI_DMBTR_FOR | DEC | 15 | ZDB1_FI_DMBTR_FOR | |
| 7 | DMBTR_VAT | | | 부가세 | ZEB1_FI_DMBTR_VAT | DEC | 15 | ZDB1_FI_DMBTR_VAT | |
| 8 | AROPCNT | | | 매출채권 미수건수 | ZEB1_FI_AROPCNT | NUMC | 4 | ZDB1_FI_AROPCNT | |
| 9 | LVORM | | | 삭제표시 | ZEB1_FI_LVORM | CHAR | 1 | ZDB1_FI_LVORM | X |
| 10 | ERNAM | | | 작성자 | ZEB1_FI_ERNAM | CHAR | 12 | ZDB1_FI_ERNAM | (사용자 이름(ID)) |
| 11 | ERDAT | | | 작성일 | ZEB1_FI_ERDAT | DATS | 8 | ZDB1_FI_ERDAT | YYYYMMDD |
| 12 | ERZET | | | 작성시간 | ZEB1_FI_ERZET | TIMS | 6 | ZDB1_FI_ERZET | HHMMSS |
| 13 | AENAM | | | 변경자 | ZEB1_FI_AENAM | CHAR | 12 | ZDB1_FI_AENAM | (사용자 이름(ID)) |
| 14 | AEDAT | | | 변경일 | ZEB1_FI_AEDAT | DATS | 8 | ZDB1_FI_AEDAT | YYYYMMDD |
| 15 | AEZET | | | 변경시간 | ZEB1_FI_AEZET | TIMS | 6 | ZDB1_FI_AEZET | HHMMSS |

---

## 12. ZTB1FI0012 (결산 내역 관리 테이블)  <a id="ztb1fi0012"></a>

* **테이블 용도**: 결산 내역을 관리하는 용도
* **테이블 유형**: 트랜잭션 테이블

| 번호 | 필드 | PK | FK | Description | Data Element | Type | 길이 | Domain | Value range or 비고 |
| :--- | :--- | :-: | :-: | :--- | :--- | :--- | :-: | :--- | :--- |
| 1 | MANDT | X | | 클라이언트 | MANDT | CLNT | 3 | MANDT | 기본값 [예: 100] |
| 2 | BUKRS | X | | 회사 코드 | ZEB1_FI_BUKRS | CHAR | 4 | ZDB1_FI_BUKRS | 1000 본사<br>2000 지사 |
| 3 | GJAHR | X | | 회계 연도 | ZEB1_FI_GJAHR | NUMC | 4 | ZDB1_FI_GJAHR | 2025 회계연도<br>2026 회계연도 (YYYY) |
| 4 | MONAT | X | | 월 (Period) | ZEB1_FI_MONAT | NUMC | 2 | ZDB1_FI_MONAT | |
| 5 | ITEM_TYPE | | | 항목구분 | ZEB1_FI_ITEM_TYPE | CHAR | 2 | ZDB1_FI_ITEM_TYPE | |
| 6 | HKONT | | | G/L 계정 코드 | ZEB1_FI_HKONT | CHAR | 10 | ZDB1_FI_HKONT | |
| 7 | LVORM | | | 삭제표시 | ZEB1_FI_LVORM | CHAR | 1 | ZDB1_FI_LVORM | X |
| 8 | ERNAM | | | 작성자 | ZEB1_FI_ERNAM | CHAR | 12 | ZDB1_FI_ERNAM | (사용자 이름(ID)) |
| 9 | ERDAT | | | 작성일 | ZEB1_FI_ERDAT | DATS | 8 | ZDB1_FI_ERDAT | YYYYMMDD |
| 10 | ERZET | | | 작성시간 | ZEB1_FI_ERZET | TIMS | 6 | ZDB1_FI_ERZET | HHMMSS |
| 11 | AENAM | | | 변경자 | ZEB1_FI_AENAM | CHAR | 12 | ZDB1_FI_AENAM | (사용자 이름(ID)) |
| 12 | AEDAT | | | 변경일 | ZEB1_FI_AEDAT | DATS | 8 | ZDB1_FI_AEDAT | YYYYMMDD |
| 13 | AEZET | | | 변경시간 | ZEB1_FI_AEZET | TIMS | 6 | ZDB1_FI_AEZET | HHMMSS |

---

## 13. ZTB1FI0013 (사용자-역할 매핑 테이블)  <a id="ztb1fi0013"></a>

* **테이블 용도**: 사용자의 역할 및 권한 관리
* **테이블 유형**: 마스터 테이블

| 번호 | 필드 | PK | FK | Description | Data Element | Type | 길이 | Domain | Value range or 비고 |
| :--- | :--- | :-: | :-: | :--- | :--- | :--- | :-: | :--- | :--- |
| 1 | MANDT | X | | 클라이언트 | MANDT | CLNT | 3 | MANDT | 100 |
| 2 | UNAME | X | | 사용자 ID | ZEB1_FI_UNAME | CHAR | 12 | ZDB1_FI_UNAME | NCODE-B-01 |
| 3 | AGR_NAME | X | | 역할 | ZEB1_FI_AGR_NAME | CHAR | 1 | ZDB1_FI_AGR_NAME | P : 생산전표, S : 판매전표, M : 구매전표 |
| 4 | AUTH_TYPE | | | CRUD 권한 유무 | ZEB1_FI_AUTH_TYPE | CHAR | 1 | ZDB1_FI_AUTH_TYPE | X : CRUD 가능, ' ' : 조회만 가능 |
| 5 | FROM_DAT | | | 시작일 | ZEB1_FI_FROM_DAT | DATS | 8 | ZDB1_FI_FROM_DAT | 20260417 |
| 6 | TO_DAT | | | 종료일 | ZEB1_FI_TO_DAT | DATS | 8 | ZDB1_FI_TO_DAT | 99991231 |
| 7 | EXCLUDE | | | 제외 여부 | ZEB1_FI_EXCLUDE | CHAR | 1 | ZDB1_FI_EXCLUDE | X |
| 8 | LVORM | | | 삭제표시 | ZEB1_FI_LVORM | CHAR | 1 | ZDB1_FI_LVORM | X |
| 9 | ERNAM | | | 작성자 | ZEB1_FI_ERNAM | CHAR | 12 | ZDB1_FI_ERNAM | NCODE-B-01 |
| 10 | ERDAT | | | 작성일 | ZEB1_FI_ERDAT | DATS | 8 | ZDB1_FI_ERDAT | YYYYMMDD |
| 11 | ERZET | | | 작성시간 | ZEB1_FI_ERZET | TIMS | 6 | ZDB1_FI_ERZET | HHMMSS |
| 12 | AENAM | | | 변경자 | ZEB1_FI_AENAM | CHAR | 12 | ZDB1_FI_AENAM | (사용자 이름(ID)) |
| 13 | AEDAT | | | 변경일 | ZEB1_FI_AEDAT | DATS | 8 | ZDB1_FI_AEDAT | YYYYMMDD |
| 14 | AEZET | | | 변경시간 | ZEB1_FI_AEZET | TIMS | 6 | ZDB1_FI_AEZET | HHMMSS |

---

## 14. ZTB1FI0014 (계정-세금코드 매핑)  <a id="ztb1fi0014"></a>

* **테이블 용도**: 계정-세금코드 매핑
* **테이블 유형**: 마스터 테이블

| 번호 | 필드 | PK | FK | Description | Data Element | Type | 길이 | Domain | Value range or 비고 |
| :--- | :--- | :-: | :-: | :--- | :--- | :--- | :-: | :--- | :--- |
| 1 | MANDT | X | | 클라이언트 | MANDT | CLNT | 3 | MANDT | 100 |
| 2 | BUKRS | X | | 회사코드 | ZEB1_FI_BUKRS | CHAR | 12 | ZDB1_FI_BUKRS | |
| 3 | BLART | X | | 회계 전표 유형 | ZEB1_FI_BLART | CHAR | 1 | ZDB1_FI_BLART | |
| 4 | LAND1 | X | | 국가 코드 | ZEB1_SD_CNTCD | CHAR | 1 | ZDB1_FI_LAND1 | |
| 5 | HKONT | X | | G/L 계정 번호 | ZEB1_FI_HKONT | DATS | 8 | ZDB1_FI_HKONT | |
| 6 | MWSKZ | | | 세금 코드 | ZEB1_FI_MWSKZ | DATS | 8 | ZDB1_FI_MWSKZ | |
| 7 | ERNAM | | | 작성자 | ZEB1_ERNAM | CHAR | 12 | ZDB1_FI_ERNAM | |
| 8 | ERDAT | | | 작성일 | ZEB1_ERDAT | CHAR | 8 | ZDB1_FI_ERDAT | |
| 9 | ERZET | | | 작성시간 | ZEB1_ERZET | CHAR | 6 | ZDB1_FI_ERZET | |
| 10 | AENAM | | | 변경자 | ZEB1_AENAM | DATS | 12 | ZDB1_FI_AENAM | |
| 11 | AEDAT | | | 변경일 | ZEB1_AEDAT | TIMS | 8 | ZDB1_FI_AEDAT | |
| 12 | AEZET | | | 변경시간 | ZEB1_AEZET | CHAR | 6 | ZDB1_FI_AEZET | |
