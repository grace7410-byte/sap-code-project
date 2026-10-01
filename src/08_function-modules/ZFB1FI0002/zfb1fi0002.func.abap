FUNCTION zfb1fi0002.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_BUKRS) TYPE  ZTB1FI0001-BUKRS
*"     REFERENCE(I_BLDAT) TYPE  ZTB1FI0001-BLDAT
*"     REFERENCE(I_BWART) TYPE  ZTB1MM0015-BWART OPTIONAL
*"     REFERENCE(I_MODE) TYPE  CHAR10
*"     REFERENCE(I_ZAWKEY) TYPE  ZTB1FI0001-ZAWKEY
*"     REFERENCE(I_WAERS) TYPE  ZTB1FI0001-WAERS OPTIONAL
*"     REFERENCE(I_MANDT) TYPE  ZTB1FI0002-MANDT OPTIONAL
*"     REFERENCE(I_BPID) TYPE  ZTB1MM0013-BPID OPTIONAL
*"     REFERENCE(I_BPTYP) TYPE  ZTB1MM0013-BPTYP OPTIONAL
*"     REFERENCE(IT_MM_ITEM) TYPE  ZTTB1FI0001 OPTIONAL
*"     REFERENCE(IT_IR_ITEM) TYPE  ZTTB1FI0002 OPTIONAL
*"     REFERENCE(I_UKURS) TYPE  ZTB1FI0002-UKURS OPTIONAL
*"     REFERENCE(I_MBLNR_WK) TYPE  ZTB1MM0013-MBLNR OPTIONAL
*"  EXPORTING
*"     REFERENCE(E_BELNR) TYPE  BELNR
*"     REFERENCE(E_SUBRC) TYPE  SYSUBRC
*"  EXCEPTIONS
*"      ZAWKEY_MISSING
*"      INVALID_MODE
*"      NUMBER_GET_FAILED
*"      HEADER_INSERT_FAILED
*"      ITEM_INSERT_FAILED
*"      NO_ACCOUNT_FOUND
*"      NO_RECON_FOUND
*"      BALANCE_NOT_ZERO
*"----------------------------------------------------------------------

*       Global data declarations

  "## ##
  DATA: ls_head_db     TYPE ztb1fi0001,
        ls_item_db     TYPE ztb1fi0002,
        ls_item_credit TYPE ztb1fi0002,
        ls_item_fx     TYPE ztb1fi0002,
        lt_item_db     LIKE TABLE OF ls_item_db,
        ls_collect_tab LIKE ls_item_db,
        lt_collect_tab LIKE TABLE OF ls_item_db,
        lv_belnr       TYPE ztb1fi0001-belnr,
        lv_mode        TYPE c LENGTH 10,
        lv_item_no     TYPE buzei,
        lv_gjahr       TYPE ztb1fi0001-gjahr,
        lv_blart       TYPE ztb1fi0001-blart,
        lv_zawtyp      TYPE ztb1fi0001-zawtyp.

  DATA: lt_bklas TYPE TABLE OF ztb1mm0001,
        ls_bklas TYPE ztb1mm0001,
        lt_maktx TYPE TABLE OF ztb1mm0002,
        ls_maktx TYPE ztb1mm0002,
        lt_acc   TYPE TABLE OF ztb1mm0017,
        ls_acc   TYPE ztb1mm0017,
        lt_recon TYPE TABLE OF ztb1sd0002,
        ls_recon TYPE ztb1sd0002.

  DATA: lt_matnr_distinct TYPE TABLE OF string,
        lv_matnr_cnt      TYPE i.

  DATA: lv_gr_wrbtr TYPE ztb1fi0002-dmbtr,
        lv_gr_dmbtr TYPE ztb1fi0002-dmbtr,   " GR ## USD ##
        lv_gr_ukurs TYPE ztb1fi0002-ukurs,
        lv_fx_diff  TYPE p LENGTH 15 DECIMALS 2,
        lv_gr_exist TYPE abap_bool.

  DATA: lv_sum_debit  TYPE ztb1fi0002-wrbtr,
        lv_sum_credit TYPE ztb1fi0002-wrbtr.

  DATA: lv_ukurs TYPE ztb1fi0007-ukurs.

  " IR-1 else ##### DELETE# ## #### #### ## ## ### ##
  DATA: lv_credit_wrbtr_saved TYPE ztb1fi0002-wrbtr,
        lv_credit_dmbtr_saved TYPE ztb1fi0002-dmbtr.

  CLEAR: e_belnr, e_subrc.
  CLEAR: lv_item_no, lt_item_db, lt_collect_tab.

**********************************************************************
* ### ##
**********************************************************************
  IF i_zawkey IS INITIAL.
    e_subrc = 4.
    MESSAGE '##### #######' TYPE 'I' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  CASE i_mode.
    WHEN 'ZMM_SHIP'.
      lv_mode   = 'SHIP'.
      lv_blart  = 'WE'.
      lv_zawtyp = 'ZMM_SHIP'.

    WHEN 'ZMM_IR'.
      lv_mode   = 'IR'.
      lv_zawtyp = 'ZMM_IR'.
      CASE i_bptyp.
        WHEN '3'.
          lv_blart = 'KR'.
        WHEN OTHERS.
          lv_blart = 'RE'.
      ENDCASE.

    WHEN 'ZMM_GR'.
      lv_mode   = 'GR'.
      lv_blart  = 'WE'.
      lv_zawtyp = 'ZMM_GR'.

    WHEN OTHERS.
      e_subrc = 4.
      MESSAGE 'I_MODE ## #### ####' TYPE 'I' DISPLAY LIKE 'E'.
      RETURN.
  ENDCASE.

