*&---------------------------------------------------------------------*
*& Include          MZB1MM0002C01
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
    " alv ## ## ### ## # #### ###
    on_after_user_command FOR EVENT after_user_command
      OF cl_gui_alv_grid IMPORTING e_ucomm,
    " alv ### #### ####(#### # ##) #### ###
     on_data_changed FOR EVENT data_changed
      OF cl_gui_alv_grid IMPORTING er_data_changed,
    " ### ## ### ##
    on_hotspot_click FOR EVENT hotspot_click
      OF cl_gui_alv_grid IMPORTING e_row_id e_column_id,
    " html ## ## #
    sap_event FOR EVENT sapevent OF cl_gui_html_viewer
      IMPORTING action. " ## ## ##### ## # ##.
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.
  METHOD sap_event.
    DATA: lv_link_txt TYPE string.

*    IF action CS 'PLAN'.
*      IF gv_has_plan = 'X'.
*        CASE gv_current_process.
*          WHEN 'PO'.
*            gv_dynnr = '0121'. " ## ### ## ## ###
*            lv_link_txt = '## ### ##'.
*          WHEN 'PrO'.
*            gv_dynnr = '0131'. " ## ## ## ###
*            lv_link_txt = '## ##'.
*        ENDCASE.
*      ELSE.
*        MESSAGE i022(zmcb1) WITH '## ##/### ###'. "# #### #####.
*      ENDIF.
*
*    ELSEIF action CS 'ORDER'.
*      PERFORM handle_order_screen.
*      lv_link_txt = gv_order_name.
*
*    ELSEIF action CS 'VOLUME'.
*      IF gv_has_volume = 'X'.
*        gv_dynnr = '0140'. " ## ## ## ###
*        lv_link_txt = '## ##'.
*      ELSE.
*        MESSAGE i022(zmcb1) WITH '#### ###'. "# #### #####.
*      ENDIF.
*    ELSEIF action CS 'POST'.
*      IF gv_has_post = 'X'.
*        gv_dynnr = '0150'. " ## ## ## ###
*        lv_link_txt = '## ##'.
*      ELSE.
*        MESSAGE i022(zmcb1) WITH '#### ##'. "#(#) #### #####.
*      ENDIF.
*    ENDIF.
    PERFORM display_process_flow.

    IF lv_link_txt IS NOT INITIAL.
      MESSAGE s023(zmcb1) WITH lv_link_txt. " ## ### #######
    ENDIF.
  ENDMETHOD.

  METHOD on_after_user_command.
*    " ## ## ## #, ALV# ## ### itab# ## ##### ### ## ###
*    go_alv->check_changed_data( ).
*
*    CASE e_ucomm.
*      WHEN cl_gui_alv_grid=>mc_fc_loc_append_row OR " # ##
*           cl_gui_alv_grid=>mc_fc_loc_insert_row OR " # ##
*           cl_gui_alv_grid=>mc_fc_loc_delete_row OR " # ##
*           cl_gui_alv_grid=>mc_fc_loc_copy_row.     " # ##
*
*        PERFORM set_item_number. " ## # ## #####
*        PERFORM refresh_alv CHANGING gs_stable go_alv. "gs_stable # col, row #### refresh_table_display() ##
*    ENDCASE.
  ENDMETHOD. " #### ####### ##### ### ### ### ON_DATA_CHANGED# ##

  METHOD on_data_changed.
*    ## ##### ###### ##### ##### 10, 20, ... ## ##### ##
    IF er_data_changed->mt_inserted_rows IS NOT INITIAL OR " ### ## ###
     er_data_changed->mt_deleted_rows  IS NOT INITIAL. " ### ## ###

      PERFORM set_item_number. " ## # ## #####
      PERFORM refresh_alv CHANGING gs_stable go_alv. "gs_stable # col, row #### refresh_table_display() ##
    ENDIF.

*   ### ###: ####, ###, ####, ####
*   ### #:
*   (1) ##### ## ##### ## #### ##
*   (2) ## ## # #### ## #### ## ##, ## ## ## ###
*   (3) ###, ##### ## #### ### ###### ##
*   (4) ## # ###(## ## ##) ##### ### ## ### ## -> ## ### check/save #### ##
*   (5) ## ## #, KRW ### USD(####) ### ## ##### #
*   (6) #### ## # ## # ## ##. ## ## # ## ## ##
    " ## ##### ## ###
    PERFORM handle_data_changed USING er_data_changed.
  ENDMETHOD.

  METHOD on_hotspot_click. " tran ALV## ### #### ## ### #### ##
    " 1. ## ### #### - #### ## ##### ##
    CHECK e_column_id-fieldname = 'EBELN'.
    " 2. ## ### ## ### ##
    DATA: ls_tran   LIKE LINE OF gt_tran,
          lv_ref_po TYPE ebeln.
    " 3. ### ### ## # ## PO ## ## ##
    PERFORM check_selected_data USING    e_row_id CHANGING ls_tran lv_ref_po.
    " 4. check #### #### ##### ## ## ##
    " ### ###### ####### ##, #### alv## ## #### ##
    PERFORM handle_selected_data USING ls_tran lv_ref_po.
  ENDMETHOD.
ENDCLASS.
