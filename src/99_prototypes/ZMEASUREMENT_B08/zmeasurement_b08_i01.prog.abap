*&---------------------------------------------------------------------*
*& Include          MZB1MM0003I01
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA(lv_ok_code) = ok_code. " #### ### ### ## ### ####,
  CLEAR ok_code. " ## ### ##### ## # ## ### #### # ####.

  CASE lv_ok_code.
    WHEN 'BACK'. " #### ## ## # ## #### ##
      LEAVE PROGRAM.
      when 'BACK_TEST'.
        leave to transaction 'ZRB1MM0001_1'.
    WHEN 'GO_CREATE'.
      LEAVE TO SCREEN '0200'. " CALL SCREEN ## ## # ## ##
  ENDCASE.
  CLEAR lv_ok_code.
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
*&      Module  USER_COMMAND_0200  INPUT
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  DATA(lv_okcode) = ok_code. " #### ### ### ## ### ####,
  CLEAR ok_code. " ## ### ##### ## # ## ### #### # ####.

  CASE lv_okcode.
    WHEN 'BACK' OR 'GO_DISPLAY'.
      " 100### ##### ### ##
      gv_back = 'X'. " # ### ### #.

      " ###### #### #### # #### ####
      CLEAR gv_ebeln.
      SET PARAMETER ID 'BES' FIELD ''.

      " 100### ##
      LEAVE TO SCREEN '0100'.
    WHEN 'SEARCH_ZDOCNO'.

    WHEN 'ZDOCNO_OVERVIEW'.
      IF gs_volm-process = 'SO'. " ###### ##### ### ##
        PERFORM get_sd_data_all.
        go_alv_item->refresh_table_display( ).
      ELSEIF gs_volm-process = 'PO'.
        " PERFORM get_mm_data_all. (## ##)
      ENDIF.
  ENDCASE.
  CLEAR lv_okcode.
ENDMODULE.
