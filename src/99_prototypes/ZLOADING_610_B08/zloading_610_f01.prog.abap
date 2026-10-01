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
*& 100# ### #### ## ### ## ##
*&---------------------------------------------------------------------*
FORM get_data.
  DATA: ls_color TYPE lvc_s_scol.

*  SELECT ebeln bpid ekorg ekgrp bukrs bsart bedat zterm inco1 zebeln zebelnsv knumh
*    FROM ztb1mm0006 INTO CORRESPONDING FIELDS OF TABLE gt_pohd
*    WHERE bsart = 'NB' " ##### ##(SV #### ##)
*    AND lvorm <> 'X'. " ## # # ### ## ##
*  SORT gt_pohd BY ebeln DESCENDING.

  SELECT ebeln, bpid, ekorg, ekgrp, bukrs, bsart, bedat,
           zterm, inco1, zebeln, zebelnsv, knumh
      FROM ztb1mm0006
      INTO TABLE @DATA(lt_pohd_base)
     WHERE bsart = 'NB'
       AND lvorm <> 'X'.
  IF sy-subrc <> 0.
    CLEAR gt_pohd. " #### ## ## gt_pohd ####
    RETURN.
  ENDIF.

  " A. 1#/2# #### ## ###
  SELECT ebeln, ebelp, postat FROM ztb1mm0007 INTO TABLE @DATA(lt_all_tran)
       FOR ALL ENTRIES IN @lt_pohd_base WHERE ebeln = @lt_pohd_base-zebelnsv AND lvorm <> 'X'.
  " B. #### ### ## ##
  SELECT zdocno, zdocty FROM ztb1mm0020 INTO TABLE @DATA(lt_all_volm)
     FOR ALL ENTRIES IN @lt_pohd_base WHERE zdocno = @lt_pohd_base-ebeln AND lvorm <> 'X'.
  " C. ######(## ##)
  SELECT ebeln, bwart, insmk FROM ztb1mm0012 INTO TABLE @DATA(lt_all_mat)
     FOR ALL ENTRIES IN @lt_pohd_base WHERE ebeln = @lt_pohd_base-ebeln AND lvorm <> 'X'.

  CLEAR gt_pohd.
  SORT lt_pohd_base BY ebeln DESCENDING.

  LOOP AT lt_pohd_base INTO DATA(ls_base).
    " ## ALV ###
    APPEND INITIAL LINE TO gt_pohd ASSIGNING FIELD-SYMBOL(<fs_pohd>).
    MOVE-CORRESPONDING ls_base TO <fs_pohd>.
    CLEAR: <fs_pohd>-lt_scol, ls_color, gs_po_status.
    ls_color-fname = 'ICON'.

    gs_po_status-ebeln = ls_base-ebeln.

    " [1## ####] ##
    IF ls_base-zebelnsv IS NOT INITIAL.
      LOOP AT lt_all_tran INTO DATA(ls_t) WHERE ebeln = ls_base-zebelnsv.
        IF ls_t-ebelp = '0010' AND ls_t-postat = '4'.
          gs_po_status-gv_load_tran  = 'X'.
        ELSEIF ls_t-ebelp = '0020' AND ls_t-postat = '4'.
          gs_po_status-gv_plant_tran = 'X'.
        ENDIF.
      ENDLOOP.
    ENDIF.

    " [2## ####] ##
    READ TABLE lt_all_volm TRANSPORTING NO FIELDS WITH KEY zdocno = ls_base-ebeln zdocty = 'PO-1'.
    IF sy-subrc = 0. gs_po_status-gv_load_volm = 'X'. ENDIF.
    READ TABLE lt_all_volm TRANSPORTING NO FIELDS WITH KEY zdocno = ls_base-ebeln zdocty = 'PO-2'.
    IF sy-subrc = 0. gs_po_status-gv_plant_volm = 'X'. ENDIF.

    " [3## ####] ##
    LOOP AT lt_all_mat INTO DATA(ls_m) WHERE ebeln = ls_base-ebeln.
      IF ls_m-bwart = '101' AND ls_m-insmk = 'T'.
        gs_po_status-gv_load_gr  = 'X'.
      ELSEIF ls_m-bwart = '321' OR ls_m-bwart = '551'.
        gs_po_status-gv_plant_gr = 'X'.
      ENDIF.
    ENDLOOP.

    IF gs_po_status-gv_load_tran = 'X' AND gs_po_status-gv_load_volm = 'X' AND gs_po_status-gv_load_gr IS INITIAL.
      gs_po_status-gv_load_can = 'X'. " #### ## ## ##
    ENDIF.
    IF gs_po_status-gv_plant_tran = 'X' AND gs_po_status-gv_plant_volm = 'X' AND gs_po_status-gv_plant_gr IS INITIAL.
      gs_po_status-gv_plant_can = 'X'. " #### ## ## ##
    ENDIF.

    " ### ## ### #### ### ## ## ##
    IF gs_po_status-gv_plant_gr = 'X'.
      <fs_pohd>-icon     = icon_led_green.  ls_color-color-col = '1'. "'5'. " ##: ## ##
    ELSEIF gs_po_status-gv_load_gr = 'X'.
      IF gs_po_status-gv_plant_can = 'X'.
        <fs_pohd>-icon     = icon_led_red. ls_color-color-col = '3'. " ## ## ## ##, ##. ### #### RED
      ELSE.
        <fs_pohd>-icon     = icon_led_yellow. ls_color-color-col = '1'. "'3'. " ##: #### ##. ## ## ## ## (### ##)
      ENDIF.

    ELSEIF gs_po_status-gv_load_can = 'X'.
      <fs_pohd>-icon     = icon_led_red.   ls_color-color-col = '7'. "  '6'. " ##: #### ## ###### ## ## (##)
    ELSE.
      <fs_pohd>-icon     = icon_led_inactive. ls_color-color-col = '1'. "  " ###: #### ## ## (### ##)
    ENDIF.

    ls_color-color-int = '1'.
    APPEND ls_color TO <fs_pohd>-lt_scol.

    " ### ## ### ## #### ##(# ### ##)
    APPEND gs_po_status TO gt_po_status.
  ENDLOOP.

  SORT gt_pohd BY lt_scol DESCENDING icon ebeln.
ENDFORM.
*&---------------------------------------------------------------------*
*& 100# ### #### ### ###(#### ## ###, ###### ## ##)
*&---------------------------------------------------------------------*
FORM clear_process_data.
  CLEAR: gs_pohd, gt_poit, gt_head, gt_load_volm, gt_plant_volm,
          gv_load_tran, gv_plant_tran, gv_load_volm, gv_plant_volm, gv_load_gr, gv_plant_gr,
          gv_load_can, gv_plant_can, gv_inv_can, gv_inv_done.
