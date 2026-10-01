*&---------------------------------------------------------------------*
*& Include MZB1MM0002TOP                            - Module Pool      SAPMZB1MM0002
*&---------------------------------------------------------------------*

*TABLES: ztb1mm0006, ztb1mm0007,
*        ztb1mm0011, ztb1mm0012, ztb1mm0020, ztb1mm0021. "### "### ## ##
INCLUDE <icon>.

DATA: ok_code  TYPE sy-ucomm,
      " GS_VOLM-ZDOCTY, GS_POHD-BSART, GS_POHD-BEDAT
      " GS_POHD-EBELN, GS_ITEM-BWART
      gv_bwart TYPE char20,       "#### ### ## ##
      gv_bukrs TYPE char20.        "#### ### ## ##

DATA: gv_mblnr TYPE ztb1mm0011-mblnr.

*&---------------------------------------------------------------------*
*& #### ## (ZTB1MM0006)
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_pohd. " ebeln bpid bsart #### postat
         include structure ztb1mm0006.
TYPES: END OF ty_pohd.
DATA: gs_pohd TYPE ty_pohd.

*&---------------------------------------------------------------------*
*& #### ### (ZTB1MM0007 + CDS ### ## ##)
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_poit,
         ebeln  TYPE ztb1mm0007-ebeln,  " #### ##
         ebelp  TYPE ztb1mm0007-ebelp,  " #### ## ##
         matnr  TYPE ztb1mm0007-matnr,  " ####
         werks  TYPE ztb1mm0007-werks,  " ### ##
         lgort  TYPE ztb1mm0007-lgort,  " ####
         menge  TYPE i,  " ## ##
         meins  TYPE ztb1mm0007-meins,  " ## ##
         netpr  TYPE ztb1mm0007-netpr,  " ##
         dmbtr  TYPE ztb1mm0007-dmbtr,  " # ####(##)
         waersk TYPE ztb1mm0007-waersk, " ##(##)
         wrbtr  TYPE ztb1mm0007-wrbtr,  " # ####(####)
         waers  TYPE ztb1mm0007-waers,  " ##
         mwskz  TYPE ztb1mm0007-mwskz,  " ## ##
         eindt  TYPE ztb1mm0007-eindt,  " ## ###
         slfdt  TYPE ztb1mm0007-slfdt,  " ## ###
         insmk  TYPE ztb1mm0007-insmk,  " ## ##
         packno TYPE ztb1mm0007-packno, " ### ### ##
         knttp  TYPE ztb1mm0007-knttp,  " ## ##
         sakto  TYPE ztb1mm0007-sakto,  " ## ##
         epstp  TYPE ztb1mm0007-epstp,  " ### ####
         postat TYPE ztb1mm0007-postat, " #### ##
         lvorm  TYPE ztb1mm0007-lvorm,  " ## ##
         erdat  TYPE ztb1mm0007-erdat, " ###
         erzet  TYPE ztb1mm0007-erzet, " ####
         ernam  TYPE ztb1mm0007-ernam, " ###
         aedat  TYPE ztb1mm0007-aedat, " ###
         aezet  TYPE ztb1mm0007-aezet, " ####
         aenam  TYPE ztb1mm0007-aenam, " ###
       END OF ty_poit.
DATA: gs_poit TYPE ty_poit,
      gt_poit TYPE TABLE OF ty_poit.

*&---------------------------------------------------------------------*
*& #### ## ## (ZTB1MM0011)
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_head,
         mblnr TYPE ztb1mm0011-mblnr,    " ####
         mjahr TYPE ztb1mm0011-mjahr,    " ####
         bldat TYPE ztb1mm0011-bldat,    " ####
         budat TYPE ztb1mm0011-budat,    " ####
         bukrs TYPE ztb1mm0011-bukrs,    " ####
         bktxt TYPE ztb1mm0011-bktxt,    " ## ## ###
         vbeln TYPE ztb1mm0011-vbeln,    " #### ##
         plpr  TYPE ztb1mm0011-plpr,  " #### ##
         ebeln TYPE ztb1mm0011-ebeln,    " #### ##
         vgart TYPE ztb1mm0011-vgart,    " ## ##
         lvorm TYPE ztb1mm0011-lvorm,    " ## ##
         ernam TYPE ztb1mm0011-ernam,    " ###
         erdat TYPE ztb1mm0011-erdat,    " ###
         erzet TYPE ztb1mm0011-erzet,    " ####
         aenam TYPE ztb1mm0011-aenam,    " ###
         aedat TYPE ztb1mm0011-aedat,    " ###
         aezet TYPE ztb1mm0011-aezet,    " ####
       END OF ty_head.
