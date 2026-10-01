*&---------------------------------------------------------------------*
*& Include          ZB1MM0002_C01
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
    " # #### #
    on_double_click FOR EVENT double_click
      OF cl_gui_alv_grid IMPORTING e_row e_column es_row_no sender." sender# #### ## alv# ## #### #### # ##
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.

  METHOD on_double_click.
    CLEAR: gs_data.

    IF sender = go_alv.
      " ### # ##
      READ TABLE gt_data INTO gs_data INDEX e_row-index.
      IF sy-subrc = 0.
        gv_ebeln = gs_data-ebeln. " ## ## #### ### ##(#### ## # ##)
        CALL SCREEN '0110' STARTING AT 50 5 ENDING AT 115 20.

        cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'ENTER' ). " PAI ## ###(####)
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
