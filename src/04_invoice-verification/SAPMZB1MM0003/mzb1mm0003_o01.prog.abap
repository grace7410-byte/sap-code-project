*&---------------------------------------------------------------------*
*& Include          MZB1MM0003_O01
*&---------------------------------------------------------------------*
MODULE status_check OUTPUT.
  IF gv_ebeln IS INITIAL.
    DATA: lv_mem_ebeln TYPE ztb1mm0006-ebeln,
          lv_c TYPE c.
    CLEAR lv_mem_ebeln.

    " 1) ### ## ### ## #### ### #### ### ##
    GET PARAMETER ID 'ZMM_EBELN' FIELD lv_mem_ebeln.

    IF lv_mem_ebeln IS NOT INITIAL.
      SET PARAMETER ID 'ZMM_EBELN' FIELD ''. " ### ###

      gv_ebeln = lv_mem_ebeln.

      " 2) ## ## ## ## ## ##### ## ##
      PERFORM check_order_and_set_status CHANGING lv_c.

      " 3) ## ### 101### #### ## ####
      gv_dynnr = '0101'.
    ELSE.
      gv_dynnr = '9000'. " ## ## ##### ##
    ENDIF.
  ENDIF.
ENDMODULE.
MODULE status_0100 OUTPUT.

  DATA: lv_title TYPE string,
        lt_extab TYPE TABLE OF sy-ucomm.

  " 1) title# ## ## ## ####
  CASE gv_mode.
    WHEN '1'. lv_title = '- ### ##'.
    WHEN '3'. lv_title = '- ##/### ##'.
    WHEN '4'. lv_title = '- ## ####'.
    WHEN OTHERS.
      lv_title  = ' '.
  ENDCASE.

  CLEAR: lt_extab.

  " 2) ## #####('0102')# ## ## 'PDF' ### ## ### ##
  IF gv_dynnr <> '0102'.
    APPEND 'PDF' TO lt_extab.
    APPEND 'CHECK' TO lt_extab. " ## ## ## ## ##(### ##) ### ## ##
  ENDIF.

  SET PF-STATUS 'S100' EXCLUDING lt_extab. " 2# ###### ## ## Status ###
  SET TITLEBAR 'T100'  WITH lv_title. " 1# ### #### title ###

  IF gv_first_time = 'X'.
    gs_head-bldat = sy-datum.
    CLEAR gv_first_time. " #### # ## ### ##
  ENDIF.

*  gv_ebeln = gv_select_ebeln.
ENDMODULE.
*&---------------------------------------------------------------------*
MODULE status_0102 OUTPUT.
  LOOP AT SCREEN. " gv_wmwst
    IF screen-group1 = 'GR1'. " ### ## ## ####, #### input = 0 ### ###
      IF gv_mode = '3'.
        screen-active = '0'.
        screen-invisible = '1'.
      ELSE.
        screen-active = '1'.
        screen-invisible = '0'.
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

  SET CURSOR FIELD 'GV_WRBTR'. " #### #### ## ### # ### ##

* ## #### ## ##### ##
*  IF go_logo IS INITIAL. " ###(C-Nergy ##) ## - ## ### ###
*    CREATE OBJECT go_cont_logo
*      EXPORTING
*        container_name = 'LOGO'. " ### #### #
*
*    CREATE OBJECT go_logo
*      EXPORTING
*        parent = go_cont_logo.
*
*    PERFORM display_image USING 'ZCNERGY_LOGO'  " SMW0# ### ### ID
*                                go_logo. " ### ## ##
*  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
MODULE status_0110 OUTPUT.
  SET PF-STATUS 'S110'.
  SET TITLEBAR 'T110'.
