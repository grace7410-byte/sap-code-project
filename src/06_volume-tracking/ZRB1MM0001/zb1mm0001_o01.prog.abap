*&---------------------------------------------------------------------*
*& Include          ZB1MM0001_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100'.
  PERFORM set_display_info. " ####(####, so) ### ## ##
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0110 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0110 OUTPUT.
  PERFORM set_fcat_struct USING 'ZTB1SD0007' CHANGING gt_fcat_so_i.
  PERFORM display_only_alv USING 'SO_AREA' 'ZTB1SD0007'
                                  gt_so_i go_alv_so_i gt_fcat_so_i.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0120 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0120 OUTPUT.
  PERFORM set_fcat_struct USING 'ZTB1MM0007' CHANGING gt_fcat_po_i.
  PERFORM display_only_alv USING 'PO_AREA' 'ZTB1MM0007'
                                    gt_po_i go_alv_po_i gt_fcat_po_i.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0121 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0121 OUTPUT.
  PERFORM set_fcat_struct USING 'ZTB1MM0005' CHANGING gt_fcat_opt.
  PERFORM display_only_alv USING 'OPT_AREA' 'ZTB1MM0005'
                                    gt_po_opt go_alv_opt gt_fcat_opt.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0130 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0130 OUTPUT.
  PERFORM set_fcat_struct USING 'ZTB1PP0014' CHANGING gt_fcat_pro_i.
  PERFORM display_only_alv USING 'PRO_AREA' 'ZTB1PP0014'
                                  gt_pro_i go_alv_pro_i gt_fcat_pro_i.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0131 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0131 OUTPUT.
  PERFORM set_fcat_struct USING 'ZTB1PP0014' CHANGING gt_fcat_pln_i.
  PERFORM display_only_alv USING 'PLN_AREA' 'ZTB1PP0014'
                                  gt_pln_i go_alv_pln_i gt_fcat_pln_i.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0140 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0140 OUTPUT.
  PERFORM set_fcat_struct USING 'ZTB1MM0020' CHANGING gt_fcat_vol_i.
  PERFORM display_only_alv USING 'VOL_AREA' 'ZTB1MM0020'
                                  gt_vol_i go_alv_vol_i gt_fcat_vol_i.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0150 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0150 OUTPUT.
  PERFORM set_fcat_struct USING 'ZTB1MM0011' CHANGING gt_fcat_mat_h.
  PERFORM set_fcat_struct USING 'ZTB1MM0012' CHANGING gt_fcat_mat_i.
  PERFORM display_detail_alv USING 'MAT_AREA' 'ZTB1MM0011' 'ZTB1MM0012'
                   gt_mat_h gt_mat_i go_alv_mat_h go_alv_mat_i gt_fcat_mat_h gt_fcat_mat_i.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS 'S200'.
  SET TITLEBAR 'T200'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CHECK_SKIP_INITIAL_SCREEN OUTPUT
*&---------------------------------------------------------------------*
MODULE check_skip_initial_screen OUTPUT.
  " #### ID### ##### ###
  GET PARAMETER ID 'BES' FIELD gv_ebeln.

  " #### ###### ### ## ##### & 200### 'BACK'## ### # ## ##
  IF gv_ebeln IS NOT INITIAL AND gv_back IS INITIAL.
    " 100# ### ### ## ## ##(200#)## ###
    SET SCREEN '0200'.
    LEAVE SCREEN.
  ENDIF.
  IF gv_back IS NOT INITIAL.
    CLEAR gv_back.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV OUTPUT (100# ### ALV ### ##)
*&---------------------------------------------------------------------*
MODULE init_alv OUTPUT.
  " 1. ## Container# ##### ####, ## ###
  IF go_cont IS INITIAL.
    PERFORM create_object. " #### ## # ALV Grid ##
    " 2. ### ####(####) ###
    PERFORM display_info_text.

    "2-1. ## ## ####
    " #### #### ####, uifunc ##### gs_layout, gs_uifunc ##
    PERFORM set_layout USING 1 CHANGING gs_layo_head.
    PERFORM set_uifunc USING 1 CHANGING gt_uifunc_head.
    PERFORM set_fcat_head CHANGING gt_fcat_head.

    "2-2. ### ## ####
    PERFORM set_layout USING 2 CHANGING gs_layo_item.
    PERFORM set_uifunc USING 2 CHANGING gt_uifunc_item.
    PERFORM set_fcat_item CHANGING gt_fcat_item.

    " ### (####)
    SET HANDLER lcl_event_handler=>on_double_click FOR go_alv_head.
    SET HANDLER lcl_event_handler=>on_double_click FOR go_alv_item.

    "2-3. ## # ## ##
    PERFORM display_alv USING gs_layo_head gt_uifunc_head gt_fcat_head
                        CHANGING go_alv_head gt_head.
    PERFORM display_alv USING gs_layo_item gt_uifunc_item gt_fcat_item
                        CHANGING go_alv_item gt_item.
  ELSE.
    " 2-4. ## ###### refresh#
    go_alv_head->refresh_table_display( ).
    go_alv_item->refresh_table_display( ).
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_DOCUMENT OUTPUT
*&---------------------------------------------------------------------*
MODULE init_document OUTPUT.

  " ## #### ### ##### # #####
  IF go_cont_doc IS BOUND.
    go_cont_doc->free( ).
    FREE go_cont_doc.
  ENDIF. " PBO # ### ## ###
  CREATE OBJECT go_cont_doc
    EXPORTING container_name = 'FLOW'.
  CREATE OBJECT go_doc.
  " ## # #### #
  PERFORM display_process_flow.

  " #### ## #### html_control# ## ####
  IF go_doc->html_control IS BOUND.
    SET HANDLER lcl_event_handler=>sap_event FOR go_doc->html_control.
  ENDIF.
*
*  IF go_cont_doc IS INITIAL. " ## ### (##### #### ##)
*    CREATE OBJECT go_cont_doc
*      EXPORTING
*        container_name = 'FLOW'. " custom container# ##
*    CREATE OBJECT go_doc.
*
**  IF go_html_viewer IS NOT BOUND. " doc ## html_viewer # #
**    CREATE OBJECT go_cont_doc
**      EXPORTING
**        container_name = 'FLOW'. " custom container# ##
**
**  CREATE OBJECT go_html_viewer
**    EXPORTING
**      parent = go_cont_doc.
**ENDIF.
*    " doc ## ## + ### #### HTML ### ## ##
*    PERFORM display_process_flow.
*
*    IF go_doc->html_control IS BOUND.
*      SET HANDLER lcl_event_handler=>sap_event FOR go_doc->html_control.
*    ENDIF.
*  ELSE.
*    go_doc->initialize_document( ). " ###
*    PERFORM display_process_flow.
*  ENDIF.
**  IF go_html_viewer IS BOUND.
**    CALL METHOD go_html_viewer->load_data
**      IMPORTING
**        assigned_url = gv_url
**      CHANGING
**        data_table   = gt_html.
**
**    " ### URL# ### ##
**    CALL METHOD go_html_viewer->show_url
**      EXPORTING
**        url = gv_url.
**
**    SET HANDLER lcl_event_handler=>sap_event FOR go_html_viewer.
**    ENDIF.
ENDMODULE.
