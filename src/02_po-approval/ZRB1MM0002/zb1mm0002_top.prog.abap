*&---------------------------------------------------------------------*
*& Include          ZB1MM0002_TOP
*&---------------------------------------------------------------------*

TYPE-POOLS: icon.
DATA: ok_code  TYPE sy-ucomm,
      gv_ebeln TYPE zeb1_mm_ebeln,
      gv_mode  TYPE c. " #### ##### ## # #### ##(##, ##)_


TYPES: BEGIN OF ty_data.
TYPES: status type icon_d,
       zappno   TYPE ztb1mm0008-zappno. " ## ##
       " EBELN BPID EKORG EKGRP BUKRS BSART BEDAT
       include structure ztb1mm0006. " ZTERM INCO1 ZEBELN ZEBELNSV KNUMH LVORM
TYPES: zappst   TYPE ztb1mm0008-zappst,   " ## ##
       zappstxt TYPE char10,
       zapper   TYPE ztb1mm0008-zapper,   " ###
       zappdat  TYPE ztb1mm0008-zappdat,  " ## ##
       zapptim  TYPE ztb1mm0008-zapptim,  " ## ##
       zmemo    TYPE ztb1mm0008-zmemo,    " ## ##
       cell_color TYPE lvc_t_scol.
TYPES: END OF ty_data.
DATA: gs_data TYPE ty_data,
      gt_data TYPE TABLE OF ty_data.

* ## ###
DATA: gs_appr TYPE ztb1mm0008, " ZAPPNO EBELN ZAPPST ZAPPER
      gt_appr TYPE TABLE OF ztb1mm0008. " ZAPPDAT ZAPPTIM ZMEMO LVORM

*&---------------------------------------------------------------------*
*& #### ## (ZTB1MM0006)
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_pohd. " EBELN BPID EKORG EKGRP BUKRS BSART BEDAT
         include structure ztb1mm0006. " ZTERM INCO1 ZEBELN ZEBELNSV KNUMH LVORM
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
*& 100# ### ALV ## ## ## (####+##)
*&---------------------------------------------------------------------*
DATA: go_dock TYPE REF TO cl_gui_docking_container,
      go_alv  TYPE REF TO cl_gui_alv_grid.

DATA: gs_variant TYPE disvariant,
      gs_stable  TYPE lvc_s_stbl,
      gs_layout  TYPE lvc_s_layo,  "layout
      gt_uifunc  TYPE ui_functions.

DATA: gt_fcat_appr TYPE lvc_t_fcat.

*&---------------------------------------------------------------------*
*& 1000# Selection Screen# ####, select-options ##
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS: pa_stat TYPE zeb1_mm_zappst.
  SELECT-OPTIONS: so_pono FOR gs_data-ebeln, " ## ##
                  so_apno FOR gs_data-zappno, " ## ##
                  so_apdat FOR gs_data-zappdat, " ## ##
                  so_podat FOR gs_data-erdat. " ## ##(=## ### ### ## = PO# ### ##)
SELECTION-SCREEN END OF BLOCK blk1.
