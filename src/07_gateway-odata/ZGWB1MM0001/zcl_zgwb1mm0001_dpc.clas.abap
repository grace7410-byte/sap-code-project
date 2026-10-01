**************************************************************************
*   Class attributes.                                                    *
**************************************************************************
Instantiation: Public
Message class:
State: Implemented
Final Indicator:
R/3 Release: 758

**************************************************************************
*   Public section of class.                                             *
**************************************************************************
class ZCL_ZGWB1MM0001_DPC definition
  public
  inheriting from /IWBEP/CL_MGW_PUSH_ABS_DATA
  abstract
  create public .

public section.

  interfaces /IWBEP/IF_SB_DPC_COMM_SERVICES .
  interfaces /IWBEP/IF_SB_GEN_DPC_INJECTION .

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_ENTITYSET
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~UPDATE_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~DELETE_ENTITY
    redefinition .

**************************************************************************
*   Private section of class.                                            *
**************************************************************************
private section.

**************************************************************************
*   Protected section of class.                                          *
**************************************************************************
protected section.

  data mo_injection type ref to /IWBEP/IF_SB_GEN_DPC_INJECTION .

  methods VOLUMESET_UPDATE_ENTITY
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_U optional
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      ER_ENTITY type ZCL_ZGWB1MM0001_MPC=>TS_VOLUME
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods VOLUMESET_GET_ENTITYSET
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_FILTER_SELECT_OPTIONS type /IWBEP/T_MGW_SELECT_OPTION
      IS_PAGING type /IWBEP/S_MGW_PAGING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      IT_ORDER type /IWBEP/T_MGW_SORTING_ORDER
      IV_FILTER_STRING type STRING
      IV_SEARCH_STRING type STRING
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITYSET optional
    exporting
      ET_ENTITYSET type ZCL_ZGWB1MM0001_MPC=>TT_VOLUME
      ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods VOLUMESET_GET_ENTITY
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IO_REQUEST_OBJECT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    exporting
      ER_ENTITY type ZCL_ZGWB1MM0001_MPC=>TS_VOLUME
      ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods VOLUMESET_DELETE_ENTITY
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_D optional
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods VOLUMESET_CREATE_ENTITY
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_C optional
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      ER_ENTITY type ZCL_ZGWB1MM0001_MPC=>TS_VOLUME
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods VOLUMEMASTERSET_UPDATE_ENTITY
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_U optional
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      ER_ENTITY type ZCL_ZGWB1MM0001_MPC=>TS_VOLUMEMASTER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods VOLUMEMASTERSET_GET_ENTITYSET
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_FILTER_SELECT_OPTIONS type /IWBEP/T_MGW_SELECT_OPTION
      IS_PAGING type /IWBEP/S_MGW_PAGING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      IT_ORDER type /IWBEP/T_MGW_SORTING_ORDER
      IV_FILTER_STRING type STRING
      IV_SEARCH_STRING type STRING
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITYSET optional
    exporting
      ET_ENTITYSET type ZCL_ZGWB1MM0001_MPC=>TT_VOLUMEMASTER
      ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods VOLUMEMASTERSET_GET_ENTITY
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IO_REQUEST_OBJECT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    exporting
      ER_ENTITY type ZCL_ZGWB1MM0001_MPC=>TS_VOLUMEMASTER
      ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods VOLUMEMASTERSET_DELETE_ENTITY
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_D optional
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods VOLUMEMASTERSET_CREATE_ENTITY
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_C optional
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      ER_ENTITY type ZCL_ZGWB1MM0001_MPC=>TS_VOLUMEMASTER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods POSET_UPDATE_ENTITY
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_U optional
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      ER_ENTITY type ZCL_ZGWB1MM0001_MPC=>TS_PO
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods POSET_GET_ENTITYSET
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_FILTER_SELECT_OPTIONS type /IWBEP/T_MGW_SELECT_OPTION
      IS_PAGING type /IWBEP/S_MGW_PAGING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      IT_ORDER type /IWBEP/T_MGW_SORTING_ORDER
      IV_FILTER_STRING type STRING
      IV_SEARCH_STRING type STRING
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITYSET optional
    exporting
      ET_ENTITYSET type ZCL_ZGWB1MM0001_MPC=>TT_PO
      ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods POSET_GET_ENTITY
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IO_REQUEST_OBJECT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    exporting
      ER_ENTITY type ZCL_ZGWB1MM0001_MPC=>TS_PO
      ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods POSET_DELETE_ENTITY
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_D optional
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods POSET_CREATE_ENTITY
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_C optional
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      ER_ENTITY type ZCL_ZGWB1MM0001_MPC=>TS_PO
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods OPTIMIZEDBSET_UPDATE_ENTITY
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_U optional
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      ER_ENTITY type ZCL_ZGWB1MM0001_MPC=>TS_OPTIMIZEDB
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods OPTIMIZEDBSET_GET_ENTITYSET
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_FILTER_SELECT_OPTIONS type /IWBEP/T_MGW_SELECT_OPTION
      IS_PAGING type /IWBEP/S_MGW_PAGING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      IT_ORDER type /IWBEP/T_MGW_SORTING_ORDER
      IV_FILTER_STRING type STRING
      IV_SEARCH_STRING type STRING
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITYSET optional
    exporting
      ET_ENTITYSET type ZCL_ZGWB1MM0001_MPC=>TT_OPTIMIZEDB
      ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods OPTIMIZEDBSET_GET_ENTITY
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IO_REQUEST_OBJECT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    exporting
      ER_ENTITY type ZCL_ZGWB1MM0001_MPC=>TS_OPTIMIZEDB
      ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods OPTIMIZEDBSET_DELETE_ENTITY
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_D optional
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods OPTIMIZEDBSET_CREATE_ENTITY
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_C optional
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      ER_ENTITY type ZCL_ZGWB1MM0001_MPC=>TS_OPTIMIZEDB
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods BPPOSSET_UPDATE_ENTITY
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_U optional
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      ER_ENTITY type ZCL_ZGWB1MM0001_MPC=>TS_BPPOS
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods BPPOSSET_GET_ENTITYSET
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_FILTER_SELECT_OPTIONS type /IWBEP/T_MGW_SELECT_OPTION
      IS_PAGING type /IWBEP/S_MGW_PAGING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      IT_ORDER type /IWBEP/T_MGW_SORTING_ORDER
      IV_FILTER_STRING type STRING
      IV_SEARCH_STRING type STRING
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITYSET optional
    exporting
      ET_ENTITYSET type ZCL_ZGWB1MM0001_MPC=>TT_BPPOS
      ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods BPPOSSET_GET_ENTITY
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IO_REQUEST_OBJECT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    exporting
      ER_ENTITY type ZCL_ZGWB1MM0001_MPC=>TS_BPPOS
      ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods BPPOSSET_DELETE_ENTITY
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_D optional
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods BPPOSSET_CREATE_ENTITY
    importing
      IV_ENTITY_NAME type STRING
      IV_ENTITY_SET_NAME type STRING
      IV_SOURCE_NAME type STRING
      IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_C optional
      IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
      IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    exporting
      ER_ENTITY type ZCL_ZGWB1MM0001_MPC=>TS_BPPOS
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .

  methods CHECK_SUBSCRIPTION_AUTHORITY
    redefinition .

