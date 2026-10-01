*&---------------------------------------------------------------------*
*& Include MZB1MM0003_TOP                           - Module Pool      SAPMZB1MM0003
*&---------------------------------------------------------------------*

INCLUDE <icon>.

DATA: ok_code         TYPE sy-ucomm,
      gv_dynnr        TYPE sy-dynnr VALUE '9000',           "SUBSCREEN ## ##
      gv_mode         TYPE char1, " ####, #####, ####
      gv_first_time   TYPE c VALUE 'X', " ## ## # 'X'# ##

      gv_ebeln        TYPE ztb1mm0014-ebeln,
      gv_select_ebeln TYPE ztb1mm0014-ebeln,
      gv_service      TYPE ztb1mm0014-ebeln,
      gv_mblnr        TYPE ztb1mm0011-ebeln,
      gv_belnr        TYPE ztb1mm0013-belnr, " ## ## ## !!!

      gv_doctxt       TYPE char20,   " ###PO ## ######
      gv_docno        TYPE char10,   " ## ## ##
      gv_rbstatxt     TYPE char20,   " #### ## ###
      gv_icon1        TYPE char30,   " ## ### 1 (#####)
      gv_icon2        TYPE char30,   "           2 (##/###)
      gv_icon3        TYPE char30,   "           3 (######)
      gv_stat1        TYPE char30,   " ## ### - ## ### /  ## ##(##) / (## ##)
      gv_stat2        TYPE char30,
      gv_stat3        TYPE char30.

DATA: rad1 TYPE c VALUE 'X', " ###: ### ##
      rad2 TYPE c,
      rad3 TYPE c,
      txt1 TYPE char20 VALUE '####',
      txt2 TYPE char20 VALUE '####',
      txt3 TYPE char20 VALUE '####'.

DATA: gv_balance    TYPE ztb1mm0014-dmbtr,
      gv_balicon    TYPE char30,
      gv_bptyp      TYPE char30,
      gv_bpnm       TYPE ztb1sd0001-bpnm,
      gv_ukurs      TYPE zcds_b1_mm_0003-add_ukurs,
      gv_org_ukurs  TYPE zcds_b1_mm_0003-add_ukurs,
      gv_wrbtr      TYPE ztb1mm0013-wrbtr,
      gv_bukrs      TYPE char30,
      gv_zterm      TYPE char30,
      gv_kschl      TYPE char30,
      gv_chk        TYPE c VALUE 'X',
      gv_wmwst      TYPE ztb1mm0014-wmwst,
      gv_save_check TYPE char1, " ## # ###(## ### ##
      gv_po_selected TYPE ztb1mm0014-ebeln." # ### #### ## #### #### #

*&---------------------------------------------------------------------*
*& #### ##, ### (ZTB1MM0006, ztb1mm0007)
*&---------------------------------------------------------------------*
DATA: BEGIN OF gs_pohd. " ebeln bpid bsart #### postat
        include structure ztb1mm0006.
DATA:   bpnm    TYPE ztb1sd0001-bpnm,
        bpidsv  TYPE ztb1sd0001-bpid,
        bpnmsv  TYPE ztb1sd0001-bpnm,
        col_fld TYPE char4,      " ex) C510
        lt_scol TYPE lvc_t_scol, " # ##
      END OF gs_pohd,
      gt_pohd LIKE TABLE OF gs_pohd.

*DATA: gs_pohd TYPE ztb1mm0006,
*      gt_pohd TYPE TABLE OF ztb1mm0006.

DATA: gs_poit TYPE ztb1mm0007,
      gt_poit TYPE TABLE OF ztb1mm0007.

DATA: gs_svit TYPE ztb1mm0007,
      gt_svit TYPE TABLE OF ztb1mm0007.

*&---------------------------------------------------------------------*
*& #### ## ##, ### (ZTB1MM0011, ZTB1MM0012)
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_grhd,
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
       END OF ty_grhd.
DATA: gs_grhd TYPE ty_grhd,
      gt_grhd TYPE TABLE OF ty_grhd.