**********************************************************************
* ### ## ## ### ##
**********************************************************************
  CASE lv_mode.
    WHEN 'SHIP' OR 'GR'.
      IF it_mm_item IS INITIAL.
        e_subrc = 4.
        MESSAGE 'IT_MM_ITEM #### ####' TYPE 'I' DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

      READ TABLE it_mm_item INTO DATA(is_mm_item) INDEX 1.

      SELECT SINGLE ukurs
        INTO lv_ukurs
        FROM ztb1fi0007
        WHERE gdatu = is_mm_item-erdat
          AND fcurr = is_mm_item-waers.
      IF sy-subrc <> 0.
        lv_ukurs = 0.
      ENDIF.

      SELECT bklas matnr
        INTO CORRESPONDING FIELDS OF TABLE lt_bklas
        FROM ztb1mm0001
        FOR ALL ENTRIES IN it_mm_item
        WHERE matnr = it_mm_item-matnr.

      IF lt_bklas IS INITIAL.
        e_subrc = 4.
        MESSAGE '##### ### ## # ####' TYPE 'I' DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

      SELECT maktx matnr
        INTO CORRESPONDING FIELDS OF TABLE lt_maktx
        FROM ztb1mm0002
        FOR ALL ENTRIES IN it_mm_item
        WHERE matnr = it_mm_item-matnr
          AND spras = 'KO'.

      IF lt_bklas IS NOT INITIAL.
        SELECT saknr_d saknr_c bwart bklas
          INTO CORRESPONDING FIELDS OF TABLE lt_acc
          FROM ztb1mm0017
          FOR ALL ENTRIES IN lt_bklas
          WHERE bwart = i_bwart
            AND bklas = lt_bklas-bklas.
      ENDIF.

    WHEN 'IR'.
      IF it_ir_item IS INITIAL.
        e_subrc = 4.
        MESSAGE 'IT_IR_ITEM #### ####' TYPE 'I' DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

      SELECT maktx matnr
        INTO CORRESPONDING FIELDS OF TABLE lt_maktx
        FROM ztb1mm0002
        FOR ALL ENTRIES IN it_ir_item
        WHERE matnr = it_ir_item-matnr
          AND spras = 'KO'.

      SELECT bpid recon bptyp
        INTO CORRESPONDING FIELDS OF TABLE lt_recon
        FROM ztb1sd0002
        WHERE bpid = i_bpid.

      IF i_bptyp = '1' AND i_mblnr_wk IS NOT INITIAL.
        SELECT SUM( i~wrbtr ) SUM( i~dmbtr ) MAX( i~ukurs )
          INTO (lv_gr_wrbtr, lv_gr_dmbtr, lv_gr_ukurs)
          FROM ztb1fi0002 AS i
          INNER JOIN ztb1fi0001 AS h
            ON h~belnr = i~belnr
           AND h~bukrs = i~bukrs
           AND h~gjahr = i~gjahr
          WHERE i~zawkey    = i_mblnr_wk
            AND i~shkzg     = 'H'
            AND h~xreversal = ''   " ### ### ## #
            AND h~stblg     = ''.  " ### #### ## #

      ENDIF.

  ENDCASE.

  lv_gjahr = sy-datum(4).

**********************************************************************
* ### ##
**********************************************************************
  CASE lv_mode.

***************************** SHIP ***********************************
    WHEN 'SHIP'.

      CLEAR: lt_matnr_distinct.
      LOOP AT it_mm_item ASSIGNING FIELD-SYMBOL(<fs_mm_cnt>).
        APPEND <fs_mm_cnt>-matnr TO lt_matnr_distinct.
      ENDLOOP.
      SORT lt_matnr_distinct.
      DELETE ADJACENT DUPLICATES FROM lt_matnr_distinct.
      lv_matnr_cnt = lines( lt_matnr_distinct ).
      READ TABLE lt_maktx INTO ls_maktx WITH KEY matnr = it_mm_item[ 1 ]-matnr.
      IF lv_matnr_cnt <= 1.
        ls_head_db-bkpf_txt = |{ sy-datum+4(2) }# { ls_maktx-maktx }  FOB |.
      ELSE.
        ls_head_db-bkpf_txt = |{ sy-datum+4(2) }# { ls_maktx-maktx } # { lv_matnr_cnt - 1 }#  FOB |.
      ENDIF.

      LOOP AT it_mm_item ASSIGNING FIELD-SYMBOL(<fs_mm>).
        CLEAR ls_item_db.

        READ TABLE lt_bklas INTO ls_bklas WITH KEY matnr = <fs_mm>-matnr.
        READ TABLE lt_maktx INTO ls_maktx WITH KEY matnr = <fs_mm>-matnr.
        READ TABLE lt_acc INTO ls_acc WITH KEY bwart = i_bwart bklas = ls_bklas-bklas.

        lv_item_no = lv_item_no + 1.
        ls_item_db-buzei    = lv_item_no.
        ls_item_db-ernam    = sy-uname.
        ls_item_db-erdat    = sy-datum.
        ls_item_db-erzet = sy-uzeit.
        ls_item_db-aenam = sy-uname.
        ls_item_db-aedat = sy-datum.
        ls_item_db-aezet = sy-uzeit.
        ls_item_db-mandt    = i_mandt.
        ls_item_db-bukrs    = i_bukrs.
        ls_item_db-gjahr    = lv_gjahr.
        ls_item_db-matnr    = <fs_mm>-matnr.
        ls_item_db-wrbtr    = <fs_mm>-dmbtr.    " MM dmbtr(##) # FI wrbtr(##)
        ls_item_db-dmbtr    = <fs_mm>-wrbtr.    " MM wrbtr(##) # FI dmbtr(##)
        ls_item_db-waers    = <fs_mm>-waersk.
        ls_item_db-waersdal = <fs_mm>-waers.
        ls_item_db-zawkey   = i_zawkey.
        ls_item_db-ukurs    = lv_ukurs.

