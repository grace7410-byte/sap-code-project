*&---------------------------------------------------------------------*
*& Include          ZB1MM0001_I01
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA(lv_ok_code) = ok_code. " #### ### ### ## ### ####,
  CLEAR ok_code. " ## ### ##### ## # ## ### #### # ####.

  CASE lv_ok_code.
    WHEN 'BACK'. " #### ## ## # ## #### ##
      LEAVE TO SCREEN 0.
    WHEN 'GO_CREATE'.
      CALL TRANSACTION 'ZB1MM0006'. " CALL SCREEN ## ## # ## ##
      cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'REFR' ).
    WHEN 'HIERARCHY'.
      " #### Expand ##
      LOOP AT gt_hvolm ASSIGNING FIELD-SYMBOL(<fs_hvolm>).
        " ## ### ## #### # ####(ZMSNO)# ### ### ##
        READ TABLE gt_volm WITH KEY zdocno = <fs_hvolm>-zdocno
                                     process = <fs_hvolm>-process
                                     TRANSPORTING NO FIELDS.

        " #### ## ## #### ### ##
        LOOP AT gt_volm TRANSPORTING NO FIELDS
          WHERE zdocno = <fs_hvolm>-zdocno
            AND zmsno  IS NOT INITIAL.

          <fs_hvolm>-expand = 'X'. " #### ### ### ## ### ##
          EXIT. " ### ### ### ### ##
        ENDLOOP.
      ENDLOOP.

      PERFORM set_layout_hier USING 0 CHANGING gs_layout_hier.
      PERFORM set_fcat CHANGING gt_fcat.
      PERFORM display_hierarchy.

    WHEN 'PRINT_PDF'.
      DATA: lt_index_rows TYPE lvc_t_row,
            ls_index_row  TYPE lvc_s_row.

      CALL METHOD go_alv_item->get_selected_rows " ### ## ####
        IMPORTING
          et_index_rows = lt_index_rows.

      IF lt_index_rows IS INITIAL. " ## ### ###
        MESSAGE i013(zmcb1) WITH '### ## ######. '. " ### ### ####.
        RETURN.
      ENDIF. " # ### ### ### ##
      IF lines( lt_index_rows ) > 1.
        MESSAGE '# ## # ## ## #####.' TYPE 'I'.
        RETURN.
      ENDIF.

      " ### ### ##
      READ TABLE lt_index_rows INTO ls_index_row INDEX 1.
      READ TABLE gt_item INTO gs_item INDEX ls_index_row-index.
      PERFORM download_and_print_pdf. " PDF ## ####
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

*    WHEN 'ZDOCNO_OVERVIEW'.
*      IF gs_volm-process = 'SO'. " ###### ##### ### ##
*        PERFORM get_sd_data_all.
*        go_alv_item->refresh_table_display( ).
*      ELSEIF gs_volm-process = 'PO'.
*        " PERFORM get_mm_data_all. (## ##)
*      ENDIF.
  ENDCASE.
  CLEAR lv_okcode.
ENDMODULE.