TYPES: BEGIN OF ty_grit,
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
         add_ukurs TYPE zcds_b1_mm_0003-add_ukurs, " CDS View ## # ### ## ##
         netpr_usd TYPE ztb1mm0012-wrbtr, " #### ##(## ##### ##)
         wrbtr     TYPE ztb1mm0012-wrbtr,    " # ####(####)
         waers     TYPE ztb1mm0012-waers,    " ##
         insmk     TYPE ztb1mm0012-insmk,    " ## ##
         zloss     TYPE ztb1mm0012-zloss,    " ###
         kokrs     TYPE ztb1mm0012-kokrs,  " ######
         kostl     TYPE ztb1mm0012-kostl, " ### ##
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
       END OF ty_grit.

*TYPES: BEGIN OF ty_item_alv.
*         INCLUDE TYPE ty_item.
*TYPES:   excp_fld       TYPE char1,
*         col_fld        TYPE char4,      " ex) C510
*         lt_scol        TYPE lvc_t_scol, " # ##
*         it_cell_style  TYPE lvc_t_styl, " # ##/###
*         cancelled_icon TYPE icon_d,
*       END OF ty_item_alv. " ### ALV# ### ### ###

DATA: gs_grit TYPE ty_grit,
      gt_grit TYPE TABLE OF ty_grit.

*----------------------------------------------------------------------*
* ## ##, ### (ZTB1MM0013, ZTB1MM0014)
*----------------------------------------------------------------------*
TYPES: BEGIN OF ty_head,
         belnr  TYPE ztb1mm0013-belnr,   " ## ## ##
         gjahr  TYPE ztb1mm0013-gjahr,   " ## ## ##
         bldat  TYPE ztb1mm0013-bldat,   " ## ##
         budat  TYPE ztb1mm0013-budat,   " ## ##
         zfbdt  TYPE ztb1mm0013-zfbdt,   " ## ###
         zterm  TYPE ztb1mm0013-zterm,   " ## ##
         bpid   TYPE ztb1mm0013-bpid,    " BP ID
         bptyp  TYPE ztb1mm0013-bptyp,   " BP ##
         bukrs  TYPE ztb1mm0013-bukrs,   " ## ##
         bktxt  TYPE ztb1mm0013-bktxt,   " ## ## ###
         dmbtr  TYPE ztb1mm0013-dmbtr,   " # ####(##)
         waersk TYPE ztb1mm0013-waersk,  " ## ##
         wrbtr  TYPE ztb1mm0013-wrbtr,   " # ####(####)
         waers  TYPE ztb1mm0013-waers,   " ## ##
         ebeln  TYPE ztb1mm0013-ebeln,   " #### ##
         mblnr  TYPE ztb1mm0013-mblnr,   " ## ## ##
         rbstat TYPE ztb1mm0013-rbstat,  " ## ## (X, A, B #)
         lvorm  TYPE ztb1mm0013-lvorm,   " ####
         ernam  TYPE ztb1mm0013-ernam,   " ###
         erdat  TYPE ztb1mm0013-erdat,   " ###
         erzet  TYPE ztb1mm0013-erzet,   " ####
         aenam  TYPE ztb1mm0013-aenam,   " ###
         aedat  TYPE ztb1mm0013-aedat,   " ###
         aezet  TYPE ztb1mm0013-aezet,   " ####
       END OF ty_head.