**********************************************************************
* ## ##)### ## (Debit)
**********************************************************************
        ls_item_db-bschl = '40'.
        ls_item_db-saknr = '1'.
        ls_item_db-koart = 'S'.
        ls_item_db-shkzg = 'S'.
        ls_item_db-hkont = ls_acc-saknr_d.
        ls_item_db-sgtxt = |{ ls_maktx-maktx } ##|.
        APPEND ls_item_db TO lt_item_db.

**********************************************************************
* ## ##)### ## (Credit) - ### ##
**********************************************************************
        CLEAR ls_collect_tab.
        ls_collect_tab-mandt    = i_mandt.
        ls_collect_tab-bukrs    = i_bukrs.
        ls_collect_tab-gjahr    = lv_gjahr.
        ls_collect_tab-bschl    = '50'.
        ls_collect_tab-saknr    = '2'.
        ls_collect_tab-koart    = 'S'.
        ls_collect_tab-shkzg    = 'H'.
        ls_collect_tab-hkont    = ls_acc-saknr_c.
        ls_collect_tab-wrbtr    = <fs_mm>-dmbtr.   " ##
        ls_collect_tab-dmbtr    = <fs_mm>-wrbtr.   " ##
        ls_collect_tab-waers    = <fs_mm>-waersk.
        ls_collect_tab-waersdal = <fs_mm>-waers.
        ls_collect_tab-ukurs    = lv_ukurs.
        COLLECT ls_collect_tab INTO lt_collect_tab.
      ENDLOOP.

      LOOP AT lt_collect_tab INTO ls_collect_tab.
        CLEAR ls_item_db.
        MOVE-CORRESPONDING ls_collect_tab TO ls_item_db.
        lv_item_no = lv_item_no + 1.
        ls_item_db-buzei  = lv_item_no.
        ls_item_db-sgtxt  = '## ## ##'.
        ls_item_db-ernam  = sy-uname.
        ls_item_db-erdat  = sy-datum.
        ls_item_db-mandt  = i_mandt.
        ls_item_db-bukrs  = i_bukrs.
        ls_item_db-gjahr  = lv_gjahr.
        ls_item_db-zawkey = i_zawkey.
        APPEND ls_item_db TO lt_item_db.
      ENDLOOP.

***************************** GR ***********************************
    WHEN 'GR'.

      CLEAR: lt_matnr_distinct.
      LOOP AT it_mm_item ASSIGNING FIELD-SYMBOL(<fs_mm_cnt2>).
        APPEND <fs_mm_cnt2>-matnr TO lt_matnr_distinct.
      ENDLOOP.
      SORT lt_matnr_distinct.
      DELETE ADJACENT DUPLICATES FROM lt_matnr_distinct.
      lv_matnr_cnt = lines( lt_matnr_distinct ).
      READ TABLE lt_maktx INTO ls_maktx WITH KEY matnr = it_mm_item[ 1 ]-matnr.
      IF lv_matnr_cnt <= 1.
        ls_head_db-bkpf_txt = |{ sy-datum+4(2) }# { ls_maktx-maktx } ### ## - ##|.
      ELSE.
        ls_head_db-bkpf_txt = |{ sy-datum+4(2) }# { ls_maktx-maktx } # { lv_matnr_cnt - 1 }# ### ## - ##|.
      ENDIF.

      LOOP AT it_mm_item ASSIGNING FIELD-SYMBOL(<fs_mm_gr>).
        CLEAR ls_item_db.

        READ TABLE lt_bklas INTO ls_bklas WITH KEY matnr = <fs_mm_gr>-matnr.
        READ TABLE lt_maktx INTO ls_maktx WITH KEY matnr = <fs_mm_gr>-matnr.
        READ TABLE lt_acc INTO ls_acc WITH KEY bwart = i_bwart bklas = ls_bklas-bklas.

        lv_item_no = lv_item_no + 1.
        ls_item_db-buzei    = lv_item_no.
        ls_item_db-ernam    = sy-uname.
        ls_item_db-erdat    = sy-datum.
        ls_item_db-mandt    = i_mandt.
        ls_item_db-bukrs    = i_bukrs.
        ls_item_db-gjahr    = lv_gjahr.
        ls_item_db-matnr    = <fs_mm_gr>-matnr.
        ls_item_db-wrbtr    = <fs_mm_gr>-dmbtr.   " MM dmbtr(##) # FI wrbtr(##)
        ls_item_db-dmbtr    = <fs_mm_gr>-wrbtr.   " MM wrbtr(##) # FI dmbtr(##)
        ls_item_db-waers    = <fs_mm_gr>-waersk.
        ls_item_db-waersdal = <fs_mm_gr>-waers.
        ls_item_db-zawkey   = i_zawkey.

**********************************************************************
* ### ## ##)### ## (Debit)
**********************************************************************
        ls_item_db-bschl = '40'.
        ls_item_db-saknr = '5'.
        ls_item_db-koart = 'S'.
        ls_item_db-shkzg = 'S'.
        ls_item_db-hkont = ls_acc-saknr_d.
        ls_item_db-sgtxt = |{ ls_maktx-maktx } #### |.
        APPEND ls_item_db TO lt_item_db.