ENDFORM.
*&---------------------------------------------------------------------*
*& Process Flow ### ## (## ### F99# X_get_process_data ##)
*&---------------------------------------------------------------------*
FORM get_process_data USING pv_ebeln.
  DATA: lv_ebeln TYPE zeb1_mm_ebeln.

  lv_ebeln = pv_ebeln. " #### ## #####
  PERFORM clear_process_data. " ###

  " [####] ### ###### ##
  READ TABLE gt_pohd INTO gy_pohd WITH KEY ebeln = lv_ebeln. " ### ### ### ##### #
  IF sy-subrc = 0.
    MOVE-CORRESPONDING gy_pohd TO gs_pohd.
  ENDIF.

  " #### #### #### ##
  READ TABLE gt_po_status INTO gs_po_status WITH KEY ebeln = lv_ebeln.
  IF sy-subrc = 0.
    gv_load_tran  = gs_po_status-gv_load_tran. " get_data ## ### ## ### # ### #####
    gv_plant_tran = gs_po_status-gv_plant_tran.
    gv_load_volm  = gs_po_status-gv_load_volm.
    gv_plant_volm = gs_po_status-gv_plant_volm.
    gv_load_gr    = gs_po_status-gv_load_gr.
    gv_plant_gr   = gs_po_status-gv_plant_gr.
    gv_load_can   = gs_po_status-gv_load_can.
    gv_plant_can  = gs_po_status-gv_plant_can.
  ENDIF.

  " 3. [# itab ### ##]
  SELECT ebeln ebelp matnr werks lgort menge meins netpr dmbtr waersk
    wrbtr waers mwskz eindt slfdt insmk packno knttp sakto epstp postat
    FROM ztb1mm0007 INTO CORRESPONDING FIELDS OF TABLE gt_poit WHERE ebeln = lv_ebeln AND lvorm <> 'X'.

  SELECT zmsno zdocty zdocno zdocit zavol ztemp zunit zdens zvcf zsvol meins zmdat
    FROM ztb1mm0020 INTO CORRESPONDING FIELDS OF TABLE gt_load_volm WHERE zdocno = lv_ebeln AND zdocty = 'PO-1' AND lvorm <> 'X'.

  SELECT zmsno zdocty zdocno zdocit zavol ztemp zunit zdens zvcf zsvol meins zmdat
    FROM ztb1mm0020 INTO CORRESPONDING FIELDS OF TABLE gt_plant_volm WHERE zdocno = lv_ebeln AND zdocty = 'PO-2' AND lvorm <> 'X'.

  SELECT mblnr, mjahr, bldat, budat, bukrs, bktxt, vbeln, plpr, ebeln, vgart
    FROM ztb1mm0011 INTO CORRESPONDING FIELDS OF TABLE @gt_head WHERE ebeln = @lv_ebeln AND lvorm <> 'X'.

  SELECT mblnr, mjahr, zeile, matnr, werks, lgort, bwart, menge, meins, netpr, dmbtr, waersk, wrbtr, waers,
      insmk, zloss, kokrs, kostl, vbeln, posnr, plpr, ebeln, ebelp
    FROM ztb1mm0012 INTO CORRESPONDING FIELDS OF TABLE @gt_item WHERE ebeln = @lv_ebeln AND lvorm <> 'X'.

  CLEAR:gt_item.
  " #### ## ##: ## ## ## (#### ### ## ##)
