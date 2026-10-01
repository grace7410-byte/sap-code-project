*&---------------------------------------------------------------------*
*& Include ZB1MM0001_TOP
*&---------------------------------------------------------------------*
TYPE-POOLS: icon.
" TABLES ztb1mm0020. " Selection screen

DATA: ok_code            TYPE sy-ucomm,
      gv_dynnr           TYPE sy-dynnr VALUE '9000', "SUBSCREEN ## ##
      gv_current_process TYPE zeb1_mm_type1." ## ## # ### #####

data: gv_ebeln TYPE zeb1_mm_ebeln,
      gv_back            TYPE c. " ## ### (X: 200# ##### ### #, #### ## ###)
DATA: gv_maktx TYPE zeb1_mm_maktx, " 200# ### ### ##
      " 100# ### #### # # ###
      gv_typ   TYPE zeb1_mm_type1, " SO, PO, PrO
      gv_typt  TYPE char5, " ####, ####, ####
      gv_mat   TYPE zeb1_mm_matnr, " ### ####
      gv_matt  TYPE zeb1_mm_maktx, " ###
      gv_doc   TYPE char25, " ## ## ####~ # ####
      gv_dat   TYPE char25, " ## ## #### ~ # ####
      gv_wks   TYPE char15, " ## ## ### ~ # ###
      gv_lgt   TYPE char15, " ## ## #### ~ # ####
      gv_lgtt  TYPE char40. " #### ###

DATA: gr_mat TYPE RANGE OF zeb1_mm_matnr,
      gv_order_name TYPE CHAR20.

*----------------------------------------------------------------------*
* ## ## ### (ZTB1MM0020)
*----------------------------------------------------------------------*
TYPES: BEGIN OF ty_volm,
         zmsno    TYPE ztb1mm0020-zmsno,    " ## ##
         zdocty   TYPE ztb1mm0020-zdocty,   " ## ## (SO, PO-1, PRO-GR #)
         process  TYPE zeb1_mm_type1, " SO, PO, PrO
         movement TYPE zeb1_mm_type2, " GR, GI
         step     TYPE zeb1_mm_type3, " 1(####), 2(####)
         text_p   TYPE char20, " ### ##(#### - ####, ####, ####)
         " text_m TYPE CHAR20, " ### ##(## - ##, ##)
         text_s   TYPE char20, " ### ##(## - ####, ####)
         zdocno   TYPE ztb1mm0020-zdocno,   " ## ##
         zdocit   TYPE ztb1mm0020-zdocit,   " ## ## ##
         zavol    TYPE i, " ztb1mm0020-zavol,    " ## ##
         meins    TYPE ztb1mm0020-meins,    " ## ##
         ztemp    TYPE ztb1mm0020-ztemp,    " ## ##
         zunit    TYPE ztb1mm0020-zunit,    " ## ##
         zdens    TYPE ztb1mm0020-zdens,    " ## ##
         zvcf     TYPE ztb1mm0020-zvcf,     " ## ##
         zsvol    TYPE i, " ztb1mm0020-zsvol,    " ## ##
         meins_2  TYPE ztb1mm0020-meins,    " ## ## (meins ### # ### #### # #)
         zmdat    TYPE ztb1mm0020-zmdat,    " ## ##
         lvorm    TYPE ztb1mm0020-lvorm,    " ## ##
         ernam    TYPE ztb1mm0020-ernam,    " ###
         erdat    TYPE ztb1mm0020-erdat,    " ###
         erzet    TYPE ztb1mm0020-erzet,    " ####
         aenam    TYPE ztb1mm0020-aenam,    " ###
         aedat    TYPE ztb1mm0020-aedat,    " ###
         aezet    TYPE ztb1mm0020-aezet,    " ####
         " ## ##
         excp_fld TYPE char4, " SAP#### ## ## ### #### ##(char1 -> char4 ##)
         col_fld  TYPE char4,      " ex) C510
       END OF ty_volm.

*&---------------------------------------------------------------------*
*& ##, ##, ## ## ### #### ## ## / ###
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_head,
         process       TYPE zeb1_mm_type1,  " ## ## ## (SO, PO, PRO #)
         zdocno        TYPE ztb1mm0020-zdocno, " ####
         bpid          TYPE bpid,                " ### (BPID / ####)
         bldat         TYPE bldat,              " ### (## # #)
         icon          TYPE icon-id,             " ## ## ##
         lt_scol       TYPE lvc_t_scol,
         cell_style    TYPE lvc_t_styl,
         It_cell_style TYPE lvc_t_styl,
         expand        TYPE char1, " ## ## ###
       END OF ty_head.

DATA: gs_hvolm TYPE ty_head,
      gt_hvolm TYPE TABLE OF ty_head,
      gs_head  TYPE ty_head,
      gt_head  TYPE TABLE OF ty_head.

