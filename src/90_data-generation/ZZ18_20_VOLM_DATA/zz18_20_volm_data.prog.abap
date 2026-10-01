*&---------------------------------------------------------------------*
*& Report ZZBP_INVOICE_DATA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zz18_20_volm_data.

DATA: ok_code       TYPE sy-ucomm,
      gv_first_time TYPE char1 VALUE 'X',
      gv_invoice    TYPE char1,
      gv_low        TYPE ztb1mm0020-ztemp,
      gv_high       TYPE ztb1mm0020-ztemp.
*      gs_selected_item TYPE ty_item

*----------------------------------------------------------------------*
* ## ## ### ### ### (ZTB1MM0018)
*----------------------------------------------------------------------*
TYPES: BEGIN OF ty_0018,
         ztemp    TYPE ztb1mm0018-ztemp,    " ## ## (DEC 5,2)
         zdens    TYPE ztb1mm0018-zdens,    " ## ## (DEC 5,2)
         zunit    TYPE ztb1mm0018-zunit,    " ## ## (CHAR 3) - Fixed: CEL
         zstd     TYPE ztb1mm0018-zstd,     " ## ## (DEC 5,2) - Fixed: 15
         zvcf     TYPE ztb1mm0018-zvcf,     " ## ## (DEC 7,4)
         lvorm    TYPE ztb1mm0018-lvorm,    " ## ## (CHAR 1)
         ernam    TYPE ztb1mm0018-ernam,    " ### (CHAR 12)
         erdat    TYPE ztb1mm0018-erdat,    " ### (DATS 8)
         erzet    TYPE ztb1mm0018-erzet,    " ## ## (TIMS 6)
         aenam    TYPE ztb1mm0018-aenam,    " ### (CHAR 12)
         aedat    TYPE ztb1mm0018-aedat,    " ### (DATS 8)
         aezet    TYPE ztb1mm0018-aezet,    " ## ## (TIMS 6)

         " CBO ## # ALV ### ## ## (### ##)
         col_fld  TYPE char4,               " ALV ## ## ##
         cell_tab TYPE lvc_t_styl,          " # #### ### ### ###
       END OF ty_0018.

*----------------------------------------------------------------------*
* ## ## ## ### ### (ZTB1MM0020)
*----------------------------------------------------------------------*
TYPES: BEGIN OF ty_0020,
         zmsno  TYPE ztb1mm0020-zmsno,    " ## ## (CHAR 10)
         zdocit TYPE ztb1mm0020-zdocit,   " ## ## ## (NUMC 4)
         zdocty TYPE ztb1mm0020-zdocty,   " ## ## (CHAR 2) - SO, PO, GR, GI
         zdocno TYPE ztb1mm0020-zdocno,   " ## ## (CHAR 10)
         zavol  TYPE ztb1mm0020-zavol,    " ## ## (QUAN 13,3)
         meins  TYPE ztb1mm0020-meins,    " ## ## (UNIT 3)
         ztemp  TYPE ztb1mm0020-ztemp,    " ## ## (DEC 5,2)
         zunit  TYPE ztb1mm0020-zunit,    " ## ## (CHAR 3)
         zdens  TYPE ztb1mm0020-zdens,    " ## ## (DEC 5,2)
         zvcf   TYPE ztb1mm0020-zvcf,     " ## ## (DEC 7,4)
         zsvol  TYPE ztb1mm0020-zsvol,    " ## ## (QUAN 13,3)
         zmdat  TYPE ztb1mm0020-zmdat,    " ## ## (DATS 8)
         lvorm  TYPE ztb1mm0020-lvorm,    " ## ## (CHAR 1)
         ernam  TYPE ztb1mm0020-ernam,    " ### (CHAR 12)
         erdat  TYPE ztb1mm0020-erdat,    " ### (DATS 8)
         erzet  TYPE ztb1mm0020-erzet,    " ## ## (TIMS 6)
         aenam  TYPE ztb1mm0020-aenam,    " ### (CHAR 12)
         aedat  TYPE ztb1mm0020-aedat,    " ### (DATS 8)
         aezet  TYPE ztb1mm0020-aezet,    " ## ## (TIMS 6)
       END OF ty_0020.

DATA: gs_head        TYPE ty_0020,
      gs_select_head TYPE ty_0020,
      gt_head        TYPE TABLE OF ty_0020.

*&---------------------------------------------------------------------*
*& #### ### (ZTB1MM0007)
*&---------------------------------------------------------------------*

