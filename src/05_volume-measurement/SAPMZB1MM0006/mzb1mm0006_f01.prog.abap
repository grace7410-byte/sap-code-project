**&---------------------------------------------------------------------*
**& Include          MZB1MM0006_F01
**&---------------------------------------------------------------------*

*
*
*    " ----------------------------------------------------------------------
*    " [Main Loop] ### ## # ## # ## ##
*    " ----------------------------------------------------------------------
*    DATA: lt_color TYPE lvc_t_scol,
*          ls_color TYPE lvc_s_scol.
*
*    LOOP AT gt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
*      CLEAR: lt_color, ls_color.
*
*      "-----------------------------------------------------------------
*      " ## 1) ## ## ## ## (NB ### # ZEBELNSV ## ##)
*      "-----------------------------------------------------------------
*      READ TABLE lt_po_hdr INTO ls_po_hdr WITH KEY ebeln = <fs_item>-ebeln BINARY SEARCH.
*      IF sy-subrc = 0.
*        " [## ##] #### ## ## #### ## #### ### ## ##!
*        <fs_item>-zebelnsv = ls_po_hdr-zebelnsv.
*
*        IF ls_po_hdr-zebelnsv IS NOT INITIAL.
*          <fs_item>-load_tran  = icon_ws_ship. " ## ####
*          <fs_item>-plant_tran = icon_ws_ship. " ### ####
*
*          " #### # ## ## (5# ##)
*          ls_color-fname     = 'ZEBELNSV'.
*          ls_color-color-col = 5.
*          ls_color-color-int = 0.
*          APPEND ls_color TO lt_color.
*
**          " LOAD_TRAN # ## ## (5# ##)
**          ls_color-fname     = 'LOAD_TRAN'.
**          ls_color-color-col = 5.
**          ls_color-color-int = 0.
**          APPEND ls_color TO lt_color.
**
**          " PLANT_TRAN # ## ## (5# ##)
**          ls_color-fname     = 'PLANT_TRAN'.
**          ls_color-color-col = 5.
**          ls_color-color-int = 0.
**          APPEND ls_color TO lt_color.
*        ELSE.
*          " #######(####)# ### #### ### X ### ##
*          <fs_item>-load_tran = icon_cancel.
*          CLEAR <fs_item>-plant_tran.
*        ENDIF.
*
*      ELSE.
*        " lt_po_hdr# ### ## ## ### 'NB'# #### #### ## ### ## ### #
*        " (## # #### ## ### DELETE ### ## ## ####. ## ### ###)
*        CLEAR: <fs_item>-load_tran, <fs_item>-plant_tran, <fs_item>-zebelnsv.
*      ENDIF.
*
*      "-----------------------------------------------------------------
*      " ## 2) #### ## ## ## -> ## ## + ## ### ###(C600)
*      "-----------------------------------------------------------------
*      READ TABLE lt_volm_cnt INTO ls_volm_cnt
*        WITH KEY zdocno = <fs_item>-ebeln
*                 zdocit = <fs_item>-ebelp BINARY SEARCH.
*      IF sy-subrc = 0.
*        <fs_item>-count_volm = ls_volm_cnt-count.
*
*        IF <fs_item>-count_volm > 1.
*          ls_color-fname     = 'COUNT_VOLM'.
*          ls_color-color-col = 6.
*          ls_color-color-int = 0.
*          APPEND ls_color TO lt_color.
*        ENDIF.
*      ELSE.
*        <fs_item>-count_volm = 0.
*      ENDIF.
*
*      "-----------------------------------------------------------------
*      " ## 3) ## ## ## (#### #### ##) -> ## ### + ###(C300)
*      "-----------------------------------------------------------------
*      READ TABLE lt_mat_check TRANSPORTING NO FIELDS
*        WITH KEY ebeln = <fs_item>-ebeln
*                 ebelp = <fs_item>-ebelp BINARY SEARCH.
*
*      IF sy-subrc = 0.
*        LOOP AT lt_mat_check INTO ls_mat_check FROM sy-tabix.
*          IF ls_mat_check-ebeln <> <fs_item>-ebeln OR ls_mat_check-ebelp <> <fs_item>-ebelp.
*            EXIT.
*          ENDIF.
*
*          " A. ####: #### 101 AND #### T -> ## ### + ###
*          IF ls_mat_check-bwart = '101' AND ls_mat_check-insmk = 'T'.
*            <fs_item>-load_gr   = icon_warehouse.
*
*            ls_color-fname     = 'LOAD_GR'.
*            ls_color-color-col = 3.
*            ls_color-color-int = 0.
*            APPEND ls_color TO lt_color.
*          ENDIF.
*
*          " B. ####: #### (321 OR 551) AND #### NOT T -> ## ### + ###
*          IF ( ls_mat_check-bwart = '321' OR ls_mat_check-bwart = '551' )
*             AND ls_mat_check-insmk <> 'T'.
*            <fs_item>-plant_gr  = icon_warehouse.
*
*            ls_color-fname     = 'PLANT_GR'.
*            ls_color-color-col = 3.
*            ls_color-color-int = 0.
*            APPEND ls_color TO lt_color.
*          ENDIF.
*
*        ENDLOOP. " #### ### ## ##
*      ENDIF.
*
*      " ## ## ## ## ### #### #(##) ## ####
*      IF gs_selected_item-ebeln IS NOT INITIAL AND gs_selected_item-ebelp IS NOT INITIAL
*               AND <fs_item>-ebeln = gs_selected_item-ebeln
*               AND <fs_item>-ebelp = gs_selected_item-ebelp.
*
*        ls_color-fname     = ' '.
*        ls_color-color-col = 1.
*        ls_color-color-int = 0.
*        ls_color-color-inv = 0.
*        APPEND ls_color TO lt_color.
*      ENDIF.
*      " ## ## # ## ### #### ##
*      <fs_item>-cell_color = lt_color.
*
*    ENDLOOP.
*
*    SORT gt_item BY ebeln ebelp.
*  ENDIF.
*
*ENDFORM.
*
*&---------------------------------------------------------------------*
*& Include     MZB1MM0006_F01
*&---------------------------------------------------------------------*
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
    " [Main Loop] ## ### ## STATUS ### # # ## ##
    " ----------------------------------------------------------------------
    DATA: lt_color TYPE lvc_t_scol,
          ls_color TYPE lvc_s_scol.

    " ## ### #### ## ### ## ##
    DATA: lv_has_load_gr  TYPE c,
          lv_has_plant_gr TYPE c.

    LOOP AT gt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
      CLEAR: lt_color, ls_color, lv_has_load_gr, lv_has_plant_gr.

      " 1) Buffer 1 ##: #### ## ##
      READ TABLE lt_po_hdr INTO ls_po_hdr WITH KEY ebeln = <fs_item>-ebeln BINARY SEARCH.
      IF sy-subrc = 0.
        <fs_item>-zebelnsv = ls_po_hdr-zebelnsv.
      ENDIF.

      " 2) Buffer 2 ##: #### ## ##
      READ TABLE lt_volm_cnt INTO ls_volm_cnt
        WITH KEY zdocno = <fs_item>-ebeln
                 zdocit = <fs_item>-ebelp BINARY SEARCH.
      IF sy-subrc = 0.
        <fs_item>-count_volm = ls_volm_cnt-count.
      ELSE.
        <fs_item>-count_volm = 0.
      ENDIF.

      " 3) Buffer 3 ##: #### ## ## (## ### ##)
      READ TABLE lt_mat_check TRANSPORTING NO FIELDS
        WITH KEY ebeln = <fs_item>-ebeln
                 ebelp = <fs_item>-ebelp BINARY SEARCH.
      IF sy-subrc = 0.
        LOOP AT lt_mat_check INTO ls_mat_check FROM sy-tabix.
          IF ls_mat_check-ebeln <> <fs_item>-ebeln OR ls_mat_check-ebelp <> <fs_item>-ebelp.
            EXIT.
          ENDIF.

          " A. #### ## ## (101 & T)
          IF ls_mat_check-bwart = '101' AND ls_mat_check-insmk = 'T'.
            lv_has_load_gr = 'X'.
          ENDIF.

          " B. #### ## ## ((321 or 551) & NOT T)
          IF ( ls_mat_check-bwart = '321' OR ls_mat_check-bwart = '551' )
             AND ls_mat_check-insmk <> 'T'.
            lv_has_plant_gr = 'X'.
          ENDIF.
        ENDLOOP.
      ENDIF.

      IF lv_has_plant_gr = 'X'.
        " 4##: #### ## -> ## ### + ###(C300) -> #### ## ## ### ##
        " -> ####### LED_GREEN## ##
        <fs_item>-status = icon_led_green.

      ELSEIF <fs_item>-count_volm > 0.
        " 3##: #### # (#### ##) -> # ###
        <fs_item>-status = icon_led_red. " -> ## ## ### ### #### RED# ##

        " #### ## ## ###(C600)## ### ###
        IF <fs_item>-count_volm > 1.
          CLEAR: ls_color.
          ls_color-fname     = 'COUNT_VOLM'.
          ls_color-color-col = 6.
          ls_color-color-int = 0.
          APPEND ls_color TO lt_color.
        ENDIF.

      ELSEIF lv_has_load_gr = 'X'.
        " 2##: #### ## -> ## ###
        <fs_item>-status = icon_warehouse.

        CLEAR: ls_color.
        ls_color-fname     = 'STATUS'. " ### ## ## ### ##
        ls_color-color-col = 5. " ### ##
        ls_color-color-int = 0.
        APPEND ls_color TO lt_color.

      ELSEIF <fs_item>-zebelnsv IS NOT INITIAL.
        " 1##: #### # (##### ##) -> # ###
        <fs_item>-status = icon_led_red. " -> ## ## ### ### #### RED# ##

      ELSE.
        " 0##: ## ### -> X ### + ## ##
        <fs_item>-status = icon_cancel.
      ENDIF.

      " 5) ##/## ## # ## ## ## ## (###)
      IF gs_selected_item-ebeln IS NOT INITIAL AND gs_selected_item-ebelp IS NOT INITIAL
                 AND <fs_item>-ebeln = gs_selected_item-ebeln
                 AND <fs_item>-ebelp = gs_selected_item-ebelp.
        CLEAR ls_color.
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
    lv_text = |{ lv_text } ### #######. #### [{ gs_head-zmsno }]# ### ########?|.

    CLEAR lv_answer.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = '## ### ## ##'
        text_question         = lv_text
        text_button_1         = '#'
        text_button_2         = '###'
        default_button        = '2'
        display_cancel_button = ' '
      IMPORTING
        answer                = lv_answer.

    IF lv_answer <> '1'.
      MESSAGE s025(zmcb1) WITH '## ### ####' DISPLAY LIKE 'E' ." '## ### #### ## ##'
      pv_cancel = 'X'. " ## ### ###### ### ##
      RETURN.          " # FORM# ## ##
    ENDIF.
  ENDIF.

  " ----------------------------------------------------------------------
  " 2. 1# ## ### ## ##, ####, ## ## ## ###
  " ----------------------------------------------------------------------
  " ## ### ### #### ## ### ##
  IF gs_selected_item-zebelnsv IS INITIAL.
    CLEAR: lv_answer, lv_text.
    lv_text = |## ### #######. #### [{ gs_head-zmsno }]# ### ########?|.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = '## ## ## ##'
        text_question         = lv_text
        text_button_1         = '#'
        text_button_2         = '###'
        default_button        = '2'
        display_cancel_button = ' '
      IMPORTING
        answer                = lv_answer.

    IF lv_answer <> '1'.
      MESSAGE s025(zmcb1) WITH '' DISPLAY LIKE 'E'.
      pv_cancel = 'X'.
      RETURN.
    ENDIF.
  ENDIF.


  " ## ##(COUNT_VOLM) ### ## ## # ##(Loss) ##
  CASE gs_selected_item-count_volm.
    WHEN 0.
      CLEAR: lv_answer, lv_text.
      lv_text = |#### [{ gs_head-zmsno }]## ## #### ## #### ### ########?|.

      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = '#### #### ## ##'
          text_question         = lv_text
          text_button_1         = '#'
          text_button_2         = '###'
          default_button        = '1'
          display_cancel_button = ' '
        IMPORTING
          answer                = lv_answer.

      IF lv_answer <> '1'.
        MESSAGE s025(zmcb1) WITH '#### #### ##' DISPLAY LIKE 'E'.
        pv_cancel = 'X'.
        RETURN.
      ENDIF.

    WHEN 1.
      IF gs_selected_item-menge = gs_head-zsvol.
        " # ## ### ### ## ## ## ##
        CLEAR: lv_answer, lv_text.
        lv_text = |## ###### ###(##)# #### ####. #### [{ gs_head-zmsno }]## ## #### ## #### ### ########?|.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            titlebar              = '#### #### ## ##'
            text_question         = lv_text
            text_button_1         = '#'
            text_button_2         = '###'
            default_button        = '1'
            display_cancel_button = ' '
          IMPORTING
            answer                = lv_answer.
      ELSE.
        " ## ### ## #### ## ##
        CLEAR: lv_answer, lv_text.
        lv_text = |#### [{ gs_head-zmsno }]## ## #### ## #### ### ########?|.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            titlebar              = '#### #### ## ##'
            text_question         = lv_text
            text_button_1         = '#'
            text_button_2         = '###'
            default_button        = '1'
            display_cancel_button = ' '
          IMPORTING
            answer                = lv_answer.
      ENDIF.

      IF lv_answer <> '1'.
        MESSAGE s025(zmcb1) WITH '#### #### ##' DISPLAY LIKE 'E'.
        pv_cancel = 'X'.
        RETURN.
      ENDIF.

    WHEN 2.
      CLEAR: lv_answer, lv_text.
      lv_text = |#### [{ gs_head-zmsno }]## ## ## # ## ##### ## #####. ##### ########?|.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = '#### ### ##'
          text_question         = lv_text
          text_button_1         = '#'
          text_button_2         = '###'
          default_button        = '2'
          display_cancel_button = ' '
        IMPORTING
          answer                = lv_answer.

      IF lv_answer <> '1'.
        MESSAGE s025(zmcb1) WITH '' DISPLAY LIKE 'E'.
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
    MESSAGE s022(zmcb1) WITH '## ### ## ## # ## ### DB# #####. ####' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  gs_head-ernam = sy-uname.
  gs_head-erdat = sy-datum.
  gs_head-erzet = sy-uzeit.

  MOVE-CORRESPONDING gs_head TO ls_head.
  MODIFY ztb1mm0020 FROM ls_head.

  IF sy-subrc = 0.
    COMMIT WORK.
    MESSAGE s005(zmcb1).

    CLEAR: gs_head,
           gs_select_head.
    PERFORM get_po_data.

    " ## #### ## ##
    cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'REFRESH' ).

  ELSE.
    ROLLBACK WORK.
    MESSAGE s000(zmcb1) WITH ': DB ## # ### ## ## ##' DISPLAY LIKE 'E'.
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
*    IF &1 = 'LOAD_TRAN' OR &1 = 'PLANT_TRAN' OR &1 = 'LOAD_GR' OR &1 = 'PLANT_GR'.
*      ls_fcat-icon = 'X'. "
*      ls_fcat-just = 'C'. " ### ##
*    ENDIF.

IF &1 = 'STATUS'.
      ls_fcat-icon = 'X'. " ### ###
      ls_fcat-just = 'C'. " ### ##
    ENDIF.

    APPEND ls_fcat TO pt_fcat.
  END-OF-DEFINITION.

  "          [FieldName]   [ColText (## ##)]     [OutputLen]
  _add_fcat 'STATUS'        '## ##'               6.
  _add_fcat 'EBELN'         '#### ##'            12.
  _add_fcat 'EBELP'         '####'                6.
*  _add_fcat 'LOAD_TRAN'     '####'               6.
*  _add_fcat 'PLANT_TRAN'    '####'              6.
  _add_fcat 'COUNT_VOLM'    '####'               6.
*  _add_fcat 'LOAD_GR'       '####'               6.
*  _add_fcat 'PLANT_GR'      '####'               6.
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
      lv_msg_text = | 20{ lv_user_date+0(2) }# { lv_user_date+2(2) }# { lv_user_date+4(2) }# ##### '{ lv_suggest_seq }'## #####.|.
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
