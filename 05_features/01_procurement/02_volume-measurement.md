# [MM] 부피 측정
- **개요**: 원유·제품의 실측 부피를 온도/밀도 기준 15℃ 표준 부피로 환산(VCF)하고, 바코드 스캔으로 구매 정보와 자동 연동.
- **비즈니스 로직**:
  1. 측정문서/측정일/측정 원인/보정계수(VCF) 조건 입력 → GO → 부피측정 및 환산 이력 조회
  2. 문서 생성 클릭 → 부피 측정 및 데이터 입력 화면(추가 레이아웃)으로 이동
  3. 스캔 시작 → 바코드 스캔으로 자재 구매 정보 및 VCF 자동 연동
  4. 온도(℃), 관찰 밀도(kg/㎥), 실측 부피 입력 → '계산' 클릭 → 15℃ 표준 부피로 환산
  5. 측정문서 확인 클릭 → 입력 데이터 오류 검증 → 자동 문서번호·유형 할당 및 저장
- **관련 테이블**: [`ZTB1MM0018`](../../04_design/table_specifications/01_MM_table_spec.md#index18)(부피측정 마스터 - VCF 기준), `ZTB1MM0020`(부피 측정 이력 - 실측/환산 부피)
- **기술 스택**: ABAP RAP, Fiori Elements(Custom Page + Barcode Scanner 확장), CDS View(VCF 산출 로직)
- **연동 흐름**: 환산 확정 → 재고 수량/평가금액 갱신([`ZTB1MM0003`](../../04_design/table_specifications/01_MM_table_spec.md#index03)) → 재고변동관리(`ZTB1MM0023/0024`)에 이력 기록  

![MM Volume Measurement](../images/mm_volume-measurement.png)
