*&---------------------------------------------------------------------*
*& Report ZMEMO_B08
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmemo_b08.


*--------------------------------------------------------------------*
*& db ### ###
*--------------------------------------------------------------------*
*DELETE FROM ztb1mm0011 where plpr BETWEEN '0000001333' AND '0000001436' .
**DELETE FROM ztb1mm0012 where plpr BETWEEN '0000001333' AND '0000001436' .
*
*IF sy-subrc = 0.
*  COMMIT WORK. " ## ### DB# ## ##
*  MESSAGE '#### ## #######.' TYPE 'S'.
*ELSE.
*  ROLLBACK WORK.
*  MESSAGE '## #### ### ## # ### ######.' TYPE 'W'.
*ENDIF.

*DELETE FROM ztb1mm0020 where erdat BETWEEN '20260627' AND '20260629' .
*DELETE FROM ztb1mm0012 where plpr BETWEEN '0000001333' AND '0000001436' .

*IF sy-subrc = 0.
*  COMMIT WORK. " ## ### DB# ## ##
*  MESSAGE '#### ## #######.' TYPE 'S'.
*ELSE.
*  ROLLBACK WORK.
*  MESSAGE '## #### ### ## # ### ######.' TYPE 'W'.
*ENDIF.

*--------------------------------------------------------------------*
*& #### # #### #### ## #### (## ## ##)
*--------------------------------------------------------------------*

