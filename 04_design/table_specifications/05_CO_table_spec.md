# [Design] CO (관리 회계 - 정유원가) 모듈 테이블 명세서

**최종 수정일**: 2026-07-01  
**상태**: 확정 (Approved)  
**버전**: v1.0

> 💡 **문서 연결 가이드**: 타 문서에서 특정 테이블로 링크를 걸 때는 본 파일 경로 뒤에 `#테이블명` 앵커를 사용  
> *예시: `[공정 계획 비용 테이블 스펙](04_design/05_co_table_spec.md#ztb1co0005)`*

---

## <a id="ztb1co0001"></a>1. ZTB1CO0001 (코스트센터 마스터 테이블)

* **테이블 용도**: 원가 귀속 단위(공정/부서) 관리
* **테이블 유형**: 마스터 테이블

| 번호 | 필드 | PK | FK | Description | Data Element | Domain | Type | 길이 | 비고 |
| :--- | :--- | :-: | :-: | :--- | :--- | :--- | :--- | :-: | :--- |
| 1 | MANDT | X | | 클라이언트 | MANDT | MANDT | CLNT | 3 | 100 |
| 2 | KOKRS | X | | 관리회계영역 | ZEB1_CO_KOKRS | ZDB1_CO_KOKRS | CHAR | 4 | A100 |
| 3 | KOSTL | X | | 코스트센터 | ZEB1_CO_KOSTL | ZDB1_CO_KOSTL | CHAR | 10 | 23종 + a |
| 4 | KOTXT | | | 코스트센터명 | ZEB1_CO_LTEXT | ZDB1_CO_LTEXT | CHAR | 40 | 예: 원유증류비용센터 |
| 5 | WERKS | | X | 플랜트 | ZEB1_MM_WERKS | ZDB1_MM_WERKS | CHAR | 4 | 1000 (CHECK: ZTB1MM0000) |
| 6 | CCTYP | | | 센터유형 | ZEB1_CC_TYPE | ZDB1_CC_TYPE | CHAR | 2 | PR:공정 / AD:관리 |
| 7 | DATAB | | | 유효시작일 | ZEB1_CO_VALIDF | ZDB1_CO_VALIDF | DATS | 8 | 2026-01-01 |
| 8 | DATBI | | | 유효종료일 | ZEB1_CO_VALIDT | ZDB1_CO_VALIDT | DATS | 8 | 9999-12-31 |
| 9 | LVORM | | | 삭제표시 | ZEC2CN_LVORM | ZDB2CN_LVORM | CHAR | 1 | HHMMSS |
| 10 | ERNAM | | | 작성자 | ZCC_ERNAM | ZDB_ERNAM | CHAR | 12 | (사용자 이름(ID)) |
| 11 | ERDAT | | | 작성일 | ZCC_ERDAT | ZDB_ERDAT | DATS | 8 | YYYYMMDD |
| 12 | ERZET | | | 작성시간 | ZCC_ERZET | ZDB_ERZET | TIMS | 6 | HHMMSS |
| 13 | AENAM | | | 변경자 | ZCC_AENAM | ZDB_AENAM | CHAR | 12 | (사용자 이름(ID)) |
| 14 | AEDAT | | | 변경일 | ZCC_AEDAT | ZDB_AEDAT | DATS | 8 | YYYYMMDD |
| 15 | AEZET | | | 변경시간 | ZCC_AEZET | ZDB_AEZET | TIMS | 6 | HHMMSS |

---

## <a id="ztb1co0002"></a>2. ZTB1CO0002 (손익센터 마스터 테이블)

* **테이블 용도**: 제품/사업영역별 손익 귀속 단위 관리
* **테이블 유형**: 마스터 테이블

| 번호 | 필드 | PK | FK | Description | Data Element | Domain | Type | 길이 | 비고 |
| :--- | :--- | :-: | :-: | :--- | :--- | :--- | :--- | :-: | :--- |
| 1 | MANDT | X | | 클라이언트 | MANDT | MANDT | CLNT | 3 | 100 |
| 2 | KOKRS | X | | 관리회계영역 | ZEB1_CO_KOKRS | ZDB1_CO_KOKRS | CHAR | 4 | A100 |
| 3 | ZPRCTR | X | | 손익센터 | ZEB1_CO_PRCTR | ZDB1_CO_PRCTR | CHAR | 20 | 10종 + a |
| 4 | PRTXT | | | 손익센터명 | ZEB1_CO_LTEXT | ZDB1_CO_LTEXT | CHAR | 40 | |
| 5 | WERKS | | X | 플랜트 | ZEB1_MM_WERKS | ZDB1_MM_WERKS | CHAR | 4 | 1000 (CHECK: ZTB1MM0000) |
| 6 | PRDGP | | X | 제품군 | ZEB1_SD_SPART | ZDB1_SD_SPART | CHAR | 2 | 00, 10, 20, 30 (CHECK: ZTB1MM0001) |
| 7 | SEGMT | | | 세그먼트 | ZEB1_CO_SEGMENT | ZDB1_CO_SEGMENT | CHAR | 10 | REFINE, SALES 등 |
| 8 | PCTYP | | | 손익센터유형 | ZEB1_CO_OWNER | ZDB1_CO_OWNER | CHAR | 2 | PD:제품 / SV:서비스 |
| 9 | DATAB | | | 유효시작일 | ZEB1_CO_VALIDF | ZDB1_CO_VALIDF | DATS | 8 | 2026-01-01 |
| 10 | DATBI | | | 유효종료일 | ZEB1_CO_VALIDT | ZDB1_CO_VALIDT | DATS | 8 | 9999-12-31 |
| 11 | LVORM | | | 삭제표시 | ZEC2CN_LVORM | ZDB2CN_LVORM | CHAR | 1 | HHMMSS |
| 12 | ERNAM | | | 작성자 | ZCC_ERNAM | ZDB_ERNAM | CHAR | 12 | (사용자 이름(ID)) |
| 13 | ERDAT | | | 작성일 | ZCC_ERDAT | ZDB_ERDAT | DATS | 8 | YYYYMMDD |
| 14 | ERZET | | | 작성시간 | ZCC_ERZET | ZDB_ERZET | TIMS | 6 | HHMMSS |
| 15 | AENAM | | | 변경자 | ZCC_AENAM | ZDB_AENAM | CHAR | 12 | (사용자 이름(ID)) |
| 16 | AEDAT | | | 변경일 | ZCC_AEDAT | ZDB_AEDAT | DATS | 8 | YYYYMMDD |
| 17 | AEZET | | | 변경시간 | ZCC_AEZET | ZDB_AEZET | TIMS | 6 | HHMMSS |

