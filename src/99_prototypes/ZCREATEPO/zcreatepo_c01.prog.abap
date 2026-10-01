*&---------------------------------------------------------------------*
*& Include          ZRB1MM0001_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    " alv ## ## ### ## # #### ###
    CLASS-METHODS:
    on_after_user_command FOR EVENT after_user_command
      OF cl_gui_alv_grid IMPORTING e_ucomm,
    " alv ### #### ####(#### # ##) #### ###
     on_data_changed FOR EVENT data_changed
      OF cl_gui_alv_grid IMPORTING er_data_changed.
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_after_user_command.
    " ## ## ## #, ALV# ## ### itab# ## ##### ### ## ###
    go_alv->check_changed_data( ).

    CASE e_ucomm.
      WHEN cl_gui_alv_grid=>mc_fc_loc_append_row OR " # ##
           cl_gui_alv_grid=>mc_fc_loc_insert_row OR " # ##
           cl_gui_alv_grid=>mc_fc_loc_delete_row OR " # ##
           cl_gui_alv_grid=>mc_fc_loc_copy_row.     " # ##

        PERFORM set_item_number. " ## # ## #####
        PERFORM refresh_alv. "gs_stable # col, row #### refresh_table_display() ##
    ENDCASE.
  ENDMETHOD.

  METHOD on_data_changed.
*   ### ###: ####, ###, ####, ####, ## ###
*   ### #:
*   (1) ####-##-#### #### ##### ## ## ### ### # ##(## #### ### # ### ##)
*   (2) ### ## ## #, #### ## ## ##### ###(##### ###### ###. ### ###### ###)
*   (3) #### ## #, # ## ## ## ##
*   (4) ## ### ## #, ## ### ## ## (##### #### ##)
*   (5, ALV ##) ### #### ### ### #### '####' #### #(##### ## ## #### #) ### ### ### ## ### ## ##.
    " ## #### ## ###
    PERFORM handle_data_changed USING er_data_changed.
  ENDMETHOD.
ENDCLASS.
