*&---------------------------------------------------------------------*
*& Include          ZB1MM0002_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0110 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0110 OUTPUT.

  IF gs_data-zapper IS INITIAL AND gs_data-zappst = '1'.
    gs_data-zapper = sy-uname.
    gs_data-zappdat = sy-datum.
    gs_data-zapptim = sy-uzeit.
  ENDIF.

  " 1) ZAPPST# '1'(##)# ## ### ###
  LOOP AT SCREEN.
    IF screen-group1 = 'G1'.
      IF gs_data-zappst = '1'.
        screen-input = 1. " ###
      ELSE.
        screen-input = 0. " ####(### ##)
      ENDIF.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

  IF gs_data-zappst = '1'.
    SET PF-STATUS 'S110'.
  ELSE.
    SET PF-STATUS 'S110' EXCLUDING 'APPROVAL'.
  ENDIF.
  SET TITLEBAR 'T110'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV OUTPUT (100# ### ALV ### ##)
*&---------------------------------------------------------------------*
MODULE init_alv OUTPUT.
  "2. 100# ### Layout# Area ## (1# alv - ## ####)
  IF go_dock IS INITIAL.
    "3. ## Container# ##### ####, ## ### (cont, alv ## ##)
    PERFORM create_object_dock CHANGING go_dock go_alv.

    "4. ## #### #### ## ## (pv_type = 1)
    PERFORM set_layout USING 1 CHANGING gs_layout.
    PERFORM set_uifunc USING 1 CHANGING gt_uifunc.
    PERFORM set_fcat_appr CHANGING gt_fcat_appr.
    " ### ### ##
    SET HANDLER lcl_event_handler=>on_double_click FOR go_alv.
    " SET HANDLER lcl_event_handler=>on_after_user_command FOR go_alv.
    " SET HANDLER lcl_event_handler=>on_data_changed FOR go_alv.

    "5. # ## ####
    PERFORM display_alv USING gs_layout gt_uifunc gt_fcat_appr
                        CHANGING go_alv gt_data.
  ELSE.
    " 3-2. ## ###### refresh# -> ### ### ## #### ### #### ######
    " ### ##### ### ### #### ##.
    PERFORM get_data.

    PERFORM refresh_alv CHANGING gs_stable go_alv.
    " go_alv->refresh_table_display( ).
  ENDIF.

  " ##### ### ### ##### #### #### ###
*  IF go_cont IS BOUND. " IS INITIAL ## ####, IS ASSIGNED ## ## (## ##)
*    go_cont->set_visible( visible = gv_visible ). " gv_visible# 'X'# ###, ' '# ###
*  ENDIF.
ENDMODULE.