ENDMODULE.
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
*& Module  modify_screen_0100 (## ### - ## ###, ###)
*&---------------------------------------------------------------------*
MODULE modify_screen_0100 OUTPUT.
  LOOP AT SCREEN.
    IF screen-name = 'GV_EBELN' OR screen-name = 'GS_HEAD-BLDAT'.
      IF gv_dynnr = '0102'.
        screen-input = '0'.
      ELSE.
        screen-input = '1'.
      ENDIF.
    ENDIF.
    IF screen-name = 'BTN01'.
      IF gv_dynnr <> '0101'.
        screen-active = '0'.
        screen-invisible = '1'.
      ELSE.
        screen-active = '1'.
        screen-invisible = '0'.
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module  modify_screen_0101 (## ### - ###### 101#)
*&---------------------------------------------------------------------*
MODULE modify_screen_0101 OUTPUT.

  LOOP AT SCREEN.
    CASE screen-group1.
      WHEN 'TX1'.
        IF gv_stat1 CP '*###*'. " 1. ### ## #### ##
          screen-active = '0'. " ### ## ### = ## ##
        ELSE.
          screen-active = '1'. " #### ## ## ## #### ## => #### ### ####
        ENDIF.
        MODIFY SCREEN.

      WHEN 'TX2'. " 2. ##/### #### ##
        IF gv_stat2 CP '*###*'.
          screen-active = '0'.
        ELSE.
          screen-active = '1'. " #### ###
        ENDIF.
        MODIFY SCREEN.

      WHEN 'TX3'. " 3. ## #### #### ##
        IF gv_stat3 CP '*###*'.
          screen-active = '0'.
        ELSE.
          screen-active = '1'. " #### ###
        ENDIF.
        MODIFY SCREEN.

*********************** #### (### ##) ******************************
** ###### TXT# active ### ### *
*      WHEN 'RAD1'. " ### ## ## ##
*        IF gv_icon1 CS icon_led_red.
*          screen-invisible = '0'. " #### ## ###
*        ELSE.
*          screen-invisible = '1'. " ### = ### # ### ### ## ##
*        ENDIF.
*        MODIFY SCREEN.
************************** #### (##/###) *****************************
*      WHEN 'RAD2'.
*        IF gv_icon2 CS icon_led_red.
*          screen-invisible = '0'. " #### ## ###
*        ELSE.
*          screen-invisible = '1'. " ### = ### # ### ### ## ##
*        ENDIF.
*        MODIFY SCREEN.
*************************** #### (## ####) ****************************
*      WHEN 'RAD3'.
*        IF gv_icon3 CS icon_led_red.
*          screen-invisible = '0'. " #### ## ###
*        ELSE.
*          screen-invisible = '1'. " ### = ### # ### ### ## ##
*        ENDIF.
*        MODIFY SCREEN.

    ENDCASE.
  ENDLOOP.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0102 OUTPUT
*&---------------------------------------------------------------------*
MODULE init_alv_0102 OUTPUT.

  IF go_cont IS INITIAL.
    PERFORM create_object USING 'AREA' CHANGING go_cont go_alv.

    " 3-2. ## ####
    PERFORM set_layout USING 1 CHANGING gs_layout.
    PERFORM set_uifunc USING 1 CHANGING gt_uifunc.
    PERFORM set_fcat_item CHANGING gt_fcat_item.

    " 3-3. # ## ##
    PERFORM display_alv USING gs_layout gt_uifunc gt_fcat_item CHANGING go_alv gt_item.
  ELSE.
    PERFORM set_fcat_item CHANGING gt_fcat_item. " FCAT ###
    go_alv->set_frontend_fieldcatalog( it_fieldcatalog = gt_fcat_item ). " +) refresh

    CALL METHOD go_alv->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = ' '
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& MODULE check_pop_open (100# ### # # 120# ## ### ##)
*&---------------------------------------------------------------------*
MODULE check_pop_open OUTPUT.
*  CHECK gv_first_time = 'X'." #### # ### ## ## ##
*  CLEAR: gv_first_time. " ## # # ### ### ### ##
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
*& Module INIT_ALV_0110 OUTPUT
*&---------------------------------------------------------------------*
MODULE init_alv_0110 OUTPUT.
  "3. ## ###
  IF go_cont_pohd IS INITIAL.
    PERFORM get_po_data .
    PERFORM create_object USING 'POHD' CHANGING go_cont_pohd go_alv_pohd.

    " 3-2. ## ####
    PERFORM set_layout USING 2 CHANGING gs_layo_pohd.
    PERFORM set_uifunc USING 2 CHANGING gt_uifunc_pohd.
    PERFORM set_fcat_pohd CHANGING gt_fcat_pohd.

    " 3-3. # ## ##
    PERFORM display_alv USING gs_layo_pohd gt_uifunc_pohd gt_fcat_pohd CHANGING go_alv_pohd gt_pohd.
  ELSE.
    PERFORM refresh_alv USING gs_stable CHANGING go_alv_pohd.
  ENDIF.
ENDMODULE.
