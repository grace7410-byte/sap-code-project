*&---------------------------------------------------------------------*
*& Report ZZBP_INVOICE_DATA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzbp_invoice_data.

DATA: ok_code       TYPE sy-ucomm,
      gv_first_time TYPE char1 VALUE 'X',
      gv_invoice    TYPE char1
*      gs_selected_item TYPE ty_item
      .

*&---------------------------------------------------------------------*
*& ## ## (ZTB1MM0013)
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_head,
         belnr  TYPE ztb1mm0013-belnr,   " ## ## ##
         gjahr  TYPE ztb1mm0013-gjahr,   " ## ## ##
         bldat  TYPE ztb1mm0013-bldat,   " ## ##
         budat  TYPE ztb1mm0013-budat,   " ## ##
         zfbdt  TYPE ztb1mm0013-zfbdt,   " ## ###
         zterm  TYPE ztb1mm0013-zterm,   " ## ##
         bpid   TYPE ztb1mm0013-bpid,    " BP ID
         bptyp  TYPE ztb1mm0013-bptyp,   " BP ##
         bukrs  TYPE ztb1mm0013-bukrs,   " ## ##
         bktxt  TYPE ztb1mm0013-bktxt,   " ## ## ###
         dmbtr  TYPE ztb1mm0013-dmbtr,   " # ####(##)
         waersk TYPE ztb1mm0013-waersk,  " ## ##
         wrbtr  TYPE ztb1mm0013-wrbtr,   " # ####(####)
         waers  TYPE ztb1mm0013-waers,   " ## ##
         ebeln  TYPE ztb1mm0013-ebeln,   " #### ##
         mblnr  TYPE ztb1mm0013-mblnr,   " ## ## ##
         rbstat TYPE ztb1mm0013-rbstat,  " ## ## (X, A, B #)
         lvorm  TYPE ztb1mm0013-lvorm,   " ####
         ernam  TYPE ztb1mm0013-ernam,   " ###
         erdat  TYPE ztb1mm0013-erdat,   " ###
         erzet  TYPE ztb1mm0013-erzet,   " ####
         aenam  TYPE ztb1mm0013-aenam,   " ###
         aedat  TYPE ztb1mm0013-aedat,   " ###
         aezet  TYPE ztb1mm0013-aezet,   " ####
       END OF ty_head.

DATA: gs_head        TYPE ty_head,
      gs_select_head TYPE ty_head,
      gt_head        TYPE TABLE OF ty_head. " ### ALV# ### ###

*&---------------------------------------------------------------------*
*& #### ### (ZTB1MM0007)
*&---------------------------------------------------------------------*

TYPES: BEGIN OF ty_item,
         ebeln      TYPE ztb1mm0007-ebeln,  " #### ##
         ebelp      TYPE ztb1mm0007-ebelp,  " #### ## ##
         matnr      TYPE ztb1mm0007-matnr,  " ####
         werks      TYPE ztb1mm0007-werks,  " ### ##
         lgort      TYPE ztb1mm0007-lgort,  " ####
         menge      TYPE i,  " ## ##
         meins      TYPE ztb1mm0007-meins,  " ## ##
         netpr      TYPE ztb1mm0007-netpr,  " ##
         dmbtr      TYPE ztb1mm0007-dmbtr,  " # ####(##)
         waersk     TYPE ztb1mm0007-waersk, " ##(##)
         wrbtr      TYPE ztb1mm0007-wrbtr,  " # ####(####)
         waers      TYPE ztb1mm0007-waers,  " ##
         add_ukurs  TYPE zcds_b1_mm_0002-add_ukurs, " CDS View ## # ### ## ##
         netpr_usd  TYPE ztb1mm0012-wrbtr, " #### ##(## ##### ##)
         mwskz      TYPE ztb1mm0007-mwskz,  " ## ##
         eindt      TYPE ztb1mm0007-eindt,  " ## ###
         slfdt      TYPE ztb1mm0007-slfdt,  " ## ###
         insmk      TYPE ztb1mm0007-insmk,  " ## ##
         packno     TYPE ztb1mm0007-packno, " ### ### ##
         knttp      TYPE ztb1mm0007-knttp,  " ## ##
         sakto      TYPE ztb1mm0007-sakto,  " ## ##
         epstp      TYPE ztb1mm0007-epstp,  " ### ####
         mblnr      TYPE ztb1mm0012-mblnr,  " ###### ## (####)
         postat     TYPE ztb1mm0007-postat, " #### ##
         lvorm      TYPE ztb1mm0007-lvorm,  " ## ##
         erdat      TYPE ztb1mm0007-erdat, " ###
         erzet      TYPE ztb1mm0007-erzet, " ####
         ernam      TYPE ztb1mm0007-ernam, " ###
         aedat      TYPE ztb1mm0007-aedat, " ###
         aezet      TYPE ztb1mm0007-aezet, " ####
         aenam      TYPE ztb1mm0007-aenam, " ###
         load_gr    TYPE char1, " #### ##
         invoice    TYPE char1, " ####(#####) ##
         cell_color TYPE lvc_t_scol,
         line_color TYPE char4,
       END OF ty_item.