TYPES: BEGIN OF ty_item,
         ebeln      TYPE ztb1mm0007-ebeln,  " #### ##
         zebelnsv   TYPE ztb1mm0006-zebelnsv,
         ebelp      TYPE ztb1mm0007-ebelp,  " #### ## ##
         matnr      TYPE ztb1mm0007-matnr,
         menge      TYPE ztb1mm0007-menge,  " ## ##
         meins      TYPE ztb1mm0007-meins,  " ## ##
         insmk      TYPE ztb1mm0007-insmk,  " ## ##
         postat     TYPE ztb1mm0007-postat, " #### ##
         lvorm      TYPE ztb1mm0007-lvorm,  " ## ##
         erdat      TYPE ztb1mm0007-erdat, " ###
         erzet      TYPE ztb1mm0007-erzet, " ####
         ernam      TYPE ztb1mm0007-ernam, " ###
         aedat      TYPE ztb1mm0007-aedat, " ###
         aezet      TYPE ztb1mm0007-aezet, " ####
         aenam      TYPE ztb1mm0007-aenam, " ###

         " --------------------------
         load_tran  TYPE icon_d,           " #### ## ## ### (# ###)
         plant_tran TYPE icon_d,           " ##### ## ## ### (# ###)
         count_volm TYPE int4,              " #### ## ## (0, 1, 2...)
         load_gr    TYPE icon_d,           " #### ## ### (## ###)
         plant_gr   TYPE icon_d,           " ##### ## ### (## ###)
         " --------------------------

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
*& # # ## ## #
**********************************************************************
*INCLUDE <icon>. " ICON_#, ICON_## ### ## ##

IF gv_first_time = 'X'.
  CLEAR gv_first_time.
  PERFORM get_po_data.
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

FORM get_po_data.
  " 0. CDS ### ## ### ## (## ### # ##)
  SELECT ebeln, ebelp, matnr, menge, meins, insmk, postat, lvorm,
         erdat, erzet, ernam, aedat, aezet, aenam
    FROM zcds_b1_mm_0002( p_bldat = @sy-datum )
    INTO CORRESPONDING FIELDS OF TABLE @gt_item
   WHERE lvorm <> 'X'
    AND bsart = 'NB'.

  IF gt_item[] IS NOT INITIAL.

    " ----------------------------------------------------------------------
    " [Buffer 1] #### ## ## (BSART = 'NB' ### # #### ###)
    " ----------------------------------------------------------------------
    DATA: BEGIN OF ls_po_hdr,
            ebeln    TYPE ztb1mm0006-ebeln,
            bsart    TYPE ztb1mm0006-bsart,    " [##] ## ## ##
            zebelnsv TYPE ztb1mm0006-zebelnsv, " ### ## #######
          END OF ls_po_hdr,
          lt_po_hdr LIKE TABLE OF ls_po_hdr.

    " [## ##] bwart# ### ### ## ### bsart = 'NB' #### #####.
    " (# ## ## #### ## #### bwart## ## bsart# bwart# #####!)
    SELECT ebeln, bsart, zebelnsv
      FROM ztb1mm0006
      INTO CORRESPONDING FIELDS OF TABLE @lt_po_hdr
       FOR ALL ENTRIES IN @gt_item
     WHERE ebeln = @gt_item-ebeln
       AND bsart = 'NB'. " # ## ####(NB) ### ####
    SORT lt_po_hdr BY ebeln.

    " ----------------------------------------------------------------------
    " [Buffer 2] ## ## ## ## ## (ZTB1MM0020)
    " ----------------------------------------------------------------------
    DATA: BEGIN OF ls_volm_raw,
            zmsno  TYPE ztb1mm0020-zmsno,
            zdocno TYPE ztb1mm0020-zdocno,
            zdocit TYPE ztb1mm0020-zdocit,
          END OF ls_volm_raw,
          lt_volm_raw LIKE TABLE OF ls_volm_raw.

    DATA: BEGIN OF ls_volm_cnt,
            zdocno TYPE ztb1mm0020-zdocno,
            zdocit TYPE ztb1mm0020-zdocit,
            count  TYPE int4,
          END OF ls_volm_cnt,
          lt_volm_cnt LIKE TABLE OF ls_volm_cnt.

    SELECT zmsno,zdocno, zdocit
      FROM ztb1mm0020
      INTO CORRESPONDING FIELDS OF TABLE @lt_volm_raw
       FOR ALL ENTRIES IN @gt_item
     WHERE zdocno = @gt_item-ebeln
       AND zdocit = @gt_item-ebelp
       AND lvorm  <> 'X'.

    LOOP AT lt_volm_raw INTO ls_volm_raw.
      CLEAR ls_volm_cnt.
      ls_volm_cnt-zdocno = ls_volm_raw-zdocno.
      ls_volm_cnt-zdocit = ls_volm_raw-zdocit.
      ls_volm_cnt-count  = 1. " COLLECT# ### ## #(##+##)# ## # ## ##(+)#

      COLLECT ls_volm_cnt INTO lt_volm_cnt.
    ENDLOOP.

    SORT lt_volm_cnt BY zdocno zdocit.

    " ----------------------------------------------------------------------
    " [Buffer 3] ###### ## ### ## (ZTB1MM0012)
    " ----------------------------------------------------------------------
    DATA: lt_mat_check TYPE TABLE OF ztb1mm0012,
          ls_mat_check TYPE ztb1mm0012.

    SELECT ebeln, ebelp, bwart, insmk
      FROM ztb1mm0012
      INTO CORRESPONDING FIELDS OF TABLE @lt_mat_check
       FOR ALL ENTRIES IN @gt_item
     WHERE ebeln = @gt_item-ebeln
       AND ebelp = @gt_item-ebelp
       AND lvorm <> 'X'.
    SORT lt_mat_check BY ebeln ebelp.


    " ----------------------------------------------------------------------
    " [Main Loop] ### ## # ## # ## ##
    " ----------------------------------------------------------------------
    DATA: lt_color TYPE lvc_t_scol,
          ls_color TYPE lvc_s_scol.

    LOOP AT gt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
      CLEAR: lt_color, ls_color.

      "-----------------------------------------------------------------
      " ## 1) ## ## ## ## (NB ### # ZEBELNSV ## ##)
      "-----------------------------------------------------------------
      READ TABLE lt_po_hdr INTO ls_po_hdr WITH KEY ebeln = <fs_item>-ebeln BINARY SEARCH.
      IF sy-subrc = 0.
        " [## ##] #### ## ## #### ## #### ### ## ##!
        <fs_item>-zebelnsv = ls_po_hdr-zebelnsv.

        IF ls_po_hdr-zebelnsv IS NOT INITIAL.
          <fs_item>-load_tran  = icon_ws_ship. " ## ####
          <fs_item>-plant_tran = icon_ws_ship. " ### ####

          " #### # ## ## (5# ##)
          ls_color-fname     = 'ZEBELNSV'.
          ls_color-color-col = 5.
          ls_color-color-int = 0.
          APPEND ls_color TO lt_color.

