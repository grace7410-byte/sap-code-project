FUNCTION ZFB1MM0001.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_MBLNR) TYPE  ZEB1_MM_MBLNR
*"  CHANGING
*"     REFERENCE(CS_MM0011) TYPE  ZTB1MM0011 OPTIONAL
*"     REFERENCE(CS_MM0023) TYPE  ZTB1MM0023 OPTIONAL
*"     REFERENCE(CS_MM0024) TYPE  ZTB1MM0024 OPTIONAL
*"  EXCEPTIONS
*"      INVALID_INPUT_DATA
*"      ERROR_MODIFY_MM0001
*"      ERROR_MODIFY_MM0003
*"      INVALID_MM0001_DATA
*"      INVALID_MM0003_DATA
*"      INVALID_MM0011_DATA
*"      INVALID_MM0012_DATA
*"      MBLNR_MM0023_EXIST
*"      ERROR_INSERT_MM0023
*"      ERROR_INSERT_MM0024
*"      NO_INPUT_MM0001
*"      NO_INPUT_MM0003
*"      NO_INPUT_MM0023
*"      NO_INPUT_MM0024
*"----------------------------------------------------------------------

*       Global data declarations

  DATA : LT_MM0003 TYPE TABLE OF ZTB1MM0003,
         LT_MM0001 TYPE TABLE OF ZTB1MM0001,
         LS_MM0011 TYPE ZTB1MM0011,
         LT_MM0012 TYPE TABLE OF ZCDS_B1_FI_0047,
         LT_MM0023 TYPE TABLE OF ZTB1MM0023,
         LT_MM0024 TYPE TABLE OF ZTB1MM0024.

  DATA : LV_LOG_ID TYPE ZEB1_MM_LOG_ID.

  DATA : LV_CHAR TYPE C LENGTH 6.

  DATA : LV_DMBTR_BEF  TYPE ZEB1_MM_SALK3,
         LV_DMBTR      TYPE ZEB1_MM_SALK3,
         LV_DMBTR_DIFF TYPE ZEB1_MM_SALK3.

  DATA : LV_VERPR_BEF  TYPE ZEB1_MM_VERPR,
         LV_VERPR      TYPE ZEB1_MM_VERPR,
         LV_VERPR_DIFF TYPE ZEB1_MM_VERPR.

  IF I_MBLNR IS NOT INITIAL.

    "### ## => ## ## ### #### ##, ## ##.
    SELECT SINGLE *
      FROM ZTB1MM0023
     WHERE MBLNR = @I_MBLNR
       AND LVORM IS INITIAL
      INTO CORRESPONDING FIELDS OF @CS_MM0023.

    IF SY-SUBRC = 0.
      RAISE MBLNR_MM0023_EXIST.
    ENDIF.

    SELECT
      FROM ZCDS_B1_FI_0047
    FIELDS *
     WHERE MBLNR = @I_MBLNR
      INTO CORRESPONDING FIELDS OF TABLE @LT_MM0012.

    IF SY-SUBRC <> 0.
      RAISE INVALID_MM0012_DATA.
    ENDIF.

    SELECT  MATNR, WERKS, LGORT, MEINS, LABST, AVSTK, SPEME, INSME, TRAME, SALK3, WAERSK,
            ERNAM, ERDAT, ERZET, AENAM, AEDAT, AEZET
      FROM ZTB1MM0003
    FOR ALL ENTRIES IN @LT_MM0012
     WHERE MATNR = @LT_MM0012-MATNR
       AND LGORT = @LT_MM0012-LGORT
       AND LVORM IS INITIAL
      INTO CORRESPONDING FIELDS OF TABLE @LT_MM0003.

    IF SY-SUBRC <> 0.
      RAISE INVALID_MM0003_DATA.
    ENDIF.

    SELECT MATNR, MTART, SPART, MEINS, BKLAS, BESKZ, KZKUP, ART, STRGR, MTVFP, PLIFZ, VERPR, WAERSK,
            LVORM, ERNAM, ERDAT, ERZET, AENAM, AEDAT, AEZET
      FROM ZTB1MM0001
    FOR ALL ENTRIES IN @LT_MM0012
     WHERE MATNR = @LT_MM0012-MATNR
       AND LVORM IS INITIAL
      INTO CORRESPONDING FIELDS OF TABLE @LT_MM0001.

    IF SY-SUBRC <> 0.
      RAISE INVALID_MM0001_DATA.
    ENDIF.

    LOOP AT LT_MM0012 ASSIGNING FIELD-SYMBOL(<FS_MM0012>).
      ASSIGN COMPONENT 'MATNR' OF STRUCTURE <FS_MM0012> TO FIELD-SYMBOL(<LV_MATNR>).
      ASSIGN COMPONENT 'WERKS' OF STRUCTURE <FS_MM0012> TO FIELD-SYMBOL(<LV_WERKS>).
      ASSIGN COMPONENT 'LGORT' OF STRUCTURE <FS_MM0012> TO FIELD-SYMBOL(<LV_LGORT>).
      ASSIGN COMPONENT 'BWART' OF STRUCTURE <FS_MM0012> TO FIELD-SYMBOL(<LV_BWART>).

      "## ## ###, ## ####
      READ TABLE LT_MM0001 WITH KEY MATNR = <LV_MATNR> ASSIGNING FIELD-SYMBOL(<FS_MM0001>).
      ASSIGN COMPONENT 'MTART' OF STRUCTURE <FS_MM0001> TO FIELD-SYMBOL(<LV_MTART>).
      ASSIGN COMPONENT 'SALK3' OF STRUCTURE <FS_MM0001> TO FIELD-SYMBOL(<LV_SALK3>).

      READ TABLE LT_MM0003 WITH KEY MATNR = <LV_MATNR> LGORT = <LV_LGORT> ASSIGNING FIELD-SYMBOL(<FS_MM0003>).

      CALL FUNCTION 'NUMBER_GET_NEXT'
        EXPORTING
          NR_RANGE_NR = 'A1'
          OBJECT      = 'ZNRB1MM07'
        IMPORTING
          NUMBER      = LV_LOG_ID.

      "MM0023 ## ###
      CS_MM0023 = CORRESPONDING #( <FS_MM0012> EXCEPT ERDAT ERNAM ERZET ).
      CS_MM0023 = VALUE #( BASE CS_MM0023 LOG_ID = LV_LOG_ID ).

      CASE <LV_BWART>.
        WHEN '101'.
          IF <LV_MTART> = 'ROH' OR <LV_MTART> = 'HIBE'.                                         "## ##
            "## ### ##
            CS_MM0023 = VALUE #( BASE CS_MM0023 MTART = <LV_MTART> PROC_GRP = 'PUR'
                                      PROCTP = 'SI' CHG_DATE = <FS_MM0012>-BLDAT ).

            "### ### ##

            "##### ##
            LV_DMBTR_BEF = <FS_MM0003>-SALK3.
            LV_DMBTR = LV_DMBTR_BEF + <FS_MM0012>-DMBTR.
            LV_DMBTR_DIFF = LV_DMBTR - LV_DMBTR_BEF.


            "### ##
            CS_MM0024 = VALUE #( ITEM_NO = 10 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "#### ##
            CS_MM0024-INSMK = 'E'.
            LV_CHAR = 'LABST'.
            PERFORM PLUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.

            "## ####(# #### ## ### ### ####)
            LV_VERPR_BEF = <FS_MM0001>-VERPR.
            LV_VERPR = CS_MM0024-DMBTR / CS_MM0024-MENGE.
            LV_VERPR_DIFF = LV_VERPR - LV_VERPR_BEF.

            CS_MM0024 = VALUE #( BASE CS_MM0024 VERPR_BEF = LV_VERPR_BEF
                                                 VERPR = LV_VERPR
                                                 VERPR_DIFF = LV_VERPR_DIFF ).

            "MM03 # #### ####
            <FS_MM0003>-SALK3 = CS_MM0024-DMBTR.
            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

            "### ##(## ## ### ##)
            CS_MM0024 = VALUE #( ITEM_NO = 20 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              VERPR_BEF = LV_VERPR_BEF VERPR = LV_VERPR VERPR_DIFF = LV_VERPR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "### ### ##
            CS_MM0024-INSMK = 'T'.
            LV_CHAR = 'TRAME'.
            PERFORM PLUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.


            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

            "## ## ####
            <FS_MM0001>-VERPR = LV_VERPR.


          ELSEIF <LV_MTART> = 'HALB' OR <LV_MTART> = 'FERT'.                              "## ## ##

            "## ### ##
            CS_MM0023 = VALUE #( BASE CS_MM0023 MTART = <LV_MTART> PROC_GRP = 'PROD'
                                      PROCTP = 'PR' CHG_DATE = <FS_MM0012>-BLDAT ).

            "### ### ##

            "##### ##
            LV_DMBTR_BEF = <FS_MM0003>-SALK3.
            LV_DMBTR = LV_DMBTR_BEF + <FS_MM0012>-TOTALCOST.
            LV_DMBTR_DIFF = LV_DMBTR - LV_DMBTR_BEF.

            "### ##
            CS_MM0024 = VALUE #( ITEM_NO = 10 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "#### ##
            CS_MM0024-INSMK = 'E'.
            LV_CHAR = 'LABST'.
            PERFORM PLUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.

            "## ####(# #### ## ### ### ####)
            LV_VERPR_BEF = <FS_MM0001>-VERPR.
            LV_VERPR = CS_MM0024-DMBTR / CS_MM0024-MENGE.
            LV_VERPR_DIFF = LV_VERPR - LV_VERPR_BEF.

            CS_MM0024 = VALUE #( BASE CS_MM0024 VERPR_BEF = LV_VERPR_BEF
                                                 VERPR = LV_VERPR
                                                 VERPR_DIFF = LV_VERPR_DIFF ).

            "MM03 # #### ####
            <FS_MM0003>-SALK3 = CS_MM0024-DMBTR.
            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

            "### ##(## ## ### ##)
            CS_MM0024 = VALUE #( ITEM_NO = 20 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              VERPR_BEF = LV_VERPR_BEF VERPR = LV_VERPR VERPR_DIFF = LV_VERPR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "##### ##
            CS_MM0024-INSMK = 'A'.
            LV_CHAR = 'AVSTK'.
            PERFORM PLUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.


            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

            "## ## ####
            <FS_MM0001>-VERPR = LV_VERPR.

          ELSE.
          ENDIF.
        WHEN '261'.
          IF <LV_MTART> = 'ROH' OR <LV_MTART> = 'HIBE' OR <LV_MTART> = 'HALB'.                                        "## ## ##
            "## ### ##
            CS_MM0023 = VALUE #( BASE CS_MM0023 MTART = <LV_MTART> PROC_GRP = 'PROD'
                                      PROCTP = 'PG' CHG_DATE = <FS_MM0012>-BLDAT ).

            "### ### ##

            "##### ##
            LV_DMBTR_BEF = <FS_MM0003>-SALK3.
            LV_DMBTR = LV_DMBTR_BEF - <FS_MM0012>-DMBTR.
            LV_DMBTR_DIFF = LV_DMBTR - LV_DMBTR_BEF.

            "### ##
            CS_MM0024 = VALUE #( ITEM_NO = 10 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "#### ##
            CS_MM0024-INSMK = 'E'.
            LV_CHAR = 'LABST'.
            PERFORM MINUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.

            "## ####(# #### ## ### ### ####)
            LV_VERPR_BEF = <FS_MM0001>-VERPR.
            LV_VERPR = CS_MM0024-DMBTR / CS_MM0024-MENGE.
            LV_VERPR_DIFF = LV_VERPR - LV_VERPR_BEF.

            CS_MM0024 = VALUE #( BASE CS_MM0024 VERPR_BEF = LV_VERPR_BEF
                                                 VERPR = LV_VERPR
                                                 VERPR_DIFF = LV_VERPR_DIFF ).

            "MM03 # #### ####
            <FS_MM0003>-SALK3 = CS_MM0024-DMBTR.
            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

            "### ##(## ## ### ##)
            CS_MM0024 = VALUE #( ITEM_NO = 20 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              VERPR_BEF = LV_VERPR_BEF VERPR = LV_VERPR VERPR_DIFF = LV_VERPR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "## ### ##
            CS_MM0024-INSMK = 'A'.
            LV_CHAR = 'AVSTK'.
            PERFORM MINUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.


            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

            "## ## ####
            <FS_MM0001>-VERPR = LV_VERPR.

          ENDIF.
        WHEN '311'.
          IF <LV_MTART> = 'FERT'.                                                                 "#### ##### ### ##
            "## ### ##
            CS_MM0023 = VALUE #( BASE CS_MM0023 MTART = <LV_MTART> PROC_GRP = 'SALE'
                                                PROCTP = 'SM' CHG_DATE = <FS_MM0012>-BLDAT ).

            "### ### ##