DATA: gs_head TYPE ty_head.

*&---------------------------------------------------------------------*
*& #### ## ##(ZTB1MM0012)
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_item,
         mblnr     TYPE ztb1mm0012-mblnr,    " ####
         mjahr     TYPE ztb1mm0012-mjahr,    " ####
         zeile     TYPE ztb1mm0012-zeile,    " ## ####
         matnr     TYPE ztb1mm0012-matnr,    " ####
         werks     TYPE ztb1mm0012-werks,    " ### ##
         lgort     TYPE ztb1mm0012-lgort,    " ####
         bwart     TYPE ztb1mm0012-bwart,    " ## ##
         menge     TYPE i,    " ##
         meins     TYPE ztb1mm0012-meins,    " ## ##
         netpr     TYPE ztb1mm0012-netpr,    " ##
         dmbtr     TYPE ztb1mm0012-dmbtr,    " # ####(##)
         waersk    TYPE ztb1mm0012-waersk,   " ##(##)
         add_ukurs TYPE zcds_b1_mm_0002-add_ukurs, " CDS View ## # ### ## ##
         netpr_usd TYPE ztb1mm0012-wrbtr, " #### ##(## ##### ##)
         wrbtr     TYPE ztb1mm0012-wrbtr,    " # ####(####)
         waers     TYPE ztb1mm0012-waers,    " ##
         insmk     TYPE ztb1mm0012-insmk,    " ## ##
         zloss     TYPE ztb1mm0012-zloss,    " ###
         co_area   TYPE ztb1mm0012-kokrs,  " ######
         co_center TYPE ztb1mm0012-kostl, " ### ##
         vbeln     TYPE ztb1mm0012-vbeln,    " #### ##
         posnr     TYPE ztb1mm0012-posnr,    " #### ## ##
         plpr      TYPE ztb1mm0012-plpr,     " #### ##
         plpkn     TYPE ztb1mm0012-plpkn,    " #### ## ##
         ebeln     TYPE ztb1mm0012-ebeln,    " #### ##
         ebelp     TYPE ztb1mm0012-ebelp,    " #### ## ##
         lvorm     TYPE ztb1mm0012-lvorm,    " ## ##
         ernam     TYPE ztb1mm0012-ernam,    " ###
         erdat     TYPE ztb1mm0012-erdat,    " ###
         erzet     TYPE ztb1mm0012-erzet,    " ####
         aenam     TYPE ztb1mm0012-aenam,    " ###
         aedat     TYPE ztb1mm0012-aedat,    " ###
         aezet     TYPE ztb1mm0012-aezet,    " ####
       END OF ty_item.

TYPES: BEGIN OF ty_item_alv.
         INCLUDE TYPE ty_item.
TYPES:   excp_fld       TYPE char1,
         col_fld        TYPE char4,      " ex) C510
         lt_scol        TYPE lvc_t_scol, " # ##
         it_cell_style  TYPE lvc_t_styl, " # ##/###
         cancelled_icon TYPE icon_d,
       END OF ty_item_alv. " ### ALV# ### ### ###

DATA: gs_item TYPE ty_item_alv,
      gt_item TYPE TABLE OF ty_item_alv.

*----------------------------------------------------------------------*
* ## ## ### (ZTB1MM0020)
*----------------------------------------------------------------------*
TYPES: BEGIN OF ty_volm,
         zmsno    TYPE ztb1mm0020-zmsno,    " ## ##
         zdocty   TYPE ztb1mm0020-zdocty,   " ## ## (SO, PO, GR, GI)
         zdocno   TYPE ztb1mm0020-zdocno,   " ## ##
         zdocit   TYPE ztb1mm0020-zdocit,   " ## ## ##
         zavol    TYPE ztb1mm0020-zavol,    " ## ##
         ztemp    TYPE ztb1mm0020-ztemp,    " ## ##
         zunit    TYPE ztb1mm0020-zunit,    " ## ##
         zdens    TYPE ztb1mm0020-zdens,    " ## ##
         zvcf     TYPE ztb1mm0020-zvcf,     " ## ##
         zsvol    TYPE ztb1mm0020-zsvol,    " ## ##
         meins    TYPE ztb1mm0020-meins,    " ## ##
         zmdat    TYPE ztb1mm0020-zmdat,    " ## ##
         lvorm    TYPE ztb1mm0020-lvorm,    " ## ##
         ernam    TYPE ztb1mm0020-ernam,    " ###
         erdat    TYPE ztb1mm0020-erdat,    " ###
         erzet    TYPE ztb1mm0020-erzet,    " ####
         aenam    TYPE ztb1mm0020-aenam,    " ###
         aedat    TYPE ztb1mm0020-aedat,    " ###
         aezet    TYPE ztb1mm0020-aezet,    " ####
         " ## ##
         excp_fld TYPE char1,
         col_fld  TYPE char4,      " ex) C510
       END OF ty_volm.