DATA: gs_selected_item TYPE ty_item,
      gt_item          TYPE TABLE OF ty_item. " ### ALV# ### ###

*&---------------------------------------------------------------------*
*& 100# ### ALV ## ## ## (#### ###)
*&---------------------------------------------------------------------*
DATA: go_cont TYPE REF TO cl_gui_custom_container,
      go_alv  TYPE REF TO cl_gui_alv_grid.

DATA: gs_variant TYPE disvariant,
      gs_stable  TYPE lvc_s_stbl,
      gs_layout  TYPE lvc_s_layo,  "layout
      gt_uifunc  TYPE ui_functions.

DATA: gt_fcat_item TYPE lvc_t_fcat.
*      gs_fcat TYPE lvc_s_fcat " #### ##### ### FNAME, FVALUE #### itab# APPEND### #####

DATA: gv_col_pos TYPE int4, " gs_fcat-col_pos ## ## ## ##
      gv_visible TYPE char1. " item overview(## ##) ## ## # ##

**********************************************************************

IF gv_first_time = 'X'.
  CLEAR gv_first_time. " #### # ## ### ##

  SELECT * FROM zcds_b1_mm_0002( p_bldat = @sy-datum )
    INTO CORRESPONDING FIELDS OF TABLE @gt_item.
*    WHERE lvorm <> 'X'.
   " AND bsart = 'NB'.

  " [## ##] # #### #### / #### ## ## # ### ##
  IF gt_item[] IS NOT INITIAL.
    DATA: lt_mat_check     TYPE TABLE OF ztb1mm0012,
          ls_mat_check     TYPE ztb1mm0012,
          lt_invoice_check TYPE TABLE OF ztb1mm0013,
          ls_invoice_check TYPE ztb1mm0013.

    DATA: lt_color TYPE lvc_t_scol,
          ls_color TYPE lvc_s_scol.

    SELECT ebeln, bpid
          FROM ztb1mm0013
          INTO CORRESPONDING FIELDS OF TABLE @lt_invoice_check
          FOR ALL ENTRIES IN @gt_item
         WHERE ebeln = @gt_item-ebeln
           AND lvorm <> 'X'.

    SORT lt_invoice_check BY ebeln bpid.

    LOOP AT gt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
      " # ## #### ### ## #### #### ## ###
      CLEAR: lt_color, ls_color, lt_mat_check, <fs_item>-line_color.

      SELECT mblnr, mjahr, bwart, insmk
        FROM ztb1mm0012
        INTO CORRESPONDING FIELDS OF TABLE @lt_mat_check
       WHERE ebeln = @<fs_item>-ebeln
         AND lvorm <> 'X'.

      " ####(bwart)# ####(insmk)# #### ### ##
      LOOP AT lt_mat_check INTO ls_mat_check.
        " #### 101 + ### ##(T) = #### ##
        IF ls_mat_check-bwart = '101' AND ls_mat_check-insmk = 'T'.
          <fs_item>-load_gr = 'X'.
          EXIT. " #### #### ## ##
        ENDIF.
      ENDLOOP.

      READ TABLE lt_invoice_check INTO ls_invoice_check
        WITH KEY ebeln = <fs_item>-ebeln BINARY SEARCH.
      IF sy-subrc = 0.
        <fs_item>-invoice = 'X'.
      ENDIF.

      " 1) ##### ###### 'LOAD_GR' ## ## ###
      IF <fs_item>-load_gr = 'X'.
        ls_color-fname     = 'LOAD_GR'.
        ls_color-color-col = 5.
        ls_color-color-int = 0.
        APPEND ls_color TO lt_color.
      ENDIF.

      " 2) ## ### #### 'INVOICE' ## ## ###
      IF <fs_item>-invoice = 'X'.
        ls_color-fname     = 'INVOICE'.
        ls_color-color-col = 6.
        ls_color-color-int = 0.
        APPEND ls_color TO lt_color.
      ENDIF.

      " 3) ## ## # ## #### ## ##
      <fs_item>-cell_color = lt_color.

      IF gs_selected_item-ebeln IS NOT INITIAL
               AND <fs_item>-ebeln = gs_selected_item-ebeln.

        <fs_item>-line_color = 'C100'. "
        <fs_item>-invoice    = 'X'.    " ## #### ### 'X'# ## ####
      ENDIF.

    ENDLOOP.

    SORT gt_item BY ebeln.
  ENDIF.
