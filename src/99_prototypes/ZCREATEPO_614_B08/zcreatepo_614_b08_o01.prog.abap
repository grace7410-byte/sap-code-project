*&---------------------------------------------------------------------*
*& Include          MZB1MM0004_O01
*&---------------------------------------------------------------------*
*& Module STATUS_CHECK OUTPUT (## ###### ### ##)
*&---------------------------------------------------------------------*
MODULE status_check OUTPUT.
  IMPORT gv_mode = gv_mode FROM MEMORY ID 'MODE_CHECK'.
  IMPORT gv_ebeln = gv_ebeln FROM MEMORY ID 'ZAPPR_DATA'.

  FREE MEMORY ID 'ZAPPR_DATA'. " #### #### ####

  " ## ###### ## ### ####, '## ##'## ## ##### ##
  IF gv_mode IS NOT INITIAL.
    CASE gv_mode.
      WHEN 'U'.
        SET SCREEN '0200'.
        LEAVE SCREEN.
      WHEN 'D'. " ## ### ## ##### ##
        SET SCREEN '0300'.
        LEAVE SCREEN.
    ENDCASE.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT (100# ### Status)
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  " ## ## & ## ## ### ##
  IF gs_head-bsart IS INITIAL.
    PERFORM set_init_user_data.  " ### ### ### ####
    gs_head-bsart = 'NB'.
    gs_head-bedat = sy-datum.
    gv_visible = 'X'. " ### ##(### ##)
    SET CURSOR FIELD 'GS_HEAD-BPID'.
  ENDIF.

  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100'.

  " 100# ### ## ## ## ## ## (###)
  PERFORM control_header_screen.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT (200# ### Status)
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS 'S200'.
  SET TITLEBAR 'T200'.

  IF gt_item IS INITIAL.
    PERFORM set_init_item_rows.
    " ## 10# #### #### gt_itab ###
    PERFORM get_edit_data.
  ENDIF.

  PERFORM set_alv_edit USING 'AREA200'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0300 OUTPUT (300# ### Status)
*&---------------------------------------------------------------------*
MODULE status_0300 OUTPUT.
  SET PF-STATUS 'S300'.
  SET TITLEBAR 'T300'.

  IF gt_item IS INITIAL.
    PERFORM set_init_item_rows.
    " ## 10# #### #### gt_itab ###
    PERFORM get_edit_data.
  ENDIF.

  PERFORM set_alv_edit USING 'AREA300'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV OUTPUT (100# ### ALV ### ##)
*&---------------------------------------------------------------------*
MODULE init_alv OUTPUT.
  " 1. # ##(itab# #####)
  PERFORM set_init_item_rows.

  "2. 100# ### Layout# Area ## (1# alv - custom cont)
  IF go_cont IS INITIAL.
    "3. ## Container# ##### ####, ## ### (cont, alv ## ##)
    PERFORM create_object USING 'AREA' 'X' CHANGING go_cont go_alv.

    "4. ## #### #### ## ## (pv_type = 1)
    PERFORM set_layout USING 1 CHANGING gs_layout.
    PERFORM set_uifunc USING 1 CHANGING gt_uifunc.
    PERFORM set_fcat_item CHANGING gt_fcat_item.
    " ### ### ##
    SET HANDLER lcl_event_handler=>on_toolbar FOR go_alv.
    SET HANDLER lcl_event_handler=>on_user_command FOR go_alv.
    SET HANDLER lcl_event_handler=>on_data_changed FOR go_alv.

    "5. # ## ####
    PERFORM display_alv USING gs_layout gt_uifunc gt_fcat_item
                        CHANGING go_alv gt_item.
  ELSE.
    " 3-2. ## ###### refresh#
    PERFORM set_item_number. " 3-1. # ## ## ### ## ##
    PERFORM set_fcat_item CHANGING gt_fcat_item.

    go_alv->set_frontend_fieldcatalog( it_fieldcatalog = gt_fcat_item ).
    go_alv->refresh_table_display( ).
  ENDIF.
  " ##### ### ### ##### #### #### ###
  IF go_cont IS BOUND. " IS INITIAL ## ####, IS ASSIGNED ## ## (## ##)
    go_cont->set_visible( visible = gv_visible ). " gv_visible# 'X'# ###, ' '# ###
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0103 OUTPUT (103# ## Status)
*&---------------------------------------------------------------------*
MODULE status_0103 OUTPUT.
  SET PF-STATUS 'S103'.
  SET TITLEBAR 'T103' WITH gs_vend-bpid.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0120 OUTPUT (120# ## Status)
*&---------------------------------------------------------------------*
MODULE status_0120 OUTPUT.
  SET PF-STATUS 'S120'.
  SET TITLEBAR 'T120'.
  " ## ### ## # (#### ## ### ## ##)
  IF gv_manual = 'X'.
    LOOP AT SCREEN.
      IF screen-group1 = 'G2'. " ###, '# # ####' ###, ####
        screen-active = '0'.   " #######(#### ### ### #####)
        screen-invisible = '1'. " ####
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0101 OUTPUT (101# ALV ### ##)
*&---------------------------------------------------------------------*
MODULE init_alv_0101 OUTPUT .
  PERFORM get_vendor_all_data.
  "1. container # ##### #### ## ###
  IF go_cont_vend IS INITIAL.
    PERFORM create_object USING 'VENDOR' '' CHANGING go_cont_vend go_alv_vend. " 2# alv - custom container

    "3. ## #### #### ## ## (pv_type 2)
    PERFORM set_layout USING 2 CHANGING gs_layo_vend. " 101# alv ## #### ##
    PERFORM set_uifunc USING 2 CHANGING gt_uifunc_vend. " 101# alv ## ####
    PERFORM set_fcat_vend CHANGING gt_fcat_vend.
    SET HANDLER lcl_event_handler=>on_hotspot_click FOR go_alv_vend.

    "4. # ## ####
    PERFORM display_alv USING gs_layo_vend gt_uifunc_vend gt_fcat_vend
                        CHANGING go_alv_vend gt_vend.
  ELSE.
    " 1-2. ## ###### refresh#
    go_alv_vend->refresh_table_display( ).
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0110 OUTPUT (110# ALV ### ##)
*&---------------------------------------------------------------------*
MODULE init_alv_0110 OUTPUT.
  "1. 110# ##### Layout# ### ## ## ## (3# alv - custom container)
  IF go_dialog IS INITIAL.
    "2. ## Container# ##### ####, ## ### (, alv ## ##)
    PERFORM create_object USING 'OPTI' ' ' CHANGING go_dialog go_alv_pop.

    "3. ## #### #### ## ## (pv_type 1 ## ## ##)
    PERFORM set_layout USING 2 CHANGING gs_layo_pop. " 110# alv ## #### ##
    PERFORM set_uifunc USING 2 CHANGING gt_uifunc_pop. " 110# alv ## ####
    PERFORM set_fcat_opti CHANGING gt_fcat_opti.

    "5. # ## ####
    PERFORM display_alv USING gs_layo_pop gt_uifunc_pop gt_fcat_opti
                        CHANGING go_alv_pop gt_opti.
  ELSE.
    " 2-2. ## ###### refresh#
    go_alv_pop->refresh_table_display( ).
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_CHART_0110 OUTPUT (110# ## ### ##)
*&---------------------------------------------------------------------*
MODULE init_chart_0110 OUTPUT.
  " ## ### 1. ## ### ##
  PERFORM get_chart_data.

  " 2. #### ## ## ## ## + ## ###
  IF gt_bom IS NOT INITIAL.
    IF go_chart IS INITIAL. " 4# container: ALV# ## ## ####
      PERFORM create_chart_object USING 'CHART' CHANGING go_cont_chart go_chart.
    ENDIF.
    " 3. ## #### XML### ### #### ###
    PERFORM display_chart.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module modify_screen_0100 OUTPUT (100# ### ## ##)
*&---------------------------------------------------------------------*
MODULE modify_screen_0100 OUTPUT.
  " ### ### ## ### ## ## ##(### #) ### ###
  PERFORM control_header_screen.

  " # #### ### ####(#### ### X)
  LOOP AT SCREEN.
    CASE screen-group1.
      WHEN 'G1'. " screen-name = 'TAB01', 'TAB02'.
        IF gv_visible = 'X'.
          screen-active = '1'. " #### ## ### ## ### ##
        ELSE.
          screen-active = '0'.
*          screen-output = '1'.
*          screen-invisible = '0'.
*          screen-required = '1'.
        ENDIF.
        MODIFY SCREEN.
        CONTINUE.
      WHEN 'G3'.
        IF gv_chart_show = 'X'.
          screen-active = '1'. " bom(##)### ### ###
        ELSE.
          screen-active = '0'. " ### ### ###
        ENDIF.
        MODIFY SCREEN.
        CONTINUE.
    ENDCASE.
    " #### ## ## #### ##
    IF screen-name = 'TABSTRIP'. " ### ##### ### #### ##
      IF gv_visible = 'X'.
        screen-active = '1'. " #### ## ### ## ### ##
      ELSE.
        screen-active = '0'.
      ENDIF.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module modify_screen_0200 OUTPUT (200#, 300# ### ## ##)
*&---------------------------------------------------------------------*
MODULE modify_screen_0200 OUTPUT.
  " ### ### ## ### ## ## ##(### #) ### ###
  PERFORM control_header_screen.

  LOOP AT SCREEN. " ## ## #### #### ##, ####, ### ### ### # ##
    IF screen-name = 'GS_HEAD-BSART' OR " ##### ##
      screen-name = 'GS_HEAD-EBELN' OR
       screen-name = 'GS_HEAD-BPID'  OR
       screen-name = 'GS_HEAD-BEDAT'.
      screen-input = 0. " ####
      MODIFY SCREEN.
      CONTINUE.
    ENDIF.

    " ## ##(300#)# ## ## ## ##
    IF gv_mode = 'D'.
      IF screen-name = 'BTN_DT1' OR screen-name = 'BTN_DT2' OR screen-name = 'BTN_ALL_DEL'.
      ELSE. " ## ##, ## ## ## ## # ####
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.

*    " ## ### # #### ## ## ### ## (gv_visible ####)
*    IF screen-group1 = 'G1' OR screen-name = 'TABSTRIP'.
*       screen-active = 1.
*       MODIFY screen.
*    ENDIF.
  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------*
*& MODULE set_dynnr_tab (100# ### ##### ##)
*&---------------------------------------------------------------------*
MODULE set_dynnr_tab OUTPUT.
  IF gv_visible IS INITIAL.
    gv_dynnr_tab = '9000'. " # ##### (### 9000## Subscreen #### ##### #)
    EXIT. " #### ###### ### ##
  ENDIF.
  CASE tabstrip-activetab. " gv_visible X## ## ##### #
    WHEN 'TAB1'.
      gv_dynnr_tab = '0110'.
    WHEN 'TAB2'.
      gv_dynnr_tab = '0130'.
    WHEN OTHERS.
      gv_dynnr_tab = '0110'.
      tabstrip-activetab = 'TAB1'.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& MODULE set_dynnr_tab_edit (200# ### ##### ##)
*&---------------------------------------------------------------------*
MODULE set_dynnr_tab_edit OUTPUT.
  CASE tabstrip-activetab. " gv_visible# ### ###, ### ####
    WHEN 'TAB1'.
      gv_dynnr_tab = '0110'.
    WHEN 'TAB2'.
      gv_dynnr_tab = '0130'.
    WHEN OTHERS.
      gv_dynnr_tab = '0110'.
      tabstrip-activetab = 'TAB1'.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& MODULE check_pop_open (100# ### # # 120# ## ### ##)
*&---------------------------------------------------------------------*
MODULE check_pop_open OUTPUT.
*  CHECK gv_firsttime IS INITIAL." #### # ### ## ## ##
*  gv_firsttime = 'X'. " ## # # ### ### ### ##
*
*  SELECT SINGLE zdate "  DB## # #### ##### ## #### ### ## ##
*    FROM ztcheck_b08 " ## ### DB
*    INTO @DATA(lv_saved_date) " sy-datum ### ## ##
*    WHERE uname = @sy-uname
*      AND progname = @sy-repid
*      AND zdate = @sy-datum.
*
*  " #### ## # =  ## #### # ###
*  IF sy-subrc <> 0 OR lv_saved_date <> sy-datum. " ### ### ### ## ## ## ##
*    " cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'DISPLAY_INFO' ). " ## PAI ## ### ### ###
*    CREATE OBJECT go_timer. " ## ### ### ##
*    SET HANDLER lcl_event_handler=>on_finished FOR go_timer.
*    go_timer->interval = '0.5'. " 0.5# ## ##
*    go_timer->run( ). cl_gui_cfw=>flush( ). " ### ### ### ##
*  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_CHART_0130 OUTPUT (130# ## ### ##)
*&---------------------------------------------------------------------*
MODULE init_chart_0130 OUTPUT.
  " ## ### 1. ## ### ##
  PERFORM get_chart_data_all.

  " 2. #### ## ## ## ## + ## ###
  IF gt_bom_all IS NOT INITIAL.
    IF go_chartall IS INITIAL. " 5# container: ALV + ## ####
      PERFORM create_object_all.

      PERFORM set_layout USING 2 CHANGING gs_layo_all. " 101# alv ## #### ##
      PERFORM set_uifunc USING 2 CHANGING gt_uifunc_all. " 101# alv ## ####
      PERFORM set_fcat_all CHANGING gt_fcat_all.
    ENDIF.
    " 3. ## #### XML### ### #### ###
    PERFORM display_chart_all.

    " ### ## chart ### ### ALV ###
    PERFORM display_alv USING gs_layo_all gt_uifunc_all gt_fcat_all
                        CHANGING go_alv_all gt_bom_all.
  ELSE.
    " 2-2. ## ###### refresh#
    go_alv_all->refresh_table_display( ).
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0300 OUTPUT (300# #### ## ALV ### ##)
*&---------------------------------------------------------------------*
MODULE init_alv_0300 OUTPUT.
  " 1. ## #### ## ### ####
  SELECT ebeln bpid ekorg ekgrp bukrs bsart bedat zterm inco1 zebeln zebelnsv knumh
  lvorm ernam erdat erzet aenam aedat aezet
  FROM ztb1mm0006
  INTO CORRESPONDING FIELDS OF TABLE gt_pohd
  WHERE bsart = 'NB'
  AND lvorm <> 'X'.

  " 2. #### # ALV ## ##
  IF go_cont_pohd IS INITIAL.
    "3. ## Container# ##### ####, ## ### (cont, alv ## ##)
    PERFORM create_object USING 'SUBAREA300' '' CHANGING go_cont_pohd go_alv_pohd.

    "3. ## #### #### ## ## (pv_type = 3)
    PERFORM set_layout USING 3 CHANGING gs_layout_pohd.
    PERFORM set_fcat_pohd CHANGING gt_fcat_pohd. " ## ## ## ###### ## ##
    " ### ### ##
    SET HANDLER lcl_event_handler=>on_double_click FOR go_alv_pohd.

    " 4. ALV ##
    go_alv_pohd->set_table_for_first_display(
      EXPORTING
        " i_structure_name              = 'ZTB1MM0006'
        is_layout                     = gs_layout_pohd
      CHANGING
        it_outtab                     = gt_pohd
        it_fieldcatalog               = gt_fcat_pohd
    ).
  ELSE.
    " 5. ## ###### ####
    go_alv_pohd->refresh_table_display( ).
  ENDIF.
ENDMODULE.
