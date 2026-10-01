CLASS zcl_zgwb1mm0001_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zgwb1mm0001_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.

    METHODS bpposset_get_entity
        REDEFINITION .
    METHODS bpposset_get_entityset
        REDEFINITION .
    METHODS optimizedbset_create_entity
        REDEFINITION .
    METHODS optimizedbset_delete_entity
        REDEFINITION .
    METHODS optimizedbset_get_entity
        REDEFINITION .
    METHODS optimizedbset_get_entityset
        REDEFINITION .
    METHODS optimizedbset_update_entity
        REDEFINITION .
    METHODS poset_get_entity
        REDEFINITION .
    METHODS volumemasterset_get_entity
        REDEFINITION .
    METHODS volumemasterset_get_entityset
        REDEFINITION .
    METHODS volumeset_create_entity
        REDEFINITION .
    METHODS volumeset_delete_entity
        REDEFINITION .
    METHODS volumeset_get_entity
        REDEFINITION .
    METHODS volumeset_get_entityset
        REDEFINITION .
    METHODS volumeset_update_entity
        REDEFINITION .
    METHODS poset_get_entityset
        REDEFINITION .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ZGWB1MM0001_DPC_EXT IMPLEMENTATION.


  METHOD optimizedbset_create_entity.
* Body에 담긴 생성 데이터를 io_data_provider를 통해 가져옴
* DB Table에 Insert 후, 처리 결과를 ER_ENTITY로 전달

    "Entity 구조와 DB Table 구조에 맞는 변수 각각 선언
    DATA: ls_entity TYPE zcl_zgwb1mm0001_mpc=>ts_optimizedb, "ts_데이터셋의이름 찾아보면 존재
          ls_data   TYPE ztb1mm0005.

    "es_data에 Request Body(JSON) 정보가 들어옴
    io_data_provider->read_entry_data(
    IMPORTING es_data = ls_entity
     ).
    CHECK sy-subrc = 0.
    MOVE-CORRESPONDING ls_entity TO ls_data.

* 실제 db에 추가하기 전, 데이터 작업 가능
*  ls_data-memo = '이건 생성이야'.
    ls_data-ernam = sy-uname.
    ls_data-erdat = sy-datum.
    ls_data-erzet = sy-uzeit.
    ls_data-aenam = sy-uname.
    ls_data-aedat = sy-datum.
    ls_data-aezet = sy-uzeit.

    INSERT ztb1mm0005 FROM ls_data.
    IF sy-subrc = 0.
      " ER_ENTITY에 결과를 반영
      MOVE-CORRESPONDING ls_entity TO er_entity.
    ENDIF.
  ENDMETHOD.


  METHOD optimizedbset_delete_entity.
    IF it_key_tab IS NOT INITIAL.

    ENDIF.
*     DELELTE 요청을 통해서 실제 테이블 데이터를 삭제할 수 있다
*     IT_KEY_TAB 파라미터에 들어온 값을 가지고 해당되는 데이터를 DB Table에서 삭제

*    1. DB TABLE과 동일한 구조의 변수 선언
    DATA: ls_data TYPE ztb1mm0005.

*    2. IT_KEY_TAB 파라미터에 들어온 값으로 변수에 키값 세팅
    LOOP AT it_key_tab INTO DATA(ls_key).
      ls_data-(ls_key-name) = ls_key-value.
    ENDLOOP.
*    3. 변수에 해당되는 레코드를 DB Table에서 삭제
*    DELETE <db_tab> FROM <structure>
    DELETE ztb1mm0005 FROM ls_data.
*
*    실제 테스트. Body 없이 HTTP Method, URL만 구성
*    => /EntitySet( key1='값', key2='값2' )
  ENDMETHOD.


  METHOD optimizedbset_get_entity.
    DATA: ls_data TYPE ztb1mm0005.

    " /EntitySet(key1='값1', key2='값2')
    " 근데 구매조건최적화는 키필드 하나임
    LOOP AT it_key_tab INTO DATA(ls_key).
      IF ls_key-name = 'Knumh'. " 대소문자 잘 구분해서 작성해줘야 함
        ls_data-knumh = ls_key-value.
      ENDIF.
    ENDLOOP.

    SELECT SINGLE *
        FROM ztb1mm0005
        INTO @DATA(ls_result)
        WHERE Knumh = @ls_data-knumh.

    IF sy-subrc = 0.
      MOVE-CORRESPONDING ls_result TO er_entity.
    ENDIF.
  ENDMETHOD.


  METHOD optimizedbset_get_entityset.
    DATA: lr_bpid  TYPE RANGE OF ztb1mm0005-bpid,
          lr_herkl TYPE RANGE OF ztb1mm0005-herkl,
          lr_matnr TYPE RANGE OF ztb1mm0005-matnr.

    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      CASE ls_filter-property.
        WHEN 'Bpid'.
          lr_bpid  = CORRESPONDING #( ls_filter-select_options ).
        WHEN 'Herkl'.
          lr_herkl = CORRESPONDING #( ls_filter-select_options ).
        WHEN 'Matnr'.
          lr_matnr = CORRESPONDING #( ls_filter-select_options ).
      ENDCASE.
    ENDLOOP.

    SELECT * FROM ztb1mm0005
      INTO CORRESPONDING FIELDS OF TABLE @et_entityset
      WHERE bpid  IN @lr_bpid
        AND herkl IN @lr_herkl
        AND matnr IN @lr_matnr.

    SORT et_entityset BY knumh.

  ENDMETHOD.


  METHOD optimizedbset_update_entity.
*  PUT 요청을 통해서 실제 테이블에 데이터를 변경하는 과정
*  BODY에 담긴 변경 대상 데이터를 io_data_provider로 얻어옴
*  DB Update 진행

    "Entity 구조와 DB Table 구조에 맞는 변수 각각 선언
    DATA: ls_entity TYPE zcl_zgwb1mm0001_mpc=>ts_optimizedb,
          ls_data   TYPE ztb1mm0005.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ls_entity
    ).

    SELECT SINGLE *
      FROM ztb1mm0005
      INTO ls_data
      WHERE knumh = ls_entity-knumh.

    IF sy-subrc = 0.
      MOVE-CORRESPONDING ls_entity TO ls_data.