*            ##### ##
            LV_DMBTR_BEF = <FS_MM0003>-SALK3.
            LV_DMBTR = LV_DMBTR_BEF - <FS_MM0012>-DMBTR.
            LV_DMBTR_DIFF = LV_DMBTR - LV_DMBTR_BEF.

            "### ##
            CS_MM0024 = VALUE #( ITEM_NO = 10 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "## #### ##
            CS_MM0024-INSMK = 'E'.
            LV_CHAR = 'LABST'.
            PERFORM MINUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.

            "## ####(# #### ## ### ### ####)
            LV_VERPR_BEF = <FS_MM0001>-VERPR.
            LV_VERPR = CS_MM0024-DMBTR / CS_MM0024-MENGE.
            LV_VERPR_DIFF = LV_VERPR - LV_VERPR_BEF.

            CS_MM0024 = VALUE #( BASE CS_MM0024 VERPR_BEF = LV_VERPR_BEF
                                                 VERPR = LV_VERPR
                                                 VERPR_DIFF = LV_VERPR_DIFF ).

            "MM03 # #### ####
            <FS_MM0003>-SALK3 = CS_MM0024-DMBTR.
            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

            "### ##(## ## ### ##)
            CS_MM0024 = VALUE #( ITEM_NO = 20 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              VERPR_BEF = LV_VERPR_BEF VERPR = LV_VERPR VERPR_DIFF = LV_VERPR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "## ## ### ##
            CS_MM0024-INSMK = 'A'.
            LV_CHAR = 'AVSTK'.
            PERFORM MINUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.

            "## ####
            CS_MM0024-VERPR_BEF = <FS_MM0001>-VERPR.
            CS_MM0024-VERPR = CS_MM0024-DMBTR / CS_MM0024-MENGE.
            CS_MM0024-VERPR_DIFF = CS_MM0024-VERPR - CS_MM0024-VERPR_BEF.

            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

            "## ## ####
            <FS_MM0001>-VERPR = LV_VERPR.

          ENDIF.
        WHEN '321'.
          IF <LV_MTART> = 'ROH'.                                                                "### ##
            "## ### ##
            CS_MM0023 = VALUE #( BASE CS_MM0023 MTART = <LV_MTART> PROC_GRP = 'PUR'
                                      PROCTP = 'PI' CHG_DATE = <FS_MM0012>-BLDAT ).

            "### ### ##

            "##### ## ##
            LV_DMBTR_BEF = <FS_MM0003>-SALK3.
            LV_DMBTR = LV_DMBTR_BEF.
            LV_DMBTR_DIFF = LV_DMBTR - LV_DMBTR_BEF.

            "### ##
            CS_MM0024 = VALUE #( ITEM_NO = 10 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "## # ## ## ##
            CS_MM0024-INSMK = 'T'.
            LV_CHAR = 'TRAME'.
            PERFORM MINUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.

            "## ## ##.
            LV_VERPR_BEF = <FS_MM0001>-VERPR.
            LV_VERPR = LV_VERPR_BEF.
            LV_VERPR_DIFF = LV_VERPR - LV_VERPR_BEF.

            CS_MM0024 = VALUE #( BASE CS_MM0024 VERPR_BEF = LV_VERPR_BEF
                                                 VERPR = LV_VERPR
                                                 VERPR_DIFF = LV_VERPR_DIFF ).

            "MM03 # #### ####
            <FS_MM0003>-SALK3 = CS_MM0024-DMBTR.
            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

            "### ##(## ## ### ##)
            CS_MM0024 = VALUE #( ITEM_NO = 20 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              VERPR_BEF = LV_VERPR_BEF VERPR = LV_VERPR VERPR_DIFF = LV_VERPR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "## ### ##
            CS_MM0024-INSMK = 'S'.
            LV_CHAR = 'SPEME'.
            PERFORM PLUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.

            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

            "## ## ####(## ## ##)
