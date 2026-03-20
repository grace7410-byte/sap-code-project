# Standard Practice
## PGI(출고 전기) 시 실물 재고 부족 오류

Date: 2026-03-20
- Status: Resolved
- Module: SD/MM

## 발생 상황
- **Standard 실습 단계**: `VL02N`(출하 변경)에서 피킹 수량(Picked Qty) 입력 후 **PGI(Post Goods Issue)** 실행 단계.
- **현상**: "오류: 재고 부족(Stock out)" 메시지가 발생하며 출고 전표 확정 및 후행 문서(Billing) 진행 불가.

## 원인 분석
- **데이터 불일치**: 자재 마스터(`MM01`)는 생성되었으나, 실제 창고(Plant 1010 / SLoC 101A)에 물리적인 실물 재고가 0인 상태임.
- **ATP 설정 특성**: 연습 서버의 가용성 점검(Available To Promise) 설정이 '경고' 수준이거나 미래 입고 예정치를 포함하도록 되어 있어 `VA01`(판매 오더) 단계는 통과되었으나, **실제 물건이 나가는 PGI 단계에서는 실시간 물리 재고가 필수**이기 때문에 에러가 발생함.

## 해결 방법
- **Step 1. 재고 강제 입고 (MIGO)**: 시스템 도입 초기나 실습 환경 구축을 위한 **이동 유형 561**을 사용하여 재고를 생성함.
    - `MIGO` 접속 -> [A01 입고] / [R10 기타] 선택 -> 이동 유형 `561` 입력.
    - 대상 자재(TEST_OIL), 플랜트(1010), 저장위치(101A), 수량(100,000L) 입력 후 [Post].
- **Step 2. 재고 확인 (MMBE)**: `MMBE`에서 해당 플랜트/저장위치에 재고가 정상적으로 반영되었는지 시각적으로 확인.
- **Step 3. 출고 재실행**: `VL02N`으로 돌아가 다시 PGI 버튼 클릭 시 정상적으로 출고 문서 생성 완료.

## 참고 자료
- T-Code: MIGO, MMBE(Stock Overview), VL02N
- 관련 개념: Movement Type 561 (Initial Entry of Stock Balances)