*  만약, 별도의 DATA 세팅이 필요한 경우 여기서 작성
*  ls_data-memo = '이건 변경이야'. "사용자가 입력하는 값 반영
      ls_data-aenam = sy-uname.
      ls_data-aedat = sy-datum.
      ls_data-aezet = sy-uzeit. "사용자가 변경하는 일자, 시간 반영

      UPDATE ztb1mm0005 FROM ls_data.
    ENDIF.
  ENDMETHOD.


  METHOD bpposset_get_entity.
    DATA: ls_data TYPE ztb1sd0001.

    " /EntitySet(key1='값1', key2='값2')
    LOOP AT it_key_tab INTO DATA(ls_key).
      CASE ls_key-name.
        WHEN 'Bpid'. " 대소문자 구분
          ls_data-bpid  = ls_key-value.
        WHEN 'Bptyp'.
          ls_data-bptyp = ls_key-value.
      ENDCASE.
    ENDLOOP.

    SELECT SINGLE *
        FROM ztb1sd0001
        INTO @DATA(ls_result)
        WHERE bpid = @ls_data-bpid
        AND bptyp = @ls_data-bptyp.

    IF sy-subrc = 0.
      MOVE-CORRESPONDING ls_result TO er_entity.

      CASE er_entity-bpid.
        WHEN 'BP10000000'. er_entity-addr = '-95.3698;29.7542;0'.  " 미국 휴스턴 SMITH ST
        WHEN 'BP10000001'. er_entity-addr = '-95.3685;29.7558;0'.  " 미국 휴스턴 DALLAS ST
        WHEN 'BP10000002'. er_entity-addr = '-87.6298;41.8781;0'.  " 미국 시카고
        WHEN 'BP10000003'. er_entity-addr = '-95.3662;29.7570;0'.  " 미국 휴스턴 TRAVIS ST
        WHEN 'BP10000004'. er_entity-addr = '50.1170;26.2886;0'.   " 사우디 다흐란
        WHEN 'BP10000005'. er_entity-addr = '46.6753;24.7136;0'.   " 사우디 리야드
        WHEN 'BP10000006'. er_entity-addr = '39.1842;21.4858;0'.   " 사우디 제다
        WHEN 'BP10000007'. er_entity-addr = '46.8525;24.5492;0'.   " 사우디 리야드 공단
        WHEN 'BP10000008'. er_entity-addr = '-99.1765;19.4422;0'.  " 멕시코시티 MARINA
        WHEN 'BP10000009'. er_entity-addr = '-86.8256;21.1619;0'.  " 멕시코 칸쿤
        WHEN 'BP10000010'. er_entity-addr = '-96.1342;19.1738;0'.  " 멕시코 베라크루즈
        WHEN 'BP10000011'. er_entity-addr = '-99.1620;19.4270;0'.  " 멕시코시티 REFORMA

        WHEN 'BP40000000'. er_entity-addr = '46.8122;24.4955;0'.   " 사우디 리야드 물류단지
        WHEN 'BP40000001'. er_entity-addr = '39.1550;21.4522;0'.   " 사우디 제다 항만
        WHEN 'BP40000002'. er_entity-addr = '-95.6349;29.7852;0'.  " 미국 휴스턴 에너지코리더
        WHEN 'BP40000003'. er_entity-addr = '-118.2620;33.7420;0'. " 미국 롱비치항
        WHEN 'BP40000004'. er_entity-addr = '-96.1215;19.2010;0'.  " 멕시코 베라크루즈항

        WHEN OTHERS.
          CASE er_entity-cntcd.
            WHEN 'US'. er_entity-addr = '-95.3698;29.7542;0'. " 미국 기본값 (BP10000000)
            WHEN 'SA'. er_entity-addr = '50.1170;26.2886;0'.  " 사우디 기본값 (BP10000004)
            WHEN 'MX'. er_entity-addr = '-99.1765;19.4422;0'. " 멕시코 기본값 (BP10000008)
          ENDCASE.
      ENDCASE.
    ENDIF.
  ENDMETHOD.


  METHOD bpposset_get_entityset.
    DATA: lt_bp TYPE TABLE OF ztb1sd0001.

    SELECT * FROM ztb1sd0001 INTO TABLE lt_bp.

    SORT lt_bp BY bpid bptyp.

    LOOP AT lt_bp ASSIGNING FIELD-SYMBOL(<fs_bp>).
      CASE <fs_bp>-bpid.
          " === 공급업체 (BP10대) ===
        WHEN 'BP10000000'. <fs_bp>-addr = '-95.3698;29.7542;0'.  " 미국 휴스턴 SMITH ST
        WHEN 'BP10000001'. <fs_bp>-addr = '-95.3685;29.7558;0'.  " 미국 휴스턴 DALLAS ST
        WHEN 'BP10000002'. <fs_bp>-addr = '-87.6298;41.8781;0'.  " 미국 시카고
        WHEN 'BP10000003'. <fs_bp>-addr = '-95.3662;29.7570;0'.  " 미국 휴스턴 TRAVIS ST
        WHEN 'BP10000004'. <fs_bp>-addr = '50.1170;26.2886;0'.   " 사우디 다흐란
        WHEN 'BP10000005'. <fs_bp>-addr = '46.6753;24.7136;0'.   " 사우디 리야드
        WHEN 'BP10000006'. <fs_bp>-addr = '39.1842;21.4858;0'.   " 사우디 제다
        WHEN 'BP10000007'. <fs_bp>-addr = '46.8525;24.5492;0'.   " 사우디 리야드 공단
        WHEN 'BP10000008'. <fs_bp>-addr = '-99.1765;19.4422;0'.  " 멕시코시티 MARINA
        WHEN 'BP10000009'. <fs_bp>-addr = '-86.8256;21.1619;0'.  " 멕시코 칸쿤
        WHEN 'BP10000010'. <fs_bp>-addr = '-96.1342;19.1738;0'.  " 멕시코 베라크루즈
        WHEN 'BP10000011'. <fs_bp>-addr = '-99.1620;19.4270;0'.  " 멕시코시티 REFORMA

          " === 선적장 / 물류 거점 (BP40대) ===
        WHEN 'BP40000000'. <fs_bp>-addr = '46.8122;24.4955;0'.   " 사우디 리야드 물류단지
        WHEN 'BP40000001'. <fs_bp>-addr = '39.1550;21.4522;0'.   " 사우디 제다 항만
        WHEN 'BP40000002'. <fs_bp>-addr = '-95.6349;29.7852;0'.  " 미국 휴스턴 에너지코리더
        WHEN 'BP40000003'. <fs_bp>-addr = '-118.2620;33.7420;0'. " 미국 롱비치항
        WHEN 'BP40000004'. <fs_bp>-addr = '-96.1215;19.2010;0'.  " 멕시코 베라크루즈항

          " === 그 외 예외 주소 처리 (국가코드 기준 기본값 매핑) ===
        WHEN OTHERS.
          CASE <fs_bp>-cntcd.
            WHEN 'US'. <fs_bp>-addr = '-95.3698;29.7542;0'. " 미국 기본값
            WHEN 'SA'. <fs_bp>-addr = '50.1170;26.2886;0'.  " 사우디 기본값
            WHEN 'MX'. <fs_bp>-addr = '-99.1765;19.4422;0'. " 멕시코 기본값
          ENDCASE.
      ENDCASE.

      APPEND <fs_bp> TO et_entityset.
    ENDLOOP.
  ENDMETHOD.


  METHOD volumemasterset_get_entity.
    DATA: ls_data TYPE ztb1mm0018.
    LOOP AT it_key_tab INTO DATA(ls_key).
      CASE ls_key-name.
        WHEN 'Ztemp'. " 대소문자 구분
          ls_data-ztemp  = ls_key-value.
        WHEN 'Zdens'.
          ls_data-zdens = ls_key-value.
      ENDCASE.
    ENDLOOP.

    SELECT SINGLE *
        FROM ztb1mm0018
        INTO @DATA(ls_result)
        WHERE ztemp = @ls_data-ztemp
        AND zdens = @ls_data-zdens.

    IF sy-subrc = 0.
      MOVE-CORRESPONDING ls_result TO er_entity.
    ENDIF.
  ENDMETHOD.


  METHOD volumemasterset_get_entityset.
    DATA: lr_ztemp TYPE RANGE OF ztb1mm0018-ztemp,
          lr_zdens TYPE RANGE OF ztb1mm0018-zdens,
          lr_zvcf  TYPE RANGE OF ztb1mm0018-zvcf.

    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      CASE ls_filter-property.
        WHEN 'Ztemp'.
          lr_ztemp  = CORRESPONDING #( ls_filter-select_options ).
        WHEN 'Zdens'.
          lr_zdens = CORRESPONDING #( ls_filter-select_options ).
        WHEN 'Zvcf'.
          lr_zvcf = CORRESPONDING #( ls_filter-select_options ).
      ENDCASE.
    ENDLOOP.

    SELECT * FROM ztb1mm0018
      INTO CORRESPONDING FIELDS OF TABLE @et_entityset
      WHERE ztemp IN @lr_ztemp
        AND zdens IN @lr_zdens
        AND zvcf IN @lr_zvcf.
  ENDMETHOD.


  METHOD volumeset_create_entity.