*DATA: lt_pp_head  TYPE TABLE OF ztb1mm0011, " ### ##
*      lt_all_data TYPE TABLE OF ztb1mm0012, " ### ## ## ### ###
*      lt_pp_data  TYPE TABLE OF ztb1mm0012. " #### ### ## 1## (## ###)
*
*FIELD-SYMBOLS: <ls_head> TYPE ztb1mm0011.
*
*REFRESH: lt_pp_head, lt_all_data, lt_pp_data.
*
*" 1.
*SELECT * FROM ztb1mm0011 WHERE vgart = 'GI'
*  AND ( mblnr BETWEEN '5000003301' AND '5000003302' )
*  AND vbeln IS NOT INITIAL
*  INTO TABLE @lt_pp_head.
*
*IF lt_pp_head IS INITIAL.
*  MESSAGE '## ## ### ### #### ####.' TYPE 'S'. RETURN.
*ENDIF.
*
*" 2. ## #### ## ## ### ### ## ##
*SELECT * FROM ztb1mm0012
*  FOR ALL ENTRIES IN @lt_pp_head
*  WHERE mblnr = @lt_pp_head-mblnr
*    AND mjahr = @lt_pp_head-mjahr
*  INTO TABLE @lt_all_data.
*
*IF lt_all_data IS INITIAL.
*  MESSAGE '## ## ### #### #### ####.' TYPE 'S'. RETURN.
*ENDIF.
*
*" ### ### ### ## ## ##
*SORT lt_all_data BY mblnr mjahr.
*
*
*" 3. ## ## ## ## (### ## ## ##)
*LOOP AT lt_pp_head ASSIGNING <ls_head>.
*
*  REFRESH: lt_pp_data.
*
*  CALL FUNCTION 'ZFB1MM0001'
*    EXPORTING
*      i_mblnr            = <ls_head>-mblnr " # ## ## ## ### ### ## ##
**     i_mjahr            = <ls_head>-mjahr " ## ## ##### ## ##
*    EXCEPTIONS
*      invalid_input_data = 1
*      OTHERS             = 2.
*
*  IF sy-subrc <> 0.
*    WRITE: / |[## ##] ###: { <ls_head>-mblnr } ## #### ##.|.
*    " ## #### ## # ## ### ####(CONTINUE), ##### ##### ## ## ##
*  ENDIF.
*
*ENDLOOP.
*
*" 4. ## ## ### ##
*IF lt_all_data IS NOT INITIAL.
*  cl_demo_output=>next_section( 'SD ### ## ### ## ##' ).
*  cl_demo_output=>display( lt_all_data ).
*ENDIF.

**********************************************************************
*     MM0001, 0003 ### #### (# ##, ##) #### ###
**********************************************************************
*DATA: lv_mblnr TYPE zeb1_mm_mblnr.
*
*lv_mblnr = '5000000048'.
*
*
*CALL FUNCTION 'ZFB1MM0001'
*  EXPORTING
*    i_mblnr             = lv_mblnr                " ## ## ##
*   i_mjahr             =                  " ## ## ##
*   i_zeile             =                  " ## ## ## ##
*   i_matnr             =                  " ####
*   i_lgort             =                  " ####
*   i_werks             = '1000'           " ###
*   i_insmk             = 'A'              " ## ##
*   i_dmbtr             =                  " # ####(##)
*   i_menge             =                  " ##
*   i_bwart             =                  " ## ##
*    CHANGING
*   cs_mm0011           =                  " ## ## ## ##
*   cs_mm0023           =                  " ## ## ## ## ###
*   cs_mm0024           =                  " ## ## ## ### ###
*  EXCEPTIONS
*    invalid_input_data  = 1                " Invalid Input Data
*    error_modify_mm0001 = 2                " Invalid Moidfy Data in MM0001
*    error_modify_mm0003 = 3                " Invalid Moidfy Data in MM0003
*    invalid_mm0001_data = 4                " No MM0001 Data
*    invalid_mm0003_data = 5                " No MM0003 Data
*    invalid_mm0011_data = 6                " No MM0011 Data
*    invalid_mm0012_data = 7                " No MM0012 Data
*    error_insert_mm0023 = 8                " iInvalid Insert Data in MM0023
*    error_insert_mm0024 = 9                " Invalid Insert Data in MM0024
*    OTHERS              = 10.
*
*IF sy-subrc <> 0.
*  WRITE: '###'.
*ELSE.
*  DATA: lt_0012 TYPE TABLE OF ztb1mm0012.
*  SELECT * FROM ztb1mm0012
*    INTO TABLE lt_0012
*    WHERE mblnr = lv_mblnr.
*
*  cl_demo_output=>display( lt_0012 ).
*ENDIF.


**********************************************************************
*     #### #### ##( SD )
**********************************************************************
*
*" 1. SD ##### ### ## ## ##
*DATA: lt_sd_data TYPE TABLE OF ztb1sd0009,
*      ls_sd_data TYPE ztb1sd0009.
**
**" ## ### ## # ## ### ##
*DATA: lt_result_volm TYPE zttb1mm0001. " Export ### ##
**
*CLEAR lt_sd_data.
*
*" [## ### ##]
**ls_sd_data = VALUE #( vbeln = 'DO00000001' posnr = '10' vbeln_va = 'SO00000001' posnr_va = '10' werks = '2000' lgort = '2000' matnr = 'GAS-300' lfimg = '1000' meins = 'BBL' ernam = 'NCODE-B-29' erdat = '20260409' ). APPEND ls_sd_d
**ls_sd_data = VALUE #( vbeln = 'DO00000001' posnr = '20' vbeln_va = 'SO00000001' posnr_va = '20' werks = '2000' lgort = '2000' matnr = 'DIE-300' lfimg = '900'  meins = 'BBL' ernam = 'NCODE-B-29' erdat = '20260409' ). APPEND ls_sd_d
*ls_sd_data = VALUE #( vbeln = 'DO00000002' posnr = '10' vbeln_va = 'SO00000002' posnr_va = '10' werks = '2000' lgort = '2000' matnr = 'JET-300' lfimg = '1200' meins = 'BBL' ernam = 'NCODE-B-29' erdat = '20260409' ). APPEND ls_sd_da
*ls_sd_data = VALUE #( vbeln = 'DO00000002' posnr = '20' vbeln_va = 'SO00000002' posnr_va = '20' werks = '2000' lgort = '2000' matnr = 'GAS-300' lfimg = '800'  meins = 'BBL' ernam = 'NCODE-B-29' erdat = '20260409' ). APPEND ls_sd_da
**ls_sd_data = VALUE #( vbeln = 'DO00000003' posnr = '10' vbeln_va = 'SO00000003' posnr_va = '10' werks = '2000' lgort = '2000' matnr = 'DIE-300' lfimg = '1000' meins = 'BBL' ernam = 'NCODE-B-29' erdat = '20260409' ). APPEND ls_sd_d
*
*ls_sd_data = VALUE #( vbeln = 'DO00000003' posnr = '20' vbeln_va = 'SO00000003' posnr_va = '20' werks = '2000' lgort = '2000' matnr = 'ASP-300' lfimg = '700'  meins = 'BBL' ernam = 'NCODE-B-29' erdat = '20260409' ). APPEND ls_sd_da
*ls_sd_data = VALUE #( vbeln = 'DO00000004' posnr = '10' vbeln_va = 'SO00000004' posnr_va = '10' werks = '3000' lgort = '3000' matnr = 'DIE-300' lfimg = '1100' meins = 'BBL' ernam = 'NCODE-B-29' erdat = '20260409' ). APPEND ls_sd_da
*ls_sd_data = VALUE #( vbeln = 'DO00000004' posnr = '20' vbeln_va = 'SO00000004' posnr_va = '20' werks = '3000' lgort = '3000' matnr = 'GAS-300' lfimg = '950'  meins = 'BBL' ernam = 'NCODE-B-29' erdat = '20260409' ). APPEND ls_sd_da
*ls_sd_data = VALUE #( vbeln = 'DO00000005' posnr = '10' vbeln_va = 'SO00000005' posnr_va = '10' werks = '3000' lgort = '3000' matnr = 'NAP-300' lfimg = '1150' meins = 'BBL' ernam = 'NCODE-B-29' erdat = '20260409' ). APPEND ls_sd_da
*ls_sd_data = VALUE #( vbeln = 'DO00000005' posnr = '20' vbeln_va = 'SO00000005' posnr_va = '20' werks = '3000' lgort = '3000' matnr = 'LPG-300' lfimg = '870'  meins = 'BBL' ernam = 'NCODE-B-29' erdat = '20260409' ). APPEND ls_sd_da
*
*ls_sd_data = VALUE #( vbeln = 'DO00000006' posnr = '10' vbeln_va = 'SO00000006' posnr_va = '10' werks = '3000' lgort = '3000' matnr = 'NAP-300' lfimg = '1300' meins = 'BBL' ernam = 'NCODE-B-29' erdat = '20260409' ). APPEND ls_sd_da
*ls_sd_data = VALUE #( vbeln = 'DO00000007' posnr = '10' vbeln_va = 'SO00000007' posnr_va = '10' werks = '4000' lgort = '4000' matnr = 'GAS-300' lfimg = '1000' meins = 'BBL' ernam = 'NCODE-B-29' erdat = '20260409' ). APPEND ls_sd_da
*ls_sd_data = VALUE #( vbeln = 'DO00000007' posnr = '20' vbeln_va = 'SO00000007' posnr_va = '20' werks = '4000' lgort = '4000' matnr = 'DIE-300' lfimg = '1020' meins = 'BBL' ernam = 'NCODE-B-29' erdat = '20260409' ). APPEND ls_sd_da
*ls_sd_data = VALUE #( vbeln = 'DO00000008' posnr = '10' vbeln_va = 'SO00000008' posnr_va = '10' werks = '4000' lgort = '4000' matnr = 'LPG-300' lfimg = '980'  meins = 'BBL' ernam = 'NCODE-B-29' erdat = '20260409' ). APPEND ls_sd_da
*ls_sd_data = VALUE #( vbeln = 'DO00000008' posnr = '20' vbeln_va = 'SO00000008' posnr_va = '20' werks = '4000' lgort = '4000' matnr = 'GAS-300' lfimg = '970'  meins = 'BBL' ernam = 'NCODE-B-29' erdat = '20260409' ). APPEND ls_sd_da
*
*ls_sd_data = VALUE #( vbeln = 'DO00000009' posnr = '10' vbeln_va = 'SO00000009' posnr_va = '10' werks = '4000' lgort = '4000' matnr = 'JET-300' lfimg = '1400' meins = 'BBL' ernam = 'NCODE-B-29' erdat = '20260409' ). APPEND ls_sd_da
*ls_sd_data = VALUE #( vbeln = 'DO00000010' posnr = '10' vbeln_va = 'SO00000012' posnr_va = '10' werks = '1000' lgort = '2000' matnr = 'GAS-300' lfimg = '1000' meins = 'BBL' ernam = 'NCODE-B-29' erdat = '20260410' ). APPEND ls_sd_da
*ls_sd_data = VALUE #( vbeln = 'DO00000010' posnr = '20' vbeln_va = 'SO00000012' posnr_va = '20' werks = '1000' lgort = '2000' matnr = 'DIE-300' lfimg = '980'  meins = 'BBL' ernam = 'NCODE-B-29' erdat = '20260410' ). APPEND ls_sd_da
*


*REFRESH lt_sd_data.
*
*SELECT * FROM ztb1sd0009
*    INTO TABLE lt_sd_data
*    WHERE VBELN = 'DO00000040'. "WL WA
*
*READ TABLE lt_sd_data INTO DATA(ls_row) INDEX 1.
*DATA(lv_dat) = ls_row-erdat.
*
*CALL FUNCTION 'ZFB1CM0002'
*  EXPORTING
*    it_table            = lt_sd_data
*    i_docty             = 'SO' " PrO-GR
*    i_zmdat             = lv_dat
*  IMPORTING
*    et_volm             = lt_result_volm
*  EXCEPTIONS
*    parameter_error     = 1
*    empty_data          = 2
*    invalid_material    = 3
*    db_insert_failed    = 4
*    not_unique_document = 5
*    OTHERS              = 6.
*
*
*CASE sy-subrc.
*
*  WHEN 0.
*    MESSAGE '###' TYPE 'S'.
*    cl_demo_output=>display( lt_result_volm ).
*  WHEN 1.
*    WRITE: / '## 1: ## ## ##### ######.'.
*  WHEN 2.
*    WRITE: / '## 2: ### ###(it_table)# ######.'.
*  WHEN 3.
*    WRITE: / '## 3: ##### ###### #### ## ##, ## ### 0 #####.'.
*  WHEN 4.
*    WRITE: / '## 4: #### DB(ZTB1MM0020) ## #### ######.'.
*  WHEN 5.
*    WRITE: / '## 5: ## ## #### ####. ### ## ### #####.' .
*  WHEN OTHERS.
*    WRITE: / '## # # ## ### ## ##.'.
*ENDCASE.

***********************************************************************
**     #### #### ##( PP )
***********************************************************************
**
*" 1. PP ###### ### ## ## ##
*DATA: lt_pp_data TYPE TABLE OF ztb1mm0012,
*      ls_pp_data TYPE ztb1mm0012.
*
*" ## ### ## # ## ### ##
**DATA: lt_result_volm TYPE zttb1mm0001. " Export ### ##
*
*REFRESH lt_pp_data.
*
*SELECT * FROM ztb1mm0012
*    INTO TABLE lt_pp_data
*    WHERE mblnr = '5000000006'. "WL WA
*
*READ TABLE lt_pp_data INTO DATA(ls_row) INDEX 1.
*DATA(lv_dat) = ls_row-erdat.
*
*CALL FUNCTION 'ZFB1CM0002'
*  EXPORTING
*    it_table            = lt_sd_data
*    i_docty             = 'PrO-GR' "'SO' " PrO-GR
*    i_zmdat             = lv_dat
*  IMPORTING
*    et_volm             = lt_result_volm
*  EXCEPTIONS
*    parameter_error     = 1
*    empty_data          = 2
*    invalid_material    = 3
*    db_insert_failed    = 4
*    not_unique_document = 5
*    OTHERS              = 6.
*
*
*CASE sy-subrc.
*
*  WHEN 0.
*    cl_demo_output=>display( lt_result_volm ).
*  WHEN 1.
*    WRITE: / '## 1: ## ## ##### ######.'.
*  WHEN 2.
*    WRITE: / '## 2: ### ###(it_table)# ######.'.
*  WHEN 3.
*    WRITE: / '## 3: ##### ###### #### ## ##, ## ### 0 #####.'.
*  WHEN 4.
*    WRITE: / '## 4: #### DB(ZTB1MM0020) ## #### ######.'.
*  WHEN 5.
*    WRITE: / '## 5: ## ## #### ####. ### ## ### #####.' .
*  WHEN OTHERS.
*    WRITE: / '## # # ## ### ## ##.'.
*ENDCASE.


**--------------------------------------------------------------------*
**& #### # #### #### ## #### (## ## ##)
**--------------------------------------------------------------------*
*
*DATA: lt_pp_head    TYPE TABLE OF ztb1mm0011, " ### ##
*      lt_all_data   TYPE TABLE OF ztb1mm0012, " ### ## ## ### ###
*      lt_pp_data    TYPE TABLE OF ztb1mm0012, " #### ### ## 1## (## ###)
*      lt_result_all TYPE zttb1mm0001,         " ## #### ## ###
*      lt_result_volm TYPE zttb1mm0001.        " #### ## ###
*
*FIELD-SYMBOLS: <ls_head> TYPE ztb1mm0011.
*
*REFRESH: lt_pp_head, lt_all_data, lt_result_all.
*
*" 1. ## ## ### ## ## (#### WL # GI ##)
*SELECT * FROM ztb1mm0011 INTO TABLE @lt_pp_head WHERE vgart = 'GI'
*  and mjahr BETWEEN '5000002204' AND '5000002245'.
*
*IF lt_pp_head IS INITIAL.
*  MESSAGE '## ## ### ### #### ####.' TYPE 'S'. RETURN.
*ENDIF.
*
*" 2. ## #### ## ## ### ### ## ##
*SELECT * FROM ztb1mm0012
*  FOR ALL ENTRIES IN @lt_pp_head
*  WHERE mblnr = @lt_pp_head-mblnr
*    AND mjahr = @lt_pp_head-mjahr
*  INTO TABLE @lt_all_data.
*
*IF lt_all_data IS INITIAL.
*  MESSAGE '## ## ### #### #### ####.' TYPE 'S'. RETURN.
*ENDIF.
*
*" ### ### ### ## ## ##
*SORT lt_all_data BY mblnr mjahr.
*
*
*" 3. ## ## ## ## (### ## ## ##)
*LOOP AT lt_pp_head ASSIGNING <ls_head>.
*
*  REFRESH: lt_pp_data, lt_result_volm.
*
*  " ----------------------------------------------------------------
*  " # [## A] #### #### ## ## (### ## 1## # 1## ##)
*  " ----------------------------------------------------------------
*  CALL FUNCTION 'ZFB1MM0001'
*    EXPORTING
*      i_mblnr             = <ls_head>-mblnr " # ## ## ## ### ### ## ##
** i_mjahr             = <ls_head>-mjahr " ## ## ##### ## ##
*    EXCEPTIONS
*      invalid_input_data  = 1
*      OTHERS              = 2.
*
*  IF sy-subrc <> 0.
*    WRITE: / |[## ##] ###: { <ls_head>-mblnr } ## #### ##.|.
*    " ## #### ## # ## ### ####(CONTINUE), ##### ##### ## ## ##
*  ENDIF.
*
*
**  " ----------------------------------------------------------------
**  " # [## B] #### ## ## #### (### ## ##)
**  " ----------------------------------------------------------------
**  " ## ##### ## ### ### #### #### # ##
**  LOOP AT lt_all_data INTO DATA(ls_item) WHERE mblnr = <ls_head>-mblnr
**                                           AND mjahr = <ls_head>-mjahr.
**    APPEND ls_item TO lt_pp_data.
**  ENDLOOP.
**
**  " #### ### #### ##
**  IF lt_pp_data IS INITIAL.
**    CONTINUE.
**  ENDIF.
**
**  " ### ### ##(lt_pp_data)# #### ### ##
**  CALL FUNCTION 'ZFB1CM0002'
**    EXPORTING
**      it_table            = lt_pp_data    " ## ### ### ##
**      i_docty             = 'SO'          " ## ##
**      i_zmdat             = <ls_head>-bldat
**    IMPORTING
**      et_volm             = lt_result_volm
**    EXCEPTIONS
**      parameter_error     = 1
**      empty_data          = 2
**      invalid_material    = 3
**      db_insert_failed    = 4
**      not_unique_document = 5
**      OTHERS              = 6.
**
**  " #### ## ## # ## ##
**  IF sy-subrc = 0.
***    APPEND LINES OF lt_result_volm TO lt_result_all.
**  ELSE.
**    WRITE: / |[## ##] ###: { <ls_head>-mblnr } #### ## - ##: { sy-subrc }|.
**  ENDIF.
*
*
*ENDLOOP.
*
*" 4. ## ## ### ##
*IF lt_result_all IS NOT INITIAL.
*  cl_demo_output=>next_section( '##(PP) #### ## ### ## ##' ).
*  cl_demo_output=>display( lt_result_all ).
*ENDIF.

**--------------------------------------------------------------------*
**& #### #### ##/## ## ( PP ## ## ## )
**--------------------------------------------------------------------*
*
*" 1. ### ### ##
*DATA: lt_pp_head    TYPE TABLE OF ztb1mm0011, " ### ##
*      lt_all_data   TYPE TABLE OF ztb1mm0012, " ### ## ## ### ###
*      lt_pp_data    TYPE TABLE OF ztb1mm0012, " ### ### ## 1##(## ###)
*      lt_result_all TYPE zttb1mm0001,         " ## ### ## ### (###)
*      lt_result_volm TYPE zttb1mm0001.        " ## export# ## ###
*
*FIELD-SYMBOLS: <ls_head> TYPE ztb1mm0011.
*
*REFRESH: lt_pp_head, lt_all_data, lt_result_all.
*
*" 2. ## ## ### ## ## (#### WL: ####, WA: ####)
*SELECT * FROM ztb1mm0011
*  INTO TABLE @lt_pp_head
*  WHERE ( vgart = 'GI' ).
*
*IF lt_pp_head IS INITIAL.
*  MESSAGE '## ## ### ### #### ####.' TYPE 'S'.
*  RETURN.
*ENDIF.
*
*" 3. ## #### ## ## ### ### ## ##
*SELECT * FROM ztb1mm0012
*  FOR ALL ENTRIES IN @lt_pp_head
*  WHERE mblnr = @lt_pp_head-mblnr
*    AND mjahr = @lt_pp_head-mjahr
*  INTO TABLE @lt_all_data.
*
*IF lt_all_data IS INITIAL.
*  MESSAGE '## ## ### #### #### ####.' TYPE 'S'.
*  RETURN.
*ENDIF.
*
*" # ## ## (### #### ### ### ### ## ##)
*SORT lt_all_data BY mblnr mjahr.
*
*
*" 4. ### #### ### ## ### #### '# ###' ##
*LOOP AT lt_pp_head ASSIGNING <ls_head>.
*
*  REFRESH: lt_pp_data, lt_result_volm.
*
*  " ## ### ###(lt_all_data)## ## ### ### ### #### #### # ## # #### ##
*  LOOP AT lt_all_data INTO DATA(ls_item) WHERE mblnr = <ls_head>-mblnr
*                                           AND mjahr = <ls_head>-mjahr.
*    APPEND ls_item TO lt_pp_data.
*  ENDLOOP.
*
*  " ## ### ### #### ### ## ## ##
*  IF lt_pp_data IS INITIAL.
*    CONTINUE.
*  ENDIF.
*
*  CALL FUNCTION 'ZFB1MM0001'
*  EXPORTING
*    i_mblnr             = lv_mblnr                " ## ## ##
*"   i_mjahr             =                  " ## ## ##
*"   i_zeile             =                  " ## ## ## ##
**   i_matnr             =                  " ####
**   i_lgort             =                  " ####
**   i_werks             = '1000'           " ###
**   i_insmk             = 'A'              " ## ##
**   i_dmbtr             =                  " # ####(##)
**   i_menge             =                  " ##
**   i_bwart             =                  " ## ##
**    CHANGING
**   cs_mm0011           =                  " ## ## ## ##
**   cs_mm0023           =                  " ## ## ## ## ###
**   cs_mm0024           =                  " ## ## ## ### ###
*  EXCEPTIONS
*    invalid_input_data  = 1                " Invalid Input Data
*    error_modify_mm0001 = 2                " Invalid Moidfy Data in MM0001
*    error_modify_mm0003 = 3                " Invalid Moidfy Data in MM0003
*    invalid_mm0001_data = 4                " No MM0001 Data
*    invalid_mm0003_data = 5                " No MM0003 Data
*    invalid_mm0011_data = 6                " No MM0011 Data
*    invalid_mm0012_data = 7                " No MM0012 Data
*    error_insert_mm0023 = 8                " iInvalid Insert Data in MM0023
*    error_insert_mm0024 = 9                " Invalid Insert Data in MM0024
*    OTHERS              = 10.
*
*IF sy-subrc <> 0.
*  WRITE: '###'.
*ELSE.
*  DATA: lt_0012 TYPE TABLE OF ztb1mm0012.
*  SELECT * FROM ztb1mm0012
*    INTO TABLE lt_0012
*    WHERE mblnr = lv_mblnr.
*
*  cl_demo_output=>display( lt_0012 ).
*ENDIF.
*
*  " 5. #### ## (# ### ###)
*  CALL FUNCTION 'ZFB1CM0002'
*    EXPORTING
*      it_table            = lt_pp_data    " ## ### ## # ## ###
*      i_docty             = 'SO'      " ## ##/## ## ##
*      i_zmdat             = <ls_head>-bldat " ## ### #### ##
*    IMPORTING
*      et_volm             = lt_result_volm
*    EXCEPTIONS
*      parameter_error     = 1
*      empty_data          = 2
*      invalid_material    = 3
*      db_insert_failed    = 4
*      not_unique_document = 5
*      OTHERS              = 6.
*
*  " 6. ## ## # ## ##
*  IF sy-subrc = 0.
*    " ### ##### ## ### ## ## ## #### ###
*    APPEND LINES OF lt_result_volm TO lt_result_all.
*  ELSE.
*    " ### ## #### ### ### ##### ##
*    WRITE: / |### ## [{ <ls_head>-mblnr }] ## # ## ## - ##: { sy-subrc }|.
*    CASE sy-subrc.
*      WHEN 1. WRITE: ' (## #### ##)'.
*      WHEN 2. WRITE: ' (### ####)'.
*      WHEN 3. WRITE: ' (#### ## ## ## 0 ##)'.
*      WHEN 4. WRITE: ' (ZTB1MM0020 DB ### ##)'.
*      WHEN 5. WRITE: ' (## ## #### ##)'.
*      WHEN OTHERS. WRITE: ' (# # ## ##)'.
*    ENDCASE.
*  ENDIF.
*
*ENDLOOP.
*
*" 7. ### ## ## # ## ## ## ### ### #####
*IF lt_result_all IS NOT INITIAL.
*  cl_demo_output=>next_section( '##(PP) #### ## ### ## ##' ).
*  cl_demo_output=>display( lt_result_all ).
*ENDIF.

*" ------------------------------------------------------------------
*" ### ###
*" ------------------------------------------------------------------

*DATA: ls_head    TYPE ztb1mm0011,
*      ls_mm_item TYPE ztb1mm0012,
*      lt_mm_item LIKE TABLE OF ls_mm_item.
*
*DATA: lt_mm_head TYPE TABLE OF ztb1mm0011,
*      ls_mm_head TYPE ztb1mm0011.
*
*SELECT SINGLE * FROM ztb1mm0011
*INTO ls_mm_head
*WHERE mblnr  = '5000000224'.
*
*
**SELECT * FROM zcds_b1_mm_0002( p_bldat = @ls_mm_head-bldat )
**INTO MOVE CORRESPONTABLE lt_mm_item
**WHERE mblnr  = '5000000224'.
*
**ls_mm_item-mblnr  = '5000000224'.
**ls_mm_item-mblnr  = '5000000587'.
**ls_mm_item-mblnr  = '5000000698'.
*
*DATA: lv_fi_belnr TYPE belnr,
*      lv_fi_subrc TYPE sy-subrc.
*
*CALL FUNCTION 'ZFB1FI0002'
*  EXPORTING
*    i_bukrs    = ls_mm_head-bukrs
*    i_bldat    = ls_mm_head-bldat   " ###
*    i_bwart    = '101'
*    i_mode     = 'ZMM_SHIP'    " Character Field with Length 10
*    i_zawkey   = ls_mm_head-mblnr          " ######(#)
**   i_waers    =     " ##
**   i_mandt    =                  " Client
**   i_bpid     =                  " BP ID
**   i_bptyp    =                  " BP ##
*    it_mm_item = lt_mm_item
**   it_iv_item =                  " #######
**   i_ukurs    =                  " ## #
**   i_mblnr_wk =                  " ## ## ##
*  IMPORTING
*    e_belnr    = lv_fi_belnr
*    e_subrc    = lv_fi_subrc.   " ABAP System Field: Return Code of ABAP Statements  " #### ## ##
*
*IF lv_fi_subrc = 0 AND lv_fi_belnr IS INITIAL.
*  lv_fi_subrc = 10.
*ENDIF.
*
*CASE lv_fi_subrc.
*  WHEN 0.
*    DATA: lt_fi_item TYPE TABLE OF ztb1fi0002.
*
*    SELECT * FROM ztb1fi0002
*    INTO TABLE lt_fi_item WHERE belnr = lv_fi_belnr.
*
*    cl_demo_output=>display( lt_fi_item ).
*  WHEN 9.
*    WRITE: / '## 9'.
*  WHEN 8.
*    WRITE: / '## 8.'.
*  WHEN 4.
*    WRITE: / '## 4'.
*  WHEN 10.
*    WRITE: / '## 10' .
*  WHEN 6.
*    WRITE: / '## 6'.
*  WHEN OTHERS.
*    WRITE: / '## # # ## ### ## ##.'.
*ENDCASE.

**********************************************************************

*UPDATE ztb1mm0004
*   SET mwskz = 'B1'
* WHERE bpid  = 'BP30000000'.

*--------------------------------------------------------------------*
** DB Insert (0025 ####)
*--------------------------------------------------------------------*

*DATA: lt_header TYPE TABLE OF ztb1mm0006,
*      lt_item   TYPE TABLE OF ztb1mm0007,
*      lt_insert TYPE TABLE OF ztb1mm0025.
*
*" 1. ## ## # ### ### ##
*SELECT * FROM ztb1mm0006 INTO TABLE @lt_header.
*IF lt_header IS INITIAL. RETURN. ENDIF.
*
*SELECT * FROM ztb1mm0007
*  FOR ALL ENTRIES IN @lt_header
*  WHERE ebeln = @lt_header-ebeln
*  INTO TABLE @lt_item.
*
*" 2 & 3. NB ## ## #### # CDS View ## ##
*TYPES: BEGIN OF ty_cds_raw,
*         bpid          TYPE c LENGTH 10,
*         matnr         TYPE matnr,
*         fin_netpr_usd TYPE p LENGTH 13 DECIMALS 5,
*         zfrt          TYPE p LENGTH 13 DECIMALS 5,
*       END OF ty_cds_raw.
*DATA: lt_cds_raw TYPE STANDARD TABLE OF ty_cds_raw.
*
*" NB ## ### ##### ### ###.
*LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<ls_header>) WHERE bsart = 'NB'.
*
*  " ## NB ### BP# ### #### CDS ## ##
*  CLEAR lt_cds_raw.
*  SELECT bpid, matnr, fin_netpr_usd, zfrt
*    FROM ZCDS_B1_MM_0001( p_bedat = @<ls_header>-bedat )
*    WHERE bpid = @<ls_header>-bpid
*    INTO TABLE @lt_cds_raw.
*
*  " ## NB ### ### ##### ### ##### ##
*  LOOP AT lt_item INTO DATA(ls_item) WHERE ebeln = <ls_header>-ebeln.
*
*    " ## #### ##### #### CDS ## ##
*    READ TABLE lt_cds_raw INTO DATA(ls_cds) WITH KEY matnr = ls_item-matnr.
*    IF sy-subrc = 0.
*
*      INSERT VALUE #(
*        ebeln  = ls_item-ebeln        " NB ## ##
*        ebelp  = ls_item-ebelp        " NB ## ## (0010, 0020...)
*        matnr  = ls_item-matnr        " ####
*        netusd = ls_cds-fin_netpr_usd " ## ## ##
*        waers  = 'USD'
*      ) INTO TABLE lt_insert.
*
*      IF ls_item-ebelp = '0010' AND <ls_header>-zebelnsv IS NOT INITIAL.
*
*        " SV ### 0020# #### ### ##### ### ##
*        READ TABLE lt_item INTO DATA(ls_sv_item)
*          WITH KEY ebeln = <ls_header>-zebelnsv
*                   ebelp = '0020'.
*
*        IF sy-subrc = 0.
*          INSERT VALUE #(
*            ebeln  = <ls_header>-zebelnsv " # ### SV ## ##
*            ebelp  = '0020'               " # ## ## ## 0020
*            matnr  = ls_sv_item-matnr     " SV 20## ### ## ####
*            netusd = ls_cds-zfrt          " # CDS## ### #####
*            waers  = 'USD'
*          ) INTO TABLE lt_insert.
*        ENDIF.
*
*      ENDIF. " ## B ##
*
*    ENDIF.
*  ENDLOOP. " ### ## ##
*
*ENDLOOP. " ## ## ##
*
*" 4. DB ## # ## ##

*IF lt_insert IS NOT INITIAL.

*  " ## ## ## ## ### ###### #### ## ###
*  INSERT ztb1mm0025 FROM TABLE lt_insert ACCEPTING DUPLICATE KEYS.
*
*  IF sy-subrc = 0.
*    COMMIT WORK.
*
*    " ## ### ##
*    SELECT * FROM ztb1mm0025 INTO TABLE @DATA(lt_0025).
*    cl_demo_output=>display( lt_0025 ).
*  ELSE.
*    ROLLBACK WORK.
*    MESSAGE '### ## # ### ######.' TYPE 'E'.
*  ENDIF.
*ENDIF.


*--------------------------------------------------------------------*
** *& 6.27 ~ ### ## ## ####
*--------------------------------------------------------------------*
*DATA: lt_header  TYPE TABLE OF ztb1mm0006,
*      lt_item    TYPE TABLE OF ztb1mm0007,
*      lt_im_head TYPE TABLE OF ztb1mm0011. " ### ## ### ## ##
*
*SELECT * FROM ztb1mm0006 INTO TABLE @lt_header.
*IF lt_header IS INITIAL. RETURN. ENDIF.
*
*SELECT * FROM ztb1mm0007
*  FOR ALL ENTRIES IN @lt_header
*  WHERE ebeln = @lt_header-ebeln
*  INTO TABLE @lt_item.
*
*" NB ## ### #### ##### #####.
*LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<ls_header>) WHERE bsart = 'NB'.
*
**  " 1# #### ### '10'#(## '0010') ## ### #####.
**  READ TABLE lt_item INTO DATA(ls_item)
**    WITH KEY ebeln = <ls_header>-ebeln
**             ebelp = '0010'.
*
*  " #### ## ## -> ###PO# #####
*  IF <ls_header>-zebelnsv IS INITIAL.
*    CONTINUE.
*  ENDIF.
*
*  READ TABLE lt_item INTO DATA(ls_sv_item)
*    WITH KEY ebeln = <ls_header>-zebelnsv
*             ebelp = '0020'.
*
*  " 1# ## #### #### #### ## ### #####.
*  IF sy-subrc = 0.
*    DATA: lv_mblnr     TYPE ztb1mm0011-mblnr, " ###### ## ##
*          lv_bktxt     TYPE ztb1mm0011-bktxt, " ## ## ### - #####
*          lv_bktxt_act TYPE ztb1mm0011-bktxt, " ##### ###
*          lv_bktxt_los TYPE ztb1mm0011-bktxt, " ##### ###
*          lv_yymmdd    TYPE c LENGTH 6.
*
*    " # ## #### ZNRB1MM03 ## (###### ### ##)
*    CALL FUNCTION 'NUMBER_GET_NEXT'
*      EXPORTING
*        nr_range_nr             = '01'          " ### ##### ## (##### 01)
*        object                  = 'ZNRB1MM03'   " #### #####
*      IMPORTING
*        number                  = lv_mblnr
*      EXCEPTIONS
*        interval_not_found      = 1
*        number_range_not_intern = 2
*        object_not_found        = 3
*        quantity_is_not_1       = 4
*        interval_overflow       = 5
*        buffer_overflow         = 6
*        OTHERS                  = 7.
*
*    IF sy-subrc <> 0.
*      " ## ## # ## ## ## ## ## ## (#### ###)
*      lv_mblnr = '99' && sy-index.
*    ENDIF.
*
*    " # ## # ## ## (#### ## ###PO #### '## ###' ##)
*    "##
**    DATA(lv_doc_date) = ls_item-slfdt. " ## ### (YYYYMMDD)
*    "##
*    DATA(lv_doc_date) = ls_sv_item-slfdt. " ## ### (YYYYMMDD)
*    DATA(lv_gjahr)    = lv_doc_date(4).  " ## ## (YYYY)
*
*    " # ## ## ### ## ##
*    lv_yymmdd = lv_doc_date+2(6). " YYYYMMDD## ## YYMMDD 6## ####
*    "##
**    lv_bktxt = |#### / MS{ lv_yymmdd }01|.
*    "##
*    lv_bktxt_act = |#### / MS{ lv_yymmdd }01|.
*    lv_bktxt_los = |#### / MS{ lv_yymmdd }01|.
*
*    " # ### ## ### #### ##
**    INSERT VALUE #(
**      mandt = sy-mandt
**      mblnr = lv_mblnr          " ### ###### ##
**      mjahr = lv_gjahr          " ####
**      bldat = lv_doc_date       " #### (## ###)
**      budat = lv_doc_date       " #### (## ###)
**      bukrs = '1000'            " #### ####
**      bktxt = lv_bktxt          " ### ## ###
**      ebeln = <ls_header>-ebeln " ###### ##
**      vgart = 'WE'              " #### ####
**    ) INTO TABLE lt_im_head.
*
**    " ##
**    INSERT VALUE #(
**      mandt = sy-mandt
**      mblnr = lv_mblnr          " #### ####
**      mjahr = lv_gjahr
**      bldat = lv_doc_date
**      budat = lv_doc_date
**      bukrs = '1000'
**      bktxt = lv_bktxt_act
**      ebeln = <ls_header>-ebeln
**      vgart = 'WE'
**    ) INTO TABLE lt_im_head.
*
*    " ##
*    INSERT VALUE #(
*      mandt = sy-mandt
*      mblnr = lv_mblnr          " #### ## ####
*      mjahr = lv_gjahr
*      bldat = lv_doc_date
*      budat = lv_doc_date
*      bukrs = '1000'
*      bktxt = lv_bktxt_los      " # #### ###
*      ebeln = <ls_header>-ebeln
*      vgart = 'WE'
*    ) INTO TABLE lt_im_head.
*
*  ENDIF.
*  ENDLOOP.
*
*  IF lt_im_head IS NOT INITIAL.
*    CALL FUNCTION 'ZFB1CM0001'
*      CHANGING
*        ct_table = lt_im_head.
*
*    " ## ### ##### ### #### #### ## ## # ###
**    DELETE FROM ztb1mm0011.
*
*    INSERT ztb1mm0011 FROM TABLE lt_im_head ACCEPTING DUPLICATE KEYS.
*
*    IF sy-subrc = 0.
*      COMMIT WORK.
*
*      " ## ## ## ### ## ## # ##
*      SELECT * FROM ztb1mm0011 INTO TABLE @DATA(lt_display).
*        cl_demo_output=>display( lt_display ).
*      ELSE.
*        ROLLBACK WORK.
*        MESSAGE '### ## ## # DB ### ######.' TYPE 'E'.
*      ENDIF.
*    ENDIF.