*            <FS_MM0001>-VERPR = <FS_MM0003>-SALK3 / <FS_MM0003>-LABST.
          ELSEIF <LV_MTART> = 'HIBE'.
            "## ### ##
            CS_MM0023 = VALUE #( BASE CS_MM0023 MTART = <LV_MTART> PROC_GRP = 'PUR'
                                      PROCTP = 'PI' CHG_DATE = <FS_MM0012>-BLDAT ).

            "### ### ##

            "##### ## ##
            LV_DMBTR_BEF = <FS_MM0003>-SALK3.
            LV_DMBTR = LV_DMBTR_BEF.
            LV_DMBTR_DIFF = LV_DMBTR - LV_DMBTR_BEF.

            "### ##
            CS_MM0024 = VALUE #( ITEM_NO = 10 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "## # ## ## ##
            CS_MM0024-INSMK = 'T'.
            LV_CHAR = 'TRAME'.
            PERFORM MINUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.

            "## ## ##.
            LV_VERPR_BEF = <FS_MM0001>-VERPR.
            LV_VERPR = LV_VERPR_BEF.
            LV_VERPR_DIFF = LV_VERPR - LV_VERPR_BEF.

            CS_MM0024 = VALUE #( BASE CS_MM0024 VERPR_BEF = LV_VERPR_BEF
                                                 VERPR = LV_VERPR
                                                 VERPR_DIFF = LV_VERPR_DIFF ).

            "MM03 # #### ####
            <FS_MM0003>-SALK3 = CS_MM0024-DMBTR.
            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

            "### ##(## ## ### ##)
            CS_MM0024 = VALUE #( ITEM_NO = 20 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              VERPR_BEF = LV_VERPR_BEF VERPR = LV_VERPR VERPR_DIFF = LV_VERPR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "## ### ##
            CS_MM0024-INSMK = 'A'.
            LV_CHAR = 'AVSTK'.
            PERFORM PLUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.

            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

            "## ## ####(## ## ##)
