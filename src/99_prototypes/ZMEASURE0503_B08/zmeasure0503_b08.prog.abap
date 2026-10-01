*&---------------------------------------------------------------------*
*& Report      ZRB1MM0001
*&---------------------------------------------------------------------*
*& Program ID    : ZRB1MM0001
*& Program Name  : ## ## ## ####
*& Created by    : ###
*& Created on    : 2026-04-16
*& Description   : ## # ## ### ## ### ## ## (## ###### ##)
*&                 ##, ## # ## ### ### ## ## ## ## ##
*&---------------------------------------------------------------------*
*& [## ## / Modification Log]
*&---------------------------------------------------------------------*
*& ##        | ###       | ## ##
*&---------------------------------------------------------------------*
*& 2026-04-16  | ###       | ## ##
*& 2026-04-21  | ###       | 100# ### ALV ## ## ##
*& 2026-04-22  | ###       | 200# ### ## ##
*& 2026-04-22  | ###       | 200# ### ALV ## ##(##) -> ## 100## ##
*& 2026-04-23  | ###       |
*& 2026-04-24  | ###       |
*& 2026-04-27  | ###       | #### ##(###->### / ## #####: SAPMZB1MM0003)
*&                            ## ### ###(->1000#, 100#), #### ALV
*& 2026-04-28  | ###       | 100# ### ALV ## ##(##, ##) # #### ###
*& 2026-04-30  | ###       |
*& 2026-05-03  | ###       |
*&---------------------------------------------------------------------*
REPORT zmeasure0503_b08.

include ZMEASURE0503_B08_TOP.
*INCLUDE ZB1MM0001_COPY_TOP.
*INCLUDE zb1mm0001_top.
include ZMEASURE0503_B08_C01.
*INCLUDE ZB1MM0001_COPY_C01.
*INCLUDE zb1mm0001_c01.
include ZMEASURE0503_B08_O01.
*INCLUDE ZB1MM0001_COPY_O01.
*INCLUDE zb1mm0001_o01.
include ZMEASURE0503_B08_I01.
*INCLUDE ZB1MM0001_COPY_I01.
*INCLUDE zb1mm0001_i01.
include ZMEASURE0503_B08_F01.
*INCLUDE ZB1MM0001_COPY_F01.
*INCLUDE zb1mm0001_f01.

INITIALIZATION.
  "pa_typ = 'SO'.
  "pa_mat = 'GAS-300'.

*  so_doc-sign   = 'I'.
*  so_doc-option = 'BT'.
*  so_doc-low    = 'SO00000001'.
*  so_doc-high   = 'SO90000099'.
*  APPEND so_doc.

  so_dat-sign   = 'I'.
  so_dat-option = 'BT'.
  so_dat-low    = sy-datum - 100.
  so_dat-high   = sy-datum.      " ##
  APPEND so_dat.

  so_wks-sign   = 'I'.
  so_wks-option = 'EQ'.
  so_wks-low    = '1000'.
  so_wks-high   = '1000'.
  APPEND so_wks.

  so_lgt-sign   = 'I'.
  so_lgt-option = 'EQ'.
  so_lgt-low    = '1000'.
  so_lgt-high    = '5000'.
  APPEND so_lgt.



AT SELECTION-SCREEN OUTPUT.



AT SELECTION-SCREEN.
  " ## ### #### # => ## #### ##### ## ### #####
  PERFORM check_high_only USING so_doc[] '## ##'.
  PERFORM check_high_only USING so_dat[] '###'.
  PERFORM check_high_only USING so_wks[] '###'.
  PERFORM check_high_only USING so_lgt[] '####'.

  " ##### ### ### ### ##X =? ### &1 &2 &3 &4 #(#) #### ####
  PERFORM check_wrong_values. "### ### ##, ### # ##



START-OF-SELECTION.
  PERFORM get_header_data . " #### ## ##
  PERFORM get_item_data.
  IF gt_head IS INITIAL. " ## ### ## #### ##
    MESSAGE s019(zmcb1) DISPLAY LIKE 'E'. " ### #### ####.
    EXIT.
  ENDIF.
  "PERFORM set_display_info. " #### ### ## ## ### ###
  CALL SCREEN '0100'. " #### ## ## ## ##

END-OF-SELECTION.

*GUI Texts
*----------------------------------------------------------
* T100 --> ## ## ## ####
* T200 --> ## ## ## ## ####

*Text elements
*----------------------------------------------------------
* T01 ## (##/##/##)## ## ##


*Selection texts
*----------------------------------------------------------
* PA_MAT         ## ##
* PA_TYP         ## ##
* SO_DAT         ###
* SO_DOC         ## ##
* SO_LGT         ####
* SO_WKS         ###


*Messages
*----------------------------------------------------------
*
* Message class: Hard coded
*   # ## # ## ## #####.
*
* Message class: ZMCB1
*002   ### &1&2&3&4 #(#) #### ####.
*010   ## ### ## &1 #(#) ####
*011   ## #### ##### ## ### #####
*013   &1 ### ### ####
*019   ### &1 #### ####
*022   &1#(#) #### #####.
*023   &1 ## ## &2# #######
*031   PDF ## &1# ##### #######.
*032   ## #### ## #####.
