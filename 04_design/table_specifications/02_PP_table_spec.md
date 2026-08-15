# [Design] PP (생산 관리) 모듈 테이블 명세서

**최종 수정일**: 2026-07-01
**상태**: 확정 (Approved)  
**버전**: v1.0

> 💡 **문서 연결 가이드**: 타 문서에서 특정 테이블로 링크를 걸 때는 본 파일 경로 뒤에 `#테이블명` 앵커를 사용  
> *예시: `[BOM 헤더 스펙](04_design/02_pp_table_spec.md#ztb1pp0002)`*

---

## 목차
1. [ZTB1PP0001 (PIR 데이터 테이블)](#ztb1pp0001)
2. [ZTB1PP0002 (BOM 헤더)](#ztb1pp0002)
3. [ZTB1PP0003 (BOM 아이템)](#ztb1pp0003)
4. [ZTB1PP0004 (Work Center 마스터)](#ztb1pp0004)
5. [ZTB1PP0005 (Work Center 운영 스케줄)](#ztb1pp0005)
6. [ZTB1PP0006 (Work Center 이벤트 헤더)](#ztb1pp0006)
7. [ZTB1PP0007 (Work Center 이벤트 아이템)](#ztb1pp0007)
8. [ZTB1PP0008 (공정 헤더)](#ztb1pp0008)
9. [ZTB1PP0009 (공정 아이템)](#ztb1pp0009)
10. [ZTB1PP0010 (공정 자재 연결)](#ztb1pp0010)
11. [ZTB1PP0011 (MRP 헤더)](#ztb1pp0011)
12. [ZTB1PP0012 (MRP 아이템)](#ztb1pp0012)
13. [ZTB1PP0013 (생산계획 / 생산오더 헤더)](#ztb1pp0013)
14. [ZTB1PP0014 (생산계획 / 생산오더 아이템)](#ztb1pp0014)
15. [ZTB1PP0015 (전처리 내역)](#ztb1pp0015)

---

## 1. ZTB1PP0001 (PIR 데이터 테이블) <a id="ztb1pp0001"></a>
* **모듈명**: PP
* **테이블명**: ZTB1PP0001
* **설명**: PIR 데이터 테이블 (CBO. 생산 계획 수립에 사용. PBIM + PBED)
* **작성자 / 작성일**: 엄영욱 / 2026.04.01

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | MATNR | X | 자재 ID | ZEB1_MM_MATNR | ZDB1_MM_MATNR | CHAR | 40 | Check Table: ZTB1MM0001 / MM |
| 3 | WERKS | X | 플랜트 번호 | ZEB1_MM_WERKS | ZDB1_MM_WERKS | CHAR | 4 | Check Table: ZTB1MM0000 / MM |
| 4 | PIR_VER | X | PIR 버전 | ZEB1_PP_PIR_VER | ZDB1_PP_PIR_VER | CHAR | 2 | |
| 5 | REQ_DATE | X | 수요 발생 일자 | ZEB1_PP_REQ_DATE | ZDB1_PP_REQ_DATE | DATS | 8 | |
| 6 | REQ_QTY | | 수요 수량 | ZEB1_PP_REQ_QTY | ZDB1_PP_REQ_QTY | QUAN | 13,3 | |
| 7 | REQ_UNIT | | 수요 단위 | ZEB1_PP_REQ_UNIT | ZDB1_PP_REQ_UNIT | UNIT | 3 | |
| 8 | REMARK | | 메모 | ZEB1_PP_REMARK | ZDB1_PP_REMARK | CHAR | 100 | |
| 9 | LVORM | | 삭제 표시 | ZEB1_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 10 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 11 | ERDAT | | 생성일자 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 12 | ERZET | | 생성시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 13 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 14 | AEDAT | | 변경일자 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 15 | AEZET | | 변경시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 2. ZTB1PP0002 (STKO) <a id="ztb1pp0002"></a>
* **모듈명**: PP
* **테이블명**: ZTB1PP0002
* **설명**: BOM 헤더. 공정 수율 저장
* **작성자 / 작성일**: 엄영욱 / 2026.04.07

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | STLNR | X | BOM 고유 ID | ZEB1_PP_STLNR | ZDB1_PP_STLNR | CHAR | 8 | |
| 3 | BOMVE | X | BOM 버전 | ZEB1_PP_BOMVE | ZDB1_PP_BOMVE | CHAR | 4 | 계절 비교 코드 |
| 4 | MATNR | | 자재 ID | ZEB1_MM_MATNR | ZDB1_MM_MATNR | CHAR | 40 | Check Table: ZTB1MM0001 / MM |
| 5 | WERKS | | 플랜트 ID | ZEB1_MM_WERKS | ZDB1_MM_WERKS | CHAR | 4 | Check Table: ZTB1MM0000 / MM |
| 6 | DATUV | | 적용 시작일 | ZEB1_PP_DATUV | ZDB1_PP_DATS | DATS | 8 | |
| 7 | DATUB | | 적용 종료일 | ZEB1_PP_DATUB | ZDB1_PP_DATS | DATS | 8 | |
| 8 | BMENG | | BOM 기준 수량 | ZEB1_PP_BMENG | ZDB1_PP_QTY | QUAN | 13,3 | |
| 9 | BMEIN | | BOM 기준 단위 | ZEB1_PP_BMEIN | ZDB1_PP_UNIT | UNIT | 3 | |
| 10 | LVORM | | 삭제 표시 | ZEB1_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 11 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 12 | ERDAT | | 생성일자 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 13 | ERZET | | 생성시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 14 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 15 | AEDAT | | 변경일자 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 16 | AEZET | | 변경시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 3. ZTB1PP0003 (STPO) <a id="ztb1pp0003"></a>
* **모듈명**: PP
* **테이블명**: ZTB1PP0003
* **설명**: BOM 아이템. 공정 수율 상세 저장
* **작성자 / 작성일**: 엄영욱 / 2026.04.07

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | STLNR | X | 부모 BOM 고유 ID | ZEB1_PP_STLNR | ZDB1_PP_STLNR | CHAR | 8 | Check Table: ZTB1PP0011 |
| 3 | STLKN | X | BOM Node 번호 | ZEB1_PP_STLKN | ZDB1_PP_STLKN | NUMC | 8 | Check Table: ZTB1PP0012 |
| 4 | BOMVE | X | BOM 버전 | ZEB1_PP_BOMVE | ZDB1_PP_BOMVE | CHAR | 4 | |
| 5 | MATNR | | 자재 ID | ZEB1_MM_MATNR | ZDB1_MM_MATNR | CHAR | 40 | Check Table: ZTB1MM0001 |
| 6 | FMENG | | 구성품 필요 수량 | ZEB1_PP_FMENG | ZDB1_PP_QTY | QUAN | 13,3 | |
| 7 | MEINS | | 기준 단위 | ZEB1_PP_MEINS | ZDB1_PP_UNIT | UNIT | 3 | |
| 8 | LVORM | | 삭제 표시 | ZEB1_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 9 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 10 | ERDAT | | 생성일자 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 11 | ERZET | | 생성시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 12 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 13 | AEDAT | | 변경일자 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 14 | AEZET | | 변경시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 4. ZTB1PP0004 (CRMS) <a id="ztb1pp0004"></a>
* **모듈명**: PP
* **테이블명**: ZTB1PP0004
* **설명**: Work Center 마스터
* **작성자 / 작성일**: 엄영욱 / 2026.04.07

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | OBJID | X | WC ID | ZEB1_PP_OBJID | ZDB1_PP_OBJID | NUMC | 8 | |
| 3 | OBJTY | | WC 종류 | ZEB1_PP_OBJTY | ZDB1_PP_OBJTY | CHAR | 2 | |
| 4 | ARBPL | | WC 이름 | ZEB1_PP_ARBPL | ZDB1_PP_ARBPL | CHAR | 8 | |
| 5 | WERKS | | 플랜트 ID | ZEB1_MM_WERKS | ZDB1_MM_WERKS | CHAR | 4 | Check Table: ZTB1MM0000 |
| 6 | BEGDA | | WC 운영 시작일 | ZEB1_PP_BEGDA | ZDB1_PP_DATS | DATS | 8 | |
| 7 | ENDDA | | WC 운영 종료일 | ZEB1_PP_ENDDA | ZDB1_PP_DATS | DATS | 8 | |
| 8 | KOSTL | | Cost Center | ZEB1_CO_KOSTL | ZEB1_CO_KOSTL | CHAR | 10 | |
| 9 | AZMIN | | 설비 최소 처리 능력 | ZEB1_PP_AZMIN | ZDB1_PP_AZMIN | INT2 | 5 | |
| 10 | AZNOR | | 설비 표준 처리 능력 | ZEB1_PP_AZNOR | ZDB1_PP_AZNOR | INT2 | 5 | |
| 11 | AZMAX | | 설비 한계 처리 한계 | ZEB1_PP_AZMAX | ZDB1_PP_AZMAX | INT2 | 5 | |
| 12 | KAPEH | | 설비 처리 능력 단위 | ZEB1_PP_KAPEH | ZDB1_PP_UNIT | UNIT | 3 | |
| 13 | LVORM | | 삭제 표시 | ZEB1_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 14 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 15 | ERDAT | | 생성일자 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 16 | ERZET | | 생성시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 17 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 18 | AEDAT | | 변경일자 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 19 | AEZET | | 변경시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 5. ZTB1PP0005 (CRSC) <a id="ztb1pp0005"></a>
* **모듈명**: PP
* **테이블명**: ZTB1PP0005
* **설명**: Work Center의 실제 운영 스케줄 관리 (단위 시간 단위 재배치 가능)
* **작성자 / 작성일**: 엄영욱 / 2026.04.07

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | OBJID | X | WC ID | ZEB1_PP_OBJID | ZDB1_PP_OBJID | NUMC | 8 | Check Table: ZTB1PP_CRMS |
| 3 | STRTS | X | 시작 Timestamp | ZEB1_PP_STRTS | ZDB1_PP_TSTMP | DEC | 15 | YYYYMMDDHHMMSS |
| 4 | ENDTS | | 종료 Timestamp | ZEB1_PP_ENDTS | ZDB1_PP_TSTMP | DEC | 15 | YYYYMMDDHHMMSS |
| 5 | PLPR | | 계획/오더 번호 | ZEB1_PP_PLPR | ZDB1_PP_PLPR | NUMC | 10 | Check Table: ZTB1PP_PLPR |
| 6 | LOADQ | | 배정 처리능력 | ZEB1_PP_LOADQ | ZDB1_PP_QTY | QUAN | 13,3 | |
| 7 | LOADU | | 처리능력 단위 | ZEB1_PP_LOADU | ZDB1_PP_UNIT | UNIT | 3 | |
| 8 | STATUS | | 설비 상태 | ZEB1_PP_STATUS | ZDB1_PP_STATUS | CHAR | 10 | RUN / DOWN / BOOST |
| 9 | LOGID | | 이벤트 로그 FK | ZEB1_PP_LOGID | ZDB1_PP_LOGID | NUMC | 10 | 장애/재배치 기록 |
| 10 | LVORM | | 삭제 표시 | ZEB1_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 11 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 12 | ERDAT | | 생성일자 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 13 | ERZET | | 생성시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 14 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 15 | AEDAT | | 변경일자 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 16 | AEZET | | 변경시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 6. ZTB1PP0006 (CRHS) <a id="ztb1pp0006"></a>
* **모듈명**: PP
* **테이블명**: ZTB1PP0006
* **설명**: Work Center 이벤트 헤더
* **작성자 / 작성일**: 엄영욱 / 2026.04.07

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | Check Table: T000 |
| 2 | LOGID | X | 이벤트 ID | ZEB1_PP_LOGID | ZDB1_PP_LOGID | NUMC | 10 | 이벤트 번호 |
| 3 | EVTIM | | 이벤트 Timestamp | ZEB1_PP_ENDTS | ZDB1_PP_TSTMP | DEC | 15 | YYYYMMDDHHMMSS |
| 4 | EVNTY | | 이벤트 유형 | ZEB1_PP_EVNTY | ZDB1_PP_EVNTY | CHAR | 10 | DOWN / BOOST / REALLOCATE |
| 5 | SCOBJ | | 원 설비 | ZEB1_PP_SCOBJ | ZDB1_PP_OBJID | NUMC | 8 | Check Table: ZTB1PP_CRMS |
| 6 | TQUAN | | 이동 총량 | ZEB1_PP_TQUAN | ZDB1_PP_QTY | QUAN | 13,3 | |
| 7 | UNIT | | 이동 단위 | ZEB1_PP_UNIT | ZDB1_PP_UNIT | UNIT | 3 | Check Table: T006 |
| 8 | REASON | | 장애 사유 | ZEB1_PP_REASON | ZDB1_PP_REMARK | CHAR | 100 | |
| 9 | LVORM | | 삭제 표시 | ZEB1_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 10 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 11 | ERDAT | | 생성일자 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 12 | ERZET | | 생성시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 13 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 14 | AEDAT | | 변경일자 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 15 | AEZET | | 변경시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 7. ZTB1PP0007 (CRHI) <a id="ztb1pp0007"></a>
* **모듈명**: PP
* **테이블명**: ZTB1PP0007
* **설명**: Work Center 이벤트 아이템
* **작성자 / 작성일**: 엄영욱 / 2026.04.07

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | - | CLNT | 3 | Check Table: T000 |
| 2 | LOGID | X | 이벤트 ID | ZEB1_PP_LOGID | ZDB1_PP_LOGID | NUMC | 10 | Check Table: ZTB1PP0006 / 이벤트 FK |
| 3 | ITEM_NO | X | 아이템 번호 | ZEB1_PP_ITEM_NO | ZDB1_PP_ITEM_NO | NUMC | 4 | |
| 4 | FROBJ | | 원 설비 | ZEB1_PP_FROBJ | ZDB1_PP_OBJID | NUMC | 8 | Check Table: ZTB1PP0006 |
| 5 | TOOBJ | | 대상 설비 | ZEB1_PP_TOOBJ | ZDB1_PP_OBJID | NUMC | 8 | Check Table: ZTB1PP0006 |
| 6 | MVQTY | | 이동 처리량 | ZEB1_PP_MVQTY | ZDB1_PP_QTY | QUAN | 13,3 | |
| 7 | MVUNT | | 단위 | ZEB1_PP_MVUNT | ZDB1_PP_UNIT | UNIT | 3 | Check Table: T006 |
| 8 | LVORM | | 삭제 표시 | ZEB1_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 9 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 10 | ERDAT | | 생성일자 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 11 | ERZET | | 생성시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 12 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 13 | AEDAT | | 변경일자 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 14 | AEZET | | 변경시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 8. ZTB1PP0008 (PLKO) <a id="ztb1pp0008"></a>
* **모듈명**: PP
* **테이블명**: ZTB1PP0008
* **설명**: CBO. 공정 헤더
* **작성자 / 작성일**: 엄영욱 / 2026.04.07

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | PLNNR | X | 공정 구분 ID | ZEB1_PP_PLNNR | ZDB1_PP_PLNNR | CHAR | 8 | |
| 3 | WERKS | | 플랜트 ID | ZEB1_MM_WERKS | ZDB1_MM_WERKS | CHAR | 4 | Check Table: ZTB1MM0000 / MM |
| 4 | OBJTY | | WC 종류 | ZEB1_PP_OBJTY | ZDB1_PP_OBJTY | CHAR | 2 | |
| 5 | KTEXT | | 공정 설명 | ZEB1_PP_KTEXT | ZDB1_PP_REMARK | CHAR | 100 | |
| 6 | DATUV | | 유효 시작일 | ZEB1_PP_DATUV | ZDB1_PP_DATUV | DATS | 8 | |
| 7 | DATUB | | 유효 종료일 | ZEB1_PP_DATUB | ZDB1_PP_DATUB | DATS | 8 | |
| 8 | LVORM | | 삭제 표시 | ZEB1_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 9 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 10 | ERDAT | | 생성일자 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 11 | ERZET | | 생성시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 12 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 13 | AEDAT | | 변경일자 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 14 | AEZET | | 변경시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 9. ZTB1PP0009 (PLPO) <a id="ztb1pp0009"></a>
* **모듈명**: PP
* **테이블명**: ZTB1PP0009
* **설명**: CBO. 공정 아이템
* **작성자 / 작성일**: 엄영욱 / 2026.04.07

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | PLNNR | X | 공정 부모 번호 | ZEB1_PP_PLNNR | ZDB1_PP_PLNNR | CHAR | 8 | Check Table: ZTB1PPPLKO |
| 3 | PLNKN | X | 공정 상세 번호 | ZEB1_PP_PLNKN | ZDB1_PP_PLNKN | NUMC | 8 | 상세 공정간 구분 |
| 4 | PLNVE | X | 공정 버전 | ZEB1_PP_PLNVE | ZDB1_PP_PLNVE | CHAR | 4 | |
| 5 | LTXA1 | | 공정 짧은 설명 | ZEB1_PP_LTXA1 | ZDB1_PP_REMARK | CHAR | 100 | |
| 6 | VORNR | | 공정 순서 번호 | ZEB1_PP_VORNR | ZDB1_PP_VORNR | NUMC | 8 | 공정 순서 |
| 7 | BPHQT | | 공정 기준 수량 | ZEB1_PP_BPHQT | ZDB1_PP_QTY | QUAN | 13,3 | 1000 |
| 8 | BPHUN | | 공정 기준 단위 | ZEB1_PP_BPHUN | ZDB1_PP_UNIT | UNIT | 3 | BPH |
| 9 | PRCST | | 공정 비용 | ZEB1_PP_PRCST | ZDB1_PP_CURR | CURR | 15,2 | 40 |
| 10 | WAERS | | 공정 비용 단위 | ZEB1_PP_WAERS | ZDB1_PP_CUKY | CUKY | 5 | $ |
| 11 | LVORM | | 삭제 표시 | ZEB1_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 12 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 13 | ERDAT | | 생성일자 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 14 | ERZET | | 생성시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 15 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 16 | AEDAT | | 변경일자 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 17 | AEZET | | 변경시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 10. ZTB1PP0010 (PLMZ) <a id="ztb1pp0010"></a>
* **모듈명**: PP
* **테이블명**: ZTB1PP0010
* **설명**: 공정 자재 연결
* **작성자 / 작성일**: 엄영욱 / 2026.04.07

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | PLNNR | X | 공정 부모 번호 | ZEB1_PP_PLNNR | ZDB1_PP_PLNNR | CHAR | 8 | Check Table: ZTB1PP0008 |
| 3 | PLNKN | X | 공정 상세 번호 | ZEB1_PP_PLNKN | ZDB1_PP_PLNKN | NUMC | 8 | Check Table: ZTB1PP0009 |
| 4 | MATNR | X | 자재 ID | ZEB1_MM_MATNR | ZDB1_MM_MATNR | CHAR | 40 | |
| 5 | FLWTY | X | 흐름 방향 | ZEB1_PP_FLWTY | ZDB1_PP_FLWTY | CHAR | 1 | I / O |
| 6 | REMARK | | 메모 | ZEB1_PP_REMARK | ZDB1_PP_REMARK | CHAR | 100 | |
| 7 | LVORM | | 삭제 표시 | ZEB1_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 8 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 9 | ERDAT | | 생성일자 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 10 | ERZET | | 생성시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 11 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 12 | AEDAT | | 변경일자 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 13 | AEZET | | 변경시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 11. ZTB1PP0011 (MDKP) <a id="ztb1pp0011"></a>
* **모듈명**: PP
* **테이블명**: ZTB1PP0011
* **설명**: MRP 헤더
* **작성자 / 작성일**: 엄영욱 / 2026.04.07

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | MRPNR | X | MRP ID | ZEB1_PP_MRPNR | ZDB1_PP_MRPNR | NUMC | 10 | |
| 3 | PLWRK | | 플랜트 번호 | ZEB1_PP_PLWRK | ZDB1_MM_WERKS | CHAR | 4 | Check Table: ZTB1MM0000 / MM |
| 4 | RUNTS | | 실행시간 timestamp | ZEB1_PP_RUNTS | ZDB1_PP_TSTMP | DEC | 15 | |
| 5 | RNTYP | | 실행 유형 | ZEB1_PP_RNTYP | ZDB1_PP_RNTYP | CHAR | 10 | FULL / NET / SIM / MAN / AUTO |
| 6 | PLNVE | | 계획 버전 | ZEB1_PP_PLNVE | ZDB1_PP_PLNVE | CHAR | 4 | |
| 7 | STATUS | | 실행 상태 | ZEB1_PP_STATUS | ZDB1_PP_STATUS | CHAR | 10 | |
| 8 | REMARK | | 비고 | ZEB1_PP_REMARK | ZDB1_PP_REMARK | CHAR | 100 | |
| 9 | LVORM | | 삭제 표시 | ZEB1_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 10 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 11 | ERDAT | | 생성일자 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 12 | ERZET | | 생성시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 13 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 14 | AEDAT | | 변경일자 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 15 | AEZET | | 변경시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 12. ZTB1PP0012 (MDPO) <a id="ztb1pp0012"></a>
* **모듈명**: PP
* **테이블명**: ZTB1PP0012
* **설명**: MRP 아이템
* **작성자 / 작성일**: 엄영욱 / 2026.04.07

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | MRPNR | X | MRP 실행 ID | ZEB1_PP_MRPNR | ZDB1_PP_MRPNR | NUMC | 10 | Check Table: ZTB1PPMDKP |
| 3 | MRPKN | X | MRP 노드 번호 | ZEB1_PP_MRPKN | ZDB1_PP_MRPKN | NUMC | 4 | |
| 4 | PRMRP | | 부모 노드 | ZEB1_PP_PRMRP | ZDB1_PP_MRPKN | NUMC | 8 | |
| 5 | MATNR | | 자재 ID | ZEB1_MM_MATNR | ZDB1_MM_MATNR | CHAR | 40 | Check Table: ZTB1MM0001 |
| 6 | RQDAT | | 필요 일자 | ZEB1_PP_RQDAT | ZDB1_PP_DATS | DATS | 8 | |
| 7 | RQQTY | | 필요 수량 | ZEB1_PP_RQQTY | ZDB1_PP_QTY | QUAN | 13,3 | |
| 8 | RQUNT | | 수량 단위 | ZEB1_PP_RQUNT | ZDB1_PP_UNIT | UNIT | 3 | |
| 9 | ORDTY | | MRP 요소 유형 | ZEB1_PP_ORDTY | ZDB1_PP_ORDTY | CHAR | 10 | |
| 10 | PLPR | | 계획/오더 번호 | ZEB1_PP_PLPR | ZDB1_PP_PLPR | NUMC | 10 | Check Table: ZTB1PPPLPR |
| 11 | LVORM | | 삭제 표시 | ZEB1_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 12 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 13 | ERDAT | | 생성일자 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 14 | ERZET | | 생성시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 15 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 16 | AEDAT | | 변경일자 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 17 | AEZET | | 변경시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 13. ZTB1PP0013 (PLPR) <a id="ztb1pp0013"></a>
* **모듈명**: PP
* **테이블명**: ZTB1PP0013
* **설명**: 생산계획 / 생산오더 헤더
* **작성자 / 작성일**: 엄영욱 / 2026.04.23

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | PLPR | X | 계획/오더 번호 | ZEB1_PP_PLPR | ZDB1_PP_PLPR | NUMC | 10 | |
| 3 | PLNTY | X | 계획/오더 구분 | ZEB1_PP_PLNTY | ZDB1_PP_PLNTY | CHAR | 4 | PLN / ORD |
| 4 | WERKS | | 플랜트 | ZEB1_MM_WERKS | ZDB1_MM_WERKS | CHAR | 4 | |
| 5 | MATNR | | 자재 ID | ZEB1_MM_MATNR | ZDB1_MM_MATNR | CHAR | 40 | Check Table: ZTB1MM0001 / MM |
| 6 | ORQTY | | 생산 수량 | ZEB1_PP_ORQTY | ZDB1_PP_QTY | QUAN | 13,3 | |
| 7 | ORUNT | | 수량 단위 | ZEB1_PP_ORUNT | ZDB1_PP_UNIT | UNIT | 3 | |
| 8 | SDATE | | 시작일 | ZEB1_PP_SDATE | ZDB1_PP_DATS | CHAR | 8 | |
| 9 | PEDAT | | 종료 예정일 | ZEB1_PP_PEDAT | ZDB1_PP_DATS | DATS | 8 | |
| 10 | EDATE | | 종료일 | ZEB1_PP_EDATE | ZDB1_PP_DATS | DATS | 8 | 실제 종료일 |
| 11 | PLNVE | | 계획 버전 | ZEB1_PP_PLNVE | ZDB1_PP_PLNVE | CHAR | 4 | |
| 12 | STLNR | | 참조 BOM ID | ZEB1_PP_STLNR | ZDB1_PP_STLNR | CHAR | 8 | Check Table: ZTB1PPSTKO / 선택된 BOM |
| 13 | BOMVE | | 참조 BOM 버전 | ZEB1_PP_BOMVE | ZDB1_PP_BOMVE | CHAR | 4 | Check Table: ZTB1PPSTKO / 선택된 BOM 버전 |
| 14 | PLNNR | | 참조 공정 ID | ZEB1_PP_PLNNR | ZDB1_PP_PLNNR | CHAR | 8 | Check Table: ZTB1PP_PLKO / 선택된 공정 |
| 15 | REMARK | | 비고 | ZEB1_PP_REMARK | ZDB1_PP_REMARK | CHAR | 100 | |
| 16 | LVORM | | 삭제 표시 | ZEB1_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 17 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 18 | ERDAT | | 생성일자 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 19 | ERZET | | 생성시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 20 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 21 | AEDAT | | 변경일자 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 22 | AEZET | | 변경시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 14. ZTB1PP0014 (PLRI) <a id="ztb1pp0014"></a>
* **모듈명**: PP
* **테이블명**: ZTB1PP0014
* **설명**: 생산계획 / 생산오더 아이템
* **작성자 / 작성일**: 엄영욱 / 2026.04.23

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | PLPR | X | 계획/오더 번호 | ZEB1_PP_PLPR | ZDB1_PP_PLPR | NUMC | 10 | Check Table: ZTB1PP0013 / FK |
| 3 | PLNTY | X | 계획/오더 구분 | ZEB1_PP_PLNTY | ZDB1_PP_PLNTY | CHAR | 4 | PLN / ORD |
| 4 | PLPKN | X | PLPR 아이템 번호 | ZEB1_PP_PLPKN | ZDB1_PP_PLPKN | NUMC | 4 | 00000001~ |
| 5 | PLNNR | | 공정 ID | ZEB1_PP_PLNNR | ZDB1_PP_PLNNR | CHAR | 8 | Check Table: ZTB1PP_PLKO / 공정 참조 시 |
| 6 | PLNKN | | 공정 상세 번호 | ZEB1_PP_PLNKN | ZDB1_PP_PLNKN | NUMC | 8 | Check Table: ZTB1PP_PLPO / 공정 Item 참조 |
| 7 | VORNR | | 공정 순서 번호 | ZEB1_PP_VORNR | ZDB1_PP_VORNR | NUMC | 8 | Operation No |
| 8 | MATNR | | 산출 자재 ID | ZEB1_MM_MATNR | ZDB1_MM_MATNR | CHAR | 40 | Check Table: ZTB1MM0001 / MM |
| 9 | POQTY | | 예측 생산 수량 | ZEB1_PP_POQTY | ZDB1_PP_QTY | QUAN | 13,3 | |
| 10 | MEINS | | 단위 | ZEB1_PP_MEINS | ZDB1_PP_MEINS | UNIT | 3 | |
| 11 | DATUV | | 적용 시작일 | ZEB1_PP_DATUV | ZDB1_PP_DATUV | DATS | 8 | |
| 12 | REMARK | | 비고 | ZEB1_PP_REMARK | ZDB1_PP_REMARK | CHAR | 100 | |
| 13 | LVORM | | 삭제 표시 | ZEB1_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 14 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 15 | ERDAT | | 생성일자 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 16 | ERZET | | 생성시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 17 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 18 | AEDAT | | 변경일자 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 19 | AEZET | | 변경시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |

---

## 15. ZTB1PP0015 (PREP) <a id="ztb1pp0015"></a>
* **모듈명**: PP
* **테이블명**: ZTB1PP0015
* **설명**: 전처리 내역 저장 (Pre Process)
* **작성자 / 작성일**: 엄영욱 / 2026.04.07

| 번호 | 필드명 | KEY | Description | Data Element | Domain | Type | 길이 | 비고 |
|:---:|:---|:---:|:---|:---|:---|:---:|:---:|:---|
| 1 | MANDT | X | 클라이언트 | MANDT | MANDT | CLNT | 3 | |
| 2 | RUNID | X | 탈염 실행 ID | ZEB1_PP_RUNID | ZDB1_PP_RUNID | NUMC | 10 | |
| 3 | MATNR | | 원유 자재 | ZEB1_MM_MATNR | ZDB1_MM_MATNR | CHAR | 40 | |
| 4 | WERKS | | 플랜트 | ZEB1_MM_WERKS | ZDB1_MM_WERKS | CHAR | 4 | |
| 5 | LGORT | | 저장위치 | ZEB1_PP_LGORT | ZDB1_MM_LGORT | CHAR | 4 | |
| 6 | PREQT | | 탈염 수량 | ZEB1_PP_PREQT | ZDB1_PP_QTY | QUAN | 13,3 | |
| 7 | MEINS | | 단위 | ZEB1_PP_MEINS | ZDB1_PP_UNIT | UNIT | 3 | |
| 8 | RNDAT | | 탈염 실행일 | ZEB1_PP_RNDAT | ZDB1_PP_DATS | DATS | 8 | |
| 9 | AVDAT | | 가용 전환일 | ZEB1_PP_AVDAT | ZDB1_PP_DATS | DATS | 8 | |
| 10 | STATS | | 처리상태 | ZEB1_PP_STATS | ZDB1_PP_STATS | CHAR | 1 | |
| 11 | LVORM | | 삭제 표시 | ZEB1_LVORM | ZDB1_LVORM | CHAR | 1 | |
| 12 | ERNAM | | 생성자 | ZEB1_ERNAM | ZDB1_ERNAM | CHAR | 12 | |
| 13 | ERDAT | | 생성일자 | ZEB1_ERDAT | ZDB1_ERDAT | DATS | 8 | |
| 14 | ERZET | | 생성시간 | ZEB1_ERZET | ZDB1_ERZET | TIMS | 6 | |
| 15 | AENAM | | 변경자 | ZEB1_AENAM | ZDB1_AENAM | CHAR | 12 | |
| 16 | AEDAT | | 변경일자 | ZEB1_AEDAT | ZDB1_AEDAT | DATS | 8 | |
| 17 | AEZET | | 변경시간 | ZEB1_AEZET | ZDB1_AEZET | TIMS | 6 | |
