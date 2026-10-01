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
      CLEAR lv_subrc.

    WHEN 'SAVE'. " ## ## ## #
      PERFORM check_data_before_save CHANGING lv_subrc.
      CHECK lv_subrc = 0. " ### ### ### ##

      " ##### # # # ####
      IF gv_answer <> 'J'. " 'Yes'# ### ##
        " PERFORM confirm_save CHANGING gv_answer. " POPUP_TO_CONFIRM ##
        CHECK gv_answer = 'J'.
      ENDIF.
      " ## ## ##
      "PERFORM save_po_data.

    WHEN OTHERS. " ## # # # ### #### #

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
  CHECK gs_pohd-ebeln IS NOT INITIAL. " ## ### ### ## ##

  " ### ## ##. -> ## #### ### ##### ## ##### ### 'CR'# ##(## ## ## ##)
  PERFORM check_po_status USING gs_pohd-ebeln.
ENDMODULE.