* Body에 담긴 생성 데이터를 io_data_provider를 통해 가져옴
* DB Table에 Insert 후, 처리 결과를 ER_ENTITY로 전달

    "Entity 구조와 DB Table 구조에 맞는 변수 각각 선언
    DATA: ls_entity TYPE zcl_zgwb1mm0001_mpc=>ts_volume, "ts_데이터셋의이름 찾아보면 존재
          ls_data   TYPE ztb1mm0020.

    "es_data에 Request Body(JSON) 정보가 들어옴
    io_data_provider->read_entry_data(
    IMPORTING es_data = ls_entity
     ).
    CHECK sy-subrc = 0.
    MOVE-CORRESPONDING ls_entity TO ls_data.

* 실제 db에 추가하기 전, 데이터 작업 가능
*  ls_data-memo = '이건 생성이야'.
    ls_data-ernam = sy-uname.
    ls_data-erdat = sy-datum.
    ls_data-erzet = sy-uzeit.
    ls_data-aenam = sy-uname.
    ls_data-aedat = sy-datum.
    ls_data-aezet = sy-uzeit.
    ls_data-zunit = 'CEL'.

    INSERT ztb1mm0020 FROM ls_data.
    IF sy-subrc = 0.

      COMMIT WORK.

      "PROCESS FLOW 생성(강효창)
      DATA LV_REQNO TYPE ZEB1_SD_REF_DOC_NO.
      DATA LV_DOCNO TYPE ZEB1_SD_RESULT_DOC_NO.

      IF LS_DATA-ZDOCTY = 'PO-1'.
        LV_REQNO = CONV CHAR20( LS_DATA-ZDOCNO ).
        LV_DOCNO = CONV CHAR20( LS_DATA-ZMSNO ).

        ZCL_B1_PROCESS_STATUS=>SAVE(
          EXPORTING
            IV_PROGRAM_ID      = 'ZPB1MM04'
            IV_REF_DOC_NO      = LV_REQNO
            IV_RESULT_DOC_NO   = LV_DOCNO
            IV_RESULT_DOC_TYPE = ''
            IV_STATUS_TEXT     = '부피 측정 완료'
          EXCEPTIONS
            PROGRAM_NOT_FOUND  = 1
            MAPPING_NOT_FOUND  = 2
            CREATE_ERROR       = 3
            COMPLETE_ERROR     = 4
            OTHERS             = 5
        ).

        IF SY-SUBRC <> 0.
          MESSAGE S026(ZMCB1) WITH |PROCESS STATUS 저장 중| DISPLAY LIKE 'E'.
        ENDIF.
      ELSEIF LS_DATA-ZDOCTY = 'PO-2'.
                LV_REQNO = CONV CHAR20( LS_DATA-ZDOCNO ).
        LV_DOCNO = CONV CHAR20( LS_DATA-ZMSNO ).

        ZCL_B1_PROCESS_STATUS=>SAVE(
          EXPORTING
            IV_PROGRAM_ID      = 'ZPB1MM04_2'
            IV_REF_DOC_NO      = LV_REQNO
            IV_RESULT_DOC_NO   = LV_DOCNO
            IV_RESULT_DOC_TYPE = ''
            IV_STATUS_TEXT     = '부피 측정 완료'
          EXCEPTIONS
            PROGRAM_NOT_FOUND  = 1
            MAPPING_NOT_FOUND  = 2
            CREATE_ERROR       = 3
            COMPLETE_ERROR     = 4
            OTHERS             = 5
        ).

        IF SY-SUBRC <> 0.
          MESSAGE S026(ZMCB1) WITH |PROCESS STATUS 저장 중| DISPLAY LIKE 'E'.
        ENDIF.
      ENDIF.


      " ER_ENTITY에 결과를 반영
      MOVE-CORRESPONDING ls_entity TO er_entity.
    ELSE.
      ROLLBACK WORK.
    ENDIF.
  ENDMETHOD.


  METHOD volumeset_delete_entity.