*--------------------------------------------------------------------*
*& ### ### ## ## #### #### (WE ## ##)
*--------------------------------------------------------------------*

*DATA: lt_im_head   TYPE TABLE OF ztb1mm0011, " ### ##
*      lt_im_item   TYPE TABLE OF ztb1mm0012, " ### ### (#### ##)
*      lt_price_tab TYPE TABLE OF ztb1mm0025. " ## ## ###
*
*" ## ## ### ##
*TYPES: BEGIN OF ty_error_log,
*         mblnr TYPE ztb1mm0011-mblnr, " ### ##
*         bldat TYPE ztb1mm0011-bldat, " ### ## ##
*         ebeln TYPE ztb1mm0012-ebeln, " #### ##
*         ebelp TYPE ztb1mm0012-ebelp, " #### ##
*       END OF ty_error_log.
*DATA: lt_error_log TYPE STANDARD TABLE OF ty_error_log.
*
*FIELD-SYMBOLS: <ls_im_item> TYPE ztb1mm0012.
*
*" 1. ### ## ## ## ## ## (VGART = 'WE')
*" # ## ### ### VGART ### ### ## ### ## ### #### ## #####.
*SELECT * FROM ztb1mm0011
*  INTO TABLE @lt_im_head
*  WHERE vgart = 'WE'.
** WHERE bktxt LIKE '####%' OR bktxt LIKE '####%' OR bktxt LIKE '####%'.
*
*IF lt_im_head IS INITIAL. RETURN. ENDIF.
*
*" 2. ## #### ## ### ###(## #### ##) ## ##
*SELECT * FROM ztb1mm0012
*  FOR ALL ENTRIES IN @lt_im_head
*  WHERE mblnr = @lt_im_head-mblnr
*    AND mjahr = @lt_im_head-mjahr
*  INTO TABLE @lt_im_item.
*
*IF lt_im_item IS INITIAL. RETURN. ENDIF.
*
*" 3. ## ## ##(ZTB1MM0025) ## ##
*SELECT * FROM ztb1mm0025
*  FOR ALL ENTRIES IN @lt_im_item
*  WHERE ebeln = @lt_im_item-ebeln
*  INTO TABLE @lt_price_tab.
*
*
*" 4. ### ### #### ### ## ## ## ##
*LOOP AT lt_im_item ASSIGNING <ls_im_item>.
*
*  DATA: lv_netusd    TYPE p LENGTH 13 DECIMALS 5, " ####
*        lv_ukurs     TYPE p LENGTH 9 DECIMALS 5,  " ##
*        lv_netpr     TYPE p LENGTH 13,            " ####
*        lv_wrbtr     TYPE p LENGTH 13 DECIMALS 2, " #####
*        lv_dmbtr     TYPE p LENGTH 13,            " #####
*        lv_sap_netpr TYPE ztb1mm0012-netpr,
*        lv_sap_dmbtr TYPE ztb1mm0012-dmbtr,
*        ls_head      LIKE LINE OF lt_im_head.
*
*  CLEAR: lv_netusd, lv_ukurs, lv_netpr, lv_wrbtr, lv_dmbtr,
*         lv_sap_netpr, lv_sap_dmbtr, ls_head.
*
*  " #### ####(BLDAT) ####
*  READ TABLE lt_im_head INTO ls_head WITH KEY mblnr = <ls_im_item>-mblnr
*                                               mjahr = <ls_im_item>-mjahr.
*
*  " # ## ## ## (MM0025## #### + #### ##)
*  READ TABLE lt_price_tab INTO DATA(ls_price)
*    WITH KEY ebeln = <ls_im_item>-ebeln
*             ebelp = <ls_im_item>-ebelp.
*  IF sy-subrc = 0.
*    lv_netusd = ls_price-netusd.
*  ENDIF.
*
*  " # ### ## ## (FI0007## ### '####' ## ##)
*  SELECT SINGLE ukurs
*    FROM ztb1fi0007
*    INTO @lv_ukurs
*    WHERE gdatu = @ls_head-bldat.
*
*  " ## ### ### ## ## ## # ##
*  IF sy-subrc <> 0 OR lv_ukurs IS INITIAL.
*    INSERT VALUE #(
*      mblnr = <ls_im_item>-mblnr
*      bldat = ls_head-bldat
*      ebeln = <ls_im_item>-ebeln
*      ebelp = <ls_im_item>-ebelp
*    ) INTO TABLE lt_error_log.
*    CONTINUE.
*  ENDIF.
*
*  " # ## ## # ## #### ## (#### ## ### ##(MENGE) ##)
*  " ## ## = #### * ##
*  lv_netpr = round( val = ( lv_netusd * lv_ukurs ) dec = 0 ).
*
*  " ## ### = #### * ### ### ##
*  lv_wrbtr = lv_netusd * <ls_im_item>-menge.
*
*  " ## ### = #### * ### ### ##
*  lv_dmbtr = lv_netpr * <ls_im_item>-menge.
*
*  " SAP ## ## ## ## (KRW)
*  CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
*    EXPORTING
*      currency    = 'KRW'
*      idoc_amount = lv_netpr
*    IMPORTING
*      sap_amount  = lv_sap_netpr
*    EXCEPTIONS
*      OTHERS      = 1.
*
*  CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
*    EXPORTING
*      currency    = 'KRW'
*      idoc_amount = lv_dmbtr
*    IMPORTING
*      sap_amount  = lv_sap_dmbtr
*    EXCEPTIONS
*      OTHERS      = 1.
*
*  " # ## #### ## ### # ##
*  <ls_im_item>-netpr  = lv_sap_netpr.  " ## ##
*  <ls_im_item>-dmbtr  = lv_sap_dmbtr.  " ## ###
*  <ls_im_item>-waersk = 'KRW'.
*  <ls_im_item>-wrbtr  = lv_wrbtr.      " ## ### (USD)
*  <ls_im_item>-waers  = 'USD'.
*
*ENDLOOP.
*
*" 5. DB ## ## (MODIFY ## ##)
*IF lt_error_log IS NOT INITIAL.
*  MESSAGE '## ### ## ### #### #######.' TYPE 'W'.
*  cl_demo_output=>display( lt_error_log ).
*ENDIF.
*
*IF lt_im_item IS NOT INITIAL.
*  " C-Nergy ## ## (## # ##)
*  CALL FUNCTION 'ZFB1CM0001'
*    CHANGING
*      ct_table = lt_im_item.
*
*  " ### ##### #### #### ## (MODIFY #### ## ### ####)
*  MODIFY ztb1mm0012 FROM TABLE lt_im_item.
*
*  IF sy-subrc = 0.
*    COMMIT WORK.
*    MESSAGE '### ### ### ##### #######.' TYPE 'S'.
*    cl_demo_output=>display( lt_im_item ).
*  ELSE.
*    ROLLBACK WORK.
*    MESSAGE 'DB ## # ### ######.' TYPE 'E'.
*  ENDIF.
*ENDIF.

