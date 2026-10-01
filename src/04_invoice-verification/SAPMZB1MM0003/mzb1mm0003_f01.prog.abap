*&---------------------------------------------------------------------*
*& Include          MZB1MM0003_F01
*&---------------------------------------------------------------------*
*& FORM check_order_and_set_status (####/##### ## ## ## # ### ## ##)
*&---------------------------------------------------------------------*
FORM check_order_and_set_status CHANGING pv_error TYPE c.
  DATA: lv_ebeln TYPE ztb1mm0006-ebeln,
        ls_pohd  TYPE ztb1mm0006,
        lt_poit  TYPE TABLE OF ztb1mm0007,
        ls_poit  TYPE ztb1mm0007.

  DATA: lt_head  TYPE TABLE OF ty_check_head,
        lv_valid TYPE c.

  pv_error = abap_false. " ## ### ###

  lv_ebeln = gv_ebeln. " ##### ## # ##
  IF lv_ebeln IS INITIAL.
    MESSAGE s024(zmcb1) WITH '#### ##' DISPLAY LIKE 'E'. " ## ### ## ###
    pv_error = 'X'. " ## ### -> ### ##### ## ### ###
    EXIT.
  ENDIF.

  " 1. [####] ##
  SELECT SINGLE ebeln bpid ekorg ekgrp bukrs bsart bedat zterm inco1 zebeln zebelnsv knumh
    FROM ztb1mm0006
    INTO CORRESPONDING FIELDS OF ls_pohd
   WHERE ebeln = lv_ebeln
     AND lvorm <> 'X'.

  IF sy-subrc <> 0. " #### ## 45~~ # #### ####.
    MESSAGE s003(zmcb1) WITH '#### ##' lv_ebeln '' '' DISPLAY LIKE 'E'.
    pv_error = 'X'. " ## ###
    EXIT.
  ENDIF.

  " [####] ### -> POSTAT ## ##
  SELECT ebeln ebelp matnr werks lgort menge meins netpr dmbtr waersk
         wrbtr waers mwskz eindt slfdt insmk packno knttp sakto epstp postat
    FROM ztb1mm0007
    INTO CORRESPONDING FIELDS OF TABLE lt_poit
   WHERE ebeln = lv_ebeln
     AND postat <> '1' AND postat <> '2'
     AND lvorm <> 'X'.

  IF sy-subrc <> 0.
    MESSAGE s101(zmcb1) WITH '## ###' DISPLAY LIKE 'E'. " ## ### #### ### ## ##
    pv_error = 'X'. " ## ###
    EXIT.
  ENDIF.

  " 2. [##### = ####] ###### ## # POSTAT ##
  CLEAR gv_service.
  IF ls_pohd-zebelnsv IS NOT INITIAL. " ## ##### ## ### ### ## ##
    SELECT ebeln ebelp matnr werks lgort menge meins netpr dmbtr waersk
           wrbtr waers mwskz eindt slfdt insmk packno knttp sakto epstp postat
      FROM ztb1mm0007
      INTO CORRESPONDING FIELDS OF TABLE gt_svit
     WHERE ebeln = ls_pohd-zebelnsv
       AND lvorm <> 'X'.

    IF sy-subrc = 0.
      gv_service = ls_pohd-zebelnsv. " ##### ### ## ##
    ENDIF.
  ENDIF.

  " 3. [##] #### # ##### ## -> ## ## ## ##
  " ### ##### #### #### ####### ## ### ##
  IF gv_service IS NOT INITIAL.
    SELECT belnr, gjahr, bptyp, rbstat, ebeln
      FROM ztb1mm0013
      INTO CORRESPONDING FIELDS OF TABLE @lt_head
     WHERE ( ebeln = @gv_ebeln OR ebeln = @gv_service )
       AND lvorm <> 'X'.
  ELSE.
    SELECT belnr, gjahr, bptyp, rbstat, ebeln
      FROM ztb1mm0013
      INTO CORRESPONDING FIELDS OF TABLE @lt_head
     WHERE ebeln = @gv_ebeln
       AND lvorm <> 'X'.
  ENDIF.

  " 4. 101# ## ##
  CLEAR: gv_stat1, gv_stat2, gv_stat3, gv_icon1, gv_icon2, gv_icon3.  " ###

  PERFORM determine_invoice_status TABLES   lt_head
                                   USING    '1' gv_ebeln  " ### ## (BP## = 1)
                                   CHANGING gv_stat1 gv_icon1.
  PERFORM determine_invoice_status TABLES   lt_head
                                   USING    '3' gv_ebeln " ##/### ## (BP## = 3)
                                   CHANGING gv_stat2 gv_icon2.

  " #### #####(gv_service) #### ##### ##### ### ##### ##
  PERFORM determine_invoice_status TABLES   lt_head
                                   USING    '4' gv_service " ## #### (BP## = 4)
                                   CHANGING gv_stat3 gv_icon3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form determine_invoice_status (## ## - #### # ### ##)
*&---------------------------------------------------------------------*
FORM determine_invoice_status TABLES   pt_head LIKE gt_check_head
                              USING    pv_bptyp    TYPE ztb1mm0013-bptyp
                                       pv_ebeln    TYPE ztb1mm0014-ebeln
                              CHANGING pv_stat   TYPE char30
                                       pv_icon   TYPE char30.

  " #### + ## + #### # #### ### -> ls_head# ### ### #### ## ##
  DATA: ls_head   TYPE ty_check_head,
        lv_rbstat TYPE ztb1mm0013-rbstat,
        lv_found  TYPE char1. " ## ## ## ###

  CLEAR: lv_rbstat, lv_found.
  " ## ### ### ## ## 2# ## ##
  READ TABLE pt_head INTO ls_head WITH KEY ebeln = pv_ebeln
                                             bptyp = pv_bptyp.
  IF sy-subrc = 0.
    lv_rbstat = ls_head-rbstat.
    lv_found  = 'X'.
  ENDIF.

  " #### ### ### ### 'X'(###)# ## -> ## ###
  " ## # #### ## #### # ##(### ##)# ##### # ### ##### ## ##(## ### ##)
  IF lv_found IS INITIAL.
    pv_stat = '## ###'.

    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        name   = icon_led_red
        text   = ''
      IMPORTING
        result = pv_icon.

  ELSEIF lv_rbstat = 'X'.
    pv_stat = '### ## (####)'.

    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        name   = icon_led_yellow
        text   = ''
      IMPORTING
        result = pv_icon.

  ELSE.
    " #### #### ### A(##)# B(## ##) => ## ##
    CASE lv_rbstat.
      WHEN 'A'.
        pv_stat = '## ## (##)'.
      WHEN 'B'.
        pv_stat = '## ## (## ##)'.
    ENDCASE.

    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        name   = icon_led_green
        text   = ''
      IMPORTING
        result = pv_icon.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_good_receipt_data (## ### #### ## = ####)
*&---------------------------------------------------------------------*
FORM get_good_receipt_data.
  CLEAR: gt_item, gt_grit, gt_grhd, gv_kschl, gv_mblnr. " ### ##

  " 1. ## ### CDS ## #### ### ## #### ##, ### # ## ## ## ####
  SELECT mblnr, mjahr AS gjahr, zeile, bldat AS org_bldat,
           matnr, werks, menge, meins, dmbtr, waersk, add_ukurs,
           wrbtr, waers, ebeln, ebelp, lvorm, ernam, erdat, erzet, aenam, aedat, aezet,
           fin_netpr_usd AS netpr_usd, netpr, org_netpr, org_dmbtr
      FROM zcds_b1_mm_0003( p_bldat = @gs_head-bldat ) " gs_head-bldat# #### ## ## ### ##
      INTO TABLE @DATA(lt_cds_data)
     WHERE ebeln = @gv_ebeln
       AND bwart = '101'  " ## ##: 101 (#####)
       AND insmk = 'T'.  " ## ##: T (###### = ####)
  " CDS # #### ## lvorm <> 'X' ## ##(H, I, ## #####)

  " #### # ## ### ## ## # ## ### ##
  IF lt_cds_data IS INITIAL.
    SELECT mblnr, mjahr AS gjahr, zeile, bldat AS org_bldat,
           matnr, werks, menge, meins, dmbtr, waersk, add_ukurs,
           wrbtr, waers, ebeln, ebelp, lvorm, ernam, erdat, erzet, aenam, aedat, aezet,
           fin_netpr_usd AS netpr_usd, netpr, org_netpr, org_dmbtr
      FROM zcds_b1_mm_0003( p_bldat = @sy-datum ) " gs_head-bldat# #### ## ## ### ##
      INTO TABLE @lt_cds_data
     WHERE ebeln = @gv_ebeln AND bwart = '101' AND insmk = 'T'.
    IF lt_cds_data IS NOT INITIAL.
      MESSAGE s000(zmcb1) WITH ': #### ### ### # ## ## ### #####' DISPLAY LIKE 'W'. " ### ### ###### &1
    ELSE.
      MESSAGE s000(zmcb1) WITH '## ######' DISPLAY LIKE 'E'. " ### ### ###### &1
      EXIT.
    ENDIF.
  ENDIF.

  " ## ##(org_ukurs) ###
  DATA: lv_org_ukurs TYPE zcds_b1_mm_0003-add_ukurs.

  READ TABLE lt_cds_data INTO DATA(ls_first) INDEX 1.
  IF sy-subrc = 0 AND ls_first-org_bldat IS NOT INITIAL.
    SELECT SINGLE ukurs
      FROM ztb1fi0007
      INTO @lv_org_ukurs
     WHERE fcurr = @ls_first-waers
       AND tcurr = 'KRW'
       AND gdatu = @ls_first-org_bldat
       AND kurst LIKE '%M%'
       AND lvorm <> 'X'.
  ENDIF.

  " 2. ### CDS #### ## ### gt_item ### ## ##.
  LOOP AT lt_cds_data INTO DATA(ls_cds).
    CLEAR gs_item.

    " ### ### #### ## ## ## (DB# ## netpr, org_dmbtr # ##)
    MOVE-CORRESPONDING ls_cds TO gs_item.
    " ## ## ## ##
    IF gs_head-gjahr IS NOT INITIAL.
      gs_item-gjahr = gs_head-gjahr.
    ENDIF.
    gs_item-buzei     = sy-tabix * 10.       " ## ## ## ##
    gs_item-mwskz     = gs_vend-mwskz.  " ##### ### ## ##
    gs_item-add_ukurs = ls_cds-add_ukurs. " ## ## ## ##
    gs_item-org_ukurs = lv_org_ukurs. " #### ## ##

    PERFORM get_domain_text USING 'ZDB1_FI_MWSKZ' gs_item-mwskz CHANGING gs_item-mwskztxt. " ## / ##### # ## ##

    IF gv_mblnr IS INITIAL.
      gv_mblnr = gs_item-mblnr.
      gv_org_ukurs = gs_item-org_ukurs.
      gv_ukurs = gs_item-add_ukurs.
    ENDIF.

    CASE gv_mode.
      WHEN '1'.
        gs_item-kschl = 'OA00'. " ## (0%)

        IF gv_kschl IS INITIAL.
          PERFORM get_domain_text USING 'ZDB1_MM_KSCHL' gs_item-kschl CHANGING gv_kschl. " ### ## ####
          gv_chk = 'X'.
        ENDIF.
        CLEAR: gs_item-kschl, gs_item-wmwst. " ##### ## ##

      WHEN '3'.
        gs_item-kschl = 'MWST'. " ## ###

        IF gv_kschl IS INITIAL.
          PERFORM get_domain_text USING 'ZDB1_MM_KSCHL' gs_item-kschl CHANGING gv_kschl. " ### ## ####
          gv_chk = 'X'.
        ENDIF.

        IF gs_item-dmbtr IS NOT INITIAL. " ### 10% ## ####
          gs_item-dmbtr = round( val = ( gs_item-dmbtr / 10 ) dec = 0 ).
          gs_item-wmwst = gs_item-dmbtr. " ## ## (##)
        ENDIF.
        IF gs_item-wrbtr IS NOT INITIAL.
          gs_item-wrbtr = round( val = ( gs_item-wrbtr / 10 ) dec = 2 ).
        ENDIF.
    ENDCASE.

    APPEND gs_item TO gt_item.

    " ## ### ### (## ## # ## #### ##)
    READ TABLE gt_grhd TRANSPORTING NO FIELDS
      WITH KEY mblnr = ls_cds-mblnr
               mjahr = ls_cds-gjahr.
    IF sy-subrc <> 0.
      MOVE-CORRESPONDING ls_cds TO gs_grhd.
      APPEND gs_grhd TO gt_grhd.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_invoice_head (## ## # ### ## ### ##)
*&---------------------------------------------------------------------*
FORM set_invoice_head USING pv_eblen LIKE gv_ebeln.
  gs_head-bptyp   = gv_mode.
  PERFORM get_domain_text USING 'ZDB1_SD_BPTYP' gs_head-bptyp CHANGING gv_bptyp. " ### ## ####
  PERFORM get_domain_text USING 'ZDB1_MM_INVTYP' gs_head-bptyp CHANGING gs_head-bktxt. " ## ###(# #######) ####

  gs_head-budat = gs_head-bldat.
  gs_head-gjahr   = gs_head-bldat(4). " #### ## ###### ## 4## ##
  gs_head-zfbdt   = sy-datum.         " ## ### = ## ## ##

  " ###### ## #### gs_head ## ##### ##
  SELECT SINGLE zterm, bukrs, bpid
    FROM ztb1mm0006
    INTO ( @gs_head-zterm, @gs_head-bukrs, @gs_head-bpid )
   WHERE ebeln = @pv_eblen
     AND lvorm <> 'X'.

  " ### ## ### ### ## ### (####, ####)
  PERFORM get_domain_text USING 'ZDB1_MM_ZTERM' gs_head-zterm CHANGING gv_zterm.
  PERFORM get_domain_text USING 'ZDB1_MM_BUKRS' gs_head-bukrs CHANGING gv_bukrs.

  " GS_VEND ### ###: sd 1# # BP, 2# ####, mm 4# ## ### ## ####
  CASE gv_mode.
    WHEN '1' OR '4'.
      IF gs_head-bpid IS NOT INITIAL.
        SELECT SINGLE bpnm, cntcd, addr, bizno, email, accno, bank, waers, picnm, pictl
              FROM ztb1sd0001
              INTO CORRESPONDING FIELDS OF @gs_vend
             WHERE bptyp = @gs_head-bptyp
               AND bpid  = @gs_head-bpid.
      ENDIF.
    WHEN '3'.
      SELECT SINGLE bpid, bpnm, cntcd, addr, bizno, email, accno, bank, waers, picnm, pictl
              FROM ztb1sd0001
              INTO CORRESPONDING FIELDS OF @gs_vend
             WHERE bptyp = @gs_head-bptyp.

      CLEAR: gs_head-bpid.
      gs_head-bpid = gs_vend-bpid.
  ENDCASE.

  IF gs_head-bpid IS NOT INITIAL. " BPID# #### ##
    SELECT SINGLE recon
   FROM ztb1sd0002
   INTO ( @gs_vend-recon )
  WHERE bpid = @gs_head-bpid
  AND bptyp = @gs_head-bptyp.

    SELECT SINGLE mwskz, zvlead " ## ## # ####(## ###) ##
      FROM ztb1mm0004
      INTO ( @gs_vend-mwskz, @gs_vend-zvlead )
     WHERE bpid = @gs_head-bpid.
  ENDIF.

  " ### ##(ZTB1MM0013)## ### ## ### ## ####
  SELECT SINGLE belnr, wrbtr, waers, dmbtr, waersk, rbstat
    FROM ztb1mm0013
    INTO ( @gs_head-belnr, @gs_head-wrbtr, @gs_head-waers, @gs_head-dmbtr, @gs_head-waersk, @gs_head-rbstat )
   WHERE ebeln = @pv_eblen
     AND bpid = @gs_head-bpid " BPID# BPTYP# ### ####, ### #### ## gv_mode# ## ## ## #### ###
     AND bptyp = @gs_head-bptyp
     AND rbstat = 'X'. " ### = ### ### #
  IF gs_head-waersk IS INITIAL.
    gs_head-waersk = 'KRW'.
  ENDIF.

  PERFORM get_domain_text USING 'ZDB1_MM_RBSTAT' gs_head-rbstat CHANGING gv_rbstatxt.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form process_goods_invoice (## ## - 102# #### ### ##)
*&---------------------------------------------------------------------*
FORM process_goods_invoice.
  gv_mode = '1'. " #### ## ##

  " ## ## ## ##
  PERFORM set_invoice_head USING gv_ebeln.

  " ### ## ## ##
  gv_balance = gs_head-wrbtr. " ## ### ### #### ##
  gv_balicon = icon_red_light. " ### ### ### ##
  CLEAR gv_wrbtr.

  " ##### #### ###### ####
  PERFORM get_good_receipt_data.

  gv_doctxt       = '#### ##'.
  gv_docno        = gv_mblnr. " CDS## ### #### ## ##

ENDFORM.
*&---------------------------------------------------------------------*
*& Form process_customs_invoice (###/## - 102# #### ### ##)
*&---------------------------------------------------------------------*
FORM process_customs_invoice.
  gv_mode = '3'. " ###/## ## ##

  " ## ## ## ##
  PERFORM set_invoice_head USING gv_ebeln.

  " ### ## ## ##
  gv_balance = gs_head-wrbtr. " ## ### ### #### ##
  gv_balicon = icon_red_light. " ### ### ### ##
  CLEAR gv_wrbtr.

  " ##### #### ###### ####
  PERFORM get_good_receipt_data.

  gv_doctxt       = '#### ##'.
  gv_docno        = gv_mblnr. " CDS## ### #### ## ##
ENDFORM.
*&---------------------------------------------------------------------*
*& Form process_freight_invoice (## #### - 102# #### ### ##)
*&---------------------------------------------------------------------*
FORM process_freight_invoice.
  gv_mode = '4'. " ### ##

  " ## ## ## ##
  PERFORM set_invoice_head USING gv_service.

  " ### ## ## ##
  gv_balance = gs_head-wrbtr. " ## ### ### #### ##
  gv_balicon = icon_red_light. " ### ### ### ##
  CLEAR gv_wrbtr.

  PERFORM get_freight_invoice_data.

  gv_doctxt       = '##### ##'.
  gv_docno        = gv_service.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_freight_invoice_data (## ### ## ###PO ### ##)
*&---------------------------------------------------------------------*
FORM get_freight_invoice_data.
  CLEAR: gt_item, gv_kschl. " ### ##

  SELECT ebeln, ebelp, bedat AS org_bldat,
           matnr, werks, menge, meins, dmbtr AS org_dmbtr, waersk, add_ukurs,
           wrbtr, waers, lvorm, ernam, erdat, erzet, aenam, aedat, aezet,
           fin_netpr_usd AS netpr_usd, fin_netpr_krw AS netpr, netpr AS org_netpr
      FROM zcds_b1_mm_0002( p_bldat = @gs_head-bldat ) " gs_head-bldat# #### ## ## ### ##
      INTO TABLE @DATA(lt_cds_data)
     WHERE ebeln = @gv_service.
*     AND lvorm <> 'X'. " cds### # # #####

  " #### ### ## # ##
  IF lt_cds_data IS INITIAL..
    SELECT ebeln, ebelp, bedat AS org_bldat,
           matnr, werks, menge, meins, dmbtr AS org_dmbtr, waersk, add_ukurs,
           wrbtr, waers, lvorm, ernam, erdat, erzet, aenam, aedat, aezet,
           fin_netpr_usd AS netpr_usd, fin_netpr_krw AS netpr, netpr AS org_netpr
      FROM zcds_b1_mm_0002( p_bldat = @sy-datum )
      INTO TABLE @lt_cds_data
     WHERE ebeln = @gv_service.
    IF lt_cds_data IS NOT INITIAL.
      MESSAGE s000(zmcb1) WITH ': #### ### ### # ## ## ### #####' DISPLAY LIKE 'W'. " ### ### ###### &1
    ELSE.
      MESSAGE s000(zmcb1) WITH '## ######' DISPLAY LIKE 'E'. " ### ### ###### &1
      EXIT.
    ENDIF.
  ENDIF.

  " ## ##(org_ukurs) ###
  DATA: lv_org_ukurs TYPE zcds_b1_mm_0002-add_ukurs.

  READ TABLE lt_cds_data INTO DATA(ls_first) INDEX 1.
  IF sy-subrc = 0 AND ls_first-org_bldat IS NOT INITIAL.
    SELECT SINGLE ukurs
      FROM ztb1fi0007
      INTO @lv_org_ukurs
     WHERE fcurr = @ls_first-waers
       AND tcurr = 'KRW'
       AND gdatu = @ls_first-org_bldat
       AND kurst LIKE '%M%'
       AND lvorm <> 'X'.
  ENDIF.

  " 2. ### #### ## ### ###(gt_item)# ## ##
  LOOP AT lt_cds_data INTO DATA(ls_po).
    CLEAR gs_item.

    " ### ### #### ## ## ##
    MOVE-CORRESPONDING ls_po TO gs_item.

    " ## ## ## ##
    IF gs_head-gjahr IS NOT INITIAL.
      gs_item-gjahr = gs_head-gjahr.
    ENDIF.
    gs_item-buzei     = sy-tabix * 10.       " ## ## ## ##
    gs_item-mwskz     = gs_vend-mwskz.       " ##### ### ## ##
    PERFORM get_domain_text USING 'ZDB1_FI_MWSKZ' gs_item-mwskz CHANGING gs_item-mwskztxt. " ## / ##### # ## ##

    gs_item-add_ukurs = ls_po-add_ukurs. " ## ## ## ##
    gs_item-org_ukurs = lv_org_ukurs. " #### ## ##

    gs_item-dmbtr = gs_item-netpr * gs_item-menge.

    IF gv_ukurs IS INITIAL.
      gv_org_ukurs = gs_item-org_ukurs.
      gv_ukurs = gs_item-add_ukurs.
    ENDIF.

    IF gv_kschl IS INITIAL.
      gs_item-kschl = 'OA00'.
      PERFORM get_domain_text USING 'ZDB1_MM_KSCHL' gs_item-kschl CHANGING gv_kschl.
      gv_chk = ''.
      CLEAR gs_item-kschl.
    ENDIF.

    CLEAR gs_item-wmwst. " ## ## ## # ### ##

    APPEND gs_item TO gt_item.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_po_data
*&---------------------------------------------------------------------*
FORM get_po_data .
  " ALV ## # ## ### ## ## ##
  DATA: lt_color TYPE lvc_t_scol,
        ls_color TYPE lvc_s_scol.

  SELECT ebeln, bpid, ekorg, ekgrp, bukrs, bsart, bedat, zterm, inco1, zebelnsv, knumh
      FROM ztb1mm0006
      INTO CORRESPONDING FIELDS OF TABLE @gt_pohd
      WHERE bsart = 'NB' " ##### ##
        AND lvorm <> 'X'. " ## ##

  IF gt_pohd[] IS NOT INITIAL.

    LOOP AT gt_pohd ASSIGNING FIELD-SYMBOL(<fs_pohd>).

      CLEAR: lt_color, ls_color.

      IF <fs_pohd>-bpid IS NOT INITIAL. " BPID# ## ## ###
        SELECT SINGLE bpnm INTO @<fs_pohd>-bpnm
          FROM ztb1sd0001
         WHERE bpid = @<fs_pohd>-bpid AND bptyp = '1'.
      ENDIF.

      " ####### = #### ### #####
      IF <fs_pohd>-zebelnsv IS NOT INITIAL.
*        " #### ## ## ## ## (##)
*        ls_color-fname     = 'ZEBELNSV'.
*        ls_color-color-col = 5.
*        ls_color-color-int = 0.
*        APPEND ls_color TO lt_color.

        " ebeln ### ## 0006# ### ###
        DATA: lv_sv_bpid TYPE ztb1mm0006-bpid.
        CLEAR lv_sv_bpid.

        " #### ID, ####### # ## ##
        SELECT SINGLE bpid INTO @lv_sv_bpid
          FROM ztb1mm0006
         WHERE ebeln = @<fs_pohd>-zebelnsv
           AND lvorm <> 'X'.

        IF lv_sv_bpid IS NOT INITIAL.
          <fs_pohd>-bpidsv = lv_sv_bpid.

*          CLEAR: ls_color.
*          ls_color-fname     = 'BPIDSV'.
*          ls_color-color-col = 1.
*          ls_color-color-int = 0.
*          APPEND ls_color TO lt_color.

          SELECT SINGLE bpnm INTO @<fs_pohd>-bpnmsv
            FROM ztb1sd0001
           WHERE bpid = @lv_sv_bpid AND bptyp = '4'.

          IF <fs_pohd>-bpnmsv IS INITIAL.
            SELECT SINGLE bpnm INTO @<fs_pohd>-bpnmsv
               FROM ztb1sd0001
              WHERE bpid = @lv_sv_bpid
              AND bptyp = '1'.
          ENDIF.
        ENDIF.
      ENDIF.

*      <fs_pohd>-lt_scol = lt_color.
    ENDLOOP.
  ENDIF.

  SORT gt_pohd BY ebeln.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_object (100# ### #### item ALV ##)
*&---------------------------------------------------------------------*
FORM create_object USING pv_area   TYPE any        " ###### Custom Control ##
                    CHANGING po_cont TYPE REF TO cl_gui_custom_container
                             po_alv TYPE REF TO cl_gui_alv_grid.

  CREATE OBJECT po_cont " Custom Container ####, Area# ##
    EXPORTING
      container_name              = pv_area " ### Layout# ## ## ##
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.

  CREATE OBJECT po_alv " ALV Grid ## #### Container# ##
    EXPORTING
      i_parent          = po_cont
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.

**   #### ## ## ### ## #, ### # ## ## ## #### #### #### # #### ##
*  po_alv->register_edit_event( i_event_id = cl_gui_alv_grid=>mc_evt_enter ).
*  po_alv->register_edit_event( i_event_id = cl_gui_alv_grid=>mc_evt_modified ).

*   ALV# ## ### ## ## ## ### ## #### #
  " po_alv->set_ready_for_input( i_ready_for_input = 1 ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_alv (ALV ### ## - ## ALV ## )
*&---------------------------------------------------------------------*
FORM display_alv USING    ps_layout  TYPE lvc_s_layo
                          pt_uifunc  TYPE ui_functions
                          pt_fcat    TYPE lvc_t_fcat
                 CHANGING po_alv     TYPE REF TO cl_gui_alv_grid
                          pt_outtab  TYPE ANY TABLE. " ## ### ##### # ##!

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
*& Form refresh_alv (100# ### alv ###### - ## #### ##)
*&---------------------------------------------------------------------*
* SAPMZB1MM0002## #### [Refresh ##] 2##
* 1. go_alv->refresh_table_display( ):
* - ## ### ## # ##.
*
* 2. PERFORM refresh_alv:
* - # ##/##/## # '#### ## ## #'# ### # ## (ex - ### ###)
* - is_stable ### ## ## ### ### ###
*----------------------------------------------------------------------*
FORM refresh_alv CHANGING ps_stable TYPE lvc_s_stbl
                          po_alv TYPE REF TO cl_gui_alv_grid.

  ps_stable-row = 'X'. " ##### # ## ### ## ##
  ps_stable-col = 'X'. " ## ## ##
*  po_alv->get_current_cell( IMPORTING es_row_no = gs_row_st ).
*
*  ps_stable-row = abap_true.
*  ps_stable-col = abap_true.

  CALL METHOD po_alv->refresh_table_display
    EXPORTING
      is_stable      = ps_stable
      i_soft_refresh = 'X'  "x: ##, ##, ## ### ## -> ### #### #####
    EXCEPTIONS            "_: ## ####(##)
      finished       = 1
      OTHERS         = 2.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout (100# ### ALV #### ##)
*&---------------------------------------------------------------------*
FORM set_layout USING pv_type TYPE i
                CHANGING ps_layout TYPE lvc_s_layo.
  CLEAR ps_layout.
  IF pv_type = 1.
    " item## #### alv layout ##
*    ps_layout-sel_mode   = 'D'. " # ## ## ##
    ps_layout-grid_title = gv_doctxt && ' ###'.
  ELSEIF pv_type = 2.
    ps_layout-grid_title = '#### ##'.
    ps_layout-no_toolbar = 'X'. "## ##(## ui_func ## ## ##)
    ps_layout-sel_mode   = 'B'. " ##/## # ## ##
    ps_layout-cwidth_opt = 'X'. " # ## ## ###
    ps_layout-ctab_fname = 'LT_SCOL'.
    ps_layout-info_fname = 'COL_FLD'. " # ## ## ## ##
  ELSEIF pv_type = 3.
  ENDIF.
  " ## ##
  ps_layout-zebra      = 'X'. " ### ##
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_uifunc (100# ### ALV ## ## ## ##)
*&---------------------------------------------------------------------*
FORM set_uifunc USING pv_type TYPE i
                      pt_uifunc  TYPE ui_functions.
  REFRESH pt_uifunc.
  IF pv_type = 1.
    " item## #### ui function ##
    APPEND cl_gui_alv_grid=>mc_fc_detail       TO pt_uifunc. " ### ###
    APPEND cl_gui_alv_grid=>mc_fc_loc_copy     TO pt_uifunc.

    " # ### # ##, ## ## ### ####
    APPEND cl_gui_alv_grid=>mc_fc_loc_append_row       TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_fc_loc_undo        TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_fc_refresh       TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_fc_check        TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_fc_loc_cut      TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_fc_loc_paste    TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_fc_loc_paste_new_row TO pt_uifunc.
    APPEND cl_gui_alv_grid=>mc_fc_sort_asc     TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_fc_sort_dsc     TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_fc_find         TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_fc_filter       TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_fc_print        TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_fc_graph        TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_fc_info         TO pt_uifunc. "
    APPEND cl_gui_alv_grid=>mc_mb_sum          TO pt_uifunc.
    APPEND cl_gui_alv_grid=>mc_mb_variant      TO pt_uifunc.
    APPEND cl_gui_alv_grid=>mc_mb_view         TO pt_uifunc.
    APPEND cl_gui_alv_grid=>mc_mb_export       TO pt_uifunc.
  ELSE.
    APPEND cl_gui_alv_grid=>mc_fc_info         TO pt_uifunc.
  ENDIF.
  " ## ##
*    APPEND cl_gui_alv_grid=>mc_fc_excl_all TO pt_uifunc. " ## # ###
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
*& set_fcat_item (100# ### ALV ## #### ##)
*&---------------------------------------------------------------------*
FORM set_fcat_item CHANGING ct_fcat_item TYPE lvc_t_fcat.
  REFRESH ct_fcat_item.

  PERFORM set_fcat TABLES ct_fcat_item USING:
*    'S' 'FIELDNAME' 'BELNR', ' ' 'COLTEXT' '## ## ##', ' ' 'OUTPUTLEN' '15', ' ' 'JUST' 'C', ' ' 'KEY' 'X', ' ' 'EMPHASIZE' 'C110', 'E' '' '',
*    'S' 'FIELDNAME' 'GJAHR', ' ' 'COLTEXT' '## ##',     ' ' 'OUTPUTLEN' '6',  ' ' 'JUST' 'C', ' ' 'KEY' 'X', ' ' 'EMPHASIZE' 'C110', 'E' '' '',

    'S' 'FIELDNAME' 'BUZEI', ' ' 'COLTEXT' '####',         ' ' 'COL_POS' '2',     ' ' 'OUTPUTLEN' '6',     ' ' 'JUST' 'C', ' ' 'EMPHASIZE' 'C110', ' ' 'NO_SUM' 'X', 'E' '' '',
    'S' 'FIELDNAME' 'WERKS', ' ' 'COLTEXT' '###',          ' ' 'COL_POS' '3',     ' ' 'OUTPUTLEN' '6',     ' ' 'JUST' 'C', 'E' '' '',
    'S' 'FIELDNAME' 'MATNR', ' ' 'COLTEXT' '####',         ' ' 'COL_POS' '4',     ' ' 'OUTPUTLEN' '8',    ' ' 'JUST' 'C', 'E' '' '',
    'S' 'FIELDNAME' 'MEINS', ' ' 'COLTEXT' '## ##',        ' ' 'COL_POS' '6',     ' ' 'OUTPUTLEN' '6',    ' ' 'JUST' 'C', 'E' '' '',

    'S' 'FIELDNAME' 'DMBTR',    ' ' 'COLTEXT' '## ####',  ' ' 'COL_POS' '8',     ' ' 'OUTPUTLEN' '15',    ' ' 'NO_ZERO' 'X',        ' ' 'DECIMALS_O' '0', ' ' 'CFIELD' 'WAERSK', 'E' '' '',
    'S' 'FIELDNAME' 'WAERSK',   ' ' 'COLTEXT' '##',         ' ' 'COL_POS' '10',     ' ' 'OUTPUTLEN' '6',    ' ' 'REF_TABLE' 'ZTB1MM0014', ' ' 'REF_FIELD' 'WAERSK', ' ' 'JUST' 'C', 'E' '' '',
    'S' 'FIELDNAME' 'ADD_UKURS',' ' 'COLTEXT' '##',        ' ' 'COL_POS' '12',     ' ' 'OUTPUTLEN' '12',   ' ' 'NO_SUM' 'X',         'E' '' '',

    'S' 'FIELDNAME' 'WRBTR', ' ' 'COLTEXT' '## ######',  ' ' 'COL_POS' '13',     ' ' 'DO_SUM' 'X',        ' ' 'OUTPUTLEN' '15',  ' ' 'REF_TABLE' 'ZTB1MM0012', ' ' 'REF_FIELD' 'WRBTR', ' ' 'EMPHASIZE' 'C500', ' ' 'NO_ZERO' 'X', 'E' '' '',
    'S' 'FIELDNAME' 'WAERS', ' ' 'COLTEXT' '####',        ' ' 'COL_POS' '14',     ' ' 'OUTPUTLEN' '6',     ' ' 'JUST' 'C', 'E' '' ''.
*    'S' 'FIELDNAME' 'KSCHL', ' ' 'COLTEXT' '## ##',        ' ' 'COL_POS' '15',     ' ' 'OUTPUTLEN' '6',   ' ' 'JUST' 'C', 'E' '' '',
*    'S' 'FIELDNAME' 'ORG_UKURS',' ' 'COLTEXT' '## ## ##',  ' ' 'COL_POS' '1',     ' ' 'OUTPUTLEN' '12', 'E' '' '',

  CASE gv_mode.
    WHEN '1'.
      PERFORM set_fcat TABLES ct_fcat_item USING:
      'S' 'FIELDNAME' 'MBLNR', ' ' 'COLTEXT' '#### ##',   ' ' 'COL_POS' '1', ' ' 'OUTPUTLEN' '12', ' ' 'JUST' 'C', ' ' 'EMPHASIZE' 'C110', 'E' '' '',
      'S' 'FIELDNAME' 'MENGE', ' ' 'COLTEXT' '##',           ' ' 'COL_POS' '5',     ' ' 'OUTPUTLEN' '12',    ' ' 'QFIELDNAME' 'MEINS', ' ' 'NO_ZERO' 'X', 'E' '' '',
      'S' 'FIELDNAME' 'ORG_DMBTR',    ' ' 'COLTEXT' '#### ####',  ' ' 'COL_POS' '7',     ' ' 'OUTPUTLEN' '15',    ' ' 'NO_ZERO' 'X',        ' ' 'DECIMALS_O' '0', 'E' '' '',
      'S' 'FIELDNAME' 'MWSKZ', ' ' 'COLTEXT' '## ##',        ' ' 'COL_POS' '10',     ' ' 'OUTPUTLEN' '6',   ' ' 'JUST' 'C', 'E' '' '',
      'S' 'FIELDNAME' 'MWSKZTXT', ' ' 'COLTEXT' '#### ##',   ' ' 'COL_POS' '11',     ' ' 'JUST' 'C',      ' ' 'OUTPUTLEN' '10', 'E' '' '',
      'S' 'FIELDNAME' 'ORG_BLDAT',' ' 'COLTEXT' '#### ###',  ' ' 'COL_POS' '15',     ' ' 'OUTPUTLEN' '12',   ' ' 'JUST' 'C',    ' ' 'NO_SUM' 'X',     'E' '' '',
      'S' 'FIELDNAME' 'ORG_NETPR',' ' 'COLTEXT' '#### ####',   ' ' 'COL_POS' '16',     ' ' 'OUTPUTLEN' '12', ' ' 'NO_ZERO' 'X', ' ' 'DECIMALS_O' '0', 'E' '' '',
      'S' 'FIELDNAME' 'NETPR',    ' ' 'COLTEXT' '## ##',      ' ' 'COL_POS' '17',     ' ' 'OUTPUTLEN' '12', ' ' 'NO_ZERO' 'X', ' ' 'DECIMALS_O' '0', 'E' '' '',
      'S' 'FIELDNAME' 'NETPR_USD',' ' 'COLTEXT' '## ##',      ' ' 'COL_POS' '18',     ' ' 'OUTPUTLEN' '12', ' ' 'REF_TABLE' 'ZTB1MM0012', ' ' 'REF_FIELD' 'WRBTR', ' ' 'NO_ZERO' 'X', 'E' '' ''
     .
    WHEN '3'.
      PERFORM set_fcat TABLES ct_fcat_item USING:
      'S' 'FIELDNAME' 'MBLNR', ' ' 'COLTEXT' '#### ##',   ' ' 'COL_POS' '1', ' ' 'OUTPUTLEN' '12', ' ' 'JUST' 'C', ' ' 'EMPHASIZE' 'C110', 'E' '' '',
      'S' 'FIELDNAME' 'MENGE', ' ' 'COLTEXT' '##',           ' ' 'COL_POS' '5',     ' ' 'OUTPUTLEN' '12',    ' ' 'QFIELDNAME' 'MEINS', ' ' 'NO_ZERO' 'X', 'E' '' '',
      'S' 'FIELDNAME' 'MWSKZ', ' ' 'COLTEXT' '## ##',        ' ' 'COL_POS' '8',     ' ' 'OUTPUTLEN' '6',   ' ' 'JUST' 'C', 'E' '' '',
      'S' 'FIELDNAME' 'MWSKZTXT', ' ' 'COLTEXT' '#### ##',   ' ' 'COL_POS' '9',     ' ' 'JUST' 'C',      ' ' 'OUTPUTLEN' '15', 'E' '' '',
      'S' 'FIELDNAME' 'WMWST', ' ' 'COLTEXT' '## ##',   ' ' 'COL_POS' '10',     ' ' 'OUTPUTLEN' '15',   ' ' 'NO_ZERO' 'X',        ' ' 'DECIMALS_O' '0', 'E' '' '',
      'S' 'FIELDNAME' 'ORG_BLDAT',' ' 'COLTEXT' '#### ###',  ' ' 'COL_POS' '15',     ' ' 'OUTPUTLEN' '12',   ' ' 'JUST' 'C', 'E' '' ''.
    WHEN '4'.
      PERFORM set_fcat TABLES ct_fcat_item USING:
      'S' 'FIELDNAME' 'EBELN', ' ' 'COLTEXT' '#### ##',   ' ' 'COL_POS' '1', ' ' 'OUTPUTLEN' '12', ' ' 'JUST' 'C', ' ' 'EMPHASIZE' 'C110', 'E' '' '',
      'S' 'FIELDNAME' 'MENGE', ' ' 'COLTEXT' '##',           ' ' 'COL_POS' '5',     ' ' 'OUTPUTLEN' '5',    ' ' 'QFIELDNAME' 'MEINS', ' ' 'NO_ZERO' 'X', 'E' '' '',
      'S' 'FIELDNAME' 'ORG_DMBTR',    ' ' 'COLTEXT' '#### ####',  ' ' 'COL_POS' '7',     ' ' 'OUTPUTLEN' '15',  ' ' 'NO_ZERO' 'X',        ' ' 'DECIMALS_O' '0', 'E' '' '',
      'S' 'FIELDNAME' 'MWSKZ', ' ' 'COLTEXT' '## ##',        ' ' 'COL_POS' '10',     ' ' 'OUTPUTLEN' '6',   ' ' 'JUST' 'C', 'E' '' '',
      'S' 'FIELDNAME' 'MWSKZTXT', ' ' 'COLTEXT' '#### ##',   ' ' 'COL_POS' '11',     ' ' 'JUST' 'C',      ' ' 'OUTPUTLEN' '10', 'E' '' '',
      'S' 'FIELDNAME' 'ORG_BLDAT',' ' 'COLTEXT' '##### ###',  ' ' 'COL_POS' '15',     ' ' 'OUTPUTLEN' '12',   ' ' 'JUST' 'C', 'E' '' '',
      'S' 'FIELDNAME' 'ORG_NETPR',' ' 'COLTEXT' '#### ####',   ' ' 'COL_POS' '16',     ' ' 'OUTPUTLEN' '14', ' ' 'NO_ZERO' 'X', ' ' 'DECIMALS_O' '0', 'E' '' '',
      'S' 'FIELDNAME' 'NETPR',    ' ' 'COLTEXT' '## ##',      ' ' 'COL_POS' '17',     ' ' 'OUTPUTLEN' '14', ' ' 'NO_ZERO' 'X', ' ' 'DECIMALS_O' '0', 'E' '' '',
      'S' 'FIELDNAME' 'NETPR_USD',' ' 'COLTEXT' '## ##',      ' ' 'COL_POS' '18',     ' ' 'OUTPUTLEN' '12', ' ' 'REF_TABLE' 'ZTB1MM0012', ' ' 'REF_FIELD' 'WRBTR', ' ' 'NO_ZERO' 'X', 'E' '' ''.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_pohd (#### alv ###### ##)
*&---------------------------------------------------------------------*
FORM set_fcat_pohd CHANGING pt_fcat TYPE lvc_t_fcat.

  DATA: ls_fcat TYPE lvc_s_fcat.
  CLEAR pt_fcat.

  DEFINE _add_fcat.
    CLEAR ls_fcat.
    ls_fcat-fieldname = &1.
    ls_fcat-coltext   = &2.
    ls_fcat-outputlen = &3.
    ls_fcat-f4availabl = &4.

    " ## ### ## ## ##
    CASE &1.
    WHEN 'EBELN'.
       ls_fcat-emphasize = 'C110'. " # ## ## ##
    WHEN 'BPID' OR 'BPIDSV'.
      ls_fcat-emphasize = 'C100'.
    WHEN 'ZEBELNSV' .
      ls_fcat-emphasize = 'C400'.
    WHEN 'KNUMH'.
*      ls_fcat-icon = 'X'. "
      ls_fcat-lzero = 'X'.
      ls_fcat-just = 'C'. " ### ##
    WHEN 'BPNM' OR 'BPNMSV' OR 'BEDAT'.
    WHEN OTHERS.
      ls_fcat-ref_table = 'ZTB1MM0006'.
      ls_fcat-ref_field = &1.
    ENDCASE.

    ls_fcat-tooltip = '##### ### ## ## ##'.

    APPEND ls_fcat TO pt_fcat.
  END-OF-DEFINITION.

  "          [FieldName]   [ColText (## ##)]     [OutputLen]        [f4availabl]
  _add_fcat 'EBELN'          '#### ##'               15                 ''.
  _add_fcat 'BPID'           '#### ##'               12                 ''.
  _add_fcat 'BPNM'           '#####'                 25                 ''.
  _add_fcat 'EKORG'          '####'                   8                 'X'.
  _add_fcat 'EKGRP'          '####'                   8                 'X'.
  _add_fcat 'BUKRS'          '####'                   8                 'X'.
  _add_fcat 'BSART'          '####'                   8                 'X'.
  _add_fcat 'BEDAT'          '####'                   12                 ''.
  _add_fcat 'ZTERM'          '####'                   10                 'X'.
  _add_fcat 'INCO1'          '####'                   10                 'X'.
  _add_fcat 'ZEBELNSV'       '#### ##'               15                 ''.
  _add_fcat 'BPIDSV'         '#### ##'               15                 ''.
  _add_fcat 'BPNMSV'         '#####'                  25                 ''.
  _add_fcat 'KNUMH'          '#### ##'                15                 ''.

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
*& Form calculate_invoice_balance (### ## ## # ### # ### ### ##)
*&---------------------------------------------------------------------*
FORM calculate_invoice_balance.

  " [## ####] ### ## #(usd)# ### ## ### ### ##
  IF gv_wrbtr < 0. " 1) ## ## ##
    MESSAGE s000(zmcb1) DISPLAY LIKE 'E' WITH ': ## ### ## #####'.
    CLEAR: gv_wrbtr, gs_head-dmbtr, gv_balance.
    gv_balicon = icon_red_light.
    EXIT.
  ENDIF.

  " 2) ## ## (USD ### # 1500# # # KRW #### #### USD ### ## ### ###)
  DATA: lv_max_krw TYPE p LENGTH 13 DECIMALS 2 VALUE '999999999999999.00',
        lv_max_usd TYPE p LENGTH 13 DECIMALS 2.

  " ## ## ## ## ### ## USD (## ### / ## ##)
  IF gv_ukurs IS NOT INITIAL AND gv_ukurs > 0.
    lv_max_usd = lv_max_krw / gv_ukurs.

    " #### ### ## ## ## ## ## ## USD# #### ### ## ## ##
    IF gv_wrbtr > lv_max_usd.
      MESSAGE s126(zmcb1) DISPLAY LIKE 'E'
        WITH '## ## ' lv_max_usd ' USD'. " ## ## ## ## ### ## ## ## lv_max_usd USD# ######`
      CLEAR: gv_wrbtr, gs_head-dmbtr, gv_balance.
      gv_balicon = icon_red_light.
      EXIT.
    ENDIF.
  ELSE.
    " ### ### ## ### ###### dmbtr # balance ### ###
    CLEAR: gs_head-dmbtr, gv_balance.
    gv_balicon = icon_red_light.
    EXIT.
  ENDIF.

  " [## ##] ## ## ##
  IF gv_wrbtr IS NOT INITIAL AND gv_ukurs IS NOT INITIAL.
    DATA: lv_calc_dmbtr TYPE p LENGTH 8 DECIMALS 2.
    lv_calc_dmbtr = round( val = ( gv_wrbtr * gv_ukurs ) dec = 0 ).

    " ### ## ### ### ## ##
    IF lv_calc_dmbtr > 999999999999999.
      MESSAGE s126(zmcb1) DISPLAY LIKE 'E' WITH '## ###' '## ##' ''.
      CLEAR: gv_wrbtr, gs_head-dmbtr, gv_balance.
      gv_balicon = icon_red_light.
      EXIT.
    ENDIF.

    " ##### ## ### ## ####
    IF gs_head-waersk = 'KRW'.
      CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
        EXPORTING
          currency    = 'KRW'
          idoc_amount = lv_calc_dmbtr
        IMPORTING
          sap_amount  = gs_head-dmbtr.
    ELSE.
      CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
        EXPORTING
          currency    = gs_head-waersk
          idoc_amount = lv_calc_dmbtr
        IMPORTING
          sap_amount  = gs_head-dmbtr.
    ENDIF.
*    gs_head-dmbtr = lv_calc_dmbtr.

  ELSE.
    CLEAR gs_head-dmbtr.
  ENDIF.

  " [## ##] ### ### - ### ## ### (usd)
  gv_balance = round( val = ( gs_head-wrbtr - gv_wrbtr ) dec = 2 ).

  " [### ###] ### ### 0# ## ###, ### ###
  IF gv_balance = 0.
    " ## ## -> ## ## ## ## (###)
    gv_balicon = icon_green_light.
  ELSE.
    " ## ### -> ## ## ## (###)
    gv_balicon = icon_red_light.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& FORM check_data_before_save (## # ## ### ### ##)
*&---------------------------------------------------------------------*
FORM check_data_before_save CHANGING cv_subrc TYPE sysubrc.

  DATA: lv_error_cnt   TYPE i VALUE 0,
        lo_protocol    TYPE REF TO cl_alv_changed_data_protocol,
        lv_item_exists TYPE abap_bool VALUE abap_false.

  " ## ## ### ##
  DATA: lv_tot_item_wrbtr TYPE ztb1mm0013-wrbtr, " ### ## ##
        lv_tot_item_dmbtr TYPE ztb1mm0013-dmbtr, " ### ## ##
        lv_tot_item_wmwst TYPE ztb1mm0014-wmwst, " ### ## ##
        lv_max_allowed    TYPE p LENGTH 8 DECIMALS 2 VALUE '999999999999.99'.

  DATA: lv_check_header_dmbtr TYPE ztb1mm0013-dmbtr. " 0 ### ## ### ##

  cv_subrc = 0.
  CREATE OBJECT lo_protocol. " ## #### ## ##

  " -----------------------------------------------------------------
  " 1. ## ## ## # ## ### ##

  " ## 1) ####(bldat) # ####(budat) ## ## ##
  PERFORM check_and_add_protocol USING gs_head-bldat 'E' '014' '## ####' 'GS_HEAD-BLDAT' 0 lo_protocol CHANGING lv_error_cnt.
  PERFORM check_and_add_protocol USING gs_head-budat 'E' '014' '## ##' 'GS_HEAD-BUDAT' 0 lo_protocol CHANGING lv_error_cnt.

  " ## 2) ## ## # ## ## ##
  PERFORM check_and_add_protocol USING gs_head-bpid  'E' '014' 'BP ##' 'GS_HEAD-BPID' 0 lo_protocol CHANGING lv_error_cnt.
  PERFORM check_and_add_protocol USING gs_head-bukrs 'E' '014' '## ##' 'GS_HEAD-BUKRS' 0 lo_protocol CHANGING lv_error_cnt.
  PERFORM check_and_add_protocol USING gs_head-waers 'E' '014' '## ##' 'GS_HEAD-WAERS' 0 lo_protocol CHANGING lv_error_cnt.
  PERFORM check_and_add_protocol USING gs_head-waersk 'E' '014' '## ##' 'GS_HEAD-WAERSK' 0 lo_protocol CHANGING lv_error_cnt.
*  PERFORM check_and_add_protocol USING gs_head-ebeln 'E' '014' '### #### ##' 'GS_HEAD-EBELN' 0 lo_protocol CHANGING lv_error_cnt.

  " ## 3) ## 0 ### ## ## ##
  IF gs_head-waers <> 'KRW' AND ( gv_ukurs IS INITIAL OR gv_ukurs <= 0 ).
    PERFORM check_and_add_protocol USING '' 'E' '000' '## ## ## (0 ## ## ##)' 'GS_HEAD-WAERS' 0 lo_protocol CHANGING lv_error_cnt.
  ENDIF.

  " -----------------------------------------------------------------
  " 2. ### ### ## ## # ## ##
  CLEAR: lv_tot_item_wrbtr, lv_tot_item_dmbtr, lv_tot_item_wmwst.

  " matnr ## ebeln #### ## ## ### ##
  LOOP AT gt_item INTO DATA(ls_item) WHERE ebeln IS NOT INITIAL.
    DATA(lv_tabix) = sy-tabix.
    lv_item_exists = abap_true. " ## ### ## ### ON

    " ## 1) ### ### ## (##, ## # ## ## ##)
    PERFORM check_and_add_protocol USING ls_item-menge 'E' '014' '##' 'MENGE' lv_tabix lo_protocol CHANGING lv_error_cnt.
    PERFORM check_and_add_protocol USING ls_item-meins 'E' '014' '##' 'MEINS' lv_tabix lo_protocol CHANGING lv_error_cnt.

    " ## 2) ## #### ## (### 0## ## #)
    IF ls_item-menge <= 0.
      PERFORM check_and_add_protocol USING '' 'E' '111' '## ## (0 ## ##)' 'MENGE' lv_tabix lo_protocol CHANGING lv_error_cnt.
    ENDIF.

    " ## 3) ##(CONVT_OVERFLOW) ### ## ## ## ##
    IF ls_item-wrbtr > lv_max_allowed OR ls_item-dmbtr > lv_max_allowed.
      PERFORM check_and_add_protocol USING '' 'E' '000' '## ## ## ##' 'WRBTR' lv_tabix lo_protocol CHANGING lv_error_cnt.
    ENDIF.

    " ### ### ## ## ## ##
    lv_tot_item_wrbtr = lv_tot_item_wrbtr + ls_item-wrbtr.
    lv_tot_item_dmbtr = lv_tot_item_dmbtr + ls_item-dmbtr.
    lv_tot_item_wmwst = lv_tot_item_wmwst + ls_item-wmwst.
  ENDLOOP.

  " -----------------------------------------------------------------
  " 3. ## ### ### ## ## (## ## vs ### ## ##)
  IF lv_item_exists = abap_true.

    " 3-1. ## ## ##(WRBTR) ### ##
    IF gv_wrbtr <> lv_tot_item_wrbtr.
      DATA(lv_msg_wrbtr) = |[## ## ###] ##: { gs_head-wrbtr NUMBER = USER } / ####: { lv_tot_item_wrbtr NUMBER = USER }|.
      PERFORM check_and_add_protocol USING '' 'E' '000' lv_msg_wrbtr 'GS_HEAD-WRBTR' 0 lo_protocol CHANGING lv_error_cnt.
    ENDIF.

    " 3-2. ## ##(WMWST) ##
    IF gv_mode = '3'. " ### ## ## ## = ## ## (##, ### ##)
      IF lv_tot_item_dmbtr <> lv_tot_item_wmwst. " gs_head-dmbtr ## ## ### ##
        PERFORM check_and_add_protocol USING '' 'E' '000' '## ## ###' 'GS_HEAD-DMBTR' 0 lo_protocol CHANGING lv_error_cnt.
      ENDIF.
    ELSE. " ##### ##### ## ## X (##, ## 0)
      IF lv_tot_item_wmwst IS NOT INITIAL.
        PERFORM check_and_add_protocol USING '' 'E' '000' '## ## ###' 'GS_HEAD-DMBTR' 0 lo_protocol CHANGING lv_error_cnt.
      ENDIF.
    ENDIF.

    " 3-3. ## ##(DMBTR) ##
    IF gs_head-waersk = 'KRW'.
      DATA: lv_idoc_temp     TYPE bapi_msg. " ### ##(##)

      CALL FUNCTION 'CURRENCY_AMOUNT_SAP_TO_IDOC'
        EXPORTING
          currency    = 'KRW'
          sap_amount  = gs_head-dmbtr
        IMPORTING
          idoc_amount = lv_idoc_temp. " ## ### ##
      lv_check_header_dmbtr = lv_idoc_temp. " ### ## # ### ## ###
    ELSE.
      lv_check_header_dmbtr = gs_head-dmbtr.
    ENDIF.

    IF lv_check_header_dmbtr <> lv_tot_item_dmbtr.
      DATA: lv_compare      TYPE p LENGTH 13 DECIMALS 2.
      lv_compare = lv_check_header_dmbtr - lv_tot_item_dmbtr.

      IF ( lv_compare <= 2 ) AND ( lv_compare >= -2 ). " ##### +-2# ## (5.55 - 7.00 ## ##)
        CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
          EXPORTING
            currency    = 'KRW'
            idoc_amount = lv_tot_item_dmbtr
          IMPORTING
            sap_amount  = gs_head-dmbtr. " #### ### ## #### ###
      ELSE.
        DATA(lv_msg_dmbtr) = |[## ## ###] ##: { lv_check_header_dmbtr NUMBER = USER } / ####: { lv_tot_item_dmbtr NUMBER = USER }|.
        PERFORM check_and_add_protocol USING '' 'E' '000' lv_msg_dmbtr 'GS_HEAD-DMBTR' 0 lo_protocol CHANGING lv_error_cnt.
      ENDIF.
    ENDIF.

  ELSE.
    " ### ### ## ## ## ### ### ##
    PERFORM check_and_add_protocol USING '' 'E' '000' '### ## ### ####' 'MANDT' 0 lo_protocol CHANGING lv_error_cnt.
  ENDIF.

  " -----------------------------------------------------------------
  " 4. ## ## #### ## ##
  IF lv_error_cnt > 0. " ## ### ## ## ##
    lo_protocol->display_protocol(
*      i_container        =                  " Container (Optional)
*      i_display_toolbar  =                  " Display Toolbar
  i_optimize_columns = abap_true " ### ### ## ##
).
    cv_subrc = 4.
  ELSE.
    MESSAGE s021(zmcb1). " '### #######.'
    cv_subrc = 0.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& FORM check_and_add_protocol
*&---------------------------------------------------------------------*
FORM check_and_add_protocol USING pv_value      TYPE any
                                  pv_msgty      TYPE symsgty
                                  pv_msgno      TYPE symsgno
                                  pv_msgv1      TYPE any
                                  pv_fieldname  TYPE fieldname
                                  pv_row_id     TYPE any
                                  pr_protocol   TYPE REF TO cl_alv_changed_data_protocol
                         CHANGING p_error_cnt   TYPE i.

  " 1. ## ## ##: ## #####, ## #### ## ### ## ##### ##
  IF pv_value IS INITIAL
     OR ( ( pv_fieldname CP '*BEDAT*' OR pv_fieldname CP '*BLDAT*' OR pv_fieldname CP '*BUDAT*' )
          AND pv_value < sy-datum AND pv_value IS NOT INITIAL ).

    " 2. ## ## ##
    p_error_cnt = p_error_cnt + 1.

    " 3. ## ALV #### #### ## ### ### ###
    pr_protocol->add_protocol_entry(
        i_msgid     = 'ZMCB1'
        i_msgty     = pv_msgty
        i_msgno     = pv_msgno
        i_msgv1     = |{ pv_msgv1 }| " #### ## ### ### ### String ###
        i_fieldname = pv_fieldname
        i_row_id    = pv_row_id      " 0## #### ## ## ### ###
    ).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& FORM confirm_save (100# ### ## ###)
*&---------------------------------------------------------------------*
FORM confirm_save CHANGING cv_answer TYPE char1.

  DATA: lv_title TYPE string VALUE '## ## ##',
        lv_text  TYPE string,
        lv_count TYPE i,
        lv_total TYPE p LENGTH 8 DECIMALS 2.

  " ## ### ##
  LOOP AT gt_item INTO DATA(ls_item) WHERE ebeln IS NOT INITIAL.
    lv_count = lv_count + 1.
    lv_total = lv_total + ls_item-wrbtr.
  ENDLOOP.

  " ### ##
  lv_text = |### ## [{ gs_head-belnr }] ##\n| &&
          | # { lv_count }## ##,\n| &&
          | ## ##: { lv_total NUMBER = USER } { gs_head-waers } #\n| &&
          | ########?|.
  CLEAR cv_answer.

  " ## ##
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = lv_title
      text_question         = lv_text
      text_button_1         = '#'
      text_button_2         = '###'
      display_cancel_button = ' '
    IMPORTING
      answer                = cv_answer.

  cv_answer = COND #( WHEN cv_answer = '1' THEN 'J' ELSE 'N' ).

ENDFORM.
*&---------------------------------------------------------------------*
*& FORM save_invoice_data (## ## ## #### # ### ### ##)
*&---------------------------------------------------------------------*
FORM save_invoice_data.

  DATA: ls_head  TYPE ztb1mm0013,       " ## DB ###
        lt_item  TYPE TABLE OF ztb1mm0014, " ### DB ###
        ls_item  LIKE LINE OF lt_item,
        lv_tabix TYPE i.

  CLEAR gv_save_check.

  " ## #### gs_head# #### ## ### ### ### (## x)
  IF gs_head-belnr IS INITIAL.
    MESSAGE e006(zmcb1) WITH ': ### ## ### #### ####'.
    RETURN.
  ENDIF.

  " 1. ## ### #### ##
  gs_head-rbstat = 'A'. " #### 'X'(### ##) -> 'A'(## ## - ##)# ##
  gs_head-aenam = sy-uname.
  gs_head-aedat = sy-datum.
  gs_head-aezet = sy-uzeit.

  MOVE-CORRESPONDING gs_head TO ls_head.

  " 2. ### ### ##
  CLEAR lt_item. " - ##### ## ### ### ## ebeln #### ##
  LOOP AT gt_item INTO DATA(ls_screen) WHERE ebeln IS NOT INITIAL.

    IF sy-tabix = 1.
      ls_head-mblnr = ls_screen-mblnr. " #### ######## -> ##
      ls_head-ebeln = ls_screen-ebeln. " #### ###### -> ##
    ENDIF.

    lv_tabix = lv_tabix + 1.

    CLEAR ls_item.
    MOVE-CORRESPONDING ls_screen TO ls_item.

    " ##### ####### ##### ##
    CLEAR: ls_item-ernam, ls_item-erdat, ls_item-erzet,
           ls_item-aenam, ls_item-aedat, ls_item-aezet.

    ls_item-belnr = gs_head-belnr.
    ls_item-gjahr = gs_head-gjahr. " ### #### ##
    ls_item-buzei = lv_tabix * 10.

    IF ls_screen-waersk = 'KRW' OR gs_head-waers = 'KRW'.
      CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
        EXPORTING
          currency    = 'KRW'
          idoc_amount = ls_screen-dmbtr " ## ##
        IMPORTING
          sap_amount  = ls_item-dmbtr.

      CALL FUNCTION 'CURRENCY_AMOUNT_IDOC_TO_SAP'
        EXPORTING
          currency    = 'KRW'
          idoc_amount = ls_screen-wmwst " ## ##
        IMPORTING
          sap_amount  = ls_item-wmwst.
    ELSE.
      " KRW # ## ##(# ###) ### ##### # ### #
      ls_item-dmbtr = ls_screen-dmbtr.
      ls_item-wmwst = ls_screen-wmwst.
    ENDIF.

    APPEND ls_item TO lt_item.
  ENDLOOP.

  " ### ### ## ## ##
  call function 'ZFB1CM0001'" ##### ####
    CHANGING
      ct_table = lt_item.

  " 3. #### DB ## ## --------------------------------------
  " --- 3-1. ## ## ### ### ## # ## ## UPDATE --------
*  UPDATE ztb1mm0013 FROM @ls_head. " ### #######
  " ### ### ###### ~ ######## ~ ERDAT ~ ERZET ##### #### ####
  UPDATE ztb1mm0013
       SET rbstat  = @ls_head-rbstat, " ## ### ## ##
           bldat   = @ls_head-bldat,
           budat   = @ls_head-budat,
           zfbdt   = @ls_head-zfbdt,
           bktxt   = @ls_head-bktxt,
           dmbtr   = @ls_head-dmbtr,  " ### ##, ## ## ##
           waersk  = @ls_head-waersk,
           aenam   = @ls_head-aenam,
           aedat   = @ls_head-aedat,
           aezet   = @ls_head-aezet
     WHERE belnr   = @ls_head-belnr
       AND gjahr   = @ls_head-gjahr.

  IF sy-subrc = 0. " ## ## # ### ##
    " ## ## ## ### ### #### ## 1## ###
    DELETE FROM ztb1mm0014 WHERE belnr = @ls_head-belnr AND gjahr = @ls_head-gjahr.

    " 3-2. ## ### ## ### ### ## ## (2#)
    INSERT ztb1mm0014 FROM TABLE lt_item.

    IF sy-subrc = 0. " ## #### # ##

      DATA: lv_belnr TYPE belnr,
            lv_subrc TYPE sy-subrc.

      call function 'ZFB1FI0002'
        EXPORTING
          i_bukrs    = ls_head-bukrs                 " ####
          i_bldat    = ls_head-bldat    " ###
*         i_bwart    =                  " ## ##
          i_mode     = 'ZMM_IR'       " Character Field with Length 10
          i_zawkey   = ls_head-belnr       " ######(#)
*         i_waers    =                  " ##
*         i_mandt    =                  " Client
          i_bpid     = ls_head-bpid            " BP ID
          i_bptyp    = ls_head-bptyp        " BP ##
*         it_mm_item =                  " ###### ###
          it_ir_item = lt_item
          i_ukurs    = gv_ukurs           " ## #
          i_mblnr_wk = ls_head-mblnr         " ## ## ##
        IMPORTING
          e_belnr    = lv_belnr                 " Assignment of Item Numbers: Material Doc. - Purchasing Doc.
          e_subrc    = lv_subrc                " ABAP System Field: Return Code of ABAP Statements
*        EXCEPTIONS
*         zawkey_missing       = 1                " ##### #### #####
*         invalid_mode         = 2                " #### ## #####
*         number_get_failed    = 3                " #### ### ######
*         header_insert_failed = 4                " ## ### ### ######
*         item_insert_failed   = 5                " ### ### ### ######
*         no_account_found     = 6                " #### ### ## # ####
*         no_recon_found       = 7                " #### ### ## # ####
*         balance_not_zero     = 8                " ### ## ### #### ####
*         OTHERS     = 9
        .

      IF sy-subrc <> 0.
        ROLLBACK WORK.
        MESSAGE e006(zmcb1) WITH ': ## ## ##'.
      ELSE.
        COMMIT WORK.
        "PROCESS FLOW ##(###)
        DATA LV_REQNO TYPE ZEB1_SD_REF_DOC_NO.
        DATA LV_DOCNO TYPE ZEB1_SD_RESULT_DOC_NO.

        READ TABLE LT_ITEM INDEX 1 INTO DATA(LS_PROCESS).
        CASE LS_HEAD-BPTYP.
          WHEN '1'.           "#### ## ####
            LV_REQNO = CONV CHAR20( LS_HEAD-EBELN ).
            LV_DOCNO = CONV CHAR20( LS_PROCESS-BELNR ).

            ZCL_B1_PROCESS_STATUS=>SAVE(
              EXPORTING
                IV_PROGRAM_ID      = 'SAPMZB1MM0003'
                IV_REF_DOC_NO      = LV_REQNO
                IV_RESULT_DOC_NO   = LV_DOCNO
                IV_RESULT_DOC_TYPE = 'IV_DOC'
                IV_STATUS_TEXT     = '#### ## ## ##'
              EXCEPTIONS
                PROGRAM_NOT_FOUND  = 1
                MAPPING_NOT_FOUND  = 2
                CREATE_ERROR       = 3
                COMPLETE_ERROR     = 4
                OTHERS             = 5
            ).

            IF SY-SUBRC <> 0.
              MESSAGE S026(ZMCB1) WITH |PROCESS STATUS ## #| DISPLAY LIKE 'E'.
            ENDIF.
          WHEN '3'.           "#### ## ####
            LV_REQNO = CONV CHAR20( LS_HEAD-EBELN ).
            LV_DOCNO = CONV CHAR20( LS_PROCESS-BELNR ).

            ZCL_B1_PROCESS_STATUS=>SAVE(
              EXPORTING
                IV_PROGRAM_ID      = 'SAPMZB1MM0003_2'
                IV_REF_DOC_NO      = LV_REQNO
                IV_RESULT_DOC_NO   = LV_DOCNO
                IV_RESULT_DOC_TYPE = 'IV_DOC'
                IV_STATUS_TEXT     = '#### ## ## ##'
              EXCEPTIONS
                PROGRAM_NOT_FOUND  = 1
                MAPPING_NOT_FOUND  = 2
                CREATE_ERROR       = 3
                COMPLETE_ERROR     = 4
                OTHERS             = 5
            ).

            IF SY-SUBRC <> 0.
              MESSAGE S026(ZMCB1) WITH |PROCESS STATUS ## #| DISPLAY LIKE 'E'.
            ENDIF.
           WHEN '4'.           "#### ## ####
             SELECT SINGLE EBELN
               FROM ZTB1MM0006
              WHERE ZEBELNSV = @LS_HEAD-EBELN
               INTO @DATA(LV_EBELN).

            LV_REQNO = CONV CHAR20( LV_EBELN ).
            LV_DOCNO = CONV CHAR20( LS_PROCESS-BELNR ).

            ZCL_B1_PROCESS_STATUS=>SAVE(
              EXPORTING
                IV_PROGRAM_ID      = 'SAPMZB1MM0003_3'
                IV_REF_DOC_NO      = LV_REQNO
                IV_RESULT_DOC_NO   = LV_DOCNO
                IV_RESULT_DOC_TYPE = 'IV_DOC'
                IV_STATUS_TEXT     = '#### ## ## ##'
              EXCEPTIONS
                PROGRAM_NOT_FOUND  = 1
                MAPPING_NOT_FOUND  = 2
                CREATE_ERROR       = 3
                COMPLETE_ERROR     = 4
                OTHERS             = 5
            ).

            IF SY-SUBRC <> 0.
              MESSAGE S026(ZMCB1) WITH |PROCESS STATUS ## #| DISPLAY LIKE 'E'.
            ENDIF.



          WHEN OTHERS.
        ENDCASE.




        gv_save_check = 'X'. " ## ### ##
      ENDIF.
    ELSE.
      ROLLBACK WORK.
      MESSAGE e006(zmcb1) WITH ': ## ### ## ##'.
    ENDIF.
  ELSE.
    ROLLBACK WORK.
    MESSAGE e006(zmcb1) WITH ': ## ## #### ##'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_image (### ###)
*&---------------------------------------------------------------------*
FORM display_image  USING    VALUE(pv_objid)
                             po_logo TYPE REF TO cl_gui_picture.

  DATA : lv_url TYPE cndp_url.

  " ## ## ##
  IF po_logo IS BOUND.
    po_logo->clear_picture( ).
  ENDIF.

  " SMW0 ##### URL ### ##
  CALL FUNCTION 'DP_PUBLISH_WWW_URL'
    EXPORTING
      objid                 = pv_objid
      lifetime              = '12'
    IMPORTING
      url                   = lv_url
    EXCEPTIONS
      dp_invalid_parameters = 1
      no_object             = 2
      dp_error_publish      = 3
      OTHERS                = 4.

  IF sy-subrc <> 0.
    MESSAGE '## #### #### #####.' TYPE 'S' DISPLAY LIKE 'E'.
  ELSE.
    " URL### ### ##
    po_logo->load_picture_from_url(
      EXPORTING
        url    = lv_url ).

    po_logo->set_display_mode(
      EXPORTING
        display_mode = 1 " 1: ## ## ##### ### ##, 2: ## ### # ##
      EXCEPTIONS
        error        = 1
        OTHERS       = 2 ).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form download_and_print_pdf ( PDF ## ## # ## ## ### )
*&---------------------------------------------------------------------*
FORM download_and_print_pdf.
  DATA: lv_filename TYPE string,
        lv_path     TYPE string,
        lv_fullpath TYPE string,
        lv_result   TYPE i.

  IF gs_head-belnr IS NOT INITIAL.
    lv_filename = |Invoice_{ gs_head-belnr }_{ sy-datum }|.
  ELSE.
    lv_filename = |Invoice_PO_{ gs_head-ebeln }_{ sy-datum }|.
  ENDIF.

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

  " 2. ## ##### ## ## (OLE)
  IF gv_excel IS INITIAL.
    CREATE OBJECT gv_excel 'EXCEL.APPLICATION'.
  ENDIF.

  SET PROPERTY OF gv_excel 'VISIBLE' = 0.

  DATA: lv_workbooks TYPE ole2_object.
  CALL METHOD OF gv_excel 'WORKBOOKS' = lv_workbooks.
  CALL METHOD OF lv_workbooks 'ADD' = gv_workbook.

  " 3. ### ##
  PERFORM fill_invoice_excel_data.

  " 4. PDF ## ## # ##
  DATA: lv_pagesetup TYPE ole2_object.

  GET PROPERTY OF gv_activesheet 'PageSetup' = lv_pagesetup.
  SET PROPERTY OF lv_pagesetup 'Zoom' = 0.
  SET PROPERTY OF lv_pagesetup 'FitToPagesWide' = 1. " ## # ## 1# ##
  SET PROPERTY OF lv_pagesetup 'FitToPagesHeight' = 99.

  IF gv_workbook IS NOT INITIAL.
    CALL METHOD OF gv_workbook 'ExportAsFixedFormat'
      EXPORTING
        #1 = '0'
        #2 = lv_fullpath
        #3 = '0'.

    CALL METHOD OF gv_workbook 'Close' EXPORTING #1 = 0.
    CALL METHOD OF gv_excel 'Quit'.

    FREE OBJECT: gv_excel, gv_workbook.
    CLEAR: gv_excel, gv_workbook.

    " 5. #### ### PDF ## ###
    CALL METHOD cl_gui_frontend_services=>execute
      EXPORTING
        document  = lv_fullpath
        operation = 'OPEN'
      EXCEPTIONS
        OTHERS    = 1.

    IF sy-subrc <> 0.
      MESSAGE 'PDF ### ### #### # ######.' TYPE 'S' DISPLAY LIKE 'E'.
    ELSE.
      MESSAGE '### ### PDF ### ## #######.' TYPE 'S'.
    ENDIF.

  ELSE.
    MESSAGE e032(zmcb1).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form fill_invoice_excel_data (## ### ###)
*&---------------------------------------------------------------------*
FORM fill_invoice_excel_data.
  DATA: lv_text      TYPE string,
        lv_value     TYPE c LENGTH 30,
        lv_column    TYPE ole2_object,
        lv_row       TYPE i,
        lv_row_c     TYPE c LENGTH 10,
        lv_range_str TYPE string,
        lv_range     TYPE ole2_object. "

  GET PROPERTY OF gv_excel 'ActiveSheet' = gv_activesheet.

  CALL METHOD OF gv_excel 'Columns' = lv_column EXPORTING #1 = 2.
  SET PROPERTY OF lv_column 'ColumnWidth' = 8.  " B: '##' ## (### ## ##)

  CALL METHOD OF gv_excel 'Columns' = lv_column EXPORTING #1 = 3.
  SET PROPERTY OF lv_column 'ColumnWidth' = 10. " C: '## ##' # ## # ##

  CALL METHOD OF gv_excel 'Columns' = lv_column EXPORTING #1 = 4.
  SET PROPERTY OF lv_column 'ColumnWidth' = 15. " D: '## (##)'

  CALL METHOD OF gv_excel 'Columns' = lv_column EXPORTING #1 = 5.
  SET PROPERTY OF lv_column 'ColumnWidth' = 16. " E: '##(####)'

  CALL METHOD OF gv_excel 'Columns' = lv_column EXPORTING #1 = 6.
  SET PROPERTY OF lv_column 'ColumnWidth' = 18. " F: '## ####'

  " ### # ## ## ## ##
  CALL METHOD OF gv_excel 'Range' = lv_range EXPORTING #1 = 'B5' #2 = 'F100'.
  SET PROPERTY OF lv_range 'HorizontalAlignment' = -4131.

  " 2) ### ### ##
  PERFORM fill_cells USING 2 2 '## ## # ## ## ## ###'.
  PERFORM style_cell USING 2 2 0 1. " ## ##, ##

  " 3) ##(gs_head) ### ## ## ##
  " ## ## ##
  PERFORM style_cell USING 5 2 0 1.  PERFORM fill_cells USING 5 2 '## ## ## :'.
  PERFORM fill_cells USING 5 4 gs_head-belnr.

  " ## ##
  CONCATENATE gs_head-bukrs '[' gv_bukrs ']' INTO lv_text SEPARATED BY space.
  PERFORM style_cell USING 6 2 0 1.  PERFORM fill_cells USING 6 2 '## ## :'.
  PERFORM fill_cells USING 6 4 lv_text.

  " ## ##
  PERFORM style_cell USING 7 2 0 1.  PERFORM fill_cells USING 7 2 '## ## :'.
  PERFORM fill_cells USING 7 4 gs_head-bldat.

  " ## ##
  PERFORM style_cell USING 8 2 0 1.  PERFORM fill_cells USING 8 2 '## ## :'.
  PERFORM fill_cells USING 8 4 gs_head-budat.

  " BP ID
  IF gs_vend-bpnm IS INITIAL.
    lv_text = gs_head-bpid.
  ELSE.
    CONCATENATE gs_head-bpid '[' gs_vend-bpnm ']' INTO lv_text SEPARATED BY space.
  ENDIF.
  PERFORM style_cell USING 9 2 0 1.  PERFORM fill_cells USING 9 2 'BP ## :'.
  PERFORM fill_cells USING 9 4 lv_text.

  " ## ##
  CONCATENATE gs_head-zterm gv_zterm INTO lv_text SEPARATED BY space.
  PERFORM style_cell USING 10 2 0 1. PERFORM fill_cells USING 10 2 '## ## :'.
  PERFORM fill_cells USING 10 4 lv_text.

  " #### ##
  PERFORM style_cell USING 11 2 0 1. PERFORM fill_cells USING 11 2 '#### ## :'.
  PERFORM fill_cells USING 11 4 gv_ebeln.

  " ##### ## (## ###### ##)
  CONCATENATE gv_doctxt ' :' INTO lv_text.
  PERFORM style_cell USING 12 2 0 1. PERFORM fill_cells USING 12 2 lv_text.
  PERFORM fill_cells USING 12 4 gv_docno.

  " '## ##' ### # ### ### ###(19)
  PERFORM style_cell USING 13 2 19 1. PERFORM fill_cells USING 13 2 '## ## :'.
*  PERFORM style_cell USING 13 3 19 0. PERFORM style_cell USING 13 5 19 0.
  PERFORM style_cell USING 13 4 19 0. PERFORM fill_cells USING 13 4 gv_rbstatxt.

  " # #### (####)
  PERFORM style_cell USING 14 2 0 1.  PERFORM fill_cells USING 14 2 '# ####(####) :'.
  WRITE gs_head-wrbtr TO lv_value CURRENCY gs_head-waers. CONDENSE lv_value.
  CONCATENATE lv_value gs_head-waers INTO lv_text SEPARATED BY space.
  PERFORM fill_cells USING 14 4 lv_text.

  " 4) ###(gt_item) ### ### ##
  lv_row = 18.

  PERFORM style_cell USING lv_row 2 15 1. PERFORM fill_cells USING lv_row 2 '##'.
  PERFORM style_cell USING lv_row 3 15 1. PERFORM fill_cells USING lv_row 3 '## ##'.
  PERFORM style_cell USING lv_row 4 15 1. PERFORM fill_cells USING lv_row 4 '## (##)'.
  PERFORM style_cell USING lv_row 5 15 1. PERFORM fill_cells USING lv_row 5 '##(####)'.
  PERFORM style_cell USING lv_row 6 15 1. PERFORM fill_cells USING lv_row 6 '## ####'.
  PERFORM draw_border USING 'B18:F18'.

  " 5) ### ### #### ### ### ##
  " ### ####
  DATA: lv_check_item TYPE bapicurr-bapicurr,
        lv_total_num  TYPE bapicurr-bapicurr VALUE 0.

  LOOP AT gt_item INTO DATA(ls_item).
    lv_row = lv_row + 1.

    PERFORM fill_cells USING lv_row 2 ls_item-buzei.
    PERFORM fill_cells USING lv_row 3 ls_item-matnr.

    " ## + ##
    WRITE ls_item-menge TO lv_value. CONDENSE lv_value.
    CONCATENATE lv_value ls_item-meins INTO lv_text SEPARATED BY space.
    PERFORM fill_cells USING lv_row 4 lv_text.

    " #### ##
    WRITE ls_item-wrbtr TO lv_value CURRENCY ls_item-waers. CONDENSE lv_value.
    CONCATENATE lv_value ls_item-waers INTO lv_text SEPARATED BY space.
    PERFORM fill_cells USING lv_row 5 lv_text.

    " ## ####
    ls_item-dmbtr = ls_item-dmbtr / 100. " ###### ####..(##)
    lv_total_num = lv_total_num + ls_item-dmbtr. " idoc_to ### bapi #### ## x
    " ### ### ### ##### #### ####..
    WRITE ls_item-dmbtr TO lv_value CURRENCY ls_item-waersk. CONDENSE lv_value.
    CONCATENATE lv_value ls_item-waersk INTO lv_text SEPARATED BY space.
    PERFORM fill_cells USING lv_row 6 lv_text.

    " ### ## ### ##
    lv_row_c = lv_row.
    CONDENSE lv_row_c.
    CONCATENATE 'B' lv_row_c ':F' lv_row_c INTO lv_range_str.
    PERFORM draw_border USING lv_range_str.
  ENDLOOP.

  " # #### (##)
  PERFORM style_cell USING 15 2 0 1.  PERFORM fill_cells USING 15 2 '# ####(##) :'.
  lv_total_num = lv_total_num / 100. " idoc_to ### bapi #### ## x
  "                        ### ### ### ##### #### ####..
  WRITE lv_total_num TO lv_value CURRENCY gs_head-waersk. CONDENSE lv_value.
  CONCATENATE lv_value gs_head-waersk INTO lv_text SEPARATED BY space.
  PERFORM fill_cells USING 15 4 lv_text.

  " 6) ## ## ## ##
  lv_row = lv_row + 3.
  " 1## # ##
  PERFORM fill_cells USING lv_row 2 '### ## ### ## #### ## ## # ## ### #### ######,'.

  lv_row = lv_row + 1.
  " 2## # ## (# # ### ### ##)
  PERFORM fill_cells USING lv_row 2 '## ## ## # ## ### ## # ### ## ### #####.'.

  lv_row = lv_row + 2.
  CONCATENATE '## ###: ' '' sy-datum+0(4) '# ' sy-datum+4(2) '# ' sy-datum+6(2) '#' INTO lv_text SEPARATED BY space.
  PERFORM fill_cells USING lv_row 2 lv_text.

  lv_row = lv_row + 1.
  PERFORM fill_cells USING lv_row 5 '## ###: _________________ (#)'.
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