*          " LOAD_TRAN # ## ## (5# ##)
*          ls_color-fname     = 'LOAD_TRAN'.
*          ls_color-color-col = 5.
*          ls_color-color-int = 0.
*          APPEND ls_color TO lt_color.
*
*          " PLANT_TRAN # ## ## (5# ##)
*          ls_color-fname     = 'PLANT_TRAN'.
*          ls_color-color-col = 5.
*          ls_color-color-int = 0.
*          APPEND ls_color TO lt_color.
        ELSE.
          " #######(####)# ### #### ### X ### ##
          <fs_item>-load_tran = icon_cancel.
          CLEAR <fs_item>-plant_tran.
        ENDIF.

      ELSE.
        " lt_po_hdr# ### ## ## ### 'NB'# #### #### ## ### ## ### #
        " (## # #### ## ### DELETE ### ## ## ####. ## ### ###)
        CLEAR: <fs_item>-load_tran, <fs_item>-plant_tran, <fs_item>-zebelnsv.
      ENDIF.

      "-----------------------------------------------------------------
      " ## 2) #### ## ## ## -> ## ## + ## ### ###(C600)
      "-----------------------------------------------------------------
      READ TABLE lt_volm_cnt INTO ls_volm_cnt
        WITH KEY zdocno = <fs_item>-ebeln
                 zdocit = <fs_item>-ebelp BINARY SEARCH.
      IF sy-subrc = 0.
        <fs_item>-count_volm = ls_volm_cnt-count.

        IF <fs_item>-count_volm > 1.
          ls_color-fname     = 'COUNT_VOLM'.
          ls_color-color-col = 6.
          ls_color-color-int = 0.
          APPEND ls_color TO lt_color.
        ENDIF.
      ELSE.
        <fs_item>-count_volm = 0.
      ENDIF.

      "-----------------------------------------------------------------
      " ## 3) ## ## ## (#### #### ##) -> ## ### + ###(C300)
      "-----------------------------------------------------------------
      READ TABLE lt_mat_check TRANSPORTING NO FIELDS
        WITH KEY ebeln = <fs_item>-ebeln
                 ebelp = <fs_item>-ebelp BINARY SEARCH.

      IF sy-subrc = 0.
        LOOP AT lt_mat_check INTO ls_mat_check FROM sy-tabix.
          IF ls_mat_check-ebeln <> <fs_item>-ebeln OR ls_mat_check-ebelp <> <fs_item>-ebelp.
            EXIT.
          ENDIF.

          " A. ####: #### 101 AND #### T -> ## ### + ###
          IF ls_mat_check-bwart = '101' AND ls_mat_check-insmk = 'T'.
            <fs_item>-load_gr   = icon_warehouse.

            ls_color-fname     = 'LOAD_GR'.
            ls_color-color-col = 3.
            ls_color-color-int = 0.
            APPEND ls_color TO lt_color.
          ENDIF.

          " B. ####: #### (321 OR 551) AND #### NOT T -> ## ### + ###
          IF ( ls_mat_check-bwart = '321' OR ls_mat_check-bwart = '551' )
             AND ls_mat_check-insmk <> 'T'.
            <fs_item>-plant_gr  = icon_warehouse.

            ls_color-fname     = 'PLANT_GR'.
            ls_color-color-col = 3.
            ls_color-color-int = 0.
            APPEND ls_color TO lt_color.
          ENDIF.

        ENDLOOP. " #### ### ## ##
      ENDIF.

      " ## ## ## ## ### #### #(##) ## ####
      IF gs_selected_item-ebeln IS NOT INITIAL AND gs_selected_item-ebelp IS NOT INITIAL
               AND <fs_item>-ebeln = gs_selected_item-ebeln
               AND <fs_item>-ebelp = gs_selected_item-ebelp.

        ls_color-fname     = ' '.
        ls_color-color-col = 1.
        ls_color-color-int = 0.
        ls_color-color-inv = 0.
        APPEND ls_color TO lt_color.
      ENDIF.
      " ## ## # ## ### #### ##
      <fs_item>-cell_color = lt_color.

    ENDLOOP.

    SORT gt_item BY ebeln ebelp.
  ENDIF.

