*&---------------------------------------------------------------------*
*& Include          MZB1MM0004_TOP
*&---------------------------------------------------------------------*

*TABLES: ztb1mm0004, ztb1mm0005, ztb1mm0006, ztb1mm0007. "### "### ## ##

CONTROLS : tabstrip TYPE TABSTRIP.

DATA: ok_code         TYPE sy-ucomm,
      gv_before_dynnr TYPE sy-dynnr, " ## ### ###
      gv_mode         TYPE c, " ## / ## ##
      gv_ebeln        TYPE zeb1_mm_ebeln, " #### ##(##, ## ##### ##)
      gv_bpnm         TYPE zeb1_sd_bpnm, "BP# ### ## ##
      gv_ekorg        TYPE zeb1_mm_ekorg, "#### ### ## ##
      gv_ekgrp        TYPE zeb1_mm_eKgrp, "#### ### ## ##
      gv_bukrs        TYPE char20 value '1000',        "#### ### ## ##
      gv_postat       TYPE zeb1_mm_postat,
      gv_postatxt     TYPE char20,   " #### ## ###
      gv_zterm        TYPE char20,         " #### ###
      gv_inco1        TYPE char20,         " #### ###
      gv_cntcd        TYPE char20, " #### ###
      gv_mwskz        TYPE char20, " #### ###
      gv_zvlead       TYPE char20, " #### ##(#)
      gv_vend_org     TYPE char20, " ## ###
      gv_vend_grp     TYPE char20, " - #### ## ## ## ##
      gv_vend_term    TYPE char20,
      gv_vend_inco    TYPE char20,
      gv_vend_buk     TYPE char20.

*&---------------------------------------------------------------------*
*& ## ## ### (## ## ## - ZTB1MM0005)
*&---------------------------------------------------------------------*
" CDS View(## ### ## ## #)# ## #### ##
" ### ## add_ukurs, ### ## fin_netpr_usd, fin_netpr_krw #### #### ###

DATA: BEGIN OF gs_opti.
        include structure zcds_b1_mm_0001.
DATA:   select type icon_d,
        textday TYPE char4, " #### ##(#) #### ##
        netusd type ztb1mm0025-netusd,
      END OF gs_opti,
      gt_opti LIKE TABLE OF gs_opti.

*&---------------------------------------------------------------------*
*& #### ## (ZTB1MM0006)
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_head,
         ebeln    TYPE ztb1mm0006-ebeln,  " #### ##
         bpid     TYPE ztb1mm0006-bpid,   " ####(BP) ##
         ekorg    TYPE ztb1mm0006-ekorg,  " ## ##
         ekgrp    TYPE ztb1mm0006-ekgrp,  " ## ##
         bukrs    TYPE ztb1mm0006-bukrs,  " ## ##
         bsart    TYPE ztb1mm0006-bsart,  " ## ##
         bedat    TYPE ztb1mm0006-bedat,  " ####
         zterm    TYPE ztb1mm0006-zterm,  " ## ##
         inco1    TYPE ztb1mm0006-inco1,  " ####
         zebeln   TYPE ztb1mm0006-zebeln, " ## ## ##
         zebelnsv TYPE ztb1mm0006-zebelnsv, "(##) ##### ##
         knumh    TYPE ztb1mm0006-knumh,  " #### ##
         lvorm    TYPE ztb1mm0006-lvorm,  " ## ##
         erdat    TYPE ztb1mm0006-erdat, " ###
         erzet    TYPE ztb1mm0006-erzet, " ####
         ernam    TYPE ztb1mm0006-ernam, " ###
         aedat    TYPE ztb1mm0006-aedat, " ###
         aezet    TYPE ztb1mm0006-aezet, " ####
         aenam    TYPE ztb1mm0006-aenam, " ###
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
*& #### ## (ZTB1SD0001, ZTB1SD0002, ZTB1MM0004)
*&---------------------------------------------------------------------*
DATA: BEGIN OF gs_vend, "vendor
        bpid   TYPE ztb1sd0001-bpid,      " BP ##
        bptyp  TYPE ztb1sd0001-bptyp,     " BP ##
        bptyptxt type char20,
        bpnm   TYPE ztb1sd0001-bpnm,      " BP #
        cntcd  TYPE ztb1sd0001-cntcd,     " ## ##
        recon  TYPE ztb1sd0002-recon,     " ####
        ekorg  TYPE ztb1mm0004-ekorg,     " ## ##
        ekgrp  TYPE ztb1mm0004-ekgrp,     " ## ##
        zterm  TYPE ztb1mm0004-zterm,     " ## ##
        inco1  TYPE ztb1mm0004-inco1,     " ####
        mwskz  TYPE ztb1mm0004-mwskz,     " ## ##
        bukrs  TYPE ztb1mm0004-bukrs,     " ## ##
        zvlead TYPE ztb1mm0004-zvlead,    " ## ##
        addr   TYPE ztb1sd0001-addr,      " ####
        bizno  TYPE ztb1sd0001-bizno,     " ### ##
        email  TYPE ztb1sd0001-email,     " ###
        accno  TYPE ztb1sd0001-accno,     " ####
        bank   TYPE ztb1sd0001-bank,      " ###
        waers  TYPE ztb1sd0001-waers,     " ## ##
        picnm  TYPE ztb1sd0001-picnm,     " ### ###
        pictl  TYPE ztb1sd0001-pictl,     " ### ####
        erdat  TYPE ztb1mm0001-erdat, " ###
        erzet  TYPE ztb1mm0001-erzet, " ####
        ernam  TYPE ztb1mm0001-ernam, " ###
        aedat  TYPE ztb1mm0001-aedat, " ###
        aezet  TYPE ztb1mm0001-aezet, " ####
        aenam  TYPE ztb1mm0001-aenam, " ###
      END OF gs_vend,
      gt_vend LIKE TABLE OF gs_vend.

