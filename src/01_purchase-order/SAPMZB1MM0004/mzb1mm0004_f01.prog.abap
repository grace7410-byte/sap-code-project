*&---------------------------------------------------------------------*
*& Include          MZB1MM0004_F01
*&---------------------------------------------------------------------*
*& Form set_init_user_data (###### ## ####)
*&---------------------------------------------------------------------*
FORM set_init_user_data .
  SELECT parid, parva " SET/GET #### ID# # value ## ###
    FROM usr05
   WHERE bname = @sy-uname
   INTO TABLE @DATA(lt_data).

  IF sy-subrc NE 0.
    MESSAGE s018(zmcb1) DISPLAY LIKE 'E'. " ### # ## ######
    LEAVE PROGRAM.
  ELSE.
    SORT lt_data BY parid. "#### id# ####

    READ TABLE lt_data INTO DATA(ls_data)
      WITH KEY parid = 'BUK' BINARY SEARCH. " ####
    IF sy-subrc EQ 0.
      gs_head-bukrs = ls_data-parva.
      PERFORM get_domain_text USING 'ZDB1_MM_BUKRS' gs_head-bukrs  CHANGING gv_bukrs. " #### ###
    ENDIF.

    IF gs_head-bukrs IS INITIAL OR gv_bukrs IS INITIAL.
      gs_head-bukrs = '1000'.
      PERFORM get_domain_text USING 'ZDB1_MM_BUKRS' gs_head-bukrs  CHANGING gv_bukrs. " #### ###
    ENDIF.

    CLEAR : ls_data.
    READ TABLE lt_data INTO ls_data
          WITH KEY parid = 'EKO' BINARY SEARCH. " ####
    IF sy-subrc EQ 0.
      gs_head-ekorg = ls_data-parva.
      PERFORM get_domain_text USING 'ZDB1_MM_EKORG' gs_head-ekorg  CHANGING gv_ekorg. " #### ###
    ENDIF.

    CLEAR : ls_data.
    READ TABLE lt_data INTO ls_data
          WITH KEY parid = 'EKG' BINARY SEARCH. " ####
    IF sy-subrc EQ 0.
      gs_head-ekgrp = ls_data-parva.
      PERFORM get_domain_text USING 'ZDB1_MM_EKGRP' gs_head-ekgrp  CHANGING gv_ekgrp. " #### ###
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_header_data (100# ### ## ### ##)
*&---------------------------------------------------------------------*
FORM get_header_data .
  " 1. ZTB1SD0001(BP##) ##### BP### #### BP## ### (BP### ### 1)
  SELECT SINGLE bpnm
    FROM ztb1sd0001  " BP ### (##)
    INTO @gv_bpnm    " #### ### ###
    WHERE bpid  = @gs_head-bpid
      AND bptyp = '1'.
  IF sy-subrc <> 0.
    CLEAR gv_bpnm. " #### # ### ## ### ## & ###
    MESSAGE s108(zmcb1) WITH gs_head-bpid DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  " 2. ZTB1MM0004## ##### ## ## ### ## ####
  SELECT SINGLE ekorg, ekgrp, bukrs, zterm, inco1 "####, ##, ####, ####, ####
    FROM ztb1mm0004 " BP ### (##)
    INTO (@gs_head-ekorg, @gs_head-ekgrp, @gs_head-bukrs,
          @gs_head-zterm, @gs_head-inco1)
    WHERE bpid = @gs_head-bpid.
  IF sy-subrc <> 0.
    PERFORM clear_header_data.
  ELSE. " ####(##)# ### ## ## ### # ####
    "# Domain FV# Description ##
    PERFORM get_domain_text USING 'ZDB1_MM_EKORG' gs_head-ekorg  CHANGING gv_ekorg. " ####
    PERFORM get_domain_text USING 'ZDB1_MM_EKGRP' gs_head-ekgrp  CHANGING gv_ekgrp. " ####
    PERFORM get_domain_text USING 'ZDB1_MM_BUKRS' gs_head-bukrs  CHANGING gv_bukrs. " ####
    PERFORM get_domain_text USING 'ZDB1_MM_ZTERM' gs_head-zterm  CHANGING gv_zterm. " ####
    PERFORM get_domain_text USING 'ZDB1_MM_INCO1' gs_head-inco1  CHANGING gv_inco1. " ####
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form clear_header_data (100# ### ## ### ###)
*&---------------------------------------------------------------------*
FORM clear_header_data .
  " ## ## # ### # ## ###
  CLEAR: gv_bpnm, gv_ekorg, gv_ekgrp, gv_bukrs, gv_postat, gv_zterm, gv_inco1.
  CLEAR: gs_head-ekorg, gs_head-ekgrp, gs_head-bukrs, gs_head-zterm, gs_head-inco1,
         gs_head-zebeln, gs_head-knumh, gs_head-lvorm, gs_head-ernam, gs_head-erdat, gs_head-erzet, gs_head-aenam, gs_head-aedat,gs_head-aezet.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_header_domain_value (100# ### ## ### FV ### ##)
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
*& Form set_item_number (100# ### ALV #### ## ## ## ##)
*&---------------------------------------------------------------------*
FORM set_item_number.
  " ## ### ## Modify# ### ### ## ## ##
  LOOP AT gt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
    <fs_item>-ebelp = sy-tabix * 10. " alv## ## ## ## #*10 ex-0010, 0020, ...
  ENDLOOP.
  CHECK go_alv IS BOUND. " ## #####, ## # ## ### ### ### # ### ####
  go_alv->refresh_table_display( ). " ## ## ## ## refresh ##
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_init_item_rows (100# ### ALV ## # # ### - 10#)
*&---------------------------------------------------------------------*
FORM set_init_item_rows.
  IF gt_item IS INITIAL.
    DO 10 TIMES.
      APPEND INITIAL LINE TO gt_item. " #### 10# ##
    ENDDO.
    PERFORM set_item_number." 10## ## ## ## ##
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_object (## - ### #### # alv ### ###)
*&---------------------------------------------------------------------*
FORM create_object USING pv_area TYPE c
                         pv_basic TYPE c
                  CHANGING po_cont TYPE REF TO cl_gui_custom_container
                           po_alv TYPE REF TO Cl_gui_alv_grid.
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
  IF pv_basic = 'X'. " GO_ALV# ##
    " #### ## ## ### ## #, ### # ## ## ## #### #### #### # #### ##
    po_alv->register_edit_event( i_event_id = cl_gui_alv_grid=>mc_evt_enter ).
    po_alv->register_edit_event( i_event_id = cl_gui_alv_grid=>mc_evt_modified ).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_chart_object (## cont # chart ### ## - ##)
*&---------------------------------------------------------------------*
FORM create_chart_object  USING pv_area TYPE c
                          CHANGING po_cont TYPE REF TO cl_gui_custom_container
                                   po_chart TYPE REF TO Cl_gui_chart_engine.
  CREATE OBJECT po_cont
    EXPORTING
      container_name = pv_area. " ####### ## ### ####

  CREATE OBJECT po_chart " cont# ## ## ##
    EXPORTING
      parent = po_cont.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_object_all (130# ### - Splitter cont, ## alv# chart# ##
*&---------------------------------------------------------------------*
FORM create_object_all.
  CREATE OBJECT go_cont_chartall " 130# custom ### container ## ###
    EXPORTING
      container_name = 'CHARTALL'.

  CREATE OBJECT go_splitter " ##### # ####
    EXPORTING
      parent  = go_cont_chartall
      rows    = 1
      columns = 2.

  go_splitter->set_column_width( EXPORTING id = 1 width = 35 )
    .
  " ##, #### ## #### ### ####
  go_cont_l  = go_splitter->get_container( row = 1 column = 1 ). " ## #
  go_cont_r = go_splitter->get_container( row = 1 column = 2 ).

  CREATE OBJECT go_alv_all " #### alv ## ##
    EXPORTING
      i_parent = go_cont_l.

  CREATE OBJECT go_chartall " ##### ## ## ##
    EXPORTING
      parent = go_cont_r.
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
* ZRB1MM0001## #### [Refresh ##] 2##
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
  " ## ##
  ps_layout-zebra      = 'X'. " ### ##
  ps_layout-sel_mode   = 'A'. " ## # ## ##

  IF pv_type = 1.
    " item## #### alv layout ##
    ps_layout-grid_title = '#### ###'.
    IF gv_mode <> 'D'.
      ps_layout-sel_mode = 'B'. " ## # ## ##
    ENDIF.

  ELSEIF pv_type = 2. " opti# ##
    ps_layout-grid_title = '##### ## ## ## ##'.

  ELSEIF pv_type = 3. " pohd# ##
    ps_layout-grid_title = '#### ###'.
    ps_layout-sel_mode   = 'B'. " ## # ## ##
    ps_layout-cwidth_opt = 'X'. " # ## ## ###

  ELSEIF pv_type = 4. " vend# ##
    ps_layout-grid_title = '#### ##'.
    ps_layout-cwidth_opt = 'X'. " # ## ## ###

  ELSEIF pv_type = 5. " bom# ##
    ps_layout-grid_title = '### BOM ## ##'.
    ps_layout-cwidth_opt = 'X'. " # ## ## ###
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_uifunc (100# ### ALV ## ## ## ## ->  layout# NO_TOOLBAR = 'X'# ##### #)
*&---------------------------------------------------------------------*
FORM set_uifunc USING pv_type TYPE i
                      pt_uifunc  TYPE ui_functions.
  REFRESH pt_uifunc.
  IF pv_type = 100.
    " ## item## #### ui function ##
*    APPEND cl_gui_alv_grid=>mc_fc_detail       TO pt_uifunc. " ### ###
*    APPEND cl_gui_alv_grid=>mc_fc_loc_copy     TO pt_uifunc.
*
*    " # ### ####, ####, # ##, ##, ## ## ### ####
*    APPEND cl_gui_alv_grid=>mc_fc_check        TO pt_uifunc. "
*    APPEND cl_gui_alv_grid=>mc_fc_loc_cut      TO pt_uifunc. "
*    APPEND cl_gui_alv_grid=>mc_fc_loc_paste    TO pt_uifunc. "
*    APPEND cl_gui_alv_grid=>mc_fc_loc_paste_new_row TO pt_uifunc.
*    APPEND cl_gui_alv_grid=>mc_fc_sort_asc     TO pt_uifunc. "
*    APPEND cl_gui_alv_grid=>mc_fc_sort_dsc     TO pt_uifunc. "
*    APPEND cl_gui_alv_grid=>mc_fc_find         TO pt_uifunc. "
*    APPEND cl_gui_alv_grid=>mc_fc_filter       TO pt_uifunc. "
*    APPEND cl_gui_alv_grid=>mc_fc_print        TO pt_uifunc. "
*    APPEND cl_gui_alv_grid=>mc_fc_graph        TO pt_uifunc. "
*    APPEND cl_gui_alv_grid=>mc_fc_info         TO pt_uifunc. "
*    APPEND cl_gui_alv_grid=>mc_mb_sum          TO pt_uifunc.
*    APPEND cl_gui_alv_grid=>mc_mb_variant      TO pt_uifunc.
*    APPEND cl_gui_alv_grid=>mc_mb_view         TO pt_uifunc.
*    APPEND cl_gui_alv_grid=>mc_mb_export       TO pt_uifunc.
  ELSE. " opti, vend, all ## ##
    APPEND cl_gui_alv_grid=>mc_fc_excl_all TO pt_uifunc. " ## # ###
  ENDIF.
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
*& set_fcat_item (100# ### ALV ## #### ##)
*&---------------------------------------------------------------------*
FORM set_fcat_item CHANGING ct_fcat_item TYPE lvc_t_fcat.
  REFRESH ct_fcat_item.
*  CLEAR gs_fcat. " #### ## ###### ## ## (## ###)
*  gs_fcat-fieldname = 'EBELP'.
*  APPEND gs_fcat TO gt_fcat.

  " -> ### ####, #### ## ##
  PERFORM set_fcat TABLES ct_fcat_item USING:
        'S' 'FIELDNAME' 'EBELP', " #### ## ##
        ' ' 'COLTEXT'   '##',   " ### ###
        ' ' 'JUST' 'C', " ### ##
        ' ' 'KEY' 'X', ' ' 'EMPHASIZE' 'C110', " ### ## # ## ###!
        ' ' 'LZERO'     'X',     " 0# ### 0010## ##(char4)
        ' ' 'OUTPUTLEN' '4',     " layout## ## ### ## #### ## ##
        'E' ''          '',      " APPEND ### #### ## (## ##)
        " ### 'S'# ## ## 'E'# ####### #
        "### #### ## ##(###)
        'S' 'FIELDNAME' 'EPSTP',  ' ' 'COLTEXT' '### ####', ' ' 'JUST' 'C', ' ' 'NO_OUT' 'X', ' ' 'REF_TABLE' 'ZTB1MM0007', ' ' 'REF_FIELD' 'EPSTP', ' ' 'OUTPUTLEN' '10', ' ' 'EDIT' 'X', 'E' ' ' ' ',
         " EDIT = 'X' ## ## ##                            " ## ### # ### ####, F4VAILABL# #### F4 Help# ### # ##
        'S' 'FIELDNAME' 'MATNR',  ' ' 'COLTEXT' '####',        ' ' 'OUTPUTLEN' '10', ' ' 'JUST' 'C',  ' ' 'REF_TABLE' 'ZTB1MM0007', ' ' 'REF_FIELD' 'MATNR', ' ' 'EDIT' 'X',  ' ' 'F4AVAILABL' 'X', 'E' ' ' ' ', " EDIT = 'X' ## ## ##
        'S' 'FIELDNAME' 'WERKS',  ' ' 'COLTEXT' '###',         ' ' 'OUTPUTLEN' '6', ' ' 'JUST' 'C', ' ' 'REF_TABLE' 'ZTB1MM0007', ' ' 'REF_FIELD' 'WERKS', ' ' 'F4AVAILABL' 'X', ' ' 'EDIT' 'X',  'E' ' ' ' ',
        'S' 'FIELDNAME' 'LGORT',  ' ' 'COLTEXT' '####',        ' ' 'OUTPUTLEN' '4', ' ' 'JUST' 'C', ' ' 'REF_TABLE' 'ZTB1MM0007', ' ' 'REF_FIELD' 'LGORT', ' ' 'F4AVAILABL' 'X', ' ' 'OUTPUTLEN' '6',  ' ' 'EDIT' 'X', 'E' ' ' ' ',
        'S' 'FIELDNAME' 'MENGE',  ' ' 'COLTEXT' '## ##',       ' ' 'OUTPUTLEN' '20', ' ' 'EDIT' 'X', ' ' 'NO_ZERO' 'X',   'E' ' ' ' ',
        'S' 'FIELDNAME' 'MEINS',  ' ' 'COLTEXT' '## ##',       ' ' 'OUTPUTLEN' '6', 'E' ' ' ' ', " NO_ZERO = 'X' ## 0# # ## ## # #
        'S' 'FIELDNAME' 'NETPR',  ' ' 'COLTEXT' '##',            ' ' 'OUTPUTLEN' '30',  ' ' 'NO_ZERO' 'X',  'E' ' ' ' ',
        'S' 'FIELDNAME' 'DMBTR',  ' ' 'COLTEXT' '# ##',         ' ' 'OUTPUTLEN' '30', ' ' 'NO_ZERO' 'X',  'E' ' ' ' ',
        'S' 'FIELDNAME' 'WAERSK', ' ' 'COLTEXT' '##',         ' ' 'OUTPUTLEN' '6',  ' ' 'JUST' 'C', ' ' 'REF_TABLE' 'ZTB1MM0007', ' ' 'REF_FIELD' 'WAERSK', 'E' ' ' ' ',
        'S' 'FIELDNAME' 'WRBTR',  ' ' 'NO_OUT' 'X',             'E' '' '',   " NO_OUT = 'X' ## ## ##
        'S' 'FIELDNAME' 'WAERS',  ' ' 'NO_OUT' 'X',             'E' '' '',   " USD ### #### ##### #### ##
        'S' 'FIELDNAME' 'MWSKZ',  ' ' 'COLTEXT' '####',        ' ' 'OUTPUTLEN' '6', ' ' 'JUST' 'C', ' ' 'REF_TABLE' 'ZTB1MM0007', ' ' 'REF_FIELD' 'MWSKZ', 'E' ' ' ' ',
        'S' 'FIELDNAME' 'EINDT',  ' ' 'COLTEXT' '## ###',      ' ' 'OUTPUTLEN' '12', ' ' 'JUST' 'C',' ' 'REF_TABLE' 'ZTB1MM0007', ' ' 'REF_FIELD' 'EINDT', ' ' 'EDIT' 'X', ' ' 'F4AVAILABL' 'X',  'E' ' ' ' ',
        'S' 'FIELDNAME' 'SLFDT',  ' ' 'COLTEXT' '## ###',      ' ' 'OUTPUTLEN' '12', ' ' 'JUST' 'C', ' ' 'REF_TABLE' 'ZTB1MM0007', ' ' 'REF_FIELD' 'SLFDT', 'E' ' ' ' ',
        'S' 'FIELDNAME' 'INSMK',  ' ' 'NO_OUT' 'X',  'E' '' '', " ## ## ### #### #### ##(A) ##
        'S' 'FIELDNAME' 'PACKNO', ' ' 'NO_OUT' 'X',  'E' '' '', " ### ## ##### #### ###
        'S' 'FIELDNAME' 'KNTTP',  ' ' 'NO_OUT' 'X',  'E' '' '',
        'S' 'FIELDNAME' 'SAKTO',  ' ' 'NO_OUT' 'X',  'E' '' '',
*          'S' 'FIELDNAME' 'EPSTP',  ' ' 'NO_OUT' 'X',  'E' '' '',   "### #### ## ## ##(###)
        'S' 'FIELDNAME' 'POSTAT', ' ' 'NO_OUT' 'X',  'E' '' ''. " ## ## ### #### 1(##)# ##

  " ## ### # ## ### EDIT ## ###(=> ## ## ## - ##### ###)
  FIELD-SYMBOLS: <fs_item> TYPE lvc_s_fcat.

  LOOP AT ct_fcat_item ASSIGNING <fs_item>.
    IF gv_mode = 'D'.
      <fs_item>-edit = ' '.  " ## ### ## ## ## ## ##
    ENDIF.

    IF gv_mode = 'U' OR gv_mode = 'D'.
      IF <fs_item>-fieldname = 'NETPR' OR <fs_item>-fieldname = 'DMBTR'.
        CLEAR <fs_item>-decimals_o.
        <fs_item>-ref_table  = 'ZTB1MM0007'.  " ## ###
        <fs_item>-ref_field  = <fs_item>-fieldname. " NETPR ## DMBTR
        <fs_item>-cfieldname = 'WAERSK'.      " ### ### ##
        " <fs_item>-decimals_o = '0'.
      ENDIF.
    ELSE.
      IF <fs_item>-fieldname = 'NETPR' OR <fs_item>-fieldname = 'DMBTR'.
        <fs_item>-decimals_o = '0'.  " ## ## # ### ### ### (11,000.00 -> 11,000)
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_vend (101# ALV ## #### ##)
*&---------------------------------------------------------------------*
FORM set_fcat_vend CHANGING ct_fcat_vend TYPE lvc_t_fcat.
  PERFORM set_fcat TABLES ct_fcat_vend USING:
        'S' 'FIELDNAME' 'BPID',      ' ' 'COLTEXT' 'BP ##',        ' ' 'EMPHASIZE' 'C110', ' ' 'HOTSPOT'   'X', ' ' 'REF_TABLE' 'ZTB1SD0001', ' ' 'REF_FIELD' 'BPID',      ' ' 'F4AVAILABL' 'X', 'E' ' ' ' ',
        'S' 'FIELDNAME' 'BPTYP',     ' ' 'COLTEXT' 'BP ##',        ' ' 'EMPHASIZE' 'C110', ' ' 'REF_TABLE' 'ZTB1SD0001', ' ' 'REF_FIELD' 'BPTYP',     'E' ' ' ' ',
        'S' 'FIELDNAME' 'BPTYPTXT',  ' ' 'COLTEXT' '###',        'E' ' ' ' ',
        'S' 'FIELDNAME' 'BPNM',      ' ' 'COLTEXT' 'BP #',        ' ' 'HOTSPOT'   'X',   ' ' 'REF_TABLE' 'ZTB1SD0001', ' ' 'REF_FIELD' 'BPNM',      'E' ' ' ' ',
        'S' 'FIELDNAME' 'CNTCD',     ' ' 'COLTEXT' '## ##',      ' ' 'REF_TABLE' 'ZTB1SD0001', ' ' 'REF_FIELD' 'CNTCD',     'E' ' ' ' ',
        'S' 'FIELDNAME' 'RECON',     ' ' 'COLTEXT' '####',       ' ' 'REF_TABLE' 'ZTB1SD0002', ' ' 'REF_FIELD' 'RECON',     'E' ' ' ' ',
        'S' 'FIELDNAME' 'EKORG',     ' ' 'COLTEXT' '## ##',      ' ' 'REF_TABLE' 'ZTB1MM0004', ' ' 'REF_FIELD' 'EKORG',     'E' ' ' ' ',
        'S' 'FIELDNAME' 'EKGRP',     ' ' 'COLTEXT' '## ##',      ' ' 'REF_TABLE' 'ZTB1MM0004', ' ' 'REF_FIELD' 'EKGRP',     'E' ' ' ' ',
        'S' 'FIELDNAME' 'ZTERM',     ' ' 'COLTEXT' '## ##',      ' ' 'REF_TABLE' 'ZTB1MM0004', ' ' 'REF_FIELD' 'ZTERM',     'E' ' ' ' ',
        'S' 'FIELDNAME' 'INCO1',     ' ' 'COLTEXT' '####',       ' ' 'REF_TABLE' 'ZTB1MM0004', ' ' 'REF_FIELD' 'INCO1',     'E' ' ' ' ',
        'S' 'FIELDNAME' 'MWSKZ',     ' ' 'COLTEXT' '## ##',      ' ' 'REF_TABLE' 'ZTB1MM0004', ' ' 'REF_FIELD' 'MWSKZ',     'E' ' ' ' ',
        'S' 'FIELDNAME' 'BUKRS',     ' ' 'COLTEXT' '## ##',      ' ' 'REF_TABLE' 'ZTB1MM0004', ' ' 'REF_FIELD' 'BUKRS',     'E' ' ' ' ',
        'S' 'FIELDNAME' 'ZVLEAD',    ' ' 'COLTEXT' '## ##',      ' ' 'REF_TABLE' 'ZTB1MM0004', ' ' 'REF_FIELD' 'ZVLEAD',    'E' ' ' ' ',
        'S' 'FIELDNAME' 'ADDR',      ' ' 'COLTEXT' '####',       ' ' 'REF_TABLE' 'ZTB1SD0001', ' ' 'REF_FIELD' 'ADDR',      'E' ' ' ' ',
        'S' 'FIELDNAME' 'BIZNO',     ' ' 'COLTEXT' '### ##',    ' ' 'REF_TABLE' 'ZTB1SD0001', ' ' 'REF_FIELD' 'BIZNO',     'E' ' ' ' ',
        'S' 'FIELDNAME' 'EMAIL',     ' ' 'COLTEXT' '###',         ' ' 'REF_TABLE' 'ZTB1SD0001', ' ' 'REF_FIELD' 'EMAIL',     'E' ' ' ' ',
        'S' 'FIELDNAME' 'ACCNO',     ' ' 'COLTEXT' '####',       ' ' 'REF_TABLE' 'ZTB1SD0001', ' ' 'REF_FIELD' 'ACCNO',     'E' ' ' ' ',
        'S' 'FIELDNAME' 'BANK',      ' ' 'COLTEXT' '###',         ' ' 'REF_TABLE' 'ZTB1SD0001', ' ' 'REF_FIELD' 'BANK',      'E' ' ' ' ',
        'S' 'FIELDNAME' 'WAERS',     ' ' 'COLTEXT' '## ##',      ' ' 'REF_TABLE' 'ZTB1SD0001', ' ' 'REF_FIELD' 'WAERS',     'E' ' ' ' ',
        'S' 'FIELDNAME' 'PICNM',     ' ' 'COLTEXT' '### ###',  ' ' 'REF_TABLE' 'ZTB1SD0001', ' ' 'REF_FIELD' 'PICNM',     'E' ' ' ' ',
        'S' 'FIELDNAME' 'PICTL',     ' ' 'COLTEXT' '### ####', ' ' 'REF_TABLE' 'ZTB1SD0001', ' ' 'REF_FIELD' 'PICTL',     'E' ' ' ' '.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_opti (110# ALV ## #### ##)
*&---------------------------------------------------------------------*
FORM set_fcat_opti CHANGING ct_fcat_opti TYPE lvc_t_fcat.
*  DATA: ls_fcat TYPE lvc_s_fcat.
*  ls_fcat-de
  PERFORM set_fcat TABLES ct_fcat_opti USING:
        " 'S' 'COLTEXT'   '##',   " (##)
        " 'E' ''          '',      " APPEND ### #### ## (## ##)
        " ### 'S'# ## ## ### ' ', 'E'# ####### #

          " ##### # '###', '###'# ## ### ### ### ####, ### #### # # ## ### ###
          'S' 'FIELDNAME' 'SELECT',   ' ' 'COLTEXT' '##',     ' ' 'ICON' 'X', ' ' 'JUST' 'C',  ' ' 'OUTPUTLEN' '4', ' ' 'EMPHASIZE' 'C110', 'E' ' ' ' ',
*          'S' 'FIELDNAME' 'ZSEL',   ' ' 'COLTEXT' '##',     ' ' 'ICON' 'X', ' ' 'JUST' 'C',  ' ' 'OUTPUTLEN' '3', ' ' 'EMPHASIZE' 'C110', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'AEDAT', ' ' 'COLTEXT' '###',    ' ' 'EMPHASIZE' 'C110',   ' ' 'OUTPUTLEN' '10', ' ' 'JUST' 'C', 'E' ' ' ' ', " Visible
          'S' 'FIELDNAME' 'AEZET', ' ' 'COLTEXT' '####',   ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'AENAM', ' ' 'COLTEXT' '###',    ' ' 'EMPHASIZE' 'C110', ' ' 'OUTPUTLEN' '7',   ' ' 'JUST' 'C', 'E' ' ' ' ', " Visible
          'S' 'FIELDNAME' 'BPID',   ' ' 'COLTEXT' '#### ##',   ' ' 'OUTPUTLEN' '10', ' ' 'JUST' 'C',  ' ' 'EMPHASIZE' 'C110','E' ' ' ' ',
        " ## ## ## (Visible)
          'S' 'FIELDNAME' 'MATNR',  ' ' 'COLTEXT' '####',        ' ' 'OUTPUTLEN' '8', ' ' 'JUST' 'C', 'E' ' ' ' ', " JUST = 'C' ### ##
          'S' 'FIELDNAME' 'HERKL',  ' ' 'COLTEXT' '###',         ' ' 'OUTPUTLEN' '4', ' ' 'JUST' 'C', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'PLIFZ',  ' ' 'COLTEXT' '####',       ' ' 'OUTPUTLEN' '6', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'TEXTDAY',  ' ' 'COLTEXT' '##',       ' ' 'OUTPUTLEN' '3', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'NETPR',  ' ' 'COLTEXT' '######',  ' ' 'OUTPUTLEN' '9', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'ZFRT',   ' ' 'COLTEXT' '#####',     ' ' 'OUTPUTLEN' '8', ' ' 'DECIMALS_O' '0', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'ZOTH',   ' ' 'COLTEXT' '####',       ' ' 'OUTPUTLEN' '6',   'E' ' ' ' ',
          'S' 'FIELDNAME' 'ZGRM',   ' ' 'COLTEXT' '####',  ' ' 'OUTPUTLEN' '6',  'E' ' ' ' ',
          'S' 'FIELDNAME' 'WAERS',  ' ' 'COLTEXT' '##',     ' ' 'OUTPUTLEN' '3', ' ' 'REF_TABLE' 'ZTB1MM0005', ' ' 'REF_FIELD' 'WAERS',  'E' ' ' ' ',
*          'S' 'FIELDNAME' 'DATAB',  ' ' 'COLTEXT' '## ###',    ' ' 'OUTPUTLEN' '10', ' ' 'JUST' 'C', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'DATBI',  ' ' 'COLTEXT' '## ###',     ' ' 'OUTPUTLEN' '10',' ' 'JUST' 'C', 'E' ' ' ' ',

          " ## ## (No Out)
          'S' 'FIELDNAME' 'KNUMH',  ' ' 'COLTEXT' '#### ##',   ' ' 'JUST' 'C', ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'MEINS',  ' ' 'COLTEXT' '## ##',      ' ' 'JUST' 'C', ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'MWSKZ',  ' ' 'COLTEXT' '## ##',       ' ' 'JUST' 'C', ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'LVORM',  ' ' 'COLTEXT' '## ##',       ' ' 'JUST' 'C', ' ' 'NO_OUT' 'X', 'E' ' ' ' ',

          " ## ##### (## ##)
          'S' 'FIELDNAME' 'ERDAT', ' ' 'COLTEXT' '###',   ' ' 'JUST' 'C', ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'ERZET', ' ' 'COLTEXT' '####', ' ' 'JUST' 'C', ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'ERNAM', ' ' 'COLTEXT' '###',   ' ' 'JUST' 'C', ' ' 'NO_OUT' 'X', 'E' ' ' ' '.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_all (130# ALV ## #### ##)
*&---------------------------------------------------------------------*
FORM set_fcat_all CHANGING ct_fcat_all TYPE lvc_t_fcat.
  PERFORM set_fcat TABLES ct_fcat_all USING:
         'S' 'FIELDNAME' 'STLNR',        ' ' 'COLTEXT' 'BOM ID',        ' ' 'EMPHASIZE' 'C110',' ' 'JUST' 'C', 'E' ' ' ' ',
         'S' 'FIELDNAME' 'STLKN',        ' ' 'COLTEXT' 'Node ##',       ' ' 'NO_OUT'  'X', 'E' ' ' ' ',
         'S' 'FIELDNAME' 'BOMVE',        ' ' 'COLTEXT' 'BOM ##',         ' ' 'NO_OUT'  'X', 'E' ' ' ' ',
         'S' 'FIELDNAME' 'CRUDE',        ' ' 'COLTEXT' '## ##',          ' ' 'EMPHASIZE' 'C110',  ' ' 'JUST' 'C', 'E' ' ' ' ',
         'S' 'FIELDNAME' 'CRUDE_MAKTX',  ' ' 'COLTEXT' '###',            ' ' 'EMPHASIZE' 'C110', 'E' ' ' ' ',
         'S' 'FIELDNAME' 'CRUDE_TEXT',   ' ' 'COLTEXT' '## ##(###)',     ' ' 'NO_OUT'  'X', ' ' 'EMPHASIZE' 'C110',  'E' ' ' ' ',
         'S' 'FIELDNAME' 'MATNR',        ' ' 'COLTEXT' '###',           ' ' 'JUST' 'C', 'E' ' ' ' ',
         'S' 'FIELDNAME' 'MAKTX',        ' ' 'COLTEXT' '###',                 'E' ' ' ' ',
         'S' 'FIELDNAME' 'DISPLAY_TEXT', ' ' 'COLTEXT' '###(###)',        ' ' 'NO_OUT'  'X', 'E' ' ' ' ',
         'S' 'FIELDNAME' 'FMENG',        ' ' 'COLTEXT' '### ## ##',      ' ' 'QFIELDNAME' 'MEINS', 'E' ' ' ' ',
         'S' 'FIELDNAME' 'MEINS',        ' ' 'COLTEXT' '## ##',             'E' ' ' ' '.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_pohd (300# ALV ## #### ##)
*&---------------------------------------------------------------------*
FORM set_fcat_pohd CHANGING pt_fcat TYPE lvc_t_fcat.
  " ### ### ### ######
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'ZTB1MM0006'
    CHANGING
      ct_fieldcat      = pt_fcat.

  " ####, ##### ## ### ###
  DELETE pt_fcat WHERE fieldname = 'LVORM' OR
                       fieldname = 'ERNAM' OR fieldname = 'ERDAT' OR
                       fieldname = 'ERZET' OR fieldname = 'AENAM' OR
                       fieldname = 'AEDAT' OR fieldname = 'AEZET'.

*  FIELD-SYMBOLS: <fs> TYPE lvc_s_fcat.
*  LOOP AT pt_fcat ASSIGNING <fs>.
**    "<fs>-
*  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_opti_data (110# ## #### ### ##)
*&---------------------------------------------------------------------*
FORM get_opti_data .
  CLEAR: gt_opti.

  " ##### #### ### ##/## ### ### #### ####
  SELECT * " ### ### #### ## X. ### # # CDS View# ##### #### # O
    FROM zcds_b1_mm_0001( p_bedat = @gs_head-bedat )  "## ## ## ### -> ## ### View# ##
    WHERE ( @gs_head-bpid IS INITIAL OR bpid = @gs_head-bpid ) " BPID# ### ## BPID#, ### ##
    INTO CORRESPONDING FIELDS OF TABLE @gt_opti.
  " #### ### ####(###) ## #### ## ##
  " ### ##(## ##, ### / Fiori## ### ## / ## # # ###)# CDS## ##
  IF sy-subrc <> 0.
    MESSAGE s010(zmcb1) WITH '## ## ###' DISPLAY LIKE 'E'. " ## ### ## ## ## #### ####.
  ELSE.
    " ### ## ###(####)
    LOOP AT gt_opti ASSIGNING FIELD-SYMBOL(<fs_opti>).
      <fs_opti>-textday = '#'.
      <fs_opti>-netusd = <fs_opti>-netpr + <fs_opti>-zoth.
      IF <fs_opti>-zsel = 'X'.
        <fs_opti>-select = icon_okay.
      ENDIF.
    ENDLOOP.
  ENDIF.
  " 3. ###### ALV# ## # ### Refresh
  IF go_alv_pop IS BOUND.
    go_alv_pop->refresh_table_display( ).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form add_selected_data (110# ## ## ### -> 100# ### #### ##)
*&---------------------------------------------------------------------*
FORM add_selected_data  USING  pv_type  TYPE c
                        CHANGING po_alv TYPE REF TO cl_gui_alv_grid
                                 pt_data TYPE INDEX TABLE. " ANY TABLE ## INDEX TABLE# ## READ TABLE## index ## ##

  DATA: lt_rows   TYPE lvc_t_row, " 1. # ## itab, st ## ##
        ls_row    TYPE lvc_s_row, " ## ##(lt, ls)
        lt_cds    TYPE TABLE OF zcds_b1_mm_0001,
        lt_target TYPE TABLE OF zeb1_mm_matnr, " #### ###
        lv_tabix  TYPE sy-tabix, " ## ### ##(# 10#)# #### ##
        lv_werks  TYPE werks_d. " 2-1. ### ## (## ####)
  FIELD-SYMBOLS: <ls_data>  TYPE any,
                 <lv_matnr> TYPE any, " <ls_data>-matnr, add_ukurs
                 <lv_ukurs> TYPE any. " ## ### ## (## #### fs ##)

  " 2-2. ### ### ####
  GET PARAMETER ID 'WRK' FIELD lv_werks. " ## #### #### #### ##### ###
  IF lv_werks IS INITIAL.
    lv_werks = '1000'. " ## ### 1000 ##
  ENDIF.

  " 3. ## ALV## ### ## # ####
  CALL METHOD po_alv->get_selected_rows
    IMPORTING
      et_index_rows = lt_rows.

  IF lt_rows IS INITIAL. " #### ## ### #### # ### ####
    MESSAGE s013(zmcb1) DISPLAY LIKE 'W'. " ### #### ### ## ### ###
    RETURN. " ### ## ## # ## ### #####.
  ENDIF.

  " 4. ### ### gt_item = #### ### #### ### ####
  LOOP AT lt_rows INTO ls_row.
    " gt_opti# CDS View## ### ## ###(itab)
    READ TABLE pt_data ASSIGNING <ls_data> INDEX ls_row-index.
    IF sy-subrc <> 0. CONTINUE. ENDIF.

    " ## ls_data-matnr ## ##, matnr ### ## #### ##
    ASSIGN COMPONENT 'MATNR' OF STRUCTURE <ls_data> TO <lv_matnr>.
    IF sy-subrc <> 0. CONTINUE. ENDIF.

    " ### ### KRW ##(USD ## * ##)# 0# #### ##
    IF pv_type = 'O'. " CDS View ### ##### '### ##' ### ## 0 # #.
      ASSIGN COMPONENT 'ADD_UKURS' OF STRUCTURE <ls_data> TO <lv_ukurs>.
      " ## ### ### ## CONTINUE# ##, ## #(=## ##)## ###
      IF sy-subrc = 0 AND <lv_ukurs> = 0.
        MESSAGE i407(zmcb1) WITH <lv_matnr> '##: ' '###'. " (####) ##: ### ## ### ### #####
        CONTINUE.
      ENDIF.
    ENDIF.
    APPEND <lv_matnr> TO lt_target.
  ENDLOOP.

  " 4-1. #### ## / ##### ## ### CDS View## ##
  SELECT fin_netpr_krw, mwskz, meins, matnr
    FROM zcds_b1_mm_0001( p_bedat = @gs_head-bedat )
    FOR ALL ENTRIES IN @lt_target
    WHERE bpid  = @gs_head-bpid
      AND matnr = @lt_target-table_line
    INTO CORRESPONDING FIELDS OF TABLE @lt_cds.

  " 4-2. ### #### gt_item# ##
  SORT lt_cds BY matnr.

  LOOP AT lt_target INTO DATA(lv_matnr).
    READ TABLE lt_cds INTO DATA(ls_cds) WITH KEY matnr = lv_matnr BINARY SEARCH. " ## ### ### ##
    IF sy-subrc <> 0.
      MESSAGE i109(zmcb1) WITH lv_matnr. CONTINUE. " lv_matnr ### ## ### ####
    ENDIF.

    " 4-3. ##### ## ### #### ##, ### ## ### ##
    READ TABLE gt_item INTO gs_item WITH KEY matnr = ''. " ##### ## # ## ##
    lv_tabix = sy-tabix.

    gs_item-matnr = ls_cds-matnr.
    gs_item-werks = lv_werks.
    gs_item-meins = ls_cds-meins.

    IF ls_cds-fin_netpr_krw IS NOT INITIAL AND gv_mode = 'U'.
      CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
        EXPORTING
          currency    = 'KRW'
          idoc_amount = ls_cds-fin_netpr_krw  " #: 102644
        IMPORTING
          sap_amount  = gs_item-netpr.
    ELSE.
      gs_item-netpr = ls_cds-fin_netpr_krw.
    ENDIF.

    gs_item-waersk = 'KRW'.
    gs_item-mwskz = ls_cds-mwskz.

    IF lv_tabix > 0.
      " 4-4. # ## ### # ### #### ##(##### ##)
      MODIFY gt_item FROM gs_item INDEX lv_tabix.
    ELSE.
      APPEND gs_item TO gt_item. " ## ## ### #### ##
    ENDIF.
  ENDLOOP.

  " 5. ## ## ALV #### (## alv# ### ## alv ### refresh)
  go_alv->refresh_table_display( ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_data_changed (100# ### ALV ### ## # ##)
*&---------------------------------------------------------------------*
FORM handle_data_changed USING pr_data_changed TYPE REF TO cl_alv_changed_data_protocol.
  DATA: ls_mod_cell TYPE lvc_s_modi, " ### # ### ## ###
        lv_menge    TYPE menge_d, " # ### ###, #### #### ## #### ##
        lv_netpr    TYPE netpr,
        lv_dmbtr    TYPE dmbtr,
        lv_eindt    TYPE eindt,
        lv_slfdt    TYPE slfdt,
        lv_zvlead   TYPE i,
        lv_matnr    TYPE matnr.

  LOOP AT pr_data_changed->mt_good_cells INTO ls_mod_cell WHERE value IS NOT INITIAL. " #### ## ### ###
    " ## ### ## #### ## ### ## ###. row_id# gt_item# ### ##
    READ TABLE gt_item ASSIGNING FIELD-SYMBOL(<fs_item>) INDEX ls_mod_cell-row_id.
    CHECK sy-subrc = 0. " # ### ## ### # #

    CASE ls_mod_cell-fieldname. " ## #### ###### ## ##
        " #1. ##### ### #####
      WHEN 'MATNR'.
        " 1) #### ### #### # ####
        pr_data_changed->get_cell_value( EXPORTING i_row_id = ls_mod_cell-row_id i_fieldname = 'MATNR' IMPORTING e_value = lv_matnr ).

        IF lv_matnr IS NOT INITIAL.
          " 2) ##### ### ## ## ## - #### ####
          SELECT SINGLE fin_netpr_krw, mwskz, meins " -> (## ###) ##, (##### ####) ####, (### ####) #### ### # ##
            FROM zcds_b1_mm_0001( p_bedat = @gs_head-bedat ) " #### ##### ##
            INTO ( @<fs_item>-netpr, @<fs_item>-mwskz, @<fs_item>-meins )
            WHERE bpid  = @gs_head-bpid
              AND matnr = @lv_matnr. " #######, ####, ##### ## ### CDS## 1# #### ## !

          IF sy-subrc = 0.
            " 2-1) ### ####(KRW), ####, ##### #### ### #####
            <fs_item>-waersk = 'KRW'. " ### #### ### ####
            IF gv_mode = 'U'.
              CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
                EXPORTING
                  currency    = <fs_item>-waersk
                  idoc_amount = <fs_item>-netpr " ### ### ## ### ##
                IMPORTING
                  sap_amount  = <fs_item>-netpr.
            ENDIF.
            pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'NETPR'  i_value = <fs_item>-netpr ).
            pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'MWSKZ'  i_value = <fs_item>-mwskz ).
            pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'MEINS'  i_value = <fs_item>-meins ).
            pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'WAERSK' i_value = 'KRW' ).
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

        " #2. ### ##### (### ### ### ### #)
      WHEN 'MENGE' OR 'NETPR'. "### ### ### ## ## ## ### ###
        pr_data_changed->get_cell_value( EXPORTING i_row_id = ls_mod_cell-row_id i_fieldname = 'MENGE' IMPORTING e_value = lv_menge ).
        pr_data_changed->get_cell_value( EXPORTING i_row_id = ls_mod_cell-row_id i_fieldname = 'NETPR' IMPORTING e_value = lv_netpr ).

        lv_dmbtr = lv_menge * lv_netpr. " ### #### ####(##x##) #### ##

*        pr_data_changed->modify_cell( EXPORTING i_row_id = ls_mod_cell-row_id i_fieldname = 'MENGE' i_value = lv_menge ).
        pr_data_changed->modify_cell( EXPORTING i_row_id = ls_mod_cell-row_id i_fieldname = 'DMBTR' i_value = lv_dmbtr ).

        " ### ###(+###) ### ## ##### ###
        <fs_item>-menge = lv_menge.
        <fs_item>-netpr = lv_netpr.
        <fs_item>-dmbtr = lv_dmbtr.

        " #3. ##### ## #
      WHEN 'EINDT'. " ## #### ### ### ###
        pr_data_changed->get_cell_value( EXPORTING i_row_id = ls_mod_cell-row_id i_fieldname = 'EINDT' IMPORTING e_value = lv_eindt ).

        " ##### ##### ## #### ## (## ##### #### ##### ## ##### 1~2# ##)
        SELECT SINGLE zvlead FROM ztb1mm0004 INTO @lv_zvlead WHERE bpid = @gs_head-bpid.
        lv_slfdt = lv_eindt + lv_zvlead.

        " ### #### #### ####
        pr_data_changed->modify_cell( EXPORTING i_row_id = ls_mod_cell-row_id i_fieldname = 'SLFDT' i_value = lv_slfdt ).
        " ### ###(###, ###) ## itab# ####
        <fs_item>-eindt = lv_eindt.
        <fs_item>-slfdt = lv_slfdt.

        " #4. #### #### ## #
      WHEN 'WERKS' OR 'LGORT'.
        " 1) ## ## #### #### ## ###
        pr_data_changed->get_cell_value( EXPORTING i_row_id = ls_mod_cell-row_id i_fieldname = 'WERKS' IMPORTING e_value = <fs_item>-werks ).
        pr_data_changed->get_cell_value( EXPORTING i_row_id = ls_mod_cell-row_id i_fieldname = 'LGORT' IMPORTING e_value = <fs_item>-lgort ).

        " 2) # # ## ## ## ### ### ##
        IF <fs_item>-werks IS NOT INITIAL AND <fs_item>-lgort IS NOT INITIAL.
          SELECT SINGLE werks, lgort
            FROM ztb1mm0000
            WHERE werks = @<fs_item>-werks
              AND lgort = @<fs_item>-lgort
            INTO @DATA(lv_check).

          IF sy-subrc <> 0.
            " 3) #### ## #### ## ##
            gv_show_msg = abap_true.
            gv_msg_matnr = |{ <fs_item>-werks }/{ <fs_item>-lgort }|. " #### ### '###/####' ### ### ####

            " ## ### ### (### ALV ## ### ## ####### #)
            <fs_item>-werks = ''.
            <fs_item>-lgort = ''.
            pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'WERKS' i_value = '' ).
            pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'LGORT' i_value = '' ).
          ENDIF.
        ENDIF.
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
*& FORM clear_item_row (100# ### ALV ### ### ###)
*&---------------------------------------------------------------------*
FORM clear_item_row USING pr_data_changed TYPE REF TO cl_alv_changed_data_protocol
                          pv_row_id       TYPE lvc_s_modi-row_id
                          p_fs_item       STRUCTURE gs_item.

  " itab ### & ALV ## ###
  CLEAR: p_fs_item-meins, p_fs_item-netpr, p_fs_item-waersk, p_fs_item-mwskz, p_fs_item-menge, p_fs_item-dmbtr.

  pr_data_changed->modify_cell( i_row_id = pv_row_id i_fieldname = 'MEINS'  i_value = '' ). " ##### # ##
  pr_data_changed->modify_cell( i_row_id = pv_row_id i_fieldname = 'NETPR'  i_value = 0 ).
  pr_data_changed->modify_cell( i_row_id = pv_row_id i_fieldname = 'WAERSK' i_value = '' ).
  pr_data_changed->modify_cell( i_row_id = pv_row_id i_fieldname = 'MWSKZ'  i_value = '' ).
  pr_data_changed->modify_cell( i_row_id = pv_row_id i_fieldname = 'MENGE'  i_value = 0 ).
  pr_data_changed->modify_cell( i_row_id = pv_row_id i_fieldname = 'DMBTR'  i_value = 0 ).
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
    IF screen-name = 'GS_HEAD-BEDAT' OR "###
           screen-name = 'GS_HEAD-BSART' OR " ####
           screen-name = 'GS_HEAD-EKORG' OR " ####
           screen-name = 'GS_HEAD-EKGRP' OR " ####
           screen-name = 'GS_HEAD-ZTERM' OR " ####
           screen-name = 'GS_HEAD-INCO1'. " ####
      " #### ###(lv_editable=false) input# 0##, ### 1# ##
      screen-input = COND #( WHEN lv_editable = abap_true THEN 1 ELSE 0 ).
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& FORM check_data_before_save (100# ### ## ### ### ##)
*&---------------------------------------------------------------------*
FORM check_data_before_save CHANGING cv_subrc TYPE sysubrc.
  DATA: lv_error_cnt   TYPE i VALUE 0, " ## #### ### ALV ## #### #### ##
        lo_protocol    TYPE REF TO cl_alv_changed_data_protocol,
        lv_item_exists TYPE abap_bool. " #### #### ### ###
  IF gs_vend IS INITIAL.
    MESSAGE '#### ## ##(##)# #####' TYPE 'S' DISPLAY LIKE 'E'.
    cv_subrc = 4.
    RETURN. " ## ### ### # BPNM# #### ##### ## -> ## ### ##### # #.
  ENDIF.

  CREATE OBJECT lo_protocol. " ## #### ## ## (### ###)
  cv_subrc = 0.

  " #1. ## ##
  " ## 1) ##### ### ## ## ##
  IF gv_mode <> 'U'. " ## ### ## # = ### ## ## ##
    IF gs_head-bedat < sy-datum AND gs_head-bedat IS NOT INITIAL.
      PERFORM check_and_add_protocol USING gs_head-bedat 'E' '012' '##### ##' 'GS_HEAD-BEDAT' 0 lo_protocol CHANGING lv_error_cnt.
    ELSEIF gs_head-bedat IS INITIAL. " ## ## ###. (#### #### ##### ###, ## #### ## #### ### #### ### #### #)
      PERFORM check_and_add_protocol USING gs_head-bedat 'E' '014' '####' 'GS_HEAD-BEDAT' 0 lo_protocol CHANGING lv_error_cnt.
    ENDIF.
  ENDIF.
  " ## 2) ####, ####, ####, ####, #### ## #### ##
  PERFORM check_and_add_protocol USING gs_head-bpid 'E' '014' '####' 'GS_HEAD-BPID' 0 lo_protocol CHANGING lv_error_cnt.
  PERFORM check_and_add_protocol USING gs_head-bsart 'E' '014' '## ##' 'GS_HEAD-BSART' 0 lo_protocol CHANGING lv_error_cnt.
  PERFORM check_and_add_protocol USING gs_head-ekorg 'E' '014' '## ##' 'GS_HEAD-EKORG' 0 lo_protocol CHANGING lv_error_cnt.
  PERFORM check_and_add_protocol USING gs_head-ekgrp 'E' '014' '## ##' 'GS_HEAD-EKGRP' 0 lo_protocol CHANGING lv_error_cnt.
  PERFORM check_and_add_protocol USING gs_head-bukrs 'E' '014' '## ##' 'GS_HEAD-BUKRS' 0 lo_protocol CHANGING lv_error_cnt.
  PERFORM check_and_add_protocol USING gs_head-zterm 'E' '014' '## ##' 'GS_HEAD-ZTERM' 0 lo_protocol CHANGING lv_error_cnt.
  PERFORM check_and_add_protocol USING gs_head-inco1 'E' '014' '####' 'GS_HEAD-INCO1' 0 lo_protocol CHANGING lv_error_cnt.

  " #2. ### ### ##
  LOOP AT gt_item INTO DATA(ls_item).
    DATA(lv_tabix) = sy-tabix.

    " ######, ###, ####, ## # #### ###### #### - ## ### 10## ## ### ## ##
    IF ls_item-matnr IS NOT INITIAL OR ls_item-werks IS NOT INITIAL
        OR ls_item-lgort IS NOT INITIAL OR ls_item-menge IS NOT INITIAL.
      lv_item_exists = abap_true. " #### ### ## ### ##### (## ### ## ##)

      " ## 1) #### ### ## (## ##, ##t ## ##)
      PERFORM check_and_add_protocol USING ls_item-matnr 'E' '014' '####' 'MATNR' lv_tabix lo_protocol CHANGING lv_error_cnt.
      IF ls_item-matnr IS NOT INITIAL. " ### ###, ## ### ##### ### ## ##### ##
        SELECT SINGLE matnr
        FROM zcds_b1_mm_0001(  p_bedat = @gs_head-bedat )
          WHERE bpid  = @gs_head-bpid AND matnr = @ls_item-matnr
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

      " ## 4) ###### ###### ###(####) ##
      IF ls_item-eindt IS NOT INITIAL AND ls_item-eindt < gs_head-bedat.
        PERFORM check_and_add_protocol USING '' 'E' '110' '' 'EINDT' lv_tabix lo_protocol CHANGING lv_error_cnt.
      ELSE.
        " ## ## ## ### ## ## ### ##
        PERFORM check_and_add_protocol USING ls_item-eindt 'E' '014' '#####' 'EINDT' lv_tabix lo_protocol CHANGING lv_error_cnt.
      ENDIF.
    ENDIF.
  ENDLOOP. " ## ### ## ## # ##### ## ## ### #
  " #, ### ## #### ## ## ## ### ### ##
  IF lv_item_exists = abap_false.
    PERFORM check_and_add_protocol USING '' 'E' '000' '### ##' 'MANDT' lv_tabix lo_protocol CHANGING lv_error_cnt.
  ENDIF.

  " #3. ### #### ### ## ###
  IF lv_error_cnt > 0.
    lo_protocol->display_protocol(
*      i_container        =                  " Container (Optional)
*      i_display_toolbar  =                  " Display Toolbar
i_optimize_columns = abap_true " ### ### ## ##
).
    cv_subrc = 4.
  ELSE. " ## ## ## ## ### ###
    MESSAGE s021(zmcb1). " ### #######
    cv_subrc = 0.
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

  DATA: lv_title TYPE string VALUE '## ##',
        lv_text  TYPE string,
        lv_count TYPE i,
        lv_total TYPE dmbtr.

  " 1. ### ### ## ##
  LOOP AT gt_item INTO DATA(ls_item) WHERE matnr IS NOT INITIAL.
    lv_count = lv_count + 1.
    IF gv_mode = 'U'.
      DATA: lv_idoc_temp     TYPE bapi_msg, " ### ##(##)
            lv_converted_num TYPE zeb1_mm_dmbtr. " QUSGH

      CALL FUNCTION 'CURRENCY_AMOUNT_SAP_TO_IDOC'
        EXPORTING
          currency    = ls_item-waersk
          sap_amount  = ls_item-dmbtr
        IMPORTING
          idoc_amount = lv_idoc_temp. " ## ### ##
      lv_converted_num = lv_idoc_temp. " ### ## # ### ## ###
      lv_total = lv_total + lv_converted_num.
    ELSE.
      lv_total = lv_total + ls_item-dmbtr.
    ENDIF.

  ENDLOOP.
  " 2. ## ### ## (#: #### USU## # 3#, # ## 500,000 KRW# ########?)
  IF gv_mode = 'U'.
    lv_text = |#### [{ gv_bpnm }]##\n| &&
          |# { lv_count }#,\n ##: { lv_total NUMBER = USER } KRW#\n| &&
          |########? ## # #### #####|.
  ELSE.
    lv_text = |#### [{ gv_bpnm }]##\n| &&
              |# { lv_count }#,\n ##: { lv_total NUMBER = USER } KRW#\n| &&
              |########?|.
  ENDIF.
  CLEAR cv_answer.

  " 3. ## ##
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = lv_title
      text_question         = lv_text
      text_button_1         = '#'
      text_button_2         = '###'
      display_cancel_button = ' ' " ## '##' ### #### ## ### ###
    IMPORTING
      answer                = cv_answer
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.
  " ## ##
  cv_answer = COND #( WHEN cv_answer = '1' THEN 'J' ELSE 'N' ).

ENDFORM.
*&---------------------------------------------------------------------*
*& FORM save_po_data (#### ## ### ## ### ##)
*&---------------------------------------------------------------------*
FORM save_po_data.
  DATA: lv_ebeln      LIKE gs_head-ebeln,
        ls_head       TYPE ztb1mm0006,
        lt_item       TYPE TABLE OF ztb1mm0007, " ## ### DB ### ##
        ls_app        TYPE ztb1mm0008,          " ## ###
        lv_appno      TYPE zeb1_mm_zappno,
        ls_item       LIKE LINE OF lt_item,
        lv_tabix      TYPE i,
        lv_subrc      TYPE sy-subrc,
        lt_price_0025 TYPE TABLE OF ztb1mm0025,
        ls_price_0025 TYPE ztb1mm0025.

  " 1. ## ## ## (SNRO## ### ## ###)
  " 4500000136## #### ### lv_ebeln# ##
  PERFORM get_new_po_number CHANGING lv_ebeln.

  IF lv_ebeln IS INITIAL.
    MESSAGE e006(zmcb1) WITH ': #### ## ## ##'. " ## # ### ######
    RETURN.
  ENDIF.

  " 2. ## ### ## (gs_head# ## # ##### # ## ## ##)
  gs_head-ebeln  = lv_ebeln.      " ### ## ##
  gs_head-ernam = sy-uname.
  gs_head-erdat = sy-datum.
  gs_head-erzet = sy-uzeit.
  gs_head-aenam  = sy-uname.
  gs_head-aedat  = sy-datum.
  gs_head-aezet  = sy-uzeit.

  " 3. ### ### ##
  CLEAR lt_item.
  LOOP AT gt_item INTO DATA(ls_screen) WHERE matnr IS NOT INITIAL.
    lv_tabix = lv_tabix + 1.

    " DB ### ## ### ##
    CLEAR ls_item.
    MOVE-CORRESPONDING ls_screen TO ls_item. " #### ### # ## ###

    " 1. ###### & ####
    ls_item-ebeln   = lv_ebeln.         " ### ### ## ##
    ls_item-ebelp = lv_tabix * 10.   " #### (10, 20, 30...)

    " gt_opti# #### ## # CDS(zcds_b1_mm_0001)## ### ## ###.
    READ TABLE gt_opti INTO DATA(ls_o) WITH KEY matnr = ls_screen-matnr.
    IF sy-subrc = 0.
*      DATA: lv_netpr TYPE string,
*            lv_dmbtr TYPE string.

      " 2. KRW ##, ## - ## CDS## ### #### ### ## ###
*      ls_item-netpr = lv_netpr. " KRW# DB ## # 100# #####, ## INSERT ### ## 100# ### #### ## ### ##
*      ls_item-dmbtr = lv_dmbtr. " ###, ### #### ### -> DB ### # ### ## ##(1/100)

      IF ls_screen-waersk = 'KRW'.
        CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
          EXPORTING
            currency    = ls_screen-waersk
            idoc_amount = ls_screen-netpr " ### ### ## ### ##
          IMPORTING
            sap_amount  = ls_item-netpr.

        " # ## ##
        CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
          EXPORTING
            currency    = ls_screen-waersk
            idoc_amount = ls_screen-dmbtr
          IMPORTING
            sap_amount  = ls_item-dmbtr.
      ELSE.
        " KRW# ## ## - # #### ## ## #### #### ## ####
        ls_item-netpr = ls_screen-netpr.
        ls_item-dmbtr = ls_screen-dmbtr.
      ENDIF.
      ls_item-waersk = ls_screen-waersk.

      " 2-2. USD ##, ## -> #### #### ##. CDS## ### ### ##
      ls_item-wrbtr  = ls_o-fin_netpr_usd * ls_screen-menge.
      ls_item-waers  = ls_o-waers.

      " 3. ###### - # ## #### #### ### ### ##
      IF lv_tabix = 1.
        gs_head-knumh = ls_o-knumh.
      ENDIF.

      CLEAR ls_price_0025.
      ls_price_0025-ebeln  = ls_item-ebeln.       " #### ##
      ls_price_0025-ebelp  = ls_item-ebelp.       " #### ##
      ls_price_0025-matnr  = ls_item-matnr.       " ## ##
      ls_price_0025-netusd = ls_o-netusd.         " ## ## ##
      ls_price_0025-waers  = 'USD'.

      ls_price_0025-ernam  = sy-uname.
      ls_price_0025-erdat  = sy-datum.
      ls_price_0025-erzet  = sy-uzeit.
      ls_price_0025-aenam  = sy-uname.
      ls_price_0025-aedat  = sy-datum.
      ls_price_0025-aezet  = sy-uzeit.

      APPEND ls_price_0025 TO lt_price_0025.
    ENDIF.

    " 4. ### ### ##
    ls_item-insmk  = 'A'. " #### (##### ## ##### A)
    ls_item-postat = '1'. " ### ##: ## ##, ## ##

    APPEND ls_item TO lt_item. " DB# ### #### ##
  ENDLOOP.

  " 5. ### ## ## - ##### ##
  call function 'ZFB1CM0001'" ##### ####
    CHANGING
      ct_table = lt_item.

  " 4. ## DB ## (##, ###) - #### #### ROLLBACK##
  MOVE-CORRESPONDING gs_head TO ls_head. " #### ## ### ##
  INSERT ztb1mm0006 FROM ls_head. " ## ###
  IF sy-subrc = 0.
    INSERT ztb1mm0007 FROM TABLE lt_item. " ### ### ## ##

    IF sy-subrc = 0.
      " ## ###(ZTB1MM0008) ### ##
      PERFORM get_new_app_number CHANGING lv_appno.

      " 2. ## ###(ZTB1MM0008) ### ##
      CLEAR ls_app.
      ls_app-zappno = lv_appno.
      ls_app-ebeln  = lv_ebeln.
      ls_app-zappst = '1'.
      ls_app-ernam  = sy-uname.            " ## ##
      ls_app-erdat  = sy-datum.
      ls_app-erzet  = sy-uzeit.
      ls_app-aenam  = sy-uname.
      ls_app-aedat  = sy-datum.
      ls_app-aezet  = sy-uzeit.

      INSERT ztb1mm0008 FROM ls_app.       " ## ### ##

      IF sy-subrc = 0.
        COMMIT WORK. " DB ## ## - ####
        " MESSAGE s104(zmcb1) WITH lv_ebeln . " ## #### ## ## # ##

        "PROCESS FLOW ##(###)
        DATA lv_reqno TYPE zeb1_sd_ref_doc_no.
        DATA lv_docno TYPE zeb1_sd_result_doc_no.

        lv_reqno = CONV char20( ls_head-ebeln ).
        lv_docno = CONV char20( ls_head-ebeln ).

        zcl_b1_process_status=>save(
          EXPORTING
            iv_program_id      = 'SAPMZB1MM0004'
            iv_ref_doc_no      = lv_reqno
            iv_result_doc_no   = lv_docno
            iv_result_doc_type = 'PO'
            iv_status_text     = '## ## ## ## ##'
          EXCEPTIONS
            program_not_found  = 1
            mapping_not_found  = 2
            create_error       = 3
            complete_error     = 4
            OTHERS             = 5
        ).

        IF sy-subrc = 0.
          IF lt_price_0025 IS NOT INITIAL.
            SORT lt_price_0025 BY ebeln ebelp matnr.
            DELETE ADJACENT DUPLICATES FROM lt_price_0025 COMPARING ebeln ebelp matnr.

            INSERT ztb1mm0025 FROM TABLE lt_price_0025.
          ENDIF.

          IF sy-subrc = 0.
            EXPORT gs_head FROM gs_head TO MEMORY ID 'ZPO_DATA'.
            gv_po_ebeln = lv_ebeln.

            " ## ## # ## ## (## ###)
            PERFORM set_screen_after_save.

            IF gv_save_check IS INITIAL.  "## PO ## ## #, ### PO ## #### ##.
              gv_save_check = 'X'.
            ELSE.
              gv_save_check = ''.
            ENDIF.
          ELSE.
            ROLLBACK WORK. "  ### ### ## ## 5
            MESSAGE e006(zmcb1) WITH ': #### ## ## ## ##. ## #####'. " ## # ### ######
          ENDIF.
        ELSE.
          ROLLBACK WORK. "  ### ### ## ## 4
          MESSAGE s026(zmcb1) WITH |PROCESS STATUS ## #| DISPLAY LIKE 'E'.
        ENDIF.
      ELSE.
        ROLLBACK WORK. " ## ### ## ## ## ### ### ## ## 3
        MESSAGE e006(zmcb1) WITH ': ## ### ##'. " ## # ### ######
      ENDIF.
    ELSE.
      ROLLBACK WORK. " ### ## #### ### ### ## ## 2
      MESSAGE e006(zmcb1) WITH ': ### ## ##'. " ## # ### ######
    ENDIF.
  ELSE.
    ROLLBACK WORK. " ## ## #### ### ### ## ## 1
    MESSAGE e006(zmcb1) WITH ': ## ## ##'. " ## # ### ######
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& FORM update_po_data (#### ## ### ## ##)
*&---------------------------------------------------------------------*
FORM update_po_data.
  DATA: ls_head  TYPE ztb1mm0006,
        lt_item  TYPE TABLE OF ztb1mm0007,
        ls_item  LIKE LINE OF lt_item,
        ls_app   TYPE ztb1mm0008,
        lv_appno TYPE zeb1_mm_zappno,
        lv_tabix TYPE i.

  " 1. ## ##/### ### ## ### #### ####
  " (gv_ebeln# ##, ###/###/#### ##)
  gs_head-aenam = sy-uname.
  gs_head-aedat = sy-datum.
  gs_head-aezet = sy-uzeit.

  MOVE-CORRESPONDING gs_head TO ls_head.

  " 2. ## ## ## ### (zappst = 4 ## ##)
  " ## ## ### gs_head# ### ##### ## EBELN## ### #
  UPDATE ztb1mm0008
  SET zappst = '4',       " ## ### ##
       aenam  = @sy-uname, " ###
       aedat  = @sy-datum, " ###
       aezet  = @sy-uzeit  " ####
   WHERE ebeln = @gv_ebeln
     AND lvorm <> 'X' " ## ## # # ####
     AND zappst <> '4'. " ## ## ### ## ## ####

  " 3. ### ## ## ## # ##
  PERFORM get_new_app_number CHANGING lv_appno.
  ls_app-zappno = lv_appno.
  ls_app-ebeln  = gv_ebeln.
  ls_app-zappst = '1'. " ## #### ###
  ls_app-ernam  = sy-uname.
  ls_app-erdat  = sy-datum.
  ls_app-erzet  = sy-uzeit.
  ls_app-aenam  = sy-uname.
  ls_app-aedat  = sy-datum.
  ls_app-aezet  = sy-uzeit.

  " 4. #### ## ## # ## insert
  DELETE FROM ztb1mm0007 WHERE ebeln = gv_ebeln.
  CLEAR: lt_item, lv_tabix.

  LOOP AT gt_item INTO DATA(ls_screen) WHERE matnr IS NOT INITIAL.
    lv_tabix = lv_tabix + 1.
    CLEAR ls_item.

    MOVE-CORRESPONDING ls_screen TO ls_item.

    " ### ## ## ## / #### ## PO ##(## ##) ###.
    ls_item-ebeln = gv_ebeln.
    ls_item-ebelp = lv_tabix * 10.
    ls_item-postat = '1'.
    ls_item-insmk = 'A'.

    " ### ## ##
    IF ls_screen-waersk = 'KRW'.
*      CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP' " ##### ### ### ###(## ##)
*        EXPORTING
*          currency    = ls_screen-waersk
*          idoc_amount = ls_screen-netpr / dmbtr
*        IMPORTING
*          sap_amount  = ls_item-netpr. / dmbtr

      ls_item-netpr = ls_screen-netpr.
      ls_item-dmbtr = ls_screen-dmbtr.
    ENDIF.
    ls_item-waersk = ls_screen-waersk.

    " CDS ## ###(gt_opti) ## # USD ###
    READ TABLE gt_opti INTO DATA(ls_o) WITH KEY matnr = ls_screen-matnr.
    IF sy-subrc = 0.
      ls_item-wrbtr = ls_o-fin_netpr_usd * ls_screen-menge.
      ls_item-waers = ls_o-waers.

      IF lv_tabix = 1. " ###### - # ## #### #### ### ### ##
        ls_head-knumh = ls_o-knumh.
      ENDIF.
    ENDIF.
    IF ls_item-erdat IS INITIAL. " ## ##(## ### # ##)# ###
      ls_item-ernam = sy-uname. " ### ### ### #### ## ### ##
      ls_item-erdat = sy-datum.
      ls_item-erzet = sy-uzeit.
    ENDIF.
    " #### ##### ## ### ##
    ls_item-aenam = sy-uname.
    ls_item-aedat = sy-datum.
    ls_item-aezet = sy-uzeit.

    APPEND ls_item TO lt_item.
  ENDLOOP.

  " 5. DB ##
  " 5-1. ## ## (MODIFY ## - ### Update, ### Insert)
  MODIFY ztb1mm0006 FROM ls_head.
  IF sy-subrc = 0.
    " 5-2. ### ## (## ### ## # ## INSERT)
    INSERT ztb1mm0007 FROM TABLE lt_item.
    IF sy-subrc = 0.
      " 5-3. ## ## ##
      INSERT ztb1mm0008 FROM ls_app.
      IF sy-subrc = 0.
        COMMIT WORK.
        gv_save_check = 'X'. " ##### ###


        DATA(lv_msg_cnt) = |{ lv_tabix }|. " # ##### ### ### ###
        " MESSAGE s005(zmcb1). " ### ####### ##
        MESSAGE s115(zmcb1) WITH lv_msg_cnt '##'. " ### ### ######, #### #######
      ELSE.
        ROLLBACK WORK. . " #### ## #### ### ### ## ## 3
        MESSAGE e006(zmcb1) WITH ': ## ## ## ##'.
      ENDIF.
    ELSE.
      ROLLBACK WORK. . " ### ## #### ### ### ## ## 2
      MESSAGE e006(zmcb1) WITH ': ### ## ##'.
    ENDIF.
  ELSE.
    ROLLBACK WORK. . " ## ## #### ### ### ## ## 1
    MESSAGE e006(zmcb1) WITH ': ## ## ##'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_new_po_number (#### ## ##)
*&---------------------------------------------------------------------*
FORM get_new_po_number CHANGING cv_ebeln.
  DATA: lv_number TYPE nriv-nrlevel. " ### ### ### ## ## ##

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr            = '01'            " SNRO## ## Interval ##
      object                 = 'ZNRB1MM01'     " Number Range ##
    IMPORTING
      number                 = lv_number       " ### ## (45000000001 ~ 4500009999)
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
    " 4500000136 ## ### 10## ### ### ###
    cv_ebeln = |{ lv_number ALPHA = IN }|.
  ELSE.
    " ## ## # ##
    MESSAGE e015(zmcb1).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_new_app_number (#### ## ##)
*&---------------------------------------------------------------------*
FORM get_new_app_number CHANGING cv_zappno.
  DATA: lv_number TYPE nriv-nrlevel. " ### ### ### ## ## ##

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr            = '01'            " SNRO## ## Interval ##
      object                 = 'ZNRB1MM06'     " Number Range ##
    IMPORTING
      number                 = lv_number       " ### ## (45000000001 ~ 4500009999)
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
    " ### ##(0000154)# 7## ### ### ## APP# ## 10## ##
    DATA(lv_temp) = |{ lv_number ALPHA = OUT }|. " ## 0# ### -> ## 7### ####
    cv_zappno = |APP{ lv_temp ALPHA = IN WIDTH = 7 }|. " APP ###
  ELSE.
    " ## ## # ##
    MESSAGE e015(zmcb1).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_screen_after_save (#### ## ## ## ##)
*&---------------------------------------------------------------------*
FORM set_screen_after_save.
  " 1. ## ### ### (## ## # ##)
  PERFORM clear_header_data.
  " 2. ### ### ### ###
  REFRESH gt_item.
  " 3. ALV ## ###
  " #### ### # # ## #### ### ## ###### ## ###
  PERFORM set_init_item_rows.
  " 4. ALV ####
  IF go_alv IS BOUND.
    PERFORM refresh_alv USING gs_stable CHANGING go_alv.
  ENDIF.
  " 5. ## ## ## (#### #### ## ## #### ##)
  PERFORM control_header_screen.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_CHART_DATA (## ## ### ####)
*&---------------------------------------------------------------------*
FORM get_chart_data.
  " ## # ## (20240520 -> 05)
  gv_month = sy-datum+4(2).

  " ## ## = bomve # ####
  IF gv_month BETWEEN '03' AND '05'.
    gv_season = 'SPRG'.
  ELSEIF gv_month BETWEEN '06' AND '08'.
    gv_season = 'SUMR'.
  ELSEIF gv_month BETWEEN '09' AND '11'.
    gv_season = 'FALL'.
  ELSE.
    gv_season = 'WNTR'.
  ENDIF.

  " ### ### ## ## ### ##(bom)
  SELECT a~matnr, b~maktx, a~fmeng, a~meins
      FROM ztb1pp0003 AS a " pp bom(##) ###
      LEFT OUTER JOIN ztb1mm0002 AS b ON a~matnr = b~matnr " ## ### ###
                               AND b~spras = '3' " @sy-langu " ### ### ### ###->## ### ###
        WHERE a~bomve = @gv_season " 4, 5## bomve = 'SPRG'
          AND fmeng     > 0         " ### ### ### ### # # ##
          AND a~stlnr IN ( SELECT stlnr " pp bom item ####:
                               FROM ztb1pp0003 " ##(-)# ## ## ## bom ## (+)# ### ### #### ##.
                              WHERE matnr = @gv_crude " ## ### ### # ##
                                AND fmeng < 0
                                AND bomve = @gv_season )
        INTO CORRESPONDING FIELDS OF TABLE @gt_bom.

  IF sy-subrc = 0 AND gt_bom IS NOT INITIAL.
    gv_chart_show = 'X'. " ### ### ### ##
    " ##### #### ## #### ### ## ### ##
    LOOP AT gt_bom ASSIGNING FIELD-SYMBOL(<fs_bom>).
      <fs_bom>-display_text = |{ <fs_bom>-maktx } ({ <fs_bom>-matnr })|.
    ENDLOOP.
  ELSE.
    CLEAR gv_chart_show. " ### ### ##
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_CHART (110# ##### ## ###)
*&---------------------------------------------------------------------*
FORM display_chart.

  DATA: lo_ixml         TYPE REF TO if_ixml,
        lo_ixml_doc     TYPE REF TO if_ixml_document,
        lo_ixml_sf      TYPE REF TO if_ixml_stream_factory,
        lo_ixml_ostream TYPE REF TO if_ixml_ostream,
        lo_encoding     TYPE REF TO if_ixml_encoding,
        lo_chartdata    TYPE REF TO if_ixml_element,
        lo_categories   TYPE REF TO if_ixml_element,
        lo_category     TYPE REF TO if_ixml_element,
        lo_series       TYPE REF TO if_ixml_element,
        lo_point        TYPE REF TO if_ixml_element,
        lo_value        TYPE REF TO if_ixml_element,
        lv_xstring      TYPE xstring,
        lv_val_str      TYPE string.

  " ### ## ## # ### ## ## ## ### ##
  DATA: lo_title     TYPE REF TO if_ixml_element,
        lo_title_txt TYPE REF TO if_ixml_element.

  lo_ixml     = cl_ixml=>create( ). " IXML ## ##
  lo_ixml_doc = lo_ixml->create_document( ).

  lo_encoding = lo_ixml->create_encoding( character_set = 'utf-8' byte_order = 0 ).
  lo_ixml_doc->set_encoding( lo_encoding ). " ## ## ####
  lo_chartdata = lo_ixml_doc->create_simple_element( name = 'ChartData' parent = lo_ixml_doc ).

*  " ### ###
*  lo_title = lo_ixml_doc->create_simple_element( name = 'Title' parent = lo_chartdata ).
*  lo_title_txt = lo_ixml_doc->create_simple_element( name = 'Text' parent = lo_title ).
*  lo_title_txt->if_ixml_node~set_value( '## ## # BOM ## ##' ).

  lo_categories = lo_ixml_doc->create_simple_element( name = 'Categories' parent = lo_chartdata ).

  " itab(pp# bom ###)## ###(## > 0)# ### X# ## ###
  LOOP AT gt_bom INTO gs_bom WHERE fmeng > 0.
    lo_category = lo_ixml_doc->create_simple_element( name = 'Category' parent = lo_categories ).
    lo_category->if_ixml_node~set_value( |{ gs_bom-display_text }| ). " LPG-200, GAS-200 #
  ENDLOOP.
  " <Series> Y# ##
  lo_series = lo_ixml_doc->create_simple_element( name = 'Series' parent = lo_chartdata ).
  lo_series->set_attribute( name = 'label' value = '## ##' ).

  LOOP AT gt_bom INTO gs_bom WHERE fmeng > 0.
    lo_point = lo_ixml_doc->create_simple_element( name = 'Point' parent = lo_series ).
    lo_value = lo_ixml_doc->create_simple_element( name = 'Value' parent = lo_point ).

    lv_val_str = |{ gs_bom-fmeng }|. " ##(##-27.40 #)# ### ##
    lo_value->if_ixml_node~set_value( lv_val_str ).
  ENDLOOP.
  " ###...
  lo_ixml_sf = lo_ixml->create_stream_factory( ).
  lo_ixml_ostream = lo_ixml_sf->create_ostream_xstring( lv_xstring ).
  lo_ixml_doc->render( lo_ixml_ostream ).
  " ### ##
  IF go_chart IS BOUND. " ## ## ###### ### ##

    go_chart->set_data( xdata = lv_xstring ).
    go_chart->render( ).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_CHART_DATA_ALL (130# ## ## ### ####)
*&---------------------------------------------------------------------*
FORM get_chart_data_all.
  DATA: lt_matnr_range TYPE RANGE OF matnr,
        ls_matnr_range LIKE LINE OF lt_matnr_range.

  " ### ## ##: (-)# ## #### ### ## ##### ##
  lt_matnr_range = VALUE #( ( sign = 'I' option = 'EQ' low = 'WTI-100' )
                            ( sign = 'I' option = 'EQ' low = 'DUBAI-100' )
                            ( sign = 'I' option = 'EQ' low = 'MAYA-100' ) ).
  " ### ## ### #### ###(gv_season, gv_month ##)

  " ## ## ### ##, ### ## ## ### ##(bom)
  SELECT a~matnr, b~maktx, a~fmeng, a~meins, a~stlnr, a~bomve
      FROM ztb1pp0003 AS a " pp bom(##) ###
      LEFT OUTER JOIN ztb1mm0002 AS b ON a~matnr = b~matnr " ## ### ###
                               AND b~spras = '3' " @sy-langu " ### ### ### ###->## ### ###
        WHERE a~bomve = @gv_season " 4, 5## bomve = 'SPRG'
          AND fmeng     > 0         " ### ### ### ### # # ##
          AND a~stlnr IN ( SELECT stlnr " pp bom item ####:
                               FROM ztb1pp0003 " ##(-)# ## ## ## bom ## (+)# ### ### #### ##.
                              WHERE matnr IN @lt_matnr_range " ## ### ##
                                AND fmeng < 0
                                AND bomve = @gv_season )
        INTO CORRESPONDING FIELDS OF TABLE @gt_bom_all.

  IF sy-subrc = 0 AND gt_bom_all IS NOT INITIAL.
    gv_chart_show_all = 'X'. " ### ### ### ##

    LOOP AT gt_bom_all ASSIGNING FIELD-SYMBOL(<fs_bom>).
      SELECT SINGLE a~matnr, b~maktx "
      FROM ztb1pp0003 AS a
      LEFT OUTER JOIN ztb1mm0002 AS b ON a~matnr = b~matnr AND b~spras = '3'
      INTO (@<fs_bom>-crude, @<fs_bom>-crude_maktx)
     WHERE a~stlnr = @<fs_bom>-stlnr
       AND a~fmeng < 0
       AND a~bomve = @<fs_bom>-bomve.

      " ####(###) #### ### ## ### ## (#### ##)
      <fs_bom>-crude_text  = |{ <fs_bom>-crude } ({ <fs_bom>-crude_maktx })|.
      <fs_bom>-display_text = |{ <fs_bom>-maktx } ({ <fs_bom>-matnr })|.
    ENDLOOP.
  ELSE.
    CLEAR gv_chart_show_all. " ### ### ##
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_CHART_ALL (130# ##### ## ###)
*&---------------------------------------------------------------------*
FORM display_chart_all.

  DATA: lo_ixml         TYPE REF TO if_ixml,
        lo_ixml_doc     TYPE REF TO if_ixml_document,
        lo_ixml_sf      TYPE REF TO if_ixml_stream_factory,
        lo_ixml_ostream TYPE REF TO if_ixml_ostream,
        lo_encoding     TYPE REF TO if_ixml_encoding,

        " ### #### ## ##
        lo_title        TYPE REF TO if_ixml_element,
        lo_title_txt    TYPE REF TO if_ixml_element,

        lo_chartdata    TYPE REF TO if_ixml_element,
        lo_categories   TYPE REF TO if_ixml_element,
        lo_category     TYPE REF TO if_ixml_element,
        lo_series       TYPE REF TO if_ixml_element,
        lo_point        TYPE REF TO if_ixml_element,
        lo_value        TYPE REF TO if_ixml_element,
        lv_xstring      TYPE xstring,
        lt_crude        TYPE string_table. " value ### # ## #### ## ######
  DATA: BEGIN OF  ls_prod,
          matnr        TYPE zeb1_mm_matnr, " ###
          display_text LIKE gs_bom_all-display_text, " #####(collect ##) ### ## ### ##
        END OF  ls_prod,
        lt_products LIKE TABLE OF  ls_prod.

  lo_ixml         = cl_ixml=>create( ). " IXML ## ##
  lo_ixml_doc = lo_ixml->create_document( ).

  lo_encoding = lo_ixml->create_encoding( character_set = 'utf-8' byte_order = 0 ).
  lo_ixml_doc->set_encoding( lo_encoding ). " ## ## ####

  lo_chartdata = lo_ixml_doc->create_simple_element( name = 'ChartData' parent = lo_ixml_doc ). " ### # ##

  lo_title = lo_ixml_doc->create_simple_element( name = 'Title' parent = lo_chartdata ).
  lo_title_txt = lo_ixml_doc->create_simple_element( name = 'Text' parent = lo_title ).

  " [SPRG] ## ## ## ## ##
  lo_title_txt->if_ixml_node~set_value( |[{ gv_season }] ## ## BOM ## ## ##| ).

  lo_categories = lo_ixml_doc->create_simple_element( name = 'Categories' parent = lo_chartdata ).
  lt_crude = VALUE #( ( `WTI-100` ) ( `DUBAI-100` ) ( `MAYA-100` ) ).

  LOOP AT lt_crude INTO DATA(lv_crude). " ## #### X# ###
    lo_category = lo_ixml_doc->create_simple_element( name = 'Category' parent = lo_categories ).
    lo_category->if_ixml_node~set_value( lv_crude ).
  ENDLOOP.

  " ##### ### Series ### - y#
  LOOP AT gt_bom_all INTO DATA(ls_temp). " ## ### ### ### ###
    ls_prod-matnr = ls_temp-matnr.
    ls_prod-display_text = ls_temp-display_text.
    COLLECT ls_prod INTO lt_products. " collect ##(loop+append ## ## - ### ## ##(18#x 6#o) ## # ##
  ENDLOOP.

  LOOP AT lt_products INTO ls_prod. " ### ### ### ##(Series) ###
    lo_series = lo_ixml_doc->create_simple_element( name = 'Series' parent = lo_chartdata ).
    lo_series->set_attribute( name = 'label' value = |{ ls_prod-display_text }| ).

    " X# ## 3# ### ### ## #### ### ### ##
    LOOP AT lt_crude INTO lv_crude.
      lo_point = lo_ixml_doc->create_simple_element( name = 'Point' parent = lo_series ).

      " ## ##### ######## #### ##### ##
      READ TABLE gt_bom_all INTO DATA(ls_data)
           WITH KEY matnr = ls_prod-matnr  " ### ####
                    crude = lv_crude.      " ## ####

      IF sy-subrc = 0.
        lo_value = lo_ixml_doc->create_simple_element( name = 'Value' parent = lo_point ).
        lo_value->if_ixml_node~set_value( |{ ls_data-fmeng }| ). " ##(##)# ### ##
      ELSE.
        lo_value = lo_ixml_doc->create_simple_element( name = 'Value' parent = lo_point ).
        lo_value->if_ixml_node~set_value( '0' ).
      ENDIF.
    ENDLOOP.
  ENDLOOP.

  " ### + ###### / Stacked ### ##
  lo_ixml_sf = lo_ixml->create_stream_factory( ).
  lo_ixml_ostream = lo_ixml_sf->create_ostream_xstring( lv_xstring ).
  lo_ixml_doc->render( lo_ixml_ostream ).

*  " ## ### ###### (### ## ##)
*  go_chartall->set_customizing( xdata = cl_abap_codepage=>convert_to(
*          |<Chart><ChartElements><ChartType Name='Columns'>| &&
*          |<Property Name='Stacked' Value='false'/>| && " ### ## false ##
*          |</ChartType></ChartElements></Chart>| ) ).

  " ### ## - ## #### ##.
  IF go_chartall IS BOUND.
    go_chartall->set_data( xdata = lv_xstring ).
    go_chartall->render( ).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_vendor_all_data (101# #### ## ##)
*&---------------------------------------------------------------------*
FORM get_vendor_all_data.
  REFRESH gt_vend.
  SELECT a~bpid, a~bptyp, a~bpnm, a~addr, a~cntcd, a~bizno,
         a~email, a~accno, a~bank, a~waers, a~picnm, a~pictl,
         b~recon, " ####  " #### ## ## # ##
         c~ekorg, c~ekgrp, c~zterm, c~inco1, c~mwskz, c~bukrs, c~zvlead
    FROM ztb1sd0001 AS a
    LEFT OUTER JOIN ztb1sd0002 AS b ON a~bpid  = b~bpid
                                   AND a~bptyp = b~bptyp
    LEFT OUTER JOIN ztb1mm0004 AS c ON a~bpid  = c~bpid " ## BP# c~ ### #### ## #
   WHERE a~bptyp = '1' " ### BP ### '####'# ## ##### #
     AND a~lvorm <> 'X' " left outer join### ## ### A# ### (####, ## ## ## ## ### ## ##)
    INTO CORRESPONDING FIELDS OF TABLE @gt_vend.

  IF sy-subrc <> 0.
    gv_dynnr = '9000'. " #### # ##
  ELSE.
    LOOP AT gt_vend ASSIGNING FIELD-SYMBOL(<fs_vend>).
      PERFORM get_domain_text USING 'ZDB1_SD_BPTYP' <fs_vend>-bptyp CHANGING <fs_vend>-bptyptxt.
    ENDLOOP.
    gv_dynnr = '0101'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_vendor_data (102#, 103# #### ## ##)
*&---------------------------------------------------------------------*
FORM get_vendor_data USING pv_pop pv_bpid.
  CLEAR gs_vend.
  SELECT SINGLE a~bpid, a~bptyp, a~bpnm, a~addr, a~cntcd, a~bizno,
                a~email, a~accno, a~bank, a~waers, a~picnm, a~pictl,
                b~recon, " ####  " #### ## ## # ##
                c~ekorg, c~ekgrp, c~zterm, c~inco1, c~mwskz, c~bukrs, c~zvlead
    FROM ztb1sd0001 AS a
    LEFT OUTER JOIN ztb1sd0002 AS b ON a~bpid  = b~bpid
                                   AND a~bptyp = b~bptyp
    LEFT OUTER JOIN ztb1mm0004 AS c ON a~bpid  = c~bpid
   WHERE a~bpid  = @pv_bpid " ##### ## #### ### ##
     AND a~bptyp = '1' " ###### ##### ## ### BP## ### ###
     AND a~lvorm <> 'X' " left outer join### ## ### A# ### (####, ## ## ## ## ### ## ##)
    INTO CORRESPONDING FIELDS OF @gs_vend.

  IF sy-subrc <> 0.
    IF pv_pop = 'X'. " #### ### #### ### ### #### ###
      MESSAGE s108(zmcb1) DISPLAY LIKE 'W' WITH pv_bpid. " #### pv_bpid# #### ####
      EXIT.
    ELSE.
      PERFORM get_vendor_all_data. " ##### ## #### ## ### ####
      gv_dynnr = '101'. " Sub### ## ### #### ###
    ENDIF.
  ELSE.
    IF pv_pop = 'X'. " #### ## ## # ## ### ## ##
      PERFORM get_domain_text USING 'ZDB1_MM_EKORG' gs_vend-ekorg  CHANGING gv_vend_org. " ####
      PERFORM get_domain_text USING 'ZDB1_MM_EKGRP' gs_vend-ekgrp  CHANGING gv_vend_grp. " ####
      PERFORM get_domain_text USING 'ZDB1_MM_BUKRS' gs_vend-bukrs  CHANGING gv_vend_buk  . " ####
      PERFORM get_domain_text USING 'ZDB1_MM_ZTERM' gs_vend-zterm  CHANGING gv_vend_term. " ####
      PERFORM get_domain_text USING 'ZDB1_MM_INCO1' gs_vend-inco1  CHANGING gv_vend_inco. " ####
    ELSE.
      gv_dynnr = '102'.
    ENDIF.
    " ##
    PERFORM get_domain_text USING 'ZDB1_MM_CNTCD' gs_vend-cntcd  CHANGING gv_cntcd. " #### ###
    PERFORM get_domain_text USING 'ZDB1_MM_MWSKZ' gs_vend-mwskz  CHANGING gv_mwskz. " #### ###
    gv_zvlead = '# / ### ##'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_alv_edit (200, 300# item ALV ##)
*&---------------------------------------------------------------------*
FORM set_alv_edit  USING VALUE(pv_container_name).
  " 1. ### 200## 300## #### ####, ## ## ###
  IF go_cont IS NOT INITIAL AND gv_before_dynnr <> sy-dynnr.
    go_cont->free( ).
    FREE: go_cont, go_alv.
  ENDIF.

  "2. ## Container# ##### ### ## ## ### (cont, alv ## ##)
  IF go_cont IS INITIAL.
    gv_before_dynnr = sy-dynnr. " ## ##### #####
    PERFORM create_object USING pv_container_name 'X' CHANGING go_cont go_alv.

    "3. ## #### #### ## ## (pv_type = 1)
    PERFORM set_layout USING 1 CHANGING gs_layout.
    PERFORM set_uifunc USING 1 CHANGING gt_uifunc.
    PERFORM set_fcat_item CHANGING gt_fcat_item.
    " ### ### ##
    " SET HANDLER lcl_event_handler=>on_after_user_command FOR go_alv.
    SET HANDLER lcl_event_handler=>on_data_changed FOR go_alv.

    "4. # ## ####
    PERFORM display_alv USING gs_layout gt_uifunc gt_fcat_item
                        CHANGING go_alv gt_item.
  ELSE.
    " 2-2. ex) 300# #### ## ## ##### # -> # ## ######  refresh#
    PERFORM set_item_number. " 2-1. # ## ## ### ## ##
    go_alv->refresh_table_display( ).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_edit_data (200, 300 ##/## ### ### ####)
*&---------------------------------------------------------------------*
FORM get_edit_data .
  DATA: lt_item TYPE TABLE OF ztb1mm0007,
        ls_item TYPE ztb1mm0007.

  " ## ###### ### gv_eblen-> #### ## ### ####
  SELECT SINGLE ebeln bpid ekorg ekgrp bukrs bsart bedat zterm inco1 zebeln zebelnsv knumh
      lvorm ernam erdat erzet aenam aedat aezet
    FROM ztb1mm0006
    INTO CORRESPONDING FIELDS OF gs_head
   WHERE ebeln = gv_ebeln.

  IF gs_head IS NOT INITIAL. " ## ## ####
    PERFORM get_opti_data. " 110# ##### ### ### #####(#### ##)

    SELECT ebeln ebelp matnr werks lgort menge meins netpr dmbtr waersk wrbtr waers
      mwskz eindt slfdt insmk packno knttp sakto epstp postat
      lvorm ernam erdat erzet aenam aedat aezet " #
      FROM ztb1mm0007 " ## ### ### ### ####
      INTO CORRESPONDING FIELDS OF TABLE lt_item
     WHERE ebeln = gv_ebeln ORDER BY ebelp. " ## ## #### ####

    IF sy-subrc = 0.
      " ## 10## ### gt_item# DB ### ####
      LOOP AT lt_item INTO ls_item. " sy-tabix# ### gt_item# 1##, 2##... #### ##
*        IF ls_item-waersk = 'KRW'.
*          " ## ### ## ##!!
*          CALL FUNCTION 'CURRENCY_AMOUNT_SAP_TO_IDOC'
*            EXPORTING
*              currency    = ls_item-waersk
*              sap_amount  = ls_item-netpr
*            IMPORTING
*              idoc_amount = ls_item-netpr. " ## 100# ### 102644# ##
*
*          " # ### #####
*          CALL FUNCTION 'CURRENCY_AMOUNT_SAP_TO_IDOC'
*            EXPORTING
*              currency    = ls_item-waersk
*              sap_amount  = ls_item-dmbtr
*            IMPORTING
*              idoc_amount = ls_item-dmbtr.
*        ENDIF.

        READ TABLE gt_item ASSIGNING FIELD-SYMBOL(<fs_item>) INDEX sy-tabix.
        IF sy-subrc = 0.
          MOVE-CORRESPONDING ls_item TO <fs_item>. " #### #### MOVE-CORRESPONDING## ###
        ELSE.
          " ## DB #### 10### ## ## #### #####(##)
          APPEND INITIAL LINE TO gt_item ASSIGNING <fs_item>.
          MOVE-CORRESPONDING ls_item TO <fs_item>.
        ENDIF.
      ENDLOOP.

      " 1(##) > 2(SV) > 3(##) > 4(##)
      SORT lt_item BY postat ASCENDING.
      " #### 1# ### ### 1# ##. ###### #### ## ### ### ###
      READ TABLE lt_item INTO DATA(ls_status_check) INDEX 1.
      IF sy-subrc = 0.
        gv_postat = ls_status_check-postat.
        PERFORM get_domain_text USING 'ZDB1_MM_POSTAT' gv_postat CHANGING gv_postatxt.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form confirm_delete (300# ### ## ## - ##)
*&---------------------------------------------------------------------*
FORM confirm_delete USING pv_text CHANGING pv_answer.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = '## ##'
      text_question         = pv_text
      text_button_1         = '#'
      text_button_2         = '###'
      display_cancel_button = ' ' " ## ### ## ### ## ## ##
    IMPORTING
      answer                = pv_answer.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form delete_selected_items (300# ### ## ## - # ## ##)
*&---------------------------------------------------------------------*
FORM delete_selected_items.
  DATA: lt_rows         TYPE lvc_t_row,
        lv_selected_cnt TYPE i, " ### # ##
        lv_remain_cnt   TYPE i, " ## #
        lv_text         TYPE string.

  " 1. ALV## ### # ####
  CALL METHOD go_alv->get_selected_rows
    IMPORTING
      et_index_rows = lt_rows.
  lv_selected_cnt = lines( lt_rows ). " lines# ## ### # ### ##

  IF lv_selected_cnt = 0.
    MESSAGE s013(zmcb1) DISPLAY LIKE 'E' WITH '## ##: '. " ## ##: ### ### ####
    RETURN.
  ENDIF.

  " 2. ## ## # ##
  LOOP AT gt_item INTO DATA(ls_temp)
      WHERE lvorm <> 'X'      " ## # # # #
         AND matnr IS NOT INITIAL. " ##### ## # ### ###
    lv_remain_cnt = lv_remain_cnt + 1.
  ENDLOOP.

  " 3. ## ## ## ## - ## ## vs ## ##
  IF lv_selected_cnt = lv_remain_cnt.
    " 1) ### # ### ##
    lv_text = |## ### #### ## ### ## #####. ## ########?|.
    PERFORM confirm_delete USING lv_text CHANGING lv_answer.
    IF lv_answer = '1'.
      PERFORM delete_po_all.
    ENDIF.
  ELSE.
    " 2) ## ### #### ##
    lv_text = |### { lv_selected_cnt }## ### ########? ## # #### #####.|.
    PERFORM confirm_delete USING lv_text CHANGING lv_answer.
    IF lv_answer = '1'.
      PERFORM delete_po_items USING lt_rows. " ## ## #### ##
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form delete_po_all (300# ### ##/### ## ##)
*&---------------------------------------------------------------------*
FORM delete_po_all.
  " 1. ## ## ## (LVORM = 'X')
  UPDATE ztb1mm0006
       SET lvorm = 'X'," ## ### ### ##### ## ####
           aenam = @sy-uname, aedat = @sy-datum, aezet = @sy-uzeit
     WHERE ebeln = @gv_ebeln.

  IF sy-subrc = 0.
    " 2. ### ## ## ## (LVORM = 'X')
    UPDATE ztb1mm0007
      SET lvorm = 'X',
          aenam = @sy-uname, aedat = @sy-datum, aezet = @sy-uzeit
     WHERE ebeln = @gv_ebeln.

    IF sy-subrc = 0.
      " 3. ## ## ## (ZAPPST = '4')
      UPDATE ztb1mm0008
      SET zappst = '4',       " ## ### ##
           aenam  = @sy-uname, " ###
           aedat  = @sy-datum, " ###
           aezet  = @sy-uzeit  " ####
       WHERE ebeln = @gv_ebeln
         AND lvorm <> 'X' " ## ## # # ####
         AND zappst <> '4'. " ## ## ### ## ## ####

      IF sy-subrc = 0.
        COMMIT WORK. " 3# ### #### #### ##
        MESSAGE s007(zmcb1). " '### #######.'
        LEAVE TO SCREEN 0. " ## #### ####

      ELSE.
        ROLLBACK WORK. " #### ## #### ### ### ## ## 3
        MESSAGE e008(zmcb1) WITH ': ## ## ##'. " ## # ### ###### : ## ## ##
      ENDIF.

    ELSE.
      ROLLBACK WORK. " ### ## #### ### ### ## ## 2
      MESSAGE e008(zmcb1) WITH ': ### ## ##'. " ## # ### ######
    ENDIF.

  ELSE.
    ROLLBACK WORK. " ## ## #### ### ### ## ## 1
    MESSAGE e008(zmcb1) WITH ': ## ## ##'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form delete_po_items (300# ### ### ## ##)
*&---------------------------------------------------------------------*
FORM delete_po_items USING pt_rows TYPE lvc_t_row.
  DATA: lv_appno    TYPE zeb1_mm_zappno,
        ls_app      TYPE ztb1mm0008,
        lv_cnt      TYPE i, " ### # ##
        lv_err_flag TYPE c. " ### # ####

  lv_cnt = lines( pt_rows ).

  " 1. ### ##### LVORM = 'X' ####
  LOOP AT pt_rows INTO DATA(ls_row).
    READ TABLE gt_item ASSIGNING FIELD-SYMBOL(<fs_item>) INDEX ls_row-index.
    IF sy-subrc = 0.
      UPDATE ztb1mm0007 SET lvorm = 'X',
          aenam = @sy-uname, aedat = @sy-datum, aezet = @sy-uzeit
       WHERE ebeln = @gv_ebeln AND ebelp = @<fs_item>-ebelp.
    ENDIF.
    IF sy-subrc <> 0.
      lv_err_flag = 'X'.
    ENDIF.
  ENDLOOP.

  IF lv_err_flag IS INITIAL. " ## ## ##### ##
    " 2. ## ## ##
    UPDATE ztb1mm0008
    SET zappst = '4',       " ## ### ##
         aenam  = @sy-uname, " ###
         aedat  = @sy-datum, " ###
         aezet  = @sy-uzeit  " ####
     WHERE ebeln = @gv_ebeln
       AND lvorm <> 'X' " ## ## # # ####
       AND zappst <> '4'. " ## ## ### ## ## ####

    IF sy-subrc = 0.
      " 3. ### ## ###
      PERFORM get_new_app_number CHANGING lv_appno.
      CLEAR ls_app.
      ls_app-zappno = lv_appno.
      ls_app-ebeln  = gv_ebeln.
      ls_app-zappst = '1'.
      ls_app-ernam  = sy-uname.
      ls_app-erdat  = sy-datum.
      ls_app-erzet  = sy-uzeit.
      ls_app-aenam  = sy-uname.
      ls_app-aedat  = sy-datum.
      ls_app-aezet  = sy-uzeit.

      INSERT ztb1mm0008 FROM ls_app.

      IF sy-subrc = 0.
        COMMIT WORK.
        MESSAGE s115(zmcb1) WITH lv_cnt '##' . " ### ### ######, #### #######
        PERFORM get_edit_data. " ## ##### ### ## ##
        IF go_alv IS BOUND.
          go_alv->refresh_table_display( ). " ## ## ####
        ENDIF.
      ELSE.
        ROLLBACK WORK. " #### ## #### ### ### ## ## 2
        MESSAGE e008(zmcb1) WITH ': ## ## ## ##'. " ## # ### ###### :## ## ## ##
      ENDIF.
    ELSE.
      ROLLBACK WORK. " #### ## #### ### ### ## ## 2
      MESSAGE e008(zmcb1) WITH ': ## ## ##'. " ## # ### ###### : ## ## ##
    ENDIF.
  ELSE.
    ROLLBACK WORK. " ### ## #### ### ### ## ## 1
    MESSAGE e008(zmcb1) WITH ': ### ## ##'. " ## # ### ######:
  ENDIF.
ENDFORM.
