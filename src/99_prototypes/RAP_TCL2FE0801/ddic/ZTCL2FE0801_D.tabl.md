# ZTCL2FE0801_D

> 원본 설명(export 시 한글 손실): `##GENERATED ZTCL2FE0801`

| Row | Field name | Position | Key | Data element | Domain | Datatype | Length | Domain text |
|---|---|---|---|---|---|---|---|---|
| 1 | MANDT | 1 | X | MANDT | MANDT | CLNT | 3 | Client |
| 2 | CARRIERID | 2 | X | S_CARR_ID | S_CARR_ID | CHAR | 3 | Airline Code |
| 3 | CONNECTIONID | 3 | X | S_CONN_ID | S_CONN_ID | NUMC | 4 | Flight Connection Number |
| 4 | FLIGHTDATE | 4 | X | S_DATE | S_DATE | DATS | 8 | Flight date |
| 5 | PRICE | 5 |  | S_PRICE | S_PRICE | CURR | 15 | Airfare |
| 6 | CURRENCYCODE | 6 |  | S_CURRCODE | S_CURR | CUKY | 5 | Local currency of airline |
| 7 | PLANETYPEID | 7 |  | S_PLANETYE | S_PLANE | CHAR | 10 | Aircraft Type |
| 8 | SEATSMAX | 8 |  | S_SEATSMAX | S_SEATS | INT4 | 10 | Maximum Capacity in Economy Class |
| 9 | SEATSOCCUPIED | 9 |  | S_SEATSOCC | S_SEATS | INT4 | 10 | Occupied Seats in Economy Class |
| 10 | CREATEDBY | 10 |  | ABP_CREATION_USER | XUBNAME | CHAR | 12 | Created By User |
| 11 | CREATEDAT | 11 |  | ABP_CREATION_TSTMPL | TZNTSTMPL | DEC | 21 | Creation Date Time |
| 12 | LASTCHANGEDBY | 12 |  | ABP_LASTCHANGE_USER | XUBNAME | CHAR | 12 | Last Changed By User |
| 13 | LASTCHANGEDAT | 13 |  | ABP_LASTCHANGE_TSTMPL | TZNTSTMPL | DEC | 21 | Last Change Date Time |
| 14 | LOCALLASTCHANGEDAT | 14 |  | ABP_LOCINST_LASTCHANGE_TSTMPL | TZNTSTMPL | DEC | 21 | Local Instance Last Change Date Time |
| 15 | .INCLUDE | 15 |  |  |  |  | 0 | Standard Include for Draft Administration (BDL Syntax Check) |
| 16 | DRAFTENTITYCREATIONDATETIME | 16 |  | SYCH_BDL_DRAFT_CREATED_AT | TZNTSTMPL | DEC | 21 | Draft Created At |
| 17 | DRAFTENTITYLASTCHANGEDATETIME | 17 |  | SYCH_BDL_DRAFT_LAST_CHANGED_AT | TZNTSTMPL | DEC | 21 | Draft Last Changed At |
| 18 | DRAFTADMINISTRATIVEDATAUUID | 18 |  | SYCH_BDL_DRAFT_ADMIN_UUID | SYSUUID | RAW | 16 | Draft Administration UUID |
| 19 | DRAFTENTITYOPERATIONCODE | 19 |  | SYCH_BDL_DRAFT_OPERATION_CODE | SYCH_BDL_DRAFT_OPERATION_CODE | CHAR | 1 | Draft - Operation Code |
| 20 | HASACTIVEENTITY | 20 |  | SYCH_BDL_DRAFT_HASACTIVE |  | CHAR | 1 | Draft Flag "Has Active Instance" |
| 21 | DRAFTFIELDCHANGES | 21 |  | SYCH_BDL_DRAFT_FIELD_CHANGES |  | RSTR | 0 | Draft Field Changes as BLOB |
