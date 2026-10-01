*&---------------------------------------------------------------------*
*& Include          MZB1MM0006_C01
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    " alv ## ## ### ## # #### ###
    CLASS-METHODS:
    " # #### #
    on_double_click FOR EVENT double_click
      OF cl_gui_alv_grid IMPORTING e_row e_column es_row_no sender." sender# #### ## alv# ## #### #### # ##
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.

  METHOD on_double_click.
    CLEAR: gs_head, gs_select_head.
    IF e_row-index IS INITIAL OR e_row-index = 0.
      EXIT.
    ENDIF.

    PERFORM handle_double_click USING e_row-index.

    cl_gui_cfw=>set_new_ok_code(
      EXPORTING
        new_code = 'REFRESH' " PAI## 'REFRESH'# # # sy-ucomm# ### #### #### #
    ).
  ENDMETHOD.
ENDCLASS.
