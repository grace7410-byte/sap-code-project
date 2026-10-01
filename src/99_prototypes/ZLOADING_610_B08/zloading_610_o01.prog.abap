*&---------------------------------------------------------------------*
*& Include          MZB1MM0002O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT  (100# ### Status)
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  DATA: lv_title TYPE string.
  CASE gv_mode.
    WHEN 'L'. lv_title = '- ####'.
    WHEN 'P'. lv_title = '- ####'.
    WHEN 'S'. lv_title = '- ## ##(####)'.
    WHEN OTHERS.
      lv_title  = ' '.
  ENDCASE.

  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100'  WITH lv_title.

*  ### ##
  " 1. ## #### # ####
  GET PARAMETER ID 'BUK' FIELD gs_head-bukrs. " ## ##
  IF gs_head-bukrs IS NOT INITIAL. " ##### ### ### ####
    PERFORM get_domain_text USING 'ZDB1_MM_BUKRS' gs_head-bukrs  CHANGING gv_bukrs.
  ENDIF.

  " 2. ## ### ##
  gv_type = 'GR'.        " ## ##(##, ## #)
  gs_pohd-bsart = 'NB'.         " ### #### ## ####
  gs_head-bldat = sy-datum.     " ## ## = ##

  IF gv_first_time = 'X'. " ## ### ### #### # ##### ##
    gv_ebeln = '4500000213'.
  ENDIF.
  SET CURSOR FIELD 'GV_EBELN'.

  gv_visible = 'X'.

*  IF gv_ebeln IS NOT INITIAL.
*    PERFORM get_process_data USING gv_ebeln.
*  ENDIF.

  gv_ebeln = gv_select_ebeln.
ENDMODULE.
MODULE status_0120 OUTPUT.
  SET PF-STATUS 'S120'.
*  SET TITLEBAR 'T120'.
ENDMODULE.
MODULE status_0130 OUTPUT.
  SET PF-STATUS 'S120'.
  SET TITLEBAR 'T130'.

  " ## ### ## # (#### ## ### ## ##)
  IF gv_manual = 'X'.
    LOOP AT SCREEN.
      IF screen-group1 = 'G2'. " ###, '# # ####' ###, ####
        screen-active = '0'.   " #######(#### ### ### #####)
        screen-invisible = '1'. " ####
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV OUTPUT (100# ### ALV ### ##)
*&---------------------------------------------------------------------*
MODULE init_alv OUTPUT.
  " 1. # ##(item itab# #####)
  PERFORM set_init_item_rows.

  "2. ## ### Area ## (1# alv - custom cont)
  IF go_cont IS INITIAL.

    "2-1. ## Container# ##### ####, ## ### (cont, alv ## ##)
    PERFORM create_object USING 'AREA' CHANGING go_cont go_alv. " Custom Cont + ALV Grid ##

    "2-2. ## ####
    " #### #### ####, uifunc ##### gs_layout, gs_uifunc ## (item#)
    PERFORM set_layout USING 1 CHANGING gs_layout.
    PERFORM set_uifunc USING 1 CHANGING gt_uifunc.
    PERFORM set_fcat_item CHANGING gt_fcat_item.
    SET HANDLER lcl_event_handler=>on_data_changed FOR go_alv.
    SET HANDLER lcl_event_handler=>on_toolbar FOR go_alv.
    SET HANDLER lcl_event_handler=>on_user_command FOR go_alv.

    "2-3. # ## ####
    PERFORM display_alv USING gs_layout gt_uifunc gt_fcat_item
                        CHANGING go_alv gt_item.
  ELSE.
    " 2-5. ## ###### refresh#
    PERFORM set_item_number. " 2-4. # ## ## ### ## ##

    PERFORM set_fcat_item CHANGING gt_fcat_item. " gv_mode# ## fcat# #### ##
    go_alv->set_frontend_fieldcatalog( it_fieldcatalog = gt_fcat_item ). " +) refresh

    PERFORM refresh_alv USING gs_stable CHANGING go_alv.
  ENDIF.

  " ##### ### ### ##### #### #### ###
  IF go_cont IS BOUND. " IS INITIAL ## ####, IS ASSIGNED ## ## (## ##)
    go_cont->set_visible( visible = gv_visible ). " gv_visible# 'X'# ###, ' '# ###
    go_alv->set_ready_for_input( i_ready_for_input = 1 ).

*    IF gs_row_st-row_id IS NOT INITIAL. " ### ### ##
*      DATA: ls_col_st TYPE lvc_s_col.
*      CALL METHOD go_alv->set_scroll_info_via_id
*        EXPORTING
*          is_row_no   = gs_row_st    " ### # ## (Numeric Row ID)
*          is_col_info = ls_col_st. " ## ## ####
*      CLEAR gs_row_st.
*    ENDIF.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0101 OUTPUT (100# ###)
*&---------------------------------------------------------------------*
MODULE init_alv_0101 OUTPUT.
  "3. ## ### 2,3# alv - container+splitter cont ##
  IF go_cont_101 IS INITIAL.
    PERFORM get_data .
    PERFORM create_split_object
      USING 2 'DOC1'
      CHANGING go_cont_101 go_split_101 go_cont_1 go_cont_2 go_alv_101.

    " 3-2. ## ####
    PERFORM set_layout USING 2 CHANGING gs_layo_pohd.
    PERFORM set_uifunc USING 2 CHANGING gt_uifunc_pohd.
    PERFORM set_fcat_struct USING 'ZTB1MM0006' CHANGING gt_fcat_pohd.

    SET HANDLER lcl_event_handler=>on_toolbar FOR go_alv_101.
    SET HANDLER lcl_event_handler=>on_user_command FOR go_alv_101.

    " 3-3. # ## ##
    PERFORM display_alv USING gs_layo_pohd gt_uifunc_pohd gt_fcat_pohd CHANGING go_alv_101 gt_pohd.
  ELSE.
    PERFORM refresh_alv USING gs_stable CHANGING go_alv_101.
  ENDIF.
  PERFORM display_mat_status.
  go_doc_101->display_document( parent = go_cont_2 ).

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0110 OUTPUT (100# ### ## ##)
*&---------------------------------------------------------------------*
MODULE init_alv_0110 OUTPUT.
  "3. ## ### 2,3# alv - container+splitter cont ##
  IF go_container IS INITIAL.
    PERFORM create_split_object
      USING 3 'DOC2'
      CHANGING go_container go_splitter
               go_cont_pohd go_cont_mat go_alv_pohd. " container + Splitter + Cells 2# ALV ##

    " 3-2. ## ####
    PERFORM set_layout USING 3 CHANGING gs_layo_mat.
    PERFORM set_uifunc USING 3 CHANGING gt_uifunc_mat.
    PERFORM set_fcat_struct USING 'ZTB1MM0011' CHANGING gt_fcat_mat.

    SET HANDLER lcl_event_handler=>on_toolbar FOR go_alv_pohd.
    SET HANDLER lcl_event_handler=>on_user_command FOR go_alv_pohd.

    " 3-3. # ## ##
    PERFORM display_alv USING gs_layo_pohd gt_uifunc_pohd gt_fcat_pohd CHANGING go_alv_pohd gt_pohd.
    PERFORM display_alv USING gs_layo_mat gt_uifunc_mat gt_fcat_mat CHANGING go_alv_mat gt_head.

*    PERFORM display_inventory_status. "  -> ### #### ##, #### DOC ## X
*    go_doc_lgt->display_document( parent = go_cont_lgt ).
  ELSE.
    PERFORM refresh_alv USING gs_stable CHANGING go_alv_pohd.
    go_alv_mat->refresh_table_display( ).
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_DOCUMENT OUTPUT (100# ### #### ## ##)
*&---------------------------------------------------------------------*
MODULE init_document OUTPUT.

  IF go_cont_doc IS BOUND.
    go_cont_doc->free( ).     " #### #####
    FREE: go_cont_doc, go_doc. " ## ## ###
  ENDIF.
  " IF go_cont_doc / go_doc ## #### #### ### ##
  " ## ## ##
  CREATE OBJECT go_cont_doc
    EXPORTING
      container_name = 'FLOW'.
  CREATE OBJECT go_doc.

  " ## # #### #
  PERFORM display_process_flow.

  " #### ## #### html_control# ## ####
  IF go_doc->html_control IS BOUND.
    SET HANDLER lcl_event_handler=>sap_event FOR go_doc->html_control.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& MODULE check_pop_open (100# ### # # 120# ## ### ##)
*&---------------------------------------------------------------------*
MODULE check_pop_open OUTPUT. " -> ### #### ## ## ## X,  ### ##.

  CHECK gv_first_time = 'X'." #### # ### ## ## ##
  CLEAR: gv_first_time. " ## # # ### ### ### ##

  SELECT SINGLE zdate "  DB## # #### ##### ## #### ### ## ##
    FROM ztcheck_b08 " ## ### DB
    INTO @DATA(lv_saved_date) " sy-datum ### ## ##
    WHERE uname = @sy-uname
      AND progname = @sy-repid
      AND zdate = @sy-datum.

  " #### ## # =  ## #### # ###
  IF sy-subrc <> 0 OR lv_saved_date <> sy-datum. " ### ### ### ## ## ## ##
    " cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'DISPLAY_INFO' ). " ## PAI ## ### ### ###
    CREATE OBJECT go_timer. " ## ### ### ##
    SET HANDLER lcl_event_handler=>on_finished FOR go_timer.
    go_timer->interval = '0.5'. " 0.5# ## ##
    go_timer->run( ). cl_gui_cfw=>flush( ). " ### ### ### ##
  ENDIF.
ENDMODULE.
