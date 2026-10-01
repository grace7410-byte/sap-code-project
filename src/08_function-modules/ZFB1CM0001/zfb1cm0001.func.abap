*&---------------------------------------------------------------------*
*& Program ID    : ZFB1CM0001
*& Program Name  : [B1] ### ##### #### ##
*& Created by    : ###
*& Created on    : 2026-04-08.
*& Description   :
*& ITAB# ## ##. ## DB #### ### ### ##
*& ### #### ERNAM ~ AEZET##
*& ##### ## ## 6## ## #### changing## ####
*& 1. ## ## ### #### ##(## ##) -> ##/## ## ## 6# ####
*& 2. ## ## ### ## ## ##(####) ->     ## ## ## 3# ####
*&
*&----------------------------------------------------------------------
*&[## ## / Modification Log]
*&---------------------------------------------------------------------*
*& ##           | ###       | ## ##
*&---------------------------------------------------------------------*
*& 2026-04-08 | ### | ## ##
*& 2026-04-09 | ### | ## # #### README ## ##. ## ##(CM)## ##
*& 2026. 5.11.| ### | ### ## ##(## ##### ## ## ## ##)
*& 2026. 6. 9.| ### | ### ##. ## #### ## ## ### # ##
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*

*       Global data declarations

FUNCTION zfb1cm0001.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  CHANGING
*"     REFERENCE(CT_TABLE) TYPE  TABLE
*"----------------------------------------------------------------------
  FIELD-SYMBOLS: <row> TYPE any,
                 <col> TYPE any.

  LOOP AT ct_table ASSIGNING <row>.
    " <row># ERNAM## ### ##### ## ### ## ##
    " ### ### ##### '####'# '####'# ##
    ASSIGN COMPONENT 'ERNAM' OF STRUCTURE <row> TO <col>.
    IF sy-subrc = 0 AND <col> IS INITIAL. <col> = sy-uname. ENDIF.

    ASSIGN COMPONENT 'ERDAT' OF STRUCTURE <row> TO <col>.
    IF sy-subrc = 0 AND <col> IS INITIAL. <col> = sy-datum. ENDIF.

    ASSIGN COMPONENT 'ERZET' OF STRUCTURE <row> TO <col>.
    " erzet# #### ## -> ##### ##
    IF sy-subrc = 0 AND <col> IS INITIAL. <col> = sy-uzeit. ENDIF.

    " ### function module# #### ### ### ##
    ASSIGN COMPONENT 'AENAM' OF STRUCTURE <row> TO <col>.
    IF sy-subrc = 0. <col> = sy-uname. ENDIF.

    ASSIGN COMPONENT 'AEDAT' OF STRUCTURE <row> TO <col>.
    IF sy-subrc = 0. <col> = sy-datum. ENDIF.

    ASSIGN COMPONENT 'AEZET' OF STRUCTURE <row> TO <col>.
    IF sy-subrc = 0. <col> = sy-uzeit. ENDIF.
  ENDLOOP.

ENDFUNCTION.