---

## <a id="ztb1co0003"></a>3. ZTB1CO0003 (공정 마스터 테이블)

* **테이블 용도**: CO 해석용 공정/단계/기본 귀속 정보 관리
* **테이블 유형**: 마스터 테이블

| 번호 | 필드 | PK | FK | Description | Data Element | Domain | Type | 길이 | 비고 |
| :--- | :--- | :-: | :-: | :--- | :--- | :--- | :--- | :-: | :--- |
| 1 | MANDT | X | | 클라이언트 | MANDT | MANDT | CLNT | 3 | A100 |
| 2 | KOKRS | X | | 관리회계영역 | ZEB1_CO_KOKRS | ZDB1_CO_KOKRS | CHAR | 4 | A100 |
| 3 | WERKS | X | X | 플랜트 | ZEB1_MM_WERKS | ZDB1_MM_WERKS | CHAR | 4 | 1000 (CHECK: ZTB1MM0000) |
| 4 | PRCID | X | X | 공정ID | ZEB1_PP_PLNNR | ZDB1_PP_PLNNR | CHAR | 10 | (CHECK: ZTB1PP0008) |
| 5 | PRCNM | | | 공정명 | ZEB1_CO_PROCNAME | ZDB1_CO_PROCNAME | CHAR | 40 | |
| 6 | PRCST | | | 공정단계 | ZEB1_CO_STAGE | ZDB1_CO_STAGE | CHAR | 2 | 1차/2차 |
| 7 | PPRID | | | 상위공정ID | ZEB1_PP_PLNNR | ZDB1_PP_PLNNR | CHAR | 10 | 상위공정 참조 |
| 8 | KOSTL | | X | 코스트센터 | ZEB1_CO_KOSTL | ZDB1_CO_KOSTL | CHAR | 4 | A100 (CHECK: ZTB1CO0001) |
| 9 | ZPRCTR | | X | 손익센터 | ZEB1_CO_PRCTR | ZDB1_CO_PRCTR | CHAR | 20 | 예: FUEL_PC (CHECK: ZTB1CO0002) |
| 10 | OUTST | | | 산출물단계 | ZEB1_CO_FSTAGE | ZDB1_CO_FSTAGE | CHAR | 2 | RM/SF/FG |
| 11 | DATAB | | | 유효시작일 | ZEB1_CO_VALIDF | ZDB1_CO_VALIDF | DATS | 8 | 2026-01-01 |
| 12 | DATBI | | | 유효종료일 | ZEB1_CO_VALIDT | ZDB1_CO_VALIDT | DATS | 8 | 9999-12-31 |
| 13 | STATU | | | 상태 | ZEB1_CO_STATUS | ZDB1_CO_STATUS | CHAR | 1 | A/I |
| 14 | LVORM | | | 삭제표시 | ZEC2CN_LVORM | ZDB2CN_LVORM | CHAR | 1 | HHMMSS |
| 15 | ERNAM | | | 작성자 | ZCC_ERNAM | ZDB_ERNAM | CHAR | 12 | (사용자 이름(ID)) |
| 16 | ERDAT | | | 작성일 | ZCC_ERDAT | ZDB_ERDAT | DATS | 8 | YYYYMMDD |
| 17 | ERZET | | | 작성시간 | ZCC_ERZET | ZDB_ERZET | TIMS | 6 | HHMMSS |
| 18 | AENAM | | | 변경자 | ZCC_AENAM | ZDB_AENAM | CHAR | 12 | (사용자 이름(ID)) |
| 19 | AEDAT | | | 변경일 | ZCC_AEDAT | ZDB_AEDAT | DATS | 8 | YYYYMMDD |
| 20 | AEZET | | | 변경시간 | ZCC_AEZET | ZDB_AEZET | TIMS | 6 | HHMMSS |

---

## <a id="ztb1co0004"></a>4. ZTB1CO0004 (원가분류/계정 매핑 테이블)

* **테이블 용도**: FI 계정과 CO 원가요소/포함여부 분류 관리
* **테이블 유형**: 마스터 테이블