DATA: BEGIN OF gs_volm.
        INCLUDE       TYPE ty_volm. " 100# #### ### ## - zdocty zdocno zdocit zavol zsvol zmsno # ### ##
*         ## ## ##
DATA:   matnr         TYPE zeb1_mm_matnr,             " ## ##
        werks         TYPE zeb1_mm_werks,             " ###
        lgort         TYPE zeb1_mm_lgort,             " ####
*         ## ## (## ### ###)
        ordqty        TYPE i, " zeb1_mm_menge,        " ## ## (KWMENG / MENGE / ORQTY)
        meins_3       TYPE zeb1_mm_meins,             " ## ###
*         ALV ##(# ### #)
        icon          TYPE icon-id,             " ## ## ##
        m_icon        TYPE icon-id,             " movement ### ## ### ## ##
        lt_scol       TYPE lvc_t_scol,
        cell_style    TYPE lvc_t_styl,
        It_cell_style TYPE lvc_t_styl,
      END OF gs_volm.

DATA: gt_volm LIKE TABLE OF gs_volm,
      gs_item LIKE gs_volm,
      gt_item LIKE gt_volm.
DATA: gs_cell_style TYPE lvc_s_styl.

*&---------------------------------------------------------------------*
*& ##, ##, ## ## ## ##/### - ##/####/####
*&---------------------------------------------------------------------*
DATA: gs_so_H  TYPE ztb1sd0006,
      gt_so_h  TYPE TABLE OF ztb1sd0006,
      gs_so_i  TYPE ztb1sd0007,
      gt_so_i  TYPE TABLE OF ztb1sd0007,
      gs_po_h  TYPE ztb1mm0006,
      gt_po_h  TYPE TABLE OF ztb1mm0006,
      gs_po_i  TYPE ztb1mm0007,
      gt_po_i  TYPE TABLE OF ztb1mm0007,
      gs_pro_h TYPE ztb1pp0013,
      gt_pro_h TYPE TABLE OF ztb1pp0013,
      gs_pro_i TYPE ztb1pp0014,
      gt_pro_i TYPE TABLE OF ztb1pp0014.
DATA: gs_vol_i TYPE ztb1mm0020,
      gt_vol_i TYPE TABLE OF ztb1mm0020.
DATA: gs_mat_h TYPE ztb1mm0011,
      gt_mat_h TYPE TABLE OF ztb1mm0011,
      gs_mat_i TYPE ztb1mm0012,
      gt_mat_i TYPE TABLE OF ztb1mm0012.

DATA: gv_has_plan  TYPE char1,
      gv_has_order  TYPE char1,
      gv_has_volume TYPE char1,
      gv_has_post   TYPE char1.

DATA: gs_po_opt  TYPE ztb1mm0005,
      gt_po_opt  TYPE TABLE OF ztb1mm0005,
      gs_pln_h  TYPE  ztb1pp0013,
      gt_pln_i  TYPE TABLE OF ztb1pp0014.

*&---------------------------------------------------------------------*
*& 100# ### ALV ## ## ## ( Custom 'VOLM' ## ALV)
*&---------------------------------------------------------------------*
DATA: go_cont     TYPE REF TO cl_gui_custom_container, " ## ## ####
      go_alv_head TYPE REF TO cl_gui_alv_grid,
      go_alv_item TYPE REF TO cl_gui_alv_grid,
      go_dyndoc   TYPE REF TO cl_dd_document.    " ## ### ### ##

DATA: go_splitter    TYPE REF TO cl_gui_splitter_container,
      go_cont_1      TYPE REF TO cl_gui_container,
      go_cont_2      TYPE REF TO cl_gui_container,
      go_cont_3      TYPE REF TO cl_gui_container,
      gs_layo_head   TYPE lvc_s_layo,
      gt_uifunc_head TYPE ui_functions,
      gt_fcat_head   TYPE lvc_t_fcat,
      gs_layo_item   TYPE lvc_s_layo,
      gt_uifunc_item TYPE ui_functions,
      gt_fcat_item   TYPE lvc_t_fcat.

*&---------------------------------------------------------------------*
*& 100# ### ALV ## ## ## ( Custom 'FLOW' ## ALV)
*&---------------------------------------------------------------------*
DATA: go_cont_doc    TYPE REF TO cl_gui_custom_container, " ## ## ####
      go_doc         TYPE REF TO cl_dd_document,    " ## ### ### ##
      go_html_viewer TYPE REF TO cl_gui_html_viewer,
      gt_html        TYPE TABLE OF w3html,
      gs_html        TYPE w3html,
      gv_url         TYPE char255.

