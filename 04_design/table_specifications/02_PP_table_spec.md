# [Design] PP (생산 관리) 모듈 테이블 명세서
 
**최종 수정일**: 2026-08-16  
**상태**: 확정 (Approved)  
**버전**: v2.0 (MM 스펙 템플릿과 컬럼 구조 통일)  
 
> 💡 **문서 연결 가이드**: 타 문서에서 특정 테이블로 링크를 걸 때는 본 파일 경로 뒤에 `#테이블명` 앵커를 사용  
> *예시: `[BOM 헤더 스펙](04_design/table_specifications/02_PP_table_spec.md#ztb1pp0002)`*
 
---
 
## 테이블 목차 (Index)
 
| 순번 | 테이블명 | 설명 | 테이블 유형 |
| :--- | :--- | :--- | :--- |
| 1 | [`ZTB1PP0001`](#ztb1pp0001) | 향후 제품별 예상 수요 수량을 관리하기 위한 계획(PIR) 마스터 테이블 | 계획 마스터 테이블 |
| 2 | [`ZTB1PP0002`](#ztb1pp0002) | 제품의 구성품(BOM) 상위 헤더 정보를 관리하기 위한 마스터 테이블 | 마스터 테이블 |
| 3 | [`ZTB1PP0003`](#ztb1pp0003) | 제품 투입 품목 및 원유 수율 투입 비중 세부 데이터를 저장하는 마스터 테이블 | 마스터 테이블 |
| 4 | [`ZTB1PP0004`](#ztb1pp0004) | 공정 작업을 수행하는 설비/작업장 기본 정보를 관리하기 위한 마스터 테이블 | 마스터 테이블 |
| 5 | [`ZTB1PP0005`](#ztb1pp0005) | 작업장별 가동 및 정지 운영 스케줄 데이터를 저장하는 마스터 테이블 | 마스터 테이블 |
| 6 | [`ZTB1PP0006`](#ztb1pp0006) | 작업장 비가동/이벤트 발생 이력의 헤더 데이터를 관리하는 트랜잭션 테이블 | 트랜잭션 테이블 |
| 7 | [`ZTB1PP0007`](#ztb1pp0007) | 작업장 비가동/이벤트 상세 원인 및 세부 내역을 기록하는 트랜잭션 테이블 | 트랜잭션 테이블 |
| 8 | [`ZTB1PP0008`](#ztb1pp0008) | 정제 공정 순서 및 공정 기본 헤더 정보를 관리하기 위한 마스터 테이블 | 마스터 테이블 |
| 9 | [`ZTB1PP0009`](#ztb1pp0009) | 공정별 투입/산출 조건 및 세부 가동 내역을 저장하는 마스터 테이블 | 마스터 테이블 |
| 10 | [`ZTB1PP0010`](#ztb1pp0010) | 공정과 투입 자재/연산품 간 매핑 관계를 관리하기 위한 마스터 테이블 | 마스터 테이블 |
| 11 | [`ZTB1PP0011`](#ztb1pp0011) | 자재요소계획(MRP) 실행 단위 및 총 소요량 결과 헤더 데이터를 기록하는 테이블 | 트랜잭션 테이블 |
| 12 | [`ZTB1PP0012`](#ztb1pp0012) | MRP 실행 결과에 따른 품목별 순소요량 및 보충 수량 세부 내역 테이블 | 트랜잭션 테이블 |
| 13 | [`ZTB1PP0013`](#ztb1pp0013) | 생산계획 및 확정된 생산오더의 상위 헤더 정보를 관리하는 트랜잭션 테이블 | 트랜잭션 테이블 |
| 14 | [`ZTB1PP0014`](#ztb1pp0014) | 생산계획 및 오더별 공정 투입/산출 자재 세부 라인 데이터를 관리하는 트랜잭션 테이블 | 트랜잭션 테이블 |
| 15 | [`ZTB1PP0015`](#ztb1pp0015) | 정제 공정 투입 전 원유 불순물 제거(전처리) 가동 이력을 관리하는 트랜잭션 테이블 | 트랜잭션 테이블 |
 
---
 
## ZTB1PP0001: PIR 데이터 테이블 <a id="ztb1pp0001"></a>
*생산 계획 수립에 사용되는 계획독립소요량(PIR) 마스터. 작성자: 엄영욱 / 2026.04.01*
 
| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | MATNR | Y | CHAR | 40 | 자재 ID | Check Table: `ZTB1MM0001`(MM 자재 마스터) |
| 3 | WERKS | Y | CHAR | 4 | 플랜트 번호 | Check Table: `ZTB1MM0000`(MM 플랜트 마스터) |
| 4 | PIR_VER | Y | CHAR | 2 | PIR 버전 | 동일 자재·플랜트 내 복수 수요 시나리오 관리용 버전 구분 |
| 5 | REQ_DATE | Y | DATS | 8 | 수요 발생 일자 | 계획독립소요량 발생 기준일 (`YYYYMMDD`) |
| 6 | REQ_QTY | N | QUAN | 13,3 | 수요 수량 | 향후 예상되는 제품별 수요 수량 |
| 7 | REQ_UNIT | N | UNIT | 3 | 수요 단위 | 수량 기준 단위 (예: `BBL`) |
| 8 | REMARK | N | CHAR | 100 | 메모 | 특이사항 기록 |
| 9~15 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |
 
---
 
## ZTB1PP0002: BOM 헤더 <a id="ztb1pp0002"></a>
*제품 구성품(BOM) 상위 헤더, 공정 수율 저장. 작성자: 엄영욱 / 2026.04.07*
 
| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | STLNR | Y | CHAR | 8 | BOM 고유 ID | BOM 마스터 고유 식별자 |
| 3 | BOMVE | Y | CHAR | 4 | BOM 버전 | 계절 비교 코드 (동일 BOM의 시즌별 수율 버전 구분) |
| 4 | MATNR | N | CHAR | 40 | 자재 ID | Check Table: `ZTB1MM0001` (완제품/반제품 자재) |
| 5 | WERKS | N | CHAR | 4 | 플랜트 ID | Check Table: `ZTB1MM0000` |
| 6 | DATUV | N | DATS | 8 | 적용 시작일 | `YYYYMMDD` |
| 7 | DATUB | N | DATS | 8 | 적용 종료일 | `YYYYMMDD` |
| 8 | BMENG | N | QUAN | 13,3 | BOM 기준 수량 | 공정 수율 산정 기준 수량 |
| 9 | BMEIN | N | UNIT | 3 | BOM 기준 단위 | 정유 도메인 표준 단위 (예: `BBL`) |
| 10~16 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |
 
---
 
## ZTB1PP0003: BOM 아이템 <a id="ztb1pp0003"></a>
*제품 투입 품목 및 원유 수율 투입 비중 상세. 작성자: 엄영욱 / 2026.04.07*
 
| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | STLNR | Y | CHAR | 8 | 부모 BOM 고유 ID | Check Table: `ZTB1PP0002` |
| 3 | STLKN | Y | NUMC | 8 | BOM Node 번호 | BOM 구성품목 내 일련번호 |
| 4 | BOMVE | Y | CHAR | 4 | BOM 버전 | Check Table: `ZTB1PP0002` |
| 5 | MATNR | N | CHAR | 40 | 자재 ID | Check Table: `ZTB1MM0001` (투입 원유/연산품) |
| 6 | FMENG | N | QUAN | 13,3 | 구성품 필요 수량 | 원유 수율 투입 비중 수량 |
| 7 | MEINS | N | UNIT | 3 | 기준 단위 | 정유 도메인 표준 단위 (예: `BBL`) |
| 8~14 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |
 
---
 
## ZTB1PP0004: Work Center 마스터 <a id="ztb1pp0004"></a>
*공정 작업을 수행하는 설비/작업장 기본 정보. 작성자: 엄영욱 / 2026.04.07*
 
| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | OBJID | Y | NUMC | 8 | WC ID | 작업장(설비) 고유 식별자 |
| 3 | OBJTY | N | CHAR | 2 | WC 종류 | 설비 유형 구분 코드 |
| 4 | ARBPL | N | CHAR | 8 | WC 이름 | 작업장 명칭 |
| 5 | WERKS | N | CHAR | 4 | 플랜트 ID | Check Table: `ZTB1MM0000` |
| 6 | BEGDA | N | DATS | 8 | WC 운영 시작일 | `YYYYMMDD` |
| 7 | ENDDA | N | DATS | 8 | WC 운영 종료일 | `YYYYMMDD` |
| 8 | KOSTL | N | CHAR | 10 | Cost Center | CO 모듈 비용 귀속 코스트센터 연동 필드 |
| 9 | AZMIN | N | INT2 | 5 | 설비 최소 처리 능력 | 설비 가동 최소 처리량 |
| 10 | AZNOR | N | INT2 | 5 | 설비 표준 처리 능력 | 설비 일반 가동 표준 처리량 |
| 11 | AZMAX | N | INT2 | 5 | 설비 한계 처리 능력 | 설비 최대(Boost) 가동 처리량 한계 |
| 12 | KAPEH | N | UNIT | 3 | 설비 처리 능력 단위 | 예: `BBL/H` |
| 13~19 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |
 
---
 
## ZTB1PP0005: Work Center 운영 스케줄 <a id="ztb1pp0005"></a>
*Work Center의 실제 운영 스케줄 관리(단위 시간 단위 재배치 가능). 작성자: 엄영욱 / 2026.04.07*
 
| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | OBJID | Y | NUMC | 8 | WC ID | Check Table: `ZTB1PP0004` |
| 3 | STRTS | Y | DEC | 15 | 시작 Timestamp | `YYYYMMDDHHMMSS` |
| 4 | ENDTS | N | DEC | 15 | 종료 Timestamp | `YYYYMMDDHHMMSS` |
| 5 | PLPR | N | NUMC | 10 | 계획/오더 번호 | Check Table: `ZTB1PP0013` |
| 6 | LOADQ | N | QUAN | 13,3 | 배정 처리능력 | 해당 시간대 배정된 실제 처리량 |
| 7 | LOADU | N | UNIT | 3 | 처리능력 단위 | 예: `BBL/H` |
| 8 | STATUS | N | CHAR | 10 | 설비 상태 | **Fixed Value**: `RUN`(가동), `DOWN`(정지), `BOOST`(증설가동) |
| 9 | LOGID | N | NUMC | 10 | 이벤트 로그 FK | Check Table: `ZTB1PP0006` (장애/재배치 이벤트 연동) |
| 10~16 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |
 
---
 
## ZTB1PP0006: Work Center 이벤트 헤더 <a id="ztb1pp0006"></a>
*작업장 비가동/이벤트 발생 이력 헤더. 작성자: 엄영욱 / 2026.04.07*
 
| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 (Check Table: `T000`) |
| 2 | LOGID | Y | NUMC | 10 | 이벤트 ID | 비가동/이벤트 고유 식별번호 |
| 3 | EVTIM | N | DEC | 15 | 이벤트 Timestamp | `YYYYMMDDHHMMSS` |
| 4 | EVNTY | N | CHAR | 10 | 이벤트 유형 | **Fixed Value**: `DOWN`(정지), `BOOST`(증설가동), `REALLOCATE`(재배치) |
| 5 | SCOBJ | N | NUMC | 8 | 원 설비 | Check Table: `ZTB1PP0004` |
| 6 | TQUAN | N | QUAN | 13,3 | 이동 총량 | 재배치/변동 발생 총 처리량 |
| 7 | UNIT | N | UNIT | 3 | 이동 단위 | Check Table: `T006`, 예: `BBL/H` |
| 8 | REASON | N | CHAR | 100 | 장애 사유 | 비가동/이벤트 발생 원인 텍스트 |
| 9~15 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |
 
---
 
## ZTB1PP0007: Work Center 이벤트 아이템 <a id="ztb1pp0007"></a>
*작업장 비가동/이벤트 상세 원인 및 세부 내역. 작성자: 엄영욱 / 2026.04.07*
 
| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 (Check Table: `T000`) |
| 2 | LOGID | Y | NUMC | 10 | 이벤트 ID | Check Table: `ZTB1PP0006` |
| 3 | ITEM_NO | Y | NUMC | 4 | 아이템 번호 | 이벤트 내 세부 항목 일련번호 |
| 4 | FROBJ | N | NUMC | 8 | 원 설비 | Check Table: `ZTB1PP0004` |
| 5 | TOOBJ | N | NUMC | 8 | 대상 설비 | Check Table: `ZTB1PP0004` (재배치 대상) |
| 6 | MVQTY | N | QUAN | 13,3 | 이동 처리량 | 설비 간 재배치된 처리량 |
| 7 | MVUNT | N | UNIT | 3 | 단위 | Check Table: `T006`, 예: `BBL/H` |
| 8~14 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |
 
---
 
## ZTB1PP0008: 공정 헤더 <a id="ztb1pp0008"></a>
*정제 공정 순서 및 공정 기본 헤더 정보(CBO). 작성자: 엄영욱 / 2026.04.07*
 
| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | PLNNR | Y | CHAR | 8 | 공정 구분 ID | 정제 공정 마스터 고유 식별자 |
| 3 | WERKS | N | CHAR | 4 | 플랜트 ID | Check Table: `ZTB1MM0000` |
| 4 | OBJTY | N | CHAR | 2 | WC 종류 | 해당 공정이 수행되는 설비 유형 |
| 5 | KTEXT | N | CHAR | 100 | 공정 설명 | 공정 명칭 (예: `상압증류`, `감압증류`) |
| 6 | DATUV | N | DATS | 8 | 유효 시작일 | `YYYYMMDD` |
| 7 | DATUB | N | DATS | 8 | 유효 종료일 | `YYYYMMDD` |
| 8~14 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |
 
---
 
## ZTB1PP0009: 공정 아이템 <a id="ztb1pp0009"></a>
*공정별 투입/산출 조건 및 세부 가동 내역(CBO). 작성자: 엄영욱 / 2026.04.07*
 
| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | PLNNR | Y | CHAR | 8 | 공정 부모 번호 | Check Table: `ZTB1PP0008` |
| 3 | PLNKN | Y | NUMC | 8 | 공정 상세 번호 | 상세 공정 간 구분 일련번호 |
| 4 | PLNVE | Y | CHAR | 4 | 공정 버전 | 공정 버전 구분 |
| 5 | LTXA1 | N | CHAR | 100 | 공정 짧은 설명 | 세부 공정 명칭 |
| 6 | VORNR | N | NUMC | 8 | 공정 순서 번호 | 공정 수행 순서 |
| 7 | BPHQT | N | QUAN | 13,3 | 공정 기준 수량 | 예: `1000` (기준 처리량) |
| 8 | BPHUN | N | UNIT | 3 | 공정 기준 단위 | 예: `BPH`(Barrel Per Hour) |
| 9 | PRCST | N | CURR | 15,2 | 공정 비용 | 예: `40` (공정 단위 처리 비용) |
| 10 | WAERS | N | CUKY | 5 | 공정 비용 통화 | 예: `$`(USD) |
| 11~17 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |
 
---
 
## ZTB1PP0010: 공정 자재 연결 <a id="ztb1pp0010"></a>
*공정과 투입 자재/연산품 간 매핑 관계. 작성자: 엄영욱 / 2026.04.07*
 
| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | PLNNR | Y | CHAR | 8 | 공정 부모 번호 | Check Table: `ZTB1PP0008` |
| 3 | PLNKN | Y | NUMC | 8 | 공정 상세 번호 | Check Table: `ZTB1PP0009` |
| 4 | MATNR | Y | CHAR | 40 | 자재 ID | Check Table: `ZTB1MM0001` |
| 5 | FLWTY | Y | CHAR | 1 | 흐름 방향 | **Fixed Value**: `I`(Input, 투입), `O`(Output, 산출) |
| 6 | REMARK | N | CHAR | 100 | 메모 | 연산품 투입 비중 등 특이사항 |
| 7~13 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |
 
---
 
## ZTB1PP0011: MRP 헤더 <a id="ztb1pp0011"></a>
*자재요소계획(MRP) 실행 단위 및 총 소요량 결과 헤더. 작성자: 엄영욱 / 2026.04.07*
 
| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | MRPNR | Y | NUMC | 10 | MRP ID | 자재소요량계획 실행 고유 번호 |
| 3 | PLWRK | N | CHAR | 4 | 플랜트 번호 | Check Table: `ZTB1MM0000` |
| 4 | RUNTS | N | DEC | 15 | 실행시간 Timestamp | `YYYYMMDDHHMMSS` |
| 5 | RNTYP | N | CHAR | 10 | 실행 유형 | **Fixed Value**: `FULL`(전체), `NET`(순소요량), `SIM`(시뮬레이션), `MAN`(수동), `AUTO`(자동) |
| 6 | PLNVE | N | CHAR | 4 | 계획 버전 | 참조 계획 버전 |
| 7 | STATUS | N | CHAR | 10 | 실행 상태 | MRP 실행 진행 상태 |
| 8 | REMARK | N | CHAR | 100 | 비고 | 특이사항 |
| 9~15 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |
 
---
 
## ZTB1PP0012: MRP 아이템 <a id="ztb1pp0012"></a>
*MRP 실행 결과에 따른 품목별 순소요량 및 보충 수량 세부 내역. 작성자: 엄영욱 / 2026.04.07*
 
| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | MRPNR | Y | NUMC | 10 | MRP 실행 ID | Check Table: `ZTB1PP0011` |
| 3 | MRPKN | Y | NUMC | 4 | MRP 노드 번호 | MRP 결과 내 세부 항목 일련번호 |
| 4 | PRMRP | N | NUMC | 8 | 부모 노드 | 상위 소요량 노드 참조 |
| 5 | MATNR | N | CHAR | 40 | 자재 ID | Check Table: `ZTB1MM0001` |
| 6 | RQDAT | N | DATS | 8 | 필요 일자 | `YYYYMMDD` |
| 7 | RQQTY | N | QUAN | 13,3 | 필요 수량 | 순소요량 산출 결과 수량 |
| 8 | RQUNT | N | UNIT | 3 | 수량 단위 | 예: `BBL` |
| 9 | ORDTY | N | CHAR | 10 | MRP 요소 유형 | 소요량/보충 근거 유형 구분 |
| 10 | PLPR | N | NUMC | 10 | 계획/오더 번호 | Check Table: `ZTB1PP0013` (보충 계획오더 연동) |
| 11~17 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |
 
---
 
## ZTB1PP0013: 생산계획/생산오더 헤더 <a id="ztb1pp0013"></a>
*생산계획 및 확정된 생산오더의 상위 헤더 정보. 작성자: 엄영욱 / 2026.04.23*
 
| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | PLPR | Y | NUMC | 10 | 계획/오더 번호 | 생산계획 및 생산오더 고유 식별번호 |
| 3 | PLNTY | Y | CHAR | 4 | 계획/오더 구분 | **Fixed Value**: `PLN`(생산계획), `ORD`(확정 생산오더) |
| 4 | WERKS | N | CHAR | 4 | 플랜트 | Check Table: `ZTB1MM0000` |
| 5 | MATNR | N | CHAR | 40 | 자재 ID | Check Table: `ZTB1MM0001` (생산 대상 자재) |
| 6 | ORQTY | N | QUAN | 13,3 | 생산 수량 | 계획/확정 생산 수량 |
| 7 | ORUNT | N | UNIT | 3 | 수량 단위 | 예: `BBL` |
| 8 | SDATE | N | CHAR | 8 | 시작일 | `YYYYMMDD` |
| 9 | PEDAT | N | DATS | 8 | 종료 예정일 | `YYYYMMDD` |
| 10 | EDATE | N | DATS | 8 | 종료일 | 실제 종료일 (`YYYYMMDD`) |
| 11 | PLNVE | N | CHAR | 4 | 계획 버전 | 참조 계획 버전 |
| 12 | STLNR | N | CHAR | 8 | 참조 BOM ID | Check Table: `ZTB1PP0002` (선택된 BOM) |
| 13 | BOMVE | N | CHAR | 4 | 참조 BOM 버전 | Check Table: `ZTB1PP0002` (선택된 BOM 버전) |
| 14 | PLNNR | N | CHAR | 8 | 참조 공정 ID | Check Table: `ZTB1PP0008` (선택된 공정) |
| 15 | REMARK | N | CHAR | 100 | 비고 | 특이사항 |
| 16~22 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |
 
---
 
## ZTB1PP0014: 생산계획/생산오더 아이템 <a id="ztb1pp0014"></a>
*생산계획 및 오더별 공정 투입/산출 자재 세부 라인. 작성자: 엄영욱 / 2026.04.23*
 
| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | PLPR | Y | NUMC | 10 | 계획/오더 번호 | Check Table: `ZTB1PP0013` |
| 3 | PLNTY | Y | CHAR | 4 | 계획/오더 구분 | **Fixed Value**: `PLN`(생산계획), `ORD`(확정 생산오더) |
| 4 | PLPKN | Y | NUMC | 4 | PLPR 아이템 번호 | 오더 내 일련번호 (예: `00000001`~) |
| 5 | PLNNR | N | CHAR | 8 | 공정 ID | Check Table: `ZTB1PP0008` (공정 참조 시) |
| 6 | PLNKN | N | NUMC | 8 | 공정 상세 번호 | Check Table: `ZTB1PP0009` (공정 Item 참조) |
| 7 | VORNR | N | NUMC | 8 | 공정 순서 번호 | Operation No. |
| 8 | MATNR | N | CHAR | 40 | 산출 자재 ID | Check Table: `ZTB1MM0001` |
| 9 | POQTY | N | QUAN | 13,3 | 예측 생산 수량 | 항목별 예상 산출 수량 |
| 10 | MEINS | N | UNIT | 3 | 단위 | 예: `BBL` |
| 11 | DATUV | N | DATS | 8 | 적용 시작일 | `YYYYMMDD` |
| 12 | REMARK | N | CHAR | 100 | 비고 | 특이사항 |
| 13~19 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |
 
---
 
## ZTB1PP0015: 전처리 내역 (Pre Process) <a id="ztb1pp0015"></a>
*정제 공정 투입 전 원유 불순물 제거(탈염) 가동 이력. 작성자: 엄영욱 / 2026.04.07*
 
| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | RUNID | Y | NUMC | 10 | 탈염 실행 ID | 원유 전처리(탈염) 실행 고유번호 |
| 3 | MATNR | N | CHAR | 40 | 원유 자재 | Check Table: `ZTB1MM0001` |
| 4 | WERKS | N | CHAR | 4 | 플랜트 | Check Table: `ZTB1MM0000` |
| 5 | LGORT | N | CHAR | 4 | 저장위치 | Check Table: `ZTB1MM0000` |
| 6 | PREQT | N | QUAN | 13,3 | 탈염 수량 | 전처리 대상 원유 처리 수량 |
| 7 | MEINS | N | UNIT | 3 | 단위 | 예: `BBL` |
| 8 | RNDAT | N | DATS | 8 | 탈염 실행일 | `YYYYMMDD` |
| 9 | AVDAT | N | DATS | 8 | 가용 전환일 | 전처리 완료 후 가용재고 전환일 (`YYYYMMDD`) |
| 10 | STATS | N | CHAR | 1 | 처리상태 | 전처리 진행 상태 구분 코드 |
| 11~17 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |
 
