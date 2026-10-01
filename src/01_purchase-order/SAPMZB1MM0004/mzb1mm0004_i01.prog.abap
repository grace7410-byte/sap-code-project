*&---------------------------------------------------------------------*
*& Include          MZB1MM0004_I01
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

    WHEN 'INFO'. " ## ## ###
      gv_manual = 'X'. " #### ##### ##
      CALL SCREEN '0120' STARTING AT 50 5 ENDING AT 115 20.
      CLEAR: gv_manual. " ### ## ### ## ### ###

    WHEN 'ITEM_OVERVIEW'.
      IF gv_visible = 'X'. " X# ##(## ALV ### #### ###) ## ###
        gv_visible = ' '.
      ELSE.
        " 1. #### ### #### #### #### ##
        IF gs_head-bedat < sy-datum.
          SET CURSOR FIELD 'GS_HEAD-BEDAT'. " ### #### ### #### ## ### ##
          MESSAGE s012(zmcb1) WITH '#### ##' DISPLAY LIKE 'E'. " ## #### #### ### # ####.
          RETURN.
        ELSEIF gs_head-bedat IS INITIAL.
          SET CURSOR FIELD 'GS_HEAD-BEDAT'.
          MESSAGE s109(zmcb1) WITH '## ###' DISPLAY LIKE 'E'. " ## #### ##### ####
        ENDIF.

        " 2. #### ##### ## ### ## ## (CDS View ##)
        IF gs_head-bedat IS NOT INITIAL.
          " ##### #### ### ##/## ### ### #### ####
          PERFORM get_opti_data. " ## ## #### ###
          gv_visible = 'X'. " ## ALV# visible## ###
        ENDIF.
      ENDIF.

    WHEN 'TAB1' OR 'TAB2'. " # ## #
      tabstrip-activetab = lv_ok_code. " ## ## ## ### #####

    WHEN 'SEL_VEND'. "103# ## #### ## #
      gs_head-bpid = gs_vend-bpid.
      LEAVE TO SCREEN 0.

      " WHEN 'GET_OPTI'. " ## ## ## ### ####(gt_opti, ZTB1MM0005)

    WHEN 'CHECK'. " ### ### ## # ## ## ## ### #
      DATA: lv_subrc TYPE sysubrc. " ## ## ### ## ### ##
      PERFORM check_data_before_save CHANGING lv_subrc.
      CLEAR lv_subrc.

    WHEN 'SAVE'. " ## ## ## #
      PERFORM check_data_before_save CHANGING lv_subrc.
      CHECK lv_subrc = 0. " ### ### ### ##

      " ##### # # # ####
      CLEAR gv_answer.
      PERFORM confirm_save CHANGING gv_answer. " POPUP_TO_CONFIRM ##
      CHECK gv_answer = 'J'.

      " ## ## ##
      IF gv_mode = 'U'. " ## #### #### ## ## ###
        PERFORM update_po_data.
      ELSE.
        PERFORM save_po_data.
      ENDIF.
      " ######
      IF gv_save_check = 'X'.
        IF gv_mode = 'U'." ##### ## #### SELECT## ### #####
          PERFORM get_edit_data.
          go_alv->refresh_table_display( ).
        ELSE.
          " ### ## ### save_po_data ###### #### #### ##
          MESSAGE s104(zmcb1) WITH gv_po_ebeln. " #### ' ' # ####### ### PO #### #####.'.

          " ### ### # ##
          EXPORT gv_save_check FROM gv_save_check TO MEMORY ID 'SAVE_CHECK'.
          EXPORT gs_head FROM gs_head TO MEMORY ID 'ZPO_DATA'.

          CALL TRANSACTION 'ZB1MM0005'. " ### PO ## ###
        ENDIF.
      ENDIF.

    WHEN 'DELETE_ALL'.
      DATA: lv_text   TYPE string,
            lv_answer TYPE c.

      lv_text = |#### { gv_ebeln }## ### ## ## # ## ### #####. ## ########?|.
      PERFORM confirm_delete USING lv_text CHANGING lv_answer.

      IF lv_answer = '1'.
        PERFORM delete_po_all. " ## ## #### ##
      ENDIF.

    WHEN 'DELETE_ITEM'.
      PERFORM delete_selected_items. " ### ## ### ## ## ### ###
      " ##### # ## 0# # / ### # / ### # ###

    WHEN 'BSART'.               "## ## ### ## #### ## (###)
      IF gs_head-bsart = 'SV'.
        " ### PO ## ### ##
        LEAVE TO TRANSACTION 'ZB1MM0005'.
      ENDIF.

    WHEN 'PURC'. " ## ## ## # #### -> ## #### # ##
      IF gv_mode = 'U' OR gv_mode = 'D'.
        LEAVE TO SCREEN 0. "#### ######## -> ###### ## ##### ## ##
      ELSE.
        " ### # ##
        LEAVE TO TRANSACTION 'ZB1MM0004'.
      ENDIF.

    WHEN 'GO_DELETE'.
      gv_mode = 'D'. " ## ## ### ##
      " gv_ebeln #### #### ### ### ### ##
      CLEAR: gs_head, gt_item. " gs_head, gt_item# ## PBO## ##### ###
      CALL SCREEN 300.

    WHEN 'GO_ERASE'.
      gv_mode = 'U'. " ## ## ### ##
      " gv_ebeln ## #### #### ### ### ### ##
      CLEAR: gs_head, gt_item. " gs_head, gt_item# ## PBO## ##### ###
      CALL SCREEN 200.

    WHEN OTHERS. " ## # # # ### #### #
      IF gs_head-bpid IS NOT INITIAL. " #### ### ## ##### ## ### ###
        " #, ### ### ##### ### #### ## ####
        IF gs_head-bpid <> gv_before_bpid.
          PERFORM get_header_data." ## ##### ##### ##(### ##### ### ##)
          PERFORM get_vendor_data USING '' gs_head-bpid.  " ## ##### ####, ##### ##(## ##)

          " ### #### ##### ## ####(#, ##### ##### #)
          IF gv_visible = 'X'.
            PERFORM get_opti_data.
          ENDIF.
          gv_before_bpid = gs_head-bpid. " ### ## ## # ## BPID# ###
        ENDIF.
      ELSE.
        PERFORM get_vendor_all_data.
        IF gv_visible = 'X'.
          PERFORM get_opti_data. " ## ## #### ##
        ENDIF.
        PERFORM clear_header_data. " #### ## ###### ## ### ###
      ENDIF.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0120  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0120 INPUT.
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