ENDFORM.
*
*&---------------------------------------------------------------------*
*& Form handle_double_click
*&---------------------------------------------------------------------*
FORM handle_double_click USING pv_row_index TYPE lvc_s_row-index.

  DATA: lv_today_str TYPE c LENGTH 6,
        lv_prefix    TYPE c LENGTH 8,
        lv_like_str  TYPE string,
        lv_max_seq   TYPE numc2,
        lv_new_seq   TYPE numc2,
        lv_max_no    TYPE ztb1mm0020-zmsno. " ## ##(ZMSNO) #### ##

  " ABAP ## Float ## ## ## (## ## ##)
  DATA: lo_rand_float TYPE REF TO cl_abap_random_float,
        lv_rand_val   TYPE f.

  CLEAR: gs_select_head, gs_selected_item.

  " 1. ALV## #### ##### ## ### ##
  READ TABLE gt_item INTO gs_selected_item INDEX pv_row_index.
  IF sy-subrc <> 0.
    EXIT.
  ENDIF.

  lv_today_str = sy-datum+2(6).                  " YYMMDD ## (#: 260522)
  CONCATENATE 'MS' lv_today_str INTO lv_prefix.  " #: 'MS260522'
  CONCATENATE lv_prefix '%' INTO lv_like_str.    " LIKE ### 'MS260522%'

  " ## ### ## ## (#### ##)
  gs_select_head-zdocit   = gs_selected_item-ebelp.                          " ## ## ##
  gs_select_head-zdocno   = gs_selected_item-ebeln.          " ## ## = #### ##(EBELN)

  " ----------------------------------------------------------------------
  " 2. [## ##] ## # # ## # ### ## # ## ##(ZDOCTY) ##
  " ----------------------------------------------------------------------

  " STEP 1: ## ### # ##### ## ## #### ### ### ## ##
  SELECT SINGLE zmsno, zdocty
    FROM ztb1mm0020
    INTO ( @gs_select_head-zmsno, @gs_select_head-zdocty )
   WHERE zmsno  LIKE @lv_like_str
     AND zdocno = @gs_selected_item-ebeln
     AND lvorm  <> 'X'.

  IF sy-subrc = 0 AND gs_select_head-zmsno IS NOT INITIAL.
    " [# A] ## ## ## ### ### ## # ## ### ## ##(PO-1 ## PO-2)# ### ##!
    " ## ## ### ## ## ### #####.
  ELSE.

    " STEP 2: ## ## ##! #### '##(## ##)'# # ##### ## ## ### ##
    SELECT SINGLE zmsno
      FROM ztb1mm0020
      INTO @lv_max_no
     WHERE zmsno  NOT LIKE @lv_like_str  " ## ##(MS260522)# ## # #
       AND zdocno = @gs_selected_item-ebeln " # #### ### #
       AND lvorm  <> 'X'.

    IF sy-subrc = 0.
      " [# B] ## ### ####? ## ### # ## ##### 'PO-2'(####) ##!
      gs_select_head-zdocty = 'PO-2'.
    ELSE.
      " [# C] ## ## ## ## ## ##? ## ## ## ### #### 'PO-1'(####) ##!
      gs_select_head-zdocty = 'PO-1'.
    ENDIF.

    " STEP 3: ### ## ##(ZMSNO) ## ## ##
    CLEAR lv_max_no.
    SELECT MAX( zmsno )
      FROM ztb1mm0020
      INTO @lv_max_no
     WHERE zmsno LIKE @lv_like_str.

    IF sy-subrc = 0 AND lv_max_no IS NOT INITIAL.
      lv_max_seq = lv_max_no+8(2).               " ## ### ### ### ## ## + 1
      lv_new_seq = lv_max_seq + 1.
    ELSE.
      lv_new_seq = '01'.                         " ## ## # #### 01# ##
    ENDIF.

    CONCATENATE lv_prefix lv_new_seq INTO gs_select_head-zmsno.
  ENDIF.

  " ----------------------------------------------------------------------
  " 3. [##] ### ### ####(GS_select_HEAD)# ### ###
  " ----------------------------------------------------------------------

  " ## # ## ##
  CLEAR gs_select_head-zavol.                                " ## ## ## ### ####
  gs_select_head-zsvol    = gs_selected_item-menge.          " # ##: ##### #### ### ##(##) ##
  gs_select_head-meins    = gs_selected_item-meins.          " # ##: #### ### ## ### ##

  " ## # #### ##
  gs_select_head-zunit    = 'CEL'.                           " # ##: ## ## CEL ##(####)
  PERFORM set_dens_data USING    gs_selected_item
                        CHANGING gs_select_head-zdens.        " ### ## ###
  " (1) ### ## #### #### ##
  PERFORM get_season_temp_range CHANGING gv_low
                                         gv_high.

  " (2) ABAP ## Float ## ## ## # ## ## ##
  lo_rand_float = cl_abap_random_float=>create( seed = cl_abap_random=>seed( ) ).

  " get_next #### 0.0000... ## 1.0000... ### ### ### #####.
  lv_rand_val   = lo_rand_float->get_next( ).

  " (3) [## ##] Low## High# ### ### ## ##
  "     ##: ### + ( (### - ###) * #### )
  "     F ## ## # GS_SELECT_HEAD-ZTEMP(DEC 5,2)# ### # ### 2### ## #####.
  gs_select_head-ztemp = gv_low + ( ( gv_high - gv_low ) * lv_rand_val ).

