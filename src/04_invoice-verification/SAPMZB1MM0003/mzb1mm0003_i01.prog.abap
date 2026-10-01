*&---------------------------------------------------------------------*
*& Include          MZB1MM0003_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  " (##) ### # #### #### ##: OK_CODE ## ##)
  DATA(lv_ok_code) = ok_code. " #### ### ### ## ### ####,
  CLEAR ok_code. " ## ### ##### ## # ## ### #### # ####.

  DATA: lv_subrc  TYPE sy-subrc,
        lv_answer TYPE char1.

  CASE lv_ok_code.
    WHEN 'BACK'. " #### ## ## # ## #### ##
      IF gv_dynnr = '0102'.
*        " 102# ## ### ## #### # ## # ####(##### # ##)## ##
        CLEAR: gv_mode, gs_head-budat.
        gv_dynnr = '0101'.
      ELSEIF gv_dynnr = '0101'.
        gv_dynnr = '9000'.
        CLEAR: gv_ebeln, gv_select_ebeln.
      ELSE.
        LEAVE TO SCREEN 0.
      ENDIF.

    WHEN 'SEARCH'.
      CLEAR gv_po_selected.
      CALL SCREEN '0110' STARTING AT 25 5 ENDING AT 150 25.
      IF gv_po_selected IS NOT INITIAL.

        IF gv_dynnr = '0102'.
          CLEAR lv_answer.

          CALL FUNCTION 'POPUP_TO_CONFIRM'
            EXPORTING
              titlebar              = '### ## # ## ## ##'
              text_question         = '### ## ### ## ## #### #### ####. ##### #### ## ## #### ########?'
              text_button_1         = '#'
              text_button_2         = '###'
              display_cancel_button = ' '
            IMPORTING
              answer                = lv_answer.

          IF lv_answer = '1'. " #
            gv_dynnr = '0101'. " ###### ## ## ## ##(101)## ##
            gv_ebeln = gv_po_selected. " ### # PO ##

            CLEAR: gs_head, gv_wrbtr. " ## ### ###### ### # # #######
            REFRESH: gt_item.

            DATA: lv_dummy_char TYPE c. " #### ###, ## #### ## ### ##
            CLEAR lv_dummy_char.
            PERFORM check_order_and_set_status CHANGING lv_dummy_char.
            gs_head-bldat = sy-datum. " ## #### ## ### ### #####

            CALL METHOD cl_gui_cfw=>set_new_ok_code
              EXPORTING
                new_code = 'REFR'.
          ELSE. " ### ### ## 102# ## ### ###
          ENDIF.
        ENDIF.
      ENDIF.
      CLEAR gv_po_selected.

    WHEN 'SELECT'.
      DATA: lt_rows TYPE lvc_t_row,
            ls_row  TYPE lvc_s_row.

      go_alv_pohd->check_changed_data( ).
      go_alv_pohd->get_selected_rows( IMPORTING et_index_rows = lt_rows ).

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

      gv_select_ebeln = <fs_pohd>-ebeln.

      MESSAGE s035(zmcb1) WITH gv_select_ebeln '#'. " # #######

      DATA: lv_char         TYPE c, " ##### ### #### #
*            lv_bp_text      TYPE string, " BP## ## ### ### ##
            lv_current_stat TYPE char30. " ## ## ## ### ###### ### ##### ## -> ##### ##

      CLEAR: lv_char, lv_current_stat, gv_po_selected.

      IF gv_dynnr <> '0102'. " ####### ### #
        gv_ebeln = gv_select_ebeln.
        PERFORM check_order_and_set_status CHANGING lv_char. " ### lv_char# ## ###

        IF lv_char IS INITIAL.
          gv_dynnr = '0101'.  " ## ## ## ##### #### -> ##) #### ##
