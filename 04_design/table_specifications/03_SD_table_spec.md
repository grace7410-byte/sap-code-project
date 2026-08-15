# [Design] SD (영업 관리) 모듈 테이블 명세서

**최종 수정일**: 2026-08-16  
**상태**: 확정 (Approved)   
**버전**: v2.0 (MM/PP 스펙 템플릿과 컬럼 구조 통일)

> 💡 **문서 연결 가이드**: 타 문서에서 특정 테이블로 링크를 걸 때는 본 파일 경로 뒤에 `#테이블명` 앵커를 사용  
> *예시: `[대금 청구 아이템 스펙](04_design/table_specifications/03_SD_table_spec.md#ztb1sd0011)`*

---

## 테이블 목차 (Index)

| 순번 | 테이블명 | 설명 | 테이블 유형 |
| :--- | :--- | :--- | :--- |
| 1 | [`ZTB1SD0001`](#ztb1sd0001) | 전사 거래처(BP)의 기본 일반 정보를 관리하는 마스터 테이블 | 마스터 테이블 |
| 2 | [`ZTB1SD0002`](#ztb1sd0002) | BP별 회계 조정계정(자산/부채 성격) 연결 정보를 관리하는 마스터 테이블 | 마스터 테이블 |
| 3 | [`ZTB1SD0003`](#ztb1sd0003) | 판매 조직·유통경로 기준 고객(BP) 확장 정보를 관리하는 마스터 테이블 | 마스터 테이블 |
| 4 | [`ZTB1SD0004`](#ztb1sd0004) | 자재별 판매 가격 조건(MOPS 연동 프리미엄가)을 관리하는 마스터 테이블 | 마스터 테이블 |
| 5 | [`ZTB1SD0005`](#ztb1sd0005) | 판매오더 확정 시점의 가격 산정 로그를 저장하는 트랜잭션 테이블 | 트랜잭션 테이블 |
| 6 | [`ZTB1SD0006`](#ztb1sd0006) | 판매오더(SO) 상위 헤더 정보를 관리하는 트랜잭션 테이블 | 트랜잭션 테이블 |
| 7 | [`ZTB1SD0007`](#ztb1sd0007) | 판매오더 품목별 상세 라인을 관리하는 트랜잭션 테이블 | 트랜잭션 테이블 |
| 8 | [`ZTB1SD0008`](#ztb1sd0008) | 출고(납품) 문서 헤더 정보를 관리하는 트랜잭션 테이블(LIKP) | 트랜잭션 테이블 |
| 9 | [`ZTB1SD0009`](#ztb1sd0009) | 출고(납품) 문서 품목별 상세 라인을 관리하는 트랜잭션 테이블(LIPS) | 트랜잭션 테이블 |
| 10 | [`ZTB1SD0010`](#ztb1sd0010) | 대금 청구(송장) 문서 헤더 정보를 관리하는 트랜잭션 테이블(VBRK) | 트랜잭션 테이블 |
| 11 | [`ZTB1SD0011`](#ztb1sd0011) | 대금 청구 문서 품목별 상세 라인을 관리하는 트랜잭션 테이블(VBRP) | 트랜잭션 테이블 |
| 12 | [`ZTB1SD0012`](#ztb1sd0012) | SD에서 발생한 재고 보충 요청 내역을 관리하는 트랜잭션 테이블 | 트랜잭션 테이블 |
| 13 | [`ZTB1SD0013`](#ztb1sd0013) | 공통 코드·화면 출력용 다국어 텍스트를 관리하는 마스터 테이블 | 마스터 테이블 |
| 14 | [`ZTB1SD0014`](#ztb1sd0014) | 프로세스 흐름도(Node) 구성 요소를 관리하는 마스터 테이블 | 마스터 테이블 |
| 15 | [`ZTB1SD0015`](#ztb1sd0015) | 프로세스 흐름도의 노드 간 연결(Edge) 정보를 관리하는 마스터 테이블 | 마스터 테이블 |
| 16 | [`ZTB1SD0016`](#ztb1sd0016) | 프로세스 흐름도 노드별 실행 상태 및 결과 문서를 기록하는 트랜잭션 테이블 | 트랜잭션 테이블 |
| 17 | [`ZTB1SD0017`](#ztb1sd0017) | 화면/트랜잭션 코드 단위 프로그램 정보를 관리하는 마스터 테이블 | 마스터 테이블 |
| 18 | [`ZTB1SD0018`](#ztb1sd0018) | 전사 비즈니스 프로세스 정의 정보를 관리하는 마스터 테이블 | 마스터 테이블 |
| 19 | [`ZTB1SD0019`](#ztb1sd0019) | 프로세스 흐름도 노드와 실행 프로그램 간 매핑 정보를 관리하는 마스터 테이블 | 마스터 테이블 |
| 20 | [`ZTB1SD0020`](#ztb1sd0020) | 프로그램과 소속 모듈 간 매핑 정보를 관리하는 마스터 테이블 | 마스터 테이블 |

---

## ZTB1SD0001: BP 마스터 일반 <a id="ztb1sd0001"></a>
*작성자: 최지수 / 2026.03.25*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | BPID | Y | CHAR | 10 | BP 코드 | 전사 고유 거래처(BP) 식별 코드 |
| 3 | BPTYP | Y | CHAR | 4 | BP 유형 | **Fixed Value**: `1`(공급업체), `2`(고객) |
| 4 | BPNM | N | CHAR | 40 | BP 명 | 거래처명 |
| 5 | ADDR | N | CHAR | 60 | 업체주소 | |
| 6 | CNTCD | N | CHAR | 3 | 국가 코드 | |
| 7 | BIZNO | N | CHAR | 16 | 사업자 번호 | |
| 8 | EMAIL | N | CHAR | 60 | 이메일 | |
| 9 | ACCNO | N | CHAR | 18 | 계좌번호 | 하나의 BP에 하나의 은행/계좌번호만 관리 |
| 10 | BANK | N | CHAR | 60 | 은행명 | 하나의 BP에 하나의 은행/계좌번호만 관리 |
| 11 | WAERS | N | CUKY | 5 | 통화 코드 | |
| 12 | PICNM | N | CHAR | 40 | 거래처 담당자 | |
| 13 | PICTL | N | CHAR | 30 | 거래처 담당자 전화번호 | |
| 14~20 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |

---

## ZTB1SD0002: BP 조정 계정 마스터 <a id="ztb1sd0002"></a>
*이 BP가 회계 관점에서 어떤 성격의 자산/부채 계정으로 연결되는지 관리. 작성자: 강효창 / 2026.03.26*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | BPID | Y | CHAR | 10 | BP 코드 | Search Help: `KRED_C` |
| 3 | BPTYP | Y | CHAR | 4 | BP 유형 | **Fixed Value**: `1`(공급업체), `2`(고객), `3`(세관), `4`(운송업체) |
| 4 | RECON | N | CHAR | 8 | 조정계정 | 해당 BP가 연결되는 회계상 자산/부채 조정계정(G/L) |
| 5~11 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |

---

## ZTB1SD0003: 고객 마스터 (판매) <a id="ztb1sd0003"></a>
*작성자: 최지수 / 2026.03.25*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | BPID | Y | CHAR | 10 | 고객코드 | BP 마스터(`ZTB1SD0001`) 외래키 연동 |
| 3 | VKORG | Y | CHAR | 4 | 영업조직 | **Fixed Value**: `1000`(국내), `2000`(해외) |
| 4 | VTWEG | Y | CHAR | 2 | 유통경로 | **Fixed Value**: `10`(직판/주유소), `20`(도매/기업거래), `2000-10`(해외수출) |
| 5 | SPART | Y | CHAR | 2 | 제품군 | **Fixed Value**: `10`(연료유), `20`(아스팔트), `30`(석유화학) |
| 6 | ZTERM | N | CHAR | 4 | 지급 조건 키 | **Fixed Value**: `0001`(즉시지급), `0002`(14일이내), `0003`(30일이내) |
| 7 | INCO1 | N | CHAR | 3 | 인도조건 | |
| 8 | TAXCL | N | CHAR | 1 | 고객 세금 분류 | **Fixed Value**: `0`(면세 고객), `1`(과세 고객) |
| 9 | TAXTY | N | CHAR | 1 | 과세 유형 | **Fixed Value**: `0`(수출), `1`(국내) |
| 10 | ZVIP | N | CHAR | 1 | VIP 여부 | 우수고객 지정 여부 |
| 11~17 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |

---

## ZTB1SD0004: 가격 조건 마스터 <a id="ztb1sd0004"></a>
*작성자: 최지수 / 2026.03.25*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | KSCHL | Y | CHAR | 4 | 조건 타입 | 가격결정 조건유형 코드 (fixed value) |
| 3 | MATNR | Y | CHAR | 40 | 자재 번호 | Check Table: `ZTC2CNMM0001` |
| 4 | DATAB | Y | DATS | 8 | 유효시작일 | |
| 5 | ZPREM | N | CURR | 15,2 | 프리미엄가 | 프리미엄가(마진). 예: `50`이면 리터당 50원을 더 받겠다는 의미 |
| 6 | STPRS | N | CURR | 15,2 | MOPS 값 | |
| 7 | UKURS | N | DEC | 9,5 | 환율 | |
| 8 | WAERS_STPRS | N | CUKY | 5 | MOPS 통화키 | 예: `USD` |
| 9 | DATBI | N | DATS | 8 | 유효종료일 | 예: `9999.12.31` |
| 10 | WAERS | N | CUKY | 5 | 통화키 | 예: `KRW` |
| 11 | KPEIN | N | DEC | 5 | 가격 단위 | 예: `100` |
| 12 | MEINS | N | UNIT | 3 | UoM | 예: `BBL` |
| 13~19 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |

---

## ZTB1SD0005: 판매오더 가격 로그 테이블 <a id="ztb1sd0005"></a>
*작성자: 최지수 / 2026.03.25*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | VBELN | Y | CHAR | 10 | 판매오더번호 | 판매오더 아이템 참조 |
| 3 | POSNR | Y | NUMC | 4 | 아이템번호 | 판매오더 아이템 참조 |
| 4 | KSCHL | Y | CHAR | 4 | 조건타입 | |
| 5 | ZPREM | N | CURR | 15,2 | 프리미엄가 | |
| 6 | STPRS | N | CURR | 15,2 | MOPS값 | FI - MOPS 테이블 연동 |
| 7 | WAERS_STPRS | N | CUKY | 5 | MOPS 통화코드 | |
| 8 | UKURS | N | DEC | 9,5 | 환율 | FI - 환율 테이블 연동 |
| 9 | NETPR | N | CURR | 15,2 | 단가 | **[산식]**: `(MOPS × 환율) + 프리미엄` |
| 10 | KWMENG | N | QUAN | 13,3 | 주문 수량 | |
| 11 | MEINS | N | UNIT | 3 | UoM | 예: `BBL` |
| 12 | NETVL | N | CURR | 15,2 | 순 금액 | **[산식]**: `단가 × 수량` |
| 13 | WAERS | N | CUKY | 5 | 통화키 | |
| 14 | MWSKZ | N | CHAR | 2 | 세금코드 | **Fixed Value**: `A0`(과세 10%), `A1`(영세 0%) |
| 15~20 | 시스템 필드 | - | - | - | 이력 관리 | 생성/변경 이력 타임스탬프 필드 일체 (`ERNAM`, `ERDAT`, `ERZET`, `AENAM`, `AEDAT`, `AEZET`) |

---

## ZTB1SD0006: 판매 오더 헤더 테이블 <a id="ztb1sd0006"></a>
*작성자: 최지수 / 2026.03.25*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | VBELN | Y | CHAR | 10 | 판매 오더 번호 | 판매 문서의 고유 식별자 |
| 3 | VKORG | Y | CHAR | 4 | 영업조직 | **Fixed Value**: `1000`(국내), `2000`(해외) (BP마스터 참조) |
| 4 | VTWEG | Y | CHAR | 2 | 유통경로 | **Fixed Value**: `10`(직판/주유소), `20`(도매/기업거래), `30`(해외수출) |
| 5 | SOTYP | N | CHAR | 4 | 판매 오더 유형 | 예: `OR`(표준오더) |
| 6 | BPID | N | CHAR | 10 | 고객 코드 | 고객 BP 아이디 |
| 7 | ORDDA | N | DATS | 8 | 오더 주문일 | |
| 8 | VDATU | N | DATS | 8 | 픽업 요청일 | |
| 9 | PLDDA | N | DATS | 8 | 출하 예정일 | |
| 10 | SOLDT | N | CHAR | 10 | 판매처 | BP 마스터(일반) 참조 |
| 11 | SHIPT | N | CHAR | 10 | 납품처 | BP 마스터(일반) 참조 |
| 12 | ZTERM | N | CHAR | 4 | 지급 조건 키 | |
| 13 | INCO1 | N | CHAR | 3 | 인도조건 | |
| 14 | TAXCL | N | CHAR | 1 | 고객 세금 분류 | **Fixed Value**: `0`(면세 고객), `1`(과세 고객) |
| 15 | TAXTY | N | CHAR | 1 | 과세 유형 | **Fixed Value**: `0`(수출), `1`(국내) |
| 16 | SOSTA | N | CHAR | 3 | 판매오더상태 | 공통 코드 참고 |
| 17~23 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |

---

## ZTB1SD0007: 판매 오더 아이템 테이블 <a id="ztb1sd0007"></a>
*작성자: 최지수 / 2026.03.25*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | VBELN | Y | CHAR | 10 | 판매 문서 번호 | 판매오더 헤더 참조 |
| 3 | POSNR | Y | NUMC | 4 | 판매 문서 항목 | |
| 4 | WERKS | N | CHAR | 4 | 플랜트 코드 | Check Table: `ZTC2CNMM0000` |
| 5 | LGORT | N | CHAR | 4 | 재고 저장위치 | Check Table: `ZTC2CNMM0000` |
| 6 | SPART | N | CHAR | 2 | 제품군 | **Fixed Value**: `10`(연료유), `20`(아스팔트), `30`(석유화학) |
| 7 | MATNR | N | CHAR | 40 | 자재번호 | Check Table: `ZTC2CNMM0001` |
| 8 | KWMENG | N | QUAN | 13,3 | 주문 수량 | |
| 9 | NETPR | N | CURR | 15,2 | 단가 | 가격결정 테이블 - `PR00`값(세전금액) |
| 10 | MEINS | N | UNIT | 3 | UoM | 예: `BBL` |
| 11 | NETVL | N | CURR | 15,2 | 순 금액 | **[산식]**: `단가 × 수량` |
| 12 | WAERS | N | CUKY | 5 | 통화키 | |
| 13~18 | 시스템 필드 | - | - | - | 이력 관리 | 생성/변경 이력 타임스탬프 필드 일체 (`ERNAM`, `ERDAT`, `ERZET`, `AENAM`, `AEDAT`, `AEZET`) |

---

## ZTB1SD0008: 출고 문서 헤더 테이블(LIKP) <a id="ztb1sd0008"></a>
*작성자: 최지수 / 2026.03.25*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | VBELN | Y | CHAR | 10 | 출고 문서 번호 | |
| 3 | VBELN_VA | N | CHAR | 10 | 판매 오더 번호 | 판매오더 헤더 참조 |
| 4 | LFDAT | N | DATS | 8 | 출고일 | |
| 5 | SHIPT | N | CHAR | 10 | 납품처 | BP 마스터(일반) 참조 |
| 6 | ZTERM | N | CHAR | 4 | 지급 조건 키 | |
| 7 | INCO1 | N | CHAR | 3 | 인도조건 | |
| 8 | TAXCL | N | CHAR | 1 | 고객 세금 분류 | **Fixed Value**: `0`(면세 고객), `1`(과세 고객) |
| 9 | TAXTY | N | CHAR | 1 | 과세 유형 | **Fixed Value**: `0`(수출), `1`(국내) |
| 10~15 | 시스템 필드 | - | - | - | 이력 관리 | 생성/변경 이력 타임스탬프 필드 일체 (`ERNAM`, `ERDAT`, `ERZET`, `AENAM`, `AEDAT`, `AEZET`) |

---

## ZTB1SD0009: 출고 문서 아이템 테이블(LIPS) <a id="ztb1sd0009"></a>
*작성자: 최지수 / 2026.03.25*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | VBELN | Y | CHAR | 10 | 출고 문서 번호 | 출고문서 헤더 참조 |
| 3 | POSNR | Y | NUMC | 4 | 항목 번호 | |
| 4 | VBELN_VA | N | CHAR | 10 | 참조 판매 문서 번호 | 판매오더 아이템 참조 |
| 5 | POSNR_VA | N | NUMC | 4 | 참조 판매 항목 번호 | 판매오더 아이템 참조 |
| 6 | WERKS | N | CHAR | 4 | 플랜트 코드 | Check Table: `ZTC2CNMM0000` |
| 7 | LGORT | N | CHAR | 4 | 재고 저장위치 | Check Table: `ZTC2CNMM0000` |
| 8 | MATNR | N | CHAR | 40 | 자재 번호 | |
| 9 | LFIMG | N | QUAN | 13,3 | 실제 납품 수량 | |
| 10 | MEINS | N | UNIT | 3 | UoM | |
| 11~16 | 시스템 필드 | - | - | - | 이력 관리 | 생성/변경 이력 타임스탬프 필드 일체 (`ERNAM`, `ERDAT`, `ERZET`, `AENAM`, `AEDAT`, `AEZET`) |

---

## ZTB1SD0010: 대금 청구 헤더 테이블(VBRK) <a id="ztb1sd0010"></a>
*작성자: 최지수 / 2026.03.25*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | VBELN | Y | CHAR | 10 | 청구 문서 번호 | |
| 3 | VBELN_VA | N | CHAR | 10 | 출고 문서 번호 | 출고문서 헤더 참조 |
| 4 | FKDAT | N | DATS | 8 | 청구일 | |
| 5 | NETWR | N | CURR | 15,2 | 순 금액 합계 | |
| 6 | MWSTS | N | CURR | 15,2 | 총 세금금액 | **[구성]**: 유류세 + 부가세 |
| 7 | EXVWR | N | CURR | 15,2 | 총 유류세액 | |
| 8 | VATWR | N | CURR | 15,3 | 총 부가세액 | |
| 9 | DMBTR | N | CURR | 15,2 | 총 청구 금액 | **[산식]**: `NETWR + MWSTS` (최종 입금받을 금액) |
| 10 | WAERS | N | CUKY | 5 | 통화 코드 | |
| 11 | ZTERM | N | CHAR | 4 | 지급 조건 키 | |
| 12 | INCO1 | N | CHAR | 3 | 인도조건 | |
| 13 | TAXCL | N | CHAR | 1 | 고객 세금 분류 | **Fixed Value**: `0`(면세 고객), `1`(과세 고객) |
| 14 | TAXTY | N | CHAR | 1 | 과세 유형 | **Fixed Value**: `0`(수출), `1`(국내) |
| 15 | STATUS | N | CHAR | 1 | 대금 청구 상태 | 공통 코드 참고 |
| 16~21 | 시스템 필드 | - | - | - | 이력 관리 | 생성/변경 이력 타임스탬프 필드 일체 (`ERNAM`, `ERDAT`, `ERZET`, `AENAM`, `AEDAT`, `AEZET`) |

---

## ZTB1SD0011: 대금 청구 아이템 테이블(VBRP) <a id="ztb1sd0011"></a>
*작성자: 최지수 / 2026.03.25*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | VBELN | Y | CHAR | 10 | 청구 문서 번호 | 대금 청구 헤더 참조 |
| 3 | POSNR | Y | NUMC | 4 | 항목 번호 | |
| 4 | VBELN_VA | N | CHAR | 10 | 참조 출고 문서 번호 | 판매오더 번호 |
| 5 | POSNR_VA | N | NUMC | 4 | 참조 DO 항목 번호 | |
| 6 | MATNR | N | CHAR | 40 | 자재번호 | 자재마스터 참조 |
| 7 | FKIMG | N | QUAN | 13,3 | 실제 청구 수량 | |
| 8 | MEINS | N | UNIT | 3 | UoM | |
| 9 | NETVL | N | CURR | 15,2 | 순금액 | 가격결정 로그 테이블(`ZTB1SD0005`) - `PR00` 값 |
| 10 | EXTAX | N | CURR | 15,2 | 유류세 | 가격결정 로그 테이블(`ZTB1SD0005`) - `TAX` 합 |
| 11 | VATVL | N | CURR | 15,2 | 부가세 | |
| 12 | WAERS | N | CUKY | 5 | 통화키 | |
| 13 | MWSKZ | N | CHAR | 2 | 세금코드 | |
| 14~19 | 시스템 필드 | - | - | - | 이력 관리 | 생성/변경 이력 타임스탬프 필드 일체 (`ERNAM`, `ERDAT`, `ERZET`, `AENAM`, `AEDAT`, `AEZET`) |

---

## ZTB1SD0012: 재고 보충 요청 테이블 <a id="ztb1sd0012"></a>
*작성자: 강효창 / 2026.03.26*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | REQ_NO | Y | CHAR | 10 | 보충 요청 번호 | |
| 3 | MATNR | N | CHAR | 40 | 자재 코드 | Check Table: `ZTB1MM0003` |
| 4 | WERKS | N | CHAR | 4 | 플랜트 | |
| 5 | LGORT | N | CHAR | 4 | 저장창고 | |
| 6 | REQ_DATE | N | DATS | 8 | 요청일자 | |
| 7 | REQ_QTY | N | QUAN | 5 | 요청 수량 | |
| 8 | MEINS | N | UNIT | 3 | UoM | |
| 9 | REQ_STATUS | N | CHAR | 1 | 요청 상태 | **Fixed Value**: `R`(요청), `A`(승인), `D`(반려) |
| 10 | SUPPLY_DATE | N | DATS | 8 | 공급 예정일 | |
| 11~17 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |

---

## ZTB1SD0013: 텍스트 테이블 <a id="ztb1sd0013"></a>
*작성자: 최지수 / 2026.03.25*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | DIV | Y | CHAR | 5 | 데이터 구분 코드 | 공통코드 그룹 구분 |
| 3 | CODE | Y | CHAR | 20 | 실제 코드 값 | |
| 4 | SPARS | Y | SPARS | 1 | 언어 | 다국어 식별자 |
| 5 | TEXT | N | CHAR | 100 | 텍스트 | 화면 출력용 텍스트 |
| 6~11 | 시스템 필드 | - | - | - | 이력 관리 | 생성/변경 이력 타임스탬프 필드 일체 (`ERNAM`, `ERDAT`, `ERZET`, `AENAM`, `AEDAT`, `AEZET`) |

---

## ZTB1SD0014: Node 테이블 <a id="ztb1sd0014"></a>
*작성자: 엄영욱 / 2026.07.01*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | PROC_ID | Y | CHAR | 20 | 프로세스 ID | Check Table: `ZTB1SD0018` |
| 3 | NODE_ID | Y | CHAR | 20 | 노드 ID | |
| 4 | NODE_SEQ | N | NUMC | 4 | 노드 순서 | |
| 5 | NODE_TITLE | N | CHAR | 40 | 노드명 | |
| 6 | NODE_DESC | N | CHAR | 80 | 노드 설명 | |
| 7 | NODE_TYPE | N | CHAR | 10 | 노드 유형 | |
| 8 | SEM_OBJ | N | CHAR | 40 | Semantic Object | Fiori 타일 연동용 |
| 9 | ACTION | N | CHAR | 20 | Action | Fiori 타일 연동용 |
| 10 | ACTIVE | N | CHAR | 1 | 사용 여부 | |
| 11 | LANE_ID | N | CHAR | 20 | 노드 영역 | 프로세스 흐름도 상 Lane(구간) 구분 |
| 12 | EXECUTABLE | N | CHAR | 1 | 노드 클릭 가능 여부 | |
| 13~19 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |

---

## ZTB1SD0015: EDGE 테이블 <a id="ztb1sd0015"></a>
*작성자: 엄영욱 / 2026.07.01*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | PROC_ID | Y | CHAR | 20 | 프로세스 ID | Check Table: `ZTB1SD0018` |
| 3 | EDGE_ID | Y | CHAR | 20 | 연결 ID | |
| 4 | FROM_NODE | N | CHAR | 20 | 시작 노드 | Check Table: `ZTB1SD0014` |
| 5 | TO_NODE | N | CHAR | 20 | 도착 노드 | Check Table: `ZTB1SD0014` |
| 6 | EDGE_SEQ | N | NUMC | 4 | 연결 순서 | |
| 7 | COND_TEXT | N | CHAR | 40 | 조건 텍스트 | 분기 조건 표시 텍스트 |
| 8 | ACTIVE | N | CHAR | 1 | 사용 여부 | |
| 9~15 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |

---

## ZTB1SD0016: NODE 실행 상태 <a id="ztb1sd0016"></a>
*작성자: 엄영욱 / 2026.07.01*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | PROC_ID | Y | CHAR | 20 | 프로세스 ID | Check Table: `ZTB1SD0018` |
| 3 | NODE_ID | Y | CHAR | 20 | 노드 ID | Check Table: `ZTB1SD0014` |
| 4 | RUN_ID | Y | NUMC | 4 | 실행 단위 ID | |
| 5 | REF_DOC_NO | Y | CHAR | 20 | 노드 참조 문서 번호 | |
| 6 | RESULT_DOC_NO | N | CHAR | 20 | 해당 단계 결과 문서번호 | |
| 7 | RESULT_DOC_TYPE | N | CHAR | 10 | 결과 문서 유형 | |
| 8 | NODE_STATUS | N | CHAR | 10 | 노드 상태 | |
| 9 | STATUS_TEXT | N | CHAR | 40 | 노드 상태 텍스트 | |
| 10 | EXECUTED | N | CHAR | 1 | 노드 실행 여부 | |
| 11 | SAVED | N | CHAR | 1 | 노드 최종 저장 여부 | |
| 12 | EXEC_DATE | N | DATS | 8 | 실행일 | |
| 13 | EXEC_TIME | N | TIMS | 6 | 실행 시간 | |
| 14 | EXEC_USER | N | CHAR | 12 | 실행자 | |
| 15 | SAVE_DATE | N | DATS | 8 | 저장일 | |
| 16 | SAVE_TIME | N | TIMS | 6 | 저장 시간 | |
| 17 | SAVE_USER | N | CHAR | 12 | 저장자 | |
| 18~24 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |

---

## ZTB1SD0017: 프로그램 마스터 <a id="ztb1sd0017"></a>
*작성자: 엄영욱 / 2026.07.01*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | PROGRAM_ID | Y | CHAR | 20 | 프로그램 ID | |
| 3 | TCODE | N | CHAR | 20 | 실행 코드 | |
| 4 | PROGRAM_TITLE | N | CHAR | 40 | 프로그램 명 | |
| 5 | SEM_OBJ | N | CHAR | 40 | Semantic Object | Fiori 타일 연동용 |
| 6 | ACTION | N | CHAR | 20 | Action | Fiori 타일 연동용 |
| 7 | TILE_CREATED | N | CHAR | 1 | 타일 생성 여부 | |
| 8 | EXECUTABLE | N | CHAR | 1 | 노드 클릭 가능 여부 | |
| 9 | ACTIVE | N | CHAR | 1 | 사용 여부 | |
| 10 | PROGRAM_TYPE | N | CHAR | 10 | 프로그램 타입 | |
| 11 | MODULE_ID | N | CHAR | 10 | 대표 모듈 | |
| 12~18 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |

---

## ZTB1SD0018: 프로세스 마스터 <a id="ztb1sd0018"></a>
*작성자: 엄영욱 / 2026.07.01*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | PROC_ID | Y | CHAR | 20 | 프로세스 ID | |
| 3 | PROC_TITLE | N | CHAR | 60 | 프로세스명 | |
| 4 | PROC_DESC | N | CHAR | 255 | 프로세스 설명 | |
| 5 | MAIN_MODULE | N | CHAR | 10 | 대표 모듈 | |
| 6 | RELATED_MODULES | N | CHAR | 50 | 관련 모듈 | |
| 7 | DISPLAY_SEQ | N | NUMC | 4 | 표시 순서 | |
| 8 | ICON | N | CHAR | 40 | 아이콘 | |
| 9 | ACTIVE | N | CHAR | 1 | 사용 여부 | |
| 10 | PROCESS_TYPE | N | CHAR | 10 | 프로세스 유형 | |
| 11~17 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |

---

## ZTB1SD0019: 프로그램 마스터 (노드-프로그램 매핑) <a id="ztb1sd0019"></a>
*작성자: 엄영욱 / 2026.07.01*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | PROC_ID | Y | CHAR | 20 | 프로세스 ID | Check Table: `ZTB1SD0018` |
| 3 | NODE_ID | Y | CHAR | 20 | 노드 ID | Check Table: `ZTB1SD0014` |
| 4 | PROGRAM_ID | Y | CHAR | 20 | 프로그램 ID | Check Table: `ZTB1SD0017` |
| 5 | STEP_SEQ | N | NUMC | 4 | 실행 순서 | |
| 6 | MODULE_ID | N | CHAR | 10 | 대표 모듈 | |
| 7 | IN_PROCESS | N | CHAR | 1 | 상세 프로세스 포함 여부 | |
| 8 | RELATED_TILE | N | CHAR | 1 | 첫 화면 관련 타일 활성화 여부 | |
| 9 | ACTIVE | N | CHAR | 1 | 사용 여부 | |
| 10~16 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |

---

## ZTB1SD0020: 프로그램 모듈 매핑 <a id="ztb1sd0020"></a>
*작성자: 엄영욱 / 2026.07.01*

| 번호 | 필드명 | Key | 타입 | 길이 | Description | 비고 및 비즈니스 제약 조건 / 예시 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| 1 | MANDT | Y | CLNT | 3 | 클라이언트 | 시스템 기본값 |
| 2 | PROGRAM_ID | Y | CHAR | 20 | 프로그램 ID | Check Table: `ZTB1SD0017` |
| 3 | MODULE_ID | Y | CHAR | 10 | 대표 모듈 | |
| 4 | ACTIVE | N | CHAR | 1 | 사용 여부 | |
| 5~11 | 시스템 필드 | - | - | - | 이력 및 삭제 관리 | 삭제 표시(`LVORM`) 및 생성/변경 이력 타임스탬프 필드 일체 |
