# ZTCL2FE0101

> 원본 설명(export 시 한글 손실): `Fiori Element DB Table`

| Row | Field name | Position | Key | Data element | Domain | Datatype | Length | Domain text |
|---|---|---|---|---|---|---|---|---|
| 1 | CLIENT | 1 | X | MANDT | MANDT | CLNT | 3 | Client |
| 2 | CARRIER_ID | 2 | X | S_CARR_ID | S_CARR_ID | CHAR | 3 | Airline Code |
| 3 | CONNECTION_ID | 3 | X | S_CONN_ID | S_CONN_ID | NUMC | 4 | Flight Connection Number |
| 4 | FLIGHT_DATE | 4 | X | S_DATE | S_DATE | DATS | 8 | Flight date |
| 5 | PRICE | 5 |  | S_PRICE | S_PRICE | CURR | 15 | Airfare |
| 6 | CURRENCY_CODE | 6 |  | S_CURRCODE | S_CURR | CUKY | 5 | Local currency of airline |
| 7 | PLANE_TYPE_ID | 7 |  | S_PLANETYE | S_PLANE | CHAR | 10 | Aircraft Type |
| 8 | SEATS_MAX | 8 |  | S_SEATSMAX | S_SEATS | INT4 | 10 | Maximum Capacity in Economy Class |
| 9 | SEATS_OCCUPIED | 9 |  | S_SEATSOCC | S_SEATS | INT4 | 10 | Occupied Seats in Economy Class |
| 10 | CREATED_BY | 10 |  | ABP_CREATION_USER | XUBNAME | CHAR | 12 | Created By User |
| 11 | CREATED_AT | 11 |  | ABP_CREATION_TSTMPL | TZNTSTMPL | DEC | 21 | Creation Date Time |
| 12 | LAST_CHANGED_BY | 12 |  | ABP_LASTCHANGE_USER | XUBNAME | CHAR | 12 | Last Changed By User |
| 13 | LAST_CHANGED_AT | 13 |  | ABP_LASTCHANGE_TSTMPL | TZNTSTMPL | DEC | 21 | Last Change Date Time |
| 14 | LOCAL_LAST_CHANGED_AT | 14 |  | ABP_LOCINST_LASTCHANGE_TSTMPL | TZNTSTMPL | DEC | 21 | Local Instance Last Change Date Time |
