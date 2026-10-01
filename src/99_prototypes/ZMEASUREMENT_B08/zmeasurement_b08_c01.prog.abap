*&---------------------------------------------------------------------*
*& Include          MZB1MM0003C01
*&------------------------------------------------------------------
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
    " alv ## ## ### ## # #### ###
    on_double_click FOR EVENT double_click
      OF cl_gui_alv_grid IMPORTING e_row e_column es_row_no sender." sender# #### ## alv# ## #### #### # ##
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_double_click.
    " 1. 200# ALV(###)## ##### ##
    IF sender = go_alv_item.
      " 2. ## # #### ##### ### #### ### ####### ##### ## ####
      " e_row-rowtype# ### ### ## ## + ### ## ### ####(index# 0## ## ##)
      IF e_row-index > 0 OR e_row-rowtype IS NOT INITIAL.
        EXIT.
      ENDIF.
      " 3. ## #### ### ##
      READ TABLE gt_item INTO gs_item INDEX e_row-index.
      IF sy-subrc = 0. " ### ###(##, ##, ##### ## ##)# #### ##, ## ## ##(#####)
        PERFORM set_selected_data USING gs_item.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
