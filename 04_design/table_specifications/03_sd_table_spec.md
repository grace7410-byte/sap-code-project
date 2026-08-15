# [Design] SD (영업 관리) 모듈 테이블 명세서

**최종 수정일**: 2026-07-01  
**상태**: 확정 (Approved)  
**버전**: v2.3 (Check Table, Search Help, Fixed Value 열 제거 및 구조 통일)

> 💡 **문서 연결 가이드**: 타 문서에서 특정 테이블로 링크를 걸 때는 본 파일 경로 뒤에 `#테이블명` 앵커를 사용  
> *예시: `[대금 청구 아이템 스펙](04_design/03_sd_table_spec.md#ztb1sd0011)`*

---

## 1. ZTB1SD0001 (BP 마스터 일반) <a id="ztb1sd0001"></a>
* **모듈명**: SD
* **테이블명**: ZTB1SD0001
* **설명**: BP 마스터 일반
* **작성자 / 작성일**: 최지수 / 2026.03.25

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | BPID | X | BP 코드 | ZEB1_SD_BPID | ZDB1_SD_BPID | CHAR | 10 | BP코드 |
| 3 | BPTYP | X | BP 유형 | ZEB1_SD_BPTYP | ZDB1_SD_BPTYP | CHAR | 4 | 1: 공급업체 2: 고객 |
| 4 | BPNM | | BP 명 | ZEB1_SD_BPNM | ZDB1_SD_BPNM | CHAR | 40 | |
| 5 | ADDR | | 업체주소 | ZEB1_SD_ADDR | ZDB1_SD_ADDR | CHAR | 60 | |
| 7 | CNTCD | | 국가 코드 | ZEB1_SD_CNTCD | ZDB1_SD_CNTCD | CHAR | 3 | |
| 8 | BIZNO | | 사업자 번호 | ZEB1_SD_BIZNO | ZDB1_SD_BIZNO | CHAR | 16 | |
| 9 | EMAIL | | 이메일 | ZEB1_SD_EMAIL | ZDB1_SD_EMAIL | CHAR | 60 | |
| 10 | ACCNO | | 계좌번호 | ZEB1_SD_ACCNO | ZDB1_SD_ACCNO | CHAR | 18 | 하나의 bp에 하나의 은행/계좌번호 |
| 11 | BANK | | 은행명 | ZEB1_SD_BANK | ZDB1_SD_BANK | CHAR | 60 | 하나의 bp에 하나의 은행/계좌번호 |
| 12 | WAERS | | 통화 코드 | ZEB1_SD_WAERS | ZDB1_SD_WAERS | CUKY | 5 | |
| 13 | PICNM | | 거래처 담당자 | ZEB1_SD_PICNM | ZDB1_SD_PICNM | CHAR | 40 | |
| 14 | PICTL | | 거래처 담당자 전화번호 | ZEB1_SD_PICTL | ZDB1_SD_PICTL | CHAR | 30 | |
| 15 | LVORM | | 삭제표시 | ZEB1_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 16 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 17 | ERDAT | | 생성일 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 18 | ERZET | | 생성 시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 19 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 20 | AEDAT | | 변경일 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 21 | AEZET | | 변경 시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 2. ZTB1SD0002 (BP 조정 계정 마스터) <a id="ztb1sd0002"></a>
* **모듈명**: SD
* **테이블명**: ZTB1SD0002
* **설명**: BP 조정 계정 마스터 (이 bp가 회계 관점에서 어떤 성격의 자산/부채 계정으로 연결되는지)
* **작성자 / 작성일**: 강효창 / 2026-03-26

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | BPID | X | BP 코드 | ZEB1_SD_BPID | ZDB1_SD_BPID | CHAR | 10 | Search Help: KRED_C |
| 3 | BPTYP | X | BP 유형 | ZEB1_SD_BPTYP | ZDB1_SD_BPTYP | CHAR | 4 | 1: 공급업체 2: 고객 3: 세관 4: 운송업체 |
| 4 | RECON | | 조정계정 | ZEB1_SD_RECON | ZDB1_SD_RECON | CHAR | 8 | |
| 5 | LVORM | | 삭제 표시 | ZEB1_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 6 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 7 | ERDAT | | 생성일 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 8 | ERZET | | 생성 시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 9 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 10 | AEDAT | | 변경일 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 11 | AEZET | | 변경 시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 3. ZTB1SD0003 (고객 마스터 (판매)) <a id="ztb1sd0003"></a>
* **모듈명**: SD
* **테이블명**: ZTB1SD0003
* **설명**: 고객 마스터 (판매)
* **작성자 / 작성일**: 최지수 / 2026.03.25

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | BPID | X | 고객코드 | ZEB1_SD_BPID | ZDB1_SD_BPID | CHAR | 10 | |
| 3 | VKORG | X | 영업조직 | ZEB1_SD_VKORG | ZDB1_SD_VKORG | CHAR | 4 | 1000: 국내 2000: 해외 |
| 4 | VTWEG | X | 유통경로 | ZEB1_SD_VTWEG | ZDB1_SD_VTWEG | CHAR | 2 | 10: 직판(주유소) 20: 도매(기업거래), 2000-10: 해외수출 |
| 5 | SPART | X | 제품군 | ZEB1_SD_SPART | ZDB1_SD_SPART | CHAR | 2 | 10: 연료유, 20: 아스팔트 30: 석유화학 |
| 6 | ZTERM | | 지급 조건 키 | ZEB1_SD_ZTERM | ZDB1_SD_ZTERM | CHAR | 4 | 0001: 즉시지급, 0002: 14일이내 0003: 30일이내 |
| 7 | INCO1 | | 인도조건 | ZEB1_SD_INCO1 | ZDB1_SD_INCO1 | CHAR | 3 | |
| 8 | TAXCL | | 고객 세금 분류 | ZEB1_SD_TAXCL | ZDB1_SD_TAXCL | CHAR | 1 | 0: 면세 고객 1: 과세 고객 |
| 9 | TAXTY | | 과세 유형 | ZEB1_SD_TAXTY | ZDB1_SD_TAXTY | CHAR | 1 | 0: 수출 1: 국내 |
| 10 | LVORM | | 삭제 표시 | ZEB1_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 11 | ZVIP | | vip여부 | ZEB1_ZVIP | ZDB1_ZVIP | CHAR | 1 | |
| 12 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 13 | ERDAT | | 생성일 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 14 | ERZET | | 생성 시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 15 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 16 | AEDAT | | 변경일 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 17 | AEZET | | 변경 시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 4. ZTB1SD0004 (가격 조건 마스터) <a id="ztb1sd0004"></a>
* **모듈명**: SD
* **테이블명**: ZTB1SD0004
* **설명**: 가격 조건 마스터
* **작성자 / 작성일**: 최지수 / 2026.03.25

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | KSCHL | X | 조건 타입 | ZEB1_SD_KSCHL | ZDB1_SD_KSCHL | CHAR | 4 | fixed value |
| 3 | MATNR | X | 자재 번호 | ZEB1_SD_MATNR | ZDB1_SD_MATNR | CHAR | 40 | Check Table: ZTC2CNMM0001 |
| 4 | DATAB | X | 유효시작일 | ZEB1_SD_DATAB | ZDB1_SD_DATAB | DATS | 8 | |
| 5 | ZPREM | | 프리미엄가 | ZEB1_SD_ZPREM | ZDB1_SD_ZPREM | CURR | 15,2 | 프리미엄가(마진), ex) 50이면 리터당 50원을 더 받겠다. |
| 6 | STPRS | | MOPS 값 | ZEB1_FI_STPRS | ZDB1_FI_STPRS | CURR | 15,2 | |
| 7 | UKURS | | 환율 | ZEB1_FI_UKURS | ZDB1_FI_UKURS | DEC | 9,5 | |
| 8 | WAERS_STPRS | | MOPS 통화키 | ZEB1_SD_WAERS | ZDB1_SD_WAERS | CUKY | 5 | USD |
| 9 | DATBI | | 유효종료일 | ZEB1_SD_DATBI | ZDB1_SD_DATBI | DATS | 8 | 9999.12.31 |
| 10 | WAERS | | 통화키 | ZEB1_SD_WAERS | ZDB1_SD_WAERS | CUKY | 5 | KRW |
| 11 | KPEIN | | 가격 단위 | ZEB1_SD_KPEIN | ZDB1_SD_KPEIN | DEC | 5 | 100 |
| 12 | MEINS | | UoM | ZEB1_MM_MEINS | ZDB1_MM_MEINS | UNIT | 3 | BBL |
| 13 | LVORM | | 삭제 표시 | ZEB1_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 14 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 15 | ERDAT | | 생성일자 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 16 | ERZET | | 생성시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 17 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 18 | AEDAT | | 변경일 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 19 | AEZET | | 변경 시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 5. ZTB1SD0005 (판매오더 가격 로그 테이블) <a id="ztb1sd0005"></a>
* **모듈명**: SD
* **테이블명**: ZTB1SD0005
* **설명**: 판매오더 가격 로그 테이블
* **작성자 / 작성일**: 최지수 / 2026.03.25

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | VBELN | X | 판매오더번호 | ZEB1_SD_VBELN | ZDB1_SD_VBELN | CHAR | 10 | 판매오더 아이템 참조 |
| 3 | POSNR | X | 아이템번호 | ZEB1_SD_POSNR | ZDB1_SD_POSNR | NUMC | 4 | 판매오더 아이템 참조 |
| 4 | KSCHL | X | 조건타입 | ZEB1_SD_KSCHL | ZDB1_SD_KSCHL | CHAR | 4 | |
| 5 | ZPREM | | 프리미엄가 | ZEB1_SD_ZPREM | ZDB1_SD_ZPREM | CURR | 15,2 | |
| 6 | STPRS | | MOPS값 | ZEB1_FI_STPRS | ZDB1_FI_STPRS | CURR | 15,2 | FI - MOPS T |
| 7 | WAERS_STPRS | | MOPS 통화코드 | ZEB1_SD_WAERS | ZDB1_SD_WAERS | CUKY | 5 | |
| 8 | UKURS | | 환율 | ZEB1_FI_UKURS | ZDB1_FI_UKURS | DEC | 9,5 | FI - 환율 T |
| 9 | NETPR | | 단가 | ZEB1_SD_NETPR | ZDB1_SD_NETPR | CURR | 15,2 | (MOPS * 환율) + 프리미엄 |
| 10 | KWMENG | | 주문 수량 | ZEB1_SD_KWMENG | ZDB1_SD_KWMENG | QUAN | 13,3 | |
| 11 | MEINS | | UoM | ZEB1_MM_MEINS | ZDB1_MM_MEINS | UNIT | 3 | BBL |
| 12 | NETVL | | 순 금액 | ZEB1_SD_NETVL | ZDB1_SD_NETVL | CURR | 15,2 | 단가 X 수량 |
| 13 | WAERS | | 통화키 | ZEB1_SD_WAERS | ZDB1_SD_WAERS | CUKY | 5 | |
| 14 | MWSKZ | | 세금코드 | ZEB1_FI_MWSKZ | ZDB1_FI_MWSKZ | CHAR | 2 | A0 : 과세 10%, A1 : 영세 0% |
| 15 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 16 | ERDAT | | 생성일자 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 17 | ERZET | | 생성시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 18 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 19 | AEDAT | | 변경일 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 20 | AEZET | | 변경 시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 6. ZTB1SD0006 (판매 오더 헤더 테이블) <a id="ztb1sd0006"></a>
* **모듈명**: SD
* **테이블명**: ZTB1SD0006
* **설명**: 판매 오더 헤더 테이블
* **작성자 / 작성일**: 최지수 / 2026.03.25

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | VBELN | X | 판매 오더 번호 | ZEB1_SD_VBELN | ZDB1_SD_VBELN | CHAR | 10 | 판매 문서의 고유 식별자 |
| 3 | VKORG | X | 영업조직 | ZEB1_SD_VKORG | ZDB1_SD_VKORG | CHAR | 4 | 1000: 국내 2000: 해외 (BP마스터 참조) |
| 4 | VTWEG | X | 유통경로 | ZEB1_SD_VTWEG | ZDB1_SD_VTWEG | CHAR | 2 | 10: 직판(주유소) 20:도매(기업거래), 30: 해외수출 |
| 5 | SOTYP | | 판매 오더 유형 | ZEB1_SD_SOTYP | ZDB1_SD_SOTYP | CHAR | 4 | 판매 오더 유형 (OR 표준오더) |
| 6 | BPID | | 고객 코드 | ZEB1_SD_BPID | ZDB1_SD_BPID | CHAR | 10 | 고객 BP 아이디 |
| 7 | ORDDA | | 오더 주문일 | ZEB1_SD_ORDDA | ZDB1_SD_ORDDA | DATS | 8 | |
| 8 | VDATU | | 픽업 요청일 | ZEB1_SD_VDATU | ZDB1_SD_VDATU | DATS | 8 | |
| 9 | PLDDA | | 출하 예정일 | ZEB1_SD_PLDDA | ZDB1_SD_PLDDA | DATS | 8 | |
| 10 | SOLDT | | 판매처 | ZEB1_SD_SOLDT | ZDB1_SD_SOLDT | CHAR | 10 | BP 마스터(일반) 참조 |
| 11 | SHIPT | | 납품처 | ZEB1_SD_SHIPT | ZDB1_SD_SHIPT | CHAR | 10 | BP 마스터(일반) 참조 |
| 12 | ZTERM | | 지급 조건 키 | ZEB1_SD_ZTERM | ZDB1_SD_ZTERM | CHAR | 4 | |
| 13 | INCO1 | | 인도조건 | ZEB1_SD_INCO1 | ZDB1_SD_INCO1 | CHAR | 3 | |
| 14 | TAXCL | | 고객 세금 분류 | ZEB1_SD_TAXCL | ZDB1_SD_TAXCL | CHAR | 1 | 0: 면세 고객 1: 과세 고객 |
| 15 | TAXTY | | 과세 유형 | ZEB1_SD_TAXTY | ZDB1_SD_TAXTY | CHAR | 1 | 0: 수출 1:국내 |
| 16 | SOSTA | | 판매오더상태 | ZEB1_SD_SOSTA | ZDB1_SD_SOSTA | CHAR | 3 | 공통 코드 참고 |
| 17 | LVORM | | 삭제 표시 | ZEB1_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 18 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 19 | ERDAT | | 생성일자 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 20 | ERZET | | 생성시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 21 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 22 | AEDAT | | 변경일 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 23 | AEZET | | 변경 시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 7. ZTB1SD0007 (판매 오더 아이템 테이블) <a id="ztb1sd0007"></a>
* **모듈명**: SD
* **테이블명**: ZTB1SD0007
* **설명**: 판매 오더 아이템 테이블
* **작성자 / 작성일**: 최지수 / 2026.03.25

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | VBELN | X | 판매 문서 번호 | ZEB1_SD_VBELN | ZDB1_SD_VBELN | CHAR | 10 | 판매오더 헤더 참조 |
| 3 | POSNR | X | 판매 문서 항목 | ZEB1_SD_POSNR | ZDB1_SD_POSNR | NUMC | 4 | |
| 4 | WERKS | | 플랜트 코드 | ZEB1_MM_WERKS | ZDB1_MM_WERKS | CHAR | 4 | Check Table: ZTC2CNMM0000 |
| 5 | LGORT | | 재고 저장위치 | ZEB1_MM_LGORT | ZDB1_MM_LGORT | CHAR | 4 | Check Table: ZTC2CNMM0000 |
| 6 | SPART | | 제품군 | ZEB1_SD_SPART | ZDB1_SD_SPART | CHAR | 2 | 10: 연료유, 20: 아스팔트 30: 석유화학 |
| 7 | MATNR | | 자재번호 | ZEB1_MM_MATNR | ZDB1_MM_MATNR | CHAR | 40 | Check Table: ZTC2CNMM0001 |
| 8 | KWMENG | | 주문 수량 | ZEB1_SD_KWMENG | ZDB1_SD_KWMENG | QUAN | 13,3 | |
| 9 | NETPR | | 단가 | ZEB1_SD_NETPR | ZDB1_SD_NETPR | CURR | 15,2 | 가격결정T - PR00값(세전금액) |
| 10 | MEINS | | UoM | ZEB1_MM_MEINS | ZDB1_MM_MEINS | UNIT | 3 | BBL |
| 11 | NETVL | | 순 금액 | ZEB1_SD_NETVL | ZDB1_SD_NETVL | CURR | 15,2 | 단가 X 수량 |
| 12 | WAERS | | 통화키 | ZEB1_SD_WAERS | ZDB1_SD_WAERS | CUKY | 5 | |
| 13 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 14 | ERDAT | | 생성일자 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 15 | ERZET | | 생성시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 16 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 17 | AEDAT | | 변경일 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 18 | AEZET | | 변경 시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 8. ZTB1SD0008 (출고 문서 헤더 테이블(LIKP)) <a id="ztb1sd0008"></a>
* **모듈명**: SD
* **테이블명**: ZTB1SD0008
* **설명**: 출고 문서 헤더 테이블(LIKP)
* **작성자 / 작성일**: 최지수 / 2026.03.25

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | VBELN | X | 출고 문서 번호 | ZEB1_SD_VBELN | ZDB1_SD_VBELN | CHAR | 10 | |
| 3 | VBELN_VA | | 판매 오더 번호 | ZEB1_SD_VBELN_VA | ZDB1_SD_VBELN_VA | CHAR | 10 | 판매오더 헤더 참조 |
| 4 | LFDAT | | 출고일 | ZEB1_SD_LFDAT | ZDB1_SD_LFDAT | DATS | 8 | |
| 5 | SHIPT | | 납품처 | ZEB1_SD_SHIPT | ZDB1_SD_SHIPT | CHAR | 10 | BP 마스터(일반) 참조 |
| 6 | ZTERM | | 지급 조건 키 | ZEB1_SD_ZTERM | ZDB1_SD_ZTERM | CHAR | 4 | |
| 7 | INCO1 | | 인도조건 | ZEB1_SD_INCO1 | ZDB1_SD_INCO1 | CHAR | 3 | |
| 8 | TAXCL | | 고객 세금 분류 | ZEB1_SD_TAXCL | ZDB1_SD_TAXCL | CHAR | 1 | 0: 면세 고객 1: 과세 고객 |
| 9 | TAXTY | | 과세 유형 | ZEB1_SD_TAXTY | ZDB1_SD_TAXTY | CHAR | 1 | 0: 수출 1:국내 |
| 10 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 11 | ERDAT | | 생성일 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 12 | ERZET | | 생성 시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 13 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 14 | AEDAT | | 변경일 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 15 | AEZET | | 변경 시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 9. ZTB1SD0009 (출고 문서 아이템 테이블(LIPS)) <a id="ztb1sd0009"></a>
* **모듈명**: SD
* **테이블명**: ZTB1SD0009
* **설명**: 출고 문서 아이템 테이블(LIPS)
* **작성자 / 작성일**: 최지수 / 2026.03.25

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | VBELN | X | 출고 문서 번호 | ZEB1_SD_VBELN | ZDB1_SD_VBELN | CHAR | 10 | 출고문서 헤더 참조 |
| 3 | POSNR | X | 항목 번호 | ZEB1_SD_POSNR | ZDB1_SD_POSNR | NUMC | 4 | |
| 4 | VBELN_VA | | 참조 판매 문서 번호 | ZEB1_SD_VBELN_VA | ZDB1_SD_VBELN_VA | CHAR | 10 | 판매오더 아이템 참조 |
| 5 | POSNR_VA | | 참조 판매 항목 번호 | ZEB1_SD_POSNR_VA | ZDB1_SD_POSNR_VA | NUMC | 4 | 판매오더 아이템 참조 |
| 6 | WERKS | | 플랜트 코드 | ZEB1_MM_WERKS | ZDB1_MM_WERKS | CHAR | 4 | Check Table: ZTC2CNMM0000 |
| 7 | LGORT | | 재고 저장위치 | ZEB1_MM_LGORT | ZDB1_MM_LGORT | CHAR | 4 | Check Table: ZTC2CNMM0000 |
| 8 | MATNR | | 자재 번호 | ZEB1_MM_MATNR | ZDB1_MM_MATNR | CHAR | 40 | |
| 9 | LFIMG | | 실제 납품 수량 | ZEB1_SD_LFIMG | ZDB1_SD_LFIMG | QUAN | 13,3 | |
| 10 | MEINS | | UoM | ZEB1_MM_MEINS | ZDB1_MM_MEINS | UNIT | 3 | |
| 11 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 12 | ERDAT | | 생성일 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 13 | ERZET | | 생성 시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 14 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 15 | AEDAT | | 변경일 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 16 | AEZET | | 변경 시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 10. ZTB1SD0010 (대금 청구 헤더 테이블(VBRK)) <a id="ztb1sd0010"></a>
* **모듈명**: SD
* **테이블명**: ZTB1SD0010
* **설명**: 대금 청구 헤더 테이블(VBRK)
* **작성자 / 작성일**: 최지수 / 2026.03.25

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | VBELN | X | 청구 문서 번호 | ZEB1_SD_VBELN | ZDB1_SD_VBELN | CHAR | 10 | |
| 3 | VBELN_VA | | 출고 문서 번호 | ZEB1_SD_VBELN_VA | ZDB1_SD_VBELN_VA | CHAR | 10 | 출고문서 헤더 참조 |
| 4 | FKDAT | | 청구일 | ZEB1_SD_FKDAT | ZDB1_SD_FKDAT | DATS | 8 | |
| 5 | NETWR | | 순 금액 합계 | ZEB1_SD_NETWR | ZDB1_SD_NETWR | CURR | 15,2 | |
| 6 | MWSTS | | 총 세금금액 | ZEB1_SD_MWSTS | ZDB1_SD_MWSTS | CURR | 15,2 | 유류세 + 부가세 |
| 7 | EXVWR | | 총 유류세액 | ZEB1_SD_EXVWR | ZDB1_SD_EXVWR | CURR | 15,2 | |
| 8 | VATWR | | 총 부가세액 | ZEB1_SD_VATWR | ZDB1_SD_VATWR | CURR | 15,3 | |
| 9 | DMBTR | | 총 청구 금액 | ZEB1_SD_DMBTR | ZDB1_SD_DMBTR | CURR | 15,2 | NETWR + MWSBK (최종 입금받을 돈) |
| 10 | WAERS | | 통화 코드 | ZEB1_SD_WAERS | ZDB1_SD_WAERS | CUKY | 5 | |
| 11 | ZTERM | | 지급 조건 키 | ZEB1_SD_ZTERM | ZDB1_SD_ZTERM | CHAR | 4 | |
| 12 | INCO1 | | 인도조건 | ZEB1_SD_INCO1 | ZDB1_SD_INCO1 | CHAR | 3 | |
| 13 | TAXCL | | 고객 세금 분류 | ZEB1_SD_TAXCL | ZDB1_SD_TAXCL | CHAR | 1 | 0: 면세 고객 1: 과세 고객 |
| 14 | TAXTY | | 과세 유형 | ZEB1_SD_TAXTY | ZDB1_SD_TAXTY | CHAR | 1 | 0: 수출 1:국내 |
| 15 | STATUS | | 대금 청구 상태 | ZEB1_SD_STATUS | ZDB1_SD_STATUS | CHAR | 1 | 공통 코드 참고 |
| 16 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 17 | ERDAT | | 생성일 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 18 | ERZET | | 생성 시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 19 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 20 | AEDAT | | 변경일 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 21 | AEZET | | 변경 시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 11. ZTB1SD0011 (대금 청구 아이템 테이블(VBRP)) <a id="ztb1sd0011"></a>
* **모듈명**: SD
* **테이블명**: ZTB1SD0011
* **설명**: 대금 청구 아이템 테이블(VBRP)
* **작성자 / 작성일**: 최지수 / 2026.03.25

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | VBELN | X | 청구 문서 번호 | ZEB1_SD_VBELN | ZDB1_SD_VBELN | CHAR | 10 | 대금 청구 헤더 |
| 3 | POSNR | X | 항목 번호 | ZEB1_SD_POSNR | ZDB1_SD_POSNR | NUMC | 4 | |
| 4 | VBELN_VA | | 참조 출고 문서 번호 | ZEB1_SD_VBELN_VA | ZDB1_SD_VBELN_VA | CHAR | 10 | 판매오더 번호 |
| 5 | POSNR_VA | | 참조 DO 항목 번호 | ZEB1_SD_POSNR_VA | ZDB1_SD_POSNR_VA | NUMC | 4 | |
| 6 | MATNR | | 자재번호 | ZEB1_MM_MATNR | ZDB1_SD_MATNR | CHAR | 40 | 자재마스터 |
| 7 | FKIMG | | 실제 청구 수량 | ZEB1_SD_FKIMG | ZDB1_SD_FKIMG | QUAN | 13,3 | |
| 8 | MEINS | | UoM | ZEB1_SD_MEINS | ZDB1_SD_MEINS | UNIT | 3 | |
| 9 | NETVL | | 순금액 | ZEB1_SD_NETVL | ZDB1_SD_NETVL | CURR | 15,2 | SD05 T -PR00 |
| 10 | EXTAX | | 유류세 | ZEB1_SD_EXTAX | ZDB1_SD_EXTAX | CURR | 15,2 | SD05 T -TAX 합 |
| 11 | VATVL | | 부가세 | ZEB1_SD_VATVL | ZDB1_SD_VATVL | CURR | 15,2 | |
| 12 | WAERS | | 통화키 | ZEB1_SD_WAERS | ZDB1_SD_WAERS | CUKY | 5 | |
| 13 | MWSKZ | | 세금코드 | ZEB1_FI_MWSKZ | ZDB1_SD_MWSKZ | CHAR | 2 | |
| 14 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 15 | ERDAT | | 생성일 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 16 | ERZET | | 생성 시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 17 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 18 | AEDAT | | 변경일 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 19 | AEZET | | 변경 시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 12. ZTB1SD0012 (재고 보충 요청 테이블) <a id="ztb1sd0012"></a>
* **모듈명**: SD
* **테이블명**: ZTB1SD0012
* **설명**: 재고 보충 요청 테이블
* **작성자 / 작성일**: 강효창 / 2026.03.26

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | REQ_NO | X | 보충 요청 번호 | ZEB1_SD_REQ_NO | ZDB1_SD_REQ_NO | CHAR | 10 | |
| 3 | MATNR | | 자재 코드 | ZEB1_SD_MATNR | ZDB1_SD_MATNR | CHAR | 40 | Check Table: ZTB1MM0003 |
| 4 | WERKS | | 플랜트 | ZEB1_SD_WERKS | ZDB1_SD_WERKS | CHAR | 4 | |
| 5 | LGORT | | 저장창고 | ZEB1_SD_LGORT | ZDB1_SD_LGORT | CHAR | 4 | |
| 6 | REQ_DATE | | 요청일자 | ZEB1_SD_REQ_DATE | ZDB1_SD_REQ_DATE | DATS | 8 | |
| 7 | REQ_QTY | | 요청 수량 | ZEB1_SD_REQ_QTY | ZDB1_SD_REQ_QTY | QUAN | 5 | |
| 8 | MEINS | | UoM | ZEB1_MM_MEINS | ZDB1_MM_MEINS | UNIT | 3 | |
| 9 | REQ_STATUS | | 요청 상태 | ZEB1_SD_REQ_STATUS | ZDB1_SD_REQ_STATUS | CHAR | 1 | (R: 요청 / A: 승인 / D: 반려) |
| 10 | SUPPLY_DATE | | 공급 예정일 | ZEB1_SD_SUPPLY_DATE | ZDB1_SD_SUPPLY_DATE | DATS | 8 | |
| 11 | LVORM | | 삭제 표시 | ZEB1_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 12 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 13 | ERDAT | | 생성일 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 14 | ERZET | | 생성 시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 15 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 16 | AEDAT | | 변경일 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 17 | AEZET | | 변경 시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 13. ZTB1SD0013 (텍스트 테이블) <a id="ztb1sd0013"></a>
* **모듈명**: SD
* **테이블명**: ZTB1SD0013
* **설명**: 텍스트 테이블
* **작성자 / 작성일**: 최지수 / 2026.03.25

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | DIV | X | 데이터 구분 코드 | ZEB1_SD_DIV | ZDB1_SD_DIV | CHAR | 5 | |
| 3 | CODE | X | 실제 코드 값 | ZEB1_SD_CODE | ZDB1_SD_CODE | CHAR | 20 | |
| 4 | SPARS | X | 언어 | ZEB1_SD_SPARS | ZDB1_SD_SPARS | SPARS | 1 | |
| 5 | TEXT | | 텍스트 | ZEB1_SD_TEXT | ZDB1_SD_TEXT | CHAR | 100 | |
| 6 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 7 | ERDAT | | 생성일 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 8 | ERZET | | 생성 시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 9 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 10 | AEDAT | | 변경일 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 11 | AEZET | | 변경 시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 14. ZTB1SD0014 (Node 테이블) <a id="ztb1sd0014"></a>
* **모듈명**: SD
* **테이블명**: ZTB1SD0014
* **설명**: Node 테이블
* **작성자 / 작성일**: 엄영욱 / 2026.07.01

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | PROC_ID | X | 프로세스 ID | ZEB1_SD_PROC_ID | ZDB1_SD_PROC_ID | CHAR | 20 | |
| 3 | NODE_ID | X | 노드 ID | ZEB1_SD_NODE_ID | ZDB1_SD_NODE_ID | CHAR | 20 | |
| 4 | NODE_SEQ | | 노드 순서 | ZEB1_SD_NODE_SEQ | ZDB1_SD_NODE_SEQ | NUMC | 4 | |
| 5 | NODE_TITLE | | 노드명 | ZEB1_SD_NODE_TITLE | ZDB1_SD_NODE_TITLE | CHAR | 40 | |
| 6 | NODE_DESC | | 노드 설명 | ZEB1_SD_NODE_DESC | ZDB1_NODE_DESC | CHAR | 80 | |
| 7 | NODE_TYPE | | 노드 유형 | ZEB1_SD_NODE_TYPE | ZDB1_NODE_TYPE | CHAR | 10 | |
| 8 | SEM_OBJ | | Semantic Object | ZEB1_SD_SEM_OBJ | ZDB1_SEM_OBJ | CHAR | 40 | |
| 9 | ACTION | | Action | ZEB1_SD_ACTION | ZDB1_ACTION | CHAR | 20 | |
| 10 | ACTIVE | | 사용 여부 | ZEB1_SD_ACTIVE | ZDB1_ACTIVE | CHAR | 1 | |
| 11 | LANE_ID | | 노드 영역 | ZEB1_SD_LANE_ID | ZDB1_LANE_ID | CHAR | 20 | |
| 12 | EXECUTABLE | | 노드 클릭 가능 여부 | ZEB1_SD_EXECUTABLE | ZDB1_EXECUTABLE | CHAR | 1 | |
| 13 | LVORM | | 삭제표시 | ZEB1_SD_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 14 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 15 | ERDAT | | 생성일 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 16 | ERZET | | 생성 시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 17 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 18 | AEDAT | | 변경일 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 19 | AEZET | | 변경 시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 15. ZTB1SD0015 (EDGE 테이블) <a id="ztb1sd0015"></a>
* **모듈명**: SD
* **테이블명**: ZTB1SD0015
* **설명**: EDGE 테이블
* **작성자 / 작성일**: 엄영욱 / 2026.07.01

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | PROC_ID | X | 프로세스 ID | ZEB1_SD_PROC_ID | ZDB1_SD_PROC_ID | CHAR | 20 | |
| 3 | EDGE_ID | X | 연결 ID | ZEB1_SD_EDGE_ID | ZDB1_SD_EDGE_ID | CHAR | 20 | |
| 4 | FROM_NODE | | 시작 노드 | ZEB1_SD_FROM_NODE | ZDB1_SD_FROM_NODE | CHAR | 20 | |
| 5 | TO_NODE | | 도착 노드 | ZEB1_SD_TO_NODE | ZDB1_SD_TO_NODE | CHAR | 20 | |
| 6 | EDGE_SEQ | | 연결 순서 | ZEB1_SD_EDGE_SEQ | ZDB1_EDGE_SEQ | NUMC | 4 | |
| 7 | COND_TEXT | | 조건 텍스트 | ZEB1_SD_COND_TEXT | ZDB1_COND_TEXT | CHAR | 40 | |
| 8 | ACTIVE | | 사용 여부 | ZEB1_SD_ACTIVE | ZDB1_ACTIVE | CHAR | 1 | |
| 9 | LVORM | | 삭제표시 | ZEB1_SD_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 10 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 11 | ERDAT | | 생성일 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 12 | ERZET | | 생성 시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 13 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 14 | AEDAT | | 변경일 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 15 | AEZET | | 변경 시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 16. ZTB1SD0016 (NODE 실행 상태) <a id="ztb1sd0016"></a>
* **모듈명**: SD
* **테이블명**: ZTB1SD0016
* **설명**: NODE 실행 상태
* **작성자 / 작성일**: 엄영욱 / 2026.07.01

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | PROC_ID | X | 프로세스 ID | ZEB1_SD_PROC_ID | ZDB1_SD_PROC_ID | CHAR | 20 | |
| 3 | NODE_ID | X | 노드 ID | ZEB1_SD_NODE_ID | ZDB1_SD_NODE_ID | CHAR | 20 | |
| 4 | RUN_ID | X | 실행 단위 ID | ZEB1_SD_RUN_ID | ZDB1_SD_RUN_ID | NUMC | 4 | |
| 5 | REF_DOC_NO | X | 노드 참조 문서 번호 | ZEB1_SD_REF_DOC_NO | ZDB1_SD_REF_DOC_NO | CHAR | 20 | |
| 6 | RESULT_DOC_NO | | 해당 단계 결과 문서번호 | ZEB1_SD_RESULT_DOC_NO | ZDB1_RESULT_DOC_NO | CHAR | 20 | |
| 7 | RESULT_DOC_TYPE | | 결과 문서 유형 | ZEB1_SD_RESULT_DOC_TYPE | ZDB1_RESULT_DOC_TYPE | CHAR | 10 | |
| 8 | NODE_STATUS | | 노드 상태 | ZEB1_SD_NODE_STATUS | ZDB1_NODE_STATUS | CHAR | 10 | |
| 9 | STATUS_TEXT | | 노드 상태 텍스트 | ZEB1_SD_STATUS_TEXT | ZDB1_STATUS_TEXT | CHAR | 40 | |
| 10 | EXECUTED | | 노드 실행 여부 | ZEB1_SD_EXECUTED | ZDB1_EXECUTED | CHAR | 1 | |
| 11 | SAVED | | 노드 최종 저장 여부 | ZEB1_SD_SAVED | ZDB1_SAVED | CHAR | 1 | |
| 12 | EXEC_DATE | | 실행일 | ZEB1_SD_EXEC_DATE | ZDB1_EXEC_DATE | DATS | 8 | |
| 13 | EXEC_TIME | | 실행 시간 | ZEB1_SD_EXEC_TIME | ZDB1_EXEC_TIME | TIMS | 6 | |
| 14 | EXEC_USER | | 실행자 | ZEB1_SD_EXEC_USER | ZDB1_EXEC_USER | CHAR | 12 | |
| 15 | SAVE_DATE | | 저장일 | ZEB1_SD_SAVE_DATE | ZDB1_SAVE_DATE | DATS | 8 | |
| 16 | SAVE_TIME | | 저장 시간 | ZEB1_SD_SAVE_TIME | ZDB1_SAVE_TIME | TIMS | 6 | |
| 17 | SAVE_USER | | 저장자 | ZEB1_SD_SAVE_USER | ZDB1_SAVE_USER | CHAR | 12 | |
| 18 | LVORM | | 삭제표시 | ZEB1_SD_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 19 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 20 | ERDAT | | 생성일 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 21 | ERZET | | 생성 시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 22 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 23 | AEDAT | | 변경일 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 24 | AEZET | | 변경 시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 17. ZTB1SD0017 (프로그램 마스터) <a id="ztb1sd0017"></a>
* **모듈명**: SD
* **테이블명**: ZTB1SD0017
* **설명**: 프로그램 마스터
* **작성자 / 작성일**: 엄영욱 / 2026.07.01

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | PROGRAM_ID | X | 프로그램 ID | ZEB1_SD_PROGRAM_ID | ZDB1_SD_PROGRAM_ID | CHAR | 20 | |
| 3 | TCODE | | 실행 코드 | ZEB1_SD_TCODE | ZDB1_SD_TCODE | CHAR | 20 | |
| 4 | PROGRAM_TITLE | | 프로그램 명 | ZEB1_SD_PROGRAM_TITLE | ZDB1_SD_PROGRAM_TITLE | CHAR | 40 | |
| 5 | SEM_OBJ | | Semantic Object | ZEB1_SD_SEM_OBJ | ZDB1_SEM_OBJ | CHAR | 40 | |
| 6 | ACTION | | Action | ZEB1_SD_ACTION | ZDB1_ACTION | CHAR | 20 | |
| 7 | TILE_CREATED | | 타일 생성 여부 | ZEB1_SD_TILE_CREATED | ZDB1_TILE_CREATED | CHAR | 1 | |
| 8 | EXECUTABLE | | 노드 클릭 가능 여부 | ZEB1_SD_EXECUTABLE | ZDB1_EXECUTABLE | CHAR | 1 | |
| 9 | ACTIVE | | 사용 여부 | ZEB1_SD_ACTIVE | ZDB1_ACTIVE | CHAR | 1 | |
| 10 | PROGRAM_TYPE | | 프로그램 타입 | ZEB1_SD_PROGRAM_TYPE | ZDB1_PROGRAM_TYPE | CHAR | 10 | |
| 11 | MODULE_ID | | 대표 모듈 | ZEB1_SD_MODULE_ID | ZDB1_MODULE_ID | CHAR | 10 | |
| 12 | LVORM | | 삭제표시 | ZEB1_SD_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 13 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 14 | ERDAT | | 생성일 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 15 | ERZET | | 생성 시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 16 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 17 | AEDAT | | 변경일 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 18 | AEZET | | 변경 시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 18. ZTB1SD0018 (프로세스 마스터) <a id="ztb1sd0018"></a>
* **모듈명**: SD
* **테이블명**: ZTB1SD0018
* **설명**: 프로세스 마스터
* **작성자 / 작성일**: 엄영욱 / 2026.07.01

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | PROC_ID | X | 프로세스 ID | ZEB1_SD_PROC_ID | ZDB1_SD_PROC_ID | CHAR | 20 | |
| 3 | PROC_TITLE | | 프로세스명 | ZEB1_SD_PROC_TITLE | ZDB1_SD_PROC_TITLE | CHAR | 60 | |
| 4 | PROC_DESC | | 프로세스 설명 | ZEB1_SD_PROC_DESC | ZDB1_SD_PROC_DESC | CHAR | 255 | |
| 5 | MAIN_MODULE | | 대표 모듈 | ZEB1_SD_MAIN_MODULE | ZDB1_SD_MAIN_MODULE | CHAR | 10 | |
| 6 | RELATED_MODULES | | 관련 모듈 | ZEB1_SD_RELATED_MODULES | ZDB1_RELATED_MODULES | CHAR | 50 | |
| 7 | DISPLAY_SEQ | | 표시 순서 | ZEB1_SD_DISPLAY_SEQ | ZDB1_DISPLAY_SEQ | NUMC | 4 | |
| 8 | ICON | | 아이콘 | ZEB1_SD_ICON | ZDB1_ICON | CHAR | 40 | |
| 9 | ACTIVE | | 사용 여부 | ZEB1_SD_ACTIVE | ZDB1_ACTIVE | CHAR | 1 | |
| 10 | PROCESS_TYPE | | 프로세스 유형 | ZEB1_SD_PROCESS_TYPE | ZDB1_PROCESS_TYPE | CHAR | 10 | |
| 11 | LVORM | | 삭제표시 | ZEB1_SD_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 12 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 13 | ERDAT | | 생성일 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 14 | ERZET | | 생성 시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 15 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 16 | AEDAT | | 변경일 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 17 | AEZET | | 변경 시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 19. ZTB1SD0019 (프로그램 마스터) <a id="ztb1sd0019"></a>
* **모듈명**: SD
* **테이블명**: ZTB1SD0019
* **설명**: 프로그램 마스터 (노드-프로그램 매핑)
* **작성자 / 작성일**: 엄영욱 / 2026.07.01

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | PROC_ID | X | 프로세스 ID | ZEB1_SD_PROC_ID | ZDB1_SD_PROC_ID | CHAR | 20 | |
| 3 | NODE_ID | X | 노드 ID | ZEB1_SD_NODE_ID | ZDB1_SD_NODE_ID | CHAR | 20 | |
| 4 | PROGRAM_ID | X | 프로그램 ID | ZEB1_SD_PROGRAM_ID | ZDB1_SD_PROGRAM_ID | CHAR | 20 | |
| 5 | STEP_SEQ | | 실행 순서 | ZEB1_SD_STEP_SEQ | ZDB1_SD_STEP_SEQ | NUMC | 4 | |
| 6 | MODULE_ID | | 대표 모듈 | ZEB1_SD_MODULE_ID | ZDB1_MODULE_ID | CHAR | 10 | |
| 7 | IN_PROCESS | | 상세 프로세스 포함 여부 | ZEB1_SD_IN_PROCESS | ZDB1_IN_PROCESS | CHAR | 1 | |
| 8 | RELATED_TILE | | 첫 화면 관련 타일 활성화 여부 | ZEB1_SD_RELATED_TILE | ZDB1_RELATED_TILE | CHAR | 1 | |
| 9 | ACTIVE | | 사용 여부 | ZEB1_SD_ACTIVE | ZDB1_ACTIVE | CHAR | 1 | |
| 10 | LVORM | | 삭제표시 | ZEB1_SD_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 11 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 12 | ERDAT | | 생성일 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 13 | ERZET | | 생성 시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 14 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 15 | AEDAT | | 변경일 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 16 | AEZET | | 변경 시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 20. ZTB1SD0020 (프로그램 모듈 매핑) <a id="ztb1sd0020"></a>
* **모듈명**: SD
* **테이블명**: ZTB1SD0020
* **설명**: 프로그램 모듈 매핑
* **작성자 / 작성일**: 엄영욱 / 2026.07.01

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | PROGRAM_ID | X | 프로그램 ID | ZEB1_SD_PROGRAM_ID | ZDB1_SD_PROGRAM_ID | CHAR | 20 | |
| 3 | MODULE_ID | X | 대표 모듈 | ZEB1_SD_MODULE_ID | ZDB1_MODULE_ID | CHAR | 10 | |
| 4 | ACTIVE | | 사용 여부 | ZEB1_SD_ACTIVE | ZDB1_ACTIVE | CHAR | 1 | |
| 5 | LVORM | | 삭제표시 | ZEB1_SD_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 6 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 7 | ERDAT | | 생성일 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 8 | ERZET | | 생성 시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 9 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 10 | AEDAT | | 변경일 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 11 | AEZET | | 변경 시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |
