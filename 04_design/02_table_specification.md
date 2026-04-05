# 02_table_specification.md

## 1. Data Schema Overview (DBML)
본 프로젝트의 테이블 구조와 외래 키(Ref) 관계를 정의한 데이터 스키마임. 

### 1.1 Material Management (MM)
*자재 마스터, 구매 오더, 이동 문서 및 부피 보정 테이블 정의*

| 핵심 테이블 | 용도 |
| :--- | :--- |
| **ZTB1MM0001** | 자재 마스터 (Material Master) |
| **ZTB1MM0006** | 구매오더 헤더 (PO Header) |
| **ZTB1MM0011** | 자재 이동 문서 헤더 (Material Document) |
| **ZTB1MM0020** | 부피 측정 테이블 (Volume Measurement - 정유 특화) |

<details>
<summary>MM 상세 테이블 스키마 코드 보기</summary>
  
```dbml
/* ===== MM ===== */
Table ZTB1MM0000 {
  MANDT varchar(3) [pk]
  WERKS varchar(4) [pk]
  LGORT varchar(4) [pk]
  NAME1 varchar(30)
  LGOBE varchar(16)
}
Table ZTB1MM0001 {
  MANDT varchar(3) [pk]
  MATNR varchar(40) [pk]
  MTART varchar(4)
  SPART varchar(2)
  MEINS varchar(3)
  BKLAS varchar(4)
  BESKZ varchar(1)
  KZKUP varchar(1)
  ART varchar(8)
  STRGR varchar(2)
  MTVFP varchar(2)
  PLIFZ decimal(3,0)
  VEPPR decimal(15,2)
  WAERS varchar(5)
}
Table ZTB1MM0002 {
  MANDT varchar(3) [pk]
  MATNR varchar(40) [pk]
  SPRAS varchar(1) [pk]
  MAKTX varchar(40)
  MAKTG varchar(40)
}
Ref: ZTB1MM0002.MATNR > ZTB1MM0001.MATNR

Table ZTB1MM0003 {
  MANDT varchar(3) [pk]
  MATNR varchar(40) [pk]
  WERKS varchar(4) [pk]
  LGORT varchar(4) [pk]
  MEINS varchar(3)
  LABST decimal(13,3)
  AVSTK decimal(13,3)
  SPEME decimal(13,3)
  INSME decimal(13,3)
  TRAME decimal(13,3)
  RETME decimal(13,3)
  SALK3 decimal(15,2)
  WAERS varchar(5)
}
Ref: ZTB1MM0003.MATNR > ZTB1MM0001.MATNR
Ref: ZTB1MM0003.WERKS > ZTB1MM0000.WERKS
Ref: ZTB1MM0003.LGORT > ZTB1MM0000.LGORT

Table ZTB1MM0004 {
  MANDT varchar(3) [pk]
  BPID varchar(10) [pk]
  EKORG varchar(4)
  EKGRP varchar(3)
  ZTERM varchar(4)
  INCO1 varchar(3)
  MWSKZ varchar(2)
  BUKRS varchar(4)
}
Ref : ZTB1MM0004.BPID > ZTB1SD0001.BPID

Table ZTB1MM0005 [note: "Purchase Info Record (Condition) 정보"]{ 
  MANDT varchar(3) [pk]
  KNUMH varchar(10) [pk]
  LIFNR varchar(10)
  MATNR varchar(40)
  DATBI date
  DATAB date
  HERKL varchar(3)
  PLIFZ decimal(3,0)
  MEINS varchar(3)
  WAERS varchar(5)
  NETPR decimal(15,2)
  ZFRT decimal(15,2)
  MWSKZ varchar(2)
  ZOTH decimal(15,2)
  ZGRM decimal(15,2)
}
Ref : ZTB1MM0005.LIFNR > ZTB1SD0001.BPID
Ref : ZTB1MM0005.MATNR > ZTB1MM0001.MATNR
Ref : ZTB1MM0005.PLIFZ > ZTB1MM0001.PLIFZ


Table ZTB1MM0006 [note:"구매오더의 헤더 정보"]{ 
  MANDT varchar(3) [pk]
  EBELN varchar(10) [pk]
  LIFNR varchar(10)
  EKORG varchar(4)
  EKGRP varchar(3)
  BUKRS varchar(4)
  BSART varchar(4)
  BEDAT date
  POSTAT varchar(1)
  ZTERM varchar(4)
  INCO1 varchar(3)
}


Ref: ZTB1MM0006.LIFNR > ZTB1SD0001.BPID
Ref: ZTB1MM0006.BUKRS > ZTB1FI0004.BUKRS

Table ZTB1MM0007 [note: "구매오더 항목"] {
  MANDT varchar(3) [pk]
  EBELN varchar(10) [pk]
  EBELP varchar(4) [pk]
  MATNR varchar(40)
  WERKS varchar(4)
  LGORT varchar(4)
  MENGE decimal(13,3)
  MEINS varchar(3)
  NETPR decimal(15,2)
  NETWR decimal(15,2)
  MWSKZ varchar(2)
  WAERS varchar(5)
  EINDT date
  SLFDT date
  INSMK varchar(1)
  PACKNO varchar(10)
  KNTTP varchar(1)
  SAKTO varchar(10)
  EPSTP varchar(1)
  POSTAT varchar(1)
}

Ref: ZTB1MM0007.EBELN > ZTB1MM0006.EBELN
Ref: ZTB1MM0007.MATNR > ZTB1MM0001.MATNR
Ref: ZTB1MM0007.WERKS > ZTB1MM0003.WERKS
Ref: ZTB1MM0007.LGORT > ZTB1MM0003.LGORT
Ref: ZTB1MM0007.INSMK > ZTB1MM0019.INSMK

Table ZTB1MM0008 [note: "구매오더 결재"] {
  MANDT varchar(3) [pk]
  ZAPPNO varchar(10) [pk]
  EBELN varchar(10) [pk]
  EBELP varchar(4) [pk]
  ERNAM varchar(12)
  ERDAT date
  ERZET varchar(6)
  ZAPPST varchar(1)
  ZAPPER varchar(12)
  ZAPPDAT date
  ZAPPTIM varchar(6)
  ZMEMO varchar(60)
}

Ref: ZTB1MM0008.EBELN > ZTB1MM0007.EBELN
Ref: ZTB1MM0008.EBELP > ZTB1MM0007.EBELP

Table ZTB1MM0009 [note: "서비스 엔트리 시트 헤더"] {
  MANDT varchar(3) [pk]
  LBLNI varchar(10) [pk]
  EBELN varchar(10)
  EBELP varchar(4)
  PACKNO varchar(10)
  LWERT decimal(15,2)
  FRGRL varchar(1)
  BLDAT date
  BUDAT date
  GWRT decimal(15,2)
  WAERS varchar(5)
}

Ref: ZTB1MM0009.EBELN > ZTB1MM0007.EBELN
Ref: ZTB1MM0009.EBELP > ZTB1MM0007.EBELP

Table ZTB1MM0010 [note: "서비스 엔트리 시트 항목"] {
  MANDT varchar(3) [pk]
  PACKNO varchar(10) [pk]
  INTROW varchar(10) [pk]
  SUB_PACK varchar(10)
  KTEXT1 varchar(40)
  MENGE decimal(13,3)
  MEINS varchar(3)
  TBTWR decimal(15,2)
  WAERS varchar(5)
}

Ref: ZTB1MM0010.PACKNO > ZTB1MM0009.PACKNO

Table ZTB1MM0011 [note: "자재 이동 문서 헤더"] {
  MANDT varchar(3) [pk]
  MBLNR varchar(10) [pk]
  MJAHR varchar(4) [pk]
  BLDAT date
  BUDAT date
  BUKRS varchar(4)
  BKTXT varchar(25)
  SOID varchar(10)
  LPLNR varchar(12)
  EBELN varchar(10)
  VGART varchar(2)
}

Table ZTB1MM0012 [note: "자재 이동 문서 항목"] {
  MANDT varchar(3) [pk]
  MBLNR varchar(10) [pk]
  MJAHR varchar(4) [pk]
  ZEILE varchar(4) [pk]
  MATNR varchar(40)
  WERKS varchar(4)
  LGORT varchar(4)
  BWART varchar(3)
  MENGE decimal(13,3)
  MEINS varchar(3)
  DMBTR decimal(15,2)
  WAERS varchar(5)
  INSMK varchar(1)
  ZLOSS decimal(13,3)
  CO_AREA varchar(4)
  CO_CENTER varchar(10)
  VBELN varchar(10)
  POSNR varchar(4)
  BPID varchar(10)
  PLPR_ID varchar(12)
  LIFNR varchar(10)
  EBELN varchar(10)
  EBELP varchar(4)
}

Ref: ZTB1MM0012.MBLNR > ZTB1MM0011.MBLNR
Ref: ZTB1MM0012.MJAHR > ZTB1MM0011.MJAHR
Ref: ZTB1MM0012.MATNR > ZTB1MM0001.MATNR

Table ZTB1MM0013 [note: "송장 문서 헤더"] {
  MANDT varchar(3) [pk]
  BELNR varchar(10) [pk]
  GJAHR varchar(4) [pk]
  BLDAT date
  BUDAT date
  ZFBDT date
  ZTERM varchar(4)
  LIFNR varchar(10)
  BUKRS varchar(4)
  BKTXT varchar(25)
  RBSTAT varchar(1)
}

Table ZTB1MM0014 [note: "송장 문서 목록"] {
  MANDT varchar(3) [pk]
  BELNR varchar(10) [pk]
  GJAHR varchar(4) [pk]
  BUZEI varchar(4) [pk]
  WERKS varchar(4)
  EBELN varchar(10)
  EBELP varchar(4)
  MATNR varchar(40)
  MENGE decimal(13,3)
  MEINS varchar(3)
  WRBTR decimal(15,2)
  WAERS varchar(5)
  MWSKZ decimal(5,2)
  DMBTR decimal(15,2)
  WAFRSK varchar(5)
  KSCHL varchar(4)
}

Ref: ZTB1MM0014.BELNR > ZTB1MM0013.BELNR
Ref: ZTB1MM0014.GJAHR > ZTB1MM0013.GJAHR
Ref: ZTB1MM0014.EBELN > ZTB1MM0007.EBELN 
Ref: ZTB1MM0014.EBELP > ZTB1MM0007.EBELP


Table ZTB1MM0015 [note: "이동 유형 테이블"] {
  MANDT varchar(3) [pk]
  BWART varchar(3) [pk]
  BTEXT varchar(20)
}

Table ZTB1MM0016 [note: "평가 클래스 테이블"] {
  MANDT varchar(3) [pk]
  BKLAS varchar(4) [pk]
  BTEXT varchar(20)
}

Table ZTB1MM0017 [note: "계정 결정 매핑 테이블"] {
  MANDT varchar(3) [pk]
  BWART varchar(3) [pk]
  BKLAS varchar(4) [pk]
  SAKNR_D varchar(10)
  SAKNR_C varchar(10)
}

Ref: ZTB1MM0017.BWART > ZTB1MM0015.BWART
Ref: ZTB1MM0017.BKLAS > ZTB1MM0016.BKLAS

Table ZTB1MM0018 [note: "자재 유형 테이블"] {
  MANDT varchar(3) [pk]
  MTART varchar(4) [pk]
  MTBEZ varchar(25)
}


Table ZTB1MM0019 [note: "재고 유형 테이블"] {
  MANDT varchar(3) [pk]
  INSMK varchar(1) [pk]
  INSTX varchar(20)
}

Table ZTB1MM0020 [note: "부피 측정 테이블"] {
  MANDT varchar(3) [pk]
  ZMSNO varchar(10) [pk]
  ZDOCTY varchar(2)
  ZDOCNO varchar(10)
  ZDOCIT varchar(4)
  ZAVOL decimal(13,3)
  ZTEMP decimal(5,2)
  ZUNIT varchar(3)
  ZDENS decimal(5,2)
  ZVCF decimal(5,2)
  ZSVOL decimal(13,3)
  MEINS varchar(3)
  ZMDAT date
}
```
</details>

### 1.2 Production Planning (PP) & Controlling (CO)
*BOM, 공정, 생산 실적 및 원가 센터 정보 매핑*

<details>
<summary>PP/CO 상세 테이블 스키마 코드 보기</summary>
```dbml
/* ===== PP ===== */
Table ZTB1PP0001 [note: "CBO. 생산 계획 수립에 사용. PBIM + PBED"] {
  MANDT varchar(3) [pk]
  MATNR varchar(40) [pk]
  WERKS varchar(4) [pk]
  PIR_VER varchar(2) [pk]
  REQ_DATE date [pk]
  REQ_QTY decimal(13,3)
  REQ_UNIT varchar(3)
  REMARK varchar(1)
}

Table ZTB1PP0002 [note: "BOM 헤더"] {
  MANDT varchar(3) [pk]
  STLNR varchar(8) [pk]
  BOMVE varchar(4) [pk]
  MATNR varchar(40)
  WRKAN varchar(4)
  DATUV date
  VALID_TO date
  BMEIN varchar(3)
  BMENG decimal(13,3)
}

Table ZTB1PP0003 [note: "BOM 아이템"] {
  MANDT varchar(3) [pk]
  STLNR varchar(8) [pk]
  BOMVE varchar(4) [pk]
  STLKN varchar(8) [pk]
  MATNR varchar(40)
  FMENG decimal(13,3)
  MEINS varchar(3)
}

Table ZTB1PP0004 [note: "Work Center 마스터 (CR MASTER)"] {
  MANDT varchar(3) [pk]
  OBJID varchar(8) [pk]
  OBJTY varchar(2)
  ARBPL varchar(8)
  WERKS varchar(4)
  BEGDA date
  ENDDA date
  KOSTL varchar(10)
  AZMIN int
  AZNOR int
  AZMAX int
  KAPEH varchar(3)
}

Ref: ZTB1PP0001.MATNR > ZTB1MM0001.MATNR
Ref: ZTB1PP0001.WERKS > ZTB1MM0000.WERKS

Ref: ZTB1PP0002.MATNR > ZTB1MM0001.MATNR
Ref: ZTB1PP0002.WRKAN > ZTB1MM0000.WERKS

Ref: ZTB1PP0003.STLNR > ZTB1PP0002.STLNR
Ref: ZTB1PP0003.BOMVE > ZTB1PP0002.BOMVE
Ref: ZTB1PP0003.MATNR > ZTB1MM0001.MATNR

Ref: ZTB1PP0004.WERKS > ZTB1MM0000.WERKS

Table ZTB1PP0005 [note: "Work Center Schedule"] {
  MANDT varchar(3) [pk]
  OBJID varchar(8) [pk]
  START_TS decimal(15,0) [pk]
  END_TS decimal(15,0)
  PLPR varchar(12)
  LOADQ decimal(13,3)
  LOADU varchar(3)
  STATUS varchar(10)
  LOGID varchar(10)
}

Table ZTB1PP0006 [note: "Work Center Event Log"] {
  MANDT varchar(3) [pk]
  LOG_ID varchar(10) [pk]
  EVTIM decimal(15,0)
  EVNTY varchar(10)
  SCOBJ varchar(8)
  TQUAN decimal(13,3)
  UNIT varchar(3)
  REASON varchar(100)
}

Table ZTB1PP0007 [note: "Work Center Event Log Detail"] {
  MANDT varchar(3) [pk]
  LOG_ID varchar(10) [pk]
  ITEM_NO varchar(4) [pk]
  FROBJ varchar(8)
  TOOBJ varchar(8)
  MVQTY decimal(13,3)
  MVUNT varchar(3)
}

Table ZTB1PP0008 [note: "공정 헤더"] {
  MANDT varchar(3) [pk]
  PLNNR varchar(8) [pk]
  WERKS varchar(4)
  KTEXT varchar(40)
  DATUV date
  VALID_TO date
  BPHQT decimal(13,3)
  BPHUN varchar(3)
  PRCST decimal(15,2)
  PRUNT varchar(5)
}

Table ZTB1PP0009 [note: "공정 아이템"] {
  MANDT varchar(3) [pk]
  PLNNR varchar(8) [pk]
  PLNKN varchar(8) [pk]
  VORNR varchar(8)
  LTXA1 varchar(40)
  PLNVE varchar(4)
}
Table ZTB1PP0010 [note: "MRP 헤더"] {
  MANDT varchar(3) [pk]
  MRPNR varchar(10) [pk]
  PLWRK varchar(4)
  RUNTS decimal(15,0)
  RNTYP varchar(10)
  PLNVE varchar(4)
  STATUS varchar(10)
  REMARK varchar(100)
}
Table ZTB1PP0011 [note: "MRP 아이템"] {
  MANDT varchar(3) [pk]
  MRPNR varchar(10) [pk]
  MRPKN varchar(8) [pk]
  PRMRP varchar(8)
  MATNR varchar(18)
  RQDAT date
  RQQTY decimal(13,3)
  RQUNT varchar(3)
  ORDTY varchar(10)
  PLPR varchar(12)
}
Table ZTB1PP0012 [note: "생산계획 / 생산오더"] {
  MANDT varchar(3) [pk]
  PLPR varchar(12) [pk]
  PLNTY varchar(4)
  WERKS varchar(4)
  ORQTY decimal(13,3)
  ORUNT varchar(3)
  SDATE date
  PEDAT date
  EDATE date
  PLNVE varchar(4)
  STLNR varchar(8)
  BOMVE varchar(4)
  PLNNR varchar(8)
  REMARK varchar(100)
}
Table ZTB1PP0013 [note: "생산계획 / 생산오더 아이템"] {
  MANDT varchar(3) [pk]
  PLPR varchar(12) [pk]
  PLPKN varchar(8) [pk]
  ITMTY varchar(4)
  STLNR varchar(8)
  STLKN varchar(8)
  PLNNR varchar(8)
  PLNKN varchar(8)
  VORNR varchar(8)
  MATNR varchar(40)
  REQTY decimal(13,3)
  ACQTY varchar(3)
  MEINS varchar(3)
  DATUV date
  VALID_TO date
  REMARK varchar(100)
}


Ref: ZTB1PP0005.OBJID > ZTB1PP0004.OBJID
Ref: ZTB1PP0005.LOGID > ZTB1PP0006.LOG_ID

Ref: ZTB1PP0006.SCOBJ > ZTB1PP0004.OBJID

Ref: ZTB1PP0007.LOG_ID > ZTB1PP0006.LOG_ID
Ref: ZTB1PP0007.FROBJ > ZTB1PP0004.OBJID
Ref: ZTB1PP0007.TOOBJ > ZTB1PP0004.OBJID

Ref: ZTB1PP0008.WERKS > ZTB1MM0000.WERKS

Ref: ZTB1PP0009.PLNNR > ZTB1PP0008.PLNNR

Ref: ZTB1PP0010.PLWRK > ZTB1MM0000.WERKS
Ref: ZTB1PP0010.PLNVE > ZTB1PP0002.BOMVE

Ref: ZTB1PP0011.MRPNR > ZTB1PP0010.MRPNR
Ref: ZTB1PP0011.PRMRP > ZTB1PP0011.MRPKN
Ref: ZTB1PP0011.MATNR > ZTB1MM0001.MATNR
Ref: ZTB1PP0011.PLPR > ZTB1PP0012.PLPR

Ref: ZTB1PP0012.WERKS > ZTB1MM0000.WERKS
Ref: ZTB1PP0012.STLNR > ZTB1PP0002.STLNR
Ref: ZTB1PP0012.BOMVE > ZTB1PP0002.BOMVE
Ref: ZTB1PP0012.PLNNR > ZTB1PP0008.PLNNR

Ref: ZTB1PP0013.PLPR > ZTB1PP0012.PLPR
Ref: ZTB1PP0013.STLNR > ZTB1PP0002.STLNR
Ref: ZTB1PP0013.STLKN > ZTB1PP0003.STLKN
Ref: ZTB1PP0013.PLNNR > ZTB1PP0008.PLNNR
Ref: ZTB1PP0013.PLNKN > ZTB1PP0009.PLNKN
Ref: ZTB1PP0013.VORNR > ZTB1PP0009.VORNR
Ref: ZTB1PP0013.MATNR > ZTB1MM0001.MATNR


/* ==== CO ==== */

Table ZTB1CO0001 {
  CO_AREA varchar(4) [pk]
  CO_CENTER varchar(10) [pk]
  VALID_FROM date [pk]

  PROFIT_CENTER varchar(10)
  CC_TYPE varchar(2)
  COMPANY_CODE varchar(4)
  PLANT_ID varchar(4)
  PROCESS_TYPE varchar(2)
  RESP_PERSON varchar(12)
  VALID_TO date
  STATUS varchar(1)
}

Table ZTB1CO0002 {
  CO_AREA varchar(4) [pk]
  PROFIT_CENTER varchar(10) [pk]
  VALID_FROM date [pk]

  PC_TYPE varchar(2)
  COMPANY_CODE varchar(4)
  SEGMENT varchar(10)
  PC_OWNER_TYPE varchar(2)
  RESP_PERSON varchar(12)
  VALID_TO date
  STATUS varchar(1)
}

Table ZTB1CO0003 {
  PLANT_ID varchar(4) [pk]
  PROCESS_ID varchar(10) [pk]
  VALID_FROM date [pk]

  PROCESS_NAME varchar(40)
  PROCESS_STAGE varchar(10)
  MAIN_CO_CENTER varchar(10)
  STATUS varchar(1)
}

Table ZTB1CO0004 {
  CO_AREA varchar(4) [pk]
  FISCAL_YEAR varchar(4) [pk]
  PERIOD varchar(3) [pk]
  VALUE_TYPE varchar(2) [pk]
  CO_CENTER varchar(10) [pk]

  AMOUNT decimal(15,2)
  QUANTITY decimal(13,3)
}

Table ZTB1CO0005 {
  PLANT_ID varchar(4) [pk]
  PROCESS_ID varchar(10) [pk]
  VALID_FROM date [pk]

  COST_CENTER varchar(10)
  STD_INPUT_OIL_QTY decimal(15,3)
  STD_INPUT_CAT_QTY decimal(15,3)
  STD_INPUT_BCU_QTY decimal(15,3)
  INPUT_OIL_UOM varchar(3)
  INPUT_CAT_UOM varchar(3)
  INPUT_BCU_UOM varchar(3)
  OUTPUT_UOM varchar(3)
  STD_YIELD_RATE decimal(5,2)
  STD_OUTPUT_QTY decimal(15,3)
  STD_RUN_HOUR decimal(13,2)
  VALID_TO date
  STATUS varchar(1)
  MAIN_PRODUCT varchar(18)
}

Table ZTB1CO0006 {
  PLANT_ID varchar(4) [pk]
  PROCESS_ID varchar(10) [pk]
  FISCAL_YEAR varchar(4) [pk]
  PERIOD varchar(3) [pk]

  COST_CENTER varchar(10)
  INPUT_QTY decimal(15,3)
  OUTPUT_QTY decimal(15,3)
  ACT_YIELD_RATE decimal(5,2)
  RUN_HOUR decimal(13,2)
  INPUT_UOM varchar(3)
  OUTPUT_UOM varchar(3)
  DATA_SOURCE varchar(10)
  SOURCE_DOC_NO varchar(10)
  ACTIVITY_TYPE varchar(6)
  CONFIRM_FLAG varchar(1)
  PRODUCT_ID varchar(18)
  PRODUCT_QTY decimal(15,3)
  PRODUCT_UOM varchar(3)
}

Table ZTB1CO0008 {
  CO_AREA varchar(4) [pk]
  FISCAL_YEAR varchar(4) [pk]
  PERIOD varchar(3) [pk]
  VERSION varchar(3) [pk]
  OBJECT_TYPE varchar(4) [pk]
  OBJECT_ID varchar(12) [pk]
  CO_ELEMENT varchar(10) [pk]

  PLAN_AMOUNT decimal(15,2)
  PLAN_QUANTITY decimal(13,3)
  UNIT varchar(3)
  CURRENCY varchar(5)
  PRODUCT_ID varchar(18)
  ALLOC_RATIO decimal(5,2)
  PLAN_OUTPUT_QTY decimal(15,3)
}

Table ZTB1CO0010 {
  CONTROLLING_AREA varchar(4) [pk]
  FISCAL_YEAR varchar(4) [pk]
  PERIOD varchar(3) [pk]
  PROCESS_ID varchar(10) [pk]
  PRODUCT_ID varchar(18) [pk]

  COST_CENTER varchar(10)
  INPUT_QTY decimal(15,3)
  OUTPUT_QTY decimal(15,3)
  YIELD_RATE decimal(5,2)
  UNIT varchar(3)
  SOURCE_DOC_NO varchar(10)
}

Table ZTB1CO0011 {
  CONTROLLING_AREA varchar(4) [pk]
  FISCAL_YEAR varchar(4) [pk]
  PERIOD varchar(3) [pk]
  PROCESS_ID varchar(10) [pk]
  PRODUCT_ID varchar(18) [pk]

  COST_CENTER varchar(10)
  TOTAL_COST decimal(15,2)
  PRODUCTION_QTY decimal(13,3)
  UNIT_COST decimal(15,2)
  CURRENCY varchar(5)
}

Ref: ZTB1CO0001.PROFIT_CENTER > ZTB1CO0002.PROFIT_CENTER
Ref: ZTB1CO0001.COMPANY_CODE > ZTB1FI0001.BUKRS

Ref: ZTB1CO0002.COMPANY_CODE > ZTB1FI0001.BUKRS

Ref: ZTB1CO0003.MAIN_CO_CENTER > ZTB1CO0001.CO_CENTER

Ref: ZTB1CO0004.CO_CENTER > ZTB1CO0001.CO_CENTER
Ref: ZTB1CO0004.CO_AREA > ZTB1CO0001.CO_AREA

Ref: ZTB1CO0004.FISCAL_YEAR > ZTB1FI0006.PERIV

Ref: ZTB1CO0005.PROCESS_ID > ZTB1CO0003.PROCESS_ID
Ref: ZTB1CO0005.PLANT_ID > ZTB1CO0003.PLANT_ID
Ref: ZTB1CO0005.COST_CENTER > ZTB1CO0001.CO_CENTER

Ref: ZTB1CO0006.PROCESS_ID > ZTB1CO0003.PROCESS_ID
Ref: ZTB1CO0006.PLANT_ID > ZTB1CO0003.PLANT_ID
Ref: ZTB1CO0006.COST_CENTER > ZTB1CO0001.CO_CENTER
Ref: ZTB1CO0006.PRODUCT_ID > ZTB1MM0001.MATNR

Ref: ZTB1CO0008.CO_AREA > ZTB1CO0001.CO_AREA
Ref: ZTB1CO0008.OBJECT_ID > ZTB1CO0001.CO_CENTER
Ref: ZTB1CO0008.PRODUCT_ID > ZTB1MM0001.MATNR

Ref: ZTB1CO0010.CONTROLLING_AREA > ZTB1CO0001.CO_AREA
Ref: ZTB1CO0010.PROCESS_ID > ZTB1CO0003.PROCESS_ID
Ref: ZTB1CO0010.COST_CENTER > ZTB1CO0001.CO_CENTER
Ref: ZTB1CO0010.PRODUCT_ID > ZTB1MM0001.MATNR

Ref: ZTB1CO0011.CONTROLLING_AREA > ZTB1CO0001.CO_AREA
Ref: ZTB1CO0011.PROCESS_ID > ZTB1CO0003.PROCESS_ID
Ref: ZTB1CO0011.COST_CENTER > ZTB1CO0001.CO_CENTER
Ref: ZTB1CO0011.PRODUCT_ID > ZTB1MM0001.MATNR
```
```
</details>

## 1.3 Sales & Distribution (SD)
*판매 가격 결정, 물류센터 보충 및 대금 청구 구조*

<details>
<summary>SD 상세 테이블 스키마 코드 보기</summary>
```dbml 
/* ===== SD ===== */
Table ZTB1SD0001 [note: "BP 마스터 일반"] {		
  MANDT  varchar(3)   [pk]		
  BPID   varchar(10)  [pk]		
  BPTYP  varchar(4)   [pk]		
  BPNM   varchar(40) 		
  ADDR   varchar(60)  		
  CNTCD  varchar(3)  		
  BIZNO  varchar(16) 		
  EMAIL  varchar(60) 		
  ACCNO  varchar(18)  		
  BANK   varchar(60) 		
  WAERS  varchar(5) 		
  PICNM  varchar(40)		
  PICTL  varchar(30) 
}		
Table ZTB1SD0002 [note: "BP 마스터 조정계정"] {			
MANDT varchar(3) [pk]			
BPID varchar(10) [pk]			
BPTYP varchar(4) [pk]			
RECON varchar(10)	
}	
Table ZTB1SD0003 [note: "BP 마스터 판매"] {			
MANDT varchar(3) [pk]			
BPID varchar(10) [pk]			
VKORG varchar(4) [pk]			
VTWEG varchar(2) [pk]			
SPART varchar(2) [pk]			
ZTERM varchar(4)			
INCO1 varchar(3)			
TAXCL varchar(1)			
TAXTY varchar(1)	
}			
Table ZTB1SD0004 [note: "가격 조건 마스터"] {
MANDT varchar(3) [pk]
KSCHL varchar(4) [pk]
VKORG varchar(4) [pk]
VTWEG varchar(2) [pk]
MATNR varchar(40) [pk]
DATAB date [pk]
ZPREM decimal(15,2)
DATBI date
WAERS varchar(5)
MEINS varchar(3)
LVORM varchar(1)
}

