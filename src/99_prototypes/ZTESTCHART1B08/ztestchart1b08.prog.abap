REPORT ZTESTCHART1B08.
DATA: ok_code         TYPE sy-ucomm,
      lo_chart_engine TYPE REF TO cl_gui_chart_engine,
      lo_docking      TYPE REF TO cl_gui_docking_container, " ## ####
      lv_xdata        TYPE xstring,
      lv_xcust        TYPE xstring.

START-OF-SELECTION.
  CALL SCREEN 100.

*----------------------------------------------------------------------*
* PBO (### ## #)
*----------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
 SET PF-STATUS 'S100'.

  IF lo_docking IS INITIAL.
    " 1. ## #### ## (#### ## ## ##!)
    CREATE OBJECT lo_docking
      EXPORTING
        side      = cl_gui_docking_container=>dock_at_left " ### ##
        extension = 500. " ## 500##

    " 2. ## ## ## # ## ##### ##
    CREATE OBJECT lo_chart_engine
      EXPORTING
        parent = lo_docking.

" 1. XML ### ## 'String' ## ## # # ##
DATA: lv_cust_string TYPE string.
lv_cust_string = '<ChartEngine><Chart><Type>StackedBar</Type></Chart></ChartEngine>'.

" 2. (## ## ##) String# ### #### ####(xstring)# #### ##
" SCMS_STRING_TO_XSTRING ## ## # #### ## ### # ###.
CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
  EXPORTING
    text = lv_cust_string  " String ## ##
  IMPORTING
    buffer = lv_xcust.     " XString ## ##

" --- (## lv_data_xml ## ### #### String ## #### ##) ---

" 3. XML #### ## 'String' ## ## # # ##
DATA: lv_data_string TYPE string.
lv_data_string =
  '<ChartData>' &&
  '  <Categories><Category>Oil Yield</Category></Categories>' &&
  '  <Series label="LPG"><Point><Value>5</Value></Point></Series>' &&
  '  <Series label="GAS"><Point><Value>35</Value></Point></Series>' &&
  '  <Series label="DSL"><Point><Value>45</Value></Point></Series>' &&
  '  <Series label="ETC"><Point><Value>15</Value></Point></Series>' &&
  '</ChartData>'.

" 4. ### XML# #### ##
CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
  EXPORTING
    text = lv_data_string
  IMPORTING
    buffer = lv_xdata.

    lo_chart_engine->set_customizing( xdata = lv_xcust ).
    lo_chart_engine->set_data( xdata = lv_xdata ).
    lo_chart_engine->render( ).
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE OK_CODE.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