*  CLEAR: gs_select_head-ztemp,                                " ## # ## ####
  CLEAR  gs_select_head-zvcf.                               " #### ####

  " #### #### ##
  CLEAR gs_select_head-lvorm.
  gs_select_head-zmdat    = sy-datum.                        " ###
  gs_select_head-ernam    = sy-uname.                        " ###
  gs_select_head-erdat    = sy-datum.                        " ###
  gs_select_head-erzet    = sy-uzeit.                        " ####

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
        i_soft_refresh = ' ' "x: ##, ##, ## ### ## -> ### #### #####
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

  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

    WHEN 'CAL_VCF'.
      gs_select_head = gs_head. " ### ### # #### ###
      CLEAR: gs_head.

      IF gs_select_head-zdens IS INITIAL OR gs_select_head-zdens = 0.
        MESSAGE '## ##' TYPE 'I'.
        EXIT.
      ENDIF.

      IF gs_select_head-ztemp IS INITIAL.
        MESSAGE '## ##' TYPE 'I'.
        EXIT.
      ENDIF.

      DATA: lv_rounded_temp TYPE ztb1mm0020-ztemp.

      lv_rounded_temp = round( val = gs_select_head-ztemp dec = 1 ).

      CLEAR gs_select_head-zvcf.
      SELECT SINGLE zvcf
        FROM ztb1mm0018
        INTO @gs_select_head-zvcf
       WHERE zdens = @gs_select_head-zdens
         AND ztemp = @lv_rounded_temp.

      IF sy-subrc <> 0 OR gs_select_head-zvcf IS INITIAL.
        CLEAR gs_select_head-zvcf.
        MESSAGE '## ## ### ###. ### -5# ## 40# ### #####'
        TYPE 'S' DISPLAY LIKE 'E'.
        EXIT.
      ELSE.
        MESSAGE '## ##(VCF) ## ##' TYPE 'S'.
      ENDIF.

      " ### # ### ## PBO ## ##
      cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'REFRESH' ).

    WHEN 'CAL_AVOL'.
      IF gs_head-zvcf IS INITIAL OR gs_head-zvcf = 0.
        MESSAGE '#### ##' TYPE 'I'.
        EXIT.
      ENDIF.

      IF gs_head-zsvol IS INITIAL OR gs_head-zsvol = 0.
        MESSAGE '#### ##' TYPE 'I'.
        EXIT.
      ENDIF.

      gs_select_head = gs_head.
      CLEAR: gs_head, gs_select_head-zavol.
      gs_select_head-zavol = gs_select_head-zsvol / gs_select_head-zvcf.

      MESSAGE '#### ## ##' TYPE 'S'.

      " ## #### ## ##
      cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'REFRESH' ).

    WHEN 'CAL_SVOL'.
      IF gs_head-zvcf IS INITIAL OR gs_head-zvcf = 0.
        MESSAGE '#### ##' TYPE 'I'.
        EXIT.
      ENDIF.

      IF gs_head-zavol IS INITIAL OR gs_head-zavol = 0.
        MESSAGE '#### ##' TYPE 'I'.
        EXIT.
      ENDIF.

      gs_select_head = gs_head.
      CLEAR: gs_head, gs_select_head-zsvol.
      gs_select_head-zsvol = gs_select_head-zavol * gs_select_head-zvcf.

      MESSAGE '#### ## ##' TYPE 'S'.

      " ## #### ## ##
      cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'REFRESH' ).

    WHEN 'SAVE'.
      DATA: lv_cancel_flag TYPE c LENGTH 1.

      " ZMSNO #### ### ####, ####
      PERFORM check_zmsno_data.

      CLEAR lv_cancel_flag.
      PERFORM confirm_volm_data CHANGING lv_cancel_flag. " ### #### # # # ####

      IF lv_cancel_flag = 'X'.
        CLEAR ok_code.
        EXIT. " ###(#### ### ### # ## ## # ## ##)
      ENDIF.
      PERFORM save_volm_data.
      CLEAR ok_code.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.