ENDIF.

**********************************************************************
START-OF-SELECTION.
  CALL SCREEN 100.

**********************************************************************
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    " alv ## ## ### ## # #### ###
    CLASS-METHODS:
    " # #### #
    on_double_click FOR EVENT double_click
      OF cl_gui_alv_grid IMPORTING e_row e_column es_row_no sender." sender# #### ## alv# ## #### #### # ##
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.

  METHOD on_double_click.
    CLEAR: gs_head, gs_select_head.
    IF e_row-index IS INITIAL OR e_row-index = 0.
      EXIT.
    ENDIF.

    PERFORM handle_double_click USING e_row-index.

    cl_gui_cfw=>set_new_ok_code(
      EXPORTING
        new_code = 'REFRESH' " PAI## 'REFRESH'# # # sy-ucomm# ### #### #### #
    ).
  ENDMETHOD.
ENDCLASS.

*&---------------------------------------------------------------------*
*& Form handle_double_click
*&---------------------------------------------------------------------*
FORM handle_double_click USING pv_row_index TYPE lvc_s_row-index.

  DATA: gs_selected_item LIKE LINE OF gt_item,
        lv_total_wrbtr   TYPE ztb1mm0013-wrbtr,
        lv_waers         TYPE ztb1mm0013-waers.

  CLEAR: gs_select_head, gv_invoice, gs_selected_item.

  READ TABLE gt_item INTO gs_selected_item INDEX pv_row_index.
  IF sy-subrc <> 0.
    EXIT.
  ENDIF.
  gv_invoice = gs_selected_item-invoice.

  gs_select_head-gjahr = sy-datum(4). " ## ## ##

  CLEAR: gs_select_head-bldat,
         gs_select_head-budat,
         gs_select_head-zfbdt,
         gs_select_head-bktxt,
         gs_select_head-dmbtr,
         gs_select_head-waersk.

  SELECT SINGLE zterm, bpid, bukrs
    INTO ( @gs_select_head-zterm, @gs_select_head-bpid, @gs_select_head-bukrs )
    FROM ztb1mm0006
   WHERE ebeln = @gs_selected_item-ebeln.

  IF gs_select_head-bpid CP 'BP1*'.
    gs_select_head-bptyp = '1'.
  ELSEIF gs_select_head-bpid CP 'BP3*'.
    gs_select_head-bptyp = '3'.
  ELSEIF gs_select_head-bpid CP 'BP4*'.
    gs_select_head-bptyp = '4'.
  ENDIF.

  DATA: lt_po_items TYPE TABLE OF ztb1mm0007.

  " CDS # ### ## ##
  DATA: lv_bedat     TYPE sy-datum,
        lv_zfrt      TYPE p LENGTH 13 DECIMALS 2, " ## ## (USD)
        lv_add_ukurs TYPE p LENGTH 9 DECIMALS 4,  " ##
        lv_days      TYPE p LENGTH 8 DECIMALS 2,  " ## ## ###
        lv_cal_dmbtr TYPE p LENGTH 16 DECIMALS 2. " ##### ## ##

  CLEAR: lv_total_wrbtr, lv_waers.

  " ## ##### #### ## #### ## ##
  SELECT ebelp, wrbtr, waers, netpr, dmbtr
    FROM ztb1mm0007
    INTO CORRESPONDING FIELDS OF TABLE @lt_po_items
   WHERE ebeln = @gs_selected_item-ebeln
     AND lvorm <> 'X'.

  SELECT SINGLE bedat INTO @lv_bedat FROM ztb1mm0006
 WHERE ebeln = @gs_selected_item-ebeln. " ### ####,,,