*--------------------------------------------------------------------*
** *& 6.27 ~ ### ### ## ####
*--------------------------------------------------------------------*

*DATA: lt_im_head   TYPE TABLE OF ztb1mm0011, " ### ##
*      lt_po_item   TYPE TABLE OF ztb1mm0007, " #### ###
*      lt_price_tab TYPE TABLE OF ztb1mm0025, " ## ## ###
*      lt_im_item   TYPE TABLE OF ztb1mm0012. " # ## ### ### ###
*
*FIELD-SYMBOLS: <ls_im_head> TYPE ztb1mm0011.
*
*" ## ### ### ## SAP ## ### ##
*DATA: lo_rand TYPE REF TO cl_abap_random_int.
*
*" A) ##### #### ### ### ## SELECT
*SELECT * FROM ztb1mm0011
*  INTO TABLE @lt_im_head
*  WHERE bktxt LIKE '####%'.
**  WHERE bktxt LIKE '####%'.
**  WHERE bktxt LIKE '####%'.
*
*IF lt_im_head IS INITIAL. RETURN. ENDIF.
*
*" B) #### ### #### ### ### ## ##
*SELECT * FROM ztb1mm0007
*  FOR ALL ENTRIES IN @lt_im_head
*  WHERE ebeln = @lt_im_head-ebeln
*  INTO TABLE @lt_po_item.
*
*" C) ### ### ### ## ## ##(ZTB1MM0025) ## ##
*SELECT * FROM ztb1mm0025
*  FOR ALL ENTRIES IN @lt_im_head
*  WHERE ebeln = @lt_im_head-ebeln
*  INTO TABLE @lt_price_tab.
*
*
*TYPES: BEGIN OF ty_error_log,
*         mblnr TYPE ztb1mm0011-mblnr, " ### ##
*         ebeln TYPE ztb1mm0007-ebeln, " #### ##
*         ebelp TYPE ztb1mm0007-ebelp, " #### ##
*         bldat TYPE ztb1mm0011-bldat, " ### ## ##
*       END OF ty_error_log.
*DATA: lt_error_log TYPE STANDARD TABLE OF ty_error_log.
*
*"## ###
*" ## ## ## (### ## ##, 1## 5## ### ## => 0.1% ~ 0.5% ##)
*lo_rand = cl_abap_random_int=>create( seed = cl_abap_random=>seed( )
*                                      min  = 1
*                                      max  = 5 ).
*
*LOOP AT lt_im_head ASSIGNING <ls_im_head>.
*
*  " ## ### ### ##### ### PO ##### #####.
*  LOOP AT lt_po_item INTO DATA(ls_po_item) WHERE ebeln = <ls_im_head>-ebeln.
*
*    DATA: lv_netusd   TYPE p LENGTH 13 DECIMALS 5, " ####
*          lv_ukurs    TYPE p LENGTH 9 DECIMALS 5,  " ##
*          lv_netpr    TYPE p LENGTH 13,            " #### (##)
*          lv_wrbtr    TYPE p LENGTH 13 DECIMALS 2, " #####
*          lv_dmbtr    TYPE p LENGTH 13,            " #####
*          lv_ship_qty TYPE p LENGTH 13 DECIMALS 2, " ## ## ##
*          lv_act_qty  TYPE p LENGTH 13 DECIMALS 2, " ### ## ##
*          lv_loss_qty TYPE p LENGTH 13 DECIMALS 2, " ### ###
*          lv_rand_val TYPE i.
*
*    CLEAR: lv_netusd, lv_ukurs, lv_netpr, lv_wrbtr, lv_dmbtr,
*            lv_ship_qty, lv_act_qty, lv_loss_qty, lv_rand_val.
*
*    "## ###
**    lv_ship_qty = ls_po_item-menge. " ## #### ### ## ####
**
**    IF ls_po_item-meins = 'KG' OR ls_po_item-matnr = 'ZEOL' OR ls_po_item-matnr = 'NIMO'.
**      " KG ### ## ## ##
**      lv_loss_qty = 0.
**      lv_act_qty  = lv_ship_qty.
**    ELSE.
**      " BBL ## ### 0.1% ~ 0.5% ## ## ## ## ##
**      lv_rand_val = lo_rand->get_next( ). " 1 ~ 5 ### ## ##
**      lv_loss_qty = lv_ship_qty * ( lv_rand_val / 1000 ).
**      lv_act_qty  = lv_ship_qty - lv_loss_qty.
**    ENDIF.
*    "####.
*
*    " # ## ## ## (ZTB1MM0025## #### + #### ##)
*    READ TABLE lt_price_tab INTO DATA(ls_price)
*      WITH KEY ebeln = ls_po_item-ebeln
*               ebelp = ls_po_item-ebelp.
*    IF sy-subrc = 0.
*      lv_netusd = ls_price-netusd.
*    ENDIF.
*
*    " # ### ## ## (ZTB1FI0007## ### '####' ## ##)
*    " GDATU ### 99991231-## ### ## ### ### ### #### ##### ## ## ##
*    SELECT SINGLE ukurs
*      FROM ztb1fi0007
*      INTO @lv_ukurs
*      WHERE gdatu = @<ls_im_head>-bldat. " ### #### ##
*
*    IF sy-subrc <> 0 OR lv_ukurs IS INITIAL.
*      INSERT VALUE #(
*        mblnr = <ls_im_head>-mblnr
*        ebeln = ls_po_item-ebeln " ## ### #### ## ##
*        ebelp = ls_po_item-ebelp " ## ### #### ## ##
*        bldat = <ls_im_head>-bldat
*      ) INTO TABLE lt_error_log.
*
*      CONTINUE. " ## #### #### ## ### ### ###
*    ENDIF.
*
*    " # ## ## #### # ## ## ##
*    " ## ### = #### * ##
*    "##
*    lv_wrbtr = lv_netusd * ls_po_item-menge.
*    "##
**    lv_wrbtr = lv_netusd * lv_act_qty.
**    lv_netpr = round( val = ( lv_netusd * lv_ukurs ) dec = 0 ).
**    lv_dmbtr = lv_netpr * lv_act_qty.
*
*    DATA: lv_sap_netpr TYPE ztb1mm0012-netpr,
*          lv_sap_dmbtr TYPE ztb1mm0012-dmbtr.
*
*    CLEAR: lv_sap_netpr, lv_sap_dmbtr.
*
*    " ## ## = #### * ## (##### ### #### #### ### ##)
*    lv_netpr = round( val = ( lv_netusd * lv_ukurs ) dec = 0 ). " ##
*
*    CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
*      EXPORTING
*        currency    = 'KRW'          " ### ## # (##)
*        idoc_amount = lv_netpr       " ### ### ## ## ##
*      IMPORTING
*        sap_amount  = lv_sap_netpr   " DB ### ## ## ##
*      EXCEPTIONS
*        OTHERS      = 1.
*
*    " ## ### = #### * ##
*    lv_dmbtr = lv_netpr * ls_po_item-menge. "##
*
*    CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
*      EXPORTING
*        currency    = 'KRW'
*        idoc_amount = lv_dmbtr
*      IMPORTING
*        sap_amount  = lv_sap_dmbtr   " DB ### ## ## ##
*      EXCEPTIONS
*        OTHERS      = 1.
*
*    " # ### ### ## (### lv_sap_netpr, lv_sap_dmbtr# ##!)
*    "##
*    INSERT VALUE #(
*      mandt  = sy-mandt
*      mblnr  = <ls_im_head>-mblnr
*      mjahr  = <ls_im_head>-mjahr
*      zeile  = ls_po_item-ebelp
*      matnr  = ls_po_item-matnr
*      werks  = ls_po_item-werks
*      lgort  = ls_po_item-lgort
**      bwart  = '101'
*      bwart  = '321'
**      bwart  = '551'
**      menge  = ls_po_item-menge
*      menge  = lv_act_qty " ####
*      meins  = ls_po_item-meins
*      netpr  = lv_sap_netpr
*      dmbtr  = lv_sap_dmbtr
*      waersk = 'KRW'
*      wrbtr  = lv_wrbtr            " USD# ### 2## ## ##### ## ## ### ##
*      waers  = 'USD'
*      insmk  = 'T'
*      ebeln  = ls_po_item-ebeln
*      ebelp  = ls_po_item-ebelp
*    ) INTO TABLE lt_im_item.
*
**    INSERT VALUE #(
**          mandt  = sy-mandt
**          mblnr  = <ls_im_head>-mblnr
**          mjahr  = <ls_im_head>-mjahr
**          zeile  = ls_po_item-ebelp
**          matnr  = ls_po_item-matnr
**          werks  = ls_po_item-werks
**          lgort  = ls_po_item-lgort
**          bwart  = '321'               " ####: ##### 321 ####
**          menge  = lv_act_qty          " # ### ## ## ##
**          meins  = ls_po_item-meins
**          netpr  = lv_sap_netpr
**          dmbtr  = lv_sap_dmbtr
**          waersk = 'KRW'
**          wrbtr  = lv_wrbtr
**          waers  = 'USD'
**          insmk  = 'A'                 " ####: ### ## S## 'A' ## ##(### 'S'# ##)
**          zloss  = lv_loss_qty         " # ### ## (## ## + ### = ## ## ##)
**          ebeln  = ls_po_item-ebeln
**          ebelp  = ls_po_item-ebelp
**          " KOKRS, KOSTL # ##### ### ##### #### ## ##
**        ) INTO TABLE lt_im_item.
*
*  ENDLOOP.
*ENDLOOP.
*
*IF lt_error_log IS NOT INITIAL.
*  " ### ### ### ## ## ## ## ### ## #####.
*  MESSAGE '## ### ## ### #### #######. ### #####.' TYPE 'W'.
*  cl_demo_output=>next_section( '## ## ## ## (#### ##)' ).
*  cl_demo_output=>write( lt_error_log ).
*
*ELSEIF lt_im_item IS NOT INITIAL.
*  CALL FUNCTION 'ZFB1CM0001'
*    CHANGING
*      ct_table = lt_im_item.
*
*  DELETE FROM ztb1mm0012 where mblnr BETWEEN '5000000001' AND '5000000026'.
*
*  INSERT ztb1mm0012 FROM TABLE lt_im_item ACCEPTING DUPLICATE KEYS.
*
*  IF sy-subrc = 0.
*    COMMIT WORK.
*
*    " ## ### ### ## ## ### ### ## ## ###
*    SELECT * FROM ztb1mm0012 INTO TABLE @DATA(lt_display)
*      where mblnr BETWEEN '5000000001' AND '5000000050'.
*    cl_demo_output=>display( lt_display ).
*  ELSE.
*    ROLLBACK WORK.
*    MESSAGE '### #### ### ## # DB ### ######.' TYPE 'E'.
*  ENDIF.
*ENDIF.

