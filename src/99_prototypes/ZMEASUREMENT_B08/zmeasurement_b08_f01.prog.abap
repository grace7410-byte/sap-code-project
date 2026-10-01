*&---------------------------------------------------------------------*
*& Include          MZB1MM0003F01
*&---------------------------------------------------------------------*
*& Form get_data (100# ### ALV ### ##)
*&---------------------------------------------------------------------*
FORM get_data.
  DATA: lt_volm TYPE TABLE OF ty_volm, " ty_volm# 3# ### ### ###(####, ##, ##)
        ls_volm LIKE LINE OF lt_volm. " alv# ## # ## ### ## ##
  " 1. #### T## ### ##
  SELECT zmsno zdocty zdocno zdocit zavol ztemp zunit zdens zvcf zsvol meins zmdat
      FROM ztb1mm0020 UP TO 200 ROWS " ## ##
      INTO CORRESPONDING FIELDS OF TABLE lt_volm

      . " ## Process, movement, step #######
  " ## ### ### ##
  IF lt_volm IS INITIAL.
    MESSAGE s112(zmcb1) DISPLAY LIKE 'E' WITH '####'. " ## ### #### ## ####
    EXIT.
  ENDIF.

  " 2. ## ## ## (### #### ##. PO-1 -> PO / GR / #### # ##)
  LOOP AT lt_volm ASSIGNING FIELD-SYMBOL(<fs_volm>). " #### ##
    <fs_volm>-meins_2 = <fs_volm>-meins. " ## ### ### (## ##### # ##)

    CASE <fs_volm>-zdocty. " ##### SO, PO-1, Pro-GR ## #
      WHEN 'SO'. " ##(SO), ##(GI)
        <fs_volm>-process = 'SO'. <fs_volm>-movement = 'GI'.
      WHEN 'PO-1'. " ##(PO), ##(GR), ####(1)
        <fs_volm>-process = 'PO'. <fs_volm>-movement = 'GR'. <fs_volm>-step = '1'.
      WHEN 'PO-2'. " ####(2)
        <fs_volm>-process = 'PO'. <fs_volm>-movement = 'GR'. <fs_volm>-step = '2'.
      WHEN 'PrO-GR'. " ##(PrO)
        <fs_volm>-process = 'PrO'. <fs_volm>-movement = 'GR'.
      WHEN 'PrO-GI'.
        <fs_volm>-process = 'PrO'. <fs_volm>-movement = 'GI'.
    ENDCASE.

    " 3. ### # ## ## ### ####
    PERFORM get_domain_text USING 'ZDB1_MM_TYPE1' <fs_volm>-process CHANGING <fs_volm>-text_p.
    PERFORM set_text_by_code USING 'M' <fs_volm>-movement CHANGING <fs_volm>-text_s. " ## m### ### ## ### ## ## s
    IF <fs_volm>-step IS NOT INITIAL. " ## ###### ###### ## ## ### step# ## ###### ##
      PERFORM get_domain_text USING 'ZDB1_MM_TYPE3' <fs_volm>-step CHANGING <fs_volm>-text_s.
    ENDIF.
  ENDLOOP.

  gt_volm = lt_volm. " ## ALV #### ##
  SORT gt_volm BY zmsno.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_header_domain_value (### Fixed Value ### ##)
*&---------------------------------------------------------------------*
FORM get_domain_text USING    p_gv_domname TYPE any " ZDB1_MM_## #### domain#
                              p_gv_value   TYPE any " Fixed value# ####
                     CHANGING c_gv_text    TYPE char20. " fv# description ####

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
*& Form set_text_by_code (### FV ### - #### ## #### ### ####)
*&---------------------------------------------------------------------*
FORM set_text_by_code USING    pv_type  TYPE c  " ## ## (P:####, M:###, S:##)
                               pv_code  TYPE any
                      CHANGING cv_text  TYPE char20.
  DATA: lv_desc TYPE string.
  CASE pv_type.
    WHEN 'P'. " PROCESS (####)
      CASE pv_code.
        WHEN 'PO'.  lv_desc = '####'.
        WHEN 'SO'. lv_desc = '####'.
        WHEN 'PRO'. lv_desc = '####'.
      ENDCASE.
    WHEN 'M'. " MOVEMENT (### ##)
      CASE pv_code.
        WHEN 'GR'.  lv_desc = '##'.
        WHEN 'GI'.  lv_desc = '##'.
      ENDCASE.
    WHEN 'S'. " STEP (##)
      CASE pv_code.
        WHEN '1'.   lv_desc = '####'.
        WHEN '2'.   lv_desc = '####'.
      ENDCASE.
  ENDCASE.
  cv_text = lv_desc.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_object (### #### # ALV ## "##)
*&---------------------------------------------------------------------*
FORM create_object USING pv_area TYPE c
                   CHANGING po_cont TYPE REF TO cl_gui_custom_container
                                 po_alv TYPE REF TO cl_gui_alv_grid.
  CREATE OBJECT po_cont " Custom Container ####, Area# ##
    EXPORTING
      container_name              = pv_area " ### Layout# ## ## ##
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.
  CREATE OBJECT po_alv " ALV Grid ## #### Container# ##
    EXPORTING
      i_parent          = po_cont
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
*   #### ## ## ### ## #, ### # ## ## ## #### #### #### # #### ##
  po_alv->register_edit_event( i_event_id = cl_gui_alv_grid=>mc_evt_enter ).
  po_alv->register_edit_event( i_event_id = cl_gui_alv_grid=>mc_evt_modified ).

*   ALV# ## ### ## ## ## ### ## #### #
*  po_alv->set_ready_for_input( i_ready_for_input = 1 ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_alv (ALV ## ### ##)
*&---------------------------------------------------------------------*
FORM display_alv USING    ps_layout  TYPE lvc_s_layo
                          pt_uifunc  TYPE ui_functions
                          pt_fcat    TYPE lvc_t_fcat
                 CHANGING po_alv     TYPE REF TO cl_gui_alv_grid
                          pt_outtab  TYPE ANY TABLE. " ## ### ##### # ##

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
*& Form refresh_alv (ALV ## #### - ## #### ##)
*&---------------------------------------------------------------------*
* SAPMZB1MM0003## #### [Refresh ##] 2##
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
*& Form set_layout (ALV ## #### ##)
*&---------------------------------------------------------------------*
FORM set_layout USING pv_type TYPE i
                CHANGING ps_layout TYPE lvc_s_layo.
  CLEAR ps_layout.
  IF pv_type = 1.
    " 100# ### alv layout ##
    ps_layout-sel_mode   = 'D'. " # ## ## ##
    ps_layout-cwidth_opt = 'X'. " # ## ## ###
  ELSE.
    " 200# ##### #### alv layout ##
    ps_layout-sel_mode   = 'B'. " # ## ## ##
  ENDIF.
  " ## ##
  ps_layout-info_fname = 'COL_FLD'. " # ## ## ## ##
  ps_layout-zebra      = 'X'. " ### ##
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_uifunc (ALV ## ## ## ## ##)
*&---------------------------------------------------------------------*
FORM set_uifunc USING pv_type TYPE i
                      pt_uifunc  TYPE ui_functions.
  REFRESH pt_uifunc.
  IF pv_type = 1.
    " 100# ### ALV ui function ## -> ## # ## ## X
  ELSE.
    " 200# ##### #### ui function ##
  ENDIF.
  " ## ##
*    APPEND cl_gui_alv_grid=>mc_fc_excl_all TO pt_uifunc. " ## # ###
ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_fcat (Field Catalog ### ##)
*&---------------------------------------------------------------------*
FORM create_fcat TABLES tt_fcat TYPE lvc_t_fcat  " ### ## ### ### (gt_fcat)
                  USING  pv_stat                  " ## ###: 'S'(##), ' '(##), 'E'(##/##)
                         pv_fnam                  " ## ## (#: 'FIELDNAME', 'COLTEXT')
                         pv_fval.                 " ## #   (#: 'MATNR', '####')
  FIELD-SYMBOLS: <fld> TYPE any.

  " ### gs_fcat ### ### # FORM #### ### ## ###
  STATICS: ls_fcat TYPE lvc_s_fcat.   " STATICS: ## ###

  " ### ## ### ### # ## ls_fcat# ### ##
  IF pv_stat = 'S'.
    CLEAR ls_fcat.
  ENDIF.

  " ls_fcat## ## ### # pv_fnam# ### # pv_fval# ##
  ASSIGN COMPONENT pv_fnam OF STRUCTURE ls_fcat TO <fld>.
  IF sy-subrc = 0 AND <fld> IS ASSIGNED.
    <fld> = pv_fval.
  ENDIF.

  " # ### ## ## ### ##### gt_fcat# ###
  IF pv_stat = 'E'.
    APPEND ls_fcat TO tt_fcat.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& set_fcat_volm (100# ### ALV ## #### ##)
*&---------------------------------------------------------------------*
FORM set_fcat_volm CHANGING ct_fcat_volm TYPE lvc_t_fcat.
  PERFORM create_fcat TABLES ct_fcat_volm USING:
         'S' 'FIELDNAME' 'ZMSNO',    ' ' 'COLTEXT' '## ##',       ' ' 'KEY' 'X', ' ' 'EMPHASIZE' 'C110', 'E' ' ' ' ', " ###: NO_OUT 'X'
         'S' 'FIELDNAME' 'ZDOCTY',       ' ' 'NO_OUT'  'X',           'E' ' ' ' ', " ### ##
         'S' 'FIELDNAME' 'PROCESS', ' ' 'COLTEXT' ' ',  ' ' 'EMPHASIZE' 'C510', 'E' ' ' ' ',
         'S' 'FIELDNAME' 'TEXT_P',  ' ' 'COLTEXT' '####',    ' ' 'EMPHASIZE' 'C501', 'E' ' ' ' ',
         'S' 'FIELDNAME' 'MOVEMENT', ' ' 'COLTEXT' ' ',  'E' ' ' ' ',
         'S' 'FIELDNAME' 'STEP',         ' ' 'COLTEXT' ' ',   ' ' 'NO_OUT'  'X',  'E' ' ' ' ',
         'S' 'FIELDNAME' 'TEXT_S', ' ' 'COLTEXT' '##',  'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZDOCNO',   ' ' 'COLTEXT' '####',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZDOCIT',   ' ' 'COLTEXT' '####',   'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZAVOL',    ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'MEINS',    ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZTEMP',    ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZUNIT',    ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZDENS',    ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZVCF',     ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZSVOL',    ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'MEINS_2',  ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZMDAT',    ' ' 'COLTEXT' '## ##',       'E' ' ' ' '.
ENDFORM.
*&---------------------------------------------------------------------*
*& set_fcat_item (200# ### ALV ## #### ##)
*&---------------------------------------------------------------------*
FORM set_fcat_item CHANGING ct_fcat_item TYPE lvc_t_fcat.
  PERFORM create_fcat TABLES ct_fcat_item USING:
         'S' 'FIELDNAME' 'ICON',     ' ' 'COLTEXT' ' ',                ' ' 'ICON' 'X', ' ' 'KEY' 'X', ' ' 'EMPHASIZE' 'C110',  ' ' 'OUTPUTLEN' '3'  ,'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZDOCTY',   ' ' 'COLTEXT' '##',              ' ' 'KEY' 'X', ' ' 'EMPHASIZE' 'C110',  ' ' 'OUTPUTLEN' '3'  , 'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZDOCNO',   ' ' 'COLTEXT' '## ##',          ' ' 'KEY' 'X', ' ' 'EMPHASIZE' 'C110', ' ' 'OUTPUTLEN' '11'  , 'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZDOCIT',   ' ' 'COLTEXT' '####',           ' ' 'KEY' 'X', ' ' 'EMPHASIZE' 'C110',  ' ' 'OUTPUTLEN' '5'  , 'E' ' ' ' ',
         'S' 'FIELDNAME' 'PROCESS', ' ' 'COLTEXT' ' ',             ' ' 'NO_OUT'  'X', ' ' 'EMPHASIZE' 'C510', 'E' ' ' ' ',
         'S' 'FIELDNAME' 'TEXT_P',  ' ' 'COLTEXT' '####',            ' ' 'NO_OUT'  'X', ' ' 'EMPHASIZE' 'C501', 'E' ' ' ' ',
         'S' 'FIELDNAME' 'MOVEMENT', ' ' 'COLTEXT' ' ',  ' ' 'NO_OUT'  'X', 'E' ' ' ' ',
         'S' 'FIELDNAME' 'M_ICON',     ' ' 'COLTEXT' ' ',        ' ' 'ICON' 'X', ' ' 'OUTPUTLEN' '3'  ,'E' ' ' ' ',
         'S' 'FIELDNAME' 'STEP',         ' ' 'COLTEXT' ' ',   ' ' 'NO_OUT'  'X',  'E' ' ' ' ',
         'S' 'FIELDNAME' 'TEXT_S', ' ' 'COLTEXT' '##',          ' ' 'OUTPUTLEN' '5', 'E' ' ' ' ',
         'S' 'FIELDNAME' 'MATNR',    ' ' 'COLTEXT' '## ##',        ' ' 'OUTPUTLEN' '8'  ,'E' ' ' ' ',
         'S' 'FIELDNAME' 'WERKS',    ' ' 'COLTEXT' '###',           ' ' 'OUTPUTLEN' '6'  ,'E' ' ' ' ',
         'S' 'FIELDNAME' 'LGORT',    ' ' 'COLTEXT' '####',         ' ' 'OUTPUTLEN' '6'  ,'E' ' ' ' ',
         'S' 'FIELDNAME' 'ORDQTY',   ' ' 'COLTEXT' '## ##',        ' ' 'OUTPUTLEN' '8'  ,' ' 'QFIELDNAME' 'MEINS', 'E' ' ' ' ',
         'S' 'FIELDNAME' 'MEINS',    ' ' 'COLTEXT' '##',            ' ' 'OUTPUTLEN' '3'  ,'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZAVOL',    ' ' 'COLTEXT' '## ##',        ' ' 'OUTPUTLEN' '8'  ,' ' 'QFIELDNAME' 'MEINS', ' ' 'NO_ZERO' 'X', 'E' ' ' ' ',
         'S' 'FIELDNAME' 'MEINS_2',  ' ' 'COLTEXT' '##',           ' ' 'OUTPUTLEN' '3'  ,'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZSVOL',    ' ' 'COLTEXT' '## ##',        ' ' 'OUTPUTLEN' '8'  ,' ' 'QFIELDNAME' 'MEINS', ' ' 'NO_ZERO' 'X', 'E' ' ' ' ',
         'S' 'FIELDNAME' 'MEINS_3',  ' ' 'COLTEXT' '##',           ' ' 'OUTPUTLEN' '3'  , 'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZMSNO',    ' ' 'COLTEXT' '## ##',        ' ' 'OUTPUTLEN' '10'  ,'E' ' ' ' ',
         'S' 'FIELDNAME' 'BLDAT',    ' ' 'COLTEXT' '###',      ' ' 'OUTPUTLEN' '10'  ,'E' ' ' ' ',
         'S' 'FIELDNAME' 'BPID',     ' ' 'COLTEXT' '###',           ' ' 'OUTPUTLEN' '10'  ,'E' ' ' ' '.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_sd_data_all (200# ### SO ## # ## ##)
*&---------------------------------------------------------------------*
FORM get_sd_data_all.
  REFRESH gt_item. " ## ### ###

  SELECT 'SO' AS zdocty,  a~vbeln AS zdocno, " ## ## ## -> ## ####
         b~posnr AS zdocit, " #### ##### ##### ## ##### #
         b~matnr, b~werks, b~lgort, b~kwmeng AS ordqty,
         c~zavol, c~zsvol, b~meins, c~zmsno, a~ordda AS bldat, a~bpid " ##(SO)###-> ###
    FROM ztb1sd0006 AS a
    INNER JOIN ztb1sd0007 AS b " ### #### #### ## #### ##
       ON a~vbeln = b~vbeln
    LEFT OUTER JOIN ztb1mm0020 AS c " ## ## ### ##(####, #### #### ## ## ##)
       ON  c~zdocty = 'SO' " #### ## ####, #### #### ##### #####
       AND b~vbeln = c~zdocno
       AND b~posnr = c~zdocit
       AND c~lvorm <> 'X'        " #### ## ####
    WHERE a~lvorm  <> 'X'         " #### ## ###
    INTO CORRESPONDING FIELDS OF TABLE @gt_item.

  IF sy-subrc <> 0.
    MESSAGE i019(zmcb1) WITH '####'. " ### #### #### ####.
  ELSE.
    " ## ##, ## ## ## #### ## ### ## #### ####
    LOOP AT gt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
      " 1) ## ### ## #### ##(meins_2) ##
      IF <fs_item>-zavol IS NOT INITIAL.
        <fs_item>-meins_2 = <fs_item>-meins.
      ENDIF.
      " 2) ## ### ## #### ##(meins_3) ##
      IF <fs_item>-zsvol IS NOT INITIAL.
        <fs_item>-meins_3 = <fs_item>-meins.
      ENDIF.

      " ####/##### + ### ## ###
      <fs_item>-process  = 'SO'.
      <fs_item>-movement = 'GI'. " ##### ##(GI) ####
      PERFORM get_domain_text  USING 'ZDB1_MM_TYPE1' <fs_item>-process  CHANGING <fs_item>-text_p.
      PERFORM set_text_by_code USING 'M'             <fs_item>-movement CHANGING <fs_item>-text_s.
    ENDLOOP.

    " ALV ## ### # #### ## ## (## #)
    PERFORM set_item_style.
    MESSAGE s020(zmcb1) WITH sy-dbcnt '#'. " n## #### #######.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_item_style (200# ### ## ## )
*&---------------------------------------------------------------------*
FORM set_item_style.
  LOOP AT gt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
    " 1. ## ### ## ### ##
    IF <fs_item>-zmsno IS NOT INITIAL.
      <fs_item>-icon = icon_wd_check_box. " ### ## (##)
    ELSE.
      <fs_item>-icon = icon_pdir_foreward. " ### ### (##)
    ENDIF.

    " 2. ### ## ### ## (### ##)
    CASE <fs_item>-movement.
      WHEN 'GR'.
        <fs_item>-m_icon = icon_wd_inbound_plug.  " ### ###/### ###
      WHEN 'GI'.
        <fs_item>-m_icon = icon_wd_outbound_plug. " ### ###/### ###
    ENDCASE.

    " 3. ## (### ## ## ## ###### ## ###
    " <fs_item>-col_fld = 'C110'.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_selected_data (200# ALV ## ## # ### ## ### ## ## 220## ##)
*&---------------------------------------------------------------------*
FORM set_selected_data  USING    ps_item LIKE gs_item.
  DATA: lv_answer TYPE c.

  CALL FUNCTION 'POPUP_TO_CONFIRM'   " 1. ## ## ##
    EXPORTING
      titlebar              = '## ## ##'
      text_question         = |[{ ps_item-zdocno }] ## ### ## #### #####?|
      text_button_1         = '#'      " # ## ## ###
      text_button_2         = '###'  " # ## ## ###
      display_cancel_button = ' '            " ## ### ##
    IMPORTING
      answer                = lv_answer. " lv_answer# '1'## Yes ##, '2'## No ##

  IF lv_answer = '1'. " YES ### ## ## ##
    gv_visible = 'X'. " 220# ### ### ###

    CLEAR gs_volm. " 2. ### ##
    MOVE-CORRESPONDING ps_item TO gs_volm.

    SELECT SINGLE maktx FROM ztb1mm0002 INTO @gv_maktx
     WHERE matnr = @ps_item-matnr
      AND spras = '3' " @sy-langu ## ### ### ###
      .
    " 3. ## ## (## # ## ##)
    gs_volm-meins_2 = ps_item-meins.
    gs_volm-zunit   = 'CEL'.

    " 4. ### ### ## ## ### ## (## ### ## ##)
    " ## ### #### VCF 1.0# ### ### ##
    IF gs_volm-movement = 'GR'.
      gs_volm-zavol = ps_item-ordqty. " ## ## ## ## ## ##
    ELSE.
      gs_volm-zsvol = ps_item-ordqty. " ## ## ## ## ## ##
    ENDIF.

    " ## ##
    cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'REFRESH' ).
    MESSAGE s000(zmcb1) WITH '#### #######. #### #####.'.
  ELSE.
    gv_visible = ' '. " ## ## ##
  ENDIF.

ENDFORM.
