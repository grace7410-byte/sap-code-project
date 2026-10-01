*&---------------------------------------------------------------------*
*& Include          ZRB1MM0001_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT (100# ### Status)
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100'.

  " 100# ### ## ## ## ## ## (###)
  PERFORM control_header_screen.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV OUTPUT (100# ### ALV ### ##)
*&---------------------------------------------------------------------*
MODULE init_alv OUTPUT.
  " 1. # ##(itab# #####)
  PERFORM set_init_item_rows.

  "2. 100# ### Layout# Area ## (1# alv - custom cont)
  IF go_cont IS INITIAL.
    "3. ## Container# ##### ####, ## ### (cont, alv ## ##)
    PERFORM create_object.

    "4. ## ####
    PERFORM set_layout.
    PERFORM set_uifunc.
    PERFORM set_fcat_item CHANGING gt_fcat_item.
    SET HANDLER lcl_event_handler=>on_after_user_command FOR go_alv.
    SET HANDLER lcl_event_handler=>on_data_changed FOR go_alv.

    "5. # ## ####
    PERFORM display_alv.
  ELSE.
    " 3-2. ## ###### refresh#
    PERFORM set_item_number. " 3-1. # ## ## ### ## ##
    go_alv->refresh_table_display( ).
  ENDIF.
  " ##### ### ### ##### #### #### ###
  IF go_cont IS BOUND. " IS INITIAL ## ####, IS ASSIGNED ## ## (## ##)
    go_cont->set_visible( visible = gv_visible ). " gv_visible# 'X'# ###, ' '# ###
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0110 OUTPUT (110# ## Status)
*&---------------------------------------------------------------------*
MODULE status_0110 OUTPUT.
  SET PF-STATUS 'S110'.
  SET TITLEBAR 'T110'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0110 OUTPUT (110# ## ALV ### ##)
*&---------------------------------------------------------------------*
MODULE init_alv_0110 OUTPUT.
  "1. 110# ## Layout# ### ## ## ## (2# alv - custom container)
  IF go_dialog IS INITIAL.
    "2. ## Container# ##### ####, ## ### (, alv ## ##)
    PERFORM create_dialog_object.

    "3. ## ####
    PERFORM set_dialog_layout.
    PERFORM set_dialog_uifunc.
    PERFORM set_fcat_opti CHANGING gt_fcat_opti.

    "5. # ## ####
    PERFORM display_dialog_alv.
  ELSE.
    " 2-2. ## ###### refresh#
    go_alv->refresh_table_display( ).
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0110 OUTPUT (100# ### ## ##)
*&---------------------------------------------------------------------*
MODULE modify_screen_0100 OUTPUT.
  " ### ### ## ### ## ## ##(### #) ### ###
  PERFORM control_header_screen.
ENDMODULE.
