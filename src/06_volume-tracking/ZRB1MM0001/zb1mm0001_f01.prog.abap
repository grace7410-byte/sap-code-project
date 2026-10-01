*&---------------------------------------------------------------------*
*& Include          ZB1MM0001_3F01
*&---------------------------------------------------------------------*
*& Form get_header_data (100# ### ALV ## ### ##)
*&---------------------------------------------------------------------*
FORM get_header_data.
  CLEAR gt_hvolm. " ## ###### APPENDING### ## ### Clear# ## ##

  " #### #### ## ## ## ## ### ##
  CASE pa_typ.
    WHEN 'PO'.
      PERFORM get_po_header. " #### ##
    WHEN 'SO'.
      PERFORM get_so_header. " #### ##
    WHEN 'PrO'.
      PERFORM get_pro_header. " #### ##
    WHEN OTHERS. " '##' ## # ## ## ##
      PERFORM get_po_header.
      PERFORM get_so_header.
      PERFORM get_pro_header.
  ENDCASE.

  " 2. ## ## ##
  IF gt_hvolm IS INITIAL.
    MESSAGE s010(zmcb1) DISPLAY LIKE 'E' WITH '## ## ###'.
    EXIT.
  ENDIF.

  gt_head = gt_hvolm.
  SORT gt_head BY bldat DESCENDING zdocno.
  SORT gt_hvolm BY process zdocno.
ENDFORM.
*&---------------------------------------------------------------------*
*& #### ## ## (ZTB1MM0006)
*&---------------------------------------------------------------------*
FORM get_po_header.
  SELECT 'PO'   AS process, ebeln AS zdocno,bpid, bedat AS bldat
    FROM ztb1mm0006 " INTO ## APPENDING# ## gt_hvolm# ## ##
    APPENDING CORRESPONDING FIELDS OF TABLE @gt_hvolm
   WHERE ebeln IN @so_doc
     AND bedat IN @so_dat  " ### ## ##
     AND bsart = 'NB'" ## ##### ## ##( ##### #### # #### ## ##)
     AND lvorm <> 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*& #### ## ## (ZTB1SD0006)
*&---------------------------------------------------------------------*
FORM get_so_header.
  SELECT 'SO'   AS process, vbeln  AS zdocno, bpid, ordda  AS bldat
    FROM ztb1sd0006
    APPENDING CORRESPONDING FIELDS OF TABLE @gt_hvolm
   WHERE vbeln IN @so_doc
     AND ordda IN @so_dat  " ### ## ##
     AND lvorm <> 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*& #### ## ## (ZTB1PP0013)
*&---------------------------------------------------------------------*
FORM get_pro_header.
  SELECT 'PrO'  AS process, plpr AS zdocno, sdate  AS bldat " BPID ### ####
    FROM ztb1pp0013
    APPENDING CORRESPONDING FIELDS OF TABLE @gt_hvolm
   WHERE plpr  IN @so_doc
     AND sdate IN @so_dat  " ## ### ## ##
     AND plnty = 'PROD' " ## ### ##(##### ## ## ####)
     AND lvorm <> 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*& ## ## # ### #### ##
*&---------------------------------------------------------------------*
*FORM set_global_filter.
*  CLEAR gr_mat.
*  IF pa_mat IS NOT INITIAL. " ##### ###
*    APPEND VALUE #( sign = 'I' option = 'EQ' low = pa_mat ) TO gr_mat.
*  ENDIF.
*ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_item_data (100# ### ALV ### ##)
*&---------------------------------------------------------------------*
FORM get_item_data.
  CLEAR gt_item.
  IF gt_head IS INITIAL.
    RETURN.
  ENDIF. " ## #### #####

  " ### ## ###### #### ### ##
  CASE pa_typ.
    WHEN 'PO'.
      PERFORM get_po_item.
    WHEN 'SO'.
      PERFORM get_so_item.
    WHEN 'PrO'.
      PERFORM get_pro_item.
    WHEN OTHERS.
      PERFORM get_po_item. " ##### INTO ## APPENDING# ## gt_item# ### ### ## ##
      PERFORM get_so_item.
      PERFORM get_pro_item.
  ENDCASE.

  PERFORM modify_item_data.

  gt_item = gt_volm. " ## ALV #### ##
  SORT gt_item BY zmsno DESCENDING zdocit. " #### ## #### > #### ### ##
  PERFORM set_volm_style CHANGING gt_volm. " ## ### volm ### ##
ENDFORM.
*&---------------------------------------------------------------------*
*& #### ### ## (## ### + ## ## Join)
*&---------------------------------------------------------------------*
FORM get_po_item.
  SELECT a~ebeln AS zdocno, a~ebelp AS zdocit, a~matnr, a~werks, a~lgort, a~menge AS ordqty, a~meins,
         b~zmsno, b~zdocty, b~zavol, b~ztemp, b~zunit, b~zdens, b~zvcf, b~zsvol, b~meins  AS meins_2, b~zmdat
    FROM ztb1mm0007 AS a
    LEFT OUTER JOIN ztb1mm0020 AS b ON a~ebeln = b~zdocno
                                   AND a~ebelp = b~zdocit
                                   " AND b~zdocty LIKE 'PO%'
                                   AND b~lvorm <> 'X'
    APPENDING CORRESPONDING FIELDS OF TABLE @gt_volm
    FOR ALL ENTRIES IN @gt_head
   WHERE a~ebeln = @gt_head-zdocno
     AND a~lvorm <> 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*& #### ### ## (## ### + ## ## Join)
*&---------------------------------------------------------------------*
FORM get_so_item.
  SELECT  a~vbeln AS zdocno, a~posnr AS zdocit, a~matnr, a~werks, a~lgort, a~kwmeng AS ordqty, a~meins,
         b~zmsno, b~zdocty, b~zavol, b~ztemp, b~zunit, b~zdens, b~zvcf, b~zsvol, b~meins AS meins_2, b~zmdat
    FROM ztb1sd0007 AS a
    LEFT OUTER JOIN ztb1mm0020 AS b ON a~vbeln = b~zdocno
                                   AND a~posnr = b~zdocit
                                   " AND b~zdocty = 'SO'
                                   AND b~lvorm <> 'X'
    APPENDING CORRESPONDING FIELDS OF TABLE @gt_volm
    FOR ALL ENTRIES IN @gt_head
   WHERE a~vbeln = @gt_head-zdocno. " SD #### ##### ## ##
ENDFORM.
*&---------------------------------------------------------------------*
*& #### ### ## (## ### + ## ## Join)
*&---------------------------------------------------------------------*
FORM get_pro_item.
  CHECK gt_head IS NOT INITIAL.

  SELECT  a~plpr AS zdocno, a~plpkn AS zdocit, a~matnr, a~poqty AS ordqty, a~meins,
         b~zmsno, b~zdocty, b~zavol, b~ztemp, b~zunit, b~zdens, b~zvcf, b~zsvol, b~meins  AS meins_2, b~zmdat
    FROM ztb1pp0014 AS a
    LEFT OUTER JOIN ztb1mm0020 AS b ON a~plpr = b~zdocno
                                   AND a~plpkn = b~zdocit
                                   " AND b~zdocty LIKE 'PrO%'
                                   AND b~lvorm <> 'X'
    APPENDING CORRESPONDING FIELDS OF TABLE @gt_volm
    FOR ALL ENTRIES IN @gt_head
   WHERE a~plpr = @gt_head-zdocno.
  " AND a~plnty = 'PROD'
  " AND a~lvorm <> 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*& FORM modify_item_data (### ## ## - ##, ####, #### ### #)
*&---------------------------------------------------------------------*
FORM modify_item_data.

  LOOP AT gt_volm ASSIGNING FIELD-SYMBOL(<fs_item>). " #### ##
    IF <fs_item>-zmsno IS INITIAL. " ## ### ### process ### gs_head process ###
      READ TABLE gt_head ASSIGNING FIELD-SYMBOL(<ls_head>)
             WITH KEY zdocno = <fs_item>-zdocno.
      IF sy-subrc = 0.
        <fs_item>-process = <ls_head>-process. " ### ## 'PO', 'SO', 'PrO'# ###
      ENDIF.
    ENDIF.

    " 1) ## ###, ## ### ## ## (## ##### # ##).
    " <fs_item>-meins_2 = <fs_item>-meins. " ## ## #### ### meins_2# ###
    IF <fs_item>-meins_2 IS NOT INITIAL. " ### ##(=#### # ### ## ##)
      <fs_item>-meins_3 = <fs_item>-meins_2. " ##### ## ### ###
    ENDIF.

    " 2) #### ### - ### #### ##. PO-1 -> PO / GR / #### # ##
    IF <fs_item>-zmsno IS NOT INITIAL.
      CASE <fs_item>-zdocty. " ##### SO, PO-1, Pro-GR ## #
        WHEN 'SO'. " ##(SO), ##(GI)
          <fs_item>-process = 'SO'. <fs_item>-movement = 'GI'.
        WHEN 'PO-1'. " ##(PO), ##(GR), ####(1)
          <fs_item>-process = 'PO'. <fs_item>-movement = 'GR'. <fs_item>-step = '1'.
        WHEN 'PO-2'. " ####(2)
          <fs_item>-process = 'PO'. <fs_item>-movement = 'GR'. <fs_item>-step = '2'.
        WHEN 'PrO-GR'. " ##(PrO)
          <fs_item>-process = 'PrO'. <fs_item>-movement = 'GR'.
        WHEN 'PrO-GI'.
          <fs_item>-process = 'PrO'. <fs_item>-movement = 'GI'.
      ENDCASE.
    ELSE.
      CASE <fs_item>-process.
        WHEN 'PO'.
          <fs_item>-movement = 'GR'. " step ### #####(### ## ### ## ##)
        WHEN 'PrO'.
          IF <fs_item>-ordqty < 0. " ### ### ### ####(##)
            <fs_item>-movement = 'GR'.
          ELSE.
            <fs_item>-movement = 'GI'. " ### ###(###, ##)
          ENDIF.
        WHEN 'SO'. " ### ##
          <fs_item>-movement = 'GI'.
      ENDCASE.
    ENDIF.

    " 3) ##: ##, ###, #### #### # select-options
    " - #### ### ##### ## ##
    " ## - ## # #### ###(SO)# #### ## ## ## - ##### #### #### ## ##
    IF ( pa_mat IS NOT INITIAL AND <fs_item>-matnr <> pa_mat ) OR
       ( <fs_item>-werks NOT IN so_wks ) OR
       ( <fs_item>-lgort NOT IN so_lgt ).
      <fs_item>-excp_fld = 'DEL'. " ### ##### ### ##
      CONTINUE.
    ENDIF.

    " 4) ### # ## ## ### ####
    PERFORM get_domain_text USING 'ZDB1_MM_TYPE1' <fs_item>-process CHANGING <fs_item>-text_p.
    PERFORM set_text_by_code USING 'M' <fs_item>-movement CHANGING <fs_item>-text_s. " ## m### ### ## ### ## ## s
    IF <fs_item>-step IS NOT INITIAL. " ## ###### ###### ## ## ### step# ## ###### ##
      PERFORM get_domain_text USING 'ZDB1_MM_TYPE3' <fs_item>-step CHANGING <fs_item>-text_s.
    ENDIF.
    " 5) ### / ## ##
    PERFORM set_item_style USING <fs_item>.
  ENDLOOP.

  " #### ### ##
  DELETE gt_volm WHERE excp_fld = 'DEL'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_item_style (### ## ## - ##, ###)
*&---------------------------------------------------------------------*
FORM set_item_style USING ps_item LIKE gs_item.
  DATA: ls_scol  TYPE lvc_s_scol.

  " 1. ## ## ## ###
  IF ps_item-zmsno IS NOT INITIAL. " ## ### ###
    ps_item-icon = icon_checked. " ### ## (##)

    READ TABLE gt_head ASSIGNING FIELD-SYMBOL(<ls_head>)
          WITH KEY zdocno = ps_item-zdocno
                   process = ps_item-process.
    IF sy-subrc = 0.
      <ls_head>-expand = 'X'. " ## ### -  #### ## ### ## ##
    ENDIF.
  ELSE.
    READ TABLE gt_head ASSIGNING FIELD-SYMBOL(<fs_head>)
           WITH KEY zdocno = ps_item-zdocno
                    process = ps_item-process. " ##### ## ### # #### ### ### ### ##
    IF sy-subrc = 0.
      <fs_head>-icon = icon_pdir_foreward. " ### ### (##)

      " 2. ## ## # ## ##
      CLEAR ls_scol.
      ls_scol-fname = 'ZDOCNO'.  " #### ## ###
      ls_scol-color-col = alv_style_color_key.     " 6: ###, 3: ### -> ##### ##
      ls_scol-color-int = 0.     " 1: ## ##
      INSERT ls_scol INTO TABLE <fs_head>-lt_scol.

      CLEAR ls_scol.
      ls_scol-fname = 'ZMSNO'.
      ls_scol-color-col = 6.       " ###
      ls_scol-color-int = 0.       " ## ##
      INSERT ls_scol INTO TABLE ps_item-lt_scol.
    ENDIF.
    ps_item-icon = icon_pdir_foreward. " ### ### (##)
  ENDIF.

  " 2. ### ## ### ## (### ##)
  CASE ps_item-movement.
    WHEN 'GR'.
      ps_item-m_icon = icon_wd_inbound_plug.  " ### ###/### ###
    WHEN 'GI'.
      ps_item-m_icon = icon_wd_outbound_plug. " ### ###/### ###
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_volm_style (###### ## ## ##)
*&---------------------------------------------------------------------*
FORM set_volm_style CHANGING pt_volm LIKE gt_volm.
  FIELD-SYMBOLS: <fs_color> TYPE lvc_s_scol.
  DATA: ls_scol TYPE lvc_s_scol.

  LOOP AT gt_volm ASSIGNING FIELD-SYMBOL(<fs_volm>).
    IF <fs_volm>-zmsno IS INITIAL.
      " #### 'ZMSNO' ###### color-col# 6# # -> ## ####
      READ TABLE <fs_volm>-lt_scol ASSIGNING <fs_color> WITH KEY fname = 'ZMSNO'.
      IF sy-subrc = 0.
        <fs_color>-color-int = '0'. " ## ##
        <fs_color>-color-col = '1'. " ### #### ## ####
      ENDIF.
      " #### 'ZDOCIT' ### ## # ### ##
      UNASSIGN <fs_color>.
      READ TABLE <fs_volm>-lt_scol ASSIGNING <fs_color> WITH KEY fname = 'ZDOCIT'.
      IF sy-subrc = 0.
        <fs_color>-color-col = '6'. " ###
        <fs_color>-color-int = '1'. " ## ##
      ELSE.
        ls_scol-fname     = 'ZDOCIT'. " else# ### -> LT_SCOL## ## ### ##### ## -> ## #####
        ls_scol-color-col = '6'.      " ###
        ls_scol-color-int = '1'.      " ## ##
        APPEND ls_scol TO <fs_volm>-lt_scol.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_object (100# ### ALV ## ##)
*&---------------------------------------------------------------------*
FORM create_object.

  CREATE OBJECT go_cont " ### #### ##
    EXPORTING
      container_name = 'VOLM'. " ### #### ### ##

  " #### ## (1# 2# #### ### cont ####)
  CREATE OBJECT go_splitter
    EXPORTING
      parent  = go_cont
      rows    = 3
      columns = 1.

  " ### ##### ## ###
  go_splitter->set_row_height( id = 1 height = 12 ).
  go_splitter->set_row_height( id = 2 height = 25 ).

  " # ## #### ####
  go_cont_1 = go_splitter->get_container( row = 1 column = 1 ).
  go_cont_2 = go_splitter->get_container( row = 2 column = 1 ).
  go_cont_3 = go_splitter->get_container( row = 3 column = 1 ).

  CREATE OBJECT go_dyndoc. " #### ## - ### ### ## ## # ##

  " ALV Grid ##(##, ###)
  CREATE OBJECT go_alv_head
    EXPORTING
      i_parent = go_cont_2.

  CREATE OBJECT go_alv_item
    EXPORTING
      i_parent = go_cont_3.

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
*& Form set_layout (ALV ## #### ##)
*&---------------------------------------------------------------------*
FORM set_layout USING pv_type TYPE i
                CHANGING ps_layout TYPE lvc_s_layo.
  CLEAR ps_layout.
  IF pv_type = 1.
    " 100# ### ## alv layout ##
    ps_layout-sel_mode   = 'B'. " # # ##
    ps_layout-cwidth_opt = 'X'. " # ## ## ###
  ELSE.
    " 200# ##### #### alv layout ##
    ps_layout-sel_mode   = 'D'. " # ## ## ##
  ENDIF.
  " ## ##
  ps_layout-info_fname = 'COL_FLD'. " # ## ## ## ##
  ps_layout-ctab_fname  = 'LT_SCOL'.  " # ## ##
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
*& (## ALV ## #### ##)
*&---------------------------------------------------------------------*
FORM set_fcat_head CHANGING ct_fcat TYPE lvc_t_fcat.
  PERFORM create_fcat TABLES ct_fcat USING:
    'S' 'FIELDNAME' 'ICON',     ' ' 'COLTEXT' '##',      ' ' 'ICON' 'X', ' ' 'OUTPUTLEN' '4', 'E' ' ' ' ',
    " 'S' 'TECH' 'X',                                         'E' ' ' ' ',
    'S'  'FIELDNAME' 'PROCESS',                             'E' ' ' ' ',
    " 'S'  'FIELDNAME' 'TEXT_P',   ' ' 'COLTEXT' '####',   ' ' 'EMPHASIZE' 'C501',         'E' ' ' ' ',
    'S'  'FIELDNAME' 'ZDOCNO',    ' ' 'COLTEXT' '####',   ' ' 'KEY' 'X', ' ' 'OUTPUTLEN' '12', 'E' ' ' ' ',
    'S'  'FIELDNAME' 'BLDAT',     ' ' 'COLTEXT' '###',     ' ' 'OUTPUTLEN' '10',           'E' ' ' ' ',
    'S'  'FIELDNAME' 'BPID',      ' ' 'COLTEXT' '###',     ' ' 'OUTPUTLEN' '10',           'E' ' ' ' '.
ENDFORM.
*&---------------------------------------------------------------------*
*& (### ALV ## #### ##)
*&---------------------------------------------------------------------*
FORM set_fcat_item CHANGING ct_fcat TYPE lvc_t_fcat.
  PERFORM create_fcat TABLES ct_fcat USING:
    'S'  'FIELDNAME' 'ICON',     ' ' 'COLTEXT' '##',      ' ' 'ICON' 'X', ' ' 'OUTPUTLEN' '4', 'E' ' ' ' ',
    'S'  'FIELDNAME' 'M_ICON',   ' ' 'COLTEXT' '##',      ' ' 'ICON' 'X', ' ' 'OUTPUTLEN' '4', 'E' ' ' ' ',
    "'S'  'FIELDNAME' 'LT_SCOL',   ' ' 'TECH' 'X',                                         'E' ' ' ' ',
    'S'  'FIELDNAME' 'ZDOCNO',      ' ' 'COLTEXT' '####',   ' ' 'KEY' 'X',   'E' ' ' ' ',
    'S'  'FIELDNAME' 'ZDOCIT',    ' ' 'COLTEXT' '##',      ' ' 'KEY' 'X', ' ' 'OUTPUTLEN' '5',  'E' ' ' ' ',
    'S'  'FIELDNAME' 'TEXT_S',    ' ' 'COLTEXT' '##',      ' ' 'OUTPUTLEN' '6',           'E' ' ' ' ',
    'S'  'FIELDNAME' 'MATNR',     ' ' 'COLTEXT' '####',   ' ' 'OUTPUTLEN' '12',           'E' ' ' ' ',
    'S'  'FIELDNAME' 'WERKS',     ' ' 'COLTEXT' '###',     ' ' 'OUTPUTLEN' '6',           'E' ' ' ' ',
    'S'  'FIELDNAME' 'LGORT',     ' ' 'COLTEXT' '####',       ' ' 'OUTPUTLEN' '6',           'E' ' ' ' ',
    'S'  'FIELDNAME' 'ORDQTY',    ' ' 'COLTEXT' '####',   ' ' 'QFIELDNAME' 'MEINS',       'E' ' ' ' ',
    'S'  'FIELDNAME' 'MEINS',     ' ' 'COLTEXT' '##',       ' ' 'OUTPUTLEN' '4',           'E' ' ' ' ',
    'S'  'FIELDNAME' 'ZAVOL',     ' ' 'COLTEXT' '####',   ' ' 'QFIELDNAME' 'MEINS_2', ' ' 'NO_ZERO' 'X', 'E' ' ' ' ', " ## 0## ## NO_ZERO
    'S'  'FIELDNAME' 'MEINS_2',   ' ' 'COLTEXT' '##',       ' ' 'OUTPUTLEN' '4',           'E' ' ' ' ',
    'S'  'FIELDNAME' 'ZSVOL',     ' ' 'COLTEXT' '####',   ' ' 'QFIELDNAME' 'MEINS_3', ' ' 'NO_ZERO' 'X', 'E' ' ' ' ',
    'S'  'FIELDNAME' 'MEINS_3',   ' ' 'COLTEXT' '##',       ' ' 'OUTPUTLEN' '4',           'E' ' ' ' ',
    'S'  'FIELDNAME' 'ZMSNO',     ' ' 'COLTEXT' '####',   ' ' 'OUTPUTLEN' '10', ' ' 'EMPHASIZE' 'C700', 'E' ' ' ' ',
    'S'  'FIELDNAME' 'ZMDAT',     ' ' 'COLTEXT' '###',     ' ' 'OUTPUTLEN' '10',           'E' ' ' ' '.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_fcat_hier (Field Catalog ### ## - ###)
*&---------------------------------------------------------------------*
FORM create_fcat_hier TABLES tt_fcat TYPE slis_t_fieldcat_alv  " ### ## ### ### (gt_fcat)
                  USING  pv_stat                  " ## ###: 'S'(##), ' '(##), 'E'(##/##)
                         pv_fnam                  " ## ## (#: 'FIELDNAME', 'COLTEXT')
                         pv_fval.                 " ## #   (#: 'MATNR', '####')
  FIELD-SYMBOLS: <fld> TYPE any.
  STATICS: ls_fcat TYPE slis_fieldcat_alv.   " STATICS: ## ###
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
*& set_fcat (#### ## #### ##)
*&---------------------------------------------------------------------*
FORM set_fcat CHANGING ct_fcat TYPE slis_t_fieldcat_alv.
  PERFORM create_fcat_hier TABLES ct_fcat USING:
    'S' 'TABNAME'  'GT_HVOLM',   ' ' 'FIELDNAME' 'ICON',     ' ' 'COLTEXT' '##',      ' ' 'ICON' 'X', ' ' 'OUTPUTLEN' '4', 'E' ' ' ' ',
    " 'S' 'TABNAME'  'GT_HVOLM',   ' ' 'FIELDNAME' 'LT_SCOL',   ' ' 'TECH' 'X',                                         'E' ' ' ' ',
    'S' 'TABNAME'  'GT_HVOLM',   ' '  'FIELDNAME' 'PROCESS',                             'E' ' ' ' ',
    " 'S' 'TABNAME'  'GT_HVOLM',   ' '  'FIELDNAME' 'TEXT_P',   ' ' 'COLTEXT' '####',   ' ' 'EMPHASIZE' 'C501',         'E' ' ' ' ',
    'S' 'TABNAME'  'GT_HVOLM',   ' '  'FIELDNAME' 'ZDOCNO',    ' ' 'COLTEXT' '####',   ' ' 'KEY' 'X', ' ' 'OUTPUTLEN' '12', 'E' ' ' ' ',
    'S' 'TABNAME'  'GT_HVOLM',   ' '  'FIELDNAME' 'BLDAT',     ' ' 'COLTEXT' '###',     ' ' 'OUTPUTLEN' '10',           'E' ' ' ' ',
    'S' 'TABNAME'  'GT_HVOLM',   ' '  'FIELDNAME' 'BPID',      ' ' 'COLTEXT' '###',     ' ' 'OUTPUTLEN' '10',           'E' ' ' ' ',
" ###
    'S' 'TABNAME'  'GT_VOLM',   ' '  'FIELDNAME' 'ICON',     ' ' 'COLTEXT' '##',      ' ' 'ICON' 'X', ' ' 'OUTPUTLEN' '4', 'E' ' ' ' ',
    'S' 'TABNAME'  'GT_VOLM',   ' '  'FIELDNAME' 'M_ICON',   ' ' 'COLTEXT' '##',      ' ' 'ICON' 'X', ' ' 'OUTPUTLEN' '4', 'E' ' ' ' ',
    "'S' 'TABNAME'  'GT_VOLM',   ' '  'FIELDNAME' 'LT_SCOL',   ' ' 'TECH' 'X',                                         'E' ' ' ' ',
    'S' 'TABNAME'  'GT_VOLM',   ' '  'FIELDNAME' 'ZDOCNO',    ' ' 'NO_OUT' 'X',   " ### #### ##### NO_OUT                                      'E' ' ' ' ',
    'S' 'TABNAME'  'GT_VOLM',   ' '  'FIELDNAME' 'ZDOCIT',    ' ' 'COLTEXT' '##',      ' ' 'KEY' 'X', ' ' 'OUTPUTLEN' '5',  'E' ' ' ' ',
    'S' 'TABNAME'  'GT_VOLM',   ' '  'FIELDNAME' 'TEXT_S',    ' ' 'COLTEXT' '##',      ' ' 'OUTPUTLEN' '6',           'E' ' ' ' ',
    'S' 'TABNAME'  'GT_VOLM',   ' '  'FIELDNAME' 'MATNR',     ' ' 'COLTEXT' '####',   ' ' 'OUTPUTLEN' '12',           'E' ' ' ' ',
    'S' 'TABNAME'  'GT_VOLM',   ' '  'FIELDNAME' 'WERKS',     ' ' 'COLTEXT' '###',     ' ' 'OUTPUTLEN' '6',           'E' ' ' ' ',
    'S' 'TABNAME'  'GT_VOLM',   ' '  'FIELDNAME' 'LGORT',     ' ' 'COLTEXT' '####',       ' ' 'OUTPUTLEN' '6',           'E' ' ' ' ',
    'S' 'TABNAME'  'GT_VOLM',   ' '  'FIELDNAME' 'ORDQTY',    ' ' 'COLTEXT' '####',   ' ' 'QFIELDNAME' 'MEINS',       'E' ' ' ' ',
    'S' 'TABNAME'  'GT_VOLM',   ' '  'FIELDNAME' 'MEINS',     ' ' 'COLTEXT' '##',       ' ' 'OUTPUTLEN' '4',           'E' ' ' ' ',
    'S' 'TABNAME'  'GT_VOLM',   ' '  'FIELDNAME' 'ZAVOL',     ' ' 'COLTEXT' '####',   ' ' 'QFIELDNAME' 'MEINS_2', ' ' 'NO_ZERO' 'X', 'E' ' ' ' ', " ## 0## ## NO_ZERO
    'S' 'TABNAME'  'GT_VOLM',   ' '  'FIELDNAME' 'MEINS_2',   ' ' 'COLTEXT' '##',       ' ' 'OUTPUTLEN' '4',           'E' ' ' ' ',
    'S' 'TABNAME'  'GT_VOLM',   ' '  'FIELDNAME' 'ZSVOL',     ' ' 'COLTEXT' '####',   ' ' 'QFIELDNAME' 'MEINS_3', ' ' 'NO_ZERO' 'X', 'E' ' ' ' ',
    'S' 'TABNAME'  'GT_VOLM',   ' '  'FIELDNAME' 'MEINS_3',   ' ' 'COLTEXT' '##',       ' ' 'OUTPUTLEN' '4',           'E' ' ' ' ',
    'S' 'TABNAME'  'GT_VOLM',   ' '  'FIELDNAME' 'ZMSNO',     ' ' 'COLTEXT' '####',   ' ' 'OUTPUTLEN' '10', ' ' 'EMPHASIZE' 'C110', 'E' ' ' ' ',
    'S' 'TABNAME'  'GT_VOLM',   ' '  'FIELDNAME' 'ZMDAT',     ' ' 'COLTEXT' '###',     ' ' 'OUTPUTLEN' '10',           'E' ' ' ' '.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout_hier (#### ALV ## #### ##)
*&---------------------------------------------------------------------*
FORM set_layout_hier USING pv_type TYPE i
                     CHANGING ps_layout TYPE slis_layout_alv. " ## layo ## ##
  CLEAR ps_layout.
  IF pv_type = 1.
    ps_layout-zebra             = 'X'.      " ###
    ps_layout-colwidth_optimize = 'X'.      " # ## ## ### (## cwidth_opt)
  ENDIF.

  ps_layout-window_titlebar   = '## ## ## (###)'.
  ps_layout-info_fieldname    = 'COL_FLD'. " # ## ## (C110)
  ps_layout-coltab_fieldname  = 'LT_SCOL'.  " # ## ##
  " ps_layout-box_fieldname     = 'SEL'.    " ## ## ## #### ## ###

  ps_layout-expand_all        = space.      " ## ### -> ### #### ### ###
  ps_layout-expand_fieldname  = 'EXPAND'. " ##/## ## ## ##

ENDFORM.
**&---------------------------------------------------------------------*
**& Form set_uifunc (ALV ## ## ## ## ##)
**&---------------------------------------------------------------------*
*FORM set_uifunc USING pv_type TYPE i
*                      pt_uifunc  TYPE ui_functions.
*  REFRESH pt_uifunc.
*  IF pv_type = 1.
*    " 100# ### ALV ui function ## -> ## # ## ## X
*  ELSE.
*    " 200# ##### #### ui function ##
*  ENDIF.
*  " ## ##
**    APPEND cl_gui_alv_grid=>mc_fc_excl_all TO pt_uifunc. " ## # ###
*ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_uifunc_hier (#### ALV ## #### ## ##)
*&---------------------------------------------------------------------*
FORM set_uifunc_hier CHANGING ct_extab TYPE slis_t_extab.

  DATA: ls_extab TYPE slis_extab.
  REFRESH ct_extab.
  " ls_extab-fcode = '&STATS'.  " #### ## ## #### ## #### (###)
  " APPEND ls_extab TO ct_extab.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_hierarchy (#### ##)
*&---------------------------------------------------------------------*
FORM display_hierarchy.

  " ## ##
  PERFORM set_uifunc_hier CHANGING gt_extab.
  gs_keyinfo-header01 = 'ZDOCNO'.
  gs_keyinfo-item01   = 'ZDOCNO'.
  gs_keyinfo-header02 = 'PROCESS'.
  gs_keyinfo-item02   = 'PROCESS'.

  " 3. #### ### ### (Container ## ## ##)
  CALL FUNCTION 'REUSE_ALV_HIERSEQ_LIST_DISPLAY'
    EXPORTING
      i_callback_program    = sy-repid
      is_layout             = gs_layout_hier   " #### ####
      it_fieldcat           = gt_fcat
      i_tabname_header      = 'GT_HVOLM'
      i_tabname_item        = 'GT_VOLM'        " ### ### ####
      is_keyinfo            = gs_keyinfo
      it_excluding          = gt_extab         " ## ##
      i_save                = 'A'              " #### ## ##
      is_variant            = gs_variant
      " ## #### -> #### #### #
      i_screen_start_column = 25   " ## ## ## ##
      i_screen_start_line   = 5    " ## ## ## ##
      i_screen_end_column   = 145  " ## # ## ##
      i_screen_end_line     = 30   " ## # ## ##
    TABLES
      t_outtab_header       = gt_hvolm
      t_outtab_item         = gt_volm
    EXCEPTIONS
      program_error         = 1
      OTHERS                = 2.

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
*& Form set_text_by_code (### FV ### - #### ## #### ### ####)
*&---------------------------------------------------------------------*
FORM set_text_by_code USING    pv_type  TYPE c  " ## ## (P:####, M:###, S:##)
                               pv_code  TYPE any
                      CHANGING cv_text  TYPE char20.
  DATA: lv_desc TYPE string.
  CASE pv_type.
    WHEN 'P'. " PROCESS (####)
      CASE pv_code.
        WHEN 'PO'.
          lv_desc = '####'.
        WHEN 'SO'.
          lv_desc = '####'.
        WHEN 'PRO'.
          lv_desc = '####'.
      ENDCASE.
    WHEN 'M'. " MOVEMENT (### ##)
      CASE pv_code.
        WHEN 'GR'.
          lv_desc = '##'.
        WHEN 'GI'.
          lv_desc = '##'.
      ENDCASE.
    WHEN 'S'. " STEP (##)
      CASE pv_code.
        WHEN '1'.
          lv_desc = '####'.
        WHEN '2'.
          lv_desc = '####'.
      ENDCASE.
  ENDCASE.
  cv_text = lv_desc.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form  set_display_info (100# ### ## ## ### ##)
*&---------------------------------------------------------------------*
FORM set_display_info.
  DATA: lv_lgtt_low  TYPE char20, " #### ### ## ##/# ## ### #
        lv_lgtt_high TYPE char20, " ## #### ##
        lv_low_ext   TYPE char10,
        lv_high_ext  TYPE char10.

  "  #### SO/PO/PrO -> ####/####/####
  IF pa_typ IS NOT INITIAL.
    gv_typ = pa_typ.
    PERFORM get_domain_text USING 'ZDB1_MM_TYPE1' gv_typ CHANGING gv_typt.
  ELSE.
    " gv_typt = 'ALL'.
  ENDIF.
  gv_mat = pa_mat. " ## ## - ##
  IF gv_mat IS NOT INITIAL.
    SELECT SINGLE maktx INTO gv_matt FROM ztb1mm0002 " ## ## - ###
     WHERE matnr = gv_mat AND spras = '3'. " sy-langu.
  ELSE.
    " gv_mat = 'ALL'.
  ENDIF.
  " 20260420 YYYYMMDD ### ## ### YYYY-MM-DD# ##
  WRITE so_dat-low TO lv_low_ext.
  WRITE so_dat-high TO lv_high_ext.
  PERFORM combine_range_text USING lv_low_ext lv_high_ext CHANGING gv_dat. " ####

  " ####
*  PERFORM combine_range_text USING so_lgt-low so_lgt-high CHANGING gv_lgt.
*  PERFORM get_domain_text USING 'ZDB1_MM_LGORT' so_lgt-low CHANGING lv_lgtt_low. " ##### #### #### #### #.
*  PERFORM get_domain_text USING 'ZDB1_MM_LGORT' so_lgt-high CHANGING lv_lgtt_high. " ##### #### ###
*  PERFORM combine_range_text USING lv_lgtt_low lv_lgtt_high CHANGING gv_lgtt. " #### ### ###

  " ###
  PERFORM combine_range_text USING so_doc-low so_doc-high CHANGING gv_doc. " ####
  PERFORM combine_range_text USING so_wks-low so_wks-high CHANGING gv_wks. " ###
  PERFORM combine_range_text USING so_lgt-low so_lgt-high CHANGING gv_lgtt.
ENDFORM.
*&---------------------------------------------------------------------*
*& FORM combine_range_text (### 'A - B' ### #### ###)
*&---------------------------------------------------------------------*
FORM combine_range_text USING pv_low pv_high CHANGING pv_text.
  CLEAR pv_text.
  IF pv_low IS NOT INITIAL AND pv_high IS NOT INITIAL. " #### ## ## ## ###
    CONCATENATE pv_low '-' pv_high INTO pv_text SEPARATED BY space. " ' '### ####### BY SPACE ## ##
  ELSEIF pv_low IS NOT INITIAL. " low# ## ## low ### ##
    pv_text = pv_low.
  ELSE.
    " pv_text = 'ALL'. " # #: high# ###
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& ### ## ## #### ## ##
*&---------------------------------------------------------------------*
FORM display_info_text.
  go_dyndoc->initialize_document( ). " ###
  " ##
  go_dyndoc->add_text( text = '## ## ## ##' sap_style = 'HEADING' ).
  go_dyndoc->new_line( ). " ###

  go_dyndoc->add_text( text = |## ##: { gv_typt } | ).
  go_dyndoc->add_text( text = | / ##: { gv_matt } { gv_mat }| ).
  go_dyndoc->add_text( text = |/ ## ##: { gv_doc }| ).
  go_dyndoc->new_line( ).

  go_dyndoc->add_text( text = |## ##: { gv_dat }| ).
  go_dyndoc->add_text( text = | / ### # ## ##: { gv_wks } ({ gv_lgtt })| ).

  " ##### #### ###
  go_dyndoc->merge_document( ).
  go_dyndoc->display_document( parent = go_cont_1 ).
ENDFORM.

FORM X_display_process_flow_X. " ##

*  APPEND '<html><body style="background-color:#F2F2F2; font-family:Arial; font-size:12px;">' TO gt_html.
*  APPEND '<div style="padding:10px;">' TO gt_html.
*
*  " ## ##
*  APPEND '<a href="SAPEVENT:ORDER_CLICK" style="text-decoration:none;">' TO gt_html.
*  APPEND '  <span style="font-size:20px;">@0H@</span> [##]' TO gt_html.
*  APPEND '</a>' TO gt_html.
*
*  APPEND '  <span style="color:#999;">----------------></span>  ' TO gt_html.
*
*  " #### ##
*  APPEND '<a href="SAPEVENT:VOLUME_CLICK" style="text-decoration:none;">' TO gt_html.
*  APPEND '  <span style="font-size:20px;">@0J@</span> [####]' TO gt_html.
*  APPEND '</a>' TO gt_html.
*
*  APPEND '  <span style="color:#999;">----------------></span>  ' TO gt_html.
*
*  " ### ##
*  APPEND '<a href="SAPEVENT:POST_CLICK" style="text-decoration:none;">' TO gt_html.
*  APPEND '  <span style="font-size:20px;">@0H@</span> [###]' TO gt_html.
*  APPEND '</a>' TO gt_html.
*
*  APPEND '</div></body></html>' TO gt_html.
*
*  " ### ## (### ## ##)
*  DATA: lt_events TYPE cntl_simple_events,
*        ls_event  TYPE cntl_simple_event.
*
*  ls_event-eventid = cl_gui_html_viewer=>m_id_sapevent.
*  ls_event-appl_event = 'X'.
*  APPEND ls_event TO lt_events.
*
*  go_html_viewer->set_registered_events( events = lt_events ).
*  SET HANDLER lcl_event_handler=>sap_event FOR go_html_viewer.

ENDFORM.
*&---------------------------------------------------------------------*
*& ### ## ## #### ## ##
*&---------------------------------------------------------------------*
FORM display_process_flow.
  DATA: lo_table     TYPE REF TO cl_dd_table_element,
        lo_col1      TYPE REF TO cl_dd_area, lo_col2  TYPE REF TO cl_dd_area,
        lo_col3      TYPE REF TO cl_dd_area, lo_col4  TYPE REF TO cl_dd_area,
        lo_col5      TYPE REF TO cl_dd_area, lo_col6  TYPE REF TO cl_dd_area,
        lo_col7      TYPE REF TO cl_dd_area,
        lv_step1_txt TYPE sdydo_text_element,
        lv_step2_txt TYPE sdydo_text_element,
        lv_step4_txt TYPE sdydo_text_element.

  " ## 7## ##### ## / ## / ## # # ## ### #### ##
  CASE gv_current_process.
    WHEN 'PO'.  " ##### #
      lv_step1_txt = '[#######]'.
      lv_step2_txt = '[####]'.
      lv_step4_txt = '[##]'.

    WHEN 'PrO'. " ##### #
      lv_step1_txt = '[####]'.
      lv_step2_txt = '[####]'.
      lv_step4_txt = '[###]'.

    WHEN 'SO'.  " ##### #
      lv_step1_txt = '[####]'.
      lv_step4_txt = '[##]'.
    WHEN OTHERS.
      lv_step1_txt = '[##]'.
      lv_step4_txt = '[###]'.
  ENDCASE.

*  " ### ##
  go_doc->add_table( EXPORTING no_of_columns = 7
                               border        = '0'
                               width         = '100%'
                     IMPORTING table     = lo_table ).

  IF gv_current_process = 'PO' OR gv_current_process = 'PrO' .
    " ## ##
    lo_table->add_column( EXPORTING width = '23.5%' IMPORTING column = lo_col1 ).
    lo_col1->add_gap( width = 20 ).
    IF gv_has_plan = 'X'.
      lo_col1->add_icon( sap_icon = 'ICON_GREEN_LIGHT' ).
      lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_col2 ). " ## ## ##
      lo_col2->add_icon( sap_icon = 'ICON_PDIR_FOREWARD' ).
    ELSE.
      lo_col1->add_icon( sap_icon = 'ICON_LIGHT_OUT' ).
      lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_col2 ).
      lo_col2->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).
    ENDIF.

    " ## ##
    lo_table->add_column( EXPORTING width = '23.5%' IMPORTING column = lo_col3 ).
    lo_col3->add_gap( width = 20 ).
    IF gv_has_order = 'X'.
      lo_col3->add_icon( sap_icon = 'ICON_GREEN_LIGHT' ).
      lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_col4 ). " ## ## ##
      lo_col4->add_icon( sap_icon = 'ICON_PDIR_FOREWARD' ).
    ELSE.
      lo_col3->add_icon( sap_icon = 'ICON_LIGHT_OUT' ).
      lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_col4 ).
      lo_col4->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).
    ENDIF.

    " #### ##
    lo_table->add_column( EXPORTING width = '23.5%' IMPORTING column = lo_col5 ).
    lo_col5->add_gap( width = 20 ).
    IF gv_has_volume = 'X'.
      lo_col5->add_icon( sap_icon = 'ICON_GREEN_LIGHT' ).
      lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_col6 ). " ## ## ##
      lo_col6->add_icon( sap_icon = 'ICON_PDIR_FOREWARD' ).
    ELSE.
      lo_col5->add_icon( sap_icon = 'ICON_LIGHT_OUT' ).
      lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_col6 ).
      lo_col6->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).
    ENDIF.


    " ### ##
    lo_table->add_column( EXPORTING width = '23.5%' IMPORTING column = lo_col7 ).
    lo_col7->add_gap( width = 20 ).
    IF gv_has_post = 'X'.
      lo_col7->add_icon( sap_icon = 'ICON_GREEN_LIGHT' ).
    ELSE.
      lo_col7->add_icon( sap_icon = 'ICON_LIGHT_OUT' ).
    ENDIF.

    lo_table->new_row( ). " ###
    lo_col1->add_gap( width = 15 ).
    lo_col1->add_link( name = 'PLAN'   text = lv_step1_txt ).
    lo_col2->add_text( text = ' ' ).
    lo_col3->add_gap( width = 15 ).
    lo_col3->add_link( name = 'ORDER'  text = lv_step2_txt ).
    lo_col4->add_text( text = ' ' ).
    lo_col5->add_gap( width = 15 ).
    lo_col5->add_link( name = 'VOLUME' text = '[####]' ).
    lo_col6->add_text( text = ' ' ).
    lo_col7->add_gap( width = 15 ).
    lo_col7->add_link( name = 'POST'   text =  lv_step4_txt ).
  ELSE.
    lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_col1 ).

    " [## ##]
    lo_table->add_column( EXPORTING width = '30%' IMPORTING column = lo_col2 ).
    lo_col2->add_gap( width = 25 ).
    IF gv_has_order = 'X'.
      lo_col2->add_icon( sap_icon = 'ICON_GREEN_LIGHT' ).
      lo_table->add_column( EXPORTING width = '3%' IMPORTING column = lo_col3 ). " ## ## ##
      lo_col3->add_icon( sap_icon = 'ICON_PDIR_FOREWARD' ).
    ELSE.
      lo_col2->add_icon( sap_icon = 'ICON_LIGHT_OUT' ).
      lo_table->add_column( EXPORTING width = '3%' IMPORTING column = lo_col3 ).
      lo_col3->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).
    ENDIF.


    " [#### ##]
    lo_table->add_column( EXPORTING width = '30%' IMPORTING column = lo_col4 ).
    lo_col4->add_gap( width = 25 ).
    IF gv_has_volume = 'X'.
      lo_col4->add_icon( sap_icon = 'ICON_GREEN_LIGHT' ).
      lo_table->add_column( EXPORTING width = '3%' IMPORTING column = lo_col5 ). " ## ## ##
      lo_col5->add_icon( sap_icon = 'ICON_PDIR_FOREWARD' ).
    ELSE.
      lo_col4->add_icon( sap_icon = 'ICON_LIGHT_OUT' ).
      lo_table->add_column( EXPORTING width = '3%' IMPORTING column = lo_col5 ).
      lo_col5->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).
    ENDIF.


    " [### ##]
    lo_table->add_column( EXPORTING width = '30%' IMPORTING column = lo_col6 ).
    lo_col6->add_gap( width = 25 ).
    IF gv_has_post = 'X'.
      lo_col6->add_icon( sap_icon = 'ICON_GREEN_LIGHT' ).
    ELSE.
      lo_col6->add_icon( sap_icon = 'ICON_LIGHT_OUT' ).
    ENDIF.
    lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_col7 ).

    lo_table->new_row( ). " ###

    lo_col2->add_gap( width = 25 ).
    lo_col2->add_link( name = 'ORDER' text =  lv_step1_txt  ).
    lo_col3->add_text( text = ' ' ).
    lo_col4->add_gap( width = 20 ).
    lo_col4->add_link( name = 'VOLUME' text = '[####]' ).
    lo_col5->add_text( text = ' ' ).
    lo_col6->add_gap( width = 25 ).
    lo_col6->add_link( name = 'POST' text =  lv_step4_txt  ).
  ENDIF.
  " ### ##(##)
*  lo_table->set_row_style( row_no  = 1   sap_style = 'SUCCESS' ). " sap_fontsize = 'LARGE'
*  lo_table->set_row_style( row_no  = 2   sap_style = 'HEADING' ).

  go_doc->merge_document( ).
  go_doc->display_document( parent = go_cont_doc ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form clear_detail_data
*&---------------------------------------------------------------------*
FORM clear_detail_data .
  CLEAR: gv_has_plan, gv_has_order, gv_has_volume, gv_has_post.
  FREE: gt_so_h, gt_so_i, gt_vol_i, gt_mat_h, gt_mat_i,
        gt_po_h, gt_po_i, gt_pro_h, gt_pro_i,
        gs_po_opt, gt_po_opt, gs_pln_h, gt_pln_i.
ENDFORM.

FORM get_full_process_so USING pv_vbeln.
  " [1##: Order] - ### ##
  SELECT SINGLE vbeln vkorg vtweg sotyp bpid ordda vdatu pldda soldt shipt zterm inco1 taxcl taxty sosta
    FROM ztb1sd0006 INTO CORRESPONDING FIELDS OF gs_so_h WHERE vbeln = pv_vbeln.
  SELECT vbeln posnr werks lgort spart matnr kwmeng netpr meins netvl waers
    FROM ztb1sd0007 INTO CORRESPONDING FIELDS OF TABLE gt_so_i WHERE vbeln = pv_vbeln.
  gv_has_order = 'X'.

  " [2##: Volume] - ##### ## ### ##
  SELECT zmsno zdocty zdocno zdocit zavol ztemp zunit zdens zvcf zsvol meins zmdat
    FROM ztb1mm0020 INTO CORRESPONDING FIELDS OF TABLE gt_vol_i WHERE zdocno = pv_vbeln.

  IF gt_vol_i[] IS NOT INITIAL. " ## ### ### -> ### ##
    gv_has_volume = 'X'.
    READ TABLE gt_vol_i INTO gs_vol_i INDEX 1. " # ## ## #### ##
  ENDIF.

  " [3##: Post] - ###### #### ## -> ###### ###
  DATA: lt_delivery TYPE TABLE OF ztb1sd0008.

  " 1) ## ## ##(VBELN_VA)# ## ## ##(VBELN) ##
  SELECT vbeln vbeln_va FROM ztb1sd0008
    INTO CORRESPONDING FIELDS OF TABLE lt_delivery
    WHERE vbeln_va = pv_vbeln.

  IF lt_delivery[] IS NOT INITIAL.
    " 2) ## ## ## #### ###### ### ##
    SELECT mblnr mjahr bldat budat bukrs bktxt vbeln plpr ebeln vgart
      FROM ztb1mm0011
      INTO CORRESPONDING FIELDS OF TABLE gt_mat_h
      FOR ALL ENTRIES IN lt_delivery
      WHERE vbeln = lt_delivery-vbeln.
    IF sy-subrc = 0.
      gv_has_post = 'X'. " 3) ###### ## ### -> ### ##

      IF gt_mat_h[] IS NOT INITIAL.
        READ TABLE gt_mat_h INTO gs_mat_h INDEX 1. " # ## ## #### ##
      ENDIF.
      " 4) ##### ###
      SELECT mblnr mjahr zeile matnr werks lgort bwart menge meins netpr dmbtr waersk wrbtr waers
        insmk zloss kostl kokrs vbeln posnr plpr ebeln ebelp
        FROM ztb1mm0012 INTO CORRESPONDING FIELDS OF TABLE gt_mat_i FOR ALL ENTRIES IN gt_mat_h WHERE vbeln = gt_mat_h-vbeln.
    ENDIF.
  ENDIF.
ENDFORM.

FORM get_full_process_po USING pv_ebeln.
  " [1##: Order] - ### ##
  SELECT SINGLE ebeln bpid ekorg ekgrp bukrs bsart bedat zterm inco1 zebeln zebelnsv knumh
    FROM ztb1mm0006 INTO CORRESPONDING FIELDS OF gs_po_h WHERE ebeln = pv_ebeln.

  SELECT ebeln ebelp matnr werks lgort menge meins netpr dmbtr waersk
    wrbtr waers mwskz eindt slfdt insmk packno knttp sakto epstp postat
    FROM ztb1mm0007 INTO CORRESPONDING FIELDS OF TABLE gt_po_i WHERE ebeln = pv_ebeln.
  gv_has_order = 'X'.

  " [0## - ## ### ##] ##### #### ####
  IF gs_po_h-knumh IS NOT INITIAL.
    SELECT knumh bpid matnr datab datbi herkl plifz meins waers netpr zfrt mwskz zoth zgrm zsel
      FROM ztb1mm0005
      INTO CORRESPONDING FIELDS OF TABLE gt_po_opt
      WHERE knumh = gs_po_h-knumh.
    IF sy-subrc = 0.
      gv_has_plan = 'X'. " ### ### #### ### ON
      READ TABLE gt_po_opt INTO gs_po_opt INDEX 1. " # ## ### #### ##
    ENDIF.
  ENDIF.

  " [2##: Volume] - ##### ## ### ##
  SELECT zmsno zdocty zdocno zdocit zavol ztemp zunit zdens zvcf zsvol meins zmdat
    FROM ztb1mm0020 INTO CORRESPONDING FIELDS OF TABLE gt_vol_i WHERE zdocno = pv_ebeln.

  IF gt_vol_i[] IS NOT INITIAL. " ## ### ### -> ### ##
    gv_has_volume = 'X'.
    READ TABLE gt_vol_i INTO gs_vol_i INDEX 1. " # ## ## #### ##
  ENDIF.

  " [3##: Post] - ######## ##### ###
  SELECT mblnr mjahr bldat budat bukrs bktxt vbeln plpr ebeln vgart
    FROM ztb1mm0011 INTO CORRESPONDING FIELDS OF TABLE gt_mat_h WHERE ebeln = pv_ebeln.
  IF gt_mat_h IS NOT INITIAL.
    gv_has_post = 'X'. " ###### ## ### -> ### ##

    IF gt_mat_h[] IS NOT INITIAL.
      READ TABLE gt_mat_h INTO gs_mat_h INDEX 1. " # ## ## #### ##
    ENDIF.
    " ### ITEM# #####
    SELECT mblnr mjahr zeile matnr werks lgort bwart menge meins netpr dmbtr waersk wrbtr waers
      insmk zloss kokrs kostl vbeln posnr plpr ebeln ebelp
      FROM ztb1mm0012 INTO CORRESPONDING FIELDS OF TABLE gt_mat_i FOR ALL ENTRIES IN gt_mat_h WHERE ebeln = gt_mat_h-ebeln.
  ELSE.
    FREE gt_mat_i. " ### ### #### ###
  ENDIF.
ENDFORM.

FORM get_full_process_pro USING pv_plpr.
  " [1##: Order] - ### ##
  SELECT SINGLE plpr plnty werks matnr orqty orunt
       sdate pedat edate plnve stlnr bomve plnnr remark
    FROM ztb1pp0013 INTO CORRESPONDING FIELDS OF gs_pro_h WHERE plpr = pv_plpr AND plnty = 'PROD'.

  SELECT plpr plnty plpkn plnnr plpkn vornr
       matnr poqty meins datuv remark
    FROM ztb1pp0014 INTO CORRESPONDING FIELDS OF TABLE gt_pro_i WHERE plpr = pv_plpr AND plnty = 'PROD'.
  gv_has_order = 'X'.

  " [0## - ####(PLAN)] ##### #### ###
  SELECT SINGLE plpr plnty werks matnr orqty orunt sdate pedat edate plnve stlnr bomve plnnr remark
    FROM ztb1pp0013
    INTO CORRESPONDING FIELDS OF gs_pln_h  " ### ## ###
    WHERE plpr = pv_plpr AND plnty = 'PLAN'.

  IF sy-subrc = 0.
    gv_has_plan = 'X'. " ## #### #### ### ON
    " #### ###
    SELECT plpr plnty plpkn plnnr plpkn vornr matnr poqty meins datuv remark
      FROM ztb1pp0014
      INTO CORRESPONDING FIELDS OF TABLE gt_pln_i " ### ### ###
      WHERE plpr = pv_plpr AND plnty = 'PLAN'.
  ENDIF.

  " [2##: Volume] - ##### ## ### ##
  SELECT zmsno zdocty zdocno zdocit zavol ztemp zunit zdens zvcf zsvol meins zmdat
    FROM ztb1mm0020 INTO CORRESPONDING FIELDS OF TABLE gt_vol_i WHERE zdocno = pv_plpr.

  IF gt_vol_i[] IS NOT INITIAL. " ## ### ### -> ### ##
    gv_has_volume = 'X'.
    READ TABLE gt_vol_i INTO gs_vol_i INDEX 1. " # ## ## #### ##
  ENDIF.

  " [3##: Post] - ######## ##### ###
  SELECT mblnr mjahr bldat budat bukrs bktxt vbeln plpr ebeln vgart
    FROM ztb1mm0011 INTO CORRESPONDING FIELDS OF TABLE gt_mat_h WHERE plpr = pv_plpr.
  IF gt_mat_h IS NOT INITIAL.
    gv_has_post = 'X'. " ###### ## ### -> ### ##

    IF gt_mat_h[] IS NOT INITIAL.
      READ TABLE gt_mat_h INTO gs_mat_h INDEX 1. " # ## ## #### ##
    ENDIF.
    " ### ITEM# #####
    SELECT mblnr mjahr zeile matnr werks lgort bwart menge meins netpr dmbtr waersk wrbtr waers
      insmk zloss kokrs kostl vbeln posnr plpr ebeln ebelp
      FROM ztb1mm0012 INTO CORRESPONDING FIELDS OF TABLE gt_mat_i FOR ALL ENTRIES IN gt_mat_h WHERE plpr = gt_mat_h-plpr.
  ELSE.
    FREE gt_mat_i. " ### ### #### ###
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_order_screen
*&---------------------------------------------------------------------*
FORM handle_order_screen.
  " ## ### ### ##(SO/PO/PRO)# ## ##### ## ##
  CASE gv_current_process. " #### # #### #### ## (SO, PO, PrO)
    WHEN 'SO'.
      gv_dynnr = '0110'.
    WHEN 'PO'.
      gv_dynnr = '0120'.
    WHEN 'PrO'.
      gv_dynnr = '0130'.
    WHEN OTHERS.
      gv_dynnr = '9000'.
  ENDCASE.
  " ## ### ## ## PBO ##
  cl_gui_cfw=>set_new_ok_code( new_code = 'REFR' ).
ENDFORM.
*&---------------------------------------------------------------------*
*& FORM display_only_alv (## ###, #### ### ## # ##)
*&---------------------------------------------------------------------*
FORM display_only_alv USING pv_area   TYPE any        " ###### Custom Control ##
                              pv_struct TYPE tabname  " ### ##
                              pt_tab    TYPE INDEX TABLE
                              po_alv   TYPE REF TO cl_gui_alv_grid
                              pt_fcat TYPE lvc_t_fcat.

  DATA: lo_cont TYPE REF TO cl_gui_custom_container.

  " ## ### ### ## #### ### ## ##
  IF po_alv IS INITIAL.
    CREATE OBJECT lo_cont
      EXPORTING
        container_name = pv_area.
    " ALV ##### ### ##
    CREATE OBJECT po_alv EXPORTING i_parent = lo_cont.
    SET HANDLER lcl_event_handler=>on_detail_double_click FOR po_alv.

    po_alv->set_table_for_first_display(
      CHANGING  it_outtab       = pt_tab
         it_fieldcatalog        = pt_fcat
         ).
  ELSE. " ## ##### ## refresh#
    po_alv->refresh_table_display( ).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& i_structure ### fcat #### ##, ##### ###
*&---------------------------------------------------------------------*
FORM set_fcat_struct USING pv_struct CHANGING pt_fcat TYPE lvc_t_fcat.
  " ### ### ### ######
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = pv_struct
    CHANGING
      ct_fieldcat      = pt_fcat.

  " ####, ##### ## ### ###
  DELETE pt_fcat WHERE fieldname = 'LVORM' OR
                       fieldname = 'ERNAM' OR fieldname = 'ERDAT' OR
                       fieldname = 'ERZET' OR fieldname = 'AENAM' OR
                       fieldname = 'AEDAT' OR fieldname = 'AEZET'.
ENDFORM.
*&---------------------------------------------------------------------*
*& FORM display_detail_alv (#### ## ## ### ### ## # ##)
*&---------------------------------------------------------------------*
FORM display_detail_alv USING pv_area   TYPE any        " ###### Custom Control ##
                              pv_h_struct TYPE tabname  " ## ### ##
                              pv_i_struct TYPE tabname  " ### ### ##
                              pt_h_tab    TYPE INDEX TABLE
                              pt_i_tab    TYPE INDEX TABLE
                              po_alv_h   TYPE REF TO cl_gui_alv_grid
                              po_alv_i   TYPE REF TO cl_gui_alv_grid
                              pt_fcat_h TYPE lvc_t_fcat
                              pt_fcat_i TYPE lvc_t_fcat.

  DATA: lo_container TYPE REF TO cl_gui_custom_container,
        lo_splitter  TYPE REF TO cl_gui_splitter_container,
        lo_cont_h    TYPE REF TO cl_gui_container,
        lo_cont_i    TYPE REF TO cl_gui_container.

  " ## ### ### ## #### ### ## ##
  IF po_alv_h IS INITIAL.
    CREATE OBJECT lo_container
      EXPORTING
        container_name = pv_area.

    CREATE OBJECT lo_splitter
      EXPORTING
        parent  = lo_container
        rows    = 2
        columns = 1.

    lo_splitter->set_row_height( id = 1 height = 30 ).

    lo_cont_h = lo_splitter->get_container( row = 1 column = 1 ).
    lo_cont_i = lo_splitter->get_container( row = 2 column = 1 ).

    " ALV ##### ### ##
    CREATE OBJECT po_alv_h EXPORTING i_parent = lo_cont_h.
    CREATE OBJECT po_alv_i EXPORTING i_parent = lo_cont_i.
    SET HANDLER lcl_event_handler=>on_detail_double_click FOR po_alv_h.
    SET HANDLER lcl_event_handler=>on_detail_double_click FOR po_alv_i.

    po_alv_h->set_table_for_first_display(
*      EXPORTING i_structure_name = pv_h_struct
      CHANGING  it_outtab       = pt_h_tab
        it_fieldcatalog         = pt_fcat_h ).

    po_alv_i->set_table_for_first_display(
*      EXPORTING i_structure_name = pv_i_struct
      CHANGING  it_outtab       = pt_i_tab
        it_fieldcatalog         = pt_fcat_i ).

  ELSE. " ## ##### ## refresh#
    po_alv_h->refresh_table_display( ).
    po_alv_i->refresh_table_display( ).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_high_only
*&---------------------------------------------------------------------*
FORM check_high_only USING p_range TYPE STANDARD TABLE
                           p_text  TYPE string.
  FIELD-SYMBOLS: <ls_line> TYPE any.
  FIELD-SYMBOLS: <lv_low>  TYPE any,
                 <lv_high> TYPE any. " ### ##### ### high# ### ##### ##

  LOOP AT p_range ASSIGNING <ls_line>.
    ASSIGN COMPONENT 'LOW'  OF STRUCTURE <ls_line> TO <lv_low>.
    ASSIGN COMPONENT 'HIGH' OF STRUCTURE <ls_line> TO <lv_high>.

    IF <lv_low> IS INITIAL AND <lv_high> IS NOT INITIAL.
      " ## ### ##: ## #### ##### ### #####'
      MESSAGE e011(zmcb1).
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_wrong_values
*&---------------------------------------------------------------------*
FORM check_wrong_values .
  DATA: lv_wrong_fields TYPE string, " ### ## ## ##
        lv_dummy_n      TYPE n LENGTH 10, " ## ###
        lv_error        TYPE abap_bool.

  " 1. ##### SO, PO, PrO# ## # -> #### ## ##### ##
  IF pa_typ IS NOT INITIAL AND pa_typ <> 'SO' AND pa_typ <> 'PO' AND pa_typ <> 'PrO'.
    lv_wrong_fields = COND #( WHEN lv_wrong_fields IS INITIAL THEN '####'
                              ELSE lv_wrong_fields && ', ####' ).
    lv_error = abap_true.
  ENDIF.

  " 2. ## ## ## # ## ##
  IF pa_mat IS NOT INITIAL.
    SELECT SINGLE matnr FROM ztb1mm0001 INTO @DATA(lv_matnr) WHERE matnr = @pa_mat.
    IF sy-subrc <> 0.
      lv_wrong_fields = COND #( WHEN lv_wrong_fields IS INITIAL THEN '####'
                                ELSE lv_wrong_fields && ', ####' ).
      lv_error = abap_true.
    ENDIF.
  ENDIF.

  " 3. #### ## ## (SO# ## #### => SO## ## # #####)
  IF so_doc[] IS NOT INITIAL.
    LOOP AT so_doc.
      " LOW# HIGH# 0123456789SO ### ### #### ####(CN) ##
      IF ( so_doc-low  IS NOT INITIAL AND so_doc-low  CN '0123456789SO' ) OR
         ( so_doc-high IS NOT INITIAL AND so_doc-high CN '0123456789SO' ).

        lv_wrong_fields = COND #( WHEN lv_wrong_fields IS INITIAL THEN '####'
                                      ELSE lv_wrong_fields && ', ####' ).
        lv_error = abap_true.
        EXIT. " ### #### ## ##
      ENDIF.
    ENDLOOP.
  ENDIF.

  " 4. ### / #### ## ##
  PERFORM check_numeric_range USING so_wks[] '###' CHANGING lv_wrong_fields lv_error.
  PERFORM check_numeric_range USING so_lgt[] '####' CHANGING lv_wrong_fields lv_error.

  " 5. ## ## ###
  IF lv_error = abap_true.
    " ### &1 &2 &3 &4 #(#) #### ####
    MESSAGE e002(zmcb1) WITH lv_wrong_fields.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_numeric_range (## ## ## ##)
*&---------------------------------------------------------------------*
FORM check_numeric_range USING p_range TYPE STANDARD TABLE
                               p_text  TYPE string
                         CHANGING c_fields TYPE string
                                  c_error  TYPE abap_bool.
  FIELD-SYMBOLS: <ls_line> TYPE any, <lv_val> TYPE any.
  DATA: lv_char TYPE char10.

  LOOP AT p_range ASSIGNING <ls_line>.
    ASSIGN COMPONENT 'LOW' OF STRUCTURE <ls_line> TO <lv_val>.

    IF <lv_val> IS NOT INITIAL.
      " 0123456789 ### ### #### ### ##
      IF <lv_val> CN '0123456789 '.
        c_error = abap_true.
        IF c_fields IS INITIAL.
          c_fields = p_text.
        ELSE.
          CONCATENATE c_fields ',' p_text INTO c_fields SEPARATED BY space.
        ENDIF.
        RETURN. " #### ## ### ## ##
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form download_and_print_pdf ( PDF #### )
*&---------------------------------------------------------------------*
FORM download_and_print_pdf .
  DATA: lv_filename TYPE string,
        lv_path     TYPE string,
        lv_fullpath TYPE string,
        lv_result   TYPE i.
  lv_filename = |Document_{ gs_item-zdocno }_{ sy-datum }|.

  CALL METHOD cl_gui_frontend_services=>file_save_dialog
    EXPORTING
      default_file_name = lv_filename
      default_extension = 'pdf'
    CHANGING
      filename          = lv_filename
      path              = lv_path
      fullpath          = lv_fullpath
      user_action       = lv_result.

  IF lv_result <> cl_gui_frontend_services=>action_ok. RETURN. ENDIF.

  " ## ## (OLE)
  IF gv_excel IS INITIAL.
    CREATE OBJECT gv_excel 'EXCEL.APPLICATION'.
  ENDIF.

  SET PROPERTY OF gv_excel 'VISIBLE' = 0. " ## ### ### ##

  DATA: lv_workbooks TYPE ole2_object.

  CALL METHOD OF gv_excel 'WORKBOOKS' = lv_workbooks.
  " ADD# ##### # ###(## ## ##)# gv_workbook# ### #
  CALL METHOD OF lv_workbooks 'ADD' = gv_workbook.

  PERFORM pre_process_data. " ## ### ### ### ####
  "PERFORM fill_excel_data. " ## ## ### -> pre_ ## ### ##

  IF gv_workbook IS NOT INITIAL.
    CALL METHOD OF gv_workbook 'ExportAsFixedFormat'
      EXPORTING
        #1 = '0'              " Type 0 = PDF
        #2 = lv_fullpath      " ## ##
        #3 = '0'.             " Quality Standard

    " 4. ## ##
    CALL METHOD OF gv_workbook 'Close' EXPORTING #1 = 0. " #### ##
    CALL METHOD OF gv_excel 'Quit'.

    FREE OBJECT: gv_excel, gv_workbook.
    CLEAR: gv_excel, gv_workbook.

    MESSAGE s031(zmcb1) WITH lv_filename. " PDF ## &1# ##### #######
  ELSE.
    MESSAGE e032(zmcb1). " ## #### ## #####
  ENDIF.
ENDFORM.
*&------------------- ## ## ### ---------------------*
FORM fill_excel_data USING pv_logo_path.
  DATA: lv_text      TYPE string,
        lv_value     TYPE c LENGTH 20, " ### ### ## ## ##
        lv_column    TYPE ole2_object,
        lv_logo_path TYPE string.

*  lv_logo_path = 'https://brandlogovector.com/wp-content/uploads/2020/07/SAP-Logo.png'.
  GET PROPERTY OF gv_excel 'ActiveSheet' = gv_activesheet.

  " ##### ## ### #### ## ##
*  IF pv_logo_path IS NOT INITIAL.
*    PERFORM insert_logo USING pv_logo_path 380 10 70 35.
*  ENDIF.

  CALL METHOD OF gv_excel 'Columns' = lv_column EXPORTING #1 = 2. " 2## #
  SET PROPERTY OF lv_column 'ColumnWidth' = 20.

  CALL METHOD OF gv_excel 'Columns' = lv_column EXPORTING #1 = 3. " 3## #
  SET PROPERTY OF lv_column 'ColumnWidth' = 30.
  SET PROPERTY OF lv_column 'HorizontalAlignment' = -4131. " ## #####(### ### #### ###..)

  PERFORM fill_cells USING 2 2 '## ## # ## ## ## ###'.
  PERFORM style_cell USING 2 2 0 1." ### ##, ##

  PERFORM style_cell USING 5 2 15 1.
  PERFORM fill_cells USING 5 2 '## ##'.
  PERFORM fill_cells USING 5 3 gs_item-zdocno.
  PERFORM draw_border USING 'B5:C5'.

  PERFORM style_cell  USING 6 2 15 1.
  PERFORM fill_cells  USING 6 2 '## ##'.
  PERFORM fill_cells  USING 6 3 gs_item-zdocit.
  PERFORM draw_border USING 'B6:C6'.

  PERFORM style_cell  USING 7 2 15 1.
  PERFORM fill_cells  USING 7 2 '## ##'.
  PERFORM fill_cells  USING 7 3 gs_item-text_s.
  PERFORM draw_border USING 'B7:C7'.

  PERFORM style_cell  USING 8 2 15 1.
  PERFORM fill_cells  USING 8 2 '###/####'.
  CLEAR lv_text.
  CONCATENATE gs_item-werks '/' gs_item-lgort INTO lv_text SEPARATED BY space.
  PERFORM fill_cells  USING 8 3 lv_text.
  PERFORM draw_border USING 'B8:C8'.

  PERFORM style_cell  USING 10 2 15 1.
  PERFORM fill_cells  USING 10 2 '## ##'.
  CLEAR: lv_value, lv_text.
  WRITE gs_item-ordqty TO lv_value. CONDENSE lv_value.
  CONCATENATE lv_value gs_item-meins INTO lv_text SEPARATED BY space.
  PERFORM fill_cells  USING 10 3 lv_text.
  PERFORM draw_border USING 'B10:C10'.

  IF gs_item-zavol IS NOT INITIAL.
    PERFORM style_cell  USING 11 2 15 1.
    PERFORM fill_cells  USING 11 2 '## ##'.
    CLEAR: lv_value, lv_text.
    WRITE gs_item-zavol TO lv_value. CONDENSE lv_value.
    CONCATENATE lv_value gs_item-meins_2 INTO lv_text SEPARATED BY space.
    PERFORM fill_cells  USING 11 3 lv_text.
    PERFORM draw_border USING 'B11:C11'.
  ENDIF.

  PERFORM style_cell  USING 12 2 15 1.
  PERFORM fill_cells  USING 12 2 '## ##'.
  CLEAR: lv_value, lv_text.
  WRITE gs_item-ztemp TO lv_value. CONDENSE lv_value.
  CONCATENATE lv_value gs_item-zunit INTO lv_text SEPARATED BY space.
  PERFORM fill_cells  USING 12 3 lv_text.
  PERFORM draw_border USING 'B12:C12'.

  PERFORM style_cell  USING 13 2 15 1.
  PERFORM fill_cells  USING 13 2 '## ##'.
  CLEAR: lv_value.
  WRITE gs_item-zdens TO lv_value. CONDENSE lv_value.
  PERFORM fill_cells  USING 13 3 lv_value.
  PERFORM draw_border USING 'B13:C13'.

  PERFORM style_cell  USING 14 2 15 1.
  PERFORM fill_cells  USING 14 2 '## ##(VCF)'.
  CLEAR: lv_value.
  WRITE gs_item-zvcf TO lv_value. CONDENSE lv_value.
  PERFORM fill_cells  USING 14 3 lv_value.
  PERFORM draw_border USING 'B14:C14'.

  IF gs_item-zsvol IS NOT INITIAL.
    PERFORM style_cell  USING 15 2 15 1.
    PERFORM fill_cells  USING 15 2 '## ##'.
    CLEAR: lv_value, lv_text.
    WRITE gs_item-zsvol TO lv_value. CONDENSE lv_value.
    CONCATENATE lv_value gs_item-meins_3 INTO lv_text SEPARATED BY space.
    PERFORM fill_cells  USING 15 3 lv_text.
    PERFORM draw_border USING 'B15:C15'.
  ENDIF.

  PERFORM style_cell  USING 17 2 15 1.
  PERFORM fill_cells  USING 17 2 '## ##'.
  PERFORM fill_cells  USING 17 3 gs_item-zmsno.
  PERFORM draw_border USING 'B17:C17'.

  PERFORM style_cell  USING 18 2 15 1.
  PERFORM fill_cells  USING 18 2 '## ##'.
  PERFORM fill_cells  USING 18 3 gs_item-zmdat.
  PERFORM draw_border USING 'B18:C18'.

  " ## ### ###
  PERFORM fill_cells  USING 21 2 '## ### ### ## ### ## ## ### ###### #####.'.
  PERFORM fill_cells  USING 23 2 '###: ________________ (#)'.
ENDFORM.
*&--------------  set_fcat## ## ## ##### ##  --------------------*
FORM fill_cells USING pv_row pv_col pv_val.
  CALL METHOD OF gv_excel 'CELLS' = gv_cell
    EXPORTING
      #1 = pv_row
      #2 = pv_col.

  SET PROPERTY OF gv_cell 'VALUE' = pv_val.
ENDFORM.
*&-------------- ## ### ### ### ---------------------------*
FORM draw_border USING pv_range.
  DATA: lv_range   TYPE ole2_object,
        lv_borders TYPE ole2_object.

  CALL METHOD OF gv_excel 'Range' = lv_range EXPORTING #1 = pv_range.
  CALL METHOD OF lv_range 'Borders' = lv_borders.
  SET PROPERTY OF lv_borders 'LineStyle' = 1. " ##
ENDFORM.
*&---------------------- # ## # ## ## ---------------------------*
FORM style_cell USING pv_row pv_col pv_color pv_bold.
  DATA: lv_cell     TYPE ole2_object,
        lv_font     TYPE ole2_object,
        lv_interior TYPE ole2_object.

  CALL METHOD OF gv_excel 'CELLS' = lv_cell EXPORTING #1 = pv_row #2 = pv_col.

  " ## ##
  GET PROPERTY OF lv_cell 'Font' = lv_font.
  SET PROPERTY OF lv_font 'Bold' = pv_bold.

  " ### -> ## ##
  IF pv_color IS NOT INITIAL.
    GET PROPERTY OF lv_cell 'Interior' = lv_interior.
    SET PROPERTY OF lv_interior 'ColorIndex' = pv_color.
  ENDIF.
ENDFORM.
*&----------------------  ## ### ### ## ---------------------------*
FORM insert_logo USING pv_path pv_left pv_top pv_width pv_height.
  DATA: lv_shapes TYPE ole2_object,
        lv_shape  TYPE ole2_object.

  CALL METHOD OF gv_activesheet 'Shapes' = lv_shapes.

  " AddPicture(###, ####, ####, ####, ####, ##, ##)
  CALL METHOD OF lv_shapes 'AddPicture' = lv_shape
    EXPORTING
      #1 = pv_path   " ### ## (PC # ##)
      #2 = 0         " LinkToFile: False
      #3 = 1         " SaveWithDocument: True
      #4 = pv_left   " #### ### ##
      #5 = pv_top    " ### ### ##
      #6 = pv_width  " ### ##
      #7 = pv_height." ### ##
ENDFORM.
*&---------------------------------------------------------------------*
*& Form pre_process_data
*&---------------------------------------------------------------------*
FORM pre_process_data .
  DATA: ls_key       TYPE wwwdatatab,
        lv_temp_path TYPE string,
        lv_dest      TYPE localfile,
        lv_len       TYPE i.

  " SMW0# ### ##(## ###)
  ls_key-relid = 'OT'.
  ls_key-objid = 'ZSAP_LOGO'.

  " #### TEMP ## ### #### #### ##
  CALL METHOD cl_gui_frontend_services=>get_temp_directory
    CHANGING
      temp_dir = lv_temp_path.

  CONCATENATE lv_temp_path '\sap_logo.png' INTO lv_temp_path.
  REPLACE ALL OCCURRENCES OF '\\' IN lv_temp_path WITH '\'.

  lv_dest = lv_temp_path.

  " ### #### # ### ##### ##
  CALL FUNCTION 'DOWNLOAD_WEB_OBJECT'
    EXPORTING
      key         = ls_key
      destination = lv_dest.

  PERFORM fill_excel_data USING lv_temp_path.
ENDFORM.
