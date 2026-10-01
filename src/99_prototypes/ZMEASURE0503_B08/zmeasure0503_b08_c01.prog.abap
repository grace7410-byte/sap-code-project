*&---------------------------------------------------------------------*
*& Include          ZB1MM0001_C01
*&------------------------------------------------------------------
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
    " html ## ## #
    sap_event FOR EVENT sapevent OF cl_gui_html_viewer
      IMPORTING action, " ## ## ##### ## # ##
    " # #### #
    on_double_click FOR EVENT double_click
      OF cl_gui_alv_grid IMPORTING e_row e_column es_row_no sender, " sender# #### ## alv# ## #### #### # ##
    " # #### (##### ##)
    on_detail_double_click FOR EVENT double_click
      OF cl_gui_alv_grid IMPORTING e_row e_column es_row_no sender.
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.
  METHOD sap_event.
    DATA: lv_link_txt TYPE string.

    IF action CS 'PLAN'.
      IF gv_has_plan = 'X'.
        CASE gv_current_process.
          WHEN 'PO'.
            gv_dynnr = '0121'. " ## ### ## ## ###
            lv_link_txt = '## ### ##'.
          WHEN 'PrO'.
            gv_dynnr = '0131'. " ## ## ## ###
            lv_link_txt = '## ##'.
        ENDCASE.
      ELSE.
        MESSAGE i022(zmcb1) WITH '## ##/### ###'. "# #### #####.
      ENDIF.

    ELSEIF action CS 'ORDER'.
      PERFORM handle_order_screen.
      lv_link_txt = gv_order_name.

    ELSEIF action CS 'VOLUME'.
      IF gv_has_volume = 'X'.
        gv_dynnr = '0140'. " ## ## ## ###
        lv_link_txt = '## ##'.
      ELSE.
        MESSAGE i022(zmcb1) WITH '#### ###'. "# #### #####.
      ENDIF.
    ELSEIF action CS 'POST'.
      IF gv_has_post = 'X'.
        gv_dynnr = '0150'. " ## ## ## ###
        lv_link_txt = '## ##'.
      ELSE.
        MESSAGE i022(zmcb1) WITH '#### ##'. "#(#) #### #####.
      ENDIF.
    ENDIF.

    PERFORM display_process_flow.

    IF lv_link_txt IS NOT INITIAL.
      MESSAGE s023(zmcb1) WITH lv_link_txt. " ## ### #######
    ENDIF.
  ENDMETHOD.

  METHOD on_double_click.
    DATA: lv_msg_txt TYPE string.
    CLEAR: gs_item, gs_head.

    IF sender = go_alv_item.
      " ### # ##
      READ TABLE gt_item INTO gs_item INDEX e_row-index.
      gv_current_process = gs_item-process.
      lv_msg_txt = gs_item-zdocno.

      PERFORM clear_detail_data. " ## ### ###

      " ### ###(##, ##, ##### ## ##)# #### ##, ##, ### ### ##
      CASE gs_item-process.
        WHEN 'SO'.
          PERFORM get_full_process_so USING gs_item-zdocno.
        WHEN 'PO'.
          PERFORM get_full_process_po USING gs_item-zdocno.
        WHEN 'PrO'.
          PERFORM get_full_process_pro USING gs_item-zdocno.
      ENDCASE.

    ELSEIF sender = go_alv_head.
      READ TABLE gt_head INTO gs_head INDEX e_row-index.
      gv_current_process = gs_head-process.
      lv_msg_txt = gs_head-zdocno.

      PERFORM clear_detail_data. " ## ### ###

      " ### ###(##, ##, ##### ## ##)# #### ##, ##, ### ### ##
      CASE gs_head-process.
        WHEN 'SO'.
          PERFORM get_full_process_so USING gs_head-zdocno.
        WHEN 'PO'.
          PERFORM get_full_process_po USING gs_head-zdocno.
        WHEN 'PrO'.
          PERFORM get_full_process_pro USING gs_head-zdocno.
      ENDCASE.
    ENDIF.
    " process ### fv ## ##
    PERFORM get_domain_text USING 'ZDB1_MM_TYPE1' gv_current_process CHANGING gv_order_name.

    " ### #### Process Flow ## ###
    PERFORM display_process_flow.
    PERFORM handle_order_screen. " ##### ## ## ##

    IF lv_msg_txt IS NOT INITIAL.
      MESSAGE s023(zmcb1) WITH gv_current_process lv_msg_txt. " ## ## # #######.'.
    ENDIF.
  ENDMETHOD.


  METHOD on_detail_double_click.
    CLEAR: gs_vol_i, gs_mat_h.

    IF sender = go_alv_vol_i.
      " ### # ## -> ## #### ###
      READ TABLE gt_vol_i INTO gs_vol_i INDEX e_row-index.
      " ## ##
      cl_gui_cfw=>set_new_ok_code( new_code = 'REFR' ).

    ELSEIF sender = go_alv_mat_h.
      READ TABLE gt_mat_h INTO gs_mat_h INDEX e_row-index.
      cl_gui_cfw=>set_new_ok_code( new_code = 'REFR' ). " ## ##
    ENDIF.
  ENDMETHOD.
ENDCLASS.