| 번호 | 필드 | PK | FK | Description | Data Element | Domain | Type | 길이 | 비고 |
| :--- | :--- | :-: | :-: | :--- | :--- | :--- | :--- | :-: | :--- |
| 1 | MANDT | X | | 클라이언트 | MANDT | MANDT | CLNT | 3 | A100 |
| 2 | KSTAR | X | X | 원가요소(계정) | ZEB1_FI_HKONT | ZDB1_FI_HKONT | CHAR | 10 | 예: 510001 (CHECK: ZTB1FI0005) |
| 3 | DATAB | X | | 유효시작일 | ZEB1_CO_VALIDF | ZDB1_CO_VALIDF | DATS | 8 | 2026-01-01 |
| 4 | ELENM | | | 원가요소명 | ZEB1_CO_KSTXT | ZDB1_CO_KSTXT | CHAR | 40 | 예: 원유비/유틸리티비 |
| 5 | ELTYP | | | 유형 | ZEB1_CO_ELTYPE | ZDB1_CO_ELTYPE | CHAR | 2 | PR:1차 / SC:2차 |
| 6 | CSTCL | | | 비용분류 | ZEB1_CO_CLASS | ZDB1_CO_CLASS | CHAR | 12 | RAW/PROC/OH/SELL |
| 7 | ALOCY | | | 배부가능여부 | ZEB1_CO_ALLOC | ZDB1_CO_ALLOC | CHAR | 1 | Y/N |
| 8 | MFGYN | | | 제조원가포함 | ZEB1_CO_INCL | ZDB1_CO_INCL | CHAR | 1 | Y/N |
| 9 | ALCBS | | | 배부기준 | ZEB1_CO_ALLBS | ZDB1_CO_ALLBS | CHAR | 12 | QTY/HOUR/AMT |
| 10 | DATBI | | | 유효종료일 | ZEB1_CO_VALIDT | ZDB1_CO_VALIDT | DATS | 8 | 9999-12-31 |
| 11 | LVORM | | | 삭제표시 | ZEC2CN_LVORM | ZDB2CN_LVORM | CHAR | 1 | HHMMSS |
| 12 | ERNAM | | | 작성자 | ZCC_ERNAM | ZDB_ERNAM | CHAR | 12 | (사용자 이름(ID)) |
| 13 | ERDAT | | | 작성일 | ZCC_ERDAT | ZDB_ERDAT | DATS | 8 | YYYYMMDD |
| 14 | ERZET | | | 작성시간 | ZCC_ERZET | ZDB_ERZET | TIMS | 6 | HHMMSS |
| 15 | AENAM | | | 변경자 | ZCC_AENAM | ZDB_AENAM | CHAR | 12 | (사용자 이름(ID)) |
| 16 | AEDAT | | | 변경일 | ZCC_AEDAT | ZDB_AEDAT | DATS | 8 | YYYYMMDD |
| 17 | AEZET | | | 변경시간 | ZCC_AEZET | ZDB_AEZET | TIMS | 6 | HHMMSS |

---

## <a id="ztb1co0005"></a>5. ZTB1CO0005 (공정 계획 비용 테이블)

* **테이블 용도**: 공정 계획에 따라 발생한 비용 총망라 테이블
* **테이블 유형**: 결과 테이블