*--------------------------------------------------------------------*
*& 6.27 ~ ### ### ####(551) ## ####
*--------------------------------------------------------------------*

*DATA: lt_im_head    TYPE TABLE OF ztb1mm0011, " ### ## (#####)
*      lt_act_item   TYPE TABLE OF ztb1mm0012, " #### ####(321) ####
*      lt_price_tab  TYPE TABLE OF ztb1mm0025, " ## ## ###
*      lt_im_item    TYPE TABLE OF ztb1mm0012. " ## ### #### ### ###
*
*" A) '####'# #### ### ### ## SELECT
*SELECT * FROM ztb1mm0011
*  INTO TABLE @lt_im_head
*  WHERE bktxt LIKE '####%'.
*
*IF lt_im_head IS INITIAL. RETURN. ENDIF.
*
*" B) ##### ### [####] ### #### DB## ## ## (### ###)
*" ###### = ###### + 1 ###, ### MBLNR - 1 # ## ####### ###.
*SELECT * FROM ztb1mm0012
*  INTO TABLE @lt_act_item
*  WHERE bwart = '321'.
*
*" C) ### ### ### ## ## ## ## ##
*SELECT * FROM ztb1mm0025
*  FOR ALL ENTRIES IN @lt_im_head
*  WHERE ebeln = @lt_im_head-ebeln
*  INTO TABLE @lt_price_tab.
*
*" ## ## ## ##
*TYPES: BEGIN OF ty_error_log,
*         mblnr TYPE ztb1mm0011-mblnr,
*         ebeln TYPE ztb1mm0007-ebeln,
*         ebelp TYPE ztb1mm0007-ebelp,
*         bldat TYPE ztb1mm0011-bldat,
*       END OF ty_error_log.
*DATA: lt_error_log TYPE STANDARD TABLE OF ty_error_log.
*
*LOOP AT lt_im_head ASSIGNING FIELD-SYMBOL(<ls_im_head>).
*
*  " ## #### ## ## ## (## #### ## - 1)
*  DATA: lv_target_act_mblnr TYPE ztb1mm0011-mblnr.
*  lv_target_act_mblnr = <ls_im_head>-mblnr - 1.
*
*  " ## ##### ### ##### # ## ###.
*  LOOP AT lt_act_item INTO DATA(ls_act_item) WHERE mblnr = lv_target_act_mblnr.
*
*    " # [## #] #### 0### ## ##(ZEOL, NIMO #)# #### ### ## ## ##!
*    IF ls_act_item-zloss IS INITIAL OR ls_act_item-zloss = 0.
*      CONTINUE.
*    ENDIF.
*
*    DATA: lv_netusd    TYPE p LENGTH 13 DECIMALS 5, " ####
*          lv_ukurs     TYPE p LENGTH 9 DECIMALS 5,  " ##
*          lv_netpr     TYPE p LENGTH 13,            " ####
*          lv_wrbtr     TYPE p LENGTH 13 DECIMALS 2, " #####
*          lv_dmbtr     TYPE p LENGTH 13,            " #####
*          lv_loss_qty  TYPE p LENGTH 13 DECIMALS 2. " #### ## (### zloss)
*
*    CLEAR: lv_netusd, lv_ukurs, lv_netpr, lv_wrbtr, lv_dmbtr, lv_loss_qty.
*
*    " 1. #### ### '###(zloss)'# -> #### ### '##(menge)'# #
*    lv_loss_qty = ls_act_item-zloss.
*
*    " 2. ## ## ##
*    READ TABLE lt_price_tab INTO DATA(ls_price)
*      WITH KEY ebeln = ls_act_item-ebeln
*               ebelp = ls_act_item-ebelp.
*    IF sy-subrc = 0.
*      lv_netusd = ls_price-netusd.
*    ENDIF.
*
*    " 3. ### ## ## (#### ### #### ##)
*    SELECT SINGLE ukurs
*      FROM ztb1fi0007
*      INTO @lv_ukurs
*      WHERE gdatu = @<ls_im_head>-bldat.
*
*    IF sy-subrc <> 0 OR lv_ukurs IS INITIAL.
*      INSERT VALUE #(
*        mblnr = <ls_im_head>-mblnr
*        ebeln = ls_act_item-ebeln
*        ebelp = ls_act_item-ebelp
*        bldat = <ls_im_head>-bldat
*      ) INTO TABLE lt_error_log.
*      CONTINUE.
*    ENDIF.
*
*    " 4. [## ##] ## ##(lv_loss_qty) ## ## ###
*    lv_wrbtr = lv_netusd * lv_loss_qty.
*    lv_netpr = ROUND( val = ( lv_netusd * lv_ukurs ) dec = 0 ).
*    lv_dmbtr = lv_netpr * lv_loss_qty.
*
*    " 5. KRW 100# #### ### IDOC ## ##
*    DATA: lv_sap_netpr TYPE ztb1mm0012-netpr,
*          lv_sap_dmbtr TYPE ztb1mm0012-dmbtr.
*
*    CLEAR: lv_sap_netpr, lv_sap_dmbtr.
*
*    CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
*      EXPORTING
*        currency    = 'KRW'
*        idoc_amount = lv_netpr
*      IMPORTING
*        sap_amount  = lv_sap_netpr
*      EXCEPTIONS
*        OTHERS      = 1.
*
*    CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
*      EXPORTING
*        currency    = 'KRW'
*        idoc_amount = lv_dmbtr
*      IMPORTING
*        sap_amount  = lv_sap_dmbtr
*      EXCEPTIONS
*        OTHERS      = 1.
*
*    " 6. #### ### ### ##
*    INSERT VALUE #(
*      mandt  = sy-mandt
*      mblnr  = <ls_im_head>-mblnr       " #### #### (#### + 1)
*      mjahr  = <ls_im_head>-mjahr
*      zeile  = ls_act_item-zeile        " #### ##
*      matnr  = ls_act_item-matnr
*      werks  = ls_act_item-werks
*      lgort  = ls_act_item-lgort
*      bwart  = '551'                    " ####: ##### 551 ####
*      menge  = lv_loss_qty              " # ##### #### #### ###
*      meins  = ls_act_item-meins
*      netpr  = lv_sap_netpr
*      dmbtr  = lv_sap_dmbtr
*      waersk = 'KRW'
*      wrbtr  = lv_wrbtr
*      waers  = 'USD'
*      insmk  = ''                       " ####: ##
*      zloss  = 0                        " ###: ##(0)
*      kokrs  = 'A100'                   " # ###### ####
*      kostl  = 'TRANSPORT_LOSS_COST'   " # ##### ####
*      ebeln  = ls_act_item-ebeln
*      ebelp  = ls_act_item-ebelp
*    ) INTO TABLE lt_im_item.
*
*  ENDLOOP.
*ENDLOOP.
*
*IF lt_error_log IS NOT INITIAL.
*  MESSAGE '## ### ## ### #### #######. ### #####.' TYPE 'W'.
*  cl_demo_output=>next_section( '## ## ## ## (#### ##)' ).
*  cl_demo_output=>write( lt_error_log ).
*
*ELSEIF lt_im_item IS NOT INITIAL.
*
*  CALL FUNCTION 'ZFB1CM0001'
*    CHANGING
*      ct_table = lt_im_item.
*
*  " ### ### 551 #### #### ### ### (## ## ##)
*  DELETE FROM ztb1mm0012 WHERE bwart = '551'.
*
*  INSERT ztb1mm0012 FROM TABLE lt_im_item ACCEPTING DUPLICATE KEYS.
*
*  IF sy-subrc = 0.
*    COMMIT WORK.
*    SELECT * FROM ztb1mm0012 WHERE bwart = '551' INTO TABLE @DATA(lt_display).
*    cl_demo_output=>display( lt_display ).
*  ELSE.
*    ROLLBACK WORK.
*    MESSAGE '### #### ### ## # DB ### ######.' TYPE 'E'.
*  ENDIF.
*ENDIF.