*                  + #### #### #### ##(####### ### ### # ##)
*                  + #, ## ## = 'X' (## A ## ## ## B# #### #)
  IF gv_load_gr = 'X'.
    SELECT SINGLE rbstat
      FROM ztb1mm0013 " ##### #### ## ##
      INTO @DATA(lv_rbstat)
      WHERE ebeln = @lv_ebeln. " ##### ebeln# ###
    " ## #### ### #, ####### ## ## => ### RBSTAT# ###

    IF sy-subrc = 0. " #### ## ##
      CASE lv_rbstat.
        WHEN 'X'. " ####### ### ### # ##-> ## ## ##
          gv_inv_can = 'X'.
        WHEN 'A' OR 'B'. " ## ## ## ## -> ## ## ##
          gv_inv_done = 'X'.
      ENDCASE.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_object (100# ### #### item ALV ##)
*&---------------------------------------------------------------------*
FORM create_object USING pv_area   TYPE any        " ###### Custom Control ##
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

**   #### ## ## ### ## #, ### # ## ## ## #### #### #### # #### ##
*  po_alv->register_edit_event( i_event_id = cl_gui_alv_grid=>mc_evt_enter ).
*  po_alv->register_edit_event( i_event_id = cl_gui_alv_grid=>mc_evt_modified ).

*   ALV# ## ### ## ## ## ### ## #### #
  " po_alv->set_ready_for_input( i_ready_for_input = 1 ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_split_object (100# ### ## ## ####, ####, #### ALV ##)
*&---------------------------------------------------------------------*
FORM create_split_object USING    pv_type TYPE i
                                  pv_area TYPE c
                         CHANGING po_container TYPE REF TO cl_gui_custom_container
                                  po_splitter TYPE REF TO cl_gui_splitter_container
                                  po_cont_1 TYPE REF TO cl_gui_container
                                  po_cont_2 TYPE REF TO cl_gui_container
                                  po_alv_1 TYPE REF TO cl_gui_alv_grid.
  CREATE OBJECT po_container " ## ### ##### ##
    EXPORTING
      container_name = pv_area.

  CREATE OBJECT po_splitter " ##### # 3# ####
    EXPORTING
      parent  = po_container
      rows    = 1
      columns = 2. " ### ## #: 3# -> #### ## 2## ## # ##

*  go_splitter->set_column_width( id = 1 width = 20 ).
*  go_splitter->set_column_width( id = 2 width = 40 ).
*  go_splitter->set_column_width( id = 3 width = 10 ).

  " # ## #### ####
  po_cont_1 = po_splitter->get_container( row = 1 column = 1 ).
  po_cont_2 = po_splitter->get_container( row = 1 column = 2 ).
*  go_cont_lgt = go_splitter->get_container( row = 1 column = 3 ).

  CREATE OBJECT po_alv_1 EXPORTING i_parent = po_cont_1.
  IF pv_type = 3.
    CREATE OBJECT go_alv_mat EXPORTING i_parent = go_cont_mat.
  ENDIF.
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
*  po_alv->get_current_cell( IMPORTING es_row_no = gs_row_st ).
*
*  ps_stable-row = abap_true.
*  ps_stable-col = abap_true.

  CALL METHOD po_alv->refresh_table_display
    EXPORTING
      is_stable      = ps_stable
      i_soft_refresh = 'X'  "x: ##, ##, ## ### ## -> ### #### #####
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
  ELSEIF pv_type = 2.
    ps_layout-grid_title = '#### ##'.
    ps_layout-sel_mode   = 'B'. " ##/## # ## ##
    ps_layout-cwidth_opt = 'X'. " # ## ## ###
    ps_layout-zebra      = 'X'. " ### ##
    ps_layout-info_fname = 'COL_FLD'. " # ## ## ## ##
    ps_layout-ctab_fname = 'LT_SCOL'.
  ELSEIF pv_type = 3.
    " tran, volm ## #### alv layout ##
*    ps_layout-excp_fname = 'EXCP_FLD'. " ## ### ### ###
*    ps_layout-excp_led = 'X'.
    ps_layout-grid_title = '## ## ##'.
    ps_layout-cwidth_opt = 'X'. " # ## ## ###
    ps_layout-zebra      = 'X'. " ### ##
  ENDIF.
  " ## ##
*  ps_layout-no_toolbar = 'X'. " ## ## ##(## ui_func ## ## ##)
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_uifunc (100# ### ALV ## ## ## ##)
*&---------------------------------------------------------------------*
FORM set_uifunc USING pv_type TYPE i
                      pt_uifunc  TYPE ui_functions.
  REFRESH pt_uifunc.
  IF pv_type = 1.
    " item## #### ui function ##
*    APPEND cl_gui_alv_grid=>mc_fc_detail       TO pt_uifunc. " ### ###
*    APPEND cl_gui_alv_grid=>mc_fc_loc_copy     TO pt_uifunc.

    " # ### # ##, ## ## ### ####
*    APPEND cl_gui_alv_grid=>mc_fc_excl_all TO pt_uifunc. " ## # ###
  ELSE.
*    APPEND cl_gui_alv_grid=>mc_fc_info         TO pt_uifunc.
  ENDIF.
  " ## ##
  APPEND cl_gui_alv_grid=>mc_fc_excl_all TO pt_uifunc. " ## # ###
ENDFORM.
*&---------------------------------------------------------------------*
*& i_structure ### fcat #### ##, ##### ###
*&---------------------------------------------------------------------*
FORM set_fcat_struct USING pv_struct CHANGING pt_fcat TYPE lvc_t_fcat.
  REFRESH pt_fcat.
  DATA: ls_fcat TYPE lvc_s_fcat.

  " ### ### ### ######
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = pv_struct
    CHANGING
      ct_fieldcat      = pt_fcat.

  " ####, ##### ## ### ###
  DELETE pt_fcat WHERE fieldname = 'ZEBELN' OR fieldname = 'LVORM' OR
                       fieldname = 'ERNAM' OR fieldname = 'ERDAT' OR
                       fieldname = 'ERZET' OR fieldname = 'AENAM' OR
                       fieldname = 'AEDAT' OR fieldname = 'AEZET'.

  IF pv_struct = 'ZTB1MM0006'.
    " ## ### #### ## # ## ##
    LOOP AT pt_fcat ASSIGNING FIELD-SYMBOL(<fs_fcat>).
      CASE <fs_fcat>-fieldname.
        WHEN 'EBELN'.
          <fs_fcat>-key = 'X'.
          <fs_fcat>-emphasize = 'C110'.
      ENDCASE.
      <fs_fcat>-tooltip = '##### ### Process Flow ## ##'.
    ENDLOOP.

    CLEAR: ls_fcat.
    ls_fcat-fieldname = 'ICON'.
    ls_fcat-coltext = '##'.
    ls_fcat-outputlen = '6'.
    ls_fcat-icon = 'X'.
    ls_fcat-just = 'C'.
    APPEND ls_fcat TO pt_fcat.
  ENDIF.

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
  REFRESH ct_fcat_item.
  PERFORM set_fcat TABLES ct_fcat_item USING:
        'S' 'FIELDNAME' 'ZEILE', " ###### ## ##
        ' ' 'COLTEXT'   '##',   " ### ###
        ' ' 'LZERO'     'X',     " 0# ### 0010## ##(char4)
        ' ' 'OUTPUTLEN' '4',     " layout## ## ### ## #### ## ##
        'E' ''          '',      " APPEND ### #### ## (## ##)
        " ### 'S'# ##, #### ## ## 'E'# ####### #
                                                              " ## ### # ### ####, F4VAILABL# #### F4 Help# ### # ##
        'S' 'FIELDNAME' 'MATNR', ' ' 'COLTEXT' '####',         ' ' 'OUTPUTLEN' '10', ' ' 'REF_TABLE' 'ZTB1MM0012', ' ' 'REF_FIELD' 'MATNR',  ' ' 'JUST' 'C', ' ' 'F4AVAILABL' 'X', 'E' ' ' ' ', " EDIT = 'X' ## ## ##
        'S' 'FIELDNAME' 'WERKS',  ' ' 'COLTEXT' '###',        ' ' 'REF_TABLE' 'ZTB1MM0012', ' ' 'REF_FIELD' 'WERKS', ' ' 'OUTPUTLEN' '5',  ' ' 'JUST' 'C',' ' 'F4AVAILABL' 'X', 'E' ' ' ' ',
        'S' 'FIELDNAME' 'LGORT',  ' ' 'COLTEXT' '####',       ' ' 'REF_TABLE' 'ZTB1MM0012', ' ' 'REF_FIELD' 'LGORT', ' ' 'OUTPUTLEN' '6', ' ' 'JUST' 'C',' ' 'F4AVAILABL' 'X', 'E' ' ' ' ',
        'S' 'FIELDNAME' 'MENGE',  ' ' 'JUST' 'R',             ' ' 'NO_ZERO' 'X',   'E' ' ' ' ', " ' ' 'DECIMALS_OUT' '0', ' ' 'DECIMALS' '0',
        'S' 'FIELDNAME' 'MEINS',  ' ' 'COLTEXT' '####',              'E' ' ' ' ', " NO_ZERO = 'X' ## 0# # ## ## # #
        'S' 'FIELDNAME' 'NETPR',  ' ' 'COLTEXT' '##',                ' ' 'JUST' 'R',             ' ' 'NO_ZERO' 'X', ' ' 'DECIMALS_O' '0', 'E' ' ' ' ',
        'S' 'FIELDNAME' 'DMBTR',  ' ' 'COLTEXT' '# ##(##)',    ' ' 'JUST' 'R',                   ' ' 'OUTPUTLEN' '15', ' ' 'NO_ZERO' 'X', 'E' ' ' ' ',
        'S' 'FIELDNAME' 'WAERSK', ' ' 'COLTEXT' '##',          ' ' 'REF_TABLE' 'ZTB1MM0012', ' ' 'REF_FIELD' 'WAERSK', ' ' 'OUTPUTLEN' '5', 'E' ' ' ' ',
        'S' 'FIELDNAME' 'WRBTR',  ' ' 'COLTEXT' '# ##(####)',   ' ' 'NO_ZERO' 'X', ' ' 'REF_TABLE' 'ZTB1MM0012', ' ' 'REF_FIELD' 'WRBTR', ' ' 'OUTPUTLEN' '15', 'E' '' '',   " NO_OUT = 'X' ## ## ##
        'S' 'FIELDNAME' 'WAERS',  ' ' 'COLTEXT' '####',            'E' '' '',   " ##### #### ##
        'S' 'FIELDNAME' 'INSMK',  ' ' 'COLTEXT' '####',    ' ' 'JUST' 'C', ' ' 'OUTPUTLEN' '6', 'E' ' ' ' ',
        'S' 'FIELDNAME' 'ZLOSS',  ' ' 'COLTEXT' '###',     ' ' 'JUST' 'C',  ' ' 'NO_ZERO' 'X', 'E' ' ' ' ',
        'S' 'FIELDNAME' 'KOKRS',  ' ' 'COLTEXT' '######',    'E' ' ' ' ',
        'S' 'FIELDNAME' 'KOSTL',  ' ' 'COLTEXT' '#####',    'E' ' ' ' ',
        'S' 'FIELDNAME' 'EBELN',  ' ' 'COLTEXT' '#### ##', ' ' 'JUST' 'C','E' '' '',
        'S' 'FIELDNAME' 'EBELP',  ' ' 'COLTEXT' '##',      ' ' 'JUST' 'C',' ' 'NO_ZERO' 'X', ' ' 'OUTPUTLEN' '5', 'E' '' ''.

  LOOP AT ct_fcat_item ASSIGNING FIELD-SYMBOL(<fs_fcat>).
    CASE <fs_fcat>-fieldname.
      WHEN 'ZLOSS'.
        IF gv_mode = 'P'. " ### ### ## ##
          <fs_fcat>-no_out = ''.
        ELSE.
          <fs_fcat>-no_out = 'X'.
        ENDIF.
      WHEN 'KOKRS' OR 'KOSTL'. " ####
        IF gv_mode = 'S'. " ## ## ## ##
          <fs_fcat>-no_out = ''.
        ELSE.
          <fs_fcat>-no_out = 'X'.
        ENDIF.
      WHEN 'INSMK'.
        IF gv_mode = 'S'. " ## ## ## ##"## ##"
          <fs_fcat>-no_out = 'X'.
        ELSE.
          <fs_fcat>-no_out = ''.
        ENDIF.
      WHEN 'NETPR' OR 'DMBTR'.
        IF gv_mode = 'L'.
          <fs_fcat>-cfieldname = ''.
          <fs_fcat>-decimals_o = '0'.
        ELSE.
          <fs_fcat>-cfieldname = 'WAERSK'.
          <fs_fcat>-decimals_o = ''.
        ENDIF.
      WHEN 'MENGE'.
        IF gv_mode = 'S'.
          <fs_fcat>-coltext = '##'.
        ELSE.
          <fs_fcat>-coltext = '####'.
        ENDIF.
    ENDCASE.
  ENDLOOP.

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
*& FORM control_header_screen (100# ### ALV #### ## ## ## ##)
*&---------------------------------------------------------------------*
FORM control_header_screen.
  " 1. #### #### ### ## ## ###
  DATA(lv_editable) = abap_true.
  LOOP AT gt_item TRANSPORTING NO FIELDS WHERE matnr IS NOT INITIAL.
    lv_editable = abap_false. " #### #### ### (### ###) ## ## ##
    EXIT.
  ENDLOOP.

  " 2. ### ### ## ####### ### ## ##(##/###)# ##
  LOOP AT SCREEN.
    IF screen-name = 'GV_EBELN' OR   " PO ##
       screen-name = 'GS_HEAD-BKTXT' OR " ## ## ###
*       screen-name = 'GS_HEAD-BLDAT' OR
       screen-name = 'GS_HEAD-BLDAT'. " ### ##(## ## ### ## ##, ### ## ##### ##
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
*& FORM check_data_before_save (100# ### ## ### ### ##)
*&---------------------------------------------------------------------*
FORM check_data_before_save CHANGING cv_subrc TYPE sysubrc.
  DATA: lv_error_cnt   TYPE i VALUE 0, " ## #### ### ALV ## #### #### ##
        lo_protocol    TYPE REF TO cl_alv_changed_data_protocol,
        lv_item_exists TYPE abap_bool. " #### #### ### ###

  TYPES: BEGIN OF ty_sum,
           matnr TYPE ty_item-matnr,
           menge TYPE ty_item-menge,
         END OF ty_sum.
  DATA: lt_sum         TYPE TABLE OF ty_sum,
        ls_sum         LIKE LINE OF lt_sum,
        lt_valid_items LIKE gt_item.

  CREATE OBJECT lo_protocol. " ## #### ## ## (### ###)
  cv_subrc = 0.

  " #1. ## ##
  " ## 1) ##### ### ## ## ##
  IF gs_head-bldat IS INITIAL.
    PERFORM check_and_add_protocol USING gs_head-bldat 'E' '014' '####' 'GS_HEAD-BLDAT' 0 lo_protocol CHANGING lv_error_cnt.
  ELSEIF gs_head-bldat < sy-datum.  " ## #### ### # ####
    PERFORM check_and_add_protocol USING gs_head-bldat 'E' '012' '## ##' 'GS_HEAD-BLDAT' 0 lo_protocol CHANGING lv_error_cnt.
  ELSEIF gs_head-bldat > sy-datum. " ## #### ### # ####
    PERFORM check_and_add_protocol USING gs_head-bldat 'E' '036' '## ##' 'GS_HEAD-BLDAT' 0 lo_protocol CHANGING lv_error_cnt.
  ENDIF.

  " ## 2) ######, ####### ## #### ##
  PERFORM check_and_add_protocol USING gs_pohd-ebeln 'E' '014' '#### ##' 'GS_POHD-EBELN' 0 lo_protocol CHANGING lv_error_cnt.
  PERFORM check_and_add_protocol USING gs_head-bktxt 'E' '014' '## ## ###' 'GS_HEAD-BKTXT' 0 lo_protocol CHANGING lv_error_cnt.

  " #2. ### ## #
  " ##### ## ## ### -> ###/####/## ##
  lt_valid_items = VALUE #( FOR wa IN gt_item WHERE ( matnr <> '' ) ( wa ) ).
  IF lt_valid_items IS NOT INITIAL.

    " ## 1) ### ### - ### & ##### ## #### ####
    SELECT werks, lgort
        FROM ztb1mm0000
         FOR ALL ENTRIES IN @lt_valid_items
       WHERE werks = @lt_valid_items-werks
         AND lgort = @lt_valid_items-lgort
         AND lvorm = @space
        INTO TABLE @DATA(lt_master_check).
    SORT lt_master_check BY werks lgort.

    " ## 2) #### ## #### ## #### ####
    SELECT ebeln, matnr, menge
      FROM zcds_b1_mm_0002( p_bldat = @gs_head-bldat )
     WHERE ebeln = @gv_ebeln
      INTO TABLE @DATA(lt_po_data).
    SORT lt_po_data BY matnr.
  ENDIF.

  " ## 3) ### ## ## ### ## ####! (grouping ##)
  LOOP AT gt_item INTO DATA(ls_check) WHERE matnr IS NOT INITIAL.
    lv_item_exists = abap_true.

    " lt_sum# # ### ## ##### ##(### ## ### ### ### #### #### #)
    READ TABLE lt_sum ASSIGNING FIELD-SYMBOL(<fs_sum>) WITH KEY matnr = ls_check-matnr.
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

  " #3. ### ### ##
  LOOP AT gt_item INTO DATA(ls_item) WHERE matnr IS NOT INITIAL.
    DATA(lv_tabix) = sy-tabix.

    " ## ### #### #### #### ### ##### ## ## ##
    " PERFORM x_before_item_logic.

    " ## 1) ### # ## ### #### ### ##### (## ## ##)
    READ TABLE lt_sum INTO ls_sum WITH KEY matnr = ls_item-matnr.
    IF sy-subrc = 0.
      READ TABLE lt_po_data INTO DATA(ls_po) WITH KEY matnr = ls_item-matnr BINARY SEARCH.
      IF sy-subrc = 0 AND ls_sum-menge > ls_po-menge. " ## ### #### ### #####
        PERFORM check_and_add_protocol USING ls_sum-menge 'E' '123' '####' 'MENGE' lv_tabix lo_protocol CHANGING lv_error_cnt.
      ENDIF.
    ENDIF.

    " ## 2) ##### ### ##
    IF ls_item-lgort IS INITIAL." ## ##### #### #(#) #### ####. #### ### #####
      PERFORM check_and_add_protocol USING ls_item-lgort 'E' '102' '####' 'LGORT' lv_tabix lo_protocol CHANGING lv_error_cnt.
    ENDIF.

    " ## 3) ###/#### ### ### ##
    IF ls_item-werks IS NOT INITIAL AND ls_item-lgort IS NOT INITIAL.
      READ TABLE lt_master_check WITH KEY werks = ls_item-werks
                                      lgort = ls_item-lgort BINARY SEARCH TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        gv_show_msg  = abap_true.
        gv_msg_matnr = |{ ls_item-werks }/{ ls_item-lgort }|. "  #### ### '###/####' ### ### ####
        PERFORM check_and_add_protocol USING gv_msg_matnr 'E' '010' '###/####' 'WERKS' lv_tabix lo_protocol CHANGING lv_error_cnt.
      ENDIF.
    ENDIF.
  ENDLOOP.

  " ## ### ## ## # ##### ## ## ### #
  " #, ### ## #### ## ## ## ### ### ##
  IF lv_item_exists = abap_false.
    PERFORM check_and_add_protocol USING '' 'E' '000' '### ##' 'MANDT' 0 lo_protocol CHANGING lv_error_cnt.
  ENDIF.

  " #4. ### #### ### ## ###
  IF lv_error_cnt > 0.
    lo_protocol->display_protocol(
*      i_container        =                  " Container (Optional)
*      i_display_toolbar  =                  " Display Toolbar
      i_optimize_columns = abap_true " ### ### ## ##
    ).
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
*      i_msgid     =                  " Message ID
*      i_msgty     =                  " Message Type
*      i_msgno     =                  " Message No.
**      i_msgv1     =                  " Message Variable1
**      i_msgv2     =                  " Message Variable2
**      i_msgv3     =                  " Message Variable3
**      i_msgv4     =                  " Message Variable4
*      i_fieldname =                  " Field Name
**      i_row_id    =                  " RowID
**      i_tabix     =                  " Table Index
*    ).
*    (
        i_msgid     = 'ZMCB1'
        i_msgty     = pv_msgty
        i_msgno     = pv_msgno
        i_msgv1     = |{ pv_msgv1 }| " ## ## #### #### ##
        i_fieldname = ''
*        i_row_id    = pv_row_id      " 0## ### #### #### ### ##
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
        lv_total_qty TYPE menge_d, " # ## ##
        lv_modetxt   TYPE string.

  " ## ### ##
  LOOP AT gt_item INTO DATA(ls_item) WHERE matnr IS NOT INITIAL.
    lv_count = lv_count + 1.
    lv_total_qty = lv_total_qty + ls_item-menge.
  ENDLOOP.
  PERFORM get_domain_text USING 'ZDB1_MM_GRMODE' gv_mode CHANGING lv_modetxt.

  " ### ##
  lv_text = |#### [{ gs_pohd-ebeln }] ##\n| &&
            |# { lv_count }## ##, ## ## { lv_total_qty NUMBER = USER } BBL(KG)# \n| &&
            |{ lv_modetxt } ########?|.

  " ## ##
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = lv_title
      text_question         = lv_text
      text_button_1         = '##'(001)
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
  DATA: lv_mblnr    TYPE ztb1mm0011-mblnr,
        ls_head     TYPE ztb1mm0011,
        lt_item     TYPE TABLE OF ztb1mm0012,
        ls_item     TYPE ztb1mm0012,
        lv_zeile    TYPE i,
        lv_has_loss TYPE c.

  " 1. ## #### ## ## (SNRO ##)
  PERFORM get_new_gr_number CHANGING lv_mblnr.

  IF lv_mblnr IS INITIAL.
    MESSAGE e006(zmcb1) WITH ': #### ## ## ##'.
    RETURN.
  ENDIF.

  " 2. ## ### ## (## ####
  gs_head-mblnr = lv_mblnr.
  gs_head-mjahr = sy-datum(4).   " ####
  gs_head-bldat = sy-datum.      " ###
  gs_head-budat = sy-datum.      " ###
  gs_head-ebeln = gv_ebeln.      " ###### = #### ##
  gs_head-vgart = 'WE'.          " ####

  gs_head-ernam = sy-uname.
  gs_head-erdat = sy-datum.
  gs_head-erzet = sy-uzeit.

  " 3. ### ### ## (ZTB1MM0012)
  CLEAR lt_item. " ls_item# ###### ###, ls_screen# #### ###
  LOOP AT gt_item INTO DATA(ls_screen) WHERE matnr IS NOT INITIAL.
    lv_zeile = lv_zeile + 1.

    " DB ### ## ### ##
    CLEAR ls_item.
    MOVE-CORRESPONDING ls_screen TO ls_item. " #### ### # ## ###

    " 1. ###### & ####
    ls_item-mblnr = lv_mblnr.
    ls_item-mjahr = gs_head-mjahr.
    ls_item-zeile = lv_zeile * 10.      " #### (1, 2, 3... * 10)
    ls_item-bwart = ls_screen-bwart.         " ####

    " 2. KRW ##, ## - ## CDS## ### #### ### ## ###
    IF gv_mode = 'L'.
      CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
        EXPORTING
          currency    = ls_screen-waersk
          idoc_amount = ls_screen-netpr " ### ### ## ### ##
        IMPORTING
          sap_amount  = ls_item-netpr.

      CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
        EXPORTING
          currency    = ls_screen-waersk
          idoc_amount = ls_screen-dmbtr
        IMPORTING
          sap_amount  = ls_item-dmbtr.
    ELSE.
*      DATA: lv_idoc_temp     TYPE bapi_msg, " ### ##(##)
*            lv_converted_num TYPE zeb1_mm_dmbtr. " QUSGH
*
*      CALL FUNCTION 'CURRENCY_AMOUNT_SAP_TO_IDOC'
*        EXPORTING
*          currency    = ls_item-waersk
*          sap_amount  = ls_item-dmbtr
*        IMPORTING
*          idoc_amount = lv_idoc_temp. " ## ### ##
*      lv_converted_num = lv_idoc_temp. " ### ## # ### ## ###
*
*      lv_total = lv_total + lv_converted_num.
      " ## ## ## ## ####
      ls_item-netpr = ls_screen-netpr.
      ls_item-dmbtr = ls_screen-dmbtr.
    ENDIF.

    ls_item-waers = ls_screen-waers.
    ls_item-wrbtr = ls_screen-wrbtr.

    CASE gv_mode.
      WHEN 'L'.
        CLEAR: ls_item-zloss, ls_item-kokrs, ls_item-kostl.

      WHEN 'P'.
        ls_item-zloss = ls_screen-zloss. " ## ### # ### ### ### ##
        CLEAR: ls_item-kokrs, ls_item-kostl.

        IF ls_screen-zloss > 0.
          lv_has_loss = 'X'.
        ENDIF.

      WHEN 'S'.
        ls_item-kokrs = ls_screen-kokrs. " #### ### # ##### ## ### ##
        ls_item-kostl = ls_screen-kostl.
        CLEAR ls_item-zloss.
    ENDCASE.

    " #### ## ## ##
    ls_item-ebeln = ls_screen-ebeln.
    ls_item-ebelp = ls_screen-ebelp.

*    CALL FUNCTION 'ZFB1CM0001' " ##### ####
*    CHANGING
*      ct_table = ls_item.

    APPEND ls_item TO lt_item.
  ENDLOOP.

  call function 'ZFB1CM0001'" ##### ####
    CHANGING
      ct_table = lt_item.

  " 4. ## DB ## (##, ###) - #### #### ROLLBACK##
  MOVE-CORRESPONDING gs_head TO ls_head. " #### ## ### ##
  INSERT ztb1mm0011 FROM ls_head. " ## ###
  IF sy-subrc = 0.
    INSERT ztb1mm0012 FROM TABLE lt_item.  " ### ### ## ##

    IF sy-subrc = 0.
      call function 'ZFB1MM0001'
        EXPORTING
          i_mblnr             = ls_head-mblnr                " ## ## ##
*         i_mjahr             =                  " ## ## ##
*         i_zeile             =                  " ## ## ## ##
*         i_matnr             =                  " ####
*         i_lgort             =                  " ####
*         i_werks             = '1000'           " ###
*         i_insmk             = 'A'              " ## ##
*         i_dmbtr             =                  " # ####(##)
*         i_menge             =                  " ##
*         i_bwart             =                  " ## ##
*    CHANGING
*         cs_mm0011           =                  " ## ## ## ##
*         cs_mm0023           =                  " ## ## ## ## ###
*         cs_mm0024           =                  " ## ## ## ### ###
        EXCEPTIONS
          invalid_input_data  = 1                " Invalid Input Data
          error_modify_mm0001 = 2                " Invalid Moidfy Data in MM0001
          error_modify_mm0003 = 3                " Invalid Moidfy Data in MM0003
          invalid_mm0001_data = 4                " No MM0001 Data
          invalid_mm0003_data = 5                " No MM0003 Data
          invalid_mm0011_data = 6                " No MM0011 Data
          invalid_mm0012_data = 7                " No MM0012 Data
          error_insert_mm0023 = 8                " iInvalid Insert Data in MM0023
          error_insert_mm0024 = 9                " Invalid Insert Data in MM0024
          OTHERS              = 10.


      IF sy-subrc <> 0.
        ROLLBACK WORK.
        MESSAGE 'ZFB1MM0001 fail' TYPE 'E'.
      ELSE.
        COMMIT WORK. " # #### #

        " #### ##
*        data: lt_0001 type table of ztb1mm0001,
*              lt_0003 type table of ztb1mm0003.
*        SELECT * FROM ztb1mm0001 INTO TABLE lt_0001.
*        SELECT * FROM ztb1mm0003 INTO TABLE lt_0003.

        " ## # ### ##
        gv_mblnr = lv_mblnr.
        gv_mjahr = sy-datum(4).

        MESSAGE s105(zmcb1) WITH lv_mblnr '(' gv_mjahr ')'. " #### ' '(2026)# #######

        " ## ## # ## ## (## ###)
        IF gv_mode = 'P' AND lv_has_loss = 'X'.
          " ###### ### ##### -> ## ## ## ### ## ##
          PERFORM set_screen_to_loss_mode.
        ELSE.
          " ## #######, #### ### ###, ## ## ### ### ## -> ###
          PERFORM set_screen_after_save.
        ENDIF.
      ENDIF.
    ELSE.
      ROLLBACK WORK.  " ### ## #### ### ### ## ## 2
      MESSAGE e006(zmcb1) WITH ': #### ## ## ##'. "  ## # ### ######
    ENDIF.
  ELSE.
    ROLLBACK WORK. " ## ## #### ### ### ## ## 1
    MESSAGE e006(zmcb1) WITH ': #### ## ## ##'. " ## # ### ######
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_new_gr_number (## ## ## ##)
*&---------------------------------------------------------------------*
FORM get_new_gr_number CHANGING cv_mblnr.

  DATA: lv_number TYPE nriv-nrlevel.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr            = '01'            " SNRO# Interval ##
      object                 = 'ZNRB1MM03'     " ## ### NR
    IMPORTING
      number                 = lv_number       " ### ##
    EXCEPTIONS
      interval_not_found     = 1
      number_range_not_found = 2
      object_not_found       = 3
      quantity_is_0          = 4
      quantity_is_not_1      = 5
      interval_overflow      = 6
      buffer_overflow        = 7
      OTHERS                 = 8.

  IF sy-subrc = 0.
    " 10## ### ### ####
    cv_mblnr = |{ lv_number ALPHA = IN }|.
  ELSE.
    " ## ## # ## ###
    MESSAGE e015(zmcb1).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_screen_to_loss_mode (## ## ## ## & ## ##)
*&---------------------------------------------------------------------*
FORM set_screen_to_loss_mode.
  PERFORM get_process_data USING gv_ebeln.
  gv_dynnr = '0110'.

  " #### ## ### ##### ### #### ### ###
  gv_mode = 'S'.

  " ## ### ## ## (#### -> ####)
  REPLACE FIRST OCCURRENCE OF '####' IN gs_head-bktxt WITH '####'.

  " #### ## => ## ##### ### '## ###(zloss)'## ## ###
  LOOP AT gt_item ASSIGNING FIELD-SYMBOL(<fs_item>) WHERE matnr IS NOT INITIAL.
    IF <fs_item>-zloss > 0.
      <fs_item>-menge = <fs_item>-zloss. " ## #### ### '####'# #

      " ## ## ##
      <fs_item>-bwart = '551'.                      " #### ## ##
      CLEAR <fs_item>-insmk.                         " #### ## ##

      " #### ## ##
      <fs_item>-kokrs = 'A100'.                     " ###### ##
      <fs_item>-kostl = 'TRANSPORT_LOSS_COST'.      " ##### ##

      " ### ### ## #### ## #### ###
      <fs_item>-wrbtr  = <fs_item>-netpr_usd * <fs_item>-menge.
      <fs_item>-dmbtr = <fs_item>-netpr * <fs_item>-menge.

      CLEAR <fs_item>-zloss. " ## ##### ### ## ### ###
    ELSE.
      <fs_item>-menge = 0. " ## ### #### ### ## 0 ##
      <fs_item>-wrbtr = 0.
      <fs_item>-dmbtr = 0.
    ENDIF.
  ENDLOOP.

  " ### 0# # # = ## ## #### #### ##
  DELETE gt_item WHERE menge = 0 AND matnr IS NOT INITIAL.
  DATA: lv_current_lines TYPE i,
        lv_fill_lines    TYPE i.

  DESCRIBE TABLE gt_item LINES lv_current_lines. " ## ## ### ## # # ##

  IF lv_current_lines < 10.
    lv_fill_lines = 10 - lv_current_lines.      " 10### ### ## ##

    DO lv_fill_lines TIMES.
      APPEND INITIAL LINE TO gt_item.           " ### #### # # ####
    ENDDO.
  ENDIF.
  PERFORM set_item_number.

  " 100# ### ## #### ## ####
  PERFORM set_fcat_item CHANGING gt_fcat_item.

  IF go_alv IS BOUND.
    go_alv->set_frontend_fieldcatalog( it_fieldcatalog = gt_fcat_item ).
    PERFORM refresh_alv USING gs_stable CHANGING go_alv.
  ENDIF.

  " ## ### 100### ## #### PBO# ## ## ##
  SET SCREEN 100.
  LEAVE TO SCREEN 100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_screen_after_save (## ## ## ## ##)
*&---------------------------------------------------------------------*
FORM set_screen_after_save.
  " 1. ## ### + #### ### ### (## ## # ##)
  PERFORM clear_process_data.
  " 2. ### ### ### ###
  REFRESH gt_item.

  PERFORM get_process_data USING gv_ebeln.
  gv_dynnr = '0110'.

  " 3. ALV ## ###
  " #### ### # # ## #### ### ## ###### ## ###
  PERFORM set_init_item_rows.

  " 4. ALV ####
  IF go_alv IS BOUND.
    PERFORM refresh_alv USING gs_stable CHANGING go_alv.
  ENDIF.
  " 5. ## ## ## (#### #### ## ## #### ##)
  PERFORM control_header_screen.

  SET SCREEN 100.
  LEAVE TO SCREEN 100.
ENDFORM.
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

*  " ### ##
  go_doc->add_table( EXPORTING no_of_columns = 11
                               border        = '0'
                               width         = '100%'
                     IMPORTING table     = lo_table ).

  " [## ## ##]
  lo_table->add_column( EXPORTING width = '15%' IMPORTING column = lo_c1 ).
  lo_c1->add_gap( width = 15 ).
  IF gv_load_tran = 'X'.
    lo_c1->add_icon( sap_icon = 'ICON_STATUS_OK' ).
  ELSE.
    lo_c1->add_icon( sap_icon = 'ICON_NEGATIVE' ).
  ENDIF.
  lo_table->add_column(  EXPORTING width = '2%' IMPORTING column = lo_c2 ).
  lo_c2->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).


  " [## #### ##]
  lo_table->add_column(  EXPORTING width = '15%' IMPORTING column = lo_c3 ).
  lo_c3->add_gap( width = 15 ).
  IF gv_load_volm = 'X'.
    lo_c3->add_icon( sap_icon = 'ICON_STATUS_OK' ).
  ELSE.
    lo_c3->add_icon( sap_icon = 'ICON_NEGATIVE' ).
  ENDIF.
  lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_c4 ). " ## ## ##
  lo_c4->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).


  " [## ## ##]
  lo_table->add_column( EXPORTING width = '15%' IMPORTING column = lo_c5 ).
  lo_c5->add_gap( width = 15 ).
  IF gv_load_gr = 'X'.
    lo_c5->add_icon( sap_icon = 'ICON_STATUS_OK' ).
  ELSE.
    lo_c5->add_icon( sap_icon = 'ICON_NEGATIVE' ).
  ENDIF.
  lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_c6 ). " ## ## ##
  lo_c6->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).


  " [### ## ##]
  lo_table->add_column( EXPORTING width = '15%' IMPORTING column = lo_c7 ).
  lo_c7->add_gap( width = 15 ).
  IF gv_plant_tran = 'X'.
    lo_c7->add_icon( sap_icon = 'ICON_STATUS_OK' ).
  ELSE.
    lo_c7->add_icon( sap_icon = 'ICON_NEGATIVE' ).
  ENDIF.
  lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_c8 )." ## ## ##
  lo_c8->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).

  " ICON_STATUS_OK
  " ICON_STATUS_BEST
  " [### #### ##]
  lo_table->add_column( EXPORTING width = '15%' IMPORTING column = lo_c9 ).
  lo_c9->add_gap( width = 15 ).
  IF gv_plant_volm = 'X'.
    lo_c9->add_icon( sap_icon = 'ICON_STATUS_OK' ).
  ELSE.
    lo_c9->add_icon( sap_icon = 'ICON_NEGATIVE' ).
  ENDIF.
  lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_c10 ). " ## ## ##
  lo_c10->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).


  " [### ## ##]
  lo_table->add_column( EXPORTING width = '15%' IMPORTING column = lo_c11 ).
  lo_c11->add_gap( width = 15 ).
  IF gv_plant_gr = 'X'.
    lo_c11->add_icon( sap_icon = 'ICON_STATUS_OK' ).
  ELSE.
    lo_c11->add_icon( sap_icon = 'ICON_NEGATIVE' ).
  ENDIF.

  lo_table->new_row( ). " ###
  lo_c1->add_gap( width = 10 ).
  lo_c1->add_link( name = 'LOADTRAN' text =  '[1# ##]'  ).
  lo_c2->add_text( text = ' ' ).
  lo_c3->add_gap( width = 2 ).
  lo_c3->add_link( name = 'LOADVOLM' text =  '[#### ####]'  ).
  lo_c4->add_text( text = ' ' ).
  lo_c5->add_gap( width = 10 ).
  lo_c5->add_text( text =  '[####]'  ).
  lo_c6->add_text( text = ' ' ).
  lo_c7->add_gap( width = 10 ).
  lo_c7->add_link( name = 'PLANTTRAN' text =  '[2# ##]'  ).
  lo_c8->add_text( text = ' ' ).
  lo_c9->add_gap( width = 2 ).
  lo_c9->add_link( name = 'PLANTVOLM' text =  '[#### ####]'  ).
  lo_c10->add_text( text = ' ' ).
  lo_c11->add_gap( width = 10 ).
  lo_c11->add_text( text =  '[####]'  ).

  lo_table->new_row( ). " ###
  lo_c1->add_gap( width = 4 ).
  lo_c1->add_text( text = ' ' ).
  lo_table->new_row( ). " ###

  lo_c3->add_gap( width = 4 ).
  IF gv_load_can = 'X'.
    lo_c3->add_link( name = 'LOADGR' text = '#### ##' ).
    lo_c4->add_icon( sap_icon = 'ICON_INCLUDE_IN_SELECTION' ).
  ELSEIF gv_load_gr = 'X'.
    lo_c3->add_text( text = '#### ##' ).
    lo_c4->add_icon( sap_icon = 'ICON_INCLUDE_IN_SELECTION' ).
  ELSE.
    lo_c3->add_text( text = '#### ###' ).
    lo_c4->add_icon( sap_icon = 'ICON_REMOVE_FROM_SELECTION' ).
  ENDIF.

  lo_c5->add_gap( width = 4 ).
  IF gv_plant_can = 'X'.
    lo_c5->add_link( name = 'PLANTGR' text = '#### ##' ).
    lo_c6->add_icon( sap_icon = 'ICON_INCLUDE_IN_SELECTION' ).
  ELSEIF gv_plant_gr = 'X'.
    lo_c5->add_text( text = '#### ##' ).
    lo_c6->add_icon( sap_icon = 'ICON_INCLUDE_IN_SELECTION' ).
  ELSE.
    lo_c5->add_text( text = '#### ###' ).
    lo_c6->add_icon( sap_icon = 'ICON_REMOVE_FROM_SELECTION' ).
  ENDIF.

  lo_c7->add_gap( width = 4 ).
  IF gv_inv_can = 'X'.
    lo_c7->add_link( name = 'INVOICE' text = '#### ##' ).
    lo_c8->add_icon( sap_icon = 'ICON_INCLUDE_IN_SELECTION' ).
  ELSEIF gv_inv_done = 'X'.
    lo_c7->add_text( text = '#### ##' ).
    lo_c8->add_icon( sap_icon = 'ICON_INCLUDE_IN_SELECTION' ).
  ELSE.
    lo_c7->add_text( text = '#### ###' ).
    lo_c8->add_icon( sap_icon = 'ICON_REMOVE_FROM_SELECTION' ).
  ENDIF.