*    lv_bedat = lv_bedat + 1. " ## ## cds ### ### ## # #### ## => ## #### +1 #### #..

  " #### ### ## ### ## ## # #### ##
  IF lt_po_items[] IS NOT INITIAL.
    LOOP AT lt_po_items ASSIGNING FIELD-SYMBOL(<fs_po_item>).
      " [## ##] 1 - ##### ##### # ####
      IF ( <fs_po_item>-wrbtr IS INITIAL OR <fs_po_item>-wrbtr = 0 ) " USD ## ## # ## ### # ###
         AND ( <fs_po_item>-dmbtr IS INITIAL OR <fs_po_item>-dmbtr = 0 " #### ##### # ## ##
         OR <fs_po_item>-netpr IS INITIAL OR <fs_po_item>-netpr = 0 ). " ## # ##...
        CONTINUE.
      ENDIF.

      IF <fs_po_item>-wrbtr IS INITIAL OR <fs_po_item>-wrbtr = 0. "## ## ### ###,,,

        SELECT SINGLE zfrt, add_ukurs
            FROM zcds_b1_mm_0001( p_bedat = @lv_bedat )
            INTO ( @lv_zfrt, @lv_add_ukurs ).

        IF sy-subrc = 0 AND lv_add_ukurs > 0 AND <fs_po_item>-netpr > 0.
          " ##(dmbtr) / ##(netpr) = ## ##(Days) ###
          lv_days = <fs_po_item>-dmbtr / <fs_po_item>-netpr.

          " ## ##(zfrt) * ##(lv_days) = ## wrbtr
          <fs_po_item>-wrbtr = lv_zfrt * lv_days.

          " ### ##### ## ## ###
          " ## wrbtr# ##(add_ukurs)# ### ## ## ##(dmbtr)# ##### ##
          " ### ## #### #### 0.5# ## ## ##### # # ## round #### ## ##
          lv_cal_dmbtr = round( val = ( <fs_po_item>-wrbtr * lv_add_ukurs ) dec = 0 ).
          DATA: lv_diff TYPE p LENGTH 8 DECIMALS 2.
          lv_diff = abs( lv_cal_dmbtr - <fs_po_item>-dmbtr ).

          IF lv_diff <= 5. " ## ## ##

            " ### ###(###)# ## # ##
            <fs_po_item>-waers = 'USD'.

            " [# DB ##] #### ### ####.. ## ### ##
            " [## ##] 2 - ## ### ##### # ##!
            UPDATE ztb1mm0007
               SET wrbtr = @<fs_po_item>-wrbtr,
                   waers = @<fs_po_item>-waers
             WHERE ebeln = @gs_selected_item-ebeln
               AND ebelp = @<fs_po_item>-ebelp.

            IF sy-subrc = 0.
              COMMIT WORK. " DB# ## ## ##!

              lv_total_wrbtr = lv_total_wrbtr + <fs_po_item>-wrbtr. " ### ### ####
            ELSE.
              ROLLBACK WORK.
              MESSAGE |#### { gs_selected_item-ebeln }# ### ## ##! DB ### ## ## ###|
             TYPE 'S' DISPLAY LIKE 'E'.
            ENDIF.

          ELSE.
            MESSAGE |#### { gs_selected_item-ebeln }# ### ## ## ##! (## ##) DB ### ## ## ###|
              TYPE 'S' DISPLAY LIKE 'E'.
          ENDIF.
        ENDIF.
      ELSE.
        lv_total_wrbtr = lv_total_wrbtr + <fs_po_item>-wrbtr.

        IF lv_waers IS INITIAL.
          lv_waers = <fs_po_item>-waers.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  gs_select_head-wrbtr = lv_total_wrbtr.
  gs_select_head-waers = lv_waers.

  " ### ### #### #### ###
  CLEAR: gs_select_head-dmbtr.

  gs_select_head-ebeln = gs_selected_item-ebeln.

  IF gs_selected_item-load_gr = 'X'.
    SELECT SINGLE mblnr
      INTO @gs_selected_item-mblnr
      FROM ztb1mm0012
     WHERE ebeln = @gs_selected_item-ebeln
       AND bwart = '101'
       AND insmk = 'T'
       AND lvorm <> 'X'
      AND zeile = '0010'.
  ENDIF.

  IF gs_select_head-mblnr IS INITIAL.
    gs_select_head-mblnr = gs_selected_item-mblnr.
  ENDIF.

  gs_select_head-rbstat = 'X'.
  gs_select_head-ernam = sy-uname.
  gs_select_head-erdat = sy-datum.
  gs_select_head-erzet = sy-uzeit.