**TRY.
*CALL METHOD SUPER->VOLUMESET_DELETE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.
  ENDMETHOD.


  METHOD volumeset_get_entity.
    DATA: ls_data TYPE ztb1mm0020.
    LOOP AT it_key_tab INTO DATA(ls_key).
      CASE ls_key-name.
        WHEN 'Zmsno'. " 대소문자 구분
          ls_data-zmsno  = ls_key-value.
        WHEN 'Zdocit'.
          ls_data-zdocit = ls_key-value.
      ENDCASE.
    ENDLOOP.

    SELECT SINGLE *
        FROM ztb1mm0020
        INTO @DATA(ls_result)
        WHERE zmsno = @ls_data-zmsno
        AND zdocit = @ls_data-zdocit.

    IF sy-subrc = 0.
      MOVE-CORRESPONDING ls_result TO er_entity.
    ENDIF.
  ENDMETHOD.


  METHOD volumeset_get_entityset.
    DATA: lr_zmsno TYPE RANGE OF ztb1mm0020-zmsno,
          lr_ztemp TYPE RANGE OF ztb1mm0020-ztemp,
          lr_zdens TYPE RANGE OF ztb1mm0020-zdens,
          lr_zvcf  TYPE RANGE OF ztb1mm0020-zvcf,
          lr_zmdat TYPE RANGE OF ztb1mm0020-zmdat.

    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      CASE ls_filter-property.
        WHEN 'Zmsno'.
          lr_zmsno  = CORRESPONDING #( ls_filter-select_options ).
        WHEN 'Zmdat'.
          lr_zmdat = CORRESPONDING #( ls_filter-select_options ).
        WHEN 'Ztemp'.
          lr_ztemp  = CORRESPONDING #( ls_filter-select_options ).
        WHEN 'Zdens'.
          lr_zdens = CORRESPONDING #( ls_filter-select_options ).
        WHEN 'Zvcf'.
          lr_zvcf = CORRESPONDING #( ls_filter-select_options ).
      ENDCASE.
    ENDLOOP.

    SELECT * FROM ztb1mm0020
      INTO CORRESPONDING FIELDS OF TABLE @et_entityset
      WHERE zmsno IN @lr_zmsno
        AND ztemp IN @lr_ztemp
        AND zdens IN @lr_zdens
        AND zvcf IN @lr_zvcf
        AND zmdat IN @lr_zmdat.

    SORT et_entityset BY zdocty zdocno.
  ENDMETHOD.


  METHOD volumeset_update_entity.
