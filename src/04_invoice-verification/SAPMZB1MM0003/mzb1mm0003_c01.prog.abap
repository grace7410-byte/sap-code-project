*&---------------------------------------------------------------------*
*& Include          MZB1MM0003_C01
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
*      " ALV ## ## ###
*      on_toolbar FOR EVENT toolbar OF cl_gui_alv_grid IMPORTING e_object,
*
*      " ## ## ##
*      on_user_command FOR EVENT user_command OF cl_gui_alv_grid IMPORTING e_ucomm sender,
*
*      on_close FOR EVENT close OF cl_gui_dialogbox_container IMPORTING sender,

      " ## ## ####
      on_finished FOR EVENT finished OF cl_gui_timer.

ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.
**********************************************************************
* 3# METHOD ## ####(## Dialog ALV# => #### ## # ## ALV# #### ## X
**********************************************************************
*  METHOD on_toolbar.
*    DATA: ls_button TYPE stb_button.
*
*    ls_button-butn_type = 3. " ### ##
*    APPEND ls_button TO e_object->mt_toolbar.
*
*    IF gv_dynnr <> '0102'.
*      CLEAR ls_button.
*      ls_button-function  = 'SELECT_PO'.       " ####
*      " ls_button-icon      = icon_execute_object. " ###
*      ls_button-quickinfo = '### #### ##'.   " ##
*      ls_button-text      = '#### ##'.       " ## ###
*      ls_button-disabled  = ' '.             " ### ##
**    ls_button-
*      APPEND ls_button TO e_object->mt_toolbar.
*    ENDIF.
*  ENDMETHOD.
*  METHOD on_close.
*    sender->free( ).
*    CLEAR go_cont_pohd.
*
*    cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'ENTER' ).
*  ENDMETHOD.
*
*  METHOD on_user_command.
*    " ## ## -> # USER_COMMAND# 100# ## 'PO_SELECT' #### ##
*  ENDMETHOD.
**********************************************************************

  "[120#] ## ## ## # ## (##)
  METHOD on_finished.
    " ### #### ## ## ### ##
    CALL SCREEN '0120' STARTING AT 50 5 ENDING AT 125 25.
  ENDMETHOD.
ENDCLASS.