*   ### ##(##)
*  lo_table->set_row_style( row_no  = 1   sap_style = 'SUCCESS' ). " sap_fontsize = 'LARGE'
*  lo_table->set_row_style( row_no  = 2   sap_style = 'HEADING' ).

  go_doc->merge_document( ).
  go_doc->display_document( parent = go_cont_doc ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form add_selected_data (### #### ## ## / ### alv# ##)
*&---------------------------------------------------------------------*
FORM add_selected_data. " 1# ##.

  DATA: lt_item     TYPE TABLE OF ty_item, " gt_item# ### ##
        ls_item     LIKE LINE OF lt_item,
        lv_tabix    TYPE sy-tabix,
        ls_tmp_vol  LIKE gs_volm,
        lt_volm     LIKE gt_volm,
        lv_loss_qty TYPE ztb1mm0007-menge. " ## ## ## ##

  " 1. #### ##(ps_volm-zdocno)# #### ## ###
  "    CDS view## ### ## ### ## #### itab# ##
  SELECT ebeln, ebelp, matnr, werks, lgort, menge, meins, wrbtr, dmbtr,
    fin_netpr_krw AS netpr, waersk, fin_netpr_usd AS netpr_usd, waers, insmk, add_ukurs
    FROM zcds_b1_mm_0002( p_bldat = @gs_head-bldat ) " ##### ### ####(#### ### bldat)
    INTO CORRESPONDING FIELDS OF TABLE @lt_item
   WHERE ebeln = @gv_ebeln.
  "  AND postat = '2'. " ## ##
  " AND lvorm <> 'X' " ## ## -> ## CDS view ### ###

  IF sy-subrc <> 0.
    MESSAGE i112(zmcb1) WITH '#### ## ##'. " ## ### #### ## ## ## ####
    RETURN.
  ENDIF.

  " ######(### #### #### LOAD## ##) #### ## #### ##
  IF gv_mode = 'L'.
    gs_item-bwart = '101'. " #### '##' ##

    READ TABLE gt_load_volm INTO ls_tmp_vol INDEX 1.
    CHECK sy-subrc = 0.
    gs_head-bktxt = |#### / { ls_tmp_vol-zmsno }|. " ## #### ##
    lt_volm = gt_load_volm.

  ELSEIF gv_mode = 'P'.
    gs_item-bwart = '321'. " #### #### ## ##

    READ TABLE gt_plant_volm INTO ls_tmp_vol INDEX 1.
    CHECK sy-subrc = 0.
    gs_head-bktxt = |#### / { ls_tmp_vol-zmsno }|. " ## #### ##
    lt_volm = gt_plant_volm.
  ENDIF.

  " #### ##(POSTAT)# ## #### ### ## ##
  SELECT postat FROM ztb1mm0007
   WHERE ebeln = @gv_ebeln AND lvorm <> 'X'
    INTO TABLE @DATA(lt_postat). " ### ## ##

  IF sy-subrc = 0. " ## ## #### ####(### # #### ## #### ## ## #)
    SORT lt_postat BY postat ASCENDING.
    READ TABLE lt_postat INTO DATA(ls_stat) INDEX 1.
    gv_postat = ls_stat-postat.
    " ### ### #### ## ### ### ##
    PERFORM get_domain_text USING 'ZDB1_MM_POSTAT' gv_postat CHANGING gv_postatxt.
  ENDIF.

  " 4. ## ALV# gt_item# ##### #### ## + ## ### ####
  LOOP AT lt_item INTO ls_item. " ### #### ##### gt_item ### ### ##

    " 4-1. ## ### ### ## ### 0### ### 0# ##
    IF ls_item-add_ukurs = 0 OR ls_item-netpr = 0.
      MESSAGE i407(zmcb1) WITH ls_item-matnr '##:' '###'. " (####) ##: ## ### ## ### ### #####.
      CONTINUE. " ## #### ALV# #### ## ## ### ###
    ENDIF.

    " 4-2. ##### ## # # ##
    READ TABLE gt_item WITH KEY matnr = '' TRANSPORTING NO FIELDS.
    lv_tabix = sy-tabix.

    IF sy-subrc = 0.
      " 4-3. # ## ### ## ## lv_tabix# #### #### (#### ##)
      READ TABLE gt_item ASSIGNING FIELD-SYMBOL(<fs_item>) INDEX lv_tabix.
    ELSE.
      " 4-4. ## 10## # ### ### ## ####
      APPEND INITIAL LINE TO gt_item ASSIGNING <fs_item>.
      PERFORM set_item_number. " ## ## ## ## ### ## ##### ### ##
    ENDIF.

    " (1) ## ## ##
    MOVE-CORRESPONDING ls_item TO <fs_item>. " ######

    IF gv_mode = 'L'.
      <fs_item>-insmk = 'T'.   " #### (#### ## = #### ##)

      READ TABLE lt_volm INTO DATA(ls_load_vol) WITH KEY zdocit = ls_item-ebelp.
      IF sy-subrc = 0.
        <fs_item>-menge = ls_load_vol-zsvol.
      ELSE.
        <fs_item>-menge = ls_item-menge.
      ENDIF.

    ELSEIF gv_mode = 'P'.
      <fs_item>-insmk = 'S'.   " #### (#### ## = ##=#### #### '##' ##)

      READ TABLE lt_volm INTO DATA(ls_plant_vol) WITH KEY zdocit = ls_item-ebelp.
      IF sy-subrc = 0.
        <fs_item>-menge = ls_plant_vol-zsvol. " ## ## ### '## ##'

        IF ls_item-menge > <fs_item>-menge.
          <fs_item>-zloss = ls_item-menge - <fs_item>-menge.
        ELSE.
          CLEAR <fs_item>-zloss. " ## ### ## ## 0 ##
        ENDIF.
      ELSE.
        <fs_item>-menge = ls_item-menge.
        CLEAR <fs_item>-zloss.
      ENDIF.
    ENDIF.

    " (2) ## ##
    IF <fs_item>-menge = ls_item-menge.
      <fs_item>-wrbtr     = ls_item-wrbtr.
      <fs_item>-dmbtr     = <fs_item>-netpr * <fs_item>-menge.
      <fs_item>-netpr_usd = ls_item-netpr_usd.
    ELSE.
      <fs_item>-netpr_usd = ls_item-netpr_usd.
      <fs_item>-wrbtr     = <fs_item>-netpr_usd * <fs_item>-menge.

      CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
        EXPORTING
          currency    = 'KRW'
          idoc_amount = ls_item-netpr
        IMPORTING
          sap_amount  = <fs_item>-netpr.

      <fs_item>-dmbtr     = <fs_item>-netpr     *  <fs_item>-menge.
    ENDIF.
    <fs_item>-bwart = gs_item-bwart.   " #### (####/####/####) ##

    " (3) ### #### ## ##
*    IF <fs_item>-werks IS INITIAL OR <fs_item>-lgort IS INITIAL.
*      " ## #### #### ## ##### EDIT ### #####
*      READ TABLE gt_fcat_item ASSIGNING FIELD-SYMBOL(<fs_fcat>) WITH KEY fieldname = 'WERKS'.
*      IF sy-subrc = 0.
*        <fs_fcat>-edit = 'X'.
*        <fs_fcat>-checktable = . " ### ## ## #### (### ## ###### ###)
*      ENDIF.
    " #### ## ##
*      READ TABLE gt_fcat_item ASSIGNING <fs_fcat> WITH KEY fieldname = 'LGORT'.
*      IF sy-subrc = 0.
*        <fs_fcat>-edit = 'X'.
*      ENDIF.
*      " # #### ### ####, ### ALV ##### #### ##
*      DATA(lv_edit_mode) = abap_true.
*    ENDIF.
  ENDLOOP.

  " 3. ## ### ALV ####

  go_alv->set_frontend_fieldcatalog( it_fieldcatalog = gt_fcat_item ).
  PERFORM refresh_alv USING gs_stable CHANGING go_alv.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ddisplay_mat_status (#### ## ## ##)
*&---------------------------------------------------------------------*
FORM display_mat_status.

  " 1. HTML #### #### ### # ##
  IF go_doc_101 IS INITIAL.
    CREATE OBJECT go_doc_101
      EXPORTING
        style            =  'DISPLAY'                " Adjusting to the Style of a Particular GUI Environment
*        background_color = 1
*        bds_stylesheet   =                  " Use BDS Style Sheet
*        no_margins       =                  " 'X': Document Created Without Free Margins
      .
  ELSE.
    go_doc_101->initialize_document( ).
  ENDIF.

*go_doc_101->set_area_style(
*    sap_color = cl_dd_document=>LIST_GROUP_INT
*  ).

  " 2. ### ## ##
  go_doc_101->add_text(
    text         = '# #### ## ## ##'
    sap_fontsize = cl_dd_document=>medium
    sap_emphasis = cl_dd_document=>strong
  ).
  go_doc_101->new_line( 1 ). " # # # ###

  " 3. # ## ### ## # ## ##
  go_doc_101->add_text(
    text         = ' ## ##### ## ######(##) ### ####.'
  ).

  " 4. ## ## # ## ##
  go_doc_101->merge_document( ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_transport_popup ( ### #### - #### ### ## )
*&---------------------------------------------------------------------*
FORM display_transport_popup .

*  DATA: lv_target_service TYPE packno,
*        lt_popup_tran     TYPE TABLE OF ty_tran, " ##### ### ## ## ##
*        lt_done_po        TYPE TABLE OF ty_tran_key,
*        lt_cr_po          TYPE TABLE OF ty_tran_key.
*
*  " ##### ### ##### ##
*  IF gs_load_item-zebelnsv IS NOT INITIAL.
*    lv_target_service = gs_load_item-zebelnsv.
*  ENDIF.
*
*  " ### #### ### ## ## ### ### # # #### -> ### ### ## ## x
*  IF lv_target_service IS INITIAL.
*    MESSAGE s029(zmcb1) WITH gv_ebeln '### #### ##'. " &1#(#) &2#(#) #### ####.
*    EXIT.
*  ENDIF.
*
*  " ## ### ## ## (## ## ### ### ### ## # ###)
*  SELECT b~ebeln, b~ebelp, b~seqno, b~event_type, b~event_status, b~event_date, b~location, b~remark
*    FROM ztb1mm0007 AS a
*   INNER JOIN ztb1mm0021 AS b ON b~ebeln = a~ebeln AND b~ebelp = a~ebelp
*    INTO CORRESPONDING FIELDS OF TABLE @lt_popup_tran
*   WHERE a~ebeln = @lv_target_service.
*
*  " ### ## ### ###, ## ### ####/## #### DB# ### ## ##
*  IF lt_popup_tran IS INITIAL.
*    MESSAGE s029(zmcb1) WITH lv_target_service '### ## #### ###'. " &1#(#) &2#(#) #### ####.
*    EXIT.
*  ENDIF.
*
*  " #### ### -> ####(## ## ##) ### ## ###
*  DATA: lv_latest_index TYPE i,
*        lv_max_date     TYPE sy-datum.
*
*  " ## ### ## # ## ##(## # ##)# ### ####
*  LOOP AT lt_popup_tran INTO DATA(ls_search).
*    IF ls_search-event_date > sy-datum.
*      CONTINUE. " ## ### ####
*    ENDIF.
*
*    " ## ####, ### ### #### # ### ### ## #### ####
*    IF lv_max_date IS INITIAL OR ls_search-event_date > lv_max_date.
*      lv_max_date     = ls_search-event_date.
*      lv_latest_index = sy-tabix.
*    ENDIF.
*  ENDLOOP.
*
*  LOOP AT lt_popup_tran ASSIGNING FIELD-SYMBOL(<fs_tran>).
*
*    " ## ## ## ## ### #### #
*    IF sy-tabix = lv_latest_index.
*      <fs_tran>-excp_fld = icon_ws_ship. " #### ## #### ####
*      <fs_tran>-col_fld  = 'C300'.            " ## ##### ## ## ##
*      CONTINUE.
*    ENDIF.
*
*    " ## ### ### ## ## #
*    IF <fs_tran>-event_date < lv_max_date.
**      <fs_tran>-excp_fld = icon_yellow_light.
*      <fs_tran>-col_fld  = ' '.
*
*    " ### ### ### ## ## # (EVENT_DATE > SY-DATUM # ## #)
*    ELSE.
**      <fs_tran>-excp_fld = icon_red_light.
*      <fs_tran>-col_fld  = ' '.
*    ENDIF.
*
*  ENDLOOP.
*
*  " 4. SALV ## ###
*  DATA: lo_popup_alv TYPE REF TO cl_salv_table,
*        lo_columns   TYPE REF TO cl_salv_columns_table,
*        lo_column    TYPE REF TO cl_salv_column_table.
*
*  TRY.
*      cl_salv_table=>factory(
*        IMPORTING r_salv_table = lo_popup_alv
*        CHANGING  t_table      = lt_popup_tran ).
*
*      lo_popup_alv->set_screen_popup(
*        start_column = 15 end_column = 95 start_line = 5 end_line = 18 ).
*
*      lo_columns = lo_popup_alv->get_columns( ).
*      lo_columns->set_optimize( 'X' ).
*      lo_columns->set_color_column( 'COL_FLD' ).
*
*      PERFORM set_fcat TABLES ct_fcat_tran USING:
*        'S' 'FIELDNAME' 'EXCP_FLD',     ' ' 'COLTEXT' '##',  ' ' 'ICON' 'X', ' ' 'KEY' 'X', ' ' 'EMPHASIZE' 'C110', 'E' ' ' ' ', " ### ## ###
*        'S' 'FIELDNAME' 'EBELN',        ' ' 'COLTEXT' '#### ##',     ' ' 'KEY' 'X', ' ' 'EMPHASIZE' 'C110', ' ' 'HOTSPOT'   'X', 'E' ' ' ' ', " ##### ### ##
*        'S' 'FIELDNAME' 'EBELP',        ' ' 'COLTEXT' '####',    ' ' 'LZERO'     'X', ' ' 'KEY' 'X', ' ' 'EMPHASIZE' 'C110', ' ' 'OUTPUTLEN' '4', 'E' ' ' ' ',
*        " ###: NO_OUT 'X'
*        'S' 'FIELDNAME' 'PACKNO',       ' ' 'COLTEXT' '### ### ##', ' ' 'NO_OUT' 'X', ' ' 'KEY' 'X', ' ' 'EMPHASIZE' 'C110', 'E' ' ' ' ',
*        'S' 'FIELDNAME' 'SEQNO',        ' ' 'COLTEXT' '## ##',         ' ' 'NO_OUT' 'X', ' ' 'KEY' 'X', ' ' 'EMPHASIZE' 'C110', 'E' ' ' ' ',
*        'S' 'FIELDNAME' 'EVENT_TYPE',   ' ' 'COLTEXT' '### ##',       ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
*        'S' 'FIELDNAME' 'EVENT_DATE',   ' ' 'COLTEXT' '##',       'E' ' ' ' ',
*        'S' 'FIELDNAME' 'REMARK',     ' ' 'COLTEXT' '##',       'E' ' ' ' ',
*        'S' 'FIELDNAME' 'LOCATION',     ' ' 'COLTEXT' '##',       'E' ' ' ' '.
*
*      lo_popup_alv->display( ).
*
*    CATCH cx_salv_msg.
*      MESSAGE '## ## ##' TYPE 'S' DISPLAY LIKE 'E'.
*  ENDTRY.

ENDFORM.