*            <FS_MM0001>-VERPR = <FS_MM0003>-SALK3 / <FS_MM0003>-LABST.

          ELSEIF <LV_MTART> = 'FERT'.                                                             "### ##### ##
            "## ### ##
            CS_MM0023 = VALUE #( BASE CS_MM0023 MTART = <LV_MTART> PROC_GRP = 'SALE'
                                                PROCTP = 'SA' CHG_DATE = <FS_MM0012>-BLDAT ).

            "### ### ##

            "##### ##
            LV_DMBTR_BEF = <FS_MM0003>-SALK3.
            LV_DMBTR = LV_DMBTR_BEF + <FS_MM0012>-DMBTR.
            LV_DMBTR_DIFF = LV_DMBTR - LV_DMBTR_BEF.

            "### ##
            CS_MM0024 = VALUE #( ITEM_NO = 10 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "#### #### ##
            CS_MM0024-INSMK = 'E'.
            LV_CHAR = 'LABST'.
            PERFORM PLUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.

            "## #### ##
            LV_VERPR_BEF = <FS_MM0001>-VERPR.
            LV_VERPR = LV_VERPR_BEF.
            LV_VERPR_DIFF = LV_VERPR - LV_VERPR_BEF.

            CS_MM0024 = VALUE #( BASE CS_MM0024 VERPR_BEF = LV_VERPR_BEF
                                                 VERPR = LV_VERPR
                                                 VERPR_DIFF = LV_VERPR_DIFF ).

            "MM03 # #### ####
            <FS_MM0003>-SALK3 = CS_MM0024-DMBTR.
            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

            "### ##(## ## ### ##)
            CS_MM0024 = VALUE #( ITEM_NO = 20 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              VERPR_BEF = 0 VERPR = 0 VERPR_DIFF = 0
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "#### ## ### ##
            CS_MM0024-INSMK = 'A'.
            LV_CHAR = 'AVSTK'.
            PERFORM PLUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.


            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

            "## ## #### ##

          ENDIF.


        WHEN '551'.
          IF <LV_MTART> = 'ROH' OR <LV_MTART> = 'HIBE'.                                                                    "## ##
            "## ### ##
            CS_MM0023 = VALUE #( BASE CS_MM0023 MTART = <LV_MTART> PROC_GRP = 'PUR'
                                      PROCTP = 'PS' CHG_DATE = <FS_MM0012>-BLDAT ).

            "### ### ##

            "##### ##
            LV_DMBTR_BEF = <FS_MM0003>-SALK3.
            LV_DMBTR = LV_DMBTR_BEF - <FS_MM0012>-DMBTR.
            LV_DMBTR_DIFF = LV_DMBTR - LV_DMBTR_BEF.

            "### ##
            CS_MM0024 = VALUE #( ITEM_NO = 10 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "# ## ##
            CS_MM0024-INSMK = 'E'.
            LV_CHAR = 'LABST'.
            PERFORM MINUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.

            "## ####(# #### ## ### ### ####)
            LV_VERPR_BEF = <FS_MM0001>-VERPR.
            LV_VERPR = CS_MM0024-DMBTR / CS_MM0024-MENGE.
            LV_VERPR_DIFF = LV_VERPR - LV_VERPR_BEF.

            CS_MM0024 = VALUE #( BASE CS_MM0024 VERPR_BEF = LV_VERPR_BEF
                                                 VERPR = LV_VERPR
                                                 VERPR_DIFF = LV_VERPR_DIFF ).

            "MM03 # #### ####
            <FS_MM0003>-SALK3 = CS_MM0024-DMBTR.
            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

            "### ##(## ## ### ##)
            CS_MM0024 = VALUE #( ITEM_NO = 20 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              VERPR_BEF = LV_VERPR_BEF VERPR = LV_VERPR VERPR_DIFF = LV_VERPR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "## # ### ##
            CS_MM0024-INSMK = 'T'.
            LV_CHAR = 'TRAME'.
            PERFORM MINUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.

            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

            "## ## ####
            <FS_MM0001>-VERPR = LV_VERPR.

          ENDIF.
        WHEN '411'.
          IF <LV_MTART> = 'ROH'.                                                              "### ##
            "## ### ##
            CS_MM0023 = VALUE #( BASE CS_MM0023 MTART = <LV_MTART> PROC_GRP = 'PROD'
                                      PROCTP = 'PA' CHG_DATE = <FS_MM0012>-BLDAT ).

            "### ### ##

            "##### ## ##
            LV_DMBTR_BEF = <FS_MM0003>-SALK3.
            LV_DMBTR = LV_DMBTR_BEF.
            LV_DMBTR_DIFF = LV_DMBTR - LV_DMBTR_BEF.

            "### ##
            CS_MM0024 = VALUE #( ITEM_NO = 10 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "## ## ##
            CS_MM0024-INSMK = 'S'.
            LV_CHAR = 'SPEME'.
            PERFORM MINUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.

            "## ## ##.
            LV_VERPR_BEF = <FS_MM0001>-VERPR.
            LV_VERPR = LV_VERPR_BEF.
            LV_VERPR_DIFF = LV_VERPR - LV_VERPR_BEF.

            CS_MM0024 = VALUE #( BASE CS_MM0024 VERPR_BEF = LV_VERPR_BEF
                                                 VERPR = LV_VERPR
                                                 VERPR_DIFF = LV_VERPR_DIFF ).

            "MM03 # #### ## ##.
            <FS_MM0003>-SALK3 = CS_MM0024-DMBTR.

            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

            "### ##(## ## ### ##)
            CS_MM0024 = VALUE #( ITEM_NO = 20 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              VERPR_BEF = LV_VERPR_BEF VERPR = LV_VERPR VERPR_DIFF = LV_VERPR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "## ## ### ##
            CS_MM0024-INSMK = 'I'.
            LV_CHAR = 'INSME'.
            PERFORM PLUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.

            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

            "## ## ####(## ## ##)
