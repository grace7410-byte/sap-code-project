# src/ — 실제 소스 코드 (MM / 박가을)

SAP 시스템에서 2026-07-13에 내려받은 백업(`BACKUP_260713.zip`, Direct Download Enterprise 1.3.1 / SAP Release 758)을
순수 소스 파일로 변환해 정리한 폴더입니다. 기능(프로그램)별로 폴더를 나누고, 그 안에 메인 프로그램 · Include · 스크린을 둡니다.

```
src/
├── 01_purchase-order/SAPMZB1MM0004/        구매오더 통합 관리 (트랜잭션)
├── 02_po-approval/ZRB1MM0002/              구매오더 결재
├── 03_goods-receipt/SAPMZB1MM0002/         입고 관리
├── 04_invoice-verification/SAPMZB1MM0003/  송장 검증
├── 05_volume-measurement/SAPMZB1MM0006/    구매 부피 측정 생성
├── 06_volume-tracking/ZRB1MM0001/          부피측정 통합 조회 및 오더 역추적
├── 07_gateway-odata/ZGWB1MM0001/           SAP Gateway OData 서비스 (DPC/MPC 클래스)
├── 08_function-modules/                    ZFB1MM0001 · ZFB1CM0001 · ZFB1FI0002
├── 09_message-class/                       ZMCB1
├── 10_ddic/                                참조 테이블/구조 필드 정의 (Markdown)
├── 90_data-generation/                     테스트 데이터 생성용 임시 프로그램
└── 99_prototypes/                          이전 버전 · 연습 · 실험 프로그램
```

---

## 프로그램 목록

