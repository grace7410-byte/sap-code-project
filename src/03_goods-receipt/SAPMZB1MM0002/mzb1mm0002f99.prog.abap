*&---------------------------------------------------------------------*
*& Include          MZB1MM0002F99
*&---------------------------------------------------------------------*
* ## ##(## ## ####) ## #### ##
*&---------------------------------------------------------------------*
*& Process Flow ### ## (GET_DATA# #### # ver.)
*&---------------------------------------------------------------------*
FORM X_get_process_data USING pv_ebeln.
  DATA: lt_tran LIKE gt_poit, " #### #### ### po ### itab# ### ## ####### ##
        lt_item LIKE gt_item,
        lt_head LIKE gt_head. " ## ###
  DATA: lv_ebeln TYPE zeb1_mm_ebeln.

  lv_ebeln = pv_ebeln. " #### ## #####
  PERFORM clear_process_data. " ###

  " [####] ### ###### ##
  SELECT SINGLE ebeln bpid ekorg ekgrp bukrs bsart bedat zterm inco1 zebeln zebelnsv knumh
  FROM ztb1mm0006 INTO CORRESPONDING FIELDS OF gs_pohd WHERE ebeln = lv_ebeln AND lvorm <> 'X'.
  IF sy-subrc <> 0.
    MESSAGE s108(zmcb1) WITH lv_ebeln DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  " #### #### #### ##
  SELECT ebeln ebelp matnr werks lgort menge meins netpr dmbtr waersk
    wrbtr waers mwskz eindt slfdt insmk packno knttp sakto epstp postat
    FROM ztb1mm0007 INTO CORRESPONDING FIELDS OF TABLE gt_poit WHERE ebeln = lv_ebeln AND lvorm <> 'X'.

  " [1##(1,4) ####] ##### #### ### -> #### ### ##
  IF gs_pohd-zebelnsv IS NOT INITIAL.
    SELECT ebeln ebelp matnr werks lgort menge meins netpr dmbtr waersk
      wrbtr waers mwskz eindt slfdt insmk packno knttp sakto epstp postat
    FROM  ztb1mm0007
    INTO CORRESPONDING FIELDS OF TABLE lt_tran
    WHERE ebeln = gs_pohd-zebelnsv " ##### ####### = ##### ##### ### ### ##
      AND lvorm <> 'X'.

    IF sy-subrc = 0.
      LOOP AT lt_tran INTO DATA(ls_sv).
        IF ls_sv-ebelp = '0010' AND ls_sv-postat = '4'. " ##### 10### ### #####
          gv_load_tran = 'X'.  " -> 1# ## ##
        ELSEIF ls_sv-ebelp = '0020' AND ls_sv-postat = '4'. " ### 20### ### ####
          gv_plant_tran = 'X'. " -> 2# ## ##
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.

  " [2##(2,5) ####] - ##### ## ### ##
  SELECT zmsno zdocty zdocno zdocit zavol ztemp zunit zdens zvcf zsvol meins zmdat
    FROM ztb1mm0020 INTO CORRESPONDING FIELDS OF TABLE gt_load_volm
    WHERE zdocno = lv_ebeln
    AND zdocty = 'PO-1' " ##### #### #### ##### ### ##
    AND lvorm <> 'X'.
  IF sy-subrc = 0.
    gv_load_volm = 'X'.
  ENDIF.

  SELECT zmsno zdocty zdocno zdocit zavol ztemp zunit zdens zvcf zsvol meins zmdat
    FROM ztb1mm0020 INTO CORRESPONDING FIELDS OF TABLE gt_plant_volm
    WHERE zdocno = lv_ebeln
    AND zdocty = 'PO-2' " ##### #### #### ##### ### ##
    AND lvorm <> 'X'.
  IF sy-subrc = 0.
    gv_plant_volm = 'X'.
  ENDIF.

  " [3##(3,6) Post] - ######## ##### ###
  SELECT mblnr mjahr bldat budat bukrs bktxt vbeln plpr ebeln vgart
    FROM ztb1mm0011 INTO CORRESPONDING FIELDS OF TABLE gt_head WHERE ebeln = lv_ebeln AND lvorm <> 'X'.
  IF gt_head[] IS NOT INITIAL.
    " ### #### ITEM# #####
    SELECT mblnr mjahr zeile matnr werks lgort bwart menge meins netpr dmbtr waersk wrbtr waers
      insmk zloss kokrs kostl vbeln posnr plpr ebeln ebelp
      FROM ztb1mm0012 INTO CORRESPONDING FIELDS OF TABLE lt_item FOR ALL ENTRIES IN gt_head WHERE ebeln = gt_head-ebeln AND lvorm <> 'X'.

    IF lt_item[] IS NOT INITIAL.
      LOOP AT lt_item INTO DATA(ls_mat).
        CASE ls_mat-bwart.
          WHEN '101'. " ##### 101 + #### #### ### #### ## ## #
            IF ls_mat-insmk = 'T'.
              gv_load_gr = 'X'.
            ENDIF.
          WHEN '321' OR '551'.
            " #### 321 + #### ### ## -> ### ### #
            gv_plant_gr = 'X'.
        ENDCASE.
        IF gv_load_gr = 'X' AND gv_plant_gr = 'X'. " ## ##### ##
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ELSE.
    FREE lt_item. " ### ### #### ###
  ENDIF.

  " #### ## ##: 1# ## ## + ## #### ## + #### ## ##
  IF gv_load_tran = 'X' AND gv_load_volm = 'X' AND gv_load_gr IS INITIAL.
    gv_load_can = 'X'.
  ENDIF.

  " #### ## ##: 2# ## ## + ## #### ## + #### ## ##
  IF gv_plant_tran = 'X' AND gv_plant_volm = 'X' AND gv_plant_gr IS INITIAL.
    gv_plant_can = 'X'.
  ENDIF.

  " #### ## ##: ## ## ## (#### ### ## ##)