**********************************************************************
* ### ## ##)### ## (Credit)
**********************************************************************
        CLEAR ls_item_db.
        lv_item_no = lv_item_no + 1.
        ls_item_db-buzei    = lv_item_no.
        ls_item_db-ernam    = sy-uname.
        ls_item_db-erdat    = sy-datum.
        ls_item_db-mandt    = i_mandt.
        ls_item_db-bukrs    = i_bukrs.
        ls_item_db-gjahr    = lv_gjahr.
        ls_item_db-matnr    = <fs_mm_gr>-matnr.
        ls_item_db-wrbtr    = <fs_mm_gr>-dmbtr.   " MM dmbtr(##) # FI wrbtr(##)
        ls_item_db-dmbtr    = <fs_mm_gr>-wrbtr.   " MM wrbtr(##) # FI dmbtr(##)
        ls_item_db-waers    = <fs_mm_gr>-waersk.
        ls_item_db-waersdal = <fs_mm_gr>-waers.
        ls_item_db-zawkey   = i_zawkey.
        ls_item_db-bschl    = '50'.
        ls_item_db-saknr    = '1'.
        ls_item_db-koart    = 'S'.
        ls_item_db-shkzg    = 'H'.
        ls_item_db-hkont    = ls_acc-saknr_c.
        ls_item_db-sgtxt    = |{ ls_maktx-maktx } ####|.
        APPEND ls_item_db TO lt_item_db.
      ENDLOOP.

***************************** IR ***********************************
    WHEN 'IR'.

      CLEAR: lt_matnr_distinct.
      LOOP AT it_ir_item ASSIGNING FIELD-SYMBOL(<fs_ir_cnt>).
        APPEND <fs_ir_cnt>-matnr TO lt_matnr_distinct.
      ENDLOOP.
      SORT lt_matnr_distinct.
      DELETE ADJACENT DUPLICATES FROM lt_matnr_distinct.
      lv_matnr_cnt = lines( lt_matnr_distinct ).
      READ TABLE lt_maktx INTO ls_maktx WITH KEY matnr = it_ir_item[ 1 ]-matnr.
      IF lv_matnr_cnt <= 1.
        ls_head_db-bkpf_txt = |{ sy-datum+4(2) }# { ls_maktx-maktx }  ## |.
      ELSE.
        ls_head_db-bkpf_txt = |{ sy-datum+4(2) }# { ls_maktx-maktx } # { lv_matnr_cnt - 1 }#  ## |.
      ENDIF.

      CASE i_bptyp.

