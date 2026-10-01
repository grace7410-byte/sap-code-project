*&---------------------------------------------------------------------*
*& Include          ZB1MM0002_F01
*&---------------------------------------------------------------------*
*& Form get_data (100# ### ALV ####+## ## ### ##)
*&---------------------------------------------------------------------*
FORM get_data.
  CLEAR: gt_data.

  SELECT a~ebeln, a~bpid,  a~ekorg,  a~ekgrp,  a~bukrs, a~bsart, a~bedat,
          a~zterm,  a~inco1,  a~zebeln, a~zebelnsv, a~knumh,
          b~zappno,  b~zappst, b~zapper, b~zappdat, b~zapptim, b~zmemo,
          b~lvorm, b~erdat, b~erzet, b~ernam, b~aedat, b~aezet, b~aenam
    FROM ztb1mm0006 AS a LEFT OUTER JOIN ztb1mm0008 AS b
             ON a~ebeln = b~ebeln  " #### ### ##
   WHERE a~ebeln  IN @so_pono
*     AND a~lvorm  <> 'X'    " #### ## ## ##
*     AND b~lvorm  <> 'X' " ### ## ## ##
     AND a~bsart = 'NB' " #### ## ### '## ####'## #(#### X)
     AND b~zappno IN @so_apno
     AND ( @pa_stat IS INITIAL OR b~zappst = @pa_stat ) " #### ## ### ## ## ##
     AND b~zappdat IN @so_apdat
     AND a~erdat  IN @so_podat " ####(PO ###) ##
    INTO CORRESPONDING FIELDS OF TABLE @gt_data.

  IF gt_data[] IS INITIAL.
    MESSAGE s010(zmcb1) WITH '#### ##' DISPLAY LIKE 'E'. " ## ### ## #### ### ####
    EXIT.
  ENDIF.

  SORT gt_data BY zappno. " #### ### ##

  DATA: lt_color TYPE lvc_t_scol,
        ls_color TYPE lvc_s_scol.
  " ### ##, ###, ##
  LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<fs_appr>).
    PERFORM get_domain_text USING 'ZDB1_MM_ZAPPST' <fs_appr>-zappst CHANGING <fs_appr>-zappstxt.

    CASE <fs_appr>-zappst.
      WHEN '1'. " ## #
        <fs_appr>-status = icon_led_yellow.
      WHEN '2'. " ##
        <fs_appr>-status = icon_led_green.
      WHEN '3' OR '4'. " ## #
        <fs_appr>-status = icon_led_red.
      WHEN OTHERS.
        CLEAR <fs_appr>-status.
    ENDCASE.

    CLEAR lt_color.

    IF <fs_appr>-zappst = '1' OR <fs_appr>-zappst = '3'. " ## #(1)### ##(3)# #
      CLEAR ls_color.
      ls_color-fname = 'ZAPPST'. " ### ## ### ##

      IF <fs_appr>-zappst = '1'.
        ls_color-color-col = '5'.    " C500
      ELSEIF <fs_appr>-zappst = '3'. " ##
        ls_color-color-col = '6'.    " C600
      ENDIF.

      ls_color-color-int = '0'.      " ## ## ON (##)
      ls_color-color-inv = '0'.      " ## ## OFF
      APPEND ls_color TO lt_color.

      <fs_appr>-cell_color = lt_color.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_object (## - ## #### # alv ### ###)
*&---------------------------------------------------------------------*
FORM create_object_dock
*                  USING pv_area TYPE c
*                        pv_basic TYPE c
                  CHANGING po_dock TYPE REF TO cl_gui_docking_container
                           po_alv TYPE REF TO Cl_gui_alv_grid.

  CREATE OBJECT po_dock
    EXPORTING
*     parent                      =
      repid                       = sy-repid
      dynnr                       = sy-dynnr
      side                        = cl_gui_docking_container=>dock_at_left
      extension                   = 1400
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.

  CREATE OBJECT po_alv " ALV Grid ## #### Container# ##
    EXPORTING
      i_parent          = po_dock
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.

*  IF pv_basic = 'X'. " GO_ALV# ##
*    " #### ## ## ### ## #, ### # ## ## ## #### #### #### # #### ##
*    po_alv->register_edit_event( i_event_id = cl_gui_alv_grid=>mc_evt_enter ).
*    po_alv->register_edit_event( i_event_id = cl_gui_alv_grid=>mc_evt_modified ).
*  ENDIF.
ENDFORM.
*  CREATE OBJECT po_cont " Custom Container ####, Area# ##
*    EXPORTING
*      container_name              = pv_area " ### Layout# ## ## ##
*    EXCEPTIONS
*      cntl_error                  = 1
*      cntl_system_error           = 2
*      create_error                = 3
*      lifetime_error              = 4
*      lifetime_dynpro_dynpro_link = 5
*      OTHERS                      = 6.
*&---------------------------------------------------------------------*
*& Form display_alv (ALV ### ## - ## ALV ## )
*&---------------------------------------------------------------------*
FORM display_alv USING    ps_layout  TYPE lvc_s_layo
                          pt_uifunc  TYPE ui_functions
                          pt_fcat    TYPE lvc_t_fcat
                 CHANGING po_alv     TYPE REF TO cl_gui_alv_grid
                          pt_outtab  TYPE ANY TABLE. " ## ### ##### # ##!

  " ALV Grid ## Data display
  CALL METHOD po_alv->set_table_for_first_display
    EXPORTING
      is_layout                     = ps_layout  " #### ###
      it_toolbar_excluding          = pt_uifunc  " ## ##
    CHANGING
      it_outtab                     = pt_outtab  " ######## ##
      it_fieldcatalog               = pt_fcat   " i_structure ### ### ###
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh_alv (100# ### alv ###### - ## #### ##)
*&---------------------------------------------------------------------*
* ZRB1MM0002## #### [Refresh ##] 2##
* 1. go_alv->refresh_table_display( ):
* - ## ### ## # ##.
*
* 2. PERFORM refresh_alv:
* - # ##/##/## # '#### ## ## #'# ### # ## (ex - ### ###)
* - is_stable ### ## ## ### ### ###
*----------------------------------------------------------------------*
FORM refresh_alv CHANGING ps_stable TYPE lvc_s_stbl
                          po_alv TYPE REF TO cl_gui_alv_grid.
  ps_stable-row = 'X'. " ##### # ## ### ## ##
  ps_stable-col = 'X'. " ## ## ##
  CALL METHOD po_alv->refresh_table_display
    EXPORTING
      is_stable      = ps_stable
      i_soft_refresh = '' "x: ##, ##, ## ### ## -> ### #### #####
    EXCEPTIONS            "_: ## ####(##)
      finished       = 1
      OTHERS         = 2.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout (100# ### ALV #### ##)
*&---------------------------------------------------------------------*
FORM set_layout USING pv_type TYPE i
                CHANGING ps_layout TYPE lvc_s_layo.
  CLEAR ps_layout.
  IF pv_type = 1.
    " appr## #### alv layout ##
    ps_layout-sel_mode   = 'D'. " # ## ## ##
    ps_layout-no_toolbar = 'X'. "## ##(## ui_func ## ## ##)
    ps_layout-zebra      = 'X'. " ### ##
    ps_layout-ctab_fname = 'CELL_COLOR'.
    ps_layout-cwidth_opt = 'X'. " # ## ## ###
  ELSE.
    ps_layout-sel_mode   = 'A'. " ## # ## ##
    " ps_layout-info_fname = 'COL_FLD'. " # ## ## ## ##
  ENDIF.
  " ## ##
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_uifunc (100# ### ALV ## ## ## ## ->  layout# NO_TOOLBAR = 'X'# ##### #)
*&---------------------------------------------------------------------*
FORM set_uifunc USING pv_type TYPE i
                      pt_uifunc  TYPE ui_functions.
  REFRESH pt_uifunc.
*  IF pv_type = 1.
*  ELSE.
*    APPEND cl_gui_alv_grid=>mc_fc_excl_all TO pt_uifunc. " ## # ###
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
* FORM fill_fcat (## fcat ### ##)
* -> ##: Fcat# ## # ## ###(ALV# ## ### ### ####) fill_fcat# ## # ##
* ### Fcat# ## # ### fill_cat(####: ## set_fcat) ### ### ##
*&---------------------------------------------------------------------*
*FORM fill_fcat USING p_status p_fname p_value. " ##(#### ##), ###, ## #
*  IF p_status = 'S'.
*    " gs_fcat## p_fname# ### ## component# ###(##### #### ## ####)
*    ASSIGN COMPONENT p_fname OF STRUCTURE gs_fcat TO FIELD-SYMBOL(<fs>).
*    IF <fs> IS ASSIGNED.
*      <fs> = p_value.
*    ENDIF.
*
*  ELSEIF p_status = 'E'. " ## ## -> ### ## ### ## #.
*    gv_col_pos = gv_col_pos + 1.
*    gs_fcat-col_pos = gv_col_pos. " ### ### #### ##
*    APPEND gs_fcat TO gt_fcat.
*    CLEAR  gs_fcat.            "## ### ## ######
*  ENDIF.
*ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat (Field Catalog ### ##)
*&---------------------------------------------------------------------*
FORM set_fcat TABLES tt_fcat TYPE lvc_t_fcat  " ### ## ### ### (gt_fcat)
              USING  pv_stat                  " ## ###: 'S'(##), ' '(##), 'E'(##/##)
                     pv_fnam                  " ## ## (#: 'FIELDNAME', 'COLTEXT')
                     pv_fval.                 " ## #   (#: 'MATNR', '####')

  FIELD-SYMBOLS: <fld> TYPE any.

  " STATICS: ##### #### ## # #### #### ## #### ## ###
  " ### gs_fcat ### ### # FORM #### ### ## ###
  STATICS: ls_fcat TYPE lvc_s_fcat.

  " ### ## ### ### # ## ls_fcat# ### ##
  IF pv_stat = 'S'.
    CLEAR ls_fcat.
  ENDIF.

  " ## ##: ls_fcat## ## ### # pv_fnam# ### # pv_fval# ##
  " #: ls_fcat-fieldname = 'MATNR' # ## ### #### ##
  ASSIGN COMPONENT pv_fnam OF STRUCTURE ls_fcat TO <fld>.
  IF sy-subrc = 0 AND <fld> IS ASSIGNED.
    <fld> = pv_fval.
  ENDIF.

  " # ### ## ## ### ##### ## ###(gt_fcat)# ###
  IF pv_stat = 'E'.
    APPEND ls_fcat TO tt_fcat.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& set_fcat_appr (100# ### ALV ## #### ##)
*&---------------------------------------------------------------------*
FORM set_fcat_appr CHANGING ct_fcat_appr TYPE lvc_t_fcat.
  REFRESH ct_fcat_appr.

  PERFORM set_fcat TABLES ct_fcat_appr USING:
          'S' 'FIELDNAME' 'STATUS',  ' ' 'COLTEXT' '##',    ' ' 'ICON' 'X', ' ' 'EMPHASIZE' 'C110', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'ZAPPNO',  ' ' 'COLTEXT' '## ##',    ' ' 'REF_TABLE' 'ZTB1MM0008', ' ' 'REF_FIELD' 'ZAPPNO', ' ' 'EMPHASIZE' 'C110', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'EBELN',   ' ' 'COLTEXT' '## ##',    ' ' 'REF_TABLE' 'ZTB1MM0006', ' ' 'REF_FIELD' 'EBELN',  ' ' 'EMPHASIZE' 'C110', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'ZEBELNSV',' ' 'COLTEXT' '## ##',   ' ' 'REF_TABLE' 'ZTB1MM0006', ' ' 'REF_FIELD' 'ZEBELNSV', 'E' ' ' ' ',

*          -- ###(#### ## ####)
          'S' 'FIELDNAME' 'BPID',    ' ' 'COLTEXT' '####',    ' ' 'REF_TABLE' 'ZTB1MM0006', ' ' 'REF_FIELD' 'BPID',     ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'EKORG',   ' ' 'COLTEXT' '## ##',    ' ' 'REF_TABLE' 'ZTB1MM0006', ' ' 'REF_FIELD' 'EKORG',    ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'EKGRP',   ' ' 'COLTEXT' '## ##',    ' ' 'REF_TABLE' 'ZTB1MM0006', ' ' 'REF_FIELD' 'EKGRP',    ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'BUKRS',   ' ' 'COLTEXT' '## ##',    ' ' 'REF_TABLE' 'ZTB1MM0006', ' ' 'REF_FIELD' 'BUKRS',    ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'BSART',   ' ' 'COLTEXT' '## ##',    ' ' 'REF_TABLE' 'ZTB1MM0006', ' ' 'REF_FIELD' 'BSART',    ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'BEDAT',   ' ' 'COLTEXT' '## ##',    ' ' 'REF_TABLE' 'ZTB1MM0006', ' ' 'REF_FIELD' 'BEDAT',    ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'ZTERM',   ' ' 'COLTEXT' '## ##',    ' ' 'REF_TABLE' 'ZTB1MM0006', ' ' 'REF_FIELD' 'ZTERM',    ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'INCO1',   ' ' 'COLTEXT' '####',    ' ' 'REF_TABLE' 'ZTB1MM0006', ' ' 'REF_FIELD' 'INCO1',    ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'ZEBELN',  ' ' 'COLTEXT' '## ##',    ' ' 'REF_TABLE' 'ZTB1MM0006', ' ' 'REF_FIELD' 'ZEBELN',   ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'KNUMH',   ' ' 'COLTEXT' '## ###',   ' ' 'REF_TABLE' 'ZTB1MM0006', ' ' 'REF_FIELD' 'KNUMH',    ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'LVORM',   ' ' 'COLTEXT' '## ##',    ' ' 'REF_TABLE' 'ZTB1MM0008', ' ' 'REF_FIELD' 'LVORM',    ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
*          -- ## ## = ## ## (#### ##)
          'S' 'FIELDNAME' 'ERDAT',   ' ' 'COLTEXT' '###',      ' ' 'JUST' 'C', ' ' 'REF_TABLE' 'ZTB1MM0006', ' ' 'REF_FIELD' 'ERDAT', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'ERZET',   ' ' 'COLTEXT' '####',    ' ' 'JUST' 'C', ' ' 'REF_TABLE' 'ZTB1MM0006', ' ' 'REF_FIELD' 'ERZET', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'ERNAM',   ' ' 'COLTEXT' '###',      ' ' 'JUST' 'C', ' ' 'REF_TABLE' 'ZTB1MM0006', ' ' 'REF_FIELD' 'ERNAM', 'E' ' ' ' ',
*          -- ##### - ## ## ##(###)
          'S' 'FIELDNAME' 'AEDAT',   ' ' 'COLTEXT' '###',      ' ' 'JUST' 'C', ' ' 'NO_OUT' 'X', ' ' 'REF_TABLE' 'ZTB1MM0006', ' ' 'REF_FIELD' 'AEDAT', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'AEZET',   ' ' 'COLTEXT' '####',    ' ' 'JUST' 'C', ' ' 'NO_OUT' 'X', ' ' 'REF_TABLE' 'ZTB1MM0006', ' ' 'REF_FIELD' 'AEZET', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'AENAM',   ' ' 'COLTEXT' '###',      ' ' 'JUST' 'C', ' ' 'NO_OUT' 'X', ' ' 'REF_TABLE' 'ZTB1MM0006', ' ' 'REF_FIELD' 'AENAM', 'E' ' ' ' ',

*          -- ## ## ## (##)
          'S' 'FIELDNAME' 'ZAPPST',  ' ' 'COLTEXT' '###',    ' ' 'REF_TABLE' 'ZTB1MM0008', ' ' 'REF_FIELD' 'ZAPPST',  ' ' 'JUST' 'C', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'ZAPPSTXT',  ' ' 'COLTEXT' '## ##',      ' ' 'JUST' 'C', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'ZAPPER',  ' ' 'COLTEXT' '###',      ' ' 'REF_TABLE' 'ZTB1MM0008', ' ' 'REF_FIELD' 'ZAPPER',  ' ' 'JUST' 'C', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'ZAPPDAT', ' ' 'COLTEXT' '## ##',    ' ' 'REF_TABLE' 'ZTB1MM0008', ' ' 'REF_FIELD' 'ZAPPDAT', ' ' 'JUST' 'C', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'ZAPPTIM', ' ' 'COLTEXT' '## ##',    ' ' 'REF_TABLE' 'ZTB1MM0008', ' ' 'REF_FIELD' 'ZAPPTIM', ' ' 'JUST' 'C', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'ZMEMO',   ' ' 'COLTEXT' '## ##',    ' ' 'REF_TABLE' 'ZTB1MM0008', ' ' 'REF_FIELD' 'ZMEMO',   ' ' 'OUTPUTLEN' '50', 'E' ' ' ' '.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_domain_text (### Fixed Value ### ##)
*&---------------------------------------------------------------------*
FORM get_domain_text USING    p_gv_domname TYPE any " ZDB1_MM_## #### domain#
                              p_gv_value   TYPE any " Fixed value# ####
                     CHANGING c_gv_text    TYPE c. " fv# description ####

  " (## ## # #### ### ## ## ### #### ## ##)
  DATA: lt_domain_value TYPE TABLE OF dd07v, "sap ## ### ##### itab ##
        ls_domain_value LIKE LINE OF lt_domain_value. " LINE OF # wa ###
  CLEAR c_gv_text. " ## # ### (###)

  " 1. ### # ## ####
  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING
      domname         = p_gv_domname    " ZDB1_MM_### (domain)
    TABLES
      values_tab      = lt_domain_value " itab
    EXCEPTIONS
      no_values_found = 1
      OTHERS          = 2.

  IF sy-subrc = 0.
    " 2. #### FV ## #### ### ##
    READ TABLE lt_domain_value INTO ls_domain_value
      " itab # domvalue_l ## ex) G01, G02 ## #### #### ###(##### ##)
      WITH KEY domvalue_l = p_gv_value. " ex) #### ### ## G01###

    IF sy-subrc = 0. " ddtext## ex) G01# ### '###'# ### #
      c_gv_text = ls_domain_value-ddtext. " ### ## ### CHANGING ### ##
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form process_approval_data
*&---------------------------------------------------------------------*
FORM process_approval_data .
  DATA: ls_0008     TYPE ztb1mm0008,
        lv_aebelnsv TYPE ztb1mm0006-zebelnsv. " ### PO ## ###

  " -----------------------------------------------------------------
  " 1. ZTB1MM0008 (## ###) #### ### ## # ##
  " -----------------------------------------------------------------
  SELECT SINGLE * FROM ztb1mm0008 INTO ls_0008
   WHERE zappno = gs_data-zappno.

  IF sy-subrc = 0.
    ls_0008-zappst = gs_data-zappst. " #### ### 2(##) ## 3(##)
    ls_0008-zapper = gs_data-zapper.
    ls_0008-zappdat = gs_data-zappdat.
    ls_0008-zapptim = sy-uzeit.      " ## ##
    ls_0008-zmemo   = gs_data-zmemo.   " #### (### ## ###)

    " ## ##### 3# (### ### ##/##/##)
    ls_0008-aenam   = sy-uname.
    ls_0008-aedat   = sy-datum.
    ls_0008-aezet   = sy-uzeit.

    UPDATE ztb1mm0008 FROM ls_0008.
    IF sy-subrc <> 0.
      ROLLBACK WORK.
      MESSAGE '## ## ##### ######.' TYPE 'E'.
    ENDIF.

    "PROCESS FLOW ##(###)
    DATA lv_reqno TYPE zeb1_sd_ref_doc_no.
    DATA lv_docno TYPE zeb1_sd_result_doc_no.

    lv_reqno = CONV char20( ls_0008-ebeln ).
    lv_docno = CONV char20( ls_0008-zappno ).

    zcl_b1_process_status=>save(
      EXPORTING
        iv_program_id      = 'ZRB1MM0002'
        iv_ref_doc_no      = lv_reqno
        iv_result_doc_no   = lv_docno
        iv_result_doc_type = 'APP'
        iv_status_text     = '## ## ## ##'
      EXCEPTIONS
        program_not_found  = 1
        mapping_not_found  = 2
        create_error       = 3
        complete_error     = 4
        OTHERS             = 5
    ).

    IF sy-subrc <> 0.
      MESSAGE s026(zmcb1) WITH |PROCESS STATUS ## #| DISPLAY LIKE 'E'.
    ENDIF.

  ENDIF.

  " -----------------------------------------------------------------
  " [## ##] ##(2)# #### ## ### # ### PO ### ## ##
  " -----------------------------------------------------------------
  IF gs_data-zappst = '2'.

    " 2. ### ####(ZTB1MM0007)# ## ### ### '3'## ##
    UPDATE ztb1mm0007
       SET postat = '3',
           aenam  = @sy-uname,
           aedat  = @sy-datum,
           aezet  = @sy-uzeit
     WHERE ebeln  = @ls_0008-ebeln. " ## ### ### #### ##

    IF sy-subrc <> 0.
      ROLLBACK WORK.
      MESSAGE '#### ## ## ##### ######.' TYPE 'E'.
    ENDIF.

    " 3. ## ### #! ## ###(ZTB1MM0006)## ##### ##(ZEBELNSV) ##
    SELECT SINGLE zebelnsv
      FROM ztb1mm0006
      INTO @lv_aebelnsv
     WHERE ebeln = @ls_0008-ebeln.

    " ### PO ### ##### ### PO# ### ### ## '3'## ####
    IF sy-subrc = 0 AND lv_aebelnsv IS NOT INITIAL.

      UPDATE ztb1mm0007
         SET postat = '3',
             aenam  = @sy-uname,
             aedat  = @sy-datum,
             aezet  = @sy-uzeit
       WHERE ebeln  = @lv_aebelnsv. " ### PO ## ## ####

      IF sy-subrc <> 0.
        ROLLBACK WORK.
        MESSAGE '### ##### ## ## ##### ######.' TYPE 'E'.
      ENDIF.

    ENDIF.

  ENDIF.

  " 4. ## #### ## ## # ## ##(Commit)
  COMMIT WORK.
  sy-subrc = 0.
ENDFORM.
FORM pop_up_message USING VALUE(cv_title) VALUE(cv_text)
                    CHANGING cv_answer_message.

  " 3. ## ##
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = cv_title
      text_question         = cv_text
      text_button_1         = '#'
      text_button_2         = '###'
      display_cancel_button = '' " ## '##' ### #### ## ### ###
    IMPORTING
      answer                = cv_answer_message
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

ENDFORM.
