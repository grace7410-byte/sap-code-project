*&---------------------------------------------------------------------*
*& Include          MZB1MM0002C01
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
*      " alv ## ## ### ## # #### ###
*      on_after_user_command FOR EVENT after_user_command OF cl_gui_alv_grid IMPORTING e_ucomm,
      " alv ### #### ####(#### # ##) #### ###
      on_data_changed FOR EVENT data_changed OF cl_gui_alv_grid IMPORTING er_data_changed,
      " ### ## ### ##
      on_hotspot_click FOR EVENT hotspot_click  OF cl_gui_alv_grid IMPORTING e_row_id e_column_id,
      " html ## ## #
      sap_event FOR EVENT sapevent OF cl_gui_html_viewer IMPORTING action, " ## ## ##### ## # ##.
      " ALV ## ## ###
      on_toolbar FOR EVENT toolbar OF cl_gui_alv_grid IMPORTING e_object sender,
      " ## ## ##
      on_user_command FOR EVENT user_command OF cl_gui_alv_grid IMPORTING e_ucomm sender,
      " ## ## ####
      on_finished FOR EVENT finished OF cl_gui_timer.
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.
  METHOD sap_event.
    DATA: lv_link_txt TYPE string,
          lv_answer   TYPE c,
          lv_question TYPE string.

    IF action CS 'LOADTRAN'. " 1# ## ##
      PERFORM display_transport_popup. " ### ###/## #### ## ## ## ##

    ELSEIF action CS 'LOADVOLM'. " #### ####
      IF gv_load_volm = 'X'.
        CALL TRANSACTION 'ZB1MM0006'.
      ELSE.
        MESSAGE i029(zmcb1) WITH gv_ebeln '## #### ###'.
      ENDIF.

    ELSEIF action CS 'LOADGR'.   " ####
      IF gv_load_can = 'X'.
        gv_mode = 'L'. " #### ## ##

        lv_question = |{ gv_ebeln }# ### #### #### ########?|.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            text_question         = lv_question
            text_button_1         = '#'(001)
            icon_button_1         = 'ICON_OKAY'
            text_button_2         = '##'(002)
            icon_button_2         = 'ICON_CANCEL'
            display_cancel_button = ' '
          IMPORTING
            answer                = lv_answer.

        IF lv_answer <> '1'. " Yes# ### #### ###
          CLEAR: lv_question, lv_answer.
        ELSE.
          PERFORM add_selected_data. " ### ####### ## #### ####### ### ###

          cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'REFR' ).
          MESSAGE s103(zmcb1). " ## ### #######
        ENDIF.
      ELSE.
        MESSAGE '## ##### #### ## ## ###' TYPE 'I'.
      ENDIF.

*    ELSEIF action CS 'LOADGR'.   " ####
*      IF gv_load_gr = 'X'.
*        MESSAGE '##' TYPE 'I'.
*      ELSE.
*        MESSAGE i029(zmcb1) WITH gv_ebeln '#### ##'.
*      ENDIF.

    ELSEIF action CS 'PLANTTRAN'. " 2# ##
      IF gv_plant_tran = 'X'.

      ELSE.
        MESSAGE i029(zmcb1) WITH gv_ebeln '### ## ###'.
      ENDIF.

    ELSEIF action CS 'PLANTVOLM'. " #### ####
      IF gv_plant_volm = 'X'.
        lv_question = |{ gv_ebeln }# ### #### ### ########?|.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            text_question         = lv_question
            text_button_1         = '#'(001)
            icon_button_1         = 'ICON_OKAY'
            text_button_2         = '##'(002)
            icon_button_2         = 'ICON_CANCEL'
            display_cancel_button = ' '
          IMPORTING
            answer                = lv_answer.

        IF lv_answer <> '1'. " Yes# ### #### ###
          CLEAR: lv_question, lv_answer.
        ELSE.
          SUBMIT zrb1mm0001 WITH so_doc EQ gv_select_ebeln  " #### PO ## Select-Option ## Parameter #
                            WITH pa_typ EQ 'PO'          " #### #### ## #
                            AND RETURN.
        ENDIF.
      ELSE.
        lv_question = |{ gv_ebeln }# ### #### ### ####. #### ### ########?|.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            text_question         = lv_question
            text_button_1         = '#'(001)
            icon_button_1         = 'ICON_OKAY'
            text_button_2         = '##'(002)
            icon_button_2         = 'ICON_CANCEL'
            display_cancel_button = ' '
          IMPORTING
            answer                = lv_answer.

        IF lv_answer <> '1'. " Yes# ### #### ###
          CLEAR: lv_question, lv_answer.
        ELSE.
          CALL TRANSACTION 'ZB1MM0006'.
        ENDIF.
      ENDIF.
      IF gv_select_ebeln IS NOT INITIAL.
        " 1. ## ##### ### #### ### #### ## DB ###
        PERFORM get_process_data USING gv_select_ebeln.

        " 2. Process Flow ## # ## #### #### ## REFR ## ## ##
        cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'REFR' ).
      ENDIF.

    ELSEIF action CS 'PLANTGR'.   " ####
      IF gv_plant_can = 'X'.
        gv_mode = 'P'. " #### ## ##

        lv_question = |{ gv_ebeln }# ### #### #### ########?|.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            text_question         = lv_question
            text_button_1         = '#'(001)
            icon_button_1         = 'ICON_OKAY'
            text_button_2         = '##'(002)
            icon_button_2         = 'ICON_CANCEL'
            display_cancel_button = ' '
          IMPORTING
            answer                = lv_answer.

        IF lv_answer <> '1'. " Yes# ### #### ###
          CLEAR: lv_question, lv_answer.
        ELSE.
          PERFORM add_selected_data. " ### ####### ## #### ####### ### ###

          cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'REFR' ).
          MESSAGE s103(zmcb1). " ## ### #######
        ENDIF.
      ELSE.
        MESSAGE '## ##### #### ## ## ###' TYPE 'I'.
      ENDIF.

