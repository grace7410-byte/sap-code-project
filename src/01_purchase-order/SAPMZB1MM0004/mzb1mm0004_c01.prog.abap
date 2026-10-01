*&---------------------------------------------------------------------*
*& Include          MZB1MM0004_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
    " ## ## ## #### # (## ####)
*    on_after_user_command FOR EVENT after_user_command
*      OF cl_gui_alv_grid IMPORTING e_ucomm,
      " ## ## ALV ## ## ###
      on_toolbar FOR EVENT toolbar OF cl_gui_alv_grid IMPORTING e_object sender,
      " ## ## ##
      on_user_command FOR EVENT user_command OF cl_gui_alv_grid IMPORTING e_ucomm sender,

    " alv ### #### ####(#### # ##) #### ###
     on_data_changed FOR EVENT data_changed
      OF cl_gui_alv_grid IMPORTING er_data_changed,
     on_finished FOR EVENT finished OF cl_gui_timer,
         " ### ## ### ##
    on_hotspot_click FOR EVENT hotspot_click
      OF cl_gui_alv_grid IMPORTING e_row_id e_column_id,
    " # #### #
    on_double_click FOR EVENT double_click
      OF cl_gui_alv_grid IMPORTING e_row e_column es_row_no sender." sender# #### ## alv# ## #### #### # ##
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.
*  METHOD on_after_user_command.
*    " ## ## ## #, ALV# ## ### itab# ## ##### ### ## ###
*    go_alv->check_changed_data( ).
*      CASE e_ucomm.
*          WHEN cl_gui_alv_grid=>mc_fc_loc_append_row OR " # ##
*               cl_gui_alv_grid=>mc_fc_loc_insert_row OR " # ##
*               cl_gui_alv_grid=>mc_fc_loc_delete_row OR " # ##
*               cl_gui_alv_grid=>mc_fc_loc_copy_row.     " # ##
*
*            PERFORM set_item_number. " ## # ## ####4#
*            PERFORM refresh_alv USING gs_stable CHANGING go_alv. "gs_stable # col, row #### refresh_table_display() ##
*      ENDCASE.
*  ENDMETHOD. " => ## ## ## ## ## ### #### ## ## #

  METHOD on_toolbar.
    DATA: ls_button TYPE stb_button.
    IF sender = go_alv.
      CLEAR ls_button.
      ls_button-function  = 'BT_INS_ROW'.
      ls_button-text = '##'.
      ls_button-icon      = icon_insert_row.     " # ## ###
      ls_button-quickinfo = '# ##'.
      ls_button-disabled  = ' '.
      APPEND ls_button TO e_object->mt_toolbar.

      CLEAR ls_button.
      ls_button-function  = 'BT_DEL_ROW'.
      ls_button-text = '##'.
      ls_button-icon      = icon_delete_row. " # ## #### ##
      ls_button-quickinfo = '## # ##'.
      ls_button-disabled  = ' '. " ###
      APPEND ls_button TO e_object->mt_toolbar.

    ELSEIF sender = go_alv_pohd.
      CLEAR ls_button.
      ls_button-function  = 'BT_DEL_ROW'.
      ls_button-text = '## ##'.
      ls_button-icon      = icon_delete_row. " # ## #### ##
      ls_button-quickinfo = '## # ##'.
      ls_button-disabled  = ' '. " ###
      APPEND ls_button TO e_object->mt_toolbar.

    ELSE.
      CLEAR ls_button.
      IF sender = go_alv_pop.
        ls_button-function = 'ADD_OPTI'. " 110# ALV #### #### #
      ELSEIF sender = go_alv_all.
        ls_button-function ='ADD_BOM'. " 130# ALV #### #### #
      ENDIF.
      ls_button-text = |   #### ## ##   |.
      ls_button-icon = ICON_ADD_SHOPPINGCART.
      ls_button-quickinfo = '## ## #### #### ##'.
      ls_button-disabled = ' '. "###
      APPEND ls_button TO e_object->mt_toolbar.
    ENDIF.
  ENDMETHOD.

  METHOD on_user_command.
    DATA: lt_rows TYPE lvc_t_row,
          ls_row  TYPE lvc_s_row.
    DATA: ls_stable TYPE lvc_s_stbl.

    CASE e_ucomm.
      WHEN 'BT_INS_ROW'.
        sender->get_selected_rows( IMPORTING et_index_rows = lt_rows ).

        READ TABLE lt_rows INTO ls_row INDEX 1.
        IF sy-subrc = 0.
          " ### # ### ### # ## ### ##,
          " ## ## ### #### '## #(#)'# ### ### ###.
          INSERT INITIAL LINE INTO gt_item INDEX ls_row-index ASSIGNING FIELD-SYMBOL(<fs_new>).
        ELSE.
          " ## ## #### ## ### # ## ##
          APPEND INITIAL LINE TO gt_item ASSIGNING <fs_new>.
        ENDIF.
        PERFORM set_item_number. " ## ## ####

        IF sender IS BOUND.
          ls_stable-row = abap_true.
          ls_stable-col = abap_true.

          sender->refresh_table_display( EXPORTING is_stable = ls_stable EXCEPTIONS OTHERS   =  2 ).
        ENDIF.

      WHEN 'BT_DEL_ROW'.
        sender->get_selected_rows( IMPORTING et_index_rows = lt_rows ).

        IF lt_rows[] IS INITIAL.
          MESSAGE s033(zmcb1) WITH '### ##' '# ' DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

        SORT lt_rows BY index DESCENDING.

        LOOP AT lt_rows INTO ls_row.
          DELETE gt_item INDEX ls_row-index. " ## ### #### ##
        ENDLOOP.

        PERFORM set_item_number.

        IF sender IS BOUND.
          ls_stable-row = abap_true.
          ls_stable-col = abap_true.

          sender->refresh_table_display( EXPORTING is_stable = ls_stable EXCEPTIONS OTHERS   =  2 ).
        ENDIF.

      WHEN 'ADD_OPTI'. " 110# ALV #### #### #### ## ## ## ## #
        PERFORM add_selected_data USING 'O' CHANGING go_alv_pop gt_opti. " ### #### ## 100# ALV(###)# ##

      WHEN 'ADD_BOM'. " 130# ALV #### #### #### ## ## ## ## #
        PERFORM add_selected_data USING '' CHANGING go_alv_all gt_bom_all. " ### #### ## 100# ALV(###)# ##

    ENDCASE.
  ENDMETHOD.

  " [100#] item ALV ### ## # ##
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

  "[120#] ## ## ## # ## (##)
  METHOD on_finished.
    " ### #### ## ## ### ##
    CALL SCREEN '0120' STARTING AT 50 5 ENDING AT 115 20.
  ENDMETHOD.

  "[100# - 101# ##] vendor ALV## ### #### #### ## ###
  METHOD on_hotspot_click.
    " 1. ## ### #### - #### ### ### ##### ##
    CHECK e_column_id-fieldname = 'BPID' OR  e_column_id-fieldname = 'BPNM' .

    " 2. ### ## ### ## vend ### ##
    READ TABLE gt_vend INTO DATA(ls_selected_vend) INDEX e_row_id-index.
    IF sy-subrc = 0.
      " 3. #### ## ## ## - pv_pop = 'X' ##
      PERFORM get_vendor_data USING 'X' ls_selected_vend-bpid.
      " 4. gs_vend# #### ### ####(## ##) ## ###
      IF gs_vend-bpid IS NOT INITIAL.
        CALL SCREEN '0103' STARTING AT 50 5
                           ENDING   AT 135 25.
      ENDIF.
      IF gs_head-bpid = gs_vend-bpid. " #### ## ## ### PAI # # ## ## ##
        cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'ENTER' ). " ## ## ## ## ##
      ENDIF.
    ENDIF.
  ENDMETHOD.

  "[300#] po ## ## ALV## #### # #### #####(## ##, ## ####)
  METHOD on_double_click.
    DATA: ls_data   LIKE LINE OF gt_pohd, " ## #### ###
          lv_answer TYPE c.

    IF sender = go_alv_pohd.
      " ### # ##
      READ TABLE gt_pohd INTO ls_data INDEX e_row-index.
      IF sy-subrc <> 0. RETURN. ENDIF.
      " ## ##### ###, ### ##### ## #### ## ####(##)
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = '## ## ## ##'
          text_question         = |## #### { gv_ebeln }## #### ####. | &
                                  |#### { ls_data-ebeln }### ########?|
          text_button_1         = '#'
          text_button_2         = '###'
          display_cancel_button = ' ' " ## '###' ### #### ## ## ##
        IMPORTING
          answer                = lv_answer.

      " okok ## -> #### ## #####
      IF lv_answer = '1'.
        CLEAR: gv_ebeln, gs_head, gt_item. "10### ##### ## ### ##
        gv_ebeln = ls_data-ebeln.

        PERFORM set_init_item_rows. " new line ### ### ###
        PERFORM get_edit_data. " ### gv_ebeln## ### ## ####

        " PAI ## ## #### ####
        cl_gui_cfw=>set_new_ok_code(
          EXPORTING
            new_code = 'REFR'
        ).
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