Ref: ZTB1SD0004.MATNR> ZTB1MM0001.MATNR

Table ZTB1SD0005 [note: "가격 결정"]{
  MANDT varchar(3) [pk]
  VBELN varchar(10) [pk]
  POSNR varchar(4) [pk]
  KSCHL varchar(4) [pk]
  ZPREM decimal(15,2)
  MOPS decimal(15,2)
  HWAN decimal(9,5)
  NETPR decimal(15,2)
  ZSVOL decimal(13,3)
  MEINS varchar(3)
  NETVL decimal(15,2)
  WAERS varchar(5)
  MWSKZ varchar(2)
}
Table ZTB1SD0006 [note: "판매오더 헤더"]{
  MANDT varchar(3) [pk]
  VBELN varchar(10) [pk]
  VKORG varchar(4) [pk]
  VTWEG varchar(2) [pk]
  SPART varchar(2) [pk]
  SOTYP varchar(4)
  BPID varchar(10)
  ORDDA date
  SOLDT varchar(10)
  SHIPT varchar(10)
  ZTERM varchar(4)
  INCO1 varchar(3)
  TAXCL varchar(1)
  TAXTY varchar(1)
  SOSTA varchar(1)
  REJRS varchar(1)
}
Table ZTB1SD0007 [note: "판매오더 아이템"]{
  MANDT varchar(3) [pk]
  VBELN varchar(10) [pk]
  POSNR varchar(4) [pk]
  WERKS varchar(4)
  LGORT varchar(4)
  MATNR varchar(40)
  ZSVOL decimal(13,3)
  NETPR decimal(11,2)
  VRKME varchar(3)
  MEINS varchar(3)
  NETVL decimal(15,2)
  WAERS varchar(5)
}
Table ZTB1SD0008 [note: "출고 헤더"]{
  MANDT varchar(3) [pk]
  VBELN varchar(10) [pk]
  VBELN_VA varchar(10)
  LFDAT date
  SHIPT varchar(10)
  ZTERM varchar(4)
  INCO1 varchar(3)
  TAXCL varchar(1)
  TAXTY varchar(1)
}
Table ZTB1SD0009 [note: "출고 아이템"]{
  MANDT varchar(3) [pk]
  VBELN varchar(10) [pk]
  POSNR varchar(4) [pk]
  VBELN_VA varchar(10)
  POSNR_VA varchar(4)
  WERKS varchar(4)
  LGORT varchar(4)
  MATNR varchar(40)
  LFIMG decimal(13,3)
  MEINS varchar(3)
  ERNAM varchar(12)
  AKNOT date
}
Table ZTB1SD0010 [note: "대금청구 헤더"]{
  MANDT varchar(3) [pk]
  VBELN varchar(10) [pk]
  VBELN_VA varchar(10)
  FKDAT date
  NETWR decimal(15,2)
  MWSTS decimal(15,2)
  DMBTR decimal(15,2)
  WAERS varchar(5)
  ZTERM varchar(4)
  INCO1 varchar(3)
  TAXCL varchar(1)
  TAXTY varchar(1)
  STATUS varchar(1)
  ZDNCT int(4)
  ZDNDT date
}
Table ZTB1SD0011 [note: "대금청구 아이"]{
  MANDT varchar(3) [pk]
  VBELN varchar(10) [pk]
  POSNR varchar(4) [pk]
  VBELN_VA varchar(10)
  POSNR_VA varchar(4)
  MATNR varchar(40)
  FKIMG decimal(13,3)
  MEINS varchar(3)
  NETPR decimal(15,2)
  NETVL decimal(15,2)
  WAERS varchar(5)
  MWSKZ varchar(2)
}

