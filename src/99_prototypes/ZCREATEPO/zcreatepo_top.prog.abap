*&---------------------------------------------------------------------*
*& Include          ZRB1MM0001_TOP
*&---------------------------------------------------------------------*

*TABLES: ztb1mm0004, ztb1mm0005, ztb1mm0006, ztb1mm0007. "### "### ## ##
DATA: ok_code   TYPE sy-ucomm,
      gv_bpnm   TYPE zeb1_sd_bpnm, "BP# ### ## ##
      gv_ekorg  TYPE zeb1_mm_ekorg, "#### ### ## ##
      gv_ekgrp  TYPE zeb1_mm_eKgrp, "#### ### ## ##
      gv_bukrs  TYPE char20,        "#### ### ## ##
      gv_postat TYPE zeb1_mm_postat, " #### ## ###
      gv_zterm  TYPE char20,         " #### ###
      gv_inco1  TYPE char20.         " #### ###

DATA : GV_SAVE_CHECK TYPE C LENGTH 1,     "PO ## ## ## ##(###)
       GV_PO_EBELN TYPE ZEB1_MM_EBELN.       "PO ## ## ## ##(###)

*&---------------------------------------------------------------------*
*& ## ## ### (## ## ## - ZTB1MM0005)
*&---------------------------------------------------------------------*
" CDS View(## ### ## ## #)# ## #### ##
" ### ## add_ukurs, ### ## fin_netpr_usd, fin_netpr_krw #### #### ###

DATA: gs_opti TYPE zcds_b1_mm_0001,
      gt_opti TYPE TABLE OF zcds_b1_mm_0001.

*&---------------------------------------------------------------------*
*& #### ## (ZTB1MM0006)
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_head,
         ebeln  TYPE ztb1mm0006-ebeln,  " #### ##
         bpid   TYPE ztb1mm0006-bpid,   " ####(BP) ##
         ekorg  TYPE ztb1mm0006-ekorg,  " ## ##
         ekgrp  TYPE ztb1mm0006-ekgrp,  " ## ##
         bukrs  TYPE ztb1mm0006-bukrs,  " ## ##
         bsart  TYPE ztb1mm0006-bsart,  " ## ##
         bedat  TYPE ztb1mm0006-bedat,  " ####
         postat TYPE ztb1mm0006-postat, " #### ##
         zterm  TYPE ztb1mm0006-zterm,  " ## ##
         inco1  TYPE ztb1mm0006-inco1,  " ####
         zebeln TYPE ztb1mm0006-zebeln, " ## ## ##
         knumh  TYPE ztb1mm0006-knumh,  " #### ##
         lvorm  TYPE ztb1mm0006-lvorm,  " ## ##
         erdat  TYPE ztb1mm0006-erdat, " ###
         erzet  TYPE ztb1mm0006-erzet, " ####
         ernam  TYPE ztb1mm0006-ernam, " ###
         aedat  TYPE ztb1mm0006-aedat, " ###
         aezet  TYPE ztb1mm0006-aezet, " ####
         aenam  TYPE ztb1mm0006-aenam, " ###
       END OF ty_head.

DATA: gs_head TYPE ty_head.

*&---------------------------------------------------------------------*
*& #### ### (ZTB1MM0007)
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_item,
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
       END OF ty_item.

DATA: gs_item TYPE ty_item,
      gt_item TYPE TABLE OF ty_item. " ### ALV# ### ###

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

DATA: gv_col_pos     TYPE int4, " gs_fcat-col_pos ## ## ## ##
      gv_visible     TYPE char1, " item overview(## ##) ## ## # ##
      gv_before_bpid LIKE gs_head-bpid.

*&---------------------------------------------------------------------*
*& 110# ### ALV ## ## ## (## ### ## ##)
*&---------------------------------------------------------------------*
DATA: go_dialog  TYPE REF TO cl_gui_custom_container,
      go_alv_pop TYPE REF TO cl_gui_alv_grid.

DATA: gs_layo_pop   TYPE lvc_s_layo,
      gt_uifunc_pop TYPE ui_functions,
      gt_fcat_opti  TYPE lvc_t_fcat.
*&---------------------------------------------------------------------*
*& ## ## ##
*&---------------------------------------------------------------------*
DATA: gv_msg_matnr TYPE matnr,  " ## # #### ###
      gv_show_msg  TYPE abap_bool, " ## ## ##
      gv_answer TYPE CHAR1. " ## ## ### Y/N ##