*    ELSEIF action CS 'PLANTGR'.   " ####
*      IF gv_plant_gr = 'X'.
*
*      ELSE.
*        MESSAGE i029(zmcb1) WITH gv_ebeln '#### ##'.
*      ENDIF.
    ELSEIF action CS 'INVOICE'.
      IF gv_inv_can = 'X'.
        SET PARAMETER ID 'BES' FIELD gv_ebeln. " #### ### ## PARAMETER ID ##

        CALL TRANSACTION 'ZB1MM0003'.

        IF gv_ebeln IS NOT INITIAL.
          PERFORM get_process_data USING gv_ebeln.

          " ### # #### ### ### ## REFR OK_CODE ##
          cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'REFR' ).
        ENDIF.
      ENDIF.

    ENDIF.

*    IF gv_dynnr IS NOT INITIAL. " #### #### ### ### ###### ## ####
*      cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'REFR' ).
*    ENDIF.

*    " PERFORM display_process_flow.
*
*    IF lv_link_txt IS NOT INITIAL.
*      MESSAGE s023(zmcb1) WITH lv_link_txt. " ## ### #######
*    ENDIF.
  ENDMETHOD.

  METHOD on_toolbar.
    DATA: ls_button TYPE stb_button.
    IF sender = go_alv_101 OR sender = go_alv_pohd.