**************************************************************************
*   Types section of class.                                              *
**************************************************************************
*"* dummy include to reduce generation dependencies between
*"* class ZCL_ZGWB1MM0001_DPC and it's users.
*"* touched if any type reference has been changed


**************************************************************************
*   Methods (exported per method)
**************************************************************************

  method BPPOSSET_CREATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'BPPOSSET_CREATE_ENTITY'.
  endmethod.

  method BPPOSSET_DELETE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'BPPOSSET_DELETE_ENTITY'.
  endmethod.

  method BPPOSSET_GET_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'BPPOSSET_GET_ENTITY'.
  endmethod.

  method BPPOSSET_GET_ENTITYSET.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'BPPOSSET_GET_ENTITYSET'.
  endmethod.

  method BPPOSSET_UPDATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'BPPOSSET_UPDATE_ENTITY'.
  endmethod.

  method OPTIMIZEDBSET_CREATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'OPTIMIZEDBSET_CREATE_ENTITY'.
  endmethod.

  method OPTIMIZEDBSET_DELETE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'OPTIMIZEDBSET_DELETE_ENTITY'.
  endmethod.

  method OPTIMIZEDBSET_GET_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'OPTIMIZEDBSET_GET_ENTITY'.
  endmethod.

  method OPTIMIZEDBSET_GET_ENTITYSET.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'OPTIMIZEDBSET_GET_ENTITYSET'.
  endmethod.

  method OPTIMIZEDBSET_UPDATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'OPTIMIZEDBSET_UPDATE_ENTITY'.
  endmethod.

  method POSET_CREATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'POSET_CREATE_ENTITY'.
  endmethod.

  method POSET_DELETE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'POSET_DELETE_ENTITY'.
  endmethod.

  method POSET_GET_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'POSET_GET_ENTITY'.
  endmethod.

  method POSET_GET_ENTITYSET.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'POSET_GET_ENTITYSET'.
  endmethod.

  method POSET_UPDATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'POSET_UPDATE_ENTITY'.
  endmethod.

  method VOLUMEMASTERSET_CREATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'VOLUMEMASTERSET_CREATE_ENTITY'.
  endmethod.

  method VOLUMEMASTERSET_DELETE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'VOLUMEMASTERSET_DELETE_ENTITY'.
  endmethod.

  method VOLUMEMASTERSET_GET_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'VOLUMEMASTERSET_GET_ENTITY'.
  endmethod.

  method VOLUMEMASTERSET_GET_ENTITYSET.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'VOLUMEMASTERSET_GET_ENTITYSET'.
  endmethod.

  method VOLUMEMASTERSET_UPDATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'VOLUMEMASTERSET_UPDATE_ENTITY'.
  endmethod.

  method VOLUMESET_CREATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'VOLUMESET_CREATE_ENTITY'.
  endmethod.

  method VOLUMESET_DELETE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'VOLUMESET_DELETE_ENTITY'.
  endmethod.

  method VOLUMESET_GET_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'VOLUMESET_GET_ENTITY'.
  endmethod.

  method VOLUMESET_GET_ENTITYSET.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'VOLUMESET_GET_ENTITYSET'.
  endmethod.

  method VOLUMESET_UPDATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'VOLUMESET_UPDATE_ENTITY'.
  endmethod.