| 번호 | 필드 | PK | FK | Description | Data Element | Domain | Type | 길이 | 비고 |
| :--- | :--- | :-: | :-: | :--- | :--- | :--- | :--- | :-: | :--- |
| 1 | MANDT | X | | 클라이언트 | MANDT | MANDT | CLNT | 3 | A100 |
| 2 | PLNNO | X | X | 계획/오더 번호 | ZEB1_PP_PLPR | ZDB1_PP_PLPR | NUMC | 10 | OR202606001 (CHECK: ZTB1PPPL13) |
| 3 | PLNTY | X | X | 계획/오더 구분 | ZEB1_PP_PLNTY | ZDB1_PP_PLNTY | CHAR | 4 | PL=계획, OR=오더 (CHECK: ZTB1PP0013) |
| 4 | REGDT | X | | 등록일 | ZEB1_CO_VALIDF | ZDB1_CO_VALIDF | DATS | 8 | 2026-06-30 |
| 5 | VERSN | X | | 버전 | ZEB1_CO_VER | ZDB1_CO_VER | CHAR | 3 | 001, 002 |
| 6 | PRCID | X | X | 공정ID | ZEB1_PP_PLNNR | ZDB1_PP_PLNNR | CHAR | 10 | - (CHECK: ZTB1PP0008) |
| 7 | KOSTL | X | X | 코스트센터 | ZEB1_CO_KOSTL | ZDB1_CO_KOSTL | CHAR | 10 | (CHECK: ZTB1CO0001) |
| 8 | ZPRCTR | | X | 손익센터 | ZEB1_CO_PRCTR | ZDB1_CO_PRCTR | CHAR | 20 | (CHECK: ZTB1CO0002) |
| 9 | INMAT | | X | 투입품ID | ZEB1_MM_MATNR | ZDB1_MM_MATNR | CHAR | 18 | CRUDE-001 (CHECK: ZTB1MM0001) |
| 10 | INPRC | | X | 계획 투입품 비용 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15,2 | MM01 평가단가 (CHECK: ZTB1MM0001) |
| 11 | INQTY | | X | 투입량 | ZEB1_CO_QTY | ZDB1_CO_QTY | QUAN | 15,3 | (CHECK: ZTB1PPPL13) |
| 12 | INAMT | | | 계획 투입량 비용 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15,2 | |
| 13 | BCPRC | | X | 계획 BCU 비용 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15,2 | MM01 평가단가 (CHECK: ZTB1MM0001) |
| 14 | BCQTY | | X | 계획 BCU 투입량 | ZEB1_CO_QTY | ZDB1_CO_QTY | QUAN | 15,3 | (CHECK: ZTB1PP0013) |
| 15 | BCAMT | | | 계획 BCU 투입 비용 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15,2 | |
| 16 | ZEPRC | | X | 계획 ZEOL 비용 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15,2 | MM01 평가단가 (CHECK: ZTB1MM0001) |
| 17 | ZEQTY | | X | 계획 ZEOL촉매투입량 | ZEB1_CO_QTY | ZDB1_CO_QTY | QUAN | 15,3 | (CHECK: ZTB1PP0013) |
| 18 | ZEAMT | | | 계획 ZEOL 투입 비용 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15,2 | |
| 19 | NMPRC | | X | 계획 NIMO 비용 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15,2 | MM01 평가단가 (CHECK: ZTB1MM0001) |
| 20 | NMQTY | | X | 계획 NIMO 촉매투입량 | ZEB1_CO_QTY | ZDB1_CO_QTY | QUAN | 15,3 | (CHECK: ZTB1PP0013) |
| 21 | NMAMT | | | 계획 NIMO 투입 비용 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15,2 | |
| 22 | RUNHR | | | 계획가동시간 | ZEB1_CO_RUNTIME | ZDB1_CO_RUNTIME | QUAN | 13,2 | 24H 고정 |
| 23 | HRUNT | | X | 시간 단위 | ZEB1_MM_MEINS | ZDB1_MM_MEINS | UNIT | 3 | HOURS (CHECK: ZTB1MM0001) |
| 24 | PRCAM | | X | 계획 공정 비용 | ZEB1_CO_PRCOST | ZDB1_CO_PRCOST | CURR | 15 | 가동시간×실제단가 (CHECK: ZTB1CO0010) |
| 25 | OUTMT | | X | 결과물ID | ZEB1_MM_MATNR | ZDB1_MM_MATNR | CHAR | 18 | (CHECK: ZTB1MM0001) |
| 26 | OUTQT | | | 산출량 | ZEB1_CO_QTY | ZDB1_CO_QTY | QUAN | 15,3 | |
| 27 | MEINS | | X | 단위 | ZEB1_MM_MEINS | ZDB1_MM_MEINS | UNIT | 3 | BBL, KG (CHECK: ZTB1MM0001) |
| 28 | YDPCT | | | 실적 수율(%) | ZEB1_CO_YIELD | ZDB1_CO_YIELD | DEC | 5,2 | 91.5 |
| 29 | WAERS | | X | 통화 | ZEB1_FI_WAERS | ZDB1_FI_WAERS | CUKY | 5 | KRW (CHECK: ZTB1FI0004) |
| 30 | EXRAT | | X | 계산 당시 환율 | ZEB1_FI_KURSF | ZDB1_FI_KURSF | DEC | 9 | (CHECK: ZTB1FI0007) |
| 31 | ACTYN | | | 활성화 여부 | ZEB1_CO_ACTIV | ZDB1_CO_ACTIV | CHAR | 1 | Y, N |
| 32 | LVORM | | | 삭제표시 | ZEC2CN_LVORM | ZDB2CN_LVORM | CHAR | 1 | X=삭제/공백=정상 |
| 33 | ERNAM | | | 작성자 | ZCC_ERNAM | ZDB_ERNAM | CHAR | 12 | (사용자 이름(ID)) |
| 34 | ERDAT | | | 작성일 | ZCC_ERDAT | ZDB_ERDAT | DATS | 8 | YYYYMMDD |
| 35 | ERZET | | | 작성시간 | ZCC_ERZET | ZDB_ERZET | TIMS | 6 | HHMMSS |
| 36 | AENAM | | | 변경자 | ZCC_AENAM | ZDB_AENAM | CHAR | 12 | (사용자 이름(ID)) |
| 37 | AEDAT | | | 변경일 | ZCC_AEDAT | ZDB_AEDAT | DATS | 8 | YYYYMMDD |
| 38 | AEZET | | | 변경시간 | ZCC_AEZET | ZDB_AEZET | TIMS | 6 | HHMMSS |

---

## <a id="ztb1co0006"></a>6. ZTB1CO0006 (공정 실적 비용 테이블)

* **테이블 용도**: 공정 실적에 따라 발생한 비용 총망라 테이블
* **테이블 유형**: 결과 테이블