**TRY.
*CALL METHOD SUPER->VOLUMESET_UPDATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.
  ENDMETHOD.


  METHOD poset_get_entity.
    DATA: ls_data TYPE ztb1mm0007.
    LOOP AT it_key_tab INTO DATA(ls_key).
      CASE ls_key-name.
        WHEN 'Ebeln'. " 대소문자 구분
          ls_data-ebeln  = ls_key-value.
        WHEN 'Ebelp'.
          ls_data-ebelp = ls_key-value.
      ENDCASE.
    ENDLOOP.

    SELECT SINGLE *
        FROM ztb1mm0007
        INTO @DATA(ls_result)
        WHERE ebeln = @ls_data-ebeln
        AND ebelp = @ls_data-ebelp.

    IF sy-subrc = 0.
      MOVE-CORRESPONDING ls_result TO er_entity.
    ENDIF.
  ENDMETHOD.


  METHOD poset_get_entityset.
    DATA: lr_ebeln  TYPE RANGE OF ztb1mm0007-ebeln,
          lr_matnr  TYPE RANGE OF ztb1mm0007-matnr,
          lr_werks  TYPE RANGE OF ztb1mm0007-werks,
          lr_lgort  TYPE RANGE OF ztb1mm0007-lgort,
          lr_insmk  TYPE RANGE OF ztb1mm0007-insmk,
          lr_postat TYPE RANGE OF ztb1mm0007-postat.

    LOOP AT it_filter_select_options INTO DATA(ls_filter).
      CASE ls_filter-property.
        WHEN 'Ebeln'.
          lr_ebeln  = CORRESPONDING #( ls_filter-select_options ).
        WHEN 'Matnr'.
          lr_matnr = CORRESPONDING #( ls_filter-select_options ).
        WHEN 'Werks'.
          lr_werks  = CORRESPONDING #( ls_filter-select_options ).
        WHEN 'Lgort'.
          lr_lgort = CORRESPONDING #( ls_filter-select_options ).
        WHEN 'Insmk'.
          lr_insmk = CORRESPONDING #( ls_filter-select_options ).
        WHEN 'Postat'.
          lr_postat = CORRESPONDING #( ls_filter-select_options ).
      ENDCASE.
    ENDLOOP.

    SELECT * FROM ztb1mm0007
      INTO CORRESPONDING FIELDS OF TABLE @et_entityset
      WHERE ebeln IN @lr_ebeln
        AND matnr IN @lr_matnr
        AND werks IN @lr_werks
        AND lgort IN @lr_lgort
        AND insmk IN @lr_insmk
        AND postat IN @lr_postat.
  ENDMETHOD.
ENDCLASS.