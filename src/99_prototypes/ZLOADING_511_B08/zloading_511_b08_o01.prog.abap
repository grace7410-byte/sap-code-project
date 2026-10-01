*&---------------------------------------------------------------------*
*& Include          MZB1MM0002O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT  (100# ### Status)
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100'.
*  ### ##
  " 1. ## #### # ####
  GET PARAMETER ID 'BUK' FIELD gs_head-bukrs. " ## ##
  IF gs_head-bukrs IS NOT INITIAL. " ##### ### ### ####
    PERFORM get_domain_text USING 'ZDB1_MM_BUKRS' gs_head-bukrs  CHANGING gv_bukrs.
  ENDIF.

  " 2. ## ### ##
  gs_volm-zdocty = 'GR'.        " ## ##(##, ## #)
  gs_pohd-bsart = 'NB'.         " ### #### ## ####
  gs_head-bldat = sy-datum.     " ## ## = ##

  " 3. ## ### (####)
  IF gs_head-ebeln IS INITIAL. " PO ##
    gs_head-ebeln = '4500000102'. " ## #### # # # ## ##
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
    PERFORM get_data .

    "2-1. ## Container# ##### ####, ## ### (cont, alv ## ##)
    PERFORM create_object. " Custom Cont + ALV Grid ##

    "2-2. ## ####
    " #### #### ####, uifunc ##### gs_layout, gs_uifunc ## (item#)
    PERFORM set_layout USING 1 CHANGING gs_layout.
    PERFORM set_uifunc USING 1 CHANGING gt_uifunc.
    PERFORM set_fcat_item CHANGING gt_fcat_item.
    SET HANDLER lcl_event_handler=>on_after_user_command FOR go_alv.
    SET HANDLER lcl_event_handler=>on_data_changed FOR go_alv.

    "2-3. # ## ####
    PERFORM display_alv USING gs_layout gt_uifunc gt_fcat_item
                        CHANGING go_alv gt_item.
  ELSE.
    " 2-5. ## ###### refresh#
    PERFORM set_item_number. " 2-4. # ## ## ### ## ##
    go_alv->refresh_table_display( ).
  ENDIF.

  "3. ## ### 2,3# alv - container+splitter cont ##
  IF go_container IS INITIAL.
    PERFORM create_split_object. " container + Splitter + Cells 2# ALV ##

    " 3-2. ## ####
    PERFORM set_layout USING 0 CHANGING gs_layo_tran.
    PERFORM set_layout USING 0 CHANGING gs_layo_volm.
    PERFORM set_uifunc USING 0 CHANGING gt_uifunc_tran.
    PERFORM set_uifunc USING 0 CHANGING gt_uifunc_volm.
    PERFORM set_fcat_tran CHANGING gt_fcat_tran.
    PERFORM set_fcat_volm CHANGING gt_fcat_volm.
    SET HANDLER lcl_event_handler=>on_hotspot_click FOR go_alv_tran.

    " 3-3. # ## ##
    PERFORM display_alv USING gs_layo_tran gt_uifunc_tran gt_fcat_tran CHANGING go_alv_tran gt_tran.
    PERFORM display_alv USING gs_layo_volm gt_uifunc_volm gt_fcat_volm CHANGING go_alv_volm gt_volm.
  ELSE.
    go_alv_tran->refresh_table_display( ).
    go_alv_volm->refresh_table_display( ).
  ENDIF.

  " ##### ### ### ##### #### #### ###
  IF go_cont IS BOUND. " IS INITIAL ## ####, IS ASSIGNED ## ## (## ##)
    go_cont->set_visible( visible = gv_visible ). " gv_visible# 'X'# ###, ' '# ###
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0110 OUTPUT (100# ### ## ##)
*&---------------------------------------------------------------------*
MODULE modify_screen_0100 OUTPUT.
  " ### ## ### ### gt_item# #### ### ##
  PERFORM control_header_screen.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_DOCUMENT OUTPUT (100# ### #### ## ##)
*&---------------------------------------------------------------------*
MODULE init_document OUTPUT.

   " ## #### ### ##### # #####
  IF go_cont_doc IS BOUND.
    go_cont_doc->free( ).
    FREE go_cont_doc.
  ENDIF. " PBO # ### ## ###

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