| 번호 | 필드 | PK | FK | Description | Data Element | Domain | Type | 길이 | 비고 |
| :--- | :--- | :-: | :-: | :--- | :--- | :--- | :--- | :-: | :--- |
| 1 | MANDT | X | | 클라이언트 | MANDT | MANDT | CLNT | 3 | A100 |
| 2 | PLNNO | X | X | 계획/오더 번호 | ZEB1_PP_PLPR | ZDB1_PP_PLPR | NUMC | 10 | OR202606001 (CHECK: ZTB1PPPL13) |
| 3 | PLNTY | X | X | 계획/오더 구분 | ZEB1_PP_PLNTY | ZDB1_PP_PLNTY | CHAR | 4 | PL=계획, OR=오더 (CHECK: ZTB1PP0013) |
| 4 | REGDT | X | | 등록일 | ZEB1_CO_VALIDF | ZDB1_CO_VALIDF | DATS | 8 | 2026-06-30 |
| 5 | VERSN | X | | 버전 | ZEB1_CO_VER | ZDB1_CO_VER | CHAR | 3 | 001, 002 |
| 6 | PRCID | X | X | 공정ID | ZEB1_PP_PLNNR | ZDB1_PP_PLNNR | CHAR | 10 | - (CHECK: ZTB1PP0008) |
| 7 | KOSTL | X | X | 코스트센터 | ZEB1_CO_KOSTL | ZDB1_CO_KOSTL | CHAR | 10 | (CHECK: ZTB1CO0001) |
| 8 | ZPRCTR | | X | 손익센터 | ZEB1_CO_PRCTR | ZDB1_CO_PRCTR | CHAR | 20 | (CHECK: ZTB1CO0002) |
| 9 | ORGOL | | | 투입된 원유 종류 | ZEB1_CO_VER | ZDB1_CO_VER | CHAR | 18 | |
| 10 | INMAT | | X | 투입품ID | ZEB1_MM_MATNR | ZDB1_MM_MATNR | CHAR | 18 | CRUDE-001 (CHECK: ZTB1MM0001) |
| 11 | INPRC | | X | 투입당시 투입품 비용 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15,2 | MM01 평가단가 (CHECK: ZTB1MM0001) |
| 12 | INQTY | | X | 투입량 | ZEB1_CO_QTY | ZDB1_CO_QTY | QUAN | 15,3 | (CHECK: ZTB1PPPL13) |
| 13 | INAMT | | | 실적 투입량 비용 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15,2 | |
| 14 | BCPRC | | X | 투입당시 BCU 비용 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15,2 | MM01 평가단가 (CHECK: ZTB1MM0001) |
| 15 | BCQTY | | X | 실적 BCU 투입량 | ZEB1_CO_QTY | ZDB1_CO_QTY | QUAN | 15,3 | (CHECK: ZTB1PPPL13) |
| 16 | BCAMT | | | 실적 BCU 투입 비용 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15,2 | |
| 17 | ZEPRC | | X | 투입당시 ZEOL 비용 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15,2 | MM01 평가단가 (CHECK: ZTB1MM0001) |
| 18 | ZEQTY | | X | ZEOL촉매투입량 | ZEB1_CO_QTY | ZDB1_CO_QTY | QUAN | 15,3 | (CHECK: ZTB1PPPL13) |
| 19 | ZEAMT | | | 실적 ZEOL 투입 비용 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15,2 | |
| 20 | NMPRC | | X | 투입당시 NIMO 비용 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15,2 | MM01 평가단가 (CHECK: ZTB1MM0001) |
| 21 | NMQTY | | X | NIMO 촉매투입량 | ZEB1_CO_QTY | ZDB1_CO_QTY | QUAN | 15,3 | (CHECK: ZTB1PPPL13) |
| 22 | NMAMT | | | 실적 NIMO 투입 비용 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15,2 | |
| 23 | RUNHR | | | 실적가동시간 | ZEB1_CO_RUNTIME | ZDB1_CO_RUNTIME | QUAN | 13,2 | 24H 고정 |
| 24 | HRUNT | | X | 시간 단위 | ZEB1_MM_MEINS | ZDB1_MM_MEINS | UNIT | 3 | HOURS (CHECK: ZTB1MM0001) |
| 25 | PRCAM | | X | 실적 공정 비용 | ZEB1_CO_PRCOST | ZDB1_CO_PRCOST | CURR | 15 | 가동시간×실제단가 (CHECK: ZTB1CO0010) |
| 26 | OUTMT | | X | 결과물ID | ZEB1_MM_MATNR | ZDB1_MM_MATNR | CHAR | 18 | (CHECK: ZTB1MM0001) |
| 27 | OUTQT | | | 산출량 | ZEB1_CO_QTY | ZDB1_CO_QTY | QUAN | 15,3 | |
| 28 | MEINS | | X | 단위 | ZEB1_MM_MEINS | ZDB1_MM_MEINS | UNIT | 3 | BBL, KG (CHECK: ZTB1MM0001) |
| 29 | YDPCT | | | 실적 수율(%) | ZEB1_CO_YIELD | ZDB1_CO_YIELD | DEC | 5,2 | 91.5 |
| 30 | WAERS | | X | 통화 | ZEB1_FI_WAERS | ZDB1_FI_WAERS | CUKY | 5 | KRW (CHECK: ZTB1FI0004) |
| 31 | EXRAT | | X | 계산 당시 환율 | ZEB1_FI_KURSF | ZDB1_FI_KURSF | DEC | 9 | (CHECK: ZTB1FI0007) |
| 32 | ACTYN | | | 활성화 여부 | ZEB1_CO_ACTIV | ZDB1_CO_ACTIV | CHAR | 1 | Y, N |
| 33 | LVORM | | | 삭제표시 | ZEC2CN_LVORM | ZDB2CN_LVORM | CHAR | 1 | X=삭제/공백=정상 |
| 34 | ERNAM | | | 작성자 | ZCC_ERNAM | ZDB_ERNAM | CHAR | 12 | (사용자 이름(ID)) |
| 35 | ERDAT | | | 작성일 | ZCC_ERDAT | ZDB_ERDAT | DATS | 8 | YYYYMMDD |
| 36 | ERZET | | | 작성시간 | ZCC_ERZET | ZDB_ERZET | TIMS | 6 | HHMMSS |
| 37 | AENAM | | | 변경자 | ZCC_AENAM | ZDB_AENAM | CHAR | 12 | (사용자 이름(ID)) |
| 38 | AEDAT | | | 변경일 | ZCC_AEDAT | ZDB_AEDAT | DATS | 8 | YYYYMMDD |

---

## <a id="ztb1co0007"></a>7. ZTB1CO0007 (반제품/완제품 원가 테이블)

* **테이블 용도**: 생산품 또는 반제품의 원가를 공정별 계획/실적 기준으로 저장
* **테이블 유형**: 결과 테이블

