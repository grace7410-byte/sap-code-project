*&---------------------------------------------------------------------*
*& Include MZB1MM0003TOP                            - Module Pool      SAPMZB1MM0003
*&---------------------------------------------------------------------*
INCLUDE <icons>.
TABLES ztb1mm0020. " ## ##(selection screen

DATA: ok_code TYPE sy-ucomm.
DATA: gv_ebeln TYPE zeb1_mm_ebeln,
      gv_back  TYPE c. " ## ### (X: 200# ##### ### #, #### ## ###)
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

DATA: gs_volm TYPE ty_volm,
      gt_volm TYPE TABLE OF ty_volm.
*&---------------------------------------------------------------------*
*& 100# ### ALV ## ## ## (## ###)
*&---------------------------------------------------------------------*
DATA: go_cont_volm TYPE REF TO cl_gui_custom_container,
      go_alv_volm  TYPE REF TO cl_gui_alv_grid.

DATA: gs_variant_volm TYPE disvariant,
      gs_stable_volm  TYPE lvc_s_stbl,
      gs_layout_volm  TYPE lvc_s_layo,  "layout
      gt_uifunc_volm  TYPE ui_functions.
DATA: gt_fcat_volm TYPE lvc_t_fcat.

DATA: " gv_col_pos TYPE int4, " gs_fcat-col_pos ## ## ## ##
      gv_visible TYPE char1. " #### ## ## ## ## # ##

*&---------------------------------------------------------------------*
*& ##, ##, ## '##'# #### ## ### ### ## (200# ### ALV itab)
*&---------------------------------------------------------------------*
DATA: BEGIN OF gs_item.
        INCLUDE       TYPE ty_volm. " 100# #### ### ## - zdocty zdocno zdocit zavol zsvol zmsno # ### ##
*         ## ## ##
DATA:   matnr         TYPE zeb1_mm_matnr,             " ## ##
        werks         TYPE zeb1_mm_werks,             " ###
        lgort         TYPE zeb1_mm_lgort,             " ####
*         ## ## (## ### ###)
        ordqty        TYPE i, " zeb1_mm_menge,             " ## ## (KWMENG / MENGE / ORQTY)
        meins_3       TYPE zeb1_mm_meins,             " ## ###
*         ##, BP ##
        bldat         TYPE zeb1_mm_bldat,             " ### (## # #)
        bpid          TYPE zeb1_sd_bpid,              " ### (BPID / ####)
*         ALV ##(# ### #)
        icon          TYPE icon-id,             " ## ## ##
        m_icon        TYPE icon-id,             " movement ### ## ### ## ##
        lt_scol       TYPE lvc_t_scol,
        cell_style    TYPE lvc_t_styl,
        It_cell_style TYPE lvc_t_styl,
      END OF gs_item.

DATA: gt_item LIKE TABLE OF gs_item.
DATA: ls_scol       TYPE lvc_s_scol,
      gs_cell_style TYPE lvc_s_styl.
*&---------------------------------------------------------------------*
*& 200# ### ALV ## ## ## (## ###)
*&---------------------------------------------------------------------*

DATA: go_cont     TYPE REF TO cl_gui_custom_container,
      go_alv_item TYPE REF TO cl_gui_alv_grid.

DATA: gs_variant_item TYPE disvariant,
      gs_stable_item  TYPE lvc_s_stbl,
      gs_layout_item  TYPE lvc_s_layo,  "layout
      gt_uifunc_item  TYPE ui_functions.
DATA: gt_fcat_item TYPE lvc_t_fcat.

*&---------------------------------------------------------------------*
*& 1000# Selection Screen# ####, select-options ##
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS: pa_typ TYPE zeb1_mm_type1, " #### ex)SO, PO, PrO " AS LISTBOX VISIBLE LENGTH 20.
              pa_mat LIKE gs_item-matnr.     " ####
  SELECT-OPTIONS: so_doc FOR ztb1mm0020-zdocno, " ## ##
                  so_dat  FOR ztb1mm0020-zmdat, " ## ##
                  so_wks FOR gs_item-werks,    " ###
                  so_lgt FOR gs_item-lgort.    " ####
SELECTION-SCREEN END OF BLOCK blk1.
