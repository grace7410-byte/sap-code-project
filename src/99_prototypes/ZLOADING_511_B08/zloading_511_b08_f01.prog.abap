*&---------------------------------------------------------------------*
*& Include          MZB1MM0002F01
*&---------------------------------------------------------------------*
*& Form set_init_item_rows (100# ### #### ALV ## # # ### - 10#)
*&---------------------------------------------------------------------*
FORM set_init_item_rows .
  IF gt_item IS INITIAL.
    DO 10 TIMES.
      APPEND INITIAL LINE TO gt_item. " #### 10# ##
    ENDDO.
    PERFORM set_item_number." 10## ## ## ## ##
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_item_number (100# ### ALV #### ## ## ## ##)
*&---------------------------------------------------------------------*
FORM set_item_number.
  " ## ### ## Modify# ### ### ## ## ##
  LOOP AT gt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
    <fs_item>-zeile = sy-tabix * 10. " alv## ## ## ## #*10 ex-0010, 0020, ...
  ENDLOOP.
  CHECK go_alv IS BOUND . " ## #####, ## # ## ### ### ### # ### ####
  go_alv->refresh_table_display( ). " ## ## ## ## refresh ##
ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_object (100# ### #### item ALV ##)
*&---------------------------------------------------------------------*
FORM create_object .
  CREATE OBJECT go_cont " Custom Container ####, Area# ##
    EXPORTING
      container_name              = 'AREA' " ### Layout# ## ## ##
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.
  CREATE OBJECT go_alv " ALV Grid ## #### Container# ##
    EXPORTING
      i_parent          = go_cont
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
*   #### ## ## ### ## #, ### # ## ## ## #### #### #### # #### ##
  go_alv->register_edit_event( i_event_id = cl_gui_alv_grid=>mc_evt_enter ).
  go_alv->register_edit_event( i_event_id = cl_gui_alv_grid=>mc_evt_modified ).

*   ALV# ## ### ## ## ## ### ## #### #
  go_alv->set_ready_for_input( i_ready_for_input = 1 ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_split_object (100# ### #### flow, tran, volm ALV ##)
*&---------------------------------------------------------------------*
FORM create_split_object .
  CREATE OBJECT go_container " ## ### ##### ##
    EXPORTING
      container_name = 'DOC'.

  CREATE OBJECT go_splitter " ##### # 3# ####
    EXPORTING
      parent  = go_container
      rows    = 1
      columns = 2.

  " go_splitter->set_row_height( id = 1 height = 12 ).
  " go_splitter->set_row_height( id = 2 height = 25 ).

  " # ## #### ####
  go_cont_tran = go_splitter->get_container( row = 1 column = 1 ).
  go_cont_volm = go_splitter->get_container( row = 1 column = 2 ).

  " CREATE OBJECT go_doc.
  CREATE OBJECT go_alv_tran EXPORTING i_parent = go_cont_tran.
  CREATE OBJECT go_alv_volm EXPORTING i_parent = go_cont_volm.
ENDFORM.
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
* SAPMZB1MM0002## #### [Refresh ##] 2##
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
    " item## #### alv layout ##
    ps_layout-sel_mode   = 'D'. " # ## ## ##
  ELSE.
    " tran, volm ## #### alv layout ##
    ps_layout-sel_mode   = 'B'. " ##/## # ## ##
*    ps_layout-excp_fname = 'EXCP_FLD'. " ## ### ### ###
*    ps_layout-excp_led = 'X'.
    ps_layout-info_fname = 'COL_FLD'. " # ## ## ## ##
    ps_layout-zebra      = 'X'. " ### ##
    ps_layout-cwidth_opt = 'X'. " # ## ## ###
  ENDIF.
  " ## ##
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_uifunc (100# ### ALV ## ## ## ##)
*&---------------------------------------------------------------------*
FORM set_uifunc USING pv_type TYPE i
                      pt_uifunc  TYPE ui_functions.
  REFRESH pt_uifunc.
  IF pv_type = 1.
    " item## #### ui function ##
    APPEND cl_gui_alv_grid=>mc_fc_detail       TO pt_uifunc. " ### ###
    APPEND cl_gui_alv_grid=>mc_fc_loc_copy     TO pt_uifunc.

    " # ### ####, ####, # ##, ##, ## ## ### ####
    APPEND cl_gui_alv_grid=>mc_fc_check        TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_fc_loc_cut      TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_fc_loc_paste    TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_fc_loc_paste_new_row TO pt_uifunc.
    APPEND cl_gui_alv_grid=>mc_fc_sort_asc     TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_fc_sort_dsc     TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_fc_find         TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_fc_filter       TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_fc_print        TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_fc_graph        TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_fc_info         TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_mb_sum          TO pt_uifunc.
    APPEND cl_gui_alv_grid=>mc_mb_variant      TO pt_uifunc.
    APPEND cl_gui_alv_grid=>mc_mb_view         TO pt_uifunc.
    APPEND cl_gui_alv_grid=>mc_mb_export       TO pt_uifunc.
  ELSE.
    " tran, volm ## #### ui function ##
  ENDIF.
  " ## ##
*    APPEND cl_gui_alv_grid=>mc_fc_excl_all TO pt_uifunc. " ## # ###
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat (Field Catalog ### ##)
*&---------------------------------------------------------------------*
FORM set_fcat TABLES tt_fcat TYPE lvc_t_fcat  " ### ## ### ### (gt_fcat)
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
*& set_fcat_item (100# ### item ALV ## #### ##)
*&---------------------------------------------------------------------*
FORM set_fcat_item CHANGING ct_fcat_item TYPE lvc_t_fcat.
  PERFORM set_fcat TABLES ct_fcat_item USING:
        'S' 'FIELDNAME' 'ZEILE', " ###### ## ##
        ' ' 'COLTEXT'   '##',   " ### ###
        ' ' 'LZERO'     'X',     " 0# ### 0010## ##(char4)
        ' ' 'OUTPUTLEN' '4',     " layout## ## ### ## #### ## ##
        'E' ''          '',      " APPEND ### #### ## (## ##)
        " ### 'S'# ##, #### ## ## 'E'# ####### #
                                                              " ## ### # ### ####, F4VAILABL# #### F4 Help# ### # ##
        'S' 'FIELDNAME' 'MATNR', ' ' 'COLTEXT' '####',         ' ' 'REF_TABLE' 'ZTB1MM0012', ' ' 'REF_FIELD' 'MATNR', ' ' 'EDIT' 'X', ' ' 'F4AVAILABL' 'X', 'E' ' ' ' ', " EDIT = 'X' ## ## ##
        'S' 'FIELDNAME' 'WERKS',  ' ' 'COLTEXT' '###',          ' ' 'REF_TABLE' 'ZTB1MM0007', ' ' 'REF_FIELD' 'WERKS', ' ' 'EDIT' 'X', ' ' 'F4AVAILABL' 'X', 'E' ' ' ' ',
        'S' 'FIELDNAME' 'LGORT',  ' ' 'COLTEXT' '####',         ' ' 'REF_TABLE' 'ZTB1MM0007', ' ' 'REF_FIELD' 'LGORT', ' ' 'OUTPUTLEN' '6', ' ' 'F4AVAILABL' 'X', ' ' 'EDIT' 'X', 'E' ' ' ' ',
        'S' 'FIELDNAME' 'MENGE',  ' ' 'COLTEXT' '####',       ' ' 'EDIT' 'X', ' ' 'NO_ZERO' 'X',   'E' ' ' ' ', " ' ' 'DECIMALS_OUT' '0', ' ' 'DECIMALS' '0',
        'S' 'FIELDNAME' 'MEINS',  ' ' 'COLTEXT' '####',      'E' ' ' ' ', " NO_ZERO = 'X' ## 0# # ## ## # #
        'S' 'FIELDNAME' 'NETPR',  ' ' 'COLTEXT' '##',          ' ' 'REF_TABLE' 'ZTB1MM0012', ' ' 'REF_FIELD' 'NETPR', ' ' 'NO_ZERO' 'X', 'E' ' ' ' ',
        'S' 'FIELDNAME' 'DMBTR',  ' ' 'COLTEXT' '# ##(##)',    ' ' 'REF_TABLE' 'ZTB1MM0012', ' ' 'REF_FIELD' 'DMBTR', ' ' 'OUTPUTLEN' '15', ' ' 'NO_ZERO' 'X', 'E' ' ' ' ',
        'S' 'FIELDNAME' 'WAERSK', ' ' 'COLTEXT' '##',       ' ' 'OUTPUTLEN' '5', 'E' ' ' ' ',
        'S' 'FIELDNAME' 'WRBTR',  ' ' 'COLTEXT' '# ##(####)',' ' 'REF_TABLE' 'ZTB1MM0012', ' ' 'REF_FIELD' 'WRBTR', ' ' 'OUTPUTLEN' '15', 'E' '' '',   " NO_OUT = 'X' ## ## ##
        'S' 'FIELDNAME' 'WAERS',  ' ' 'COLTEXT' '####',            'E' '' '',   " ##### #### ##
        'S' 'FIELDNAME' 'INSMK',  ' ' 'COLTEXT' '####',    ' ' 'OUTPUTLEN' '4', 'E' ' ' ' ',
        'S' 'FIELDNAME' 'ZLOSS',  ' ' 'COLTEXT' '###',     ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
        'S' 'FIELDNAME' 'CO_AREA',  ' ' 'COLTEXT' '######', ' ' 'NO_OUT' 'X',    'E' ' ' ' ',
        'S' 'FIELDNAME' 'CO_CENTER',  ' ' 'COLTEXT' '#####', ' ' 'NO_OUT' 'X',    'E' ' ' ' ',
        'S' 'FIELDNAME' 'EBELN',  ' ' 'COLTEXT' '#### ##', 'E' '' '',
        'S' 'FIELDNAME' 'EBELP',  ' ' 'COLTEXT' '#### ## ##', 'E' '' ''.
ENDFORM.
*&---------------------------------------------------------------------*
*& set_fcat_tran (100# ### tran ALV ## #### ##)
*&---------------------------------------------------------------------*
FORM set_fcat_tran CHANGING ct_fcat_tran TYPE lvc_t_fcat.
  PERFORM set_fcat TABLES ct_fcat_tran USING:
        'S' 'FIELDNAME' 'EXCP_FLD',     ' ' 'COLTEXT' '##',  ' ' 'ICON' 'X', ' ' 'KEY' 'X', ' ' 'EMPHASIZE' 'C110', 'E' ' ' ' ', " ### ## ###
        'S' 'FIELDNAME' 'EBELN',        ' ' 'COLTEXT' '#### ##',     ' ' 'KEY' 'X', ' ' 'EMPHASIZE' 'C110', ' ' 'HOTSPOT'   'X', 'E' ' ' ' ', " ##### ### ##
        'S' 'FIELDNAME' 'EBELP',        ' ' 'COLTEXT' '####',    ' ' 'LZERO'     'X', ' ' 'KEY' 'X', ' ' 'EMPHASIZE' 'C110', ' ' 'OUTPUTLEN' '4', 'E' ' ' ' ',
        " ###: NO_OUT 'X'
        'S' 'FIELDNAME' 'PACKNO',       ' ' 'COLTEXT' '### ### ##', ' ' 'NO_OUT' 'X', ' ' 'KEY' 'X', ' ' 'EMPHASIZE' 'C110', 'E' ' ' ' ',
        'S' 'FIELDNAME' 'SEQNO',        ' ' 'COLTEXT' '## ##',         ' ' 'NO_OUT' 'X', ' ' 'KEY' 'X', ' ' 'EMPHASIZE' 'C110', 'E' ' ' ' ',
        'S' 'FIELDNAME' 'EVENT_TYPE',   ' ' 'COLTEXT' '### ##',       ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
        " ### ## ## ~ ##
        'S' 'FIELDNAME' 'EVENT_STATUS', ' ' 'COLTEXT' '####',  'E' ' ' ' ',
        'S' 'FIELDNAME' 'EVENT_DATE',   ' ' 'COLTEXT' '##',       'E' ' ' ' ',
        'S' 'FIELDNAME' 'REMARK',     ' ' 'COLTEXT' '##',       'E' ' ' ' ',
        'S' 'FIELDNAME' 'LOCATION',     ' ' 'COLTEXT' '##',       'E' ' ' ' '.
ENDFORM.
*&---------------------------------------------------------------------*
*& set_fcat_volm (100# ### volm ALV ## #### ##)
*&---------------------------------------------------------------------*
FORM set_fcat_volm CHANGING ct_fcat_volm TYPE lvc_t_fcat.
  PERFORM set_fcat TABLES ct_fcat_volm USING:
         'S' 'FIELDNAME' 'ZMSNO',    ' ' 'COLTEXT' '## ##',       ' ' 'KEY' 'X', ' ' 'EMPHASIZE' 'C110', 'E' ' ' ' ', " ###: NO_OUT 'X'
         'S' 'FIELDNAME' 'ZDOCTY',   ' ' 'COLTEXT' '## ##',       ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZDOCNO',   ' ' 'COLTEXT' '#### ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZDOCIT',   ' ' 'COLTEXT' '####',   'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZAVOL',    ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZTEMP',    ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZUNIT',    ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZDENS',    ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZVCF',     ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZSVOL',    ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'MEINS',    ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZMDAT',    ' ' 'COLTEXT' '## ##',       'E' ' ' ' '.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_header_domain_value (### Fixed Value ### ##)
*&---------------------------------------------------------------------*
FORM get_domain_text USING    p_gv_domname TYPE any " ZDB1_MM_## #### domain#
                              p_gv_value   TYPE any " Fixed value# ####
                     CHANGING c_gv_text    TYPE any. " fv# description ####

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
*& Form get_data (####, #### ### ### ##)
*&---------------------------------------------------------------------*
FORM get_data.
  " 1. ## ## ## (## ## ### ### # ####)
  SELECT ebeln ebelp seqno event_type event_status event_date location remark
    FROM ztb1mm0021 AS a " ## ###
    INTO CORRESPONDING FIELDS OF TABLE gt_tran UP TO 100 ROWS.
  " ## CR, C# ### ##### ### ### ## ##### ## ### ##
*   WHERE event_type   = 'C'  " ## ## ## & event_status = 'CR' " ##### ## ### ### # ### ### #
*     AND NOT EXISTS ( SELECT * FROM ztb1mm0021 AS b
*                       WHERE b~ebeln  = a~ebeln
**                         " AND b~ebelp  = a~ebelp " ## ## ### #### #(### ### ## ## ### ### ##T ##)
*                         AND b~event_type = 'P' ). " ## ### ##(P)# ### # ##

  IF gt_tran IS INITIAL.
    MESSAGE s112(zmcb1) DISPLAY LIKE 'E' WITH '##'. " ## ### ## ## ####
    EXIT.
  ELSE. " tran# ### ### ### ## ### ####

    " 2. ## ## ## (### ## ## #### ### ##### ####)
    SELECT zmsno zdocty zdocno zdocit zavol ztemp zunit zdens zvcf zsvol meins zmdat
      FROM zdvb1mm0001 " ## ## DB View
                       " - ### ##### ##### ## ####T## ## ### ######(### ##### ##,
      INTO CORRESPONDING FIELDS OF TABLE gt_volm " - ####T## ####### ### ##### ## ### !
       FOR ALL ENTRIES IN gt_tran " FOR ALL ENTRIES# ## gt_tran# ## #### # ### # ## ###
     WHERE ebeln = gt_tran-ebeln
       AND ebelp = gt_tran-ebelp.

    IF gt_volm IS INITIAL.
      MESSAGE s112(zmcb1) DISPLAY LIKE 'E' WITH '####'. " ## ### #### ## ####
      EXIT.
    ENDIF.
  ENDIF.

  " 3. #### ## ## (### ##) -- ## ##, ## ##, ## #### ## #### ####
  DATA: lt_done_po TYPE TABLE OF ty_tran_key, " P(##) ## #### # ###
        lt_cr_po   TYPE TABLE OF ty_tran_key. " CR(####) ## #### # ###

  LOOP AT gt_tran INTO DATA(ls_tmp).
    " P# #### ## ## ##
    IF ls_tmp-event_type = 'P'.
      APPEND VALUE #( ebeln = ls_tmp-ebeln ) TO lt_done_po.
      " CR# #### ## ## ##
    ELSEIF ls_tmp-event_status = 'CR'.
      APPEND VALUE #( ebeln = ls_tmp-ebeln ) TO lt_cr_po.
    ENDIF.
  ENDLOOP.

  " ## ## (## ### = ######)
*  ##(10, 20, ,,)# ##### ## ### ### ## ## EBELP# #### ##
  SORT lt_done_po BY ebeln.
  DELETE ADJACENT DUPLICATES FROM lt_done_po COMPARING ebeln. " ## ### ##+##### ### ##
  SORT lt_cr_po BY ebeln.
  DELETE ADJACENT DUPLICATES FROM lt_cr_po COMPARING ebeln. " cr# ### ##+##### ### ##

  " gt_tran# ## ### # CR ### ## ## ###, CR ### ## ## ###
  LOOP AT gt_tran ASSIGNING FIELD-SYMBOL(<fs_tran>).

    " ## ## ## ## ### ## 'P' ### ### ##
    READ TABLE lt_done_po WITH KEY ebeln = <fs_tran>-ebeln
                          BINARY SEARCH TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      " ## ## #### P# ###, C ## ### ## ###### ## (### = ## ##)
      <fs_tran>-excp_fld = icon_green_light.
      <fs_tran>-col_fld  = ' '. " ## ## ## ## ##
      CONTINUE.
    ENDIF.

    " P# ### ## ## CR# #### ### ## (#### ##)
    READ TABLE lt_cr_po WITH KEY ebeln = <fs_tran>-ebeln
                        BINARY SEARCH TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      " ## ## ## P# ## ## (C### ## ##)
      <fs_tran>-excp_fld = icon_red_light. " ### = ## ##
      <fs_tran>-col_fld  = 'C300'. " ## #### ## ##
    ELSE.
      <fs_tran>-excp_fld = icon_yellow_light. " ### = ## #
      <fs_tran>-col_fld  = ' '.
    ENDIF.

  ENDLOOP.
  " ####### # = ### ### ## ###
  SORT gt_tran BY ebeln DESCENDING ebelp ASCENDING seqno ASCENDING.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_selected_data (##### ### #### ## #### ##)
*&---------------------------------------------------------------------*
FORM check_selected_data USING    ps_row_id TYPE lvc_s_row
                         CHANGING ps_tran   LIKE gs_tran
                                  pv_ref_po TYPE ebeln.
  " 1. ### # ### ####
  READ TABLE gt_tran INTO ps_tran INDEX ps_row_id-index.
  IF sy-subrc <> 0. " ### ### ### ###
    RETURN.
  ENDIF.

  " 3. ## ##(#### ##)# ## ## ## ##
  " gt_tran# ## DB View -> get_data()# ## 'P' ### ## ### ### ###
  DATA(lv_cr) = abap_false.

  LOOP AT gt_tran INTO DATA(ls_all) " #### ### ####, ## ### ### ## ### ##
    WHERE ebeln = ps_tran-ebeln
      AND ebelp = ps_tran-ebelp.
    IF ls_all-event_status = 'CR'. " #### CR# ### ## ## #### ##
      lv_cr = abap_true.
      EXIT. " #### ### ### ##
    ENDIF.
  ENDLOOP.

  " 4. CR(##, ### ##) #### # ### ### ## ##
  IF lv_cr = abap_false.
    MESSAGE s113(zmcb1) DISPLAY LIKE 'E' WITH '##' '(CR)'. " ## ### ## ## ## ## ##(CR)# ####
    CLEAR ps_tran. " ## # ### ### ##
    RETURN.
  ENDIF.

  " ## ##### ## ####(## ####) ## ##
  " #### ## ##### ######(ZEBELN #)# ##.
  SELECT SINGLE zebeln
    FROM ztb1mm0006
    INTO pv_ref_po
   WHERE ebeln = ps_tran-ebeln. " ### ## PO ### ##

  " 5. ## ## ## ##
  DATA: lv_answer   TYPE c,
        lv_question TYPE string. " ## ## # = #### -> ## ## ##### #### #### ###
  lv_question = |## ## [{ ps_tran-ebeln }] # #### [{ pv_ref_po }] # ## ######.| &&
                 |{ pv_ref_po } ### ## ########?|.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      text_question = lv_question
    IMPORTING
      answer        = lv_answer.

  IF lv_answer <> '1'. " Yes# ### #### ### ## PERFORM# # ## #
    CLEAR: ps_tran, pv_ref_po.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_selected_data (###### ### #### ##### ##)
*&---------------------------------------------------------------------*
FORM handle_selected_data USING ps_tran LIKE LINE OF gt_tran
                                 pv_ebeln LIKE gs_pohd-zebeln.
  " ## ### # ### ## ## ##
  IF gv_visible = abap_false. " ' ' # ##
    MESSAGE i017(zmcb1) WITH '[## ##]' '###'. " ## [## ##] ### ## ### ### ######
    RETURN. " ## ##
  ENDIF.

  DATA: ls_volm LIKE LINE OF gt_volm. " ps_tran(##### #####)# ####

  " ## get_data## ## #### gt_volm## ## tran# ## ### ##
  READ TABLE gt_volm INTO ls_volm
    WITH KEY zdocno = pv_ebeln.  " ##PO### ### '##PO##'# ####### ##

  IF sy-subrc = 0. " ##### ##### (1) ### ## ###: ##### ##
    ls_volm-col_fld = 'C510'.
    MODIFY gt_volm FROM ls_volm INDEX sy-tabix.
    go_alv_volm->refresh_table_display( ).

    " (2) ### #####, ## #### ## (### input #### ##)
    gs_pohd-ebeln = pv_ebeln.               " PO##
    gs_item-bwart = '101'.                  " #### ##
    " ## ## ###: ####/MS26####NN <- ###### ##
    gs_head-bktxt = |#### / { ls_volm-zmsno }|.

    " ### ALV ##
    PERFORM add_selected_data USING ls_volm. " #### ### #### ### ### ###### #### ###
    cl_gui_cfw=>set_new_ok_code( 'REFRESH' ).
    MESSAGE s606(zmcb1). " ## ## ### #######
  ELSE.
    " (3) ## ## #: ## #### ##
    MESSAGE i607(zmcb1). " ## ### #####. ## #### #####
    SET PARAMETER ID 'BES' FIELD pv_ebeln. " #### id# ## ###### ##
    CALL TRANSACTION 'ZRB1MM0001' AND SKIP FIRST SCREEN. " call transaction## #### ## ## # ## ### # ##.

    " (#### ####) #####
    PERFORM get_data. " ## ### ##### #
    go_alv_tran->refresh_table_display( ).
    go_alv_volm->refresh_table_display( ).
    MESSAGE s016(zmcb1) WITH '##'. " #### #######. ## #### ### #####
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form add_selected_data (### #### ### alv# ##)
*&---------------------------------------------------------------------*
FORM add_selected_data USING ps_volm LIKE LINE OF gt_volm.

  DATA: lt_item  TYPE TABLE OF ty_item, " gt_item# ### ##
        ls_item  LIKE LINE OF lt_item,
        lv_tabix TYPE sy-tabix.

  " 1. #### ##(ps_volm-zdocno)# #### ## ###
  "    CDS view## ### ## ### ## #### itab# ##
  SELECT ebeln, ebelp, matnr, werks, lgort, menge, meins, fin_netpr_krw AS netpr, waersk, fin_netpr_usd AS netpr_usd, waers, insmk, add_ukurs
    FROM zcds_b1_mm_0002( p_bldat = @gs_head-bldat ) " ##### ### ####(#### ### bldat)
    INTO CORRESPONDING FIELDS OF TABLE @lt_item
   WHERE ebeln = @ps_volm-zdocno.
  "  AND postat = '2'. " ## ##
  " AND lvorm <> 'X' " ## ## -> ## CDS view ### ###

  IF sy-subrc <> 0.
    MESSAGE i112(zmcb1) WITH '#### ## ##'. " ## ### #### ## ## ## ####
    RETURN.
  ENDIF.

  " 2. ## ALV# gt_item# ##### #### ## + ## ### ####
  LOOP AT lt_item INTO ls_item. " ### #### ##### gt_item ### ### ##

    " 2-1. ## ### ### ## ### 0### ### 0# ##
    IF ls_item-add_ukurs = 0 OR ls_item-netpr = 0.
      MESSAGE i407(zmcb1) WITH ls_item-matnr '##:' '###'. " (####) ##: ## ### ## ### ### #####.
      CONTINUE. " ## #### ALV# #### ## ## ### ###
    ENDIF.

    " 2-2. ##### ## # # ##
    READ TABLE gt_item WITH KEY matnr = '' TRANSPORTING NO FIELDS.
    lv_tabix = sy-tabix.

    IF sy-subrc = 0.
      " 2-3. # ## ### ## ## lv_tabix# #### #### (#### ##)
      READ TABLE gt_item ASSIGNING FIELD-SYMBOL(<fs_item>) INDEX lv_tabix.
    ELSE.
      " 2-4. ## 10## # ### ### ## ####
      APPEND INITIAL LINE TO gt_item ASSIGNING <fs_item>.
      PERFORM set_item_number. " ## ## ## ## ### ## ##### ### ##
    ENDIF.

    " (1) ## ## ##
    MOVE-CORRESPONDING ls_item TO <fs_item>. " ######
    <fs_item>-insmk = 'T'.   " #### (#### ## = #### ##)
    <fs_item>-bwart = gs_item-bwart.   " #### (#### ##)

    " (2) ## ##
    " ## ### ## #### ### #### ### ###
    " ## ### ## '## ##'# ## #### ###
    IF ls_item-ebelp = ps_volm-zdocit.
      <fs_item>-menge = ps_volm-zsvol. " ## ## ##
    ELSE.
      MESSAGE s608(zmcb1) WITH '####' DISPLAY LIKE 'W'.
    ENDIF.

    " (3) ## ##
    <fs_item>-dmbtr = <fs_item>-netpr * <fs_item>-menge. " ###(##)
    <fs_item>-wrbtr = <fs_item>-netpr_usd * <fs_item>-menge.  " ###(####)
  ENDLOOP.

  " 3. ## ### ALV ####
  PERFORM refresh_alv USING gs_stable CHANGING go_alv.
ENDFORM.
*&---------------------------------------------------------------------*
*& FORM control_header_screen (100# ### ALV #### ## ## ## ##)
*&---------------------------------------------------------------------*
FORM control_header_screen.
  " 1. #### #### ### ## ## ###
  DATA(lv_editable) = abap_true.
  LOOP AT gt_item TRANSPORTING NO FIELDS WHERE matnr IS NOT INITIAL.
    lv_editable = abap_false. " #### #### ### (### ###) ## ## ##
    EXIT.
  ENDLOOP.

  " 2. ### ### ## ##### ### ## ##(##/###)# ##
  LOOP AT SCREEN.
    IF screen-name = 'GS_VOLM-ZDOCTY' OR   " ## ## (GR Goods Receipt #)
       screen-name = 'GS_POHD-BSART' OR   " #### ##
       screen-name = 'GS_POHD-EBELN' OR   " PO ##
       screen-name = 'GS_ITEM-BWART' OR   " ####
       screen-name = 'GS_HEAD-BLDAT'. " #### ### #### ##(## ## ### ## ##, ### ## ##### ##
      " #### ###(lv_editable=false) input# 0##, ### 1# ##
      IF lv_editable = abap_false.
        screen-input = 0.
      ELSE.
        screen-input = 1.
      ENDIF.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_data_changed (100# ### ALV ### ## # ##)
*&---------------------------------------------------------------------*
FORM handle_data_changed USING pr_data_changed TYPE REF TO cl_alv_changed_data_protocol.
  DATA: ls_mod_cell TYPE lvc_s_modi, " ### # ### ## ###
        lv_matnr    TYPE matnr, " # ### ###, #### #### ## #### ##
        lv_menge    TYPE menge_d,
        lv_netpr    TYPE netpr.      " KRW ### ##
*        lv_ukurs    TYPE ukurs_curr, " ## ##
*        lv_wrbtr    TYPE wrbtr,      " ## ## (USD #)
*        lv_dmbtr    TYPE dmbtr.      " ## ## (KRW)

  LOOP AT pr_data_changed->mt_good_cells INTO ls_mod_cell WHERE value IS NOT INITIAL. " #### ## ### ###
    " #### ## ### ## ####, ## ## # # ## #### ##
    CHECK ls_mod_cell-value IS NOT INITIAL.
    " ## ### ## #### ## ### ## ###. row_id# gt_item# ### ##
    READ TABLE gt_item ASSIGNING FIELD-SYMBOL(<fs_item>) INDEX ls_mod_cell-row_id.
    CHECK sy-subrc = 0. " # ### ## ### # #

    CASE ls_mod_cell-fieldname. " ## #### ###### ## ##
        " #1. ##### ### #####
      WHEN 'MATNR'.
        " 1) #### ### #### # ####
        pr_data_changed->get_cell_value( EXPORTING i_row_id = ls_mod_cell-row_id i_fieldname = 'MATNR' IMPORTING e_value = lv_matnr ).

        " 2) ##### ### ## ## ## - #### #### ## ### ### #### ##
        IF lv_matnr IS NOT INITIAL.
          " 2-1. # ## #### ### PO## #### ### ##
          IF gs_pohd-ebeln IS INITIAL.
            MESSAGE '## ### PO ## ## ##### #### ### #####' TYPE 'S' DISPLAY LIKE 'E'.
            PERFORM clear_item_row USING pr_data_changed ls_mod_cell-row_id <fs_item>.
            EXIT. " -> ### ## ##
          ENDIF. " ## PO## # ### # # #### ####

          " 2-2. CDS View Entity# #### ## ### ##### #### #### ##
          SELECT SINGLE ebelp, fin_netpr_usd, fin_netpr_krw, add_ukurs, waers, meins " ########, ######, krw##, ### ##, ####, ####
            FROM zcds_b1_mm_0002( p_bldat = @gs_head-bldat ) " #### ##### ##
            WHERE ebeln = @gs_pohd-ebeln
              AND matnr = @lv_matnr " #### ####, ##### ## ### CDS## 1# #### ## !
            INTO (@<fs_item>-ebelp, @<fs_item>-netpr_usd, @<fs_item>-netpr, @<fs_item>-add_ukurs, @<fs_item>-waers, @<fs_item>-meins).

          IF sy-subrc = 0.
            " 2-3-1) ### ### ## #### ### ##### ##
            <fs_item>-ebeln = gs_pohd-ebeln.
            <fs_item>-bwart = '101'. " gs_item-bwart ## 101 ## ##(#### ##)
            <fs_item>-insmk = 'T'.   " ##### # #### (#### ## = #### ##)
            <fs_item>-waersk = 'KRW'.

            " 2-3-2) #### ####(KRW), ####, ##### #### ### ####
            pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'NETPR' i_value = <fs_item>-netpr ).
            pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'WAERS'     i_value = <fs_item>-waers ).
            pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'WAERSK'    i_value = 'KRW' ).
            pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'MEINS'     i_value = <fs_item>-meins ).
          ELSE.
            " 2-2) #### ## ##### ### ### ### ## # ###
            gv_show_msg  = abap_true. " ### ### ##
            gv_msg_matnr = lv_matnr.  " ## ### #### ##
            PERFORM clear_item_row USING pr_data_changed ls_mod_cell-row_id <fs_item>.
          ENDIF.

        ELSE. " lv_matnr IS INITIAL
          " 3) #### #### ### ## # ## ## #### ##
          gv_show_msg  = abap_true. " ### ### ##
          gv_msg_matnr = lv_matnr.  " ## ### #### ##
          PERFORM clear_item_row USING pr_data_changed ls_mod_cell-row_id <fs_item>.
        ENDIF.

        " #2. ### #####
      WHEN 'MENGE'. "### ### ## ## ## ### ###
        pr_data_changed->get_cell_value( EXPORTING i_row_id = ls_mod_cell-row_id i_fieldname = 'MENGE' IMPORTING e_value = lv_menge ).

        " 1) ## ## ##: KRW ## * ##
        <fs_item>-dmbtr = <fs_item>-netpr * lv_menge.

        " 2) ####(USD #) ## ##: USD ## * ##
        <fs_item>-wrbtr = <fs_item>-netpr_usd * lv_menge.

        " ALV ### ### ## ####
        pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'DMBTR' i_value = <fs_item>-dmbtr ).
        pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'WRBTR' i_value = <fs_item>-wrbtr ).
        pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'WAERS' i_value = <fs_item>-waers ).

        " #4. #### #### ## #
      WHEN 'WERKS' OR 'LGORT'.
        " 1) ## ## #### #### ## ###
        pr_data_changed->get_cell_value( EXPORTING i_row_id = ls_mod_cell-row_id i_fieldname = 'WERKS' IMPORTING e_value = <fs_item>-werks ).
        pr_data_changed->get_cell_value( EXPORTING i_row_id = ls_mod_cell-row_id i_fieldname = 'LGORT' IMPORTING e_value = <fs_item>-lgort ).

        " 2) # # ## ## ## ### ### ##
        PERFORM check_plant_storage_master USING pr_data_changed ls_mod_cell-row_id <fs_item>.
    ENDCASE.
  ENDLOOP.

  " ### ### ### # (5)# ### ##/### ## ## ## ## ##
  PERFORM control_header_screen.
  PERFORM refresh_alv USING gs_stable CHANGING go_alv.

  IF gv_show_msg IS NOT INITIAL.
    MESSAGE s109(zmcb1) WITH gv_msg_matnr DISPLAY LIKE 'W'. " (##### ###/####) ## ### ## # ####
    CLEAR: gv_show_msg, gv_msg_matnr.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_plant_storage_master (### #### ### ##)
*&---------------------------------------------------------------------*
FORM check_plant_storage_master USING pr_data_changed TYPE REF TO cl_alv_changed_data_protocol
                                      pv_row_id TYPE lvc_s_modi-row_id
                                      ps_item STRUCTURE gs_item.
  IF  ps_item-werks IS NOT INITIAL AND ps_item-lgort IS NOT INITIAL.
    SELECT SINGLE werks, lgort
      FROM ztb1mm0000
      WHERE werks = @ps_item-werks
        AND lgort = @ps_item-lgort
      INTO @DATA(lv_check).

    IF sy-subrc <> 0.
      " 3) #### ## #### ## ##
      gv_show_msg = abap_true.
      gv_msg_matnr = |{ ps_item-werks }/{ ps_item-lgort }|. " #### ### '###/####' ### ### ####

      " ## ### ### (### ALV ## ### ## ####### #)
      ps_item-werks = ''.
      ps_item-lgort = ''.
      pr_data_changed->modify_cell( i_row_id = pv_row_id i_fieldname = 'WERKS' i_value = '' ).
      pr_data_changed->modify_cell( i_row_id = pv_row_id i_fieldname = 'LGORT' i_value = '' ).
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& FORM clear_item_row (100# ### ALV ### ### ###)
*&---------------------------------------------------------------------*
FORM clear_item_row USING pr_data_changed TYPE REF TO cl_alv_changed_data_protocol
                          pv_row_id       TYPE lvc_s_modi-row_id
                          p_fs_item       STRUCTURE gs_item.

  " itab ### & ALV ## ###
  CLEAR: p_fs_item-meins, p_fs_item-netpr, p_fs_item-waersk, p_fs_item-waers, p_fs_item-menge, p_fs_item-dmbtr, p_fs_item-wrbtr.

  pr_data_changed->modify_cell( i_row_id = pv_row_id i_fieldname = 'MEINS'  i_value = '' ). " ##### # ##
  pr_data_changed->modify_cell( i_row_id = pv_row_id i_fieldname = 'NETPR'  i_value = 0 ).
  pr_data_changed->modify_cell( i_row_id = pv_row_id i_fieldname = 'WAERSK' i_value = '' ).
  pr_data_changed->modify_cell( i_row_id = pv_row_id i_fieldname = 'WAERS'     i_value = '' ).
  pr_data_changed->modify_cell( i_row_id = pv_row_id i_fieldname = 'MENGE'  i_value = 0 ).
  pr_data_changed->modify_cell( i_row_id = pv_row_id i_fieldname = 'DMBTR'  i_value = 0 ).
  pr_data_changed->modify_cell( i_row_id = pv_row_id i_fieldname = 'WRBTR'     i_value = 0 ).
ENDFORM.
*&---------------------------------------------------------------------*
*& FORM check_po_status (###### ## ## ## ##)
*&---------------------------------------------------------------------*
FORM check_po_status USING pv_mat_po TYPE ebeln. " #### #### ### ### ### #####
  DATA: lv_tran_po   TYPE ebeln, " ### ### ##### ####, ##### '######'# ### ### #### ##
        lv_cr_exists TYPE abap_bool, " cr#(## ## ##) #####,
        lv_p_exists  TYPE abap_bool. " p##(## ## ##, ###### ## ##)# ### ##

  " 1. # ## PO# #### ## PO# ### ## ####,
  SELECT SINGLE ebeln
    FROM ztb1mm0006 " #### ##
    INTO @lv_tran_po " ## PO ##
   WHERE zebeln = @pv_mat_po. " ####### ## PO# ## PO ##

  IF sy-subrc <> 0.
    MESSAGE e609(zmcb1) WITH '####'. " ## ### ## #######
    RETURN.
  ENDIF.

  " 2. ## ## PO# ### ### (CR# ## P# ### #)
  SELECT event_type, event_status
    FROM ztb1mm0021
    WHERE ebeln = @lv_tran_po
    INTO TABLE @DATA(lt_status).

  " CR(## ##) ### ### ##
  READ TABLE lt_status WITH KEY event_status = 'CR' TRANSPORTING NO FIELDS.
  IF sy-subrc = 0.
    lv_cr_exists = abap_true.
  ENDIF.

  " P(## ## ## ##) ### ## ### ##
  READ TABLE lt_status WITH KEY event_type = 'P' TRANSPORTING NO FIELDS.
  IF sy-subrc = 0.
    lv_p_exists = abap_true.
  ENDIF.

  " 3. ## ## - CR# ## + P# ## # ##### ###
  IF lv_cr_exists = abap_false.
    MESSAGE e113(zmcb1) WITH '##' '(CR)'.
  ELSEIF lv_p_exists = abap_true.
    MESSAGE e610(zmcb1) WITH '####'. " ## ## ### ### #####
  ELSE.
    " MESSAGE '## ### #####' TYPE 'S'. ## ## ### ##X
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& FORM check_data_before_save (100# ### ## ### ### ##)
*&---------------------------------------------------------------------*
FORM check_data_before_save CHANGING cv_subrc TYPE sysubrc.
  DATA: lv_error_cnt   TYPE i VALUE 0, " ## #### ### ALV ## #### #### ##
        lo_protocol    TYPE REF TO cl_alv_changed_data_protocol,
        lv_item_exists TYPE abap_bool. " #### #### ### ###

  CREATE OBJECT lo_protocol. " ## #### ## ## (### ###)
  cv_subrc = 0.

  " #1. ## ##
  " ## 1) ##### ### ## ## ##
  IF gs_head-bldat < sy-datum AND gs_head-bldat IS NOT INITIAL. " ## #### &1 # # #### / &1 ### ## ## #####
    PERFORM check_and_add_protocol USING gs_head-bldat 'E' '012' '## ##' 'GS_HEAD-BLDAT' 0 lo_protocol CHANGING lv_error_cnt.
  ELSEIF gs_head-bldat IS INITIAL. " ## ## ###. (#### #### ##### ###, ## #### ## #### ### #### ### #### #)
    PERFORM check_and_add_protocol USING gs_head-bldat 'E' '014' '####' 'GS_HEAD-BLDAT' 0 lo_protocol CHANGING lv_error_cnt.
  ENDIF.
  " ## 2) ####, ######, ######, ####, ####, ####### ## #### ##
  PERFORM check_and_add_protocol USING gs_volm-zdocty 'E' '014' '####' 'GS_VOLM-ZDOCTY' 0 lo_protocol CHANGING lv_error_cnt.
  PERFORM check_and_add_protocol USING gs_pohd-bsart 'E' '014' '#### ##' 'GS_POHD-BSART' 0 lo_protocol CHANGING lv_error_cnt.
  PERFORM check_and_add_protocol USING gs_pohd-ebeln 'E' '014' '#### ##' 'GS_POHD-EBELN' 0 lo_protocol CHANGING lv_error_cnt.
  PERFORM check_and_add_protocol USING gs_item-bwart 'E' '014' '####' 'GS_ITEM-BWART' 0 lo_protocol CHANGING lv_error_cnt.
  PERFORM check_and_add_protocol USING gs_head-bukrs 'E' '014' '####' 'GS_HEAD-BUKRS' 0 lo_protocol CHANGING lv_error_cnt.
  PERFORM check_and_add_protocol USING gs_head-bktxt 'E' '014' '## ## ###' 'GS_HEAD-BKTXT' 0 lo_protocol CHANGING lv_error_cnt.

  " ## #### #### ###### ## ### ##
  TYPES: BEGIN OF ty_sum,
           matnr TYPE ty_item-matnr,
           menge TYPE ty_item-menge,
         END OF ty_sum.
  DATA: lt_sum TYPE TABLE OF ty_sum,
        ls_sum LIKE LINE OF lt_sum.

  " ### ## #) ### ## ## ### ## ####! (grouping ##)
  LOOP AT gt_item INTO DATA(ls_check) WHERE matnr IS NOT INITIAL.
    " lt_sum# # ### ## ##### ##(### ## ### ### ### #### #### #)
    READ TABLE lt_sum ASSIGNING FIELD-SYMBOL(<fs_sum>)
                      WITH KEY matnr = ls_check-matnr.
    IF sy-subrc = 0.
      " ## ### ## ### #### ### #
      <fs_sum>-menge = <fs_sum>-menge + ls_check-menge.
    ELSE.
      " ### ### ##, # ### ## ### ####
      ls_sum-matnr = ls_check-matnr.
      ls_sum-menge = ls_check-menge.
      APPEND ls_sum TO lt_sum.
    ENDIF.
  ENDLOOP.

  " #2. ### ### ##
  LOOP AT gt_item INTO DATA(ls_item).
    DATA(lv_tabix) = sy-tabix.

    " ######, ###, ####, ## # #### ###### #### - ## ### 10## ## ### ## ##
    IF ls_item-matnr IS NOT INITIAL OR ls_item-werks IS NOT INITIAL
        OR ls_item-lgort IS NOT INITIAL OR ls_item-menge IS NOT INITIAL.
      lv_item_exists = abap_true. " #### ### ## ### ##### (## ### ## ##)

      " ## 1) #### ### ## (## ##, ##t ## ##)
      PERFORM check_and_add_protocol USING ls_item-matnr 'E' '014' '####' 'MATNR' lv_tabix lo_protocol CHANGING lv_error_cnt.
      IF ls_item-matnr IS NOT INITIAL. " ### ###, ## ### ##### ## #### ##
        SELECT SINGLE matnr
        FROM zcds_b1_mm_0002(  p_bldat = @gs_head-bldat )
          WHERE ebeln = @gs_pohd-ebeln AND matnr = @ls_item-matnr
          INTO @DATA(lv_dummy).
        IF sy-subrc <> 0. " pv_value ### matnr# ## INITIAL ## ### ## ####
          PERFORM check_and_add_protocol USING ls_item-matnr 'E' '109' ls_item-matnr 'MATNR' lv_tabix lo_protocol CHANGING lv_error_cnt.
        ENDIF.
      ENDIF.

      " ## 2) ### # #### ### ##
      PERFORM check_and_add_protocol USING ls_item-werks 'E' '014' '###' 'WERKS' lv_tabix lo_protocol CHANGING lv_error_cnt.
      PERFORM check_and_add_protocol USING ls_item-lgort 'E' '014' '####' 'LGORT' lv_tabix lo_protocol CHANGING lv_error_cnt.
      " ## ## ### -> ## #### ###(#### ## ###) ##
      IF ls_item-werks IS NOT INITIAL AND ls_item-lgort IS NOT INITIAL.
        SELECT SINGLE werks FROM ztb1mm0000
          WHERE werks = @ls_item-werks AND lgort = @ls_item-lgort AND lvorm <> 'X'
          INTO @DATA(lv_dummy_lg).
        IF sy-subrc <> 0. " #### ## ###/#### ### ## ##
          PERFORM check_and_add_protocol USING '' 'E' '010' '### # ####' 'WERKS' lv_tabix lo_protocol CHANGING lv_error_cnt.
        ENDIF.
      ENDIF.

      " ## 3) ## 1 ## ##
      IF ls_item-menge <= 1.
        PERFORM check_and_add_protocol USING '' 'E' '111' ls_item-meins 'MENGE' lv_tabix lo_protocol CHANGING lv_error_cnt.
      ENDIF.

      " ## 4) ## ## < #### ## ## (###)

    ENDIF.
  ENDLOOP. " ## ### ## ## # ##### ## ## ### #
  " #, ### ## #### ## ## ## ### ### ##
  IF lv_item_exists = abap_false.
    PERFORM check_and_add_protocol USING '' 'E' '000' '### ##' 'MANDT' lv_tabix lo_protocol CHANGING lv_error_cnt.
  ENDIF.

  " #3. ### #### ### ## ###
  IF lv_error_cnt > 0.
    lo_protocol->display_protocol( ).
    cv_subrc = 4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& FORM check_and_add_protocol (100# ### ## ## ###)
*&---------------------------------------------------------------------*
FORM check_and_add_protocol USING pv_value     TYPE any       " ### #
                                pv_msgty     TYPE symsgty   " ### ## (E, W #)
                                pv_msgno     TYPE symsgno   " ### ##
                                pv_msgv1     TYPE any       " ### ## 1 (&1)
                                pv_fieldname TYPE fieldname " ## ###
                                pv_row_id    TYPE any       " # ## (##### lv_tabix, ### 0)
                                pr_protocol  TYPE REF TO cl_alv_changed_data_protocol
                       CHANGING p_error_cnt  TYPE i.        " ## ### (#####)

  " 1. ## ##: ## ##### ##### ## / ### #### ## #### ##
  IF pv_value IS INITIAL OR ( pv_fieldname CP '*BEDAT*' AND pv_value < sy-datum ).
    " 2. ## ### ##
    p_error_cnt = p_error_cnt + 1.

    " 3. #### ## (ZMCB1 #### ##)
    pr_protocol->add_protocol_entry(
        i_msgid     = 'ZMCB1'
        i_msgty     = pv_msgty
        i_msgno     = pv_msgno
        i_msgv1     = |{ pv_msgv1 }| " ## ## #### #### ##
        i_fieldname = pv_fieldname
        i_row_id    = pv_row_id      " 0## ### #### #### ### ##
    ).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& FORM confirm_save (100# ### ## ###)
*&---------------------------------------------------------------------*
FORM confirm_save CHANGING cv_answer TYPE char1.

  DATA: lv_title     TYPE string VALUE '## ##',
        lv_text      TYPE string,
        lv_count     TYPE i,
        lv_total_qty TYPE menge_d. " # ## ##

  " ## ### ##
  LOOP AT gt_item INTO DATA(ls_item) WHERE matnr IS NOT INITIAL.
    lv_count = lv_count + 1.
    lv_total_qty = lv_total_qty + ls_item-menge.
  ENDLOOP.

  " ### ##
  lv_text = |#### [{ gs_head-ebeln }] ##\n| &&
            |# { lv_count }## ##, ## ## { lv_total_qty NUMBER = USER } { ls_item-meins }#\n| &&
            |### ## ########?|.

  " ## ##
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = lv_title
      text_question         = lv_text
      text_button_1         = '####'(001)
      icon_button_1         = 'ICON_SYSTEM_SAVE'
      text_button_2         = '##'(002)
      icon_button_2         = 'ICON_CANCEL'
      display_cancel_button = ' '
    IMPORTING
      answer                = cv_answer.

  cv_answer = COND #( WHEN cv_answer = '1' THEN 'J' ELSE 'N' ).

ENDFORM.
*&---------------------------------------------------------------------*
*& FORM save_gr_data (#### ## ### ##)
*&---------------------------------------------------------------------*
FORM save_gr_data.
  DATA: lv_mblnr TYPE ztb1mm0011-mblnr,
        ls_head  TYPE ztb1mm0011,
        lt_item  TYPE TABLE OF ztb1mm0012,
        ls_item  TYPE ztb1mm0012,
        lv_zeile TYPE i.

  " 1. ## #### ## ## (SNRO ##)
  PERFORM get_new_gr_number CHANGING lv_mblnr.

  IF lv_mblnr IS INITIAL.
    MESSAGE e006(zmcb1) WITH ': #### ## ## ##'.
    RETURN.
  ENDIF.

  " 2. ## ### ## (ZTB1MM0011)
  ls_head-mblnr = lv_mblnr.
  ls_head-mjahr = sy-datum(4).
  ls_head-bldat = sy-datum.      " ###
  ls_head-budat = sy-datum.      " ###
  ls_head-ebeln = gs_head-ebeln. " ## #### ##
  ls_head-vgart = 'WE'.          " #### (WE: ##)
  ls_head-ernam = sy-uname.
  ls_head-erdat = sy-datum.
  ls_head-erzet = sy-uzeit.

  " 3. ### ### ## (ZTB1MM0012)
  CLEAR lt_item.
  LOOP AT gt_item INTO DATA(ls_screen) WHERE matnr IS NOT INITIAL.
    lv_zeile = lv_zeile + 1.

    CLEAR ls_item.
    MOVE-CORRESPONDING ls_screen TO ls_item.

    ls_item-mblnr = lv_mblnr.
    ls_item-mjahr = ls_head-mjahr.
    ls_item-zeile = lv_zeile.      " #### (1, 2, 3...)
    ls_item-bwart = '101'.         " #### (101: PO## ##)

    " ## ## (KRW ### ## ## ##)
    IF ls_screen-waersk = 'KRW'.
      CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
        EXPORTING
          currency    = ls_screen-waersk
          idoc_amount = ls_screen-dmbtr
        IMPORTING
          sap_amount  = ls_item-dmbtr.
    ENDIF.

    " #### ## ## ##
    ls_item-ebeln = ls_screen-ebeln.
    ls_item-ebelp = ls_screen-ebelp.

    " ## ##
    ls_item-ernam = sy-uname.
    ls_item-erdat = sy-datum.
    ls_item-erzet = sy-uzeit.

    APPEND ls_item TO lt_item.
  ENDLOOP.

  " 4. DB ## # #### ##
  INSERT ztb1mm0011 FROM ls_head.
  IF sy-subrc = 0.
    INSERT ztb1mm0012 FROM TABLE lt_item.

    IF sy-subrc = 0.
      COMMIT WORK.
      MESSAGE s104(zmcb1) WITH lv_mblnr. " ## ### (#### ##)

      " ## # ## ## (#: ### ### #### ## ##)
      gv_mblnr = lv_mblnr.
      " PERFORM refresh_after_save.
    ELSE.
      ROLLBACK WORK.
      MESSAGE e006(zmcb1) WITH ': #### ## ## ##'.
    ENDIF.
  ELSE.
    ROLLBACK WORK.
    MESSAGE e006(zmcb1) WITH ': #### ## ## ##'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_new_gr_number (## ## ## ##)
*&---------------------------------------------------------------------*
FORM get_new_gr_number CHANGING cv_mblnr.

  DATA: lv_number TYPE nriv-nrlevel.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = '01'            " SNRO# Interval ##
      object                  = 'ZNRB1MM03'     " ## ### NR
    IMPORTING
      number                  = lv_number       " ### ##
    EXCEPTIONS
      interval_not_found      = 1
      number_range_not_found  = 2
      object_not_found        = 3
      quantity_is_0           = 4
      quantity_is_not_1       = 5
      interval_overflow       = 6
      buffer_overflow         = 7
      OTHERS                  = 8.

  IF sy-subrc = 0.
    " 10## ### ### ####
    cv_mblnr = |{ lv_number ALPHA = IN }|.
  ELSE.
    " ## ## # ## ###
    MESSAGE e015(zmcb1).
  ENDIF.

ENDFORM.
**&---------------------------------------------------------------------*
**& Form set_screen_after_save (#### ## ## ## ##)
**&---------------------------------------------------------------------*
*FORM set_screen_after_save.
*  " 1. ## ### ### (## ## # ##)
*  PERFORM clear_header_data.
*  " 2. ### ### ### ###
*  REFRESH gt_item.
*  " 3. ALV ## ###
*  " #### ### # # ## #### ### ## ###### ## ###
*  PERFORM set_init_item_rows.
*  " 4. ALV ####
*  IF go_alv IS BOUND.
*    PERFORM refresh_alv.
*  ENDIF.
*  " 5. ## ## ## (#### #### ## ## #### ##)
*  PERFORM control_header_screen.
*ENDFORM.
*&---------------------------------------------------------------------*
*& ### ## ## #### ## ##
*&---------------------------------------------------------------------*
FORM display_process_flow.
  DATA: lo_table TYPE REF TO cl_dd_table_element,
        lo_c1    TYPE REF TO cl_dd_area, lo_c2  TYPE REF TO cl_dd_area,
        lo_c3    TYPE REF TO cl_dd_area, lo_c4  TYPE REF TO cl_dd_area,
        lo_c5    TYPE REF TO cl_dd_area, lo_c6  TYPE REF TO cl_dd_area,
        lo_c7    TYPE REF TO cl_dd_area, lo_c8  TYPE REF TO cl_dd_area,
        lo_c9    TYPE REF TO cl_dd_area, lo_c10  TYPE REF TO cl_dd_area,
        lo_c11   TYPE REF TO cl_dd_area.

*  go_doc->add_text_as_heading(
*    EXPORTING
*      text          =   '########## 70%'
*  ).
*  " ### ##
  go_doc->add_table( EXPORTING no_of_columns = 11
                               border        = '0'
                               width         = '100%'
                     IMPORTING table     = lo_table ).

  " ICON_SYSTEM_START_RECORDING
  " ICON_WD_CONTEXT
  " ICON_WD_RADIO_BUTTON_EMPTY

  " [## ## ##]
  lo_table->add_column( EXPORTING width = '15%' IMPORTING column = lo_c1 ).
  lo_c1->add_gap( width = 15 ).
  IF gv_load_tran = 'X'.
    lo_c1->add_icon( sap_icon = 'ICON_OO_OBJECT' ).
    lo_table->add_column(  EXPORTING width = '2%' IMPORTING column = lo_c2 ). " ## ## ##
    lo_c2->add_icon( sap_icon = 'ICON_PDIR_FOREWARD' ).
  ELSE.
    lo_c1->add_icon( sap_icon = 'ICON_DRAW_ELLIPSE' ).
    lo_table->add_column(  EXPORTING width = '2%' IMPORTING column = lo_c2 ).
    lo_c2->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).
  ENDIF.

  " [## #### ##]
  lo_table->add_column(  EXPORTING width = '15%' IMPORTING column = lo_c3 ).
  lo_c3->add_gap( width = 15 ).
  IF gv_load_volm = 'X'.
    lo_c3->add_icon( sap_icon = 'ICON_OO_OBJECT' ).
    lo_table->add_column(  EXPORTING width = '2%' IMPORTING column = lo_c4 ). " ## ## ##
    lo_c4->add_icon( sap_icon = 'ICON_PDIR_FOREWARD' ).
  ELSE.
    lo_c3->add_icon( sap_icon = 'ICON_DRAW_ELLIPSE' ).
    lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_c4 ).
    lo_c4->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).
  ENDIF.

  " [## ## ##]
  lo_table->add_column( EXPORTING width = '15%' IMPORTING column = lo_c5 ).
  lo_c5->add_gap( width = 15 ).
  IF gv_load_gr = 'X'.
    lo_c5->add_icon( sap_icon = 'ICON_OO_OBJECT' ).
    lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_c6 ). " ## ## ##
    lo_c6->add_icon( sap_icon = 'ICON_PDIR_FOREWARD' ).
  ELSE.
    lo_c5->add_icon( sap_icon = 'ICON_DRAW_ELLIPSE' ).
    lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_c6 ).
    lo_c6->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).
  ENDIF.

  " [### ## ##]
  lo_table->add_column( EXPORTING width = '15%' IMPORTING column = lo_c7 ).
  lo_c7->add_gap( width = 15 ).
  IF gv_plant_tran = 'X'.
    lo_c7->add_icon( sap_icon = 'ICON_OO_OBJECT' ).
    lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_c8 ). " ## ## ##
    lo_c8->add_icon( sap_icon = 'ICON_PDIR_FOREWARD' ).
  ELSE.
    lo_c7->add_icon( sap_icon = 'ICON_DRAW_ELLIPSE' ).
    lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_c8 ).
    lo_c8->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).
  ENDIF.

  " [### #### ##]
  lo_table->add_column( EXPORTING width = '15%' IMPORTING column = lo_c9 ).
  lo_c9->add_gap( width = 15 ).
  IF gv_plant_volm = 'X'.
    lo_c9->add_icon( sap_icon = 'ICON_OO_OBJECT' ).
    lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_c10 ). " ## ## ##
    lo_c10->add_icon( sap_icon = 'ICON_PDIR_FOREWARD' ).
  ELSE.
    lo_c9->add_icon( sap_icon = 'ICON_DRAW_ELLIPSE' ).
    lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_c10 ).
    lo_c10->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).
  ENDIF.

  " [### ## ##]
  lo_table->add_column( EXPORTING width = '15%' IMPORTING column = lo_c11 ).
  lo_c11->add_gap( width = 15 ).
  IF gv_plant_gr = 'X'.
    lo_c11->add_icon( sap_icon = 'ICON_OO_OBJECT' ).
  ELSE.
    lo_c11->add_icon( sap_icon = 'ICON_DRAW_ELLIPSE' ).
  ENDIF.

  lo_table->new_row( ). " ###
  lo_c1->add_gap( width = 10 ).
  lo_c1->add_link( name = 'LOAD_TRAN' text =  '[1# ##]'  ).
  lo_c2->add_text( text = ' ' ).
  lo_c3->add_gap( width = 2 ).
  lo_c3->add_link( name = 'LOAD_VOLM' text =  '[#### ####]'  ).
  lo_c4->add_text( text = ' ' ).
  lo_c5->add_gap( width = 10 ).
  lo_c5->add_link( name = 'LOAD_TRAN' text =  '[####]'  ).
  lo_c6->add_text( text = ' ' ).
  lo_c7->add_gap( width = 10 ).
  lo_c7->add_link( name = 'PLANT_TRAN' text =  '[2# ##]'  ).
  lo_c8->add_text( text = ' ' ).
  lo_c9->add_gap( width = 2 ).
  lo_c9->add_link( name = 'PLANT_VOLM' text =  '[#### ####]'  ).
  lo_c10->add_text( text = ' ' ).
  lo_c11->add_gap( width = 10 ).
  lo_c11->add_link( name = 'PLANT_TRAN' text =  '[####]'  ).

*   ### ##(##)
*  lo_table->set_row_style( row_no  = 1   sap_style = 'SUCCESS' ). " sap_fontsize = 'LARGE'
*  lo_table->set_row_style( row_no  = 2   sap_style = 'HEADING' ).

  go_doc->merge_document( ).
  go_doc->display_document( parent = go_cont_doc ).
ENDFORM.

*FORM get_full_process_po USING pv_ebeln.
*  " [1##: Order] - ### ##
*  SELECT SINGLE ebeln bpid ekorg ekgrp bukrs bsart bedat zterm inco1 zebeln zebelnsv knumh
*    FROM ztb1mm0006 INTO CORRESPONDING FIELDS OF gs_po_h WHERE ebeln = pv_ebeln.
*
*    SELECT ebeln ebelp matnr werks lgort menge meins netpr dmbtr waersk
*      wrbtr waers mwskz eindt slfdt insmk packno knttp sakto epstp postat
*      FROM ztb1mm0007 INTO CORRESPONDING FIELDS OF TABLE gt_po_i WHERE ebeln = pv_ebeln.
*      gv_has_order = 'X'.
*
*      " [0## - ## ### ##] ##### #### ####
*      IF gs_po_h-knumh IS NOT INITIAL.
*        SELECT knumh bpid matnr datab datbi herkl plifz meins waers netpr zfrt mwskz zoth zgrm zsel
*          FROM ztb1mm0005
*          INTO CORRESPONDING FIELDS OF TABLE gt_po_opt
*          WHERE knumh = gs_po_h-knumh.
*          IF sy-subrc = 0.
*            gv_has_plan = 'X'. " ### ### #### ### ON
*            READ TABLE gt_po_opt INTO gs_po_opt INDEX 1. " # ## ### #### ##
*          ENDIF.
*        ENDIF.
*
*        " [2##: Volume] - ##### ## ### ##
*        SELECT zmsno zdocty zdocno zdocit zavol ztemp zunit zdens zvcf zsvol meins zmdat
*          FROM ztb1mm0020 INTO CORRESPONDING FIELDS OF TABLE gt_vol_i WHERE zdocno = pv_ebeln.
*
*          IF gt_vol_i[] IS NOT INITIAL. " ## ### ### -> ### ##
*            gv_has_volume = 'X'.
*            READ TABLE gt_vol_i INTO gs_vol_i INDEX 1. " # ## ## #### ##
*          ENDIF.
*
*          " [3##: Post] - ######## ##### ###
*          SELECT mblnr mjahr bldat budat bukrs bktxt vbeln plpr ebeln vgart
*            FROM ztb1mm0011 INTO CORRESPONDING FIELDS OF TABLE gt_mat_h WHERE ebeln = pv_ebeln.
*            IF gt_mat_h IS NOT INITIAL.
*              gv_has_post = 'X'. " ###### ## ### -> ### ##
*
*              IF gt_mat_h[] IS NOT INITIAL.
*                READ TABLE gt_mat_h INTO gs_mat_h INDEX 1. " # ## ## #### ##
*              ENDIF.
*              " ### ITEM# #####
*              SELECT mblnr mjahr zeile matnr werks lgort bwart menge meins netpr dmbtr waersk wrbtr waers
*                insmk zloss co_area co_center vbeln posnr plpr ebeln ebelp
*                FROM ztb1mm0012 INTO CORRESPONDING FIELDS OF TABLE gt_mat_i FOR ALL ENTRIES IN gt_mat_h WHERE ebeln = gt_mat_h-ebeln.
*              ELSE.
*                FREE gt_mat_i. " ### ### #### ###
*              ENDIF.
*ENDFORM.
