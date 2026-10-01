*&---------------------------------------------------------------------*
*& Report ZRB1MM0002
*&---------------------------------------------------------------------*
*& Program ID    : ZRB1MM0002
*& Program Name  : #### ## ####
*& Created by    : ###
*& Created on    : 2026-04-30
*& Description   :
*&---------------------------------------------------------------------*
*& [## ## / Modification Log]
*&---------------------------------------------------------------------*
*& ##        | ###       | ## ##
*&---------------------------------------------------------------------*
*& 2026-04-30  | ###       | ## ##
*& 2026-05-01  | ###       | 100# ### # 110# ## ##
*& 2026-05-06  | ###       | #### # #### ##### ## ##
*& 2026-06-24  | ###       | DB Insert Update # ###, # ## # ## ##
*&---------------------------------------------------------------------*
REPORT zrb1mm0002.

include zb1mm0002_top.
include zb1mm0002_c01.
include zb1mm0002_o01.
include zb1mm0002_i01.
include zb1mm0002_f01.

INITIALIZATION.
so_pono-sign   = 'I'.
  so_pono-option = 'BT'.
  so_pono-low    = '4500000001'.
  so_pono-high   = '4500099999'.
  APPEND so_pono.
  CLEAR  so_pono.

  so_apno-sign   = 'I'.
  so_apno-option = 'BT'.
  so_apno-low    = 'APP0000001'.
  so_apno-high   = 'APP0099999'.
  APPEND so_apno.
  CLEAR  so_apno.

  so_podat-sign   = 'I'.
  so_podat-option = 'BT'.
  so_podat-low    = '20260101'.
  so_podat-high   = sy-datum.
  APPEND so_podat.
  CLEAR  so_podat.

AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN.

START-OF-SELECTION.
  PERFORM get_data.
  IF gt_data IS INITIAL.
    EXIT.
  ENDIF.

  CALL SCREEN '0100'.

END-OF-SELECTION.

*GUI Texts
*----------------------------------------------------------
* T100 --> [C-NERGY] #### ##/## ####
* T110 --> [C-NERGY] #### #### ##
* T120 --> #### ##

*Text elements
*----------------------------------------------------------
* T01 ## ##


*Selection texts
*----------------------------------------------------------
* PA_STAT         ## ##
* SO_APDAT         ###
* SO_APNO         ####
* SO_PODAT         ###
* SO_PONO         ######


*Messages
*----------------------------------------------------------
*
* Message class: Hard coded
*   ####, ###, ##### ## ## #####.
*
* Message class: ZMCB1
*010   ## ### ## &1 #(#) ####
*022   &1#(#) #### #####.
*026   &1 ### #######