*----------------------------------------------------------------------
* IR-1) #### ## (bptyp = '1')
*----------------------------------------------------------------------
        WHEN '1'.
          lv_gr_exist = abap_false.

          LOOP AT it_ir_item ASSIGNING FIELD-SYMBOL(<fs_ir1>).
            READ TABLE lt_maktx INTO ls_maktx WITH KEY matnr = <fs_ir1>-matnr.

            IF lv_gr_exist = abap_false.
              CLEAR ls_item_db.
              lv_item_no = lv_item_no + 1.
              ls_item_db-buzei    = lv_item_no.
              ls_item_db-ernam    = sy-uname.
              ls_item_db-erdat    = sy-datum.
              ls_item_db-mandt    = i_mandt.
              ls_item_db-bukrs    = i_bukrs.
              ls_item_db-gjahr    = lv_gjahr.
              ls_item_db-matnr    = <fs_ir1>-matnr.
              ls_item_db-waers    = <fs_ir1>-waersk.
              ls_item_db-waersdal = <fs_ir1>-waers.
              ls_item_db-zawkey   = i_zawkey.
              ls_item_db-lifnr    = i_bpid.
              ls_item_db-mwskz    = <fs_ir1>-mwskz.
              ls_item_db-bschl    = '40'.
              ls_item_db-saknr    = '2'.
              ls_item_db-koart    = 'S'.
              ls_item_db-shkzg    = 'S'.
              ls_item_db-hkont    = '21000010'.
              ls_item_db-ukurs    = lv_gr_ukurs.
              ls_item_db-wrbtr    = lv_gr_wrbtr.      " GR ## KRW (###, ## ## # #)
              ls_item_db-dmbtr    = lv_gr_dmbtr.      " GR ## USD (###, ## ## # #)
              ls_item_db-sgtxt    = |{ ls_maktx-maktx } ## ##|.
              APPEND ls_item_db TO lt_item_db.

              CLEAR ls_item_credit.
              lv_item_no = lv_item_no + 1.
              ls_item_credit-buzei    = lv_item_no.
              ls_item_credit-ernam    = sy-uname.
              ls_item_credit-erdat    = sy-datum.
              ls_item_credit-mandt    = i_mandt.
              ls_item_credit-bukrs    = i_bukrs.
              ls_item_credit-gjahr    = lv_gjahr.
              ls_item_credit-matnr    = <fs_ir1>-matnr.
              ls_item_credit-waers    = <fs_ir1>-waersk.
              ls_item_credit-waersdal = <fs_ir1>-waers.
              ls_item_credit-zawkey   = i_zawkey.
              ls_item_credit-lifnr    = i_bpid.
              ls_item_credit-bschl    = '31'.
              ls_item_credit-saknr    = '2'.
              ls_item_credit-koart    = 'K'.
              ls_item_credit-shkzg    = 'H'.
              ls_item_credit-ukurs    = i_ukurs.
              ls_item_credit-wrbtr    = <fs_ir1>-dmbtr.   " ## KRW (IT_IR_ITEM ##: dmbtr# KRW)
              ls_item_credit-dmbtr    = <fs_ir1>-wrbtr.   " ## USD (IT_IR_ITEM ##: wrbtr# USD)
              READ TABLE lt_recon INTO ls_recon WITH KEY bptyp = '1'.
              ls_item_credit-hkont    = ls_recon-recon.
              ls_item_credit-sgtxt    = |{ ls_maktx-maktx } ## ##|.
              APPEND ls_item_credit TO lt_item_db.

              lv_fx_diff = <fs_ir1>-dmbtr - lv_gr_wrbtr.   " KRW## ## (<fs_ir1># KRW# dmbtr ##)

              IF lv_fx_diff <> 0.
                CLEAR ls_item_fx.
                lv_item_no = lv_item_no + 1.
                ls_item_fx-buzei  = lv_item_no.
                ls_item_fx-ernam  = sy-uname.
                ls_item_fx-erdat  = sy-datum.
                ls_item_fx-mandt  = i_mandt.
                ls_item_fx-bukrs  = i_bukrs.
                ls_item_fx-gjahr  = lv_gjahr.
                ls_item_fx-koart  = 'S'.
                ls_item_fx-waers  = 'KRW'.
                ls_item_fx-zawkey = i_zawkey.
                IF lv_fx_diff > 0.
                  ls_item_fx-bschl = '40'.
                  ls_item_fx-hkont = '53000002'.
                  ls_item_fx-shkzg = 'S'.
                  ls_item_fx-saknr = '5'.
                  ls_item_fx-wrbtr = lv_fx_diff.
                ELSE.
                  ls_item_fx-bschl = '50'.
                  ls_item_fx-hkont = '42000002'.
                  ls_item_fx-shkzg = 'H'.
                  ls_item_fx-saknr = '4'.
                  ls_item_fx-wrbtr = lv_fx_diff * -1.
                ENDIF.
                ls_item_fx-sgtxt = |{ ls_maktx-maktx } #####|.
                APPEND ls_item_fx TO lt_item_db.
              ENDIF.

              lv_gr_exist = abap_true.

            ELSE.
              " ##(GR/IR ##, hkont='21000010')# wrbtr·dmbtr ##
              " ## ##### GR ## ### #### #### # ## #### ##

              READ TABLE lt_recon INTO ls_recon WITH KEY bptyp = '1'.
              READ TABLE lt_item_db ASSIGNING FIELD-SYMBOL(<fs_credit>)
                WITH KEY shkzg = 'H' hkont = ls_recon-recon.
              IF sy-subrc = 0.
                <fs_credit>-wrbtr = <fs_credit>-wrbtr + <fs_ir1>-dmbtr.   " KRW## ## (IT_IR_ITEM ##: dmbtr# KRW)
                <fs_credit>-dmbtr = <fs_credit>-dmbtr + <fs_ir1>-wrbtr.   " USD## ## (IT_IR_ITEM ##: wrbtr# USD)

                " DELETE# ###### ##### ##### #### # ####
                " ## ### # ## ## ### ## #####.
                lv_credit_wrbtr_saved = <fs_credit>-wrbtr.
                lv_credit_dmbtr_saved = <fs_credit>-dmbtr.
              ENDIF.

              DELETE lt_item_db WHERE hkont = '53000002'.
              DELETE lt_item_db WHERE hkont = '42000002'.
              " # # #### <fs_credit># # ## ##### ### # #### ## ##.
              "   ## ### ### lv_credit_wrbtr_saved / lv_credit_dmbtr_saved## ##.

              lv_fx_diff = lv_credit_wrbtr_saved - lv_gr_wrbtr.   " ## ## KRW vs GR ## KRW ##

              IF lv_fx_diff <> 0.
                CLEAR ls_item_fx.
                lv_item_no = lv_item_no + 1.
                ls_item_fx-buzei  = lv_item_no.
                ls_item_fx-ernam  = sy-uname.
                ls_item_fx-erdat  = sy-datum.
                ls_item_fx-mandt  = i_mandt.
                ls_item_fx-bukrs  = i_bukrs.
                ls_item_fx-gjahr  = lv_gjahr.
                ls_item_fx-koart  = 'S'.
                ls_item_fx-waers  = 'KRW'.
                ls_item_fx-zawkey = i_zawkey.
                IF lv_fx_diff > 0.
                  ls_item_fx-bschl = '40'.
                  ls_item_fx-hkont = '53000002'.
                  ls_item_fx-shkzg = 'S'.
                  ls_item_fx-saknr = '5'.
                  ls_item_fx-wrbtr = lv_fx_diff.
                ELSE.
                  ls_item_fx-bschl = '50'.
                  ls_item_fx-hkont = '42000002'.
                  ls_item_fx-shkzg = 'H'.
                  ls_item_fx-saknr = '4'.
                  ls_item_fx-wrbtr = lv_fx_diff * -1.
                ENDIF.
                ls_item_fx-sgtxt = |{ ls_maktx-maktx } #####|.
                APPEND ls_item_fx TO lt_item_db.
              ENDIF.
            ENDIF.
          ENDLOOP.