*                  + #### #### #### ##(####### ### ### # ##)
*                  + #, ## ## = 'X' (## A ## ## ## B# #### #)
  IF gv_load_gr = 'X'.
    SELECT SINGLE rbstat
      FROM ztb1mm0013 " ##### #### ## ##
      INTO @DATA(lv_rbstat)
      WHERE ebeln = @lv_ebeln. " ##### ebeln# ###
    " ## #### ### #, ####### ## ## => ### RBSTAT# ###

    IF sy-subrc = 0. " #### ## ##
      CASE lv_rbstat.
        WHEN 'X'. " ####### ### ### # ##-> ## ## ##
          gv_inv_can = 'X'.
        WHEN 'A' OR 'B'. " ## ## ## ## -> ## ## ##
          gv_inv_done = 'X'.
      ENDCASE.
    ENDIF.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Process Flow ### ## (GET_DATA# #### # ver.)
*&---------------------------------------------------------------------*
FORM x_display_process_flow.
  DATA: lo_table TYPE REF TO cl_dd_table_element,
        lo_c1    TYPE REF TO cl_dd_area, lo_c2  TYPE REF TO cl_dd_area,
        lo_c3    TYPE REF TO cl_dd_area, lo_c4  TYPE REF TO cl_dd_area,
        lo_c5    TYPE REF TO cl_dd_area, lo_c6  TYPE REF TO cl_dd_area,
        lo_c7    TYPE REF TO cl_dd_area, lo_c8  TYPE REF TO cl_dd_area,
        lo_c9    TYPE REF TO cl_dd_area, lo_c10  TYPE REF TO cl_dd_area,
        lo_c11   TYPE REF TO cl_dd_area.

*  " ### ##
  go_doc->add_table( EXPORTING no_of_columns = 11
                               border        = '0'
                               width         = '100%'
                     IMPORTING table     = lo_table ).

  " [## ## ##]
  lo_table->add_column( EXPORTING width = '15%' IMPORTING column = lo_c1 ).
  lo_c1->add_gap( width = 15 ).
  IF gv_load_tran = 'X'.
    lo_c1->add_icon( sap_icon = 'ICON_STATUS_OK' ).
  ELSE.
    lo_c1->add_icon( sap_icon = 'ICON_NEGATIVE' ).
  ENDIF.
  lo_table->add_column(  EXPORTING width = '2%' IMPORTING column = lo_c2 ).
  lo_c2->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).


  " [## #### ##]
  lo_table->add_column(  EXPORTING width = '15%' IMPORTING column = lo_c3 ).
  lo_c3->add_gap( width = 15 ).
  IF gv_load_volm = 'X'.
    lo_c3->add_icon( sap_icon = 'ICON_STATUS_OK' ).
  ELSE.
    lo_c3->add_icon( sap_icon = 'ICON_NEGATIVE' ).
  ENDIF.
  lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_c4 ). " ## ## ##
  lo_c4->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).


  " [## ## ##]
  lo_table->add_column( EXPORTING width = '15%' IMPORTING column = lo_c5 ).
  lo_c5->add_gap( width = 15 ).
  IF gv_load_gr = 'X'.
    lo_c5->add_icon( sap_icon = 'ICON_STATUS_OK' ).
  ELSE.
    lo_c5->add_icon( sap_icon = 'ICON_NEGATIVE' ).
  ENDIF.
  lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_c6 ). " ## ## ##
  lo_c6->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).


  " [### ## ##]
  lo_table->add_column( EXPORTING width = '15%' IMPORTING column = lo_c7 ).
  lo_c7->add_gap( width = 15 ).
  IF gv_plant_tran = 'X'.
    lo_c7->add_icon( sap_icon = 'ICON_STATUS_OK' ).
  ELSE.
    lo_c7->add_icon( sap_icon = 'ICON_NEGATIVE' ).
  ENDIF.
  lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_c8 )." ## ## ##
  lo_c8->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).

  " ICON_STATUS_OK
  " ICON_STATUS_BEST
  " [### #### ##]
  lo_table->add_column( EXPORTING width = '15%' IMPORTING column = lo_c9 ).
  lo_c9->add_gap( width = 15 ).
  IF gv_plant_volm = 'X'.
    lo_c9->add_icon( sap_icon = 'ICON_STATUS_OK' ).
  ELSE.
    lo_c9->add_icon( sap_icon = 'ICON_NEGATIVE' ).
  ENDIF.
  lo_table->add_column( EXPORTING width = '2%' IMPORTING column = lo_c10 ). " ## ## ##
  lo_c10->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).


  " [### ## ##]
  lo_table->add_column( EXPORTING width = '15%' IMPORTING column = lo_c11 ).
  lo_c11->add_gap( width = 15 ).
  IF gv_plant_gr = 'X'.
    lo_c11->add_icon( sap_icon = 'ICON_STATUS_OK' ).
  ELSE.
    lo_c11->add_icon( sap_icon = 'ICON_NEGATIVE' ).
  ENDIF.

  lo_table->new_row( ). " ###
  lo_c1->add_gap( width = 10 ).
  lo_c1->add_link( name = 'LOADTRAN' text =  '[1# ##]'  ).
  lo_c2->add_text( text = ' ' ).
  lo_c3->add_gap( width = 2 ).
  lo_c3->add_link( name = 'LOADVOLM' text =  '[#### ####]'  ).
  lo_c4->add_text( text = ' ' ).
  lo_c5->add_gap( width = 10 ).
  lo_c5->add_text( text =  '[####]'  ).
  lo_c6->add_text( text = ' ' ).
  lo_c7->add_gap( width = 10 ).
  lo_c7->add_link( name = 'PLANTTRAN' text =  '[2# ##]'  ).
  lo_c8->add_text( text = ' ' ).
  lo_c9->add_gap( width = 2 ).
  lo_c9->add_link( name = 'PLANTVOLM' text =  '[#### ####]'  ).
  lo_c10->add_text( text = ' ' ).
  lo_c11->add_gap( width = 10 ).
  lo_c11->add_text( text =  '[####]'  ).

  lo_table->new_row( ). " ###
  lo_c1->add_gap( width = 4 ).
  lo_c1->add_text( text = ' ' ).
  lo_table->new_row( ). " ###

  lo_c3->add_gap( width = 4 ).
  IF gv_load_can = 'X'.
    lo_c3->add_link( name = 'LOADGR' text = '#### ##' ).
    lo_c4->add_icon( sap_icon = 'ICON_INCLUDE_IN_SELECTION' ).
  ELSEIF gv_load_gr = 'X'.
    lo_c3->add_text( text = '#### ##' ).
    lo_c4->add_icon( sap_icon = 'ICON_INCLUDE_IN_SELECTION' ).
  ELSE.
    lo_c3->add_text( text = '#### ###' ).
    lo_c4->add_icon( sap_icon = 'ICON_REMOVE_FROM_SELECTION' ).
  ENDIF.

  lo_c5->add_gap( width = 4 ).
  IF gv_plant_can = 'X'.
    lo_c5->add_link( name = 'PLANTGR' text = '#### ##' ).
    lo_c6->add_icon( sap_icon = 'ICON_INCLUDE_IN_SELECTION' ).
  ELSEIF gv_plant_gr = 'X'.
    lo_c5->add_text( text = '#### ##' ).
    lo_c6->add_icon( sap_icon = 'ICON_INCLUDE_IN_SELECTION' ).
  ELSE.
    lo_c5->add_text( text = '#### ###' ).
    lo_c6->add_icon( sap_icon = 'ICON_REMOVE_FROM_SELECTION' ).
  ENDIF.

  lo_c7->add_gap( width = 4 ).
  IF gv_inv_can = 'X'.
    lo_c7->add_link( name = 'INVOICE' text = '#### ##' ).
    lo_c8->add_icon( sap_icon = 'ICON_INCLUDE_IN_SELECTION' ).
  ELSEIF gv_inv_done = 'X'.
    lo_c7->add_text( text = '#### ##' ).
    lo_c8->add_icon( sap_icon = 'ICON_INCLUDE_IN_SELECTION' ).
  ELSE.
    lo_c7->add_text( text = '#### ###' ).
    lo_c8->add_icon( sap_icon = 'ICON_REMOVE_FROM_SELECTION' ).
  ENDIF.