DATA: gs_volm TYPE ty_volm,
      gt_volm TYPE TABLE OF ty_volm.

*----------------------------------------------------------------------*
* #### ### (ZTB1MM0021)
*----------------------------------------------------------------------*
TYPES: BEGIN OF ty_tran,
         ebeln        TYPE zeb1_mm_ebeln,    " #### ##
         ebelp        TYPE zeb1_mm_ebelp,    " ## ##
         packno       TYPE zeb1_mm_packno,   " ### ### ##
         seqno        TYPE zeb1_mm_seqno,    " ## ##
         event_type   TYPE zeb1_mm_event_type,   " ### ##
         event_status TYPE zeb1_mm_event_status, " ### ## ##
         event_date   TYPE zeb1_mm_event_date,   " ### ##
         location     TYPE zeb1_mm_location,     " ## ##
         remark       TYPE zeb1_mm_remark,       " ##
         lvorm        TYPE zeb1_lvorm,           " ## ##
         ernam        TYPE zeb1_ernam,           " ###
         erdat        TYPE zeb1_erdat,           " ###
         erzet        TYPE zeb1_erzet,           " ## ##
         aenam        TYPE zeb1_aenam,           " ###
         aedat        TYPE zeb1_aedat,           " ###
         aezet        TYPE zeb1_aezet,           " ## ##
         " ## ##
         excp_fld     TYPE char4, " ## ### #### char1 -> char4
         col_fld      TYPE char4,      " ex) C510
       END OF ty_tran.

DATA: gs_tran TYPE ty_tran,
      gt_tran TYPE TABLE OF ty_tran.
*&---------------------------------------------------------------------*
*& 100# ### ALV ## ## ## (#### ###)
*&---------------------------------------------------------------------*
DATA: go_cont TYPE REF TO cl_gui_custom_container,
      go_alv  TYPE REF TO cl_gui_alv_grid.

DATA: gs_variant TYPE disvariant,
      gs_stable  TYPE lvc_s_stbl,
      gs_layout  TYPE lvc_s_layo,  "layout
      gt_uifunc  TYPE ui_functions.
DATA: gt_fcat_item TYPE lvc_t_fcat. " item, tran, volm## FCAT # ##

DATA: gv_col_pos TYPE int4, " gs_fcat-col_pos ## ## ## ##
      gv_visible TYPE char1. " item overview(## ##) ## ## # ##

*&---------------------------------------------------------------------*
*& 100# ### ALV ## ## ## (#### # ####)
*&---------------------------------------------------------------------*
DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_splitter  TYPE REF TO cl_gui_splitter_container,
      go_cont_tran TYPE REF TO cl_gui_container,          " ### #
      go_cont_volm TYPE REF TO cl_gui_container,          " ### #
      go_alv_tran  TYPE REF TO cl_gui_alv_grid,
      go_alv_volm  TYPE REF TO cl_gui_alv_grid.

DATA: gs_layo_tran   TYPE lvc_s_layo,
      gt_uifunc_tran TYPE ui_functions,
      gt_fcat_tran   TYPE lvc_t_fcat.
DATA: gs_layo_volm   TYPE lvc_s_layo,
      gt_uifunc_volm TYPE ui_functions,
      gt_fcat_volm   TYPE lvc_t_fcat.

*&---------------------------------------------------------------------*
*& #### FLOW & ## ##
*&---------------------------------------------------------------------*
DATA: go_cont_doc   TYPE REF TO cl_gui_custom_container,
      go_doc        TYPE REF TO cl_dd_document,    " ## ### ### ##
      gv_load_tran  TYPE char1,
      gv_load_volm  TYPE char1,
      gv_load_gr    TYPE char1,
      gv_plant_tran TYPE char1,
      gv_plant_volm TYPE char1,
      gv_plant_gr   TYPE char1.

*&---------------------------------------------------------------------*
*& ## ## ##
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_tran_key, " #### ### ## ### ## ## ## ###
         ebeln TYPE zeb1_mm_ebeln,    " #### ##
         ebelp TYPE zeb1_mm_ebelp,    " ## ##
       END OF ty_tran_key.
DATA: gv_msg_matnr TYPE matnr,  " ## # #### ###
      gv_show_msg  TYPE abap_bool, " ## ## ##
      gv_answer    TYPE char1. " ## ## ### Y/N ##