*            <FS_MM0001>-VERPR = <FS_MM0003>-SALK3 / <FS_MM0003>-LABST.
          ENDIF.
        WHEN '421'.                                                                               "### ## ##
          IF <LV_MTART> = 'ROH'.
            "## ### ##
            CS_MM0023 = VALUE #( BASE CS_MM0023 MTART = <LV_MTART> PROC_GRP = 'PROD'
                                      PROCTP = 'PB' CHG_DATE = <FS_MM0012>-BLDAT ).

            "### ### ##

            "##### ## ##
            LV_DMBTR_BEF = <FS_MM0003>-SALK3.
            LV_DMBTR = LV_DMBTR_BEF.
            LV_DMBTR_DIFF = LV_DMBTR - LV_DMBTR_BEF.

            "### ##
            CS_MM0024 = VALUE #( ITEM_NO = 10 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "## ## ## ##
            CS_MM0024-INSMK = 'I'.
            LV_CHAR = 'INSME'.
            PERFORM MINUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.

            "## ## ##.
            LV_VERPR_BEF = <FS_MM0001>-VERPR.
            LV_VERPR = LV_VERPR_BEF.
            LV_VERPR_DIFF = LV_VERPR - LV_VERPR_BEF.

            CS_MM0024 = VALUE #( BASE CS_MM0024 VERPR_BEF = LV_VERPR_BEF
                                                 VERPR = LV_VERPR
                                                 VERPR_DIFF = LV_VERPR_DIFF ).

            "MM03 # #### ## ##.
            <FS_MM0003>-SALK3 = CS_MM0024-DMBTR.

            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

            "### ##(## ## ### ##)
            CS_MM0024 = VALUE #( ITEM_NO = 20 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              VERPR_BEF = LV_VERPR_BEF VERPR = LV_VERPR VERPR_DIFF = LV_VERPR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "## ### ##
            CS_MM0024-INSMK = 'A'.
            LV_CHAR = 'AVSTK'.
            PERFORM PLUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.

            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.


          ENDIF.
        WHEN '431'.                                                                                 "### ## ##
          IF <LV_MTART> = 'ROH'.
            "## ### ##
            CS_MM0023 = VALUE #( BASE CS_MM0023 MTART = <LV_MTART> PROC_GRP = 'PROD'
                                      PROCTP = 'PC' CHG_DATE = <FS_MM0012>-BLDAT ).

            "### ### ##

            "##### ## ##
            LV_DMBTR_BEF = <FS_MM0003>-SALK3.
            LV_DMBTR = LV_DMBTR_BEF.
            LV_DMBTR_DIFF = LV_DMBTR - LV_DMBTR_BEF.

            "### ##
            CS_MM0024 = VALUE #( ITEM_NO = 10 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "## ## ## ##
            CS_MM0024-INSMK = 'I'.
            LV_CHAR = 'INSME'.
            PERFORM MINUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.

            "## ## ##.
            LV_VERPR_BEF = <FS_MM0001>-VERPR.
            LV_VERPR = LV_VERPR_BEF.
            LV_VERPR_DIFF = LV_VERPR - LV_VERPR_BEF.

            CS_MM0024 = VALUE #( BASE CS_MM0024 VERPR_BEF = LV_VERPR_BEF
                                                 VERPR = LV_VERPR
                                                 VERPR_DIFF = LV_VERPR_DIFF ).

            "MM03 # #### ## ##.
            <FS_MM0003>-SALK3 = CS_MM0024-DMBTR.

            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

            "### ##(## ## ### ##)
            CS_MM0024 = VALUE #( ITEM_NO = 20 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              VERPR_BEF = LV_VERPR_BEF VERPR = LV_VERPR VERPR_DIFF = LV_VERPR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "## ### ##
            CS_MM0024-INSMK = 'S'.
            LV_CHAR = 'SPEME'.
            PERFORM PLUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.

            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.
          ENDIF.
        WHEN '601'.
          IF <LV_MTART> = 'FERT'.                                                               "### ##
            "## ### ##
            CS_MM0023 = VALUE #( BASE CS_MM0023 MTART = <LV_MTART> PROC_GRP = 'SALE'
                                      PROCTP = 'SO' CHG_DATE = <FS_MM0012>-BLDAT ).

            "### ### ##

            "##### ##
            LV_DMBTR_BEF = <FS_MM0003>-SALK3.
            LV_DMBTR = LV_DMBTR_BEF - <FS_MM0012>-DMBTR.
            LV_DMBTR_DIFF = LV_DMBTR - LV_DMBTR_BEF.

            "### ##
            CS_MM0024 = VALUE #( ITEM_NO = 10 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "#### ##
            CS_MM0024-INSMK = 'E'.
            LV_CHAR = 'LABST'.
            PERFORM MINUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.

            "## #### ##
            LV_VERPR_BEF = <FS_MM0001>-VERPR.
            LV_VERPR = LV_VERPR_BEF.
            LV_VERPR_DIFF = LV_VERPR - LV_VERPR_BEF.

            CS_MM0024 = VALUE #( BASE CS_MM0024 VERPR_BEF = LV_VERPR_BEF
                                     VERPR = LV_VERPR
                                     VERPR_DIFF = LV_VERPR_DIFF ).

            "MM03 # #### ####
            <FS_MM0003>-SALK3 = CS_MM0024-DMBTR.
            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

            "### ##(## ## ### ##)
            CS_MM0024 = VALUE #( ITEM_NO = 20 LOG_ID = LV_LOG_ID MATNR = <LV_MATNR> WERKS = <LV_WERKS> LGORT = <LV_LGORT>
                                              DMBTR_BEF = LV_DMBTR_BEF DMBTR = LV_DMBTR DMBTR_DIFF = LV_DMBTR_DIFF
                                              VERPR_BEF = 0 VERPR = 0 VERPR_DIFF = 0
                                              MEINS_BEF = 'BBL' MEINS = 'BBL' MEINS_DIFF = 'BBL'
                                              WAERSK_BEF = 'KRW' WAERSK = 'KRW' WAERSK_DIFF = 'KRW' ).

            "## ### ##
            CS_MM0024-INSMK = 'A'.
            LV_CHAR = 'AVSTK'.
            PERFORM MINUS_MM0024 USING LV_CHAR <FS_MM0012>-MENGE
                                CHANGING <FS_MM0003> CS_MM0024.

            APPEND CS_MM0024 TO LT_MM0024.
            CLEAR : CS_MM0024.

          ENDIF.
        WHEN OTHERS.
      ENDCASE.

      APPEND CS_MM0023 TO LT_MM0023.

    ENDLOOP.

    ZCL_B1_PP_TOOLBOX=>FILL_TIMESTAMP( CHANGING CV_DATA = LT_MM0001 ).
    ZCL_B1_PP_TOOLBOX=>FILL_TIMESTAMP( CHANGING CV_DATA = LT_MM0003 ).

    LOOP AT LT_MM0023 ASSIGNING FIELD-SYMBOL(<FS_MM0023>).
      <FS_MM0023> = VALUE #( BASE <FS_MM0023> ERNAM = SY-UNAME ERDAT = SY-DATUM ERZET = SY-UZEIT
                                              AENAM = SY-UNAME AEDAT = SY-DATUM AEZET = SY-UZEIT  ).
    ENDLOOP.

    LOOP AT LT_MM0024 ASSIGNING FIELD-SYMBOL(<FS_MM0024>).
      <FS_MM0024> = VALUE #( BASE <FS_MM0024> ERNAM = SY-UNAME ERDAT = SY-DATUM ERZET = SY-UZEIT
                                              AENAM = SY-UNAME AEDAT = SY-DATUM AEZET = SY-UZEIT  ).
    ENDLOOP.

    IF LT_MM0001 IS NOT INITIAL.
     MODIFY ZTB1MM0001 FROM TABLE LT_MM0001.
     IF SY-SUBRC <> 0.
       RAISE ERROR_MODIFY_MM0001.
     ENDIF.
   ELSE.
     RAISE NO_INPUT_MM0001.
   ENDIF.

    IF LT_MM0003 IS NOT INITIAL.
      MODIFY ZTB1MM0003 FROM TABLE LT_MM0003.
      IF SY-SUBRC <> 0.
        RAISE ERROR_MODIFY_MM0003.
      ENDIF.
    ELSE.
      RAISE NO_INPUT_MM0003.
    ENDIF.

    IF LT_MM0023 IS NOT INITIAL.
      INSERT ZTB1MM0023 FROM TABLE LT_MM0023 ACCEPTING DUPLICATE KEYS.
      IF SY-SUBRC <> 0.
        RAISE ERROR_INSERT_MM0023.
      ENDIF.
    ELSE.
      RAISE NO_INPUT_MM0023.
    ENDIF.

    IF LT_MM0024 IS NOT INITIAL.

      INSERT ZTB1MM0024 FROM TABLE LT_MM0024 ACCEPTING DUPLICATE KEYS.
      IF SY-SUBRC <> 0.
        RAISE ERROR_INSERT_MM0024.
      ENDIF.
    ELSE.
      RAISE NO_INPUT_MM0024.
    ENDIF.

  ELSE.

    RAISE INVALID_INPUT_DATA.

  ENDIF.