*&---------------------------------------------------------------------*
*& 110, 120, 130# ### ALV ## ## ## ( Docking + Splitter )
*&---------------------------------------------------------------------*
DATA: go_dock_sub  TYPE REF TO cl_gui_docking_container,
      go_split_sub TYPE REF TO cl_gui_splitter_container,
      go_cont_h    TYPE REF TO cl_gui_container,
      go_cont_i    TYPE REF TO cl_gui_container.

" 110# SO
DATA: go_alv_so_h TYPE REF TO cl_gui_alv_grid,
      go_alv_so_i TYPE REF TO cl_gui_alv_grid,
      gt_fcat_so_i TYPE lvc_t_fcat.

" 120# PO
DATA: go_alv_po_h TYPE REF TO cl_gui_alv_grid,
      go_alv_po_i TYPE REF TO cl_gui_alv_grid,
      gt_fcat_po_i TYPE lvc_t_fcat.

" 130# PrO ##)
DATA: go_alv_pro_h TYPE REF TO cl_gui_alv_grid,
      go_alv_pro_i TYPE REF TO cl_gui_alv_grid,
      gt_fcat_pro_i TYPE lvc_t_fcat.

*&---------------------------------------------------------------------*
*& 140, 150# ### ALV ## ## ##
*&---------------------------------------------------------------------*

" 140# vol ##
DATA: go_alv_vol_i TYPE REF TO cl_gui_alv_grid,
      gt_fcat_vol_i TYPE lvc_t_fcat.

" 150# mat ##
DATA: go_alv_mat_h TYPE REF TO cl_gui_alv_grid,
      go_alv_mat_i TYPE REF TO cl_gui_alv_grid,
      gt_fcat_mat_h TYPE lvc_t_fcat,
      gt_fcat_mat_i TYPE lvc_t_fcat.

*&---------------------------------------------------------------------*
*& 121, 131# ### ALV ## ## ##
*&---------------------------------------------------------------------*

" 121# vol ##
DATA: go_alv_opt TYPE REF TO cl_gui_alv_grid,
      gt_fcat_opt TYPE lvc_t_fcat.

" 131# mat ##
DATA: go_alv_pln_h TYPE REF TO cl_gui_alv_grid,
      go_alv_pln_i TYPE REF TO cl_gui_alv_grid,
      gt_fcat_pln_h TYPE lvc_t_fcat,
      gt_fcat_pln_i TYPE lvc_t_fcat.

*&---------------------------------------------------------------------*
*& (### ## ## ## #) #### ALV ## ##
*&---------------------------------------------------------------------*
DATA: gs_keyinfo     TYPE slis_keyinfo_alv. " #### ### ALV

DATA: gs_layout_hier TYPE slis_layout_alv,    " ####
      gt_fcat        TYPE slis_t_fieldcat_alv,     " ## ####
      gt_extab       TYPE slis_t_extab,             " ## ## (uifunc ##)
      gs_variant     TYPE disvariant.

*DATA: go_cont     TYPE REF TO cl_gui_custom_container,
*      go_alv_item TYPE REF TO cl_gui_alv_grid.
*
*DATA: gs_variant_item TYPE disvariant,
*      gs_stable_item  TYPE lvc_s_stbl,
*      gs_layout_item  TYPE lvc_s_layo,  "layout
*      gt_uifunc_item  TYPE ui_functions.
*DATA: gt_fcat_item TYPE lvc_t_fcat.

*&---------------------------------------------------------------------*
*& (PDF ## ## ## #) EXCEL -> PDF ## # ##
*&---------------------------------------------------------------------*

DATA: gv_excel       TYPE ole2_object,
      gv_workbook    TYPE ole2_object,
      gv_cell        TYPE ole2_object,
      gv_application TYPE ole2_object,
      gv_activesheet TYPE ole2_object.

DATA: gv_file_path     TYPE string,     " ## ## ## ##
      gv_pdf_path      TYPE string,     " PDF ## ##
      gv_default_folder TYPE string.    " ## #### ##

*&---------------------------------------------------------------------*
*& 1000# Selection Screen# ####, select-options ##
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS: pa_typ TYPE zeb1_mm_type1, " #### ex)SO, PO, PrO " AS LISTBOX VISIBLE LENGTH 20.
              pa_mat LIKE gs_item-matnr MATCHCODE OBJECT ZSHB1MM0004.     " ####(### ##)
  SELECT-OPTIONS: so_doc FOR gs_head-zdocno , " ## ##
                  so_dat  FOR gs_head-bldat, " ###
                  so_wks FOR gs_item-werks MATCHCODE OBJECT ZSHB1MM0002,    " ###(### ##)
                  so_lgt FOR gs_item-lgort MATCHCODE OBJECT ZSHB1MM0002.    " ####(### ##)
SELECTION-SCREEN END OF BLOCK blk1.