*----------------------------------------------------------------------
* IR-2) #### ## (bptyp = '3')
*----------------------------------------------------------------------
        WHEN '3'.
          LOOP AT it_ir_item ASSIGNING FIELD-SYMBOL(<fs_ir3>).
            READ TABLE lt_maktx INTO ls_maktx WITH KEY matnr = <fs_ir3>-matnr.
            READ TABLE lt_recon INTO ls_recon WITH KEY bptyp = '3'.

            CLEAR ls_item_db.
            lv_item_no = lv_item_no + 1.
            ls_item_db-buzei    = lv_item_no.
            ls_item_db-ernam    = sy-uname.
            ls_item_db-erdat    = sy-datum.
            ls_item_db-mandt    = i_mandt.
            ls_item_db-bukrs    = i_bukrs.
            ls_item_db-gjahr    = lv_gjahr.
            ls_item_db-matnr    = <fs_ir3>-matnr.
            ls_item_db-wrbtr    = <fs_ir3>-dmbtr.   " KRW
            ls_item_db-dmbtr    = <fs_ir3>-wrbtr.   " USD # ##
            ls_item_db-waers    = <fs_ir3>-waersk.
            ls_item_db-waersdal = <fs_ir3>-waers.
            ls_item_db-ukurs    = i_ukurs.
            ls_item_db-zawkey   = i_zawkey.
            ls_item_db-lifnr    = i_bpid.
            ls_item_db-mwskz    = <fs_ir3>-mwskz.
            ls_item_db-bschl    = '40'.
            ls_item_db-saknr    = '1'.
            ls_item_db-koart    = 'S'.
            ls_item_db-shkzg    = 'S'.
            ls_item_db-hkont    = ls_recon-recon.
            ls_item_db-sgtxt    = |{ ls_maktx-maktx } ## ##|.
            APPEND ls_item_db TO lt_item_db.

            CLEAR ls_item_credit.
            ls_item_credit = ls_item_db.
            lv_item_no = lv_item_no + 1.
            ls_item_credit-buzei = lv_item_no.
            ls_item_credit-bschl = '50'.
            ls_item_credit-saknr = '2'.
            ls_item_credit-koart = 'S'.
            ls_item_credit-shkzg = 'H'.
            ls_item_credit-hkont = '21000001'.
            ls_item_credit-sgtxt = |{ ls_maktx-maktx } ## ##|.
            APPEND ls_item_credit TO lt_item_db.
          ENDLOOP.

*----------------------------------------------------------------------
* IR-3) #### ## (bptyp OTHERS)
*----------------------------------------------------------------------
        WHEN OTHERS.
          READ TABLE lt_recon INTO ls_recon WITH KEY bptyp = i_bptyp.

          LOOP AT it_ir_item ASSIGNING FIELD-SYMBOL(<fs_ir4>).
            READ TABLE lt_maktx INTO ls_maktx WITH KEY matnr = <fs_ir4>-matnr.

            CLEAR ls_item_db.
            lv_item_no = lv_item_no + 1.
            ls_item_db-buzei    = lv_item_no.
            ls_item_db-ernam    = sy-uname.
            ls_item_db-erdat    = sy-datum.
            ls_item_db-mandt    = i_mandt.
            ls_item_db-bukrs    = i_bukrs.
            ls_item_db-gjahr    = lv_gjahr.
            ls_item_db-matnr    = <fs_ir4>-matnr.
            ls_item_db-wrbtr    = <fs_ir4>-dmbtr.   " KRW
            ls_item_db-dmbtr    = <fs_ir4>-wrbtr.   " USD # ##
            ls_item_db-waers    = <fs_ir4>-waersk.
            ls_item_db-waersdal = <fs_ir4>-waers.
            ls_item_db-ukurs    = i_ukurs.
            ls_item_db-zawkey   = i_zawkey.
            ls_item_db-lifnr    = i_bpid.
            ls_item_db-mwskz    = <fs_ir4>-mwskz.
            ls_item_db-bschl    = '40'.
            ls_item_db-saknr    = '1'.
            ls_item_db-koart    = 'S'.
            ls_item_db-shkzg    = 'S'.
            ls_item_db-hwste = <fs_ir4>-wmwst.
            IF <fs_ir4>-matnr CP 'WTI*'.
              ls_item_db-hkont = '11000010'.
            ELSEIF <fs_ir4>-matnr CP 'DUBAI*'.
              ls_item_db-hkont = '11000011'.
            ELSE.
              ls_item_db-hkont = '11000012'.
            ENDIF.
            ls_item_db-sgtxt = |{ ls_maktx-maktx } ## ## ##|.
            APPEND ls_item_db TO lt_item_db.

            CLEAR ls_item_credit.
            ls_item_credit = ls_item_db.
            lv_item_no = lv_item_no + 1.
            ls_item_credit-buzei = lv_item_no.
            ls_item_credit-bschl = '31'.
            ls_item_credit-saknr = '2'.
            ls_item_credit-koart = 'K'.
            ls_item_credit-shkzg = 'H'.
            ls_item_credit-hkont = ls_recon-recon.
            ls_item_credit-sgtxt = |{ ls_maktx-maktx } ## ## ##|.
            APPEND ls_item_credit TO lt_item_db.
          ENDLOOP.
      ENDCASE.

  ENDCASE.

**********************************************************************
* BUZEI #### (## DELETE# ## ## # ##)
**********************************************************************
  SORT lt_item_db BY buzei.
  LOOP AT lt_item_db ASSIGNING FIELD-SYMBOL(<fs_renum>).
    <fs_renum>-buzei = sy-tabix.
  ENDLOOP.
  lv_item_no = lines( lt_item_db ).

