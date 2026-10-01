*&---------------------------------------------------------------------*
*& Include          ZRB1MM0001_F01
*&---------------------------------------------------------------------*
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
  CLEAR: gs_head-ekorg, gs_head-ekgrp, gs_head-bukrs, gs_head-postat, gs_head-zterm, gs_head-inco1,
         gs_head-postat,gs_head-zebeln, gs_head-knumh, gs_head-lvorm, gs_head-ernam, gs_head-erdat, gs_head-erzet, gs_head-aenam, gs_head-aedat,gs_head-aezet.
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
*& Form create_object (100# ### ### #### # alv ### ###)
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

  " #### ## ## ### ## #, ### # ## ## ## #### #### #### # #### ##
  go_alv->register_edit_event( i_event_id = cl_gui_alv_grid=>mc_evt_enter ).
  go_alv->register_edit_event( i_event_id = cl_gui_alv_grid=>mc_evt_modified ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_alv (100# ### # ## ### ### ####)
*&---------------------------------------------------------------------*
FORM display_alv .
*  gs_variant-report = sy-repid. " ## #### ##
  " ALV Grid ## Data display
  CALL METHOD go_alv->set_table_for_first_display
    EXPORTING
*     i_structure_name              = 'ZTB1MM0007'
*     is_variant                    = gs_variant " #### ###
*     i_save                        = 'A' " A, X, U, '' " ## ##
*     i_default                     = 'X'        " ## #### ##
      is_layout                     = gs_layout  " #### ###
      it_toolbar_excluding          = gt_uifunc  " ## ##
    CHANGING
      it_outtab                     = gt_item    " ######## ##
*     it_sort                       = gt_sorter  " ##
*     it_filter                     = gt_filter  " ## ### #### ## ##
      it_fieldcatalog               = gt_fcat_item    " i_structure ### ### ###
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
FORM refresh_alv .
  gs_stable-row = 'X'. " ##### # ## ### ## ##
  gs_stable-col = 'X'. " ## ## ##
  CALL METHOD go_alv->refresh_table_display
    EXPORTING
      is_stable      = gs_stable
      i_soft_refresh = '' "x: ##, ##, ## ### ## -> ### #### #####
    EXCEPTIONS            "_: ## ####(##)
      finished       = 1
      OTHERS         = 2.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout (100# ### ALV #### ##)
*&---------------------------------------------------------------------*
FORM set_layout.
*  gs_layout-cwidth_opt = 'X'. " # ## ## ### " # ## #### ## #### #(fcat)
  gs_layout-sel_mode   = 'D'. " # ## ## ##
ENDFORM.
*&---------------------------------------------------------------------*
*& set_fcat_item (100# ### ALV ## #### ##)
*&---------------------------------------------------------------------*
FORM set_fcat_item CHANGING ct_fcat_item TYPE lvc_t_fcat.

*  CLEAR gs_fcat. " #### ## ###### ## ## (## ###)
*  gs_fcat-fieldname = 'EBELP'.
*  APPEND gs_fcat TO gt_fcat.

  " -> ### ####, #### ## ##
  PERFORM set_fcat TABLES ct_fcat_item USING:
        'S' 'FIELDNAME' 'EBELP', " #### ## ##
        ' ' 'COLTEXT'   '##',   " ### ###
        ' ' 'KEY' 'X', ' ' 'EMPHASIZE' 'C110', " ### ## # ## ###!
        ' ' 'LZERO'     'X',     " 0# ### 0010## ##(char4)
        ' ' 'OUTPUTLEN' '4',     " layout## ## ### ## #### ## ##
        'E' ''          '',      " APPEND ### #### ## (## ##)
        " ### 'S'# ## ## 'E'# ####### #
                                                               " ## ### # ### ####, F4VAILABL# #### F4 Help# ### # ##
        'S' 'FIELDNAME' 'MATNR',  ' ' 'COLTEXT' '####',        ' ' 'REF_TABLE' 'ZTB1MM0007', ' ' 'REF_FIELD' 'MATNR', ' ' 'EDIT' 'X', ' ' 'F4AVAILABL' 'X', 'E' ' ' ' ', " EDIT = 'X' ## ## ##
        'S' 'FIELDNAME' 'WERKS',  ' ' 'COLTEXT' '###',          ' ' 'REF_TABLE' 'ZTB1MM0007', ' ' 'REF_FIELD' 'WERKS', ' ' 'F4AVAILABL' 'X', ' ' 'EDIT' 'X',  'E' ' ' ' ', " ' ' 'REF_TABLE' 'ZTB1MM0007', ' ' 'REF_FIELD' 'WERKS', " #### #### ### ### ###
        'S' 'FIELDNAME' 'LGORT',  ' ' 'COLTEXT' '####',        ' ' 'REF_TABLE' 'ZTB1MM0007', ' ' 'REF_FIELD' 'LGORT', ' ' 'F4AVAILABL' 'X', ' ' 'OUTPUTLEN' '6',  ' ' 'EDIT' 'X', 'E' ' ' ' ', "  ' ' 'REF_TABLE' 'ZTB1MM0007', ' ' 'REF_FIELD' 'LGORT',

        'S' 'FIELDNAME' 'MENGE',  ' ' 'COLTEXT' '####',       ' ' 'EDIT' 'X', ' ' 'NO_ZERO' 'X',   'E' ' ' ' ', " ' ' 'DECIMALS_OUT' '0', ' ' 'DECIMALS' '0',
        'S' 'FIELDNAME' 'MEINS',  ' ' 'COLTEXT' '####',       'E' ' ' ' ', " NO_ZERO = 'X' ## 0# # ## ## # #        " ### ### ##### QUAN## ## " ## ## #/##,## # ### 0## (####) ##

        'S' 'FIELDNAME' 'NETPR',  ' ' 'COLTEXT' '##',          ' ' 'NO_ZERO' 'X',  'E' ' ' ' ',
        'S' 'FIELDNAME' 'DMBTR',  ' ' 'COLTEXT' '# ##',       ' ' 'NO_ZERO' 'X',  'E' ' ' ' ',
        'S' 'FIELDNAME' 'WAERSK', ' ' 'COLTEXT' '##',          'E' ' ' ' ',
        'S' 'FIELDNAME' 'WRBTR',  ' ' 'NO_OUT' 'X',             'E' '' '',   " NO_OUT = 'X' ## ## ##
        'S' 'FIELDNAME' 'WAERS',  ' ' 'NO_OUT' 'X',             'E' '' '',   " USD ### #### ##### #### ##
        'S' 'FIELDNAME' 'MWSKZ',  ' ' 'COLTEXT' '####',        'E' ' ' ' ',
        'S' 'FIELDNAME' 'EINDT',  ' ' 'COLTEXT' '## ###',      ' ' 'REF_TABLE' 'ZTB1MM0007', ' ' 'REF_FIELD' 'EINDT', ' ' 'EDIT' 'X', ' ' 'F4AVAILABL' 'X',  'E' ' ' ' ',
        'S' 'FIELDNAME' 'SLFDT',  ' ' 'COLTEXT' '## ###',      'E' ' ' ' ',
        'S' 'FIELDNAME' 'INSMK',  ' ' 'NO_OUT' 'X',  'E' '' '', " ## ## ### #### #### ##(A) ##
        'S' 'FIELDNAME' 'PACKNO', ' ' 'NO_OUT' 'X',  'E' '' '', " ### ## ##### #### ###
        'S' 'FIELDNAME' 'KNTTP',  ' ' 'NO_OUT' 'X',  'E' '' '',
        'S' 'FIELDNAME' 'SAKTO',  ' ' 'NO_OUT' 'X',  'E' '' '',
        'S' 'FIELDNAME' 'EPSTP',  ' ' 'NO_OUT' 'X',  'E' '' '',
        'S' 'FIELDNAME' 'POSTAT', ' ' 'NO_OUT' 'X',  'E' '' ''. " ## ## ### #### 1(##)# ##
ENDFORM.
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
*& Form set_uifunc (100# ### ALV ## ## ## ##)
*&---------------------------------------------------------------------*
FORM set_uifunc.
  REFRESH gt_uifunc.
  APPEND cl_gui_alv_grid=>mc_fc_detail       TO gt_uifunc. " ### ###
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy     TO gt_uifunc.
*  APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row TO gt_uifunc. " # ##(##### #)
  " # ### ####, ####, # ##, ##, ## ## ### ####
  APPEND cl_gui_alv_grid=>mc_fc_check        TO gt_uifunc. "
  APPEND cl_gui_alv_grid=>mc_fc_loc_cut      TO gt_uifunc. "
  APPEND cl_gui_alv_grid=>mc_fc_loc_paste    TO gt_uifunc. "
  APPEND cl_gui_alv_grid=>mc_fc_loc_paste_new_row TO gt_uifunc.
  APPEND cl_gui_alv_grid=>mc_fc_sort_asc     TO gt_uifunc. "
  APPEND cl_gui_alv_grid=>mc_fc_sort_dsc     TO gt_uifunc. "
  APPEND cl_gui_alv_grid=>mc_fc_find         TO gt_uifunc. "
  APPEND cl_gui_alv_grid=>mc_fc_filter       TO gt_uifunc. "
  APPEND cl_gui_alv_grid=>mc_fc_print        TO gt_uifunc. "
  APPEND cl_gui_alv_grid=>mc_fc_graph        TO gt_uifunc. "
  APPEND cl_gui_alv_grid=>mc_fc_info         TO gt_uifunc. "
  APPEND cl_gui_alv_grid=>mc_mb_sum          TO gt_uifunc.
  APPEND cl_gui_alv_grid=>mc_mb_variant      TO gt_uifunc.
  APPEND cl_gui_alv_grid=>mc_mb_view         TO gt_uifunc.
  APPEND cl_gui_alv_grid=>mc_mb_export       TO gt_uifunc.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_dialog_object (110# ## cont # alv ### ###)
*&---------------------------------------------------------------------*
FORM create_dialog_object .
  CREATE OBJECT go_dialog " Custom Container ####, Area# ##
    EXPORTING
      container_name              = 'POPUP' " ### Layout# ## ## ##
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.

  CREATE OBJECT go_alv_pop " ALV Grid ## #### Container# ##
    EXPORTING
      i_parent          = go_dialog
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_dialog_alv (110# ## # ## ### ### ####)
*&---------------------------------------------------------------------*
FORM display_dialog_alv .
  CALL METHOD go_alv_pop->set_table_for_first_display
    EXPORTING
      is_layout                     = gs_layo_pop  " #### ###
      it_toolbar_excluding          = gt_uifunc_pop  " ## ##
    CHANGING
      it_outtab                     = gt_opti    " itab# ##
      it_fieldcatalog               = gt_fcat_opti    " i_structure ### ### ###
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_dialog_layout (110# ## ALV #### ##)
*&---------------------------------------------------------------------*
FORM set_dialog_layout .
  gs_layo_pop-cwidth_opt = 'X'. " # ## ## ###
  gs_layo_pop-zebra      = 'X'. " ### ##
  gs_layo_pop-sel_mode   = 'A'. " ## # ## ## " B: ##/##
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_dialog_uifunc (110# ## ALV ## ## ## ##)
*&---------------------------------------------------------------------*
FORM set_dialog_uifunc .
  REFRESH gt_uifunc_pop.
  APPEND cl_gui_alv_grid=>mc_fc_excl_all  TO gt_uifunc_pop. " ## ## ##
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_dialog_fieldcat (110# ## ALV ## #### ##)
*&---------------------------------------------------------------------*
FORM set_fcat_opti CHANGING ct_fcat_opti TYPE lvc_t_fcat.
  PERFORM set_fcat TABLES ct_fcat_opti USING:
        " 'S' 'COLTEXT'   '##',   " (##)
        " 'E' ''          '',      " APPEND ### #### ## (## ##)
        " ### 'S'# ## ## ### ' ', 'E'# ####### #

          " ##### # '###', '###'# ## ### ### ### ####, ### #### # # ## ### ###
          'S' 'FIELDNAME' 'AEDAT', ' ' 'COLTEXT' '####',   ' ' 'EMPHASIZE' 'C110',' ' 'COL_POS' '1',   ' ' 'JUST' 'C', 'E' ' ' ' ', " Visible
          'S' 'FIELDNAME' 'AEZET', ' ' 'COLTEXT' '####', ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'AENAM', ' ' 'COLTEXT' '###',    ' ' 'EMPHASIZE' 'C110', ' ' 'COL_POS' '2',   ' ' 'JUST' 'C', 'E' ' ' ' ', " Visible

        " ## ## ## (Visible)
          'S' 'FIELDNAME' 'MATNR',  ' ' 'COLTEXT' '####',        ' ' 'JUST' 'C', 'E' ' ' ' ', " JUST = 'C' ### ##
          'S' 'FIELDNAME' 'HERKL',  ' ' 'COLTEXT' '###',          ' ' 'JUST' 'C', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'PLIFZ',  ' ' 'COLTEXT' '## ##',       ' ' 'JUST' 'C', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'WAERS',  ' ' 'COLTEXT' '##',            ' ' 'JUST' 'C', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'NETPR',  ' ' 'COLTEXT' '## ## ##',  ' ' 'JUST' 'C', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'ZFRT',   ' ' 'COLTEXT' '## ###',     ' ' 'JUST' 'C', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'ZOTH',   ' ' 'COLTEXT' '## ##',       ' ' 'JUST' 'C', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'ZGRM',   ' ' 'COLTEXT' '## ## ##',  ' ' 'JUST' 'C', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'DATAB',  ' ' 'COLTEXT' '## ## ###',     ' ' 'JUST' 'C', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'DATBI',  ' ' 'COLTEXT' '## ## ###',     ' ' 'JUST' 'C', 'E' ' ' ' ',

          " ## ## (No Out)
          'S' 'FIELDNAME' 'KNUMH',  ' ' 'COLTEXT' '#### ##',   ' ' 'JUST' 'C', ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'BPID',   ' ' 'COLTEXT' '#### ##',   ' ' 'JUST' 'C', ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'MEINS',  ' ' 'COLTEXT' '## ##',      ' ' 'JUST' 'C', ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'MWSKZ',  ' ' 'COLTEXT' '## ##',       ' ' 'JUST' 'C', ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'LVORM',  ' ' 'COLTEXT' '## ##',       ' ' 'JUST' 'C', ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'ZSEL',   ' ' 'COLTEXT' '## ##',      ' ' 'JUST' 'C', ' ' 'NO_OUT' 'X', 'E' ' ' ' ',

          " ## ##### (## ##)
          'S' 'FIELDNAME' 'ERDAT', ' ' 'COLTEXT' '###',   ' ' 'JUST' 'C', ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'ERZET', ' ' 'COLTEXT' '####', ' ' 'JUST' 'C', ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
          'S' 'FIELDNAME' 'ERNAM', ' ' 'COLTEXT' '###',   ' ' 'JUST' 'C', ' ' 'NO_OUT' 'X', 'E' ' ' ' '.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_opti_data (110# ## #### ### ##)
*&---------------------------------------------------------------------*
FORM get_opti_data .
  " 1. #### ### #### #### #### ##
  IF gs_head-bedat < sy-datum.
    MESSAGE s012(zmcb1) WITH '#### ##' DISPLAY LIKE 'E'. " ## #### #### ### # ####.
    RETURN.
  ENDIF.

  " 2. #### ##### ## ### ## ## (CDS View ##)
  IF gs_head-bedat IS NOT INITIAL.
    " ##### #### ### ##/## ### ### #### ####

    SELECT * " ### ### #### ## X. ### # # CDS View# ##### #### # O
      FROM zcds_b1_mm_0001( p_bedat = @gs_head-bedat )  "## ## ## ### -> ## ### View# ##
      INTO CORRESPONDING FIELDS OF TABLE @gt_opti
      WHERE bpid = @gs_head-bpid. " #### ### ##### #### ## ##
    " ### ##(## ##, ### / Fiori## ### ## / ## # # ###)# CDS## ##
    IF sy-subrc <> 0.
      MESSAGE s010(zmcb1) WITH '## ## ###' DISPLAY LIKE 'E'. " ## ### ## ## ## #### ####.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form add_selected_data (110# ## ## ### -> 100# ### #### ##)
*&---------------------------------------------------------------------*
FORM add_selected_data.
  DATA: lt_rows  TYPE lvc_t_row, " 1. # ## itab, st ## ##
        ls_row   TYPE lvc_s_row, " ## ##(lt, ls)
        lv_tabix TYPE sy-tabix, " ## ### ##(# 10#)# #### ##
        lv_werks TYPE werks_d. " 2-1. ### ## (## ####)

  " 2-2. ### ### ####
  GET PARAMETER ID 'WRK' FIELD lv_werks. " ## #### #### #### ##### ###
  IF lv_werks IS INITIAL.
    lv_werks = '1000'. " ## ### 1000 ##
  ENDIF.

  " 3. ## ALV## ### ## # ####
  CALL METHOD go_alv_pop->get_selected_rows
    IMPORTING
      et_index_rows = lt_rows.

  IF lt_rows IS INITIAL. " #### ## ### #### # ### ####
    MESSAGE s013(zmcb1) DISPLAY LIKE 'W'. " ### #### ### ## ### ###
    RETURN. " ### ## ## # ## ### #####.
  ENDIF.

  " 4. ### ### gt_item = #### ### #### ### ####
  LOOP AT lt_rows INTO ls_row.
    " gt_opti# CDS View## ### ## ###(itab)
    READ TABLE gt_opti INTO gs_opti INDEX ls_row-index.

    " 4-1. ### ### KRW ##(USD ## * ##)# 0# #### ##
    IF sy-subrc <> 0 " CDS View ### ##### '### ##' ### ## 0 # #.
        OR gs_opti-add_ukurs = 0.

      " 4-2. ## ### ### ## CONTINUE# ##, ## #(=## ##)## ###
      MESSAGE i407(zmcb1) WITH gs_opti-matnr '##: ' '###'. " (####) ##: ### ## ### ### #####
      CONTINUE.
    ENDIF.

    " 4-3. ##### ## ### #### ##, ### ## ### ##
    READ TABLE gt_item INTO gs_item WITH KEY matnr = ''. " ##### ## # ## ##
    lv_tabix = sy-tabix.

    IF sy-subrc = 0.
      " 4-4. # ## ### # ### #### ##(##### ##)
      gs_item-matnr = gs_opti-matnr.
      gs_item-werks = lv_werks.
      gs_item-meins = gs_opti-meins.
      gs_item-netpr = gs_opti-fin_netpr_krw.
      gs_item-waersk = 'KRW'.
      gs_item-mwskz = gs_opti-mwskz.
      gs_item-werks = lv_werks.

      MODIFY gt_item FROM gs_item INDEX lv_tabix.
    ELSE.

      CLEAR gs_item.
      gs_item-matnr = gs_opti-matnr.         " ####
      gs_item-werks = lv_werks.              " ###
      gs_item-meins = gs_opti-meins.         " ####
      gs_item-netpr = gs_opti-fin_netpr_krw. " CDS# ### KRW ## ##
      gs_item-waersk = 'KRW'.                " ##(##)
      gs_item-mwskz = gs_opti-mwskz.         " ####
      gs_item-werks = lv_werks.              " ### ## ##

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
            pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'NETPR'  i_value = <fs_item>-netpr ).
            pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'MWSKZ'  i_value = <fs_item>-mwskz ).
            pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'MEINS'  i_value = <fs_item>-meins ).
            <fs_item>-waersk = 'KRW'. " ### #### ### ####
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
  PERFORM refresh_alv.

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
           screen-name = 'GS_HEAD-BUKRS' OR " ####
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

  CREATE OBJECT lo_protocol. " ## #### ## ## (### ###)
  cv_subrc = 0.

  " #1. ## ##
  " ## 1) ##### ### ## ## ##
  IF gs_head-bedat < sy-datum AND gs_head-bedat IS NOT INITIAL.
    PERFORM check_and_add_protocol USING gs_head-bedat 'E' '012' '##### ##' 'GS_HEAD-BEDAT' 0 lo_protocol CHANGING lv_error_cnt.
  ELSEIF gs_head-bedat IS INITIAL. " ## ## ###. (#### #### ##### ###, ## #### ## #### ### #### ### #### #)
    PERFORM check_and_add_protocol USING gs_head-bedat 'E' '014' '####' 'GS_HEAD-BEDAT' 0 lo_protocol CHANGING lv_error_cnt.
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

  DATA: lv_title TYPE string VALUE '## ##',
        lv_text  TYPE string,
        lv_count TYPE i,
        lv_total TYPE dmbtr.

  " 1. ### ### ## ##
  LOOP AT gt_item INTO DATA(ls_item) WHERE matnr IS NOT INITIAL.
    lv_count = lv_count + 1.
    lv_total = lv_total + ls_item-dmbtr.
  ENDLOOP.
  " 2. ## ### ## (#: #### USU## # 3#, # ## 500,000 KRW# ########?)
  lv_text = |#### [{ gv_bpnm }]##\n| &&
            |# { lv_count }#,\n ##: { lv_total NUMBER = USER } KRW#\n| &&
            |########?|.
  CLEAR cv_answer.

  " 3. ## ##
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = lv_title
      text_question         = lv_text
      text_button_1         = '##'(001)
      icon_button_1         = 'ICON_SYSTEM_SAVE'
      text_button_2         = '##'(002)
      icon_button_2         = 'ICON_CANCEL'
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
*& FORM save_po_data (#### ## ### ##)
*&---------------------------------------------------------------------*
FORM save_po_data.
  DATA: lv_ebeln LIKE gs_head-ebeln,
        ls_head  TYPE ztb1mm0006,
        lt_item  TYPE TABLE OF ztb1mm0007, " ## ### DB ### ##
        ls_item  LIKE LINE OF lt_item,
        lv_tabix TYPE i,
        lv_subrc TYPE sy-subrc.

  " 1. ## ## ## (SNRO## ### ## ###)
  " 4500000136## #### ### lv_ebeln# ##
  PERFORM get_new_po_number CHANGING lv_ebeln.

  IF lv_ebeln IS INITIAL.
    MESSAGE e006(zmcb1) WITH ': #### ## ## ##'. " ## # ### ######
    RETURN.
  ENDIF.

  " 2. ## ### ## (gs_head# ## # ##### # ## ## ##)
  gs_head-ebeln  = lv_ebeln.      " ### ## ##
  gs_head-ernam = sy-uname.     " ###
  gs_head-erdat = sy-datum.     " ###
  gs_head-erzet = sy-uzeit.     " ####
  gs_head-postat = '1'.       " ## # ## ### ##

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
      " 2. KRW ##, ## - ## CDS## ### #### ### ## ###
      ls_item-netpr = ls_screen-netpr / 100. " KRW# DB ## # 100# #####, ## INSERT ### ## 100# ### #### ## ### ##
      ls_item-dmbtr = ls_screen-dmbtr / 100. " ###, ### #### ### -> DB ### # ### ## ##(1/100)
      ls_item-waersk = 'KRW'. " ## ## ##

      " 2-2. USD ##, ## -> #### #### ##. CDS## ### ### ##
      ls_item-wrbtr  = ls_o-fin_netpr_usd * ls_screen-menge.
      ls_item-waers  = ls_o-waers.

      " 3. ###### - # ## #### #### ### ### ##
      IF lv_tabix = 1.
        gs_head-knumh = ls_o-knumh.
      ENDIF.
    ENDIF.

    " 4. ### ### ##
    ls_item-insmk  = 'A'. " #### (##### ## ##### A)
    ls_item-postat = '1'. " ### ##: ## ##, ## ##

    " 5. ### ## ## - ##### ##
    ls_item-ernam = sy-uname.
    ls_item-erdat = sy-datum.
    ls_item-erzet = sy-uzeit.


    APPEND ls_item TO lt_item. " DB# ### #### ##
  ENDLOOP.

  " 4. ## DB ## (##, ###) - #### #### ROLLBACK##
  MOVE-CORRESPONDING gs_head TO ls_head. " #### ## ### ##
  INSERT ztb1mm0006 FROM ls_head. " ## ###
  IF sy-subrc = 0.
    INSERT ztb1mm0007 FROM TABLE lt_item. " ### ### ## ##

    IF sy-subrc = 0.
      COMMIT WORK. " DB ## ## - ####
      MESSAGE s104(zmcb1) WITH lv_ebeln .

      " ## ## # ## ## (## ###)
      PERFORM set_screen_after_save.

      IF GV_SAVE_CHECK IS INITIAL.        "## PO ## ## #, ### PO ## #### ##.
        GV_SAVE_CHECK = 'X'.
      ELSE.
        GV_SAVE_CHECK = ''.
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
    PERFORM refresh_alv.
  ENDIF.
  " 5. ## ## ## (#### #### ## ## #### ##)
  PERFORM control_header_screen.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_init_item_rows (100# ### ALV ## # # ### - 10#)
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
*& Form set_init_user_data
*&---------------------------------------------------------------------*
FORM set_init_user_data . " ###### ## #### ##
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