*          CALL SCREEN '0110' STARTING AT 10 5
*                                     ENDING   AT 80 20.
        ENDIF.
      ELSEIF gv_dynnr = '0102'.
        " ## #### # ### '#### ## ## ### #### ####' #### ## ###
        " -> ## #### SEARCH## ###. ##### ## #### ### # ######
        gv_po_selected = gv_select_ebeln.
      ENDIF.

      LEAVE TO SCREEN 0.

    WHEN 'SELECT_INV'. " -> ##) 101# ## 110# #### #### # #### ## ### ##

      IF gs_head-bldat IS INITIAL.
        " '##### #####'
        MESSAGE s024(zmcb1) WITH '####' DISPLAY LIKE 'E'.
        EXIT. " ## #### ### ## ## # #
      ENDIF.
      IF gs_head-bldat > sy-datum.
        MESSAGE s036(zmcb1) WITH '## ##'. " ###### ##### # ##(#####)
        EXIT.
      ENDIF.
      " ##### ### ## ###, #### ###(BEDAT)## ### # ##
      DATA: lv_po_bedat TYPE ztb1mm0006-bedat.
      CLEAR lv_po_bedat.

      SELECT SINGLE bedat
        FROM ztb1mm0006
        INTO @lv_po_bedat
       WHERE ebeln = @gv_ebeln
         AND lvorm <> 'X'.

      IF sy-subrc = 0 AND gs_head-bldat < lv_po_bedat.
        MESSAGE e012(zmcb1) WITH '## ##'. " ## #### ## ## # # ####.
        EXIT.
      ENDIF.

      " ### ## ## ## #### ####
      CASE 'X'.
        WHEN rad1.
          lv_current_stat = gv_stat1.
          " lv_bp_text = 'BP##: 1 (####)'. " -> ##) ## ### ## #### ## ##
        WHEN rad2.
          lv_current_stat = gv_stat2.
          " lv_bp_text = 'BP##: 1 (####)'.
        WHEN rad3.
          lv_current_stat = gv_stat3.
          " lv_bp_text = 'BP##: 4 (####)'.
      ENDCASE.

      " ## ## #### '##'# ####, '###'# ######(NOT CP) 102### #### ### #
      IF lv_current_stat <> '### ## (####)'.

        CASE lv_current_stat.
          WHEN '## ###'.
            MESSAGE s125(zmcb1) DISPLAY LIKE 'E'. " ## ### ## #### #### ####

          WHEN '## ## (##)' OR '## ## (## ##)'.
            MESSAGE s124(zmcb1) DISPLAY LIKE 'E'. " ## ## ### ## #####

          WHEN OTHERS. " ## #### ##
            MESSAGE s000(zmcb1) WITH '## ### ## ### ####' DISPLAY LIKE 'E'.
        ENDCASE.
        EXIT. " ## ### ### ## ## # # (## ## X)
      ENDIF.

      " #### #### ## ## ## ## ##
      CHECK lv_current_stat CP '*###*'.

**********************************************************************
*      " ## ##### -> ## ## #### # # # #### ## ##### -> ##) ### ## ### X
*      CALL FUNCTION 'POPUP_TO_CONFIRM'
*        EXPORTING
*          titlebar              = '## ## ##'
*          text_question         = |{ lv_bp_text }# ## ### ########?|
*          text_button_1         = '#'
*          text_button_2         = '###'
*          default_button        = '1'
*          display_cancel_button = ' '     " ## ##
*        IMPORTING
*          answer                = lv_char " #### ## ## (1 ## 2# ##)
*        EXCEPTIONS
*          text_not_found        = 1
*          OTHERS                = 2.
*
*      IF lv_char = '1'.
*        gv_dynnr = '0102'. " ## ### ### ##### ####
*      ENDIF.
**********************************************************************

      " ### ### ## ## ##(102#)## ### ### ## # ## ##
      CASE 'X'.
        WHEN rad1. " ### ### ### ##
          PERFORM process_goods_invoice.

        WHEN rad2. " ##/### ### ### ##
          PERFORM process_customs_invoice.

        WHEN rad3. " ## #### ### ### ##
          PERFORM process_freight_invoice.
      ENDCASE.

      gv_dynnr = '0102'. " -> ##) ##### ## ####