| 번호 | 필드 | PK | FK | Description | Data Element | Domain | Type | 길이 | 비고 |
| :--- | :--- | :-: | :-: | :--- | :--- | :--- | :--- | :-: | :--- |
| 1 | MANDT | X | | 클라이언트 | MANDT | MANDT | CLNT | 3 | 100 |
| 2 | CSTID | X | | 원가ID | ZEB1_CO_COSTID | ZDB1_CO_COSTID | CHAR | 14 | CST2026060001 |
| 3 | CSTDT | X | | 원가기준일 | ZEB1_CO_SCSTDT | ZDB1_CO_SCSTDT | DATS | 8 | |
| 4 | PLNNO | X | X | 계획/오더번호 | ZEB1_PP_PLPR | ZDB1_PP_PLPR | NUMC | 10 | OR2026060001 (CHECK: ZTB1PP0014) |
| 5 | MATNR | X | X | 생산품ID | ZEB1_MM_MATNR | ZDB1_MM_MATNR | CHAR | 18 | GAS-300 (CHECK: ZTB1MM0001) |
| 6 | PLACT | X | | 계획/실적구분 | ZEB1_CO_PATYP | ZDB1_CO_PATYP | CHAR | 6 | PLAN / FINN |
| 7 | PRCID | | X | 공정ID | ZEB1_PP_PLNNR | ZDB1_PP_PLNNR | CHAR | 10 | PCDU0001, PGAS0001 (CHECK: ZTB1CO0003) |
| 8 | ORGOL | | | 투입된 원유 종류 | ZEB1_CO_VER | ZDB1_CO_VER | CHAR | 18 | |
| 9 | MVPRC | | X | 이동평균단가 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15 | MM01 평가단가 (CHECK: ZTB1MM0001) |
| 10 | CRQTY | | X | 투입된 원유 양 | ZEB1_CO_CRDQTY | ZDB1_CO_CRDQTY | QUAN | 15 | 1000 (CHECK: ZTB1MM0012) |
| 11 | MEINS | | X | 단위 | ZEB1_MM_MEINS | ZDB1_MM_MEINS | UNIT | 3 | BBL (CHECK: ZTB1MM0001) |
| 12 | PRDQT | | X | 생산량 | ZEB1_CO_PRDQTY | ZDB1_CO_PRDQTY | QUAN | 15 | 920 (CHECK: ZTB1PP0014) |
| 13 | CRAMT | | X | 투입된 원유 비용 | ZEB1_CO_CRDCST | ZDB1_CO_CRDCST | CURR | 15 | 원유비 배부액 (CHECK: ZTB1MM0012) |
| 14 | P1AMT | | X | 총 1차 공정비 | ZEB1_CO_P1CST | ZDB1_CO_P1CST | CURR | 15 | 1차 공정 가동비 (CHECK: ZTB1CO0006) |
| 15 | P2AMT | | X | 총 2차 공정비 | ZEB1_CO_P2CST | ZDB1_CO_P2CST | CURR | 15 | 2차 공정 가동비 (CHECK: ZTB1CO0006) |
| 16 | CTAM1 | | X | 총 BCU 및 촉매 비용 | ZEB1_CO_CATP1 | ZDB1_CO_CATP1 | CURR | 15 | BCU/ZEOL/NIMO 1차 (CHECK: ZTB1CO0006) |
| 17 | SFAMT | | X | 당일 반제품 총원가 | ZEB1_CO_SFAMT | ZDB1_CO_SFAMT | CURR | 15 | 반제품 생산 산출원가 (완제품 원가 전용) (CHECK: ZTB1CO0006) |
| 18 | TOTAM | | | 생산 총원가 | ZEB1_CO_TOTCST | ZDB1_CO_TOTCST | CURR | 15 | 반제품/완제품 당일 총원가 |
| 19 | DAYUC | | | 당일 단위원가 | ZEB1_CO_DAYUC | ZDB1_CO_DAYUC | CURR | 15 | 당일 총원가 / 생산량 |
| 20 | WAERS | | X | 통화 | ZEB1_FI_WAERS | ZDB1_FI_WAERS | CUKY | 5 | KRW (CHECK: ZTB1FI0004) |
| 21 | EXRAT | | X | 환율 | ZEB1_FI_KURSF | ZDB1_FI_KURSF | DEC | 9 | 1350 (CHECK: ZTB1FI0007) |
| 22 | CFRMD | | | 확정 여부 | ZEB1_CO_CFRMD | ZDB1_CO_CFRMD | CHAR | 1 | Y / N |
| 23 | ACTYN | | | 활성화 여부 | ZEB1_CO_ACTIV | ZDB1_CO_ACTIV | CHAR | 1 | Y / N |
| 24 | LVORM | | | 삭제표시 | ZEC2CN_LVORM | ZDB2CN_LVORM | CHAR | 1 | X=삭제/공백=정상 |
| 25 | ERNAM | | | 작성자 | ZCC_ERNAM | ZDB_ERNAM | CHAR | 12 | (사용자 이름(ID)) |
| 26 | ERDAT | | | 작성일 | ZCC_ERDAT | ZDB_ERDAT | DATS | 8 | YYYYMMDD |
| 27 | ERZET | | | 작성시간 | ZCC_ERZET | ZDB_ERZET | TIMS | 6 | HHMMSS |
| 28 | AENAM | | | 변경자 | ZCC_AENAM | ZDB_AENAM | CHAR | 12 | (사용자 이름(ID)) |
| 29 | AEDAT | | | 변경일 | ZCC_AEDAT | ZDB_AEDAT | DATS | 8 | YYYYMMDD |
| 30 | AEZET | | | 변경시간 | ZCC_AEZET | ZDB_AEZET | TIMS | 6 | HHMMSS |

---

## <a id="ztb1co0008"></a>8. ZTB1CO0008 (제품원가 결과 상세 테이블)

* **테이블 용도**: 제품원가 계산에 쓰인 금액을 원인, 원가요소, 출처문서와 연결하는 전표형 상세 테이블
* **테이블 유형**: 상세/전표형 결과 테이블