TYPES: BEGIN OF ty_item,
         belnr          TYPE ztb1mm0014-belnr,   " ## ## ##
         gjahr          TYPE ztb1mm0014-gjahr,   " ## ## ##
         buzei          TYPE ztb1mm0014-buzei,   " ## ## ## ##
         werks          TYPE ztb1mm0014-werks,   " ### ##
         ebeln          TYPE ztb1mm0014-ebeln,   " #### ##
         ebelp          TYPE ztb1mm0014-ebelp,   " #### ## ##
         matnr          TYPE ztb1mm0014-matnr,   " ## ##
         menge          TYPE ztb1mm0014-menge,   " ##
         meins          TYPE ztb1mm0014-meins,   " ## ##
         " ### ## ###...
         dmbtr          TYPE ztb1mm0014-dmbtr,   " # ####(##)
         waersk         TYPE ztb1mm0014-waersk,  " ## ##
         add_ukurs      TYPE zcds_b1_mm_0003-add_ukurs, "##
         wrbtr          TYPE ztb1mm0014-wrbtr,   " # ####(####)
         waers          TYPE ztb1mm0014-waers,   " ## ##
         mwskz          TYPE ztb1mm0014-mwskz,   " ## ##
         mwskztxt       TYPE char30, " ## ## ### ##
         wmwst          TYPE ztb1mm0014-wmwst,   " ## ##(##)
         kschl          TYPE ztb1mm0014-kschl,   " ## ##
         lvorm          TYPE ztb1mm0014-lvorm,   " ####
         ernam          TYPE ztb1mm0014-ernam,   " ###
         erdat          TYPE ztb1mm0014-erdat,   " ###
         erzet          TYPE ztb1mm0014-erzet,   " ####
         aenam          TYPE ztb1mm0014-aenam,   " ###
         aedat          TYPE ztb1mm0014-aedat,   " ###
         aezet          TYPE ztb1mm0014-aezet,   " ####

         " ## ##
         netpr_usd      TYPE ztb1mm0012-netpr,     " ####(## ##)
         netpr          TYPE ztb1mm0012-netpr,     " ## ##

         mblnr          TYPE ztb1mm0012-mblnr,     " #### ## (## PO#)
         zeile          TYPE ztb1mm0012-zeile,     " #### ####
         org_bldat      TYPE ztb1mm0011-bldat, " #### ## ##

         org_netpr      TYPE ztb1mm0012-netpr,     " ## ##  (##)
         org_ukurs      TYPE zcds_b1_mm_0003-add_ukurs, " ##/## ## ## ##
         org_dmbtr      TYPE ztb1mm0012-dmbtr,     " ## ## ## ##

         " ALV ### ## ###
         excp_fld       TYPE char1,
         col_fld        TYPE char4,
         lt_scol        TYPE lvc_t_scol,
         it_cell_style  TYPE lvc_t_styl,
         cancelled_icon TYPE icon_d,
       END OF ty_item.

DATA: gs_head TYPE ty_head,
      gt_head TYPE TABLE OF ty_head,
      gs_item TYPE ty_item,
      gt_item TYPE TABLE OF ty_item.

*&---------------------------------------------------------------------*
*& #### ## (ZTB1SD0001, ZTB1SD0002, ZTB1MM0004)
*&---------------------------------------------------------------------*
DATA: BEGIN OF gs_vend, "vendor
        bpid   TYPE ztb1sd0001-bpid,      " BP ##
        bptyp  TYPE ztb1sd0001-bptyp,     " BP ##
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
*& 100# ### ALV ## ## ## (#### ###)
*&---------------------------------------------------------------------*
DATA: go_cont TYPE REF TO cl_gui_custom_container,
      go_alv  TYPE REF TO cl_gui_alv_grid.

DATA: gs_variant TYPE disvariant,
      gs_stable  TYPE lvc_s_stbl,
      gs_layout  TYPE lvc_s_layo,  "layout
      gt_uifunc  TYPE ui_functions.
DATA: gt_fcat_item TYPE lvc_t_fcat.

DATA: gv_col_pos TYPE int4,
      gv_visible TYPE char1.

*&---------------------------------------------------------------------*
*& 101# ### ALV ## ## ## (#### ###)
*&---------------------------------------------------------------------*
DATA:
*      go_cont_pohd TYPE REF TO cl_gui_dialogbox_container,
      go_cont_pohd TYPE REF TO cl_gui_custom_container,
      go_alv_pohd  TYPE REF TO cl_gui_alv_grid.

DATA: gs_layo_pohd   TYPE lvc_s_layo,  "layout
      gt_uifunc_pohd TYPE ui_functions.
DATA: gt_fcat_pohd TYPE lvc_t_fcat.

*&---------------------------------------------------------------------*
*& ## ## ##
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_check_head,
         belnr  TYPE ztb1mm0013-belnr,
         gjahr  TYPE ztb1mm0013-gjahr,
         bptyp  TYPE ztb1mm0013-bptyp,
         rbstat TYPE ztb1mm0013-rbstat,
         ebeln  TYPE ztb1mm0013-ebeln,
       END OF ty_check_head.

DATA: gt_check_head TYPE TABLE OF ty_check_head.

" ## ##
DATA: gv_check  TYPE char1, " 120# ## '## ## # # ###' ## ## ###
      go_timer  TYPE REF TO cl_gui_timer, " ###( ## # ## ) #### # ## ####
      gv_manual TYPE c. " ## #### #### ## ## ## ##

" ### ###
DATA: go_cont_logo TYPE REF TO cl_gui_custom_container, " ####
      go_logo       TYPE REF TO cl_gui_picture.          " ### ##

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