*      LEAVE TO SCREEN 0. " ## ##

    WHEN 'INFO'.
      gv_manual = 'X'. " #### ##### ##
      CALL SCREEN '0120' STARTING AT 50 5 ENDING AT 125 28.
      CLEAR: gv_manual. " ### ## ### ## ### ###

    WHEN 'CHECK'. " ### ### ## # ## ## ## ### #
      CLEAR lv_subrc.
      PERFORM check_data_before_save CHANGING lv_subrc.
      IF lv_subrc = 0.
        MESSAGE s021(zmcb1). " ### #######
      ENDIF.

    WHEN 'SAVE'. " ## ## ## #
      CLEAR lv_subrc.

      PERFORM check_data_before_save CHANGING lv_subrc.
      CHECK lv_subrc = 0. " ### ### ### ##

      " ##### # # # ####
      CLEAR lv_answer.
      PERFORM confirm_save CHANGING lv_answer. " POPUP_TO_CONFIRM ##
      CHECK lv_answer = 'J'.

      " ## ## DB ## ##
      PERFORM save_invoice_data.

      " ######
      IF gv_save_check = 'X'.
        " ## ## ## ###
        MESSAGE s127(zmcb1) WITH gs_head-belnr '' '' '## '. " ## ## &1&2&3#(#) #######. &4 #### #####

        SET PARAMETER ID 'ZMM_EBELN' FIELD gv_ebeln.
        CLEAR gv_save_check.

        LEAVE TO TRANSACTION sy-tcode.
      ENDIF.

    WHEN 'PDF'.
      PERFORM download_and_print_pdf.

    WHEN OTHERS. " ## # # # ### #### #
      PERFORM calculate_invoice_balance.
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
**&---------------------------------------------------------------------*
**&      Module  F4_GV_EBLEN  INPUT
**&---------------------------------------------------------------------*
*MODULE f4_gv_ebeln INPUT.
*
*  " ## F4# ### # #### ALV ##### # ## ##
*  IF go_cont_pohd IS INITIAL.
*    PERFORM get_po_data .
*    CREATE OBJECT go_cont_pohd
*      EXPORTING
*        width  = 1100
*        height = 380
*        top    = 80
*        left   = 100
**       caption = '##### #### ## # [#### ##] ## ##'
*        repid  = sy-repid
*        dynnr  = sy-dynnr
*      EXCEPTIONS
*        OTHERS = 1.
*
*    CREATE OBJECT go_alv_pohd
*      EXPORTING
*        i_parent = go_cont_pohd.
*
*    " 3-2. ## ####
*    PERFORM set_layout USING 2 CHANGING gs_layo_pohd.
*    PERFORM set_uifunc USING 2 CHANGING gt_uifunc_pohd.
*    PERFORM set_fcat_pohd CHANGING gt_fcat_pohd.
*
*    SET HANDLER lcl_event_handler=>on_close FOR go_cont_pohd.
*    SET HANDLER lcl_event_handler=>on_toolbar FOR go_alv_pohd.
*    SET HANDLER lcl_event_handler=>on_user_command FOR go_alv_pohd.
*
*    " 3-3. # ## ##
*    PERFORM display_alv USING gs_layo_pohd gt_uifunc_pohd gt_fcat_pohd CHANGING go_alv_pohd gt_pohd.
*  ELSE.
*    PERFORM refresh_alv USING gs_stable CHANGING go_alv_pohd.
*  ENDIF.
*ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0120  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0120 INPUT.
  CASE ok_code.
    WHEN 'BACK'. " #### ## ## # ## #### ##
*      DATA: ls_check TYPE ztcheck_b08.
*      IF gv_check = 'X'.
*        ls_check-uname    = sy-uname. " ### ##
*        ls_check-progname = sy-repid. " ##### = #######
*        ls_check-zdate    = sy-datum. " ## ##
*        " #### ## ## ### ### = ### #### #
*        MODIFY ztcheck_b08 FROM ls_check. " ### Insert, ### Update
*        IF sy-subrc = 0.
*          COMMIT WORK.
*        ELSE.
*          ROLLBACK WORK.
*          MESSAGE s006(zmcb1) DISPLAY LIKE 'E' WITH '<# # ## ##> ## ##'.
*        ENDIF.
*      ENDIF. " ##### #### ## ##
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