ENDFUNCTION.

FORM PLUS_MM0024 USING VALUE(PV_CHAR)
                       VALUE(PV_MENGE)
                 CHANGING VALUE(PS_MM0003) TYPE ZTB1MM0003
                          VALUE(CS_MM0024) TYPE ZTB1MM0024.

  FIELD-SYMBOLS : <LV_MENGE> TYPE ANY.
  ASSIGN COMPONENT PV_CHAR OF STRUCTURE PS_MM0003 TO <LV_MENGE>.



  CS_MM0024-MENGE_BEF = <LV_MENGE>.
  CS_MM0024-MENGE = CS_MM0024-MENGE_BEF + PV_MENGE.
  CS_MM0024-MENGE_DIFF = PV_MENGE.

  CS_MM0024-MEINS_BEF = 'BBL'.
  CS_MM0024-MEINS = 'BBL'.
  CS_MM0024-MEINS_DIFF = 'BBL'.

  "MM03 # ### ####
  <LV_MENGE> = CS_MM0024-MENGE.

ENDFORM.

FORM MINUS_MM0024 USING VALUE(PV_CHAR)
                         VALUE(PV_MENGE)
                 CHANGING VALUE(PS_MM0003) TYPE ZTB1MM0003
                          VALUE(CS_MM0024) TYPE ZTB1MM0024.

  FIELD-SYMBOLS : <LV_MENGE> TYPE ANY.
  ASSIGN COMPONENT PV_CHAR OF STRUCTURE PS_MM0003 TO <LV_MENGE>.



  CS_MM0024-MENGE_BEF = <LV_MENGE>.
  CS_MM0024-MENGE = CS_MM0024-MENGE_BEF - PV_MENGE.
  CS_MM0024-MENGE_DIFF = PV_MENGE * ( -1 ).

  CS_MM0024-MEINS_BEF = 'BBL'.
  CS_MM0024-MEINS = 'BBL'.
  CS_MM0024-MEINS_DIFF = 'BBL'.

  "MM03 # ### ####
  <LV_MENGE> = CS_MM0024-MENGE.