| 폴더 | 오브젝트 | 내용 | 관련 문서 |
| --- | --- | --- | --- |
| [`01_purchase-order`](01_purchase-order/SAPMZB1MM0004) | `SAPMZB1MM0004` (T-Code ZB1MM0004) | 최적 원유 기반 구매오더 통합 관리 | [프로그램 스펙](../04_design/03_program_specification_260429.md#index03) · [개인 스펙서](../09_portfolio/individual-program-spec.md) |
| [`02_po-approval`](02_po-approval/ZRB1MM0002) | `ZRB1MM0002` | 구매오더 결재 | [dev-log 0430](../06_development/individual_logs/dev-log-260430-03.md) · [dev-log 0515](../06_development/individual_logs/dev-log-260515-03.md) |
| [`03_goods-receipt`](03_goods-receipt/SAPMZB1MM0002) | `SAPMZB1MM0002` (T-Code ZB1MM0002) | 입고 관리 | [dev-log 0529](../06_development/individual_logs/dev-log-260529-03.md) |
| [`04_invoice-verification`](04_invoice-verification/SAPMZB1MM0003) | `SAPMZB1MM0003` (T-Code ZB1MM0003) | 송장 검증 | [dev-log 0522](../06_development/individual_logs/dev-log-260522-03.md) · [dev-log 0529](../06_development/individual_logs/dev-log-260529-03.md) |
| [`05_volume-measurement`](05_volume-measurement/SAPMZB1MM0006) | `SAPMZB1MM0006` | 구매 부피 측정 생성 | [기능 문서](../05_features/01_procurement/02_volume-measurement.md) · [dev-log 0612](../06_development/individual_logs/dev-log-260612-03.md) |
| [`06_volume-tracking`](06_volume-tracking/ZRB1MM0001) | `ZRB1MM0001` | 정유 부피측정 통합 조회 및 오더 역추적 | [프로그램 스펙](../04_design/03_program_specification_260429.md#index03) |
| [`07_gateway-odata`](07_gateway-odata/ZGWB1MM0001) | `ZCL_ZGWB1MM0001_DPC(_EXT)` / `_MPC(_EXT)` | Gateway 서비스 ZGWB1MM0001 (OptimizeDB · Volume · VolumeMaster · PO · BPPOS 엔티티셋) | [dev-log 0605](../06_development/individual_logs/dev-log-260605-03.md) |
| [`08_function-modules/ZFB1MM0001`](08_function-modules/ZFB1MM0001) | `ZFB1MM0001` (FUGR ZFGB1MM01) | 자재 이동 문서 기반 재고량 · 총평가금액 · 단가 업데이트 | [dev-log 0529-01](../06_development/individual_logs/dev-log-260529-01.md) |
| [`08_function-modules/ZFB1CM0001`](08_function-modules/ZFB1CM0001) | `ZFB1CM0001` | 공용 관리정보(ERNAM~AEZET) 타임스탬프 세팅 | [dev-log 0410-04](../06_development/individual_logs/dev-log-260410-04.md) |
| [`08_function-modules/ZFB1FI0002`](08_function-modules/ZFB1FI0002) | `ZFB1FI0002` | 자동 전표 생성 (FI 팀원 개발 — 송장 검증에서 호출) | [dev-log 0417-06](../06_development/individual_logs/dev-log-260417-06.md) |
| [`09_message-class`](09_message-class) | `ZMCB1` | 메시지 클래스 | — |
| [`90_data-generation`](90_data-generation) | `ZZ18_20_VOLM_DATA`, `ZZBP_INVOICE_DATA` | 테스트 데이터 생성용 임시 프로그램 | [dev-log 0522](../06_development/individual_logs/dev-log-260522-03.md) |

`08_function-modules`의 `ZFB1CM0001`, `ZFB1FI0002`는 MM 프로그램이 호출하는 공용/타 모듈 함수라서, 백업에 함께 들어 있던 것을 참고용으로 보관합니다.

### 99_prototypes

백업에 함께 들어 있던 이전 버전 · 연습용 프로그램입니다. 아래 "추정"은 Include 이름과 구성을 보고 판단한 것입니다.

| 폴더 | 비고 |
| --- | --- |
| `ZCREATEPO`, `ZCREATEPO_614_B08` | 구매오더 프로그램(SAPMZB1MM0004)의 이전 버전으로 추정 (Include 설명이 `ZRB1MM0001_*`로 동일) |
| `ZLOADING_511_B08`, `ZLOADING_610_B08` | 입고 관리(SAPMZB1MM0002)의 이전 버전으로 추정 (Include 설명이 `MZB1MM0002*`) |
| `ZMEASURE0503_B08` | 부피측정 조회(ZRB1MM0001)의 이전 버전으로 추정 (Include 설명이 `MZB1MM0003*`) |
| `ZMEASUREMENT_B08` | 부피 측정 관련 초기 버전 |
| `SAPMZCREATEPO`, `ZLOADING_601_B08`, `ZRB1MM0001_COPY_HTML` | **본문 코드 없음** — 백업에 `REPORT` 문 한 줄(+ 텍스트 요소)과 스크린만 남아 있음 |
| `ZEXAMPLE_SCREEN_B08`, `ZHTMLTESTB08`, `ZTESTCHART1B08`, `ZMEMO_B08` | 화면 · HTML · 차트 연습 / 메모 |
| `RAP_TCL2FE0801` | RAP/Fiori Elements 연습 (`ZTCL2FE0101`, `ZTCL2FE0801` 테이블 포함) |

---

## 파일 규칙

| 오브젝트 | 확장자 |
| --- | --- |
| 프로그램 / Include | `.prog.abap` |
| 함수 모듈 | `.func.abap` (함수 그룹 TOP은 `.fugr-top.abap`) |
| 클래스 | `.clas.abap` |
| 스크린 (Dynpro) | `screens/screen_NNNN.dynp.txt` — Flow logic 포함, Direct Download 원본 포맷 그대로 |
| GUI Title | `screens/gui_title_*.txt` |
| 메시지 클래스 | `.msag.txt` |
| 테이블 / 구조 | `10_ddic/*.tabl.md` (필드 목록 표) |

- 파일 이름은 SAP 오브젝트 이름(소문자)을 그대로 사용합니다. 메인 프로그램 파일(`sapmzb1mm0002.prog.abap` 등)의 `INCLUDE` 문을 보면 구성 Include를 알 수 있습니다.
- 여러 프로그램 폴더에 중복으로 들어 있던 테이블 정의는 내용이 모두 동일해서 `10_ddic/`에 하나씩만 남겼습니다.

---

## ⚠️ 백업 원본의 한계

1. **한글이 `#`으로 바뀌어 있습니다.** Direct Download(HTML export) 과정에서 한글 한 글자가 `#` 한 개로 치환되어 저장됐습니다.
   주석 · 텍스트 리터럴 · 메시지 · 테이블 설명의 한글은 백업 파일에서 복원할 수 없어서 그대로 두었습니다.
   (예: `gv_mode TYPE c. " #### ##### ...`) 코드 로직 자체(키워드, 변수, SQL)는 영향이 없습니다.
   - 예외: `07_gateway-odata/ZGWB1MM0001/zcl_zgwb1mm0001_dpc_ext.clas.abap`는 별도 텍스트 파일(`GW_CDS/Gateway_DPC.txt`)에서 가져와서 한글이 살아 있습니다.
2. **일부 클래스는 메서드 구현이 없습니다.** 클래스 export에는 정의부만 있고 메서드는 개별 파일로만 내려받아졌습니다.
   - `ZCL_ZGWB1MM0001_DPC`, `_MPC`: 백업에 있던 메서드는 클래스 파일 뒤에 이어 붙였습니다(`DEFINE`, `GET_LAST_MODIFIED` 등 일부는 백업에 없음).
   - `ZCL_ZGWB1MM0001_MPC_EXT`, `ZBP_R_TCL2FE0801`, `ZCLCL2FE0801`: 정의부만 있습니다.
3. 원본 HTML의 `&lt;` 등 엔티티는 원래 문자로 되돌렸고, 줄바꿈은 LF로 통일했습니다. 그 외 코드 내용은 손대지 않았습니다.

한글 주석까지 온전히 보관하려면 SAP GUI/ADT에서 소스를 직접 복사하거나 abapGit으로 다시 내려받아 해당 파일을 덮어쓰면 됩니다.