**********************************************************************
* ### ##
**********************************************************************
  IF lt_item_db IS INITIAL.
    e_subrc = 4.
    MESSAGE '### ## #### ####' TYPE 'I' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  CLEAR: lv_sum_debit, lv_sum_credit.
  LOOP AT lt_item_db INTO ls_item_db.
    IF ls_item_db-shkzg = 'S'.
      lv_sum_debit = lv_sum_debit + ls_item_db-wrbtr.
    ELSEIF ls_item_db-shkzg = 'H'.
      lv_sum_credit = lv_sum_credit + ls_item_db-wrbtr.
    ENDIF.
  ENDLOOP.

  IF lv_sum_debit <> lv_sum_credit.
    e_subrc = 4.
    MESSAGE |##({ lv_sum_debit })# ##({ lv_sum_credit })# #### ####| TYPE 'I' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

**********************************************************************
* #### ##
**********************************************************************
  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = 'C1'
      object                  = 'ZNRB1FI01'
      quantity                = 1
      toyear                  = sy-datum(4)
    IMPORTING
      number                  = lv_belnr
    EXCEPTIONS
      interval_not_found      = 1
      number_range_not_intern = 2
      object_not_found        = 3
      quantity_is_0           = 4
      quantity_is_not_1       = 5
      interval_overflow       = 6
      buffer_overflow         = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
    e_subrc = sy-subrc.
    CASE sy-subrc.
      WHEN 1. MESSAGE '## ## ### ## # ####.' TYPE 'I' DISPLAY LIKE 'E'.
      WHEN 2. MESSAGE '## ### ## #### ####.' TYPE 'I' DISPLAY LIKE 'E'.
      WHEN 3. MESSAGE '## ####(ZNRB1FI01)# #### ####.' TYPE 'I' DISPLAY LIKE 'E'.
      WHEN 4. MESSAGE '## ## ### 0###.' TYPE 'I' DISPLAY LIKE 'E'.
      WHEN 5. MESSAGE '# ##### # ## ### ### ### # ####.' TYPE 'I' DISPLAY LIKE 'E'.
      WHEN 6. MESSAGE '## ### ## #######.' TYPE 'I' DISPLAY LIKE 'E'.
      WHEN 7. MESSAGE '## ## ### ### ######.' TYPE 'I' DISPLAY LIKE 'E'.
      WHEN OTHERS. MESSAGE '## # # # ## ## ######.' TYPE 'I' DISPLAY LIKE 'E'.
    ENDCASE.
    RETURN.
  ENDIF.

**********************************************************************
* ## ## + belnr ## ###
**********************************************************************


  ls_head_db-mandt  = i_mandt.
  ls_head_db-bukrs  = i_bukrs.
  ls_head_db-gjahr  = lv_gjahr.
  ls_head_db-belnr  = lv_belnr.
  ls_head_db-blart  = lv_blart.
  ls_head_db-budat  = i_bldat.
  ls_head_db-monat  = i_bldat+4(2).
  ls_head_db-zawtyp = lv_zawtyp.
  ls_head_db-ernam  = sy-uname.
  ls_head_db-erdat  = sy-datum.
  ls_head_db-erzet  = sy-uzeit.
  ls_head_db-aenam  = sy-uname.
  ls_head_db-aedat  = sy-datum.
  ls_head_db-aezet  = sy-uzeit.
  ls_head_db-zawkey = i_zawkey.
  ls_head_db-bldat  = i_bldat.
  ls_head_db-hwaer2 = 'KRW'.

  CASE lv_mode.
    WHEN 'SHIP' OR 'GR'.
      ls_head_db-waers = it_mm_item[ 1 ]-waers.
    WHEN 'IR'.
      ls_head_db-waers = it_ir_item[ 1 ]-waers.
  ENDCASE.

  LOOP AT lt_item_db ASSIGNING FIELD-SYMBOL(<fs_final>).
    <fs_final>-belnr = lv_belnr.
  ENDLOOP.

**********************************************************************
* DB ## (COMMIT# ## ######)
**********************************************************************
  INSERT ztb1fi0001 FROM ls_head_db.
  IF sy-subrc = 0.
    INSERT ztb1fi0002 FROM TABLE lt_item_db.
    IF sy-subrc = 0.
      e_belnr = lv_belnr.
      e_subrc = 0.
    ELSE.
      ROLLBACK WORK.
      e_subrc = 8.
      MESSAGE '## ### ### ## ##' TYPE 'I' DISPLAY LIKE 'E'.
    ENDIF.
  ELSE.
    ROLLBACK WORK.
    e_subrc = 9.
    MESSAGE '## ## ### ## ##' TYPE 'I' DISPLAY LIKE 'E'.
  ENDIF.

ENDFUNCTION.


