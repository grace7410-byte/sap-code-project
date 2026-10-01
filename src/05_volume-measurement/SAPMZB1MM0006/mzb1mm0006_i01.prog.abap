*&---------------------------------------------------------------------*
*& Include          MZB1MM0006_I01
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

MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

    WHEN 'CAL_VCF'.
      gs_select_head = gs_head. " ### ### # #### ###
      CLEAR: gs_head.

      IF gs_select_head-zdens IS INITIAL OR gs_select_head-zdens = 0.
        MESSAGE s000(zmcb1) WITH ': ### #####.' DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.

      IF gs_select_head-ztemp IS INITIAL.
        MESSAGE s000(zmcb1) WITH ': ### #####.' DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.

      DATA: lv_rounded_temp TYPE ztb1mm0020-ztemp.

      lv_rounded_temp = round( val = gs_select_head-ztemp dec = 1 ).

      CLEAR gs_select_head-zvcf.
      SELECT SINGLE zvcf
        FROM ztb1mm0018
        INTO @gs_select_head-zvcf
       WHERE zdens = @gs_select_head-zdens
         AND ztemp = @lv_rounded_temp.

      IF sy-subrc <> 0 OR gs_select_head-zvcf IS INITIAL.
        CLEAR gs_select_head-zvcf.
        MESSAGE s615(zmcb1) DISPLAY LIKE 'E'. " '## ## ### ###. ### -5# ## 40# ### #####'  DISPLAY LIKE 'W'.
        EXIT.
      ELSE.
        MESSAGE s037(zmcb1) WITH '####(VCF)' 'VCF: ' gs_select_head-zvcf ''. " '## ##(VCF) ## ##' TYPE 'S'.
      ENDIF.

      " ### # ### ## PBO ## ##
      cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'REFRESH' ).

    WHEN 'CAL_AVOL'.
      IF gs_head-zvcf IS INITIAL OR gs_head-zvcf = 0.
        MESSAGE s000(zmcb1) WITH ': ##### #####.' DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.

      IF gs_head-zsvol IS INITIAL OR gs_head-zsvol = 0.
        MESSAGE s000(zmcb1) WITH ': ##### #####.' DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.

      gs_select_head = gs_head.
      CLEAR: gs_head, gs_select_head-zavol.
      gs_select_head-zavol = gs_select_head-zsvol / gs_select_head-zvcf.

      MESSAGE s037(zmcb1) WITH '####' '#: ' gs_select_head-zavol ''.

      " ## #### ## ##
      cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'REFRESH' ).

    WHEN 'CAL_SVOL'.
      IF gs_head-zvcf IS INITIAL OR gs_head-zvcf = 0.
        MESSAGE s000(zmcb1) WITH ': ##### #####.' DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.

      IF gs_head-zavol IS INITIAL OR gs_head-zavol = 0.
        MESSAGE s000(zmcb1) WITH ': ##### #####.' DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.

      gs_select_head = gs_head.
      CLEAR: gs_head, gs_select_head-zsvol.
      gs_select_head-zsvol = gs_select_head-zavol * gs_select_head-zvcf.

      MESSAGE s037(zmcb1) WITH '####' '#: ' gs_select_head-zsvol ''.

      " ## #### ## ##
      cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'REFRESH' ).

    WHEN 'SAVE'.
      DATA: lv_cancel_flag TYPE c LENGTH 1.

      " ZMSNO #### ### ####, ####
      PERFORM check_zmsno_data.

      CLEAR lv_cancel_flag.
      PERFORM confirm_volm_data CHANGING lv_cancel_flag. " ### #### # # # ####

      IF lv_cancel_flag = 'X'.
        CLEAR ok_code.
        EXIT. " ###(#### ### ### # ## ## # ## ##)
      ENDIF.
      PERFORM save_volm_data.
      CLEAR ok_code.

    WHEN 'INFO'.
      CALL SCREEN '0110' STARTING AT 50 5 ENDING AT 125 28.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