/* ===== Ref ===== */

Ref: ZTB1SD0003.BPID > ZTB1SD0001.BPID
Ref: ZTB1SD0002.BPID > ZTB1SD0001.BPID
Ref: ZTB1SD0005.VBELN > ZTB1SD0007.VBELN
Ref: ZTB1SD0005.POSNR > ZTB1SD0007.POSNR
Ref: ZTB1SD0006.BPID > ZTB1SD0001.BPID
Ref: ZTB1SD0006.SOLDT > ZTB1SD0001.BPID
Ref: ZTB1SD0006.SHIPT > ZTB1SD0001.BPID
Ref: ZTB1SD0007.VBELN > ZTB1SD0006.VBELN
Ref: ZTB1SD0008.VBELN_VA > ZTB1SD0006.VBELN
Ref: ZTB1SD0008.SHIPT > ZTB1SD0001.BPID
Ref: ZTB1SD0009.VBELN > ZTB1SD0008. VBELN
Ref: ZTB1SD0009.VBELN_VA > ZTB1SD0007.VBELN
Ref: ZTB1SD0010.VBELN_VA > ZTB1SD0008.VBELN
Ref: ZTB1SD0011.VBELN > ZTB1SD0010.VBELN
Ref: ZTB1SD0011.VBELN_VA > ZTB1SD0009.VBELN
```
```
</details>