ENDFORM.


*Messages
*----------------------------------------------------------
*
* Message class: <LS_RETURN>-ID
*<LS
*
* Message class: ALE_MSGID
*ALE
*
* Message class: AM
*287   Address cannot be maintained; entry in table TSADRV missing
*290   Entry missing in TSADRV; new address maintenance cannot be called
*291   Entry missing in TSADRV; new address maintenance cannot be called
*298   Address group & not defined; delete flag for address not possible
*I_M
*
* Message class: EC
*089   Internal error (cannot read dynpro data)
*
* Message class: EINFO-MSG_ID
*EIN
*
* Message class: ERROR_INFO-MSG_ID
*ERR
*
* Message class: LO_DELTA_DATA_HANDLE
*LO_
*
* Message class: LO_LINE_AUTHORITY_ER
*LO_
*
* Message class: LO_SYNCHRONIZER_ERRO
*LO_
*
* Message class: PM_ID
*PM_
*
* Message class: SCPR
*026   Table & is too wide. It cannot be processed
*028   The table/view & has no generated maintenance dialog
*035   Dictionary interface error: Contact SAP
*120   Table/view & not found
*273   Function module call error
*320   BC Set processing error
*395   Internal field description read error
*399   No data record activation information
*408   Table key not supported by activation links
*
* Message class: SV
*000   &
*001   The selected function is not supported
*002   Number of retrieved entries: &
*004   No entries found that match the selection criteria.
*005   One entry chosen
*006   Number of chosen entries: &
*007   No previous entry exists
*008   No next entry exists
*009   An entry already exists with the same key
*010   An entry with this key is marked for deletion
*011   Number of deleted entries: &
*012   Number of changed entries: &
*013   Entry deleted
*014   Number of entries copied: &
*015   Target key must be different from source key
*016   Number of reset entries: &
*017   Entry reset
*018   Data was saved
*019   Select a key from the allowed namespace.
*024   Specify target entries
*025   Specify target entries.
*026   Select entries before performing the function.
*028   Table & not in DDIC
*032   Position the cursor on a valid entry
*033   Specify the key within the work area
*037   The maintenance dialog for & is incomplete or not defined
*039   Table & has no relevant fields
*040   & entries reset, & original and & new entries are still marked
*041   & entries reset, & original entries are still marked
*042   & entries reset, & new entries are still marked
*043   Data already saved
*044   Read access only
*045   Start date must lie before end date.
*046   End date must lie after start date.
*047   Overlapping records are deleted or delimited
*049   Data locked by user & (display only)
*050   System error: Unable to lock table/view &
*051   You do not have authorization to change the data (only display)
*053   No display authorization for requested data
*054   Maintenance of data in current client & not permitted
*055   Address for object & not found
*056   Select at least one entry before choosing this function.
*057   The selected entry is new and has no original
*058   The selected entries are new and have no original
*059   The selected entry is still in its original state
*060   The selected entries are still in their original state
*061   & entries are still originals, & new entries have no original
*065   No entries exist, double-click for long text
*066   Select block end
*084   No values can be displayed
*092   Change task & is being processed
*095   System error changing change task &
*096   Task & was changed
*098   Entry flagged for inclusion in task &
*099   Entry was flagged for deletion from task &
*105   & entries were flagged for inclusion in task &
*106   & entries were flagged for deletion from task &
*107   Entry was already in task &
*108   & entries were already in task &
*109   & entries included, & entries were contained: &
*110   Entry was not in task &
*111   & entries deleted, & entries were not included: &
*112   & entries were not in task &
*113   Entry could not be retrieved
*114   & entries could not be retrieved
*115   Entry could not be deleted
*116   & entries could not be deleted
*117   Do not make any changes (SAP entry).
*120   Other entries will be retrieved and modified where necessary.
*121   Deleted entry will be recovered and possibly changed
*122   Entry was delimited
*123   Number of delimited entries: &
*124   Process the delimited entries.
*125   Process the delimited entry.
*127   Delimit the area of validity.
*128   Transport is not possible for delivery class &.
*129   Related objects in various tasks
*130   Client & is local, transport not permitted
*132   Object locked for task &1, user &2 (only display possible).
*134   Inconsistency in object definition (only display possible)
*136   Change with caution, entry belongs to customer
*137   Do not make any changes (SAP data).
*138   Check maintenance object &1 or update function group &2.
*139   Address data is not transferred during comparison.
*140   &1 entries deleted; &2 entries added.
*141   Entries are not added individually to the change request.
*142   Transport is not possible for the specified data
*150   Start of action &4 for entry &1 &2 &3
*151   End of action &4 for entry &1 &2 &3
*153   No language was chosen
*154   Test mode: Changes were not saved
*160   The installed system code page does not allow any other languages.
*161   Put the cursor on a form name
*162   The object &1 &2 &3 cannot be put in a request
*164   Table/view &1 is not in the Dictionary
*165   No address in import client for object &
*173   Function group &1 inconsistent
*174   Enter values in work area for non-key fields.
*175   The selected BC Set function is not supported.
*177   Data record contains fix value from BC Set and cannot be deleted
*180   Data for specified key areas unchangeable
*181   Read access only
*184   Data record contains fixed value from BC Set and cannot be changed
*193   DB save rolled back
*202   You are not authorized to change fields with fixed BC Set values
*208   Recording of table keys in request &1 ended
*209   Recording of table keys in request &1 started
*210   &1 table keys are passed for recording
*214   Save is aborted, due to error raised in event &1
*224   Data is inconsistent. To see logs click on Display Logs (Ctrl+F7) button
*225   Data is consistent
*306   Table/view & is not active
*413   & selected entries cannot be deleted
*538   Dropdown list is not supported in view clusters.
*757   You have no maintenance authorization for this table key
*763   You have no maintenance authorization for the displayed data records
*764   Data record selection was changed.
*766   Restricted display of datasets
*808   Not all columns in the table can be displayed in the list
*810   View &1 is more than 1000 characters long.
*818   &1 of &2 Business Configuration Set entries imported.
*819   Business Configuration Set imported.
*830   Last selected entry has been reached
*831   First selected entry has been reached
*863   Number of copied entries (including translations): &
*870   Maintenance Dialog Switched to List Screen
*MSG
*P_M
*
* Message class: TB
*109   No maintenance authorization for cross-client tables (see Help)
*
* Message class: TK
*430   Client &1 has status 'not modifiable'
*729   Changes to repository objects are not permitted in this client
*730   Changes to repository or cross-client customizing are not permitted
*731   Cross-client customizing cannot be modified
*
* Message class: VIM_ALE_MSGID
*VIM
*
* Message class: VIM_AUTH_MSGID
*VIM