**--------------------------------------------------------------------*
**& ### ## ##(### ##) ## #### ####
**--------------------------------------------------------------------*
*
*DATA: lt_inv_head  TYPE TABLE OF ztb1mm0013, " ## ## ###
*      lt_po_head   TYPE TABLE OF ztb1mm0006, " #### ##
*      lt_po_item   TYPE TABLE OF ztb1mm0007, " #### ###
*      lt_price_tab TYPE TABLE OF ztb1mm0025, " ## ## ###
*      lt_inv_upd   TYPE TABLE OF ztb1mm0013. " ##### ###
*
*" A) ## ## # '### ##'# ## ### ## ##
*SELECT * FROM ztb1mm0013
*  INTO TABLE @lt_inv_head
*  WHERE bktxt LIKE '### ##%'.
*
*IF lt_inv_head IS INITIAL. RETURN. ENDIF.
*
*" B) ## ### ### #### ## ## (BP## ## ##)
*SELECT * FROM ztb1mm0006
*  FOR ALL ENTRIES IN @lt_inv_head
*  WHERE ebeln = @lt_inv_head-ebeln
*  INTO TABLE @lt_po_head.
*
*" C) ## ### ### #### ### ## (#### 20# ## ##)
*SELECT * FROM ztb1mm0007
*  FOR ALL ENTRIES IN @lt_inv_head
*  WHERE ebeln = @lt_inv_head-ebeln
*  INTO TABLE @lt_po_item.
*
*" D) ## ## ## ##
*SELECT * FROM ztb1mm0025
*  FOR ALL ENTRIES IN @lt_inv_head
*  WHERE ebeln = @lt_inv_head-ebeln
*  INTO TABLE @lt_price_tab.
*
*
*" ----------------------------------------------------------------------
*" ## ### ## # ## ## ##
*" ----------------------------------------------------------------------
*LOOP AT lt_inv_head ASSIGNING FIELD-SYMBOL(<ls_inv>).
*
*  DATA: lv_ukurs      TYPE p LENGTH 9 DECIMALS 5,   " ##
*        lv_total_wrbtr TYPE p LENGTH 13 DECIMALS 2, " # #### ##
*        lv_total_dmbtr TYPE p LENGTH 13,            " # #### ##
*        lv_bpid      TYPE ztb1mm0006-bpid.        " BP ##
*
*  CLEAR: lv_ukurs, lv_total_wrbtr, lv_total_dmbtr, lv_bpid.
*
*  " # #### #### BP##(bpid) ##
*  READ TABLE lt_po_head INTO DATA(ls_po_head) WITH KEY ebeln = <ls_inv>-ebeln.
*  IF sy-subrc = 0.
*    lv_bpid = ls_po_head-bpid.
*  ENDIF.
*
*  " # ## ### ####(BLDAT) #### ### ## ##
*  SELECT SINGLE ukurs
*    FROM ztb1fi0007
*    INTO @lv_ukurs
*    WHERE gdatu = @<ls_inv>-bldat.
*
*  " ## ### ##### ## ## #### ## ## ##(0# # ##)
*  IF sy-subrc <> 0 OR lv_ukurs IS INITIAL.
*    " ## # ## ### ## ## ## ##
*    CONTINUE.
*  ENDIF.
*
*  " # #### #### ## ## #### # ## ## ## (##### #### 20# ##)
*  LOOP AT lt_po_item INTO DATA(ls_po_item) WHERE ebeln = <ls_inv>-ebeln.
*
*    DATA: lv_netusd TYPE p LENGTH 13 DECIMALS 5,
*          lv_wrbtr  TYPE p LENGTH 13 DECIMALS 2,
*          lv_dmbtr  TYPE p LENGTH 13.
*
*    CLEAR: lv_netusd, lv_wrbtr, lv_dmbtr.
*
*    " ## ## ## (ZTB1MM0025)
*    READ TABLE lt_price_tab INTO DATA(ls_price)
*      WITH KEY ebeln = ls_po_item-ebeln
*               ebelp = ls_po_item-ebelp.
*    IF sy-subrc = 0.
*      lv_netusd = ls_price-netusd.
*    ENDIF.
*
*    " ### ## ### = ## * ####
*    lv_wrbtr = ls_po_item-menge * lv_netusd.
*    " ### ## ### = ## * #### * #### ## (##### ###)
*    lv_dmbtr = ROUND( val = ( ls_po_item-menge * lv_netusd * lv_ukurs ) dec = 0 ).
*
*    " ## #### ## ### ## ## ##
*    lv_total_wrbtr = lv_total_wrbtr + lv_wrbtr.
*    lv_total_dmbtr = lv_total_dmbtr + lv_dmbtr.
*
*  ENDLOOP.
*
*  " # KRW ## 100# #### ## ## ## (DMBTR ##)
*  DATA: lv_sap_dmbtr TYPE ztb1mm0013-dmbtr.
*  CLEAR: lv_sap_dmbtr.
*
*  CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
*    EXPORTING
*      currency    = 'KRW'
*      idoc_amount = lv_total_dmbtr
*    IMPORTING
*      sap_amount  = lv_sap_dmbtr
*    EXCEPTIONS
*      OTHERS      = 1.
*
*  " # ## ### ## ### # #### ## ##
*  <ls_inv>-bpid  = lv_bpid.      " BP## ####
*  <ls_inv>-wrbtr  = lv_total_wrbtr. " # ###(##) - ##
*  <ls_inv>-waers  = 'USD'.
*  <ls_inv>-dmbtr  = lv_sap_dmbtr.  " # ### - ## (IDOC ### ##)
*  <ls_inv>-waersk = 'KRW'.
*
*  APPEND <ls_inv> TO lt_inv_upd.
*
*ENDLOOP.
*
*" ----------------------------------------------------------------------
*" DB ## # ## ## ##
*" ----------------------------------------------------------------------
*IF lt_inv_upd IS NOT INITIAL.
*  " ### #### ## ## ### ##(####) ##
*  MODIFY ztb1mm0013 FROM TABLE lt_inv_upd.
*
*  IF sy-subrc = 0.
*    COMMIT WORK.
*    " #### ### ### ## ### ## ## ###
*    cl_demo_output=>display( lt_inv_upd ).
*  ELSE.
*    ROLLBACK WORK.
*    MESSAGE '## ##(### ##) ### #### # DB ### ######.' TYPE 'E'.
*  ENDIF.
*ENDIF.

