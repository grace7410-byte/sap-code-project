# [Design] CO (관리 회계 - 정유원가) 모듈 테이블 명세서

**최종 수정일**: 2026-08-16  
**상태**: 확정 (Approved)  
**버전**: v2.0 (MM/PP/SD/FI 스펙 템플릿과 컬럼 구조 통일)  

> 💡 **문서 연결 가이드**: 타 문서에서 특정 테이블로 링크를 걸 때는 본 파일 경로 뒤에 `#테이블명` 앵커를 사용  
> *예시: `[공정 계획 비용 테이블 스펙](04_design/table_specifications/05_CO_table_spec.md#ztb1co0005)`*

---

## 테이블 목차 (Index)

| 순번 | 테이블명 | 설명 | 테이블 유형 |
| :--- | :--- | :--- | :--- |
| 1 | [`ZTB1CO0001`](#ztb1co0001) | 원가 귀속 단위(공정/부서)를 관리하는 마스터 테이블 | 마스터 테이블 |
| 2 | [`ZTB1CO0002`](#ztb1co0002) | 제품/사업영역별 손익 귀속 단위를 관리하는 마스터 테이블 | 마스터 테이블 |
| 3 | [`ZTB1CO0003`](#ztb1co0003) | CO 해석용 공정/단계/기본 귀속 정보를 관리하는 마스터 테이블 | 마스터 테이블 |
| 4 | [`ZTB1CO0004`](#ztb1co0004) | FI 계정과 CO 원가요소/포함여부 분류를 관리하는 마스터 테이블 | 마스터 테이블 |
| 5 | [`ZTB1CO0005`](#ztb1co0005) | 공정 계획에 따라 발생한 비용을 총망라하는 결과 테이블 | 결과 테이블 |
| 6 | [`ZTB1CO0006`](#ztb1co0006) | 공정 실적에 따라 발생한 비용을 총망라하는 결과 테이블 | 결과 테이블 |
| 7 | [`ZTB1CO0007`](#ztb1co0007) | 생산품/반제품의 원가를 공정별 계획·실적 기준으로 저장하는 결과 테이블 | 결과 테이블 |
| 8 | [`ZTB1CO0008`](#ztb1co0008) | 제품원가 계산 금액을 원인·원가요소·출처문서와 연결하는 상세/전표형 결과 테이블 | 상세/전표형 결과 테이블 |
| 9 | [`ZTB1CO0009`](#ztb1co0009) | 공정 비용 대비 최소 금액이 발생하는 원유를 순위별로 매긴 시뮬레이션 결과 테이블 | 결과 테이블 |

---

## ZTB1CO0001: 코스트센터 마스터 테이블 <a id="ztb1co0001"></a>
*원가 귀속 단위(공정/부서) 관리*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 예: `100` |
| 2 | KOKRS | Y | CHAR | 4 | 관리회계영역 | 예: `A100` |
| 3 | KOSTL | Y | CHAR | 10 | 코스트센터 | 23종 + a |
| 4 | KOTXT | N | CHAR | 40 | 코스트센터명 | 예: `원유증류비용센터` |
| 5 | WERKS | N | CHAR | 4 | 플랜트 | Check Table: `ZTB1MM0000`, 예: `1000` |
| 6 | CCTYP | N | CHAR | 2 | 센터유형 | **Fixed Value**: `PR`(공정), `AD`(관리) |
| 7 | DATAB | N | DATS | 8 | 유효시작일 | 예: `2026-01-01` |
| 8 | DATBI | N | DATS | 8 | 유효종료일 | 예: `9999-12-31` |
| 9~15 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`, `X`=삭제/공백=정상) 및 생성/변경 이력 타임스탬프 필드 일체 |

---

## ZTB1CO0002: 손익센터 마스터 테이블 <a id="ztb1co0002"></a>
*제품/사업영역별 손익 귀속 단위 관리*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 예: `100` |
| 2 | KOKRS | Y | CHAR | 4 | 관리회계영역 | 예: `A100` |
| 3 | ZPRCTR | Y | CHAR | 20 | 손익센터 | 10종 + a |
| 4 | PRTXT | N | CHAR | 40 | 손익센터명 | |
| 5 | WERKS | N | CHAR | 4 | 플랜트 | Check Table: `ZTB1MM0000`, 예: `1000` |
| 6 | PRDGP | N | CHAR | 2 | 제품군 | Check Table: `ZTB1MM0001`, **Fixed Value**: `00`, `10`, `20`, `30` |
| 7 | SEGMT | N | CHAR | 10 | 세그먼트 | 예: `REFINE`, `SALES` |
| 8 | PCTYP | N | CHAR | 2 | 손익센터유형 | **Fixed Value**: `PD`(제품), `SV`(서비스) |
| 9 | DATAB | N | DATS | 8 | 유효시작일 | 예: `2026-01-01` |
| 10 | DATBI | N | DATS | 8 | 유효종료일 | 예: `9999-12-31` |
| 11~17 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`, `X`=삭제/공백=정상) 및 생성/변경 이력 타임스탬프 필드 일체 |

---

## ZTB1CO0003: 공정 마스터 테이블 <a id="ztb1co0003"></a>
*CO 해석용 공정/단계/기본 귀속 정보 관리*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 예: `A100` |
| 2 | KOKRS | Y | CHAR | 4 | 관리회계영역 | 예: `A100` |
| 3 | WERKS | Y | CHAR | 4 | 플랜트 | Check Table: `ZTB1MM0000`, 예: `1000` |
| 4 | PRCID | Y | CHAR | 10 | 공정ID | Check Table: `ZTB1PP0008` |
| 5 | PRCNM | N | CHAR | 40 | 공정명 | |
| 6 | PRCST | N | CHAR | 2 | 공정단계 | **Fixed Value**: `1차`, `2차` |
| 7 | PPRID | N | CHAR | 10 | 상위공정ID | 상위공정 참조 |
| 8 | KOSTL | N | CHAR | 4 | 코스트센터 | Check Table: `ZTB1CO0001`, 예: `A100` |
| 9 | ZPRCTR | N | CHAR | 20 | 손익센터 | Check Table: `ZTB1CO0002`, 예: `FUEL_PC` |
| 10 | OUTST | N | CHAR | 2 | 산출물단계 | **Fixed Value**: `RM`, `SF`, `FG` |
| 11 | DATAB | N | DATS | 8 | 유효시작일 | 예: `2026-01-01` |
| 12 | DATBI | N | DATS | 8 | 유효종료일 | 예: `9999-12-31` |
| 13 | STATU | N | CHAR | 1 | 상태 | **Fixed Value**: `A`, `I` |
| 14~20 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`, `X`=삭제/공백=정상) 및 생성/변경 이력 타임스탬프 필드 일체 |

---

## ZTB1CO0004: 원가분류/계정 매핑 테이블 <a id="ztb1co0004"></a>
*FI 계정과 CO 원가요소/포함여부 분류 관리*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 예: `A100` |
| 2 | KSTAR | Y | CHAR | 10 | 원가요소(계정) | Check Table: `ZTB1FI0005`, 예: `510001` |
| 3 | DATAB | Y | DATS | 8 | 유효시작일 | 예: `2026-01-01` |
| 4 | ELENM | N | CHAR | 40 | 원가요소명 | 예: `원유비`, `유틸리티비` |
| 5 | ELTYP | N | CHAR | 2 | 유형 | **Fixed Value**: `PR`(1차), `SC`(2차) |
| 6 | CSTCL | N | CHAR | 12 | 비용분류 | **Fixed Value**: `RAW`, `PROC`, `OH`, `SELL` |
| 7 | ALOCY | N | CHAR | 1 | 배부가능여부 | **Fixed Value**: `Y`, `N` |
| 8 | MFGYN | N | CHAR | 1 | 제조원가포함 | **Fixed Value**: `Y`, `N` |
| 9 | ALCBS | N | CHAR | 12 | 배부기준 | **Fixed Value**: `QTY`, `HOUR`, `AMT` |
| 10 | DATBI | N | DATS | 8 | 유효종료일 | 예: `9999-12-31` |
| 11~17 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`, `X`=삭제/공백=정상) 및 생성/변경 이력 타임스탬프 필드 일체 |

---

## ZTB1CO0005: 공정 계획 비용 테이블 <a id="ztb1co0005"></a>
*공정 계획에 따라 발생한 비용 총망라 테이블*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 예: `A100` |
| 2 | PLNNO | Y | NUMC | 10 | 계획/오더 번호 | Check Table: `ZTB1PPPL13`, 예: `OR202606001` |
| 3 | PLNTY | Y | CHAR | 4 | 계획/오더 구분 | Check Table: `ZTB1PP0013`, **Fixed Value**: `PL`(계획), `OR`(오더) |
| 4 | REGDT | Y | DATS | 8 | 등록일 | 예: `2026-06-30` |
| 5 | VERSN | Y | CHAR | 3 | 버전 | 예: `001`, `002` |
| 6 | PRCID | Y | CHAR | 10 | 공정ID | Check Table: `ZTB1PP0008` |
| 7 | KOSTL | Y | CHAR | 10 | 코스트센터 | Check Table: `ZTB1CO0001` |
| 8 | ZPRCTR | N | CHAR | 20 | 손익센터 | Check Table: `ZTB1CO0002` |
| 9 | INMAT | N | CHAR | 18 | 투입품ID | Check Table: `ZTB1MM0001`, 예: `CRUDE-001` |
| 10 | INPRC | N | CURR | 15,2 | 계획 투입품 비용 | Check Table: `ZTB1MM0001`, MM01 평가단가(VERPR) 참조 |
| 11 | INQTY | N | QUAN | 15,3 | 투입량 | Check Table: `ZTB1PPPL13` |
| 12 | INAMT | N | CURR | 15,2 | 계획 투입량 비용 | |
| 13 | BCPRC | N | CURR | 15,2 | 계획 BCU 비용 | Check Table: `ZTB1MM0001`, MM01 평가단가 참조 |
| 14 | BCQTY | N | QUAN | 15,3 | 계획 BCU 투입량 | Check Table: `ZTB1PP0013` |
| 15 | BCAMT | N | CURR | 15,2 | 계획 BCU 투입 비용 | |
| 16 | ZEPRC | N | CURR | 15,2 | 계획 ZEOL 비용 | Check Table: `ZTB1MM0001`, MM01 평가단가 참조 |
| 17 | ZEQTY | N | QUAN | 15,3 | 계획 ZEOL촉매투입량 | Check Table: `ZTB1PP0013` |
| 18 | ZEAMT | N | CURR | 15,2 | 계획 ZEOL 투입 비용 | |
| 19 | NMPRC | N | CURR | 15,2 | 계획 NIMO 비용 | Check Table: `ZTB1MM0001`, MM01 평가단가 참조 |
| 20 | NMQTY | N | QUAN | 15,3 | 계획 NIMO 촉매투입량 | Check Table: `ZTB1PP0013` |
| 21 | NMAMT | N | CURR | 15,2 | 계획 NIMO 투입 비용 | |
| 22 | RUNHR | N | QUAN | 13,2 | 계획가동시간 | `24H` 고정 |
| 23 | HRUNT | N | UNIT | 3 | 시간 단위 | Check Table: `ZTB1MM0001`, 예: `HOURS` |
| 24 | PRCAM | N | CURR | 15 | 계획 공정 비용 | Check Table: `ZTB1CO0010`, **[산식]**: `가동시간 × 실제단가` |
| 25 | OUTMT | N | CHAR | 18 | 결과물ID | Check Table: `ZTB1MM0001` |
| 26 | OUTQT | N | QUAN | 15,3 | 산출량 | |
| 27 | MEINS | N | UNIT | 3 | 단위 | Check Table: `ZTB1MM0001`, 예: `BBL`, `KG` |
| 28 | YDPCT | N | DEC | 5,2 | 실적 수율(%) | 예: `91.5` |
| 29 | WAERS | N | CUKY | 5 | 통화 | Check Table: `ZTB1FI0004`, 예: `KRW` |
| 30 | EXRAT | N | DEC | 9 | 계산 당시 환율 | Check Table: `ZTB1FI0007` |
| 31 | ACTYN | N | CHAR | 1 | 활성화 여부 | **Fixed Value**: `Y`, `N` |
| 32~38 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`, `X`=삭제/공백=정상) 및 생성/변경 이력 타임스탬프 필드 일체 |

---

## ZTB1CO0006: 공정 실적 비용 테이블 <a id="ztb1co0006"></a>
*공정 실적에 따라 발생한 비용 총망라 테이블*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 예: `A100` |
| 2 | PLNNO | Y | NUMC | 10 | 계획/오더 번호 | Check Table: `ZTB1PPPL13`, 예: `OR202606001` |
| 3 | PLNTY | Y | CHAR | 4 | 계획/오더 구분 | Check Table: `ZTB1PP0013`, **Fixed Value**: `PL`(계획), `OR`(오더) |
| 4 | REGDT | Y | DATS | 8 | 등록일 | 예: `2026-06-30` |
| 5 | VERSN | Y | CHAR | 3 | 버전 | 예: `001`, `002` |
| 6 | PRCID | Y | CHAR | 10 | 공정ID | Check Table: `ZTB1PP0008` |
| 7 | KOSTL | Y | CHAR | 10 | 코스트센터 | Check Table: `ZTB1CO0001` |
| 8 | ZPRCTR | N | CHAR | 20 | 손익센터 | Check Table: `ZTB1CO0002` |
| 9 | ORGOL | N | CHAR | 18 | 투입된 원유 종류 | |
| 10 | INMAT | N | CHAR | 18 | 투입품ID | Check Table: `ZTB1MM0001`, 예: `CRUDE-001` |
| 11 | INPRC | N | CURR | 15,2 | 투입당시 투입품 비용 | Check Table: `ZTB1MM0001`, MM01 평가단가 참조 |
| 12 | INQTY | N | QUAN | 15,3 | 투입량 | Check Table: `ZTB1PPPL13` |
| 13 | INAMT | N | CURR | 15,2 | 실적 투입량 비용 | |
| 14 | BCPRC | N | CURR | 15,2 | 투입당시 BCU 비용 | Check Table: `ZTB1MM0001`, MM01 평가단가 참조 |
| 15 | BCQTY | N | QUAN | 15,3 | 실적 BCU 투입량 | Check Table: `ZTB1PPPL13` |
| 16 | BCAMT | N | CURR | 15,2 | 실적 BCU 투입 비용 | |
| 17 | ZEPRC | N | CURR | 15,2 | 투입당시 ZEOL 비용 | Check Table: `ZTB1MM0001`, MM01 평가단가 참조 |
| 18 | ZEQTY | N | QUAN | 15,3 | ZEOL촉매투입량 | Check Table: `ZTB1PPPL13` |
| 19 | ZEAMT | N | CURR | 15,2 | 실적 ZEOL 투입 비용 | |
| 20 | NMPRC | N | CURR | 15,2 | 투입당시 NIMO 비용 | Check Table: `ZTB1MM0001`, MM01 평가단가 참조 |
| 21 | NMQTY | N | QUAN | 15,3 | NIMO 촉매투입량 | Check Table: `ZTB1PPPL13` |
| 22 | NMAMT | N | CURR | 15,2 | 실적 NIMO 투입 비용 | |
| 23 | RUNHR | N | QUAN | 13,2 | 실적가동시간 | `24H` 고정 |
| 24 | HRUNT | N | UNIT | 3 | 시간 단위 | Check Table: `ZTB1MM0001`, 예: `HOURS` |
| 25 | PRCAM | N | CURR | 15 | 실적 공정 비용 | Check Table: `ZTB1CO0010`, **[산식]**: `가동시간 × 실제단가` |
| 26 | OUTMT | N | CHAR | 18 | 결과물ID | Check Table: `ZTB1MM0001` |
| 27 | OUTQT | N | QUAN | 15,3 | 산출량 | |
| 28 | MEINS | N | UNIT | 3 | 단위 | Check Table: `ZTB1MM0001`, 예: `BBL`, `KG` |
| 29 | YDPCT | N | DEC | 5,2 | 실적 수율(%) | 예: `91.5` |
| 30 | WAERS | N | CUKY | 5 | 통화 | Check Table: `ZTB1FI0004`, 예: `KRW` |
| 31 | EXRAT | N | DEC | 9 | 계산 당시 환율 | Check Table: `ZTB1FI0007` |
| 32 | ACTYN | N | CHAR | 1 | 활성화 여부 | **Fixed Value**: `Y`, `N` |
| 33~39 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`, `X`=삭제/공백=정상) 및 생성/변경 이력 타임스탬프 필드 일체 |

---

## ZTB1CO0007: 반제품/완제품 원가 테이블 <a id="ztb1co0007"></a>
*생산품 또는 반제품의 원가를 공정별 계획/실적 기준으로 저장*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 예: `100` |
| 2 | CSTID | Y | CHAR | 14 | 원가ID | 예: `CST2026060001` |
| 3 | CSTDT | Y | DATS | 8 | 원가기준일 | |
| 4 | PLNNO | Y | NUMC | 10 | 계획/오더번호 | Check Table: `ZTB1PP0014`, 예: `OR2026060001` |
| 5 | MATNR | Y | CHAR | 18 | 생산품ID | Check Table: `ZTB1MM0001`, 예: `GAS-300` |
| 6 | PLACT | Y | CHAR | 6 | 계획/실적구분 | **Fixed Value**: `PLAN`, `FINN` |
| 7 | PRCID | N | CHAR | 10 | 공정ID | Check Table: `ZTB1CO0003`, 예: `PCDU0001`, `PGAS0001` |
| 8 | ORGOL | N | CHAR | 18 | 투입된 원유 종류 | |
| 9 | MVPRC | N | CURR | 15 | 이동평균단가 | Check Table: `ZTB1MM0001`, MM01 평가단가 참조 |
| 10 | CRQTY | N | QUAN | 15 | 투입된 원유 양 | Check Table: `ZTB1MM0012`, 예: `1000` |
| 11 | MEINS | N | UNIT | 3 | 단위 | Check Table: `ZTB1MM0001`, 예: `BBL` |
| 12 | PRDQT | N | QUAN | 15 | 생산량 | Check Table: `ZTB1PP0014`, 예: `920` |
| 13 | CRAMT | N | CURR | 15 | 투입된 원유 비용 | Check Table: `ZTB1MM0012`, 원유비 배부액 |
| 14 | P1AMT | N | CURR | 15 | 총 1차 공정비 | Check Table: `ZTB1CO0006`, 1차 공정 가동비 |
| 15 | P2AMT | N | CURR | 15 | 총 2차 공정비 | Check Table: `ZTB1CO0006`, 2차 공정 가동비 |
| 16 | CTAM1 | N | CURR | 15 | 총 BCU 및 촉매 비용 | Check Table: `ZTB1CO0006`, BCU/ZEOL/NIMO 1차 |
| 17 | SFAMT | N | CURR | 15 | 당일 반제품 총원가 | Check Table: `ZTB1CO0006`, 반제품 생산 산출원가(완제품 원가 전용) |
| 18 | TOTAM | N | CURR | 15 | 생산 총원가 | 반제품/완제품 당일 총원가 |
| 19 | DAYUC | N | CURR | 15 | 당일 단위원가 | **[산식]**: `당일 총원가 ÷ 생산량` |
| 20 | WAERS | N | CUKY | 5 | 통화 | Check Table: `ZTB1FI0004`, 예: `KRW` |
| 21 | EXRAT | N | DEC | 9 | 환율 | Check Table: `ZTB1FI0007`, 예: `1350` |
| 22 | CFRMD | N | CHAR | 1 | 확정 여부 | **Fixed Value**: `Y`, `N` |
| 23 | ACTYN | N | CHAR | 1 | 활성화 여부 | **Fixed Value**: `Y`, `N` |
| 24~30 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`, `X`=삭제/공백=정상) 및 생성/변경 이력 타임스탬프 필드 일체 |

---

## ZTB1CO0008: 제품원가 결과 상세 테이블 <a id="ztb1co0008"></a>
*제품원가 계산에 쓰인 금액을 원인, 원가요소, 출처문서와 연결하는 전표형 상세 테이블*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 예: `A100` |
| 2 | CSTID | Y | CHAR | 14 | 원가ID | Check Table: `ZTB1CO0007`, 예: `CST2026060001` |
| 3 | CSTDT | Y | DATS | 8 | 원가기준일 | |
| 4 | LINNO | Y | NUMC | 6 | 라인번호 | 예: `1` |
| 5 | PLACT | N | CHAR | 6 | 계획/실적 구분 | **Fixed Value**: `PLAN`, `PROD`, `FINN` |
| 6 | PLNNO | N | NUMC | 10 | 계획/오더번호 | Check Table: `ZTB1PPPL13`, 예: `OR202606001` |
| 7 | MATNR | N | CHAR | 18 | 생산품ID | Check Table: `ZTB1MM0001`, 예: `GAS-300` |
| 8 | ORGOL | N | CHAR | 18 | 투입된 원유 종류 | |
| 9 | PRCID | N | CHAR | 10 | 공정ID | Check Table: `ZTB1CO0003`, 예: `PCDU001` |
| 10 | KOSTL | N | CHAR | 10 | 코스트센터 | Check Table: `ZTB1CO0001`, 예: `RCC100` |
| 11 | ZPRCTR | N | CHAR | 10 | 손익센터 | Check Table: `ZTB1CO0002`, 예: `FUEL_PC` |
| 12 | KSTAR | N | CHAR | 10 | 원가요소/G·L계정 | Check Table: `ZTB1CO0004`, 예: `510001`, `540200` |
| 13 | CSTCP | N | CHAR | 20 | 원구성항목 | Check Table: `ZTB1CO0004`, **Fixed Value**: `CRUDE`, `BCU`, `ZEOL`, `NIMO`, `PROC1`, `PROC2` |
| 14 | CALTP | N | CHAR | 6 | 계산 유형 | **Fixed Value**: `BASE`, `DAY`, `PREV`, `AVG`, `FINAL`, `ADJ` |
| 15 | RSNCD | N | CHAR | 40 | 비용 발생 원인 | 예: `원유투입`, `촉매투입`, `1차공정가동` |
| 16 | DMBTR | N | CURR | 15 | 금액 | 예: `120000000` |
| 17 | RATE | N | DEC | 5,2 | 반영비율 | |
| 18 | REFCST | N | CHAR | 14 | 참고원가ID | |
| 19 | WAERS | N | CUKY | 5 | 통화 | 예: `KRW`, `USD` |
| 20 | EXRAT | N | DEC | 9 | 환율 | Check Table: `ZTB1FI0007`, 예: `1350` |
| 21 | SRMOD | N | CHAR | 5 | 출처 모듈 | **Fixed Value**: `MM`, `FI`, `PP`, `CO` |
| 22 | SRDOC | N | CHAR | 20 | 원천문서번호 | Check Table: `ZTB1MM0011`/`ZTB1FI0001`, 예: `500000001`, `100000001` |
| 23 | SRITM | N | NUMC | 6 | 원천문서항목 | Check Table: `ZTB1MM0012`/`ZTB1FI0002`, 예: `1` |
| 24 | REFTX | N | CHAR | 40 | 비고 | |
| 25 | ACTYN | N | CHAR | 1 | 활성화 여부 | **Fixed Value**: `Y`, `N` |
| 26~32 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`, `X`=삭제/공백=정상) 및 생성/변경 이력 타임스탬프 필드 일체 |

---

## ZTB1CO0009: 공정 원가 최적화 결과 시뮬레이션 테이블 <a id="ztb1co0009"></a>
*시뮬레이터 결과로 나온 공정 비용 대비 최소 금액이 발생하는 원유를 순위별로 매긴 데이터*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 예: `A100` |
| 2 | SIMID | Y | CHAR | 16 | 시뮬레이션 ID | |
| 3 | WERKS | Y | CHAR | 4 | 플랜트 | Check Table: `ZTB1MM0000`, 예: `1000` |
| 4 | CDATE | N | DATS | 8 | 계산일자 | |
| 5 | BDATE | N | DATS | 8 | 기준일자 | |
| 6 | BOMVE | N | CHAR | 4 | 계절 수율코드 | Check Table: `ZTB1PP0003` |
| 7 | NO1MT | N | CHAR | 18 | 1순위 원유 | |
| 8 | NO2MT | N | CHAR | 18 | 2순위 원유 | |
| 9 | NO3MT | N | CHAR | 18 | 3순위 원유 | |
| 10 | AVG01 | N | CURR | 15 | 1순위 평균 투입 단가 | |
| 11 | AVG02 | N | CURR | 15 | 2순위 평균 투입 단가 | |
| 12 | AVG03 | N | CURR | 15 | 3순위 평균 투입 단가 | |
| 13 | STL01 | N | CHAR | 8 | 1순위 수율표 | Check Table: `ZTB1PP0003` |
| 14 | STL02 | N | CHAR | 8 | 2순위 수율표 | Check Table: `ZTB1PP0003` |
| 15 | STL03 | N | CHAR | 8 | 3순위 수율표 | Check Table: `ZTB1PP0003` |
| 16 | WTIPR | N | CURR | 15 | WTI 이동평균단가 | Check Table: `ZTB1MM0001` |
| 17 | DUBPR | N | CURR | 15 | DUBAI 이동평균단가 | Check Table: `ZTB1MM0001` |
| 18 | MAYPR | N | CURR | 15 | MAYA 이동평균단가 | Check Table: `ZTB1MM0001` |
| 19 | BCUPR | N | CURR | 15 | BCU 적용단가 | Check Table: `ZTB1MM0001`(해당 시) |
| 20 | EXRAT | N | DEC | 11 | 적용환율 | Check Table: `ZTB1FI0007` |
| 21 | BCUCH | N | CHAR | 1 | BCU 변경여부 | **Fixed Value**: `O`, `X` |
| 22 | EXRCH | N | CHAR | 1 | 환율 변경여부 | **Fixed Value**: `O`, `X` |
| 23 | BEPBC | N | CURR | 15 | BCU 손익분기단가 | |
| 24 | WAERS | N | CUKY | 5 | 통화 | Check Table: `ZTB1FI0004`, 예: `KRW` |
| 25 | REMRK | N | CHAR | 80 | 비고 | |
| 26~32 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`, `X`=삭제/공백=정상) 및 생성/변경 이력 타임스탬프 필드 일체 |
