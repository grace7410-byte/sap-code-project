*&---------------------------------------------------------------------*
*& Include          MZB1MM0003O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'S100'.
 SET TITLEBAR 'T100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CHECK_SKIP_INITIAL_SCREEN OUTPUT
*&---------------------------------------------------------------------*
MODULE check_skip_initial_screen OUTPUT.
" #### ID### ##### ###
  GET PARAMETER ID 'BES' FIELD gv_ebeln.

  " #### ###### ### ## ##### & 200### 'BACK'## ### # ## ##
  IF gv_ebeln IS NOT INITIAL AND gv_back IS INITIAL.
    " 100# ### ### ## ## ##(200#)## ###
    SET SCREEN '0200'.
    LEAVE SCREEN.
  ENDIF.
  IF gv_back IS NOT INITIAL.
    CLEAR gv_back.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
 SET PF-STATUS 'S200'.
 SET TITLEBAR 'T200'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV OUTPUT (100# ### ALV ### ##)
*&---------------------------------------------------------------------*
MODULE init_alv OUTPUT.
  " 1. ## Container# ##### ####, ## ###
  IF go_cont_volm IS INITIAL.
    PERFORM create_object USING 'VOLM' CHANGING go_cont_volm go_alv_volm. " #### ## # ALV Grid ##

    "2-2. ## ####
    " #### #### ####, uifunc ##### gs_layout, gs_uifunc ##
    PERFORM set_layout USING 1 CHANGING gs_layout_volm.
    PERFORM set_uifunc USING 1 CHANGING gt_uifunc_volm.
    PERFORM set_fcat_volm CHANGING gt_fcat_volm.

    "2-3. # ## ####
    PERFORM display_alv USING gs_layout_volm gt_uifunc_volm gt_fcat_volm
                        CHANGING go_alv_volm gt_volm.
  ELSE.
    " 2-5. ## ###### refresh#
    go_alv_volm->refresh_table_display( ).
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_200 OUTPUT (200# ### ALV ### ##)
*&---------------------------------------------------------------------*
MODULE init_alv_200 OUTPUT.
  " 1. ## Container# ##### ####, ## ###
  IF go_cont IS INITIAL.
    PERFORM create_object USING 'AREA' CHANGING go_cont go_alv_item. " #### ## # ALV Grid ##

    "2-2. ## ####
    " #### #### ####, uifunc ##### gs_layout_cont, gs_uifunc_cont ##
    PERFORM set_layout USING 2 CHANGING gs_layout_item.
    PERFORM set_uifunc USING 2 CHANGING gt_uifunc_item.
    PERFORM set_fcat_item CHANGING gt_fcat_item.
    SET HANDLER lcl_event_handler=>on_double_click FOR go_alv_item.

    "2-3. # ## ####
    PERFORM display_alv USING gs_layout_item gt_uifunc_item gt_fcat_item
                        CHANGING go_alv_item gt_item.
  ELSE.
    " 2-5. ## ###### refresh#
    go_alv_item->refresh_table_display( ).
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0220 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0220 OUTPUT.
LOOP AT SCREEN.
    " ### 'GRP'# ###(220# ##)# ####
    IF screen-group1 = 'GRP'.
      IF gv_visible = 'X'. " #### # ## # ## ## ok ##
        screen-active = 1. " ###
      ELSE.
        screen-active = 0. " ###
      ENDIF.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDMODULE.