*--------------------------------------------------------------------*
*& ### ## ##(## ## / ### # ##) ## Direct UPDATE ####
*--------------------------------------------------------------------*

*DATA: lt_inv_head  TYPE TABLE OF ztb1mm0013,
*      lt_po_head   TYPE TABLE OF ztb1mm0006,
*      lt_po_item   TYPE TABLE OF ztb1mm0007,
*      lt_price_tab TYPE TABLE OF ztb1mm0025.
*
*" 1. ## ##(1) ## ###/##(3)# #### ## ## # ## ### ##
*SELECT * FROM ztb1mm0013
*  INTO TABLE @lt_inv_head
*  WHERE bktxt LIKE '## ##%'
*     OR bktxt LIKE '###/##%'.
*
*IF lt_inv_head IS INITIAL. RETURN. ENDIF.
*
*SELECT * FROM ztb1mm0006 FOR ALL ENTRIES IN @lt_inv_head WHERE ebeln = @lt_inv_head-ebeln INTO TABLE @lt_po_head.
*SELECT * FROM ztb1mm0007 FOR ALL ENTRIES IN @lt_inv_head WHERE ebeln = @lt_inv_head-ebeln INTO TABLE @lt_po_item.
*SELECT * FROM ztb1mm0025 FOR ALL ENTRIES IN @lt_inv_head WHERE ebeln = @lt_inv_head-ebeln INTO TABLE @lt_price_tab.
*
*
*" 2. ## ## ## # ### ## UPDATE SET ##
*LOOP AT lt_inv_head ASSIGNING FIELD-SYMBOL(<ls_inv>).
*
*  DATA: lv_ukurs       TYPE p LENGTH 9 DECIMALS 5,
*        lv_total_wrbtr TYPE p LENGTH 13 DECIMALS 2,
*        lv_total_dmbtr TYPE p LENGTH 13,
*        lv_bpid        TYPE ztb1mm0013-bpid.
*
*  CLEAR: lv_ukurs, lv_total_wrbtr, lv_total_dmbtr, lv_bpid.
*
*  " # #### #### BP## ####
*  READ TABLE lt_po_head INTO DATA(ls_po_head) WITH KEY ebeln = <ls_inv>-ebeln.
*  IF sy-subrc = 0.
*    lv_bpid = ls_po_head-bpid.
*  ENDIF.
*
*  " # #### ## ## ##
*  SELECT SINGLE ukurs FROM ztb1fi0007 INTO @lv_ukurs WHERE gdatu = @<ls_inv>-bldat.
*  IF sy-subrc <> 0 OR lv_ukurs IS INITIAL.
*    CONTINUE.
*  ENDIF.
*
*  " # #### ## ## ## (## ### #### #### ##)
*  LOOP AT lt_po_item INTO DATA(ls_po_item) WHERE ebeln = <ls_inv>-ebeln.
*    DATA: lv_netusd TYPE p LENGTH 13 DECIMALS 5,
*          lv_wrbtr  TYPE p LENGTH 13 DECIMALS 2,
*          lv_dmbtr  TYPE p LENGTH 13.
*
*    CLEAR: lv_netusd, lv_wrbtr, lv_dmbtr.
*
*    " ###### + ###### ## #### ### ## ##
*    READ TABLE lt_price_tab INTO DATA(ls_price)
*      WITH KEY ebeln = ls_po_item-ebeln
*               ebelp = ls_po_item-ebelp.
*    IF sy-subrc = 0.
*      lv_netusd = ls_price-netusd.
*    ENDIF.
*
*    " ### ### ##
*    lv_wrbtr = ls_po_item-menge * lv_netusd.
*    lv_dmbtr = ROUND( val = ( ls_po_item-menge * lv_netusd * lv_ukurs ) dec = 0 ).
*
*    " ## ## #### ### ## ## # ####
*    lv_total_wrbtr = lv_total_wrbtr + lv_wrbtr.
*    lv_total_dmbtr = lv_total_dmbtr + lv_dmbtr.
*  ENDLOOP.
*
*  " # [## ## ##] BPTYP # ## (3# ###/### ## 10% ##)
*  IF <ls_inv>-bptyp = '3'.
*    lv_total_wrbtr = lv_total_wrbtr * '0.1'.
*    lv_total_dmbtr = ROUND( val = ( lv_total_dmbtr * '0.1' ) dec = 0 ).
*  ENDIF.
*
*  " # ## 100# ## ## ## #### ##
*  DATA: lv_sap_dmbtr TYPE ztb1mm0013-dmbtr.
*  CLEAR: lv_sap_dmbtr.
*
*  CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
*    EXPORTING
*      currency    = 'KRW'
*      idoc_amount = lv_total_dmbtr
*    IMPORTING
*      sap_amount  = lv_sap_dmbtr
*    EXCEPTIONS
*      OTHERS      = 1.
*
*  " # UPDATE SET #### ## ## ## ##
*  UPDATE ztb1mm0013
*     SET bpid   = @lv_bpid,
*         wrbtr  = @lv_total_wrbtr,
*         waers  = 'USD',
*         dmbtr  = @lv_sap_dmbtr,
*         waersk = 'KRW'
*   WHERE belnr  = @<ls_inv>-belnr
*     AND GJAHR  = @<ls_inv>-GJAHR.
*
*ENDLOOP.
*
*" 3. DB ### ##
*COMMIT WORK.
*MESSAGE '## ##(## ## # ###/##) ### ## #### #####.' TYPE 'S'.

*--------------------------------------------------------------------*
*& ## ### ## # ##/## ## ####
*--------------------------------------------------------------------*