*&---------------------------------------------------------------------*
*& BOM(##) ## (ZTB1PP0003)
*&---------------------------------------------------------------------*
DATA: BEGIN OF gs_bom.
        include structure ztb1pp0003. " bom ### ### (pp)
DATA:   maktx        TYPE zeb1_mm_maktx,
        display_text TYPE char40, " 18 + 18 + ##(## # ##)
      END OF gs_bom,
      gt_bom        LIKE TABLE OF gs_bom,
      gv_month      TYPE n LENGTH 2,
      gv_season     TYPE char4,
      gv_crude      TYPE zeb1_mm_crude VALUE 'WTI-100',
      gv_chart_show TYPE c. " ## ### ##

DATA:BEGIN OF gs_bom_all.
       include structure ztb1pp0003. " bom ### ### (pp)
DATA:  crude        TYPE zeb1_mm_matnr,
       crude_maktx  TYPE zeb1_mm_maktx,
       crude_text   TYPE char40,
       maktx        TYPE zeb1_mm_maktx,
       display_text TYPE char40,
     END OF gs_bom_all,
     gt_bom_all        LIKE TABLE OF gs_bom_all,
     gv_chart_show_all TYPE c.

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
*& 101# ### ALV ## ## ## (#### ##)
*&---------------------------------------------------------------------*
DATA: go_cont_vend   TYPE REF TO cl_gui_custom_container,
      go_alv_vend    TYPE REF TO cl_gui_alv_grid, " #### ### ALV# ##
      gs_layo_vend   TYPE lvc_s_layo,
      gt_uifunc_vend TYPE ui_functions,
      gt_fcat_vend   TYPE lvc_t_fcat.

*&---------------------------------------------------------------------*
*& 110# ### ALV, ## ## ## ## (## ### ## ## & ### ## ##)
*&---------------------------------------------------------------------*
DATA: go_dialog  TYPE REF TO cl_gui_custom_container,
      go_alv_pop TYPE REF TO cl_gui_alv_grid.

DATA: gs_layo_pop   TYPE lvc_s_layo,
      gt_uifunc_pop TYPE ui_functions,
      gt_fcat_opti  TYPE lvc_t_fcat.

DATA: go_cont_chart TYPE REF TO cl_gui_custom_container, " ## ## ####
      go_chart      TYPE REF TO cl_gui_chart_engine. " ## ## ####
*      gv_xstring    TYPE xstring, " xml ## ##
*      go_ixml       TYPE REF TO if_ixml. " ## ###

*&---------------------------------------------------------------------*
*& 130# ##, ALV ## ## ## (## ## ## ## ##)
*&---------------------------------------------------------------------*
DATA: go_cont_chartall TYPE REF TO cl_gui_custom_container, " ## ## ####
      go_chartall      TYPE REF TO cl_gui_chart_engine. " ## ## ####

DATA: go_splitter   TYPE REF TO cl_gui_splitter_container,
      go_cont_l     TYPE REF TO cl_gui_container,
      go_cont_r     TYPE REF TO cl_gui_container,
      go_alv_all    TYPE REF TO cl_gui_alv_grid,
      gs_layo_all   TYPE lvc_s_layo,
      gt_uifunc_all TYPE ui_functions,
      gt_fcat_all   TYPE lvc_t_fcat.

*&---------------------------------------------------------------------*
*& 300# ALV ## ## ## (#### ## ## ##)
*&---------------------------------------------------------------------*
DATA: go_cont_pohd TYPE REF TO cl_gui_custom_container,
      go_alv_pohd  TYPE REF TO cl_gui_alv_grid,
      gt_fcat_pohd TYPE lvc_t_fcat,
      gs_layout_pohd TYPE lvc_s_layo,
      gt_pohd  TYPE TABLE OF ztb1mm0006. " ## ### ### ###

*&---------------------------------------------------------------------*
*& ## ## ##
*&---------------------------------------------------------------------*
DATA: gv_msg_matnr TYPE matnr,  " ## # #### ###
      gv_show_msg  TYPE abap_bool, " ## ## ##
      gv_answer    TYPE char1. " ## ## ### Y/N ##
" ##### ##
DATA : gv_dynnr      TYPE sy-dynnr VALUE '0101',           "SUBSCREEN ## ##
       gv_dynnr_tab  TYPE sy-dynnr VALUE '0110',       "TABSTRIP SUBSCREEN
       " ##### ## ##, ## ##
       gv_save_check TYPE c LENGTH 1,                 "PO ## ## ## ##(###)
       gv_po_ebeln   TYPE zeb1_mm_ebeln,                "PO ## ## ## ##(###)
       " ## ##
       gv_check      TYPE char1, " 120# ## '## ## # # ###' ## ## ###
       gv_firsttime  TYPE char1, " #### #### # ## ### # ### ###
       go_timer      TYPE REF TO cl_gui_timer, " ###( ## # ## ) #### # ## ####
       gv_manual     TYPE c. " ## #### #### ## ## ## ##