*      ls_button-butn_type = 3. " ### ##
*      APPEND ls_button TO e_object->mt_toolbar.
*
*      CLEAR ls_button.
*      ls_button-function  = 'BT_PROC'.       " ####
*      ls_button-icon      = ICON_DRAW_SELECT. " ICON_GIS_PAN " icon_execute_object. " ###
*      ls_button-quickinfo = '#### ### ##'.   " ##
*      ls_button-text      = '##'.       " ## ###
*      ls_button-disabled  = ' '.             " ### ##
**    ls_button-
*      APPEND ls_button TO e_object->mt_toolbar.
    ELSEIF sender = go_alv.

      CLEAR ls_button.
      ls_button-function  = 'BT_INS_ROW'.
      ls_button-icon      = icon_insert_row.     " # ## ###
      ls_button-text      = '##'.       " ## ###
      ls_button-quickinfo = '## # ##'.
      ls_button-disabled  = ' '.
      APPEND ls_button TO e_object->mt_toolbar.

      CLEAR ls_button.
      ls_button-function  = 'BT_DEL_ROW'.
      ls_button-icon      = icon_delete_row. " # ## #### ##
      ls_button-text      = '##'.       " ## ###
      ls_button-quickinfo = '## # ##'.
      ls_button-disabled  = ' '. " ###
      APPEND ls_button TO e_object->mt_toolbar.

    ENDIF.
  ENDMETHOD.

  METHOD on_user_command.
    DATA: lt_rows TYPE lvc_t_row,
          ls_row  TYPE lvc_s_row.
    DATA: ls_stable TYPE lvc_s_stbl.

    CASE e_ucomm.
      WHEN 'BT_PROC'.
        sender->check_changed_data( ). " ### ## ## alv ### 101## pohd## #### # ## ## ##

        DATA(lv_change) = abap_true.
        LOOP AT gt_item TRANSPORTING NO FIELDS WHERE matnr IS NOT INITIAL.
          lv_change = abap_false. " #### #### ### (### ###) #### ## ##
          EXIT.
        ENDLOOP.
        IF lv_change = abap_false.
          MESSAGE s122(zmcb1) WITH '####' '####' DISPLAY LIKE 'E'. " #### #### ### ## #### ### #####
          RETURN.
        ENDIF.
        sender->get_selected_rows( IMPORTING et_index_rows = lt_rows ).

        IF lt_rows[] IS INITIAL. " ## ### ## ###
          MESSAGE s033(zmcb1) WITH '####' '# ' DISPLAY LIKE 'E'. " '#### # ## #####'
          RETURN.
        ELSEIF lines( lt_rows ) > 1.
          MESSAGE s034(zmcb1) WITH '# ' DISPLAY LIKE 'E'. " # ## ## #####
          RETURN.
        ENDIF.

        READ TABLE lt_rows INTO ls_row INDEX 1. " # ## ### ###### ## #### ### ##
        CHECK sy-subrc = 0.

        " ## ### ##### ## #### #### ## ##
        READ TABLE gt_pohd ASSIGNING FIELD-SYMBOL(<fs_pohd>) INDEX ls_row-index.
        CHECK sy-subrc = 0.

        gv_ebeln = <fs_pohd>-ebeln.
        gv_select_ebeln = <fs_pohd>-ebeln.

        "  ## # ### ###, ### ## ###
        LOOP AT gt_pohd ASSIGNING FIELD-SYMBOL(<fs_all>).
          IF <fs_all>-ebeln = gv_ebeln.
            <fs_all>-col_fld = 'C100'. " ### # ##
          ELSE.
            CLEAR <fs_all>-col_fld.    " ### # ## ##
          ENDIF.
        ENDLOOP.

        " ALV ####
        IF sender = go_alv_101.
          PERFORM refresh_alv USING gs_stable CHANGING go_alv_101.
        ELSEIF sender = go_alv_pohd.
          PERFORM refresh_alv USING gs_stable CHANGING go_alv_pohd.
        ENDIF.

        " #### ### ####
        PERFORM get_process_data USING gv_ebeln.
        MESSAGE s035(zmcb1) WITH gv_ebeln '#'. " # #######

        IF gt_head[] IS NOT INITIAL.
          " ####### ###
          CLEAR: gv_txt101. " #### ##
          gv_dynnr = '0110'. " ##### ######
        ELSE.
          " ### ## 101# (## #### ####)
          gv_dynnr = '0101'.
          gv_txt101 = '## ##### ####### #### ####.'.
        ENDIF.
        cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'ENTER' ).

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
        PERFORM set_item_number.

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
          sender->refresh_table_display( EXPORTING is_stable = ls_stable  EXCEPTIONS OTHERS  = 2 ).
        ENDIF.
    ENDCASE.
  ENDMETHOD.

*  METHOD on_after_user_command.
*    " ## ## ## #, ALV# ## ### itab# ## ##### ### ## ###
*    go_alv->check_changed_data( ).
*
*    CASE e_ucomm.
*      WHEN cl_gui_alv_grid=>mc_fc_loc_insert_row OR " # ##
*           cl_gui_alv_grid=>mc_fc_loc_copy_row OR  " # ##
*          cl_gui_alv_grid=>mc_fc_loc_delete_row.
*
*        PERFORM set_item_number.
*        PERFORM refresh_alv CHANGING gs_stable go_alv.
*    ENDCASE.
*  ENDMETHOD. " #### ####### ##### ### ### ### ON_DATA_CHANGED# ##

  METHOD on_data_changed.
*    ## ##### ###### ##### ##### 10, 20, ... ## ##### ##
    IF er_data_changed->mt_inserted_rows IS NOT INITIAL OR " ### ## ###
     er_data_changed->mt_deleted_rows  IS NOT INITIAL. " ### ## ###

      PERFORM set_item_number. " ## # ## #####
      PERFORM refresh_alv CHANGING gs_stable go_alv. "gs_stable # col, row #### refresh_table_display() ##
    ENDIF.

    " PERFORM handle_data_changed USING er_data_changed.
  ENDMETHOD.

  METHOD on_hotspot_click. " #### ALV## ##### ### #### ## ## ###
    " 1. ## ### #### -  ##### ##
    CHECK e_column_id-fieldname = 'ZEBELNSV'.
    " 2. ## ### ## ### ##
    DATA: ls_tran   LIKE LINE OF gt_tran,
          lv_ref_po TYPE ebeln.
  ENDMETHOD.

  "[130#] ## ## ## # ## (##)
  METHOD on_finished.
    " ### #### ## ## ### ## -> ### #### ## ## ## X,  ### ##.
*    CALL SCREEN '0130' STARTING AT 50 5 ENDING AT 122 22.
  ENDMETHOD.

ENDCLASS.
