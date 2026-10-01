*&---------------------------------------------------------------------*
*& Include          MZB1MM0002I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  " (##) ### # #### #### ##: OK_CODE ## ##)
  DATA(lv_ok_code) = ok_code. " #### ### ### ## ### ####,
  CLEAR ok_code. " ## ### ##### ## # ## ### #### # ####.

  CASE lv_ok_code.
    WHEN 'BACK'. " #### ## ## # ## #### ##
      LEAVE TO SCREEN 0.

    WHEN 'ITEM_OVERVIEW'.
      IF gv_visible = 'X'. " X# ##(## ALV ### #### ###) ## ###
        gv_visible = ' '.
      ELSE.
        gv_visible = 'X'. " ## ALV# visible## ###
      ENDIF.

    WHEN 'CHECK'. " ### ### ## # ## ## ## ### #
      DATA: lv_subrc TYPE sysubrc. " ## ## ### ## ### ##
      PERFORM check_data_before_save CHANGING lv_subrc.
      IF lv_subrc = 0.
        MESSAGE s021(zmcb1). " ### #######
      ENDIF.
      CLEAR lv_subrc.

    WHEN 'SAVE'. " ## ## ## #
      PERFORM check_data_before_save CHANGING lv_subrc.
      CHECK lv_subrc = 0. " ### ### ### ##

      " ##### # # # ####
      CLEAR gv_answer.
      PERFORM confirm_save CHANGING gv_answer. " POPUP_TO_CONFIRM ##
      CHECK gv_answer = 'J'.

      PERFORM save_gr_data.

*    WHEN 'REFR'.
*      gv_ebeln = gs_pohd-ebeln.
    WHEN 'INFO'.
      gv_manual = 'X'. " #### ##### ##
      CALL SCREEN '0130' STARTING AT 50 5 ENDING AT 125 25.
      CLEAR: gv_manual. " ### ## ### ## ### ###

    WHEN OTHERS. " ## # # # ### #### #
*      gv_select_ebeln = gv_ebeln. " ## ####### #### ###
*      PERFORM get_process_data USING gv_ebeln.
*
*      IF gt_head[] IS NOT INITIAL. " ### check_eblen ### ##
*        " ####### ###
*        CLEAR: gv_txt101. " #### ##
*        gv_dynnr = '0110'. " ##### ######
*      ELSE.
*        " ### ## 101# (## #### ####)
*        gv_dynnr = '0101'.
*        gv_txt101 = '## ##### ####### #### ####.'.
*      ENDIF.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'CANCEL' OR 'EXIT'. " ### ## #
      LEAVE PROGRAM.         " ##### #### SAP ## #### ##
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_EBELN_STATUS  INPUT
*&---------------------------------------------------------------------*
MODULE check_ebeln_status INPUT.
  " ## ###, ## ## #### ## # #
  IF gv_ebeln IS INITIAL OR gv_ebeln = gv_select_ebeln.
    RETURN.
  ENDIF.

  gv_select_ebeln = gv_ebeln. " ## ####### #### ###

  " ### ## ##. -> ## #### ### ##### ## ##### ### 'CR'# ##(## ## ## ##)
  " PERFORM check_po_status USING gs_pohd-ebeln.

  " ### ##### #### ##, ### #### #### ## ## #### Flow# ###
  PERFORM get_process_data USING gv_ebeln.

  IF gt_head[] IS NOT INITIAL.
    " ####### ###
    CLEAR: gv_txt101. " #### ##
    gv_dynnr = '0110'. " ##### ######
  ELSE.
    " ### ## 101# (## #### ####)
    gv_dynnr = '0101'.
    gv_txt101 = '## ##### ####### #### ####.'.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0130  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0130 INPUT.
  CASE ok_code.
    WHEN 'BACK'. " #### ## ## # ## #### ##
      DATA: ls_check TYPE ztcheck_b08.
      IF gv_check = 'X'.
        ls_check-uname    = sy-uname. " ### ##
        ls_check-progname = sy-repid. " ##### = #######
        ls_check-zdate    = sy-datum. " ## ##
        " #### ## ## ### ### = ### #### #
        MODIFY ztcheck_b08 FROM ls_check. " ### Insert, ### Update
        IF sy-subrc = 0.
          COMMIT WORK.
        ELSE.
          ROLLBACK WORK.
          MESSAGE s006(zmcb1) DISPLAY LIKE 'E' WITH '<# # ## ##> ## ##'.
        ENDIF.
      ENDIF. " ##### #### ## ##
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