*  gs_head = gs_select_head.
ENDFORM.
*&---------------------------------------------------------------------*
*& Module INIT_ALV OUTPUT (100# ### ALV ### ##)
*&---------------------------------------------------------------------*
MODULE init_alv OUTPUT.
  "2. 100# ### Layout# Area ## (1# alv - custom cont)
  IF go_cont IS INITIAL.
    "3. ## Container# ##### ####, ## ### (cont, alv ## ##)
    CREATE OBJECT go_cont
      EXPORTING                             " Parent container
        container_name = 'AREA'.

    CREATE OBJECT go_alv
      EXPORTING
        i_parent = go_cont.

    PERFORM set_fcat CHANGING gt_fcat_item.
    gs_layout-info_fname = 'LINE_COLOR'.
    gs_layout-ctab_fname = 'CELL_COLOR'.

    " ### ### ##
    SET HANDLER lcl_event_handler=>on_double_click FOR go_alv.

    "5. # ## ####
    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
        is_layout            = gs_layout  " #### ###
        it_toolbar_excluding = gt_uifunc  " ## ##
      CHANGING
        it_outtab            = gt_item  " ######## ##
        it_fieldcatalog      = gt_fcat_item.   " i_structure ### ### ###
  ELSE.
    " 3-2. ## ###### refresh#
    gs_stable-row = 'X'. " ##### # ## ### ## ##
    gs_stable-col = 'X'. " ## ## ##
    CALL METHOD go_alv->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = 'X' "x: ##, ##, ## ### ## -> ### #### #####
      EXCEPTIONS            "_: ## ####(##)
        finished       = 1
        OTHERS         = 2.
  ENDIF.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT (100# ### Status)
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100'.

  gs_head = gs_select_head.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'CANCEL'. " ## #
      LEAVE TO SCREEN 0. " ####
    WHEN 'EXIT'. " ## #
      LEAVE PROGRAM.    " ##### #### SAP ## #### ##
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.

MODULE user_command_0100 INPUT.
  DATA: lv_answer TYPE c.

  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN '10%'.
      IF gs_head-bptyp <> '1'.
        MESSAGE '10% # ## ##' TYPE 'I'.
        CLEAR ok_code.
        EXIT.
      ENDIF.

      gs_select_head-bpid  = 'BP30000000'. " ## BP ## ##
      gs_select_head-bptyp = '3'.          " BP ## 3(##)## ##

      gs_select_head-wrbtr = gs_head-wrbtr * '0.1'.

      MESSAGE |##! ### #### - #### # ##:({ gs_head-wrbtr } { gs_head-waers })| TYPE 'S'.
      CLEAR ok_code.

    WHEN 'SAVE'.
      IF gv_invoice = 'X'.
        CLEAR lv_answer.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            titlebar              = '## ##'
            text_question         = '# ## ### ##### ###?'
            text_button_1         = 'yes'
            text_button_2         = '##'
            default_button        = '2'
            display_cancel_button = ' '
          IMPORTING
            answer                = lv_answer.

        IF lv_answer <> '1'.
          MESSAGE '## ## ##' TYPE 'S' DISPLAY LIKE 'E'.
          CLEAR ok_code.
          EXIT.
        ENDIF.
      ENDIF.

      PERFORM save_invoice_data.
      CLEAR ok_code.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.

FORM save_invoice_data.

  DATA: ls_invoice    TYPE ztb1mm0013,
        lv_next_belnr TYPE numc10.

  CLEAR: ls_invoice, lv_next_belnr.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = '01'
      object                  = 'ZNRB1MM05'
    IMPORTING
      number                  = lv_next_belnr
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
    MESSAGE '#### ## ## -> ####' TYPE 'I'.
    EXIT.
  ENDIF.

  MOVE-CORRESPONDING gs_head TO ls_invoice.
  ls_invoice-belnr  = lv_next_belnr.
  ls_invoice-gjahr  = sy-datum(4).
  ls_invoice-ernam  = sy-uname.
  ls_invoice-erdat  = sy-datum.
  ls_invoice-erzet  = sy-uzeit.
  ls_invoice-lvorm  = ''. " ## ## ## ###

  " [# ##]
  INSERT ztb1mm0013 FROM @ls_invoice.

  IF sy-subrc = 0.
    COMMIT WORK.
    MESSAGE '## #### ##### ###!' TYPE 'S'.

    " ## ## # 100# ### ## #### #### ###
    CLEAR: gs_head, gs_select_head, gv_invoice.

    gv_first_time = 'X'.
    cl_gui_cfw=>set_new_ok_code(
  EXPORTING
    new_code = 'REFRESH' " PAI## 'REFRESH'# # # sy-ucomm# ### #### #### #
).

  ELSE.
    ROLLBACK WORK.
    MESSAGE '## ### ##(DB ##)' TYPE 'E'.
  ENDIF.

ENDFORM.

*FORM set_fcat CHANGING pt_fcat TYPE lvc_t_fcat.
*  " ### ### ### ######
*  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
*    EXPORTING
*      i_structure_name = 'ZTB1MM0007'
*    CHANGING
*      ct_fieldcat      = pt_fcat.
*
*  " ####, ##### ## ### ###
*  DELETE pt_fcat WHERE fieldname = 'LVORM' OR
*                       fieldname = 'ERNAM' OR fieldname = 'ERDAT' OR
*                       fieldname = 'ERZET' OR fieldname = 'AENAM' OR
*                       fieldname = 'AEDAT' OR fieldname = 'AEZET'.
*
*  FIELD-SYMBOLS: <fs> TYPE lvc_s_fcat.
*  LOOP AT pt_fcat ASSIGNING <fs>.
*    IF <fs>-fieldname = 'DMBTR' OR
*    <fs>-fieldname = 'WAERSK' OR
*    <fs>-fieldname = 'NETPR'.
*      <fs>-no_out = 'X'.
*    ENDIF.
*  ENDLOOP.
*ENDFORM.

*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
FORM set_fcat CHANGING pt_fcat TYPE lvc_t_fcat.

  DATA: ls_fcat TYPE lvc_s_fcat.

  CLEAR pt_fcat.

  DEFINE _add_fcat.
    CLEAR ls_fcat.
    ls_fcat-fieldname = &1.
    ls_fcat-coltext   = &2.
    ls_fcat-outputlen = &3.
    IF &1 = 'DMBTR' OR &1 = 'NETPR'.   ls_fcat-cfieldname = 'WAERSK'. ENDIF.
    IF &1 = 'WRBTR' OR &1 = 'NETPR_USD'. ls_fcat-cfieldname = 'WAERS'. ENDIF.
*    IF &1 = 'LOAD_GR'. ls_fcat-emphasize = 'C100'. ENDIF.
    IF &1 = 'EBELN' OR &1 = 'EBELP'. ls_fcat-key = 'X'. ls_fcat-emphasize = 'C110'. ENDIF.
*    if &1 = 'MENGE'.   ls_fcat-qfieldname = 'MEINS'.  endif.
    APPEND ls_fcat TO pt_fcat.
  END-OF-DEFINITION.

  "        [FieldName]   [ColText (## ##)]     [OutputLen]
  _add_fcat 'LOAD_GR'     '#### ##'                8.
  _add_fcat 'INVOICE'     '### ##'                 8.
  _add_fcat 'EBELN'       '#### ##'               10.
  _add_fcat 'EBELP'       '## ##'                   5.
  _add_fcat 'MATNR'       '## ##'                   18.
  _add_fcat 'WERKS'       '###'                      4.
  _add_fcat 'LGORT'       '## ##'                   4.
  _add_fcat 'MENGE'       '## ##'                   10.
  _add_fcat 'MEINS'       '## ##'                   3.
  _add_fcat 'NETPR'       '## ##'                   12.
  _add_fcat 'DMBTR'       '# ####(##)'            15.
  _add_fcat 'WAERSK'      '##(##)'                  5.
  _add_fcat 'WRBTR'       '# ####(####)'         15.
  _add_fcat 'WAERS'       '## ##'                   5.
  _add_fcat 'ADD_UKURS'   '## ##'                   10.
  _add_fcat 'NETPR_USD'   '##(##)'                  12.
  _add_fcat 'MWSKZ'       '## ##'                   3.
  _add_fcat 'EINDT'       '## ###'                 10.
  _add_fcat 'SLFDT'       '## ###'                 10.
  _add_fcat 'INSMK'       '## ##'                   3.
*  _add_fcat 'PACKNO'      '### ### ##'           10.
*  _add_fcat 'KNTTP'       '## ## ##'               3.
*  _add_fcat 'SAKTO'       '## ##'                   10.
*  _add_fcat 'EPSTP'       '## ####'                3.
  _add_fcat 'POSTAT'      '#### ##'                3.

ENDFORM.

*GUI Texts
*----------------------------------------------------------
* T100 --> ## ### ~ >,,<


*Messages
*----------------------------------------------------------
*
* Message class: Hard coded
*   ####
