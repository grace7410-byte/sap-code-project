*&---------------------------------------------------------------------*
*& Include          ZRB1MM0001_I01
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

    WHEN 'GET_OPTI'. " ## ## ## ### ####(gt_opti, ZTB1MM0005)
      " ##### ##### ##
      IF gs_head-bpid IS INITIAL.
        SET CURSOR FIELD 'GS_HEAD-BPID'. " ### #### ### #### ## ### ##
        MESSAGE e107(zmcb1). " ##### #####
        EXIT.
      ENDIF.

      " ## ### # ### ## ## ##
      IF gv_visible = abap_false. " ' ' # ##
        MESSAGE i017(zmcb1) WITH '[## ##]' '###'. " ## [## ##] ### ## ### ### ######
        RETURN. " ## ##
      ENDIF.

      PERFORM get_opti_data. " ## ## #### ###
      IF gt_opti IS NOT INITIAL.
        CALL SCREEN '0110' STARTING AT 5 10 " ## #### ALV# ### ## ##
                           ENDING AT 100 25.
      ENDIF.

*    WHEN 'REFR'. " ## ####### PAI ## ### ## ##
*      IF gv_show_msg = abap_true. " ### ###### (### ## #### ### ###) ### ###
*        MESSAGE s109(zmcb1) WITH gv_msg_matnr DISPLAY LIKE 'W'.
*        CLEAR: gv_show_msg, gv_msg_matnr.
*      ENDIF.

    WHEN 'ADD_ITEM'. " 110# ALV #### #### #### ## ## ## ## #
      PERFORM add_selected_data. " ### #### ## 100# ALV(###)# ##
      LEAVE TO SCREEN 0.

    WHEN 'SHOW_CHART'. " ## ## #### (ZTB1PP0002, ZTB1PP0003)

    WHEN 'CHECK'. " ### ### ## # ## ## ## ### #
      DATA: lv_subrc TYPE sysubrc. " ## ## ### ## ### ##
      PERFORM check_data_before_save CHANGING lv_subrc.
      CLEAR lv_subrc.

    WHEN 'SAVE'. " ## ## ## #
      PERFORM check_data_before_save CHANGING lv_subrc.
      CHECK lv_subrc = 0. " ### ### ### ##

      " ##### # # # ####
      IF gv_answer <> 'J'. " 'Yes'# ### ##
        PERFORM confirm_save CHANGING gv_answer. " POPUP_TO_CONFIRM ##
        CHECK gv_answer = 'J'.
      ENDIF.

      " ## ## ##
      PERFORM save_po_data.
      GV_SAVE_CHECK = 'X'.        "### PO #### ##.

    WHEN OTHERS. " ## # # # ### #### #
      IF gs_head-bpid IS NOT INITIAL. " #### ### ## ##### ## ### ###
        " #, ### ### ##### ### #### ## ####
        IF gs_head-bpid <> gv_before_bpid.
          PERFORM get_header_data.
          gv_before_bpid = gs_head-bpid. " ### ## ## # ## BPID# ###
        ENDIF.
      ELSE.
        PERFORM clear_header_data. " #### ## ###### ## ### ###
        CLEAR gv_before_bpid. " ### ### #### ## ####
      ENDIF.
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