## 1.4 Finance (FI)
전표 헤더/아이템 및 환율 관리 구조

<details>
<summary>FI 상세 테이블 스키마 코드 보기</summary>
```
/* ==== FI ==== */

Table ZTB1FI0001 [note: "전표 헤더"] {
  MANDT varchar(3) [pk]
  BUKRS varchar(4) [pk]
  GJAHR varchar(4) [pk]
  BELNR varchar(10) [pk]
  BLART varchar(2)
  BLDAT date
  BUDAT date
  MONAT varchar(2)
  BKPF_TXT varchar(50)
  WAERS varchar(5)
  HWAER varchar(5)
  KURSF decimal(15,2)
  STBLG varchar(10)
  STJAH varchar(4)
  RESLIPBK date
  RESLIPRK varchar(100)
  XREVERSAL varchar(1)
  TCODE varchar(20)
}

Table ZTB1FI0002 [note: "전표 아이템"] {
  MANDT varchar(3) [pk]
  BUKRS varchar(4) [pk]
  GJAHR varchar(4) [pk]
  BELNR varchar(10) [pk]
  BUZEI varchar(4) [pk]
  BSCHL varchar(2)
  SAKNR varchar(2)
  KOART varchar(1)
  SHKZG varchar(1)
  HKONT varchar(8)
  DMBTR decimal(15,2)
  WRBTR decimal(15,2)
  SGTXT varchar(50)
  KUNNR varchar(10)
  LIFNR varchar(10)
  MBLNR varchar(10)
  MWSKZ varchar(2)
  HWSTE decimal(15,2)
  WAERS varchar(5)
  MATNR varchar(40)
  EBELN varchar(10)
  AUFNR varchar(10)
  VBELN varchar(10)
  INVNO varchar(10)
  AUGBL varchar(10)
  AUGBLDAT date
  BLNO varchar(10)
}

Table ZTB1FI0003 [note: "전표 유형"] {
  MANDT varchar(3) [pk]
  BLART varchar(2) [pk]
  LTEXT varchar(20)
  NUMKR varchar(2)
  KOARS varchar(5)
  STBLA varchar(2)
}


Table ZTB1FI0004 [note: "당사 정보 테이블"]{ 
  MANDT varchar(3) [pk]
  BUKRS varchar(4) [pk]
  BUTXT varchar(25)
  LAND1 varchar(3)
  WAERS varchar(5)
  STCEG varchar(20)
  ADRNR varchar(100)
  TELNO varchar(20)
  MAIL varchar(50)
  ACCOUNT varchar(14)
}

Table ZTB1FI0005 [note: "G/L 마스터"] {
  MANDT varchar(3) [pk]
  BUKRS varchar(4) [pk]
  SAKNR varchar(1) [pk]
  HKONT varchar(8) [pk]
  TXT50 varchar(50)
  XINTB varchar(1)
  XLOEV varchar(1)
  KONTS varchar(1)
  WAERS varchar(5)
  GL_GROUP varchar(2)
}

Table ZTB1FI0006 [note: "회계연도 Variant"] {
  MANDT varchar(3) [pk]
  PERIV varchar(2) [pk]
  XKALE varchar(1)
  XJABH varchar(1)
  ANZBP varchar(3)
  ANZSP varchar(2)
  XWEEK varchar(1)
  FYOFB varchar(2)
  FYOFE varchar(2)
}

Table ZTB1FI0007 [note: "환율"] {
  MANDT varchar(3) [pk]
  FCURR varchar(5) [pk]
  TCURR varchar(5) [pk]
  GDATU date [pk]
  KURST varchar(4) [pk]
  UKURS decimal(9,5)
}

Table ZTB1FI0008 [note: "재무상태표 계정"] {
  MANDT varchar(3) [pk]
  BUKRS varchar(4) [pk]
  GJAHR varchar(4) [pk]
  WEEK varchar(2) [pk]
  SAKNR varchar(10) [pk]
  BELNR varchar(10) [pk]
  SHKZG varchar(1)
  SAKNR_TXT varchar(50)
  LEVEL1 varchar(5)
  LEVEL2 varchar(20)
  WAERS varchar(5)
  NCURR decimal(15,2)
}

Table ZTB1FI0009 [note: "통화 코드"] {
  MANDT varchar(3) [pk]
  WAERS varchar(5) [pk]
}

Table ZTB1FI0010 {
  MANDT varchar(3) [pk]
  BP_CODE varchar(10) [pk]
  BP_TYPE varchar(1)
  NAME1 varchar(35)
  STCD1 varchar(16)
  LAND1 varchar(3)
  ORT01 varchar(35)
  AKONT varchar(10)
  ZTERM varchar(4)
  ZWELS varchar(10)
  WAERS varchar(5)
}

Table ZTB1FI0011 {
  MANDT varchar(3) [pk]
  MATNR varchar(40) [pk]
  MEINS varchar(3)
  STPRS decimal(15,2)
  WAERS varchar(5)
  DMBTR decimal(15,2)
}

Table ZTB1FI0013 {
  MANDT varchar(3) [pk]
  BUKRS varchar(4) [pk]
  GJAHR varchar(4) [pk]
  BELNR varchar(10) [pk]
  BUZEI varchar(4) [pk]
  STATUS varchar(1)
  AUGBL varchar(10)
  AUGBLDAT date
  BP_CODE varchar(10)
  HKONT varchar(10)
  BUDAT date
  WAERS varchar(5)
  DMBTR decimal(15,2)
  SHKZG varchar(1)
  ZFBDT date
  ZTERM varchar(4)
}


Ref: ZTB1FI0001.BLART > ZTB1FI0003.BLART

Ref: ZTB1FI0002.BUKRS > ZTB1FI0001.BUKRS
Ref: ZTB1FI0002.GJAHR > ZTB1FI0001.GJAHR
Ref: ZTB1FI0002.BELNR > ZTB1FI0001.BELNR

Ref: ZTB1FI0002.MATNR > ZTB1MM0001.MATNR
Ref: ZTB1FI0002.HKONT > ZTB1FI0005.HKONT
Ref: ZTB1FI0008.SAKNR > ZTB1FI0005.SAKNR
Ref: ZTB1FI0001.BUKRS > ZTB1FI0006.PERIV
Ref: ZTB1FI0001.WAERS > ZTB1FI0009.WAERS
Ref: ZTB1FI0002.WAERS > ZTB1FI0009.WAERS
Ref: ZTB1FI0005.WAERS > ZTB1FI0009.WAERS
Ref: ZTB1FI0008.WAERS > ZTB1FI0009.WAERS
Ref: ZTB1FI0007.FCURR > ZTB1FI0009.WAERS
Ref: ZTB1FI0007.TCURR > ZTB1FI0009.WAERS

Ref: ZTB1FI0010.AKONT > ZTB1FI0005.HKONT
Ref: ZTB1FI0011.MATNR > ZTB1MM0001.MATNR
Ref: ZTB1FI0011.WAERS > ZTB1FI0009.WAERS
Ref: ZTB1FI0013.BUKRS > ZTB1FI0001.BUKRS
Ref: ZTB1FI0013.GJAHR > ZTB1FI0001.GJAHR
Ref: ZTB1FI0013.BELNR > ZTB1FI0001.BELNR
Ref: ZTB1FI0013.BP_CODE > ZTB1FI0010.BP_CODE
Ref: ZTB1FI0013.HKONT > ZTB1FI0005.HKONT
Ref: ZTB1FI0013.WAERS > ZTB1FI0009.WAERS
```
</details>
