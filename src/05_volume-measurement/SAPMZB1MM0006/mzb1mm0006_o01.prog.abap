*&---------------------------------------------------------------------*
*& Include          MZB1MM0006_O01
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT (100# ### Status)
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100'.

" # ## #
IF gv_first_time = 'X'.
  CLEAR gv_first_time.
  PERFORM get_po_data.
ENDIF.

  gs_head = gs_select_head.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV OUTPUT (100# ### ALV ### ##)
*&---------------------------------------------------------------------*
MODULE init_alv OUTPUT.
  "2. 100# ### Layout# Area ## (1# alv - custom cont)
  IF go_cont IS INITIAL.
    "3. ## Container# ##### ####, ## ### (cont, alv ## ##)
    CREATE OBJECT go_cont
      EXPORTING                             " Parent container
        container_name = 'AREA'.

    CREATE OBJECT go_alv
      EXPORTING
        i_parent = go_cont.

    PERFORM set_fcat CHANGING gt_fcat_item.
    gs_layout-grid_title = '#### ##'.
    gs_layout-zebra = 'X'.
    gs_layout-no_toolbar = 'X'.
    gs_layout-info_fname = 'LINE_COLOR'.
    gs_layout-ctab_fname = 'CELL_COLOR'.

    " ### ### ##
    SET HANDLER lcl_event_handler=>on_double_click FOR go_alv.

    "5. # ## ####
    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
        is_layout            = gs_layout  " #### ###
        it_toolbar_excluding = gt_uifunc  " ## ##
      CHANGING
        it_outtab            = gt_item  " ######## ##
        it_fieldcatalog      = gt_fcat_item.   " i_structure ### ### ###
  ELSE.
    " 3-2. ## ###### refresh#
    gs_stable-row = 'X'. " ##### # ## ### ## ##
    gs_stable-col = 'X'. " ## ## ##
    CALL METHOD go_alv->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = ' ' "x: ##, ##, ## ### ## -> ### #### #####
      EXCEPTIONS            "_: ## ####(##)
        finished       = 1
        OTHERS         = 2.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0110 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0110 OUTPUT.
  SET PF-STATUS 'S110'.
  SET TITLEBAR 'T110'.
ENDMODULE.
