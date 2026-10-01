*&---------------------------------------------------------------------*
*& Include          MZB1MM0006_TOP
*&---------------------------------------------------------------------*
INCLUDE <icon>. " ICON_#, ICON_## ### ## ##

DATA: ok_code       TYPE sy-ucomm,
      gv_first_time TYPE char1 VALUE 'X',
      gv_invoice    TYPE char1,
      gv_low        TYPE ztb1mm0020-ztemp,
      gv_high       TYPE ztb1mm0020-ztemp.
*      gs_selected_item TYPE ty_item

*----------------------------------------------------------------------*
* ## ## ### ### ### (ZTB1MM0018)
*----------------------------------------------------------------------*
TYPES: BEGIN OF ty_0018,
         ztemp    TYPE ztb1mm0018-ztemp,    " ## ## (DEC 5,2)
         zdens    TYPE ztb1mm0018-zdens,    " ## ## (DEC 5,2)
         zunit    TYPE ztb1mm0018-zunit,    " ## ## (CHAR 3) - Fixed: CEL
         zstd     TYPE ztb1mm0018-zstd,     " ## ## (DEC 5,2) - Fixed: 15
         zvcf     TYPE ztb1mm0018-zvcf,     " ## ## (DEC 7,4)
         lvorm    TYPE ztb1mm0018-lvorm,    " ## ## (CHAR 1)
         ernam    TYPE ztb1mm0018-ernam,    " ### (CHAR 12)
         erdat    TYPE ztb1mm0018-erdat,    " ### (DATS 8)
         erzet    TYPE ztb1mm0018-erzet,    " ## ## (TIMS 6)
         aenam    TYPE ztb1mm0018-aenam,    " ### (CHAR 12)
         aedat    TYPE ztb1mm0018-aedat,    " ### (DATS 8)
         aezet    TYPE ztb1mm0018-aezet,    " ## ## (TIMS 6)

         " CBO ## # ALV ### ## ## (### ##)
         col_fld  TYPE char4,               " ALV ## ## ##
         cell_tab TYPE lvc_t_styl,          " # #### ### ### ###
       END OF ty_0018.

*----------------------------------------------------------------------*
* ## ## ## ### ### (ZTB1MM0020)
*----------------------------------------------------------------------*
TYPES: BEGIN OF ty_0020,
         zmsno  TYPE ztb1mm0020-zmsno,    " ## ## (CHAR 10)
         zdocit TYPE ztb1mm0020-zdocit,   " ## ## ## (NUMC 4)
         zdocty TYPE ztb1mm0020-zdocty,   " ## ## (CHAR 2) - SO, PO, GR, GI
         zdocno TYPE ztb1mm0020-zdocno,   " ## ## (CHAR 10)
         zavol  TYPE ztb1mm0020-zavol,    " ## ## (QUAN 13,3)
         meins  TYPE ztb1mm0020-meins,    " ## ## (UNIT 3)
         ztemp  TYPE ztb1mm0020-ztemp,    " ## ## (DEC 5,2)
         zunit  TYPE ztb1mm0020-zunit,    " ## ## (CHAR 3)
         zdens  TYPE ztb1mm0020-zdens,    " ## ## (DEC 5,2)
         zvcf   TYPE ztb1mm0020-zvcf,     " ## ## (DEC 7,4)
         zsvol  TYPE ztb1mm0020-zsvol,    " ## ## (QUAN 13,3)
         zmdat  TYPE ztb1mm0020-zmdat,    " ## ## (DATS 8)
         lvorm  TYPE ztb1mm0020-lvorm,    " ## ## (CHAR 1)
         ernam  TYPE ztb1mm0020-ernam,    " ### (CHAR 12)
         erdat  TYPE ztb1mm0020-erdat,    " ### (DATS 8)
         erzet  TYPE ztb1mm0020-erzet,    " ## ## (TIMS 6)
         aenam  TYPE ztb1mm0020-aenam,    " ### (CHAR 12)
         aedat  TYPE ztb1mm0020-aedat,    " ### (DATS 8)
         aezet  TYPE ztb1mm0020-aezet,    " ## ## (TIMS 6)
       END OF ty_0020.

DATA: gs_head        TYPE ty_0020,
      gs_select_head TYPE ty_0020,
      gt_head        TYPE TABLE OF ty_0020.

*&---------------------------------------------------------------------*
*& #### ### (ZTB1MM0007)
*&---------------------------------------------------------------------*

TYPES: BEGIN OF ty_item,
         ebeln      TYPE ztb1mm0007-ebeln,  " #### ##
         zebelnsv   TYPE ztb1mm0006-zebelnsv,
         ebelp      TYPE ztb1mm0007-ebelp,  " #### ## ##
         matnr      TYPE ztb1mm0007-matnr,
         menge      TYPE ztb1mm0007-menge,  " ## ##
         meins      TYPE ztb1mm0007-meins,  " ## ##
         insmk      TYPE ztb1mm0007-insmk,  " ## ##
         postat     TYPE ztb1mm0007-postat, " #### ##
         lvorm      TYPE ztb1mm0007-lvorm,  " ## ##
         erdat      TYPE ztb1mm0007-erdat, " ###
         erzet      TYPE ztb1mm0007-erzet, " ####
         ernam      TYPE ztb1mm0007-ernam, " ###
         aedat      TYPE ztb1mm0007-aedat, " ###
         aezet      TYPE ztb1mm0007-aezet, " ####
         aenam      TYPE ztb1mm0007-aenam, " ###

         " --------------------------
         status type icon_d,
*         load_tran  TYPE icon_d,           " #### ## ## ### (# ###)
*         plant_tran TYPE icon_d,           " ##### ## ## ### (# ###)
         count_volm TYPE int4,              " #### ## ## (0, 1, 2...)
*         load_gr    TYPE icon_d,           " #### ## ### (## ###)
*         plant_gr   TYPE icon_d,           " ##### ## ### (## ###)
         " --------------------------

         cell_color TYPE lvc_t_scol,
         line_color TYPE char4,
       END OF ty_item.

DATA: gs_selected_item TYPE ty_item,
      gt_item          TYPE TABLE OF ty_item. " ### ALV# ### ###

*&---------------------------------------------------------------------*
*& 100# ### ALV ## ## ## (#### ###)
*&---------------------------------------------------------------------*
DATA: go_cont TYPE REF TO cl_gui_custom_container,
      go_alv  TYPE REF TO cl_gui_alv_grid.

DATA: gs_variant TYPE disvariant,
      gs_stable  TYPE lvc_s_stbl,
      gs_layout  TYPE lvc_s_layo,  "layout
      gt_uifunc  TYPE ui_functions.

DATA: gt_fcat_item TYPE lvc_t_fcat.
*      gs_fcat TYPE lvc_s_fcat " #### ##### ### FNAME, FVALUE #### itab# APPEND### #####

DATA: gv_col_pos TYPE int4, " gs_fcat-col_pos ## ## ## ##
      gv_visible TYPE char1. " item overview(## ##) ## ## # ##