*   ### ##(##)
*  lo_table->set_row_style( row_no  = 1   sap_style = 'SUCCESS' ). " sap_fontsize = 'LARGE'
*  lo_table->set_row_style( row_no  = 2   sap_style = 'HEADING' ).

  go_doc->merge_document( ).
  go_doc->display_document( parent = go_cont_doc ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_inventory_status (#### ## ## ###)
*&---------------------------------------------------------------------*
FORM display_inventory_status. "  -> ### #### ##, #### DOC ## X

  " 1. HTML #### #### ### # ##
  IF go_doc_lgt IS INITIAL.
    CREATE OBJECT go_doc_lgt.
  ELSE.
    go_doc_lgt->initialize_document( ).
  ENDIF.

  " 2. ### ## ##
  go_doc_lgt->add_text(
    text         = '# #### ## ## ##'
    sap_fontsize = cl_dd_document=>medium
    sap_emphasis = cl_dd_document=>strong
  ).
  go_doc_lgt->new_line( 1 ). " # # # ###

  " 3. # ## ### ## # ## ##
  " ### (## ## / ###)
  go_doc_lgt->add_text(
    text         = '  [ ### ]  :  ## ## ## ## ##### #### ## ####'
  ).
  go_doc_lgt->new_line( ).

  " #### ## ## #### ## ## (### - ## ### ### ### ## #)
  go_doc_lgt->add_text(
    text         = '  [ #### ] :  #### ## ## #### ## ### #### ## ## ### ### ## (#####)'
    sap_color    = cl_dd_document=>list_negative " ### ##
    sap_emphasis = cl_dd_document=>strong
    ).

  go_doc_lgt->new_line( ).

  " #### ## # ## ## ## ## (### - ## #### ## #)
  go_doc_lgt->add_text(
    text         = '  [ #### ] :  1# ##### ###### 2# ##(##/#####) ### #### ### ##'
    sap_color    = cl_dd_document=>list_total    " ### ##
    sap_emphasis = cl_dd_document=>strong
  ).
  go_doc_lgt->new_line( ).

  " ## ## ## ##
  go_doc_lgt->add_text(
    text         = '  [ #### ] :  ## ## # ## ####(321) ## ####(551) ## ## ## #'
    sap_color    = cl_dd_document=>list_positive " ### ##
    sap_emphasis = cl_dd_document=>strong
  ).
  go_doc_lgt->new_line( 2 ).

  go_doc_lgt->add_text(
    text         = '# ### ### ## #### ## ## #### ## #####.'
    sap_fontsize = cl_dd_document=>small
  ).

  " 4. ## ## # ## ##
  go_doc_lgt->merge_document( ).

ENDFORM.
**********************************************************************
* (##) #### ## -> # ## ####, #### (1#, 2## ##) ## ## ## ##
* ## ### ####,
* #### ### ## -> ## #### ### #### ## -> ### ### ### ##
* # #### ## # ## (## ## ### #### ##)

*&---------------------------------------------------------------------*
*& set_fcat_volm (100# ### volm ALV ## #### ##)
*&---------------------------------------------------------------------*
FORM x_set_fcat_volm CHANGING ct_fcat_volm TYPE lvc_t_fcat.
  PERFORM set_fcat TABLES ct_fcat_volm USING:
         'S' 'FIELDNAME' 'ZMSNO',    ' ' 'COLTEXT' '## ##',       ' ' 'KEY' 'X', ' ' 'EMPHASIZE' 'C110', 'E' ' ' ' ', " ###: NO_OUT 'X'
         'S' 'FIELDNAME' 'ZDOCTY',   ' ' 'COLTEXT' '## ##',       ' ' 'NO_OUT' 'X', 'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZDOCNO',   ' ' 'COLTEXT' '#### ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZDOCIT',   ' ' 'COLTEXT' '####',   'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZAVOL',    ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZTEMP',    ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZUNIT',    ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZDENS',    ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZVCF',     ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZSVOL',    ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'MEINS',    ' ' 'COLTEXT' '## ##',       'E' ' ' ' ',
         'S' 'FIELDNAME' 'ZMDAT',    ' ' 'COLTEXT' '## ##',       'E' ' ' ' '.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data (####, #### ### ### ##)
*&---------------------------------------------------------------------*
FORM x_get_data.
  " 1. ## ## ## (## ## ### ### # ####)
  SELECT ebeln ebelp seqno event_type event_status event_date location remark
    FROM ztb1mm0021 AS a " ## ###
    INTO CORRESPONDING FIELDS OF TABLE gt_tran UP TO 100 ROWS.
  " ## CR, C# ### ##### ### ### ## ##### ## ### ##
*   WHERE event_type   = 'C'  " ## ## ## & event_status = 'CR' " ##### ## ### ### # ### ### #
*     AND NOT EXISTS ( SELECT * FROM ztb1mm0021 AS b
*                       WHERE b~ebeln  = a~ebeln
**                         " AND b~ebelp  = a~ebelp " ## ## ### #### #(### ### ## ## ### ### ##T ##)
*                         AND b~event_type = 'P' ). " ## ### ##(P)# ### # ##

  IF gt_tran IS INITIAL.
    MESSAGE s112(zmcb1) DISPLAY LIKE 'E' WITH '##'. " ## ### ## ## ####
    EXIT.
  ELSE. " tran# ### ### ### ## ### ####

    " 2. ## ## ## (### ## ## #### ### ##### ####)
    SELECT zmsno zdocty zdocno zdocit zavol ztemp zunit zdens zvcf zsvol meins zmdat
      FROM zdvb1mm0001 " ## ## DB View
                       " - ### ##### ##### ## ####T## ## ### ######(### ##### ##,
      INTO CORRESPONDING FIELDS OF TABLE gt_volm " - ####T## ####### ### ##### ## ### !
       FOR ALL ENTRIES IN gt_tran " FOR ALL ENTRIES# ## gt_tran# ## #### # ### # ## ###
     WHERE ebeln = gt_tran-ebeln
       AND ebelp = gt_tran-ebelp.

    IF gt_volm IS INITIAL.
      MESSAGE s112(zmcb1) DISPLAY LIKE 'E' WITH '####'. " ## ### #### ## ####
      EXIT.
    ENDIF.
  ENDIF.

  " 3. #### ## ## (### ##) -- ## ##, ## ##, ## #### ## #### ####
  DATA: lt_done_po TYPE TABLE OF ty_tran_key, " P(##) ## #### # ###
        lt_cr_po   TYPE TABLE OF ty_tran_key. " CR(####) ## #### # ###

  LOOP AT gt_tran INTO DATA(ls_tmp).
    " P# #### ## ## ##
    IF ls_tmp-event_type = 'P'.
      APPEND VALUE #( ebeln = ls_tmp-ebeln ) TO lt_done_po.
      " CR# #### ## ## ##
    ELSEIF ls_tmp-event_status = 'CR'.
      APPEND VALUE #( ebeln = ls_tmp-ebeln ) TO lt_cr_po.
    ENDIF.
  ENDLOOP.

  " ## ## (## ### = ######)
*  ##(10, 20, ,,)# ##### ## ### ### ## ## EBELP# #### ##
  SORT lt_done_po BY ebeln.
  DELETE ADJACENT DUPLICATES FROM lt_done_po COMPARING ebeln. " ## ### ##+##### ### ##
  SORT lt_cr_po BY ebeln.
  DELETE ADJACENT DUPLICATES FROM lt_cr_po COMPARING ebeln. " cr# ### ##+##### ### ##

  " gt_tran# ## ### # CR ### ## ## ###, CR ### ## ## ###
  LOOP AT gt_tran ASSIGNING FIELD-SYMBOL(<fs_tran>).

    " ## ## ## ## ### ## 'P' ### ### ##
    READ TABLE lt_done_po WITH KEY ebeln = <fs_tran>-ebeln
                          BINARY SEARCH TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      " ## ## #### P# ###, C ## ### ## ###### ## (### = ## ##)
      <fs_tran>-excp_fld = icon_green_light.
      <fs_tran>-col_fld  = ' '. " ## ## ## ## ##
      CONTINUE.
    ENDIF.

    " P# ### ## ## CR# #### ### ## (#### ##)
    READ TABLE lt_cr_po WITH KEY ebeln = <fs_tran>-ebeln
                        BINARY SEARCH TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      " ## ## ## P# ## ## (C### ## ##)
      <fs_tran>-excp_fld = icon_red_light. " ### = ## ##
      <fs_tran>-col_fld  = 'C300'. " ## #### ## ##
    ELSE.
      <fs_tran>-excp_fld = icon_yellow_light. " ### = ## #
      <fs_tran>-col_fld  = ' '.
    ENDIF.

  ENDLOOP.
  " ####### # = ### ### ## ###
  SORT gt_tran BY ebeln DESCENDING ebelp ASCENDING seqno ASCENDING.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_selected_data (##### ### #### ## #### ##)
*&---------------------------------------------------------------------*
FORM x_check_selected_data USING    ps_row_id TYPE lvc_s_row
                         CHANGING ps_tran   LIKE gs_tran
                                  pv_ref_po TYPE ebeln.
  " 1. ### # ### ####
  READ TABLE gt_tran INTO ps_tran INDEX ps_row_id-index.
  IF sy-subrc <> 0. " ### ### ### ###
    RETURN.
  ENDIF.

  " 3. ## ##(#### ##)# ## ## ## ##
  " gt_tran# ## DB View -> get_data()# ## 'P' ### ## ### ### ###
  DATA(lv_cr) = abap_false.

  LOOP AT gt_tran INTO DATA(ls_all) " #### ### ####, ## ### ### ## ### ##
    WHERE ebeln = ps_tran-ebeln
      AND ebelp = ps_tran-ebelp.
    IF ls_all-event_status = 'CR'. " #### CR# ### ## ## #### ##
      lv_cr = abap_true.
      EXIT. " #### ### ### ##
    ENDIF.
  ENDLOOP.

  " 4. CR(##, ### ##) #### # ### ### ## ##
  IF lv_cr = abap_false.
    MESSAGE s113(zmcb1) DISPLAY LIKE 'E' WITH '##' '(CR)'. " ## ### ## ## ## ## ##(CR)# ####
    CLEAR ps_tran. " ## # ### ### ##
    RETURN.
  ENDIF.

  " ## ##### ## ####(## ####) ## ##
  " #### ## ##### ######(ZEBELN #)# ##.
  SELECT SINGLE zebeln
    FROM ztb1mm0006
    INTO pv_ref_po
   WHERE ebeln = ps_tran-ebeln. " ### ## PO ### ##

  " 5. ## ## ## ##
  DATA: lv_answer   TYPE c,
        lv_question TYPE string. " ## ## # = #### -> ## ## ##### #### #### ###
  lv_question = |## ## [{ ps_tran-ebeln }] # #### [{ pv_ref_po }] # ## ######.| &&
                 |{ pv_ref_po } ### ## ########?|.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      text_question = lv_question
    IMPORTING
      answer        = lv_answer.

  IF lv_answer <> '1'. " Yes# ### #### ### ## PERFORM# # ## #
    CLEAR: ps_tran, pv_ref_po.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_selected_data (###### ### #### ##### ##)
*&---------------------------------------------------------------------*
FORM x_handle_selected_data USING ps_tran LIKE LINE OF gt_tran
                                 pv_ebeln LIKE gs_pohd-zebeln.
  " ## ### # ### ## ## ##
  IF gv_visible = abap_false. " ' ' # ##
    MESSAGE i017(zmcb1) WITH '[## ##]' '###'. " ## [## ##] ### ## ### ### ######
    RETURN. " ## ##
  ENDIF.

  DATA: ls_volm LIKE LINE OF gt_volm. " ps_tran(##### #####)# ####

  " ## get_data## ## #### gt_volm## ## tran# ## ### ##
  READ TABLE gt_volm INTO ls_volm
    WITH KEY zdocno = pv_ebeln.  " ##PO### ### '##PO##'# ####### ##

  IF sy-subrc = 0. " ##### ##### (1) ### ## ###: ##### ##
    ls_volm-col_fld = 'C510'.
    MODIFY gt_volm FROM ls_volm INDEX sy-tabix.
    go_alv_volm->refresh_table_display( ).

    " (2) ### #####, ## #### ## (### input #### ##)
    gs_pohd-ebeln = pv_ebeln.               " PO##
    gs_item-bwart = '101'.                  " #### ##
    " ## ## ###: ####/MS26####NN <- ###### ##
    gs_head-bktxt = |#### / { ls_volm-zmsno }|.

    " ### ALV ##
    " PERFORM add_selected_data USING ls_volm. " #### ### #### ### ### ###### #### ###
    cl_gui_cfw=>set_new_ok_code( 'REFRESH' ).
    MESSAGE s606(zmcb1). " ## ## ### #######
  ELSE.
    " (3) ## ## #: ## #### ##
    MESSAGE i607(zmcb1). " ## ### #####. ## #### #####
    SET PARAMETER ID 'BES' FIELD pv_ebeln. " #### id# ## ###### ##
    CALL TRANSACTION 'ZRB1MM0001' AND SKIP FIRST SCREEN. " call transaction## #### ## ## # ## ### # ##.

    " (#### ####) #####
    PERFORM get_data. " ## ### ##### #
    go_alv_tran->refresh_table_display( ).
    go_alv_volm->refresh_table_display( ).
    MESSAGE s016(zmcb1) WITH '##'. " #### #######. ## #### ### #####
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form add_selected_data (### #### ### alv# ##)
*&---------------------------------------------------------------------*
FORM x_add_selected_data USING ps_volm LIKE LINE OF gt_volm.

  DATA: lt_item  TYPE TABLE OF ty_item, " gt_item# ### ##
        ls_item  LIKE LINE OF lt_item,
        lv_tabix TYPE sy-tabix.

  " 1. #### ##(ps_volm-zdocno)# #### ## ###
  "    CDS view## ### ## ### ## #### itab# ##
  SELECT ebeln, ebelp, matnr, werks, lgort, menge, meins, fin_netpr_krw AS netpr, waersk, fin_netpr_usd AS netpr_usd, waers, insmk, add_ukurs
    FROM zcds_b1_mm_0002( p_bldat = @gs_head-bldat ) " ##### ### ####(#### ### bldat)
    INTO CORRESPONDING FIELDS OF TABLE @lt_item
   WHERE ebeln = @ps_volm-zdocno.
  "  AND postat = '2'. " ## ##
  " AND lvorm <> 'X' " ## ## -> ## CDS view ### ###

  IF sy-subrc <> 0.
    MESSAGE i112(zmcb1) WITH '#### ## ##'. " ## ### #### ## ## ## ####
    RETURN.
  ENDIF.

  " 2. ## ALV# gt_item# ##### #### ## + ## ### ####
  LOOP AT lt_item INTO ls_item. " ### #### ##### gt_item ### ### ##

    " 2-1. ## ### ### ## ### 0### ### 0# ##
    IF ls_item-add_ukurs = 0 OR ls_item-netpr = 0.
      MESSAGE i407(zmcb1) WITH ls_item-matnr '##:' '###'. " (####) ##: ## ### ## ### ### #####.
      CONTINUE. " ## #### ALV# #### ## ## ### ###
    ENDIF.

    " 2-2. ##### ## # # ##
    READ TABLE gt_item WITH KEY matnr = '' TRANSPORTING NO FIELDS.
    lv_tabix = sy-tabix.

    IF sy-subrc = 0.
      " 2-3. # ## ### ## ## lv_tabix# #### #### (#### ##)
      READ TABLE gt_item ASSIGNING FIELD-SYMBOL(<fs_item>) INDEX lv_tabix.
    ELSE.
      " 2-4. ## 10## # ### ### ## ####
      APPEND INITIAL LINE TO gt_item ASSIGNING <fs_item>.
      PERFORM set_item_number. " ## ## ## ## ### ## ##### ### ##
    ENDIF.

    " (1) ## ## ##
    MOVE-CORRESPONDING ls_item TO <fs_item>. " ######
    <fs_item>-insmk = 'T'.   " #### (#### ## = #### ##)
    <fs_item>-bwart = gs_item-bwart.   " #### (#### ##)

    " (2) ## ##
    " ## ### ## #### ### #### ### ###
    " ## ### ## '## ##'# ## #### ###
    IF ls_item-ebelp = ps_volm-zdocit.
      <fs_item>-menge = ps_volm-zsvol. " ## ## ##
    ELSE.
      MESSAGE s608(zmcb1) WITH '####' DISPLAY LIKE 'W'.
    ENDIF.

    " (3) ## ##
    <fs_item>-dmbtr = <fs_item>-netpr * <fs_item>-menge. " ###(##)
    <fs_item>-wrbtr = <fs_item>-netpr_usd * <fs_item>-menge.  " ###(####)
  ENDLOOP.

  " 3. ## ### ALV ####
  PERFORM refresh_alv USING gs_stable CHANGING go_alv.
ENDFORM.
*&---------------------------------------------------------------------*
*& FORM check_po_status (###### ## ## ## ##)
*&---------------------------------------------------------------------*
FORM x_check_po_status USING pv_mat_po TYPE ebeln. " #### #### ### ### ### #####
  DATA: lv_tran_po   TYPE ebeln, " ### ### ##### ####, ##### '######'# ### ### #### ##
        lv_cr_exists TYPE abap_bool, " cr#(## ## ##) #####,
        lv_p_exists  TYPE abap_bool. " p##(## ## ##, ###### ## ##)# ### ##

  " 1. # ## PO# #### ## PO# ### ## ####,
  SELECT SINGLE ebeln
    FROM ztb1mm0006 " #### ##
    INTO @lv_tran_po " ## PO ##
   WHERE zebeln = @pv_mat_po. " ####### ## PO# ## PO ##

  IF sy-subrc <> 0.
    MESSAGE e609(zmcb1) WITH '####'. " ## ### ## #######
    RETURN.
  ENDIF.

  " 2. ## ## PO# ### ### (CR# ## P# ### #)
  SELECT event_type, event_status
    FROM ztb1mm0021
    WHERE ebeln = @lv_tran_po
    INTO TABLE @DATA(lt_status).

  " CR(## ##) ### ### ##
  READ TABLE lt_status WITH KEY event_status = 'CR' TRANSPORTING NO FIELDS.
  IF sy-subrc = 0.
    lv_cr_exists = abap_true.
  ENDIF.

  " P(## ## ## ##) ### ## ### ##
  READ TABLE lt_status WITH KEY event_type = 'P' TRANSPORTING NO FIELDS.
  IF sy-subrc = 0.
    lv_p_exists = abap_true.
  ENDIF.

  " 3. ## ## - CR# ## + P# ## # ##### ###
  IF lv_cr_exists = abap_false.
    MESSAGE e113(zmcb1) WITH '##' '(CR)'.
  ELSEIF lv_p_exists = abap_true.
    MESSAGE e610(zmcb1) WITH '####'. " ## ## ### ### #####
  ELSE.
    " MESSAGE '## ### #####' TYPE 'S'. ## ## ### ##X
  ENDIF.
ENDFORM.

FORM x_display_process_flow_x.
  IF gv_load_tran = 'X'.
    go_doc->add_icon( sap_icon = 'ICON_STATUS_OK' ).
  ELSE.
    go_doc->add_icon( sap_icon = 'ICON_DRAW_ELLIPSE' ).
  ENDIF.
  go_doc->add_link( name = 'LOAD_TRAN' text =  '[1# ##]'  ).
  go_doc->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).

  IF gv_load_volm = 'X'.
    go_doc->add_icon( sap_icon = 'ICON_STATUS_OK' ).
  ELSE.
    go_doc->add_icon( sap_icon = 'ICON_DRAW_ELLIPSE' ).
  ENDIF.
  go_doc->add_link( name = 'LOAD_VOLM' text =  '[#### ####]'  ).
  go_doc->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).

  IF gv_load_gr = 'X'.
    go_doc->add_icon( sap_icon = 'ICON_STATUS_OK' ).
  ELSE.
    go_doc->add_icon( sap_icon = 'ICON_DRAW_ELLIPSE' ).
  ENDIF.
  go_doc->add_link( name = 'LOAD_TRAN' text =  '[####]'  ).
  go_doc->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).

  IF gv_plant_tran = 'X'.
    go_doc->add_icon( sap_icon = 'ICON_STATUS_OK' ).
  ELSE.
    go_doc->add_icon( sap_icon = 'ICON_DRAW_ELLIPSE' ).
  ENDIF.
  go_doc->add_link( name = 'PLANT_TRAN' text =  '[2# ##]'  ).
  go_doc->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).

  IF gv_plant_volm = 'X'.
    go_doc->add_icon( sap_icon = 'ICON_STATUS_OK' ).
  ELSE.
    go_doc->add_icon( sap_icon = 'ICON_DRAW_ELLIPSE' ).
  ENDIF.
  go_doc->add_link( name = 'PLANT_VOLM' text =  '[#### ####]'  ).
  go_doc->add_icon( sap_icon = 'ICON_ARROW_RIGHT' ).

  IF gv_plant_gr = 'X'.
    go_doc->add_icon( sap_icon = 'ICON_STATUS_OK' ).
  ELSE.
    go_doc->add_icon( sap_icon = 'ICON_DRAW_ELLIPSE' ).
  ENDIF.
  go_doc->add_link( name = 'PLANT_TRAN' text =  '[####]'  ).

  go_doc->new_line( ).
  go_doc->new_line( ).
  go_doc->add_gap( width = 30 ).

  IF gv_load_can = 'X'.
    go_doc->add_link( name = 'LOAD_TRAN' text = '#### ##' ).
    go_doc->add_icon( sap_icon = 'ICON_INCLUDE_IN_SELECTION' ).
  ELSEIF gv_load_gr = 'X'.
    go_doc->add_text( text = '#### ##' ).
    go_doc->add_icon( sap_icon = 'ICON_INCLUDE_IN_SELECTION' ).
  ELSE.
    go_doc->add_text( text = '#### ###' ).
    go_doc->add_icon( sap_icon = 'ICON_REMOVE_FROM_SELECTION' ).
  ENDIF.

  IF gv_plant_can = 'X'.
    go_doc->add_link( name = 'PLANT_TRAN' text = '#### ##' ).
    go_doc->add_icon( sap_icon = 'ICON_INCLUDE_IN_SELECTION' ).
  ELSEIF gv_plant_gr = 'X'.
    go_doc->add_text( text = '#### ##' ).
    go_doc->add_icon( sap_icon = 'ICON_INCLUDE_IN_SELECTION' ).
  ELSE.
    go_doc->add_text( text = '#### ###' ).
    go_doc->add_icon( sap_icon = 'ICON_REMOVE_FROM_SELECTION' ).
  ENDIF.

  go_doc->merge_document( ).
  go_doc->display_document( parent = go_cont_doc ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form x_before_item_logic

FORM x_before_item_logic .
*      IF ls_item-matnr IS NOT INITIAL. " ### ###, ## ### ##### ## #### ##
*        SELECT SINGLE matnr
*        FROM zcds_b1_mm_0002(  p_bldat = @gs_head-bldat )
*          WHERE ebeln = @gs_pohd-ebeln AND matnr = @ls_item-matnr
*          INTO @DATA(lv_dummy).
*        IF sy-subrc <> 0. " pv_value ### matnr# ## INITIAL ## ### ## ####
*          PERFORM check_and_add_protocol USING ls_item-matnr 'E' '109' ls_item-matnr 'MATNR' lv_tabix lo_protocol CHANGING lv_error_cnt.
*        ENDIF.
*      ENDIF.
*
*      " ## 2) ### # #### ### ##
*      PERFORM check_and_add_protocol USING ls_item-werks 'E' '014' '###' 'WERKS' lv_tabix lo_protocol CHANGING lv_error_cnt.
*      PERFORM check_and_add_protocol USING ls_item-lgort 'E' '014' '####' 'LGORT' lv_tabix lo_protocol CHANGING lv_error_cnt.
*      " ## ## ### -> ## #### ###(#### ## ###) ##
*      IF ls_item-werks IS NOT INITIAL AND ls_item-lgort IS NOT INITIAL.
*        SELECT SINGLE werks FROM ztb1mm0000
*          WHERE werks = @ls_item-werks AND lgort = @ls_item-lgort AND lvorm <> 'X'
*          INTO @DATA(lv_dummy_lg).
*        IF sy-subrc <> 0. " #### ## ###/#### ### ## ##
*          PERFORM check_and_add_protocol USING '' 'E' '010' '### # ####' 'WERKS' lv_tabix lo_protocol CHANGING lv_error_cnt.
*        ENDIF.
*      ENDIF.
*
*      " ## 3) ## 1 ## ##
*      IF ls_item-menge <= 1.
*        PERFORM check_and_add_protocol USING '' 'E' '111' ls_item-meins 'MENGE' lv_tabix lo_protocol CHANGING lv_error_cnt.
*      ENDIF.
ENDFORM.
***********************************************************
*   ### ###: ####, ###, ####, #### -> ### # ### ##. ##### ###: ###, ## #
*   ### #:
*   (1) ##### ## ##### ## #### ##
*   (2) ## ## # #### ## #### ## ##, ## ## ## ###
*   (3) ###, ##### ## #### ### ###### ##
*   (4) ## # ###(## ## ##) ##### ### ## ### ## -> ## ### check/save #### ##
*   (5) ## ## #, KRW ### USD(####) ### ## ##### #
*&---------------------------------------------------------------------*
*& Form handle_data_changed (100# ### ALV ### ## # ##)
*&---------------------------------------------------------------------*
FORM handle_data_changed USING pr_data_changed TYPE REF TO cl_alv_changed_data_protocol.
  DATA: ls_mod_cell TYPE lvc_s_modi, " ### # ### ## ###
        lv_matnr    TYPE matnr, " # ### ###, #### #### ## #### ##
        lv_menge    TYPE menge_d,
        lv_netpr    TYPE netpr.      " KRW ### ##
*        lv_ukurs    TYPE ukurs_curr, " ## ##
*        lv_wrbtr    TYPE wrbtr,      " ## ## (USD #)
*        lv_dmbtr    TYPE dmbtr.      " ## ## (KRW)

  LOOP AT pr_data_changed->mt_good_cells INTO ls_mod_cell WHERE value IS NOT INITIAL. " #### ## ### ###
    " #### ## ### ## ####, ## ## # # ## #### ##
    CHECK ls_mod_cell-value IS NOT INITIAL.
    " ## ### ## #### ## ### ## ###. row_id# gt_item# ### ##
    READ TABLE gt_item ASSIGNING FIELD-SYMBOL(<fs_item>) INDEX ls_mod_cell-row_id.
    CHECK sy-subrc = 0. " # ### ## ### # #

    CASE ls_mod_cell-fieldname. " ## #### ###### ## ##
        " #1. ##### ### #####
      WHEN 'MATNR'.
        " 1) #### ### #### # ####
        pr_data_changed->get_cell_value( EXPORTING i_row_id = ls_mod_cell-row_id i_fieldname = 'MATNR' IMPORTING e_value = lv_matnr ).

        " 2) ##### ### ## ## ## - #### #### ## ### ### #### ##
        IF lv_matnr IS NOT INITIAL.
          " 2-1. # ## #### ### PO## #### ### ##
          IF gs_pohd-ebeln IS INITIAL.
            MESSAGE '## ### PO ## ## ##### #### ### #####' TYPE 'S' DISPLAY LIKE 'E'.
            PERFORM clear_item_row USING pr_data_changed ls_mod_cell-row_id <fs_item>.
            EXIT. " -> ### ## ##
          ENDIF. " ## PO## # ### # # #### ####

          " 2-2. CDS View Entity# #### ## ### ##### #### #### ##
          SELECT SINGLE ebelp, fin_netpr_usd, fin_netpr_krw, add_ukurs, waers, meins " ########, ######, krw##, ### ##, ####, ####
            FROM zcds_b1_mm_0002( p_bldat = @gs_head-bldat ) " #### ##### ##
            WHERE ebeln = @gs_pohd-ebeln
              AND matnr = @lv_matnr " #### ####, ##### ## ### CDS## 1# #### ## !
            INTO (@<fs_item>-ebelp, @<fs_item>-netpr_usd, @<fs_item>-netpr, @<fs_item>-add_ukurs, @<fs_item>-waers, @<fs_item>-meins).

          IF sy-subrc = 0.
            " 2-3-1) ### ### ## #### ### ##### ##
            <fs_item>-ebeln = gs_pohd-ebeln.
            <fs_item>-bwart = '101'. " gs_item-bwart ## 101 ## ##(#### ##)
            <fs_item>-insmk = 'T'.   " ##### # #### (#### ## = #### ##)
            <fs_item>-waersk = 'KRW'.

            " 2-3-2) #### ####(KRW), ####, ##### #### ### ####
            pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'NETPR' i_value = <fs_item>-netpr ).
            pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'WAERS'     i_value = <fs_item>-waers ).
            pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'WAERSK'    i_value = 'KRW' ).
            pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'MEINS'     i_value = <fs_item>-meins ).
          ELSE.
            " 2-2) #### ## ##### ### ### ### ## # ###
            gv_show_msg  = abap_true. " ### ### ##
            gv_msg_matnr = lv_matnr.  " ## ### #### ##
            PERFORM clear_item_row USING pr_data_changed ls_mod_cell-row_id <fs_item>.
          ENDIF.

        ELSE. " lv_matnr IS INITIAL
          " 3) #### #### ### ## # ## ## #### ##
          gv_show_msg  = abap_true. " ### ### ##
          gv_msg_matnr = lv_matnr.  " ## ### #### ##
          PERFORM clear_item_row USING pr_data_changed ls_mod_cell-row_id <fs_item>.
        ENDIF.

        " #2. ### #####
      WHEN 'MENGE'. "### ### ## ## ## ### ###
        pr_data_changed->get_cell_value( EXPORTING i_row_id = ls_mod_cell-row_id i_fieldname = 'MENGE' IMPORTING e_value = lv_menge ).

        " 1) ## ## ##: KRW ## * ##
        <fs_item>-dmbtr = <fs_item>-netpr * lv_menge.

        " 2) ####(USD #) ## ##: USD ## * ##
        <fs_item>-wrbtr = <fs_item>-netpr_usd * lv_menge.

        " ALV ### ### ## ####
        pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'DMBTR' i_value = <fs_item>-dmbtr ).
        pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'WRBTR' i_value = <fs_item>-wrbtr ).
        pr_data_changed->modify_cell( i_row_id = ls_mod_cell-row_id i_fieldname = 'WAERS' i_value = <fs_item>-waers ).

        " #4. #### #### ## #
      WHEN 'WERKS' OR 'LGORT'.
        " 1) ## ## #### #### ## ###
        pr_data_changed->get_cell_value( EXPORTING i_row_id = ls_mod_cell-row_id i_fieldname = 'WERKS' IMPORTING e_value = <fs_item>-werks ).
        pr_data_changed->get_cell_value( EXPORTING i_row_id = ls_mod_cell-row_id i_fieldname = 'LGORT' IMPORTING e_value = <fs_item>-lgort ).

        " 2) # # ## ## ## ### ### ##
        PERFORM check_plant_storage_master USING pr_data_changed ls_mod_cell-row_id <fs_item>.
    ENDCASE.
  ENDLOOP.

  " ### ### ### # (5)# ### ##/### ## ## ## ## ##
  PERFORM control_header_screen.
  PERFORM refresh_alv USING gs_stable CHANGING go_alv.

  IF gv_show_msg IS NOT INITIAL.
    MESSAGE s109(zmcb1) WITH gv_msg_matnr DISPLAY LIKE 'W'. " (##### ###/####) ## ### ## # ####
    CLEAR: gv_show_msg, gv_msg_matnr.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_plant_storage_master (### #### ### ##)
*&---------------------------------------------------------------------*
FORM check_plant_storage_master USING pr_data_changed TYPE REF TO cl_alv_changed_data_protocol
                                      pv_row_id TYPE lvc_s_modi-row_id
                                      ps_item STRUCTURE gs_item.
  IF  ps_item-werks IS NOT INITIAL AND ps_item-lgort IS NOT INITIAL.
    SELECT SINGLE werks, lgort
      FROM ztb1mm0000
      WHERE werks = @ps_item-werks
        AND lgort = @ps_item-lgort
      INTO @DATA(lv_check).

    IF sy-subrc <> 0.
      " 3) #### ## #### ## ##
      gv_show_msg = abap_true.
      gv_msg_matnr = |{ ps_item-werks }/{ ps_item-lgort }|. " #### ### '###/####' ### ### ####

      " ## ### ### (### ALV ## ### ## ####### #)
      ps_item-werks = ''.
      ps_item-lgort = ''.
      pr_data_changed->modify_cell( i_row_id = pv_row_id i_fieldname = 'WERKS' i_value = '' ).
      pr_data_changed->modify_cell( i_row_id = pv_row_id i_fieldname = 'LGORT' i_value = '' ).
    ENDIF.
  ENDIF.
ENDFORM.