| 번호 | 필드 | PK | FK | Description | Data Element | Domain | Type | 길이 | 비고 |
| :--- | :--- | :-: | :-: | :--- | :--- | :--- | :--- | :-: | :--- |
| 1 | MANDT | X | | 클라이언트 | MANDT | MANDT | CLNT | 3 | A100 |
| 2 | CSTID | X | X | 원가ID | ZEB1_CO_COSTID | ZDB1_CO_COSTID | CHAR | 14 | CST2026060001 (CHECK: ZTB1CO0007) |
| 3 | CSTDT | X | | 원가기준일 | ZEB1_CO_SCSTDT | ZDB1_CO_SCSTDT | DATS | 8 | |
| 4 | LINNO | X | | 라인번호 | ZEB1_CO_LINNO | ZDB1_CO_LINNO | NUMC | 6 | 1 |
| 5 | PLACT | | | 계획/실적 구분 | ZEB1_CO_PATYP | ZDB1_CO_PATYP | CHAR | 6 | PLAN, PROD, FINN |
| 6 | PLNNO | | X | 계획/오더번호 | ZEB1_PP_PLNNO | ZDB1_PP_PLNNO | NUMC | 10 | OR202606001 (CHECK: ZTB1PPPL13) |
| 7 | MATNR | | X | 생산품ID | ZEB1_MM_MATNR | ZDB1_MM_MATNR | CHAR | 18 | GAS-300 (CHECK: ZTB1MM0001) |
| 8 | ORGOL | | | 투입된 원유 종류 | ZEB1_CO_VER | ZDB1_CO_VER | CHAR | 18 | |
| 9 | PRCID | | X | 공정ID | ZEB1_PP_PLNNR | ZDB1_PP_PLNNR | CHAR | 10 | PCDU001 (CHECK: ZTB1CO0003) |
| 10 | KOSTL | | X | 코스트센터 | ZEB1_CO_KOSTL | ZDB1_CO_KOSTL | CHAR | 10 | RCC100 (CHECK: ZTB1CO0001) |
| 11 | ZPRCTR | | X | 손익센터 | ZEB1_CO_PRCTR | ZDB1_CO_PRCTR | CHAR | 10 | FUEL_PC (CHECK: ZTB1CO0002) |
| 12 | KSTAR | | X | 원가요소/G/L계정 | ZEB1_FI_HKONT | ZDB1_FI_HKONT | CHAR | 10 | 510001, 540200 (CHECK: ZTB1CO0004) |
| 13 | CSTCP | | X | 원구성항목 | ZEB1_CO_COMP | ZDB1_CO_COMP | CHAR | 20 | CRUDE, BCU, ZEOL, NIMO, PROC1, PROC2 (CHECK: ZTB1CO0004) |
| 14 | CALTP | | | 계산 유형 | ZEB1_CO_CALTP | ZDB1_CO_CALTP | CHAR | 6 | BASE, DAY, PREV, AVG, FINAL, ADJ |
| 15 | RSNCD | | | 비용 발생 원인 | ZEB1_CO_REASON | ZDB1_CO_REASON | CHAR | 40 | 원유투입, 촉매투입, 1차공정가동 |
| 16 | DMBTR | | | 금액 | ZEB1_CO_AMOUNT | ZDB1_CO_AMOUNT | CURR | 15 | 120000000 |
| 17 | RATE | | | 반영비율 | ZEB1_CO_AMOUNT | ZDB1_CO_AMOUNT | DEC | 5,2 | |
| 18 | REFCST | | | 참고원가ID | ZEB1_CO_AMOUNT | ZDB1_CO_AMOUNT | CHAR | 14 | |
| 19 | WAERS | | | 통화 | WAERS | WAERS | CUKY | 5 | KRW, USD |
| 20 | EXRAT | | X | 환율 | ZEB1_FI_KURSF | ZDB1_FI_KURSF | DEC | 9 | 1350 (CHECK: ZTB1FI0007) |
| 21 | SRMOD | | | 출처 모듈 | ZEB1_CO_SRCMOD | ZDB1_CO_SRCMOD | CHAR | 5 | MM, FI, PP, CO |
| 22 | SRDOC | | X | 원천문서번호 | ZEB1_CO_SRCDOC | ZDB1_CO_SRCDOC | CHAR | 20 | 500000001, 100000001 (CHECK: ZTB1MM0011/ZTB1FI0001) |
| 23 | SRITM | | X | 원천문서항목 | ZEB1_CO_SRCITM | ZDB1_CO_SRCITM | NUMC | 6 | 1 (CHECK: ZTB1MM0012/ZTB1FI0002) |
| 24 | REFTX | | | 비고 | ZEB1_CO_ACTIV | ZDB1_CO_ACTIV | CHAR | 40 | |
| 25 | ACTYN | | | 활성화 여부 | ZEB1_CO_ACTIV | ZDB1_CO_ACTIV | CHAR | 1 | Y, N |
| 26 | LVORM | | | 삭제표시 | ZEC2CN_LVORM | ZDB2CN_LVORM | CHAR | 1 | X=삭제/공백=정상 |
| 27 | ERNAM | | | 작성자 | ZCC_ERNAM | ZDB_ERNAM | CHAR | 12 | (사용자 이름(ID)) |
| 28 | ERDAT | | | 작성일 | ZCC_ERDAT | ZDB_ERDAT | DATS | 8 | YYYYMMDD |
| 29 | ERZET | | | 작성시간 | ZCC_ERZET | ZDB_ERZET | TIMS | 6 | HHMMSS |
| 30 | AENAM | | | 변경자 | ZCC_AENAM | ZDB_AENAM | CHAR | 12 | (사용자 이름(ID)) |
| 31 | AEDAT | | | 변경일 | ZCC_AEDAT | ZDB_AEDAT | DATS | 8 | YYYYMMDD |
| 32 | AEZET | | | 변경시간 | ZCC_AEZET | ZDB_AEZET | TIMS | 6 | HHMMSS |

