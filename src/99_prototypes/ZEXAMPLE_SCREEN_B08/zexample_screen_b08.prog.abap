*&---------------------------------------------------------------------*
*& Report ZEXAMPLE_SCREEN_B08
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEXAMPLE_SCREEN_B08.

DATA: ok_code         TYPE sy-ucomm.

START-OF-SELECTION.
  CALL SCREEN 100.

*----------------------------------------------------------------------*
* PBO (### ## #)
*----------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
 SET PF-STATUS 'S100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
ENDCASE.
ENDMODULE.

MODULE exit INPUT.
  CASE OK_CODE.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
