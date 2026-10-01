*&---------------------------------------------------------------------*
*& Include          ZB1MM0002_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA(lv_ok_code) = ok_code. " #### ### ### ## ### ####,
  CLEAR ok_code. " ## ### ##### ## # ## ### #### # ####.

  CASE lv_ok_code.
    WHEN 'BACK'. " #### ## ## # ## #### ##
      LEAVE TO SCREEN 0.
    WHEN 'CREATE_PO'.
      DATA: gv_title  TYPE char20,
            gv_text   TYPE string,
            gv_answer TYPE c.

      gv_title = '#### #### ##'.
      gv_text = | #### ## ###### ########? |.

      PERFORM pop_up_message USING gv_title gv_text CHANGING gv_answer.
      IF gv_answer = '1'.
        CALL TRANSACTION 'ZB1MM0004'. " #### ###### ##
        SUBMIT zrb1mm0002.
      ENDIF.
    WHEN 'ERASE_PO'.
      IF gv_ebeln IS NOT INITIAL.
        gv_mode = 'U'. " ## ##
        EXPORT gv_mode = gv_mode TO MEMORY ID 'MODE_CHECK'.
        EXPORT gv_ebeln = gv_ebeln  TO MEMORY ID 'ZAPPR_DATA'.
        CALL TRANSACTION 'ZB1MM0004'.

        PERFORM get_data. " ## ## #### #### PAI ### ###### ##
        LEAVE TO SCREEN 0. " ## ######
      ENDIF.
    WHEN 'DELETE_PO'.
      IF gv_ebeln IS NOT INITIAL.
        gv_mode = 'D'. " ## ##
        EXPORT gv_mode = gv_mode TO MEMORY ID 'MODE_CHECK'.
        EXPORT gv_ebeln = gv_ebeln  TO MEMORY ID 'ZAPPR_DATA'.
        CALL TRANSACTION 'ZB1MM0004'.

        PERFORM get_data.
        LEAVE TO SCREEN 0. " ## ##
      ENDIF.

    WHEN 'APPROVAL'.
      IF gs_data-zappst IS INITIAL OR gs_data-zapper IS INITIAL OR gs_data-zappdat IS INITIAL.
        MESSAGE '####, ###, ##### ## ## #####.' TYPE 'E'.
      ENDIF.

      " ##(3)# # ####(ZMEMO) ## ##
      IF gs_data-zappst = '3' AND gs_data-zmemo IS INITIAL.
        MESSAGE '### ## ####(ZMEMO)# #### ###.' TYPE 'E'.
      ENDIF.

      " [#### ## ##] DB #### ##
      PERFORM process_approval_data.

      IF sy-subrc = 0.
        MESSAGE '## ### #######.' TYPE 'S'.
        LEAVE TO SCREEN 0. " ## ## #### ##
      ENDIF.

    WHEN 'SERVICE'.
      CLEAR: gv_title, gv_text, gv_answer.

      SELECT SINGLE zebelnsv
        FROM ztb1mm0006 INTO @DATA(lv_service).

      IF sy-subrc <> 0.
        MESSAGE s022(zmcb1) WITH '### ##' DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.

      gv_title = '### ## #### ##'.
      IF gs_data-ebeln IS NOT INITIAL.
        gv_text = | #### [{ gs_data-ebeln }]## #######. |
      && | ### ### PO ## #### ########? |.
      ELSE.
        gv_text = | ### PO ## #### ########? |.
      ENDIF.

      PERFORM pop_up_message USING gv_title gv_text CHANGING gv_answer.
      IF gv_answer = '1'.
        SET PARAMETER ID 'BES' FIELD lv_service.
        CALL TRANSACTION 'ZB1MM0001'.
        " #### ## ###
        SUBMIT zrb1mm0002.
      ENDIF.

    WHEN OTHERS.
  ENDCASE.
  CLEAR lv_ok_code.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'CANCEL'. " ## #
      LEAVE TO SCREEN 0. " ####
    WHEN 'EXIT'. " ## #
      LEAVE PROGRAM.    " ##### #### SAP ## #### ##
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