---

## <a id="ztb1co0009"></a>9. ZTB1CO0009 (공정 원가 최적화 결과 시뮬레이션 테이블)

* **테이블 용도**: 시뮬레이터 결과로 나온 공정 비용 대비 최소 금액이 발생하는 원유를 순위별로 매긴 데이터가 들어간 테이블
* **테이블 유형**: 결과 테이블

| 번호 | 필드 | PK | FK | Description | Data Element | Domain | Type | 길이 | 비고 |
| :--- | :--- | :-: | :-: | :--- | :--- | :--- | :--- | :-: | :--- |
| 1 | MANDT | X | | 클라이언트 | MANDT | MANDT | CLNT | 3 | A100 |
| 2 | SIMID | X | | 시뮬레이션 ID | ZEB1_CO_SIMID | ZDB1_CO_SIMID | CHAR | 16 | |
| 3 | WERKS | X | X | 플랜트 | ZEB1_MM_WERKS | ZDB1_MM_WERKS | CHAR | 4 | 1000 (CHECK: ZTB1MM0000) |
| 4 | CDATE | | | 계산일자 | ZCC_ERDAT | ZDB_ERDAT | DATS | 8 | |
| 5 | BDATE | | | 기준일자 | ZEB1_CO_VALIDF | ZDB1_CO_VALIDF | DATS | 8 | |
| 6 | BOMVE | | X | 계절 수율코드 | ZEB1_PP_BOMVE | ZDB1_PP_BOMVE | CHAR | 4 | (CHECK: ZTB1PP0003) |
| 7 | NO1MT | | | 1순위 원유 | ZEB1_MM_MATNR | ZDB1_MM_MATNR | CHAR | 18 | |
| 8 | NO2MT | | | 2순위 원유 | ZEB1_MM_MATNR | ZDB1_MM_MATNR | CHAR | 18 | |
| 9 | NO3MT | | | 3순위 원유 | ZEB1_MM_MATNR | ZDB1_MM_MATNR | CHAR | 18 | |
| 10 | AVG01 | | | 1순위 평균 투입 단가 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15 | |
| 11 | AVG02 | | | 2순위 평균 투입 단가 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15 | |
| 12 | AVG03 | | | 3순위 평균 투입 단가 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15 | |
| 13 | STL01 | | X | 1순위 수율표 | ZEB1_PP_STLNR | ZDB1_PP_STLNR | CHAR | 8 | (CHECK: ZTB1PP0003) |
| 14 | STL02 | | X | 2순위 수율표 | ZEB1_PP_STLNR | ZDB1_PP_STLNR | CHAR | 8 | (CHECK: ZTB1PP0003) |
| 15 | STL03 | | X | 3순위 수율표 | ZEB1_PP_STLNR | ZDB1_PP_STLNR | CHAR | 8 | (CHECK: ZTB1PP0003) |
| 16 | WTIPR | | X | WTI 이동평균단가 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15 | (CHECK: ZTB1MM0001) |
| 17 | DUBPR | | X | DUBAI 이동평균단가 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15 | (CHECK: ZTB1MM0001) |
| 18 | MAYPR | | X | MAYA 이동평균단가 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15 | (CHECK: ZTB1MM0001) |
| 19 | BCUPR | | X | BCU 적용단가 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15 | (CHECK: ZTB1MM0001 or Not) |
| 20 | EXRAT | | X | 적용환율 | ZEB1_FI_KURSF | ZDB1_FI_KURSF | DEC | 11 | (CHECK: ZTB1FI0007) |
| 21 | BCUCH | | | BCU 변경여부 | ZEB1_CO_CHGYN | ZDB1_CO_CHGYN | CHAR | 1 | O, X |
| 22 | EXRCH | | | 환율 변경여부 | ZEB1_CO_CHGYN | ZDB1_CO_CHGYN | CHAR | 1 | O, X |
| 23 | BEPBC | | | BCU 손익분기단가 | ZEB1_MM_VERPR | ZDB1_MM_VERPR | CURR | 15 | |
| 24 | WAERS | | X | 통화 | ZEB1_FI_WAERS | ZDB1_FI_WAERS | CUKY | 5 | KRW (CHECK: ZTB1FI0004) |
| 25 | REMRK | | | 비고 | ZEB1_PP_REMARK | ZDB1_PP_REMARK | CHAR | 80 | |
| 26 | LVORM | | | 삭제표시 | ZEC2CN_LVORM | ZDB2CN_LVORM | CHAR | 1 | X=삭제/공백=정상 |
| 27 | ERNAM | | | 작성자 | ZCC_ERNAM | ZDB_ERNAM | CHAR | 12 | (사용자 이름(ID)) |
| 28 | ERDAT | | | 작성일 | ZCC_ERDAT | ZDB_ERDAT | DATS | 8 | YYYYMMDD |
| 29 | ERZET | | | 작성시간 | ZCC_ERZET | ZDB_ERZET | TIMS | 6 | HHMMSS |
| 30 | AENAM | | | 변경자 | ZCC_AENAM | ZDB_AENAM | CHAR | 12 | (사용자 이름(ID)) |
| 31 | AEDAT | | | 변경일 | ZCC_AEDAT | ZDB_AEDAT | DATS | 8 | YYYYMMDD |
| 32 | AEZET | | | 변경시간 | ZCC_AEZET | ZDB_AEZET | TIMS | 6 | HHMMSS |
