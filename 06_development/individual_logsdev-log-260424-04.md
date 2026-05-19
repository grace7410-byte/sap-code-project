# [Dev Log] 2026-04-24 (Member 04 - PP)

- **작성자**: 비공개 (1조 / 반: CL2)
- **프로그램**: [ZRB1PP0004, SAPMZB1PP0003](../../04_design/03_program_specification_260424.md#index04) (모듈: PP)
- **프로젝트 명**: 석유 정제 및 제조 전문 기업 C-NERGY / SAP ERP 도입 프로젝트
- **상태**: 구현중

## 1. 진행 내역
**[ ZRB1PP0004 ]** MRP 프로그램
- 기존 ALV GRID에서 ALV TREE로 출력하도록 형태를 변경하였다.
- 원유 투입량 결정 근거를 보여주기 위해 PIR 집계 데이터와 일자별 원유 투입량을 ALV로 출력하였다.
- Application Menu에 저장 버튼을 추가하였으며, 클릭 시 MRP와 생산계획 테이블에 데이터가 생성되도록 하였다.
- 채번을 활용하여 [ZTB1PP0011](../../04_design/table_specifications/02_PP_table_spec.md#ZTB1PP0011)(MRP 헤더), [ZTB1PP0012](../../04_design/table_specifications/02_PP_table_spec.md#ZTB1PP0012)(MRP 아이템), [ZTB1PP0013](../../04_design/table_specifications/02_PP_table_spec.md#ZTB1PP0013)(계획오더 헤더), [ZTB1PP0014](../../04_design/table_specifications/02_PP_table_spec.md#ZTB1PP0014)(계획오더 아이템) 테이블에 관련 데이터가 생성되도록 처리하였다.
- 수요 데이터를 추가하고 BOM 수율을 변경해도 프로그램이 정상적으로 동작하는지 테스트를 진행하였다.

**[ SAPMZB1PP0003 ]** 자재-공정 연결 프로그램
- 투입 자재 간 관계를 정의해 완제품 투입->원재료 생산같은 예외 처리를 강화하였다.
- 기 생성된, 혹은 추가된 데이터를 중복 생성하지 못하도록 방지 기능을 구현하였다.

## 2. 발생한 기술적 오류 및 조치
- *본 주차에 보고되거나 발생한 기술적 오류 및 특이 결함 사항 없음.*