*" 1. ### ### # ### ##
*DATA: lt_inv_head   TYPE TABLE OF ztb1mm0013, " ## ## (## ### ### ##)
*      lt_po_item    TYPE TABLE OF ztb1mm0007, " #### ### ### (#### ##)
*      lt_price_0025 TYPE TABLE OF ztb1mm0025, " #### ###
*      lt_exch_0007  TYPE TABLE OF ztb1fi0007, " FI ## ### (#### ##)
*      lt_inv_item   TYPE TABLE OF ztb1mm0014, " ## ### ## ### ###
*      ls_inv_item   TYPE ztb1mm0014.
*
*FIELD-SYMBOLS: <ls_head> TYPE ztb1mm0013. " ## ## ### ##
*
*SELECT * FROM ztb1mm0013
*  INTO TABLE @lt_inv_head
*  WHERE bktxt LIKE '## ##%'
*     OR bktxt LIKE '##%'.
*
*IF lt_inv_head IS INITIAL.
*  MESSAGE '## ## ## #### ####.' TYPE 'S'.
*  RETURN.
*ENDIF.
*
*" 2. #### #### ### #### #### ### ## ##
*SELECT * FROM ztb1mm0007 " ## #### #### ### ###### ## ##
*  FOR ALL ENTRIES IN @lt_inv_head
*  WHERE ebeln = @lt_inv_head-ebeln
*  INTO TABLE @lt_po_item.
*
*IF lt_po_item IS INITIAL.
*  MESSAGE '## #### #### #### ####.' TYPE 'S'.
*  RETURN.
*ENDIF.
*
*" 3. ##(25#) # ##(FI 7#) ### ## ## (FOR ALL ENTRIES# ## ###)
*IF lt_po_item IS NOT INITIAL.
*  " #### + ### # #### #### ##
*  SELECT * FROM ztb1mm0025
*    FOR ALL ENTRIES IN @lt_po_item
*    WHERE ebeln = @lt_po_item-ebeln
*      AND ebelp = @lt_po_item-ebelp
*    INTO TABLE @lt_price_0025.
*ENDIF.
*
*" FI ## ### ## (### ####/##### ##)
*SELECT * FROM ztb1fi0007 " ## FI ## ###### ## ##
*  FOR ALL ENTRIES IN @lt_inv_head
*  WHERE gdatu = @lt_inv_head-bldat " bldat: ### ###/##### ##
*  INTO TABLE @lt_exch_0007.
*
*" #### ### ## ##
*SORT lt_po_item    BY ebeln ebelp.
*SORT lt_price_0025 BY ebeln ebelp.
*SORT lt_exch_0007  BY gdatu.     " ## ### ##
*
*
*" 4. ## ### ## ## ### ## # ## ## ##
*LOOP AT lt_inv_head ASSIGNING <ls_head>.
*
*  " ### #### ### #### ##### ##
*  LOOP AT lt_po_item INTO DATA(ls_po) WHERE ebeln = <ls_head>-ebeln.
*
*    CLEAR: ls_inv_item.
*
*    " ## # # ## ## ##
*    ls_inv_item-belnr  = <ls_head>-belnr.  " ## ## ##
*    ls_inv_item-gjahr  = <ls_head>-gjahr.  " ## ## ##
*    ls_inv_item-buzei  = ls_po-ebelp.      " ## ## ## (#### #### ##)
*    ls_inv_item-werks  = ls_po-werks.      " ###
*    ls_inv_item-ebeln  = ls_po-ebeln.      " #### ##
*    ls_inv_item-ebelp  = ls_po-ebelp.      " #### ##
*    ls_inv_item-matnr  = ls_po-matnr.      " ####
*    ls_inv_item-menge  = ls_po-menge.      " ##
*    ls_inv_item-meins  = ls_po-meins.      " ## ##
*    ls_inv_item-waersk = 'KRW'.             " ##(## ##)
*    ls_inv_item-waers  = ls_po-waers.      " ## ## #
*
*    " ## ## ## (### ##)
*    ls_inv_item-ernam  = sy-uname.
*    ls_inv_item-erdat  = sy-datum.
*    ls_inv_item-erzet  = sy-uzeit.
*    ls_inv_item-aenam  = sy-uname.
*    ls_inv_item-aedat  = sy-datum.
*    ls_inv_item-aezet  = sy-uzeit.
*
*    " ----------------------------------------------------------------
*    " # [## # ## ## ##]
*    " ----------------------------------------------------------------
*    DATA: lv_ukurs     TYPE p DECIMALS 5 VALUE 1, " ## ##
*          lv_foreign   TYPE p DECIMALS 2,         " ## ## ##
*          lv_local_prc TYPE p DECIMALS 2.         " ## ## ##
*
*    " A. 0025# ##### ## ## ####
*    READ TABLE lt_price_0025 INTO DATA(ls_price)
*      WITH KEY ebeln = ls_po-ebeln
*               ebelp = ls_po-ebelp BINARY SEARCH.
*    IF sy-subrc = 0.
*      lv_foreign = ls_price-netusd. " 25# #### #### ### ##
*    ENDIF.
*
*    " B. FI 0007# ##### ## ##### ## ## ####
*    READ TABLE lt_exch_0007 INTO DATA(ls_exch)
*      WITH KEY gdatu = <ls_head>-bldat BINARY SEARCH. " bldat = ##### ##
*    IF sy-subrc = 0.
*      lv_ukurs = ls_exch-ukurs. " FI 7# #### ## ### ##
*    ELSE.
*      lv_ukurs = 1. " ## ## ## # ### ## ##
*    ENDIF.
*
*    " C. # ### #### #### ## # ## ## ##
*    " ## ## = ## ## * ##
*    lv_local_prc = lv_foreign * lv_ukurs.
*
*    " # ####(####: wrbtr) = ## ## * #### ##
*    ls_inv_item-wrbtr = lv_foreign * ls_po-menge.
*
*    " # ####(##: dmbtr) = ## ## * #### ##
*    DATA: lv_sap_dmbtr TYPE ztb1mm0013-dmbtr.
*    CLEAR: lv_sap_dmbtr.
*
*    lv_sap_dmbtr = lv_local_prc * ls_po-menge.
*
*    CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
*      EXPORTING
*        currency    = 'KRW'
*        idoc_amount = lv_sap_dmbtr
*      IMPORTING
*        sap_amount  = ls_inv_item-dmbtr
*      EXCEPTIONS
*        OTHERS      = 1.
*
*
*    " ----------------------------------------------------------------
*    " ## [#### vs ###### # #### ##]
*    " ----------------------------------------------------------------
*    " #### (bptyp = 1)
*    IF <ls_head>-bptyp = '1'.
*      ls_inv_item-mwskz = 'V1'.  " ####: ##### 10%
**      ls_inv_item-kschl = 'MWST'. " #### ##
*      " ## ## ## (## ##### 10% ##)
*      ls_inv_item-wmwst = ls_inv_item-dmbtr * '0.1'.
*
*      " ## ####
*    ELSEIF <ls_head>-bptyp = '4'.
*      ls_inv_item-mwskz = 'V0'.  " ####: ###
**      ls_inv_item-kschl = 'OA00'. " #### ## (###)
*      ls_inv_item-wmwst = 0.     " ###### ## 0
*    ENDIF.
*
*    " ## #### ##
*    APPEND ls_inv_item TO lt_inv_item.
*
*  ENDLOOP.
*ENDLOOP.
*
*
*" 5. # ## ## ## # DB ### ##
*IF lt_inv_item IS NOT INITIAL.
*  " ## ## ## ### ### # ## ## ##
*  SORT lt_inv_item BY belnr gjahr buzei.
*  DELETE ADJACENT DUPLICATES FROM lt_inv_item COMPARING belnr gjahr buzei.
*
*  " ## # ## ## ## ## DB ###
*  INSERT ztb1mm0014 FROM TABLE lt_inv_item.
*
*  IF sy-subrc = 0.
*    COMMIT WORK.
*    WRITE: / '## ### #### ##### #######.'.
*  ELSE.
*    ROLLBACK WORK.
*    WRITE: / 'DB ## # ### ###### (## ### ## ###)'.
*  ENDIF.
*ENDIF.

**--------------------------------------------------------------------*
**& [MM] ## ####(NB) ## ## ### ## ## ####
**--------------------------------------------------------------------*
*
*DATA: lt_po_head TYPE TABLE OF ztb1mm0006, " #### ##
*      lt_app     TYPE TABLE OF ztb1mm0008, " ## ### (Insert#)
*      ls_app     TYPE ztb1mm0008,
*      lv_appno   TYPE zeb1_mm_zappno.
*
*" 1. ##### 'NB'##, ## ## #### #### ## #### ## ##
*SELECT a~* FROM ztb1mm0006 AS a
*  LEFT OUTER JOIN ztb1mm0008 AS b ON a~ebeln = b~ebeln
*  INTO TABLE @lt_po_head
*  WHERE a~bsart = 'NB' " ## #### ##
*    AND b~ebeln IS NULL. " ## ## ## (## #### ## ##)
*
*IF lt_po_head IS INITIAL.
*  MESSAGE '## ## ### ####(NB)# #### ####.' TYPE 'S'.
*  RETURN.
*ENDIF.
*SORT lt_po_head BY ebeln ASCENDING.
*
*" 2. ## #### #### ### ## ## ### ##
*LOOP AT lt_po_head INTO DATA(ls_po_head).
*
*  CLEAR: lv_appno, ls_app.
*
*  " ## ## ## ## (##### FORM ##)
*  PERFORM get_new_app_number CHANGING lv_appno.
*
*  IF lv_appno IS INITIAL.
*    " ## ## # ## ## ### ## ### ### ### ##
*    REFRESH lt_app.
*    MESSAGE '## ## ## # ### #### ### #####.' TYPE 'E'.
*    EXIT.
*  ENDIF.
*
*  " ## ### ##
*  ls_app-mandt   = sy-mandt.
*  ls_app-zappno  = lv_appno.           " ### #### ## (APP+7##)
*  ls_app-ebeln   = ls_po_head-ebeln.   " #### ##
*  ls_app-zappst  = '2'.                " ## ##: ##
*
*  " ## # ## ##### ## ## ###
*  ls_app-ernam   = sy-uname.
*  ls_app-erdat   = ls_po_head-bedat.
*  ls_app-erzet   = ls_po_head-erzet.
*
*  ls_app-zapper = 'MM1001'.
*  ls_app-zappdat = ls_po_head-bedat.
*  ls_app-zapptim = sy-uzeit.
*
*  APPEND ls_app TO lt_app.
*ENDLOOP.
*
*CALL FUNCTION 'ZFB1CM0001' " ##### ####
*  CHANGING
*    ct_table = lt_app.
*
*" 3. DB ## ## # #### ##
*IF lt_app IS NOT INITIAL.
*
*  INSERT ztb1mm0008 FROM TABLE lt_app.
*
*  IF sy-subrc = 0.
*    COMMIT WORK.
*    DATA(lv_count) = lines( lt_app ).
*    MESSAGE |# { lv_count }## #### ## #### ##### #######.| TYPE 'S'.
*
*    " ### ### ## ##
*    cl_demo_output=>display( lt_app ).
*  ELSE.
*    ROLLBACK WORK.
*    MESSAGE '## ###(ZTB1MM0008) DB ## # ### ######.' TYPE 'E'.
*  ENDIF.
*
*ENDIF.

*&---------------------------------------------------------------------*
*& Form get_new_app_number (#### ## ##)
*&---------------------------------------------------------------------*
*FORM get_new_app_number CHANGING cv_zappno.
*  DATA: lv_number TYPE nriv-nrlevel. " ### ### ### ## ## ##
*
*  CALL FUNCTION 'NUMBER_GET_NEXT'
*    EXPORTING
*      nr_range_nr            = '01'            " SNRO## ## Interval ##
*      object                 = 'ZNRB1MM06'     " Number Range ##
*    IMPORTING
*      number                 = lv_number       " ### ## (45000000001 ~ 4500009999)
*    EXCEPTIONS
*      interval_not_found     = 1
*      number_range_not_found = 2
*      object_not_found       = 3
*      quantity_is_0          = 4
*      quantity_is_not_1      = 5
*      interval_overflow      = 6
*      buffer_overflow        = 7
*      OTHERS                 = 8.
*  IF sy-subrc = 0.
*     ### ##(0000154)# 7## ### ### ## APP# ## 10## ##
*    DATA(lv_temp) = |{ lv_number ALPHA = OUT }|. " ## 0# ### -> ## 7### ####
*    cv_zappno = |APP{ lv_temp ALPHA = IN WIDTH = 7 }|. " APP ###
*  ELSE.
*     ## ## # ##
*    MESSAGE e015(zmcb1).
*  ENDIF.
*ENDFORM.