FORM confirm_volm_data CHANGING pv_cancel TYPE c.
  DATA: lv_answer TYPE c,
        lv_text   TYPE string. " ## #### ##

  " ----------------------------------------------------------------------
  " 1. ##, ##, ####, ####, #### ## # ## ### ## ####
  " ----------------------------------------------------------------------
  CLEAR lv_text.

  IF gs_head-ztemp IS INITIAL OR gs_head-ztemp = 0.
    lv_text = |{ lv_text } [## ##]|.
  ENDIF.

  IF gs_head-zdens IS INITIAL OR gs_head-zdens = 0.
    lv_text = |{ lv_text } [##]|.
  ENDIF.

  IF gs_head-zavol IS INITIAL OR gs_head-zavol = 0.
    lv_text = |{ lv_text } [## ##]|.
  ENDIF.

  IF gs_head-zsvol IS INITIAL OR gs_head-zsvol = 0.
    lv_text = |{ lv_text } [## ##]|.
  ENDIF.

  IF gs_head-zvcf IS INITIAL OR gs_head-zvcf = 0.
    lv_text = |{ lv_text } [## ##]|.
  ENDIF.

  IF lv_text IS NOT INITIAL.
    " ## ### ### ([## ##] [##] ### #######)
    lv_text = |{ lv_text } ## ##.... ## ### ### ###?|.

    CLEAR lv_answer.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = '## ### ## ##'
        text_question         = lv_text
        text_button_1         = 'YES ####'
        text_button_2         = '## ##'
        default_button        = '2'
        display_cancel_button = ' '
      IMPORTING
        answer                = lv_answer.

    IF lv_answer <> '1'.
      MESSAGE '## ### #### ## ##' TYPE 'S' DISPLAY LIKE 'E'.
      pv_cancel = 'X'. " ## ### ###### ### ##
      RETURN.          " # FORM# ## ##
    ENDIF.
  ENDIF.

  " ----------------------------------------------------------------------
  " 2. 1# ## ### ## ##, ####, ## ## ## ###
  " ----------------------------------------------------------------------
  " ## ### ### #### ## ### ##
  IF gs_selected_item-zebelnsv IS INITIAL.
    CLEAR lv_answer.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = '## ## ## ##'
        text_question         = '## ## ### ### ##?'
        text_button_1         = 'YES'
        text_button_2         = '## ##'
        default_button        = '2'
        display_cancel_button = ' '
      IMPORTING
        answer                = lv_answer.

    IF lv_answer <> '1'.
      MESSAGE '### ###' TYPE 'S' DISPLAY LIKE 'E'.
      pv_cancel = 'X'.
      RETURN.
    ENDIF.
  ENDIF.


  " ## ##(COUNT_VOLM) ### ## ## # ##(Loss) ##
  CASE gs_selected_item-count_volm.
    WHEN 0.
      CLEAR lv_answer.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = '#### ## ##'
          text_question         = '#### ##### ### ###?'
          text_button_1         = 'yes'
          text_button_2         = '##'
          default_button        = '1'
          display_cancel_button = ' '
        IMPORTING
          answer                = lv_answer.

      IF lv_answer <> '1'.
        MESSAGE '#### ## ##' TYPE 'S' DISPLAY LIKE 'E'.
        pv_cancel = 'X'.
        RETURN.
      ENDIF.

    WHEN 1.
      IF gs_selected_item-menge = gs_head-zsvol.
        " # ## ### ### ## ## ## ##
        CLEAR lv_answer.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            titlebar              = '####(## ##) ##'
            text_question         = '## ###### ### ##!!! ### #####?'
            text_button_1         = 'yes'
            text_button_2         = '##'
            default_button        = '1'
            display_cancel_button = ' '
          IMPORTING
            answer                = lv_answer.
      ELSE.
        " ## ### ## #### ## ##
        CLEAR lv_answer.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            titlebar              = '#### ## ##'
            text_question         = '#### ##### ### ###?'
            text_button_1         = 'yes'
            text_button_2         = '##'
            default_button        = '1'
            display_cancel_button = ' '
          IMPORTING
            answer                = lv_answer.
      ENDIF.

      IF lv_answer <> '1'.
        MESSAGE '#### ## ##' TYPE 'S' DISPLAY LIKE 'E'.
        pv_cancel = 'X'.
        RETURN.
      ENDIF.

    WHEN 2.
      CLEAR lv_answer.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = '## ## ##'
          text_question         = '## + ## ### ## ## ##### ### ###?'
          text_button_1         = 'yes### ##'
          text_button_2         = '## ##'
          default_button        = '2'
          display_cancel_button = ' '
        IMPORTING
          answer                = lv_answer.

      IF lv_answer <> '1'.
        MESSAGE '## ##' TYPE 'S' DISPLAY LIKE 'E'.
        pv_cancel = 'X'.
        RETURN.
      ENDIF.
  ENDCASE.
ENDFORM.

FORM save_volm_data.
  DATA: lv_dummy_msno TYPE ztb1mm0020-zmsno,
        ls_head       TYPE ztb1mm0020.

  CLEAR: lv_dummy_msno, ls_head.

  SELECT SINGLE zmsno
    FROM ztb1mm0020
    INTO @lv_dummy_msno
   WHERE zmsno  = @gs_head-zmsno
     AND zdocit = @gs_head-zdocit.

  IF sy-subrc = 0.
    " ## ##### ### #### ## # ## ##
    ROLLBACK WORK.
    MESSAGE '## ### ## ### ## ### DB# ##. ### # ##' TYPE 'I' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  gs_head-ernam = sy-uname. " ## #### ## ID (#: NCODE-B-08)
  gs_head-erdat = sy-datum. " ## ## (YYYYMMDD)
  gs_head-erzet = sy-uzeit. " ## ## (HHMMSS)

  MOVE-CORRESPONDING gs_head TO ls_head.
  MODIFY ztb1mm0020 FROM ls_head.

  IF sy-subrc = 0.
    COMMIT WORK.
    MESSAGE '##### ###' TYPE 'S'.

    CLEAR: gs_head,
           gs_select_head.
    PERFORM get_po_data.

    " ## #### ## ##
    cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'REFRESH' ).

  ELSE.
    ROLLBACK WORK.
    MESSAGE 'DB ## # ### ## ## ##.' TYPE 'E'.
  ENDIF.

ENDFORM.

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

    " ## ### ## ## ##
    IF &1 = 'EBELN' OR &1 = 'EBELP' .
      ls_fcat-emphasize = 'C110'. " # ## ## ##
    ENDIF.

    IF &1 = 'MENGE'.
      ls_fcat-qfieldname = 'MEINS'. " ## ## ##
    ENDIF.
    IF &1 = 'POSTAT'.
      ls_fcat-ref_table = 'ZTB1MM0007'.
      ls_fcat-ref_field = 'POSTAT'.
      ls_fcat-f4availabl = 'X'.
      ls_fcat-qfieldname = 'MEINS'. " ## ## ##
    ENDIF.
    IF &1 = 'COUNT_VOLM'.
      ls_fcat-no_zero = 'X'.
    ENDIF.

" [##] ### ## ## # ### ## ##
    IF &1 = 'LOAD_TRAN' OR &1 = 'PLANT_TRAN' OR &1 = 'LOAD_GR' OR &1 = 'PLANT_GR'.
      ls_fcat-icon = 'X'. "
      ls_fcat-just = 'C'. " ### ##
    ENDIF.

    APPEND ls_fcat TO pt_fcat.
  END-OF-DEFINITION.

  "          [FieldName]   [ColText (## ##)]     [OutputLen]
  _add_fcat 'EBELN'         '#### ##'            12.
  _add_fcat 'EBELP'         '####'                6.
  _add_fcat 'LOAD_TRAN'     '####'               6.
  _add_fcat 'PLANT_TRAN'    '####'              6.
  _add_fcat 'COUNT_VOLM'    '####'               6.
  _add_fcat 'LOAD_GR'       '####'               6.
  _add_fcat 'PLANT_GR'      '####'               6.
  _add_fcat 'MATNR'         '####'                18.
  _add_fcat 'MENGE'         '####'                12.
  _add_fcat 'MEINS'         '####'                5.
  _add_fcat 'INSMK'         '####'                5.
  _add_fcat 'POSTAT'        '##'                   10.
  _add_fcat 'ERDAT'         '###(###X)'            15.
  _add_fcat 'ZEBELNSV'      '#### ##'            12.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form set_dens_data
*&---------------------------------------------------------------------*
FORM set_dens_data USING ps_item TYPE ty_item CHANGING pv_dens TYPE ztb1mm0018-zdens.

  IF ps_item-matnr = 'ASP-200' OR ps_item-matnr = 'ASP-300' OR ps_item-matnr = 'BC-100'.
    pv_dens = '0.96'.

  ELSEIF ps_item-matnr = 'MAYA-100'.
    pv_dens = '0.92'.

  ELSEIF ps_item-matnr = 'DUBAI-100'.
    pv_dens = '0.87'.

  ELSEIF ps_item-matnr = 'DIE-200' OR ps_item-matnr = 'DIE-300'.
    pv_dens = '0.84'.

  ELSEIF ps_item-matnr = 'WTI-100'.
    pv_dens = '0.82'.

  ELSEIF ps_item-matnr = 'JET-200' OR ps_item-matnr = 'JET-300' OR
         ps_item-matnr = 'NAP-200' OR ps_item-matnr = 'NAP-300'.
    pv_dens = '0.79'.

  ELSEIF ps_item-matnr = 'GAS-200' OR ps_item-matnr = 'GAS-300'.
    pv_dens = '0.74'.

  ELSEIF ps_item-matnr = 'LPG-200' OR ps_item-matnr = 'LPG-300'.
    pv_dens = '0.55'.

  ELSEIF ps_item-matnr = 'NIMO' OR ps_item-matnr = 'ZEOL'.
    " #### ## ## ## ## (0## ##### ## ##)
    CLEAR pv_dens.

  ELSE.
    " #### ## ## ### #### ## ## ##
    CLEAR pv_dens.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_season_temp_range
*&---------------------------------------------------------------------*
FORM get_season_temp_range CHANGING pv_low_temp  TYPE ztb1mm0020-ztemp
                                    pv_high_temp TYPE ztb1mm0020-ztemp.

  DATA: lv_month TYPE c LENGTH 2.

  CLEAR: pv_low_temp, pv_high_temp.
  lv_month = sy-datum+4(2). " ## # ##

  CASE lv_month.
      " # (3# ~ 5#) : 10.00 ~ 20.00
    WHEN '03' OR '04' OR '05'.
      pv_low_temp  = '10.00'.
      pv_high_temp = '20.00'.

      " ## (6# ~ 8#) : 25.00 ~ 40.00
    WHEN '06' OR '07' OR '08'.
      pv_low_temp  = '25.00'.
      pv_high_temp = '40.00'.

      " ## (9# ~ 11#) : 8.00 ~ 18.00
    WHEN '09' OR '10' OR '11'.
      pv_low_temp  = '8.00'.
      pv_high_temp = '18.00'.

      " ## (12# ~ 2#) : -5.00 ~ 10.00
    WHEN '12' OR '01' OR '02'.
      pv_low_temp  = '-5.00'.
      pv_high_temp = '10.00'.

    WHEN OTHERS.
      pv_low_temp  = '-5.00'.
      pv_high_temp = '40.00'.
  ENDCASE.

ENDFORM.

FORM check_zmsno_data.

  DATA: lv_orig_zmsno  TYPE ztb1mm0020-zmsno,
        lv_user_date   TYPE c LENGTH 6,
        lv_chk_prefix  TYPE string,
        lv_chk_like    TYPE string,
        lv_db_max_no   TYPE ztb1mm0020-zmsno,
        lv_db_ebeln    TYPE ztb1mm0020-zdocno,
        lv_db_seq      TYPE n LENGTH 2,
        lv_suggest_seq TYPE n LENGTH 2,
        lv_msg_text    TYPE string.

  lv_orig_zmsno = gs_head-zmsno.

  gs_select_head = gs_head.
  CLEAR: gs_head.

  IF gs_select_head-zmsno IS NOT INITIAL AND strlen( gs_select_head-zmsno ) >= 8.

    lv_user_date = gs_select_head-zmsno+2(6).
    CONCATENATE 'MS' lv_user_date INTO lv_chk_prefix.
    CONCATENATE lv_chk_prefix '%' INTO lv_chk_like.

    SELECT zmsno, zdocno
      FROM ztb1mm0020
      INTO ( @lv_db_max_no, @lv_db_ebeln )
     WHERE zmsno LIKE @lv_chk_like
     ORDER BY zmsno DESCENDING.
      EXIT.
    ENDSELECT.

    IF sy-subrc = 0 AND lv_db_max_no IS NOT INITIAL.
      lv_db_seq = lv_db_max_no+8(2).

      IF lv_db_ebeln = gs_selected_item-ebeln.
        lv_suggest_seq = lv_db_seq.
      ELSE.
        lv_suggest_seq = lv_db_seq + 1.
      ENDIF.
    ELSE.
      lv_suggest_seq = '01'.
    ENDIF.

    CONCATENATE lv_chk_prefix lv_suggest_seq INTO gs_select_head-zmsno.

    " #### ## ## #(## ## ## #)
    IF lv_orig_zmsno <> gs_select_head-zmsno.
      lv_msg_text = | 20{ lv_user_date+0(2) }# { lv_user_date+2(2) }# { lv_user_date+4(2) }# ##### '{ lv_suggest_seq }'## ## |.
      MESSAGE lv_msg_text TYPE 'S' DISPLAY LIKE 'E'.

      " ### ## ## ### #### ### ## #####. (#### ## # ## ####)
      cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'REFRESH' ).
      CLEAR ok_code.
      EXIT.
    ELSE.
      gs_head = gs_select_head.
    ENDIF.
  ENDIF.
ENDFORM.

*GUI Texts
*----------------------------------------------------------
* T100 --> ## ###~~!!


*Messages
*----------------------------------------------------------
*YPE
*
* Message class: Hard coded
*   ## ##