*Messages
*----------------------------------------------------------
*
* Message class: <LS_RETURN>-ID
*<LS
*
* Message class: ALE_MSGID
*ALE
*
* Message class: AM
*287   Address cannot be maintained; entry in table TSADRV missing
*290   Entry missing in TSADRV; new address maintenance cannot be called
*291   Entry missing in TSADRV; new address maintenance cannot be called
*298   Address group & not defined; delete flag for address not possible
*I_M
*
* Message class: EC
*089   Internal error (cannot read dynpro data)
*
* Message class: EINFO-MSG_ID
*EIN
*
* Message class: ERROR_INFO-MSG_ID
*ERR
*
* Message class: Hard coded
*   ## ## ### ## # ####.
*
* Message class: LO_DELTA_DATA_HANDLE
*LO_
*
* Message class: LO_LINE_AUTHORITY_ER
*LO_
*
* Message class: LO_SYNCHRONIZER_ERRO
*LO_
*
* Message class: PM_ID
*PM_
*
* Message class: SCPR
*026   Table & is too wide. It cannot be processed
*028   The table/view & has no generated maintenance dialog
*035   Dictionary interface error: Contact SAP
*120   Table/view & not found
*273   Function module call error
*320   BC Set processing error
*395   Internal field description read error
*399   No data record activation information
*408   Table key not supported by activation links
*
* Message class: SV
*000   &
*001   The selected function is not supported
*002   Number of retrieved entries: &
*004   No entries found that match the selection criteria.
*005   One entry chosen
*006   Number of chosen entries: &
*007   No previous entry exists
*008   No next entry exists
*009   An entry already exists with the same key
*010   An entry with this key is marked for deletion
*011   Number of deleted entries: &
*012   Number of changed entries: &
*013   Entry deleted
*014   Number of entries copied: &
*015   Target key must be different from source key
*016   Number of reset entries: &
*017   Entry reset
*018   Data was saved
*019   Select a key from the allowed namespace.
*024   Specify target entries
*025   Specify target entries.
*026   Select entries before performing the function.
*028   Table & not in DDIC
*032   Position the cursor on a valid entry
*033   Specify the key within the work area
*037   The maintenance dialog for & is incomplete or not defined
*039   Table & has no relevant fields
*040   & entries reset, & original and & new entries are still marked
*041   & entries reset, & original entries are still marked
*042   & entries reset, & new entries are still marked
*043   Data already saved
*044   Read access only
*045   Start date must lie before end date.
*046   End date must lie after start date.
*047   Overlapping records are deleted or delimited
*049   Data locked by user & (display only)
*050   System error: Unable to lock table/view &
*051   You do not have authorization to change the data (only display)
*053   No display authorization for requested data
*054   Maintenance of data in current client & not permitted
*055   Address for object & not found
*056   Select at least one entry before choosing this function.
*057   The selected entry is new and has no original
*058   The selected entries are new and have no original
*059   The selected entry is still in its original state
*060   The selected entries are still in their original state
*061   & entries are still originals, & new entries have no original
*065   No entries exist, double-click for long text
*066   Select block end
*084   No values can be displayed
*092   Change task & is being processed
*095   System error changing change task &
*096   Task & was changed
*098   Entry flagged for inclusion in task &
*099   Entry was flagged for deletion from task &
*105   & entries were flagged for inclusion in task &
*106   & entries were flagged for deletion from task &
*107   Entry was already in task &
*108   & entries were already in task &
*109   & entries included, & entries were contained: &
*110   Entry was not in task &
*111   & entries deleted, & entries were not included: &
*112   & entries were not in task &
*113   Entry could not be retrieved
*114   & entries could not be retrieved
*115   Entry could not be deleted
*116   & entries could not be deleted
*117   Do not make any changes (SAP entry).
*120   Other entries will be retrieved and modified where necessary.
*121   Deleted entry will be recovered and possibly changed
*122   Entry was delimited
*123   Number of delimited entries: &
*124   Process the delimited entries.
*125   Process the delimited entry.
*127   Delimit the area of validity.
*128   Transport is not possible for delivery class &.
*129   Related objects in various tasks
*130   Client & is local, transport not permitted
*132   Object locked for task &1, user &2 (only display possible).
*134   Inconsistency in object definition (only display possible)
*136   Change with caution, entry belongs to customer
*137   Do not make any changes (SAP data).
*138   Check maintenance object &1 or update function group &2.
*139   Address data is not transferred during comparison.
*140   &1 entries deleted; &2 entries added.
*141   Entries are not added individually to the change request.
*142   Transport is not possible for the specified data
*150   Start of action &4 for entry &1 &2 &3
*151   End of action &4 for entry &1 &2 &3
*153   No language was chosen
*154   Test mode: Changes were not saved
*160   The installed system code page does not allow any other languages.
*161   Put the cursor on a form name
*162   The object &1 &2 &3 cannot be put in a request
*164   Table/view &1 is not in the Dictionary
*165   No address in import client for object &
*173   Function group &1 inconsistent
*174   Enter values in work area for non-key fields.
*175   The selected BC Set function is not supported.
*177   Data record contains fix value from BC Set and cannot be deleted
*180   Data for specified key areas unchangeable
*181   Read access only
*184   Data record contains fixed value from BC Set and cannot be changed
*193   DB save rolled back
*202   You are not authorized to change fields with fixed BC Set values
*208   Recording of table keys in request &1 ended
*209   Recording of table keys in request &1 started
*210   &1 table keys are passed for recording
*214   Save is aborted, due to error raised in event &1
*224   Data is inconsistent. To see logs click on Display Logs (Ctrl+F7) button
*225   Data is consistent
*306   Table/view & is not active
*413   & selected entries cannot be deleted
*538   Dropdown list is not supported in view clusters.
*757   You have no maintenance authorization for this table key
*763   You have no maintenance authorization for the displayed data records
*764   Data record selection was changed.
*766   Restricted display of datasets
*808   Not all columns in the table can be displayed in the list
*810   View &1 is more than 1000 characters long.
*818   &1 of &2 Business Configuration Set entries imported.
*819   Business Configuration Set imported.
*830   Last selected entry has been reached
*831   First selected entry has been reached
*863   Number of copied entries (including translations): &
*870   Maintenance Dialog Switched to List Screen
*MSG
*P_M
*
* Message class: TB
*109   No maintenance authorization for cross-client tables (see Help)
*
* Message class: TK
*430   Client &1 has status 'not modifiable'
*729   Changes to repository objects are not permitted in this client
*730   Changes to repository or cross-client customizing are not permitted
*731   Cross-client customizing cannot be modified
*
* Message class: VIM_ALE_MSGID
*VIM
*
* Message class: VIM_AUTH_MSGID
*VIM
*
* Message class: ZMCB1
*417   ## ### # ### ####.
