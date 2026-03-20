# Standard 출하 생성 시 Selection Date 오류

Date: 2026-03-20

- Status: Resolved
- Module: SD

## 발생 상황
- `VL01N`(출하 생성)에서 정상적인 판매 오더 번호(383)를 입력했음에도 "준비된 물건이 없음(No schedule lines due for delivery)" 메시지가 발생하며 문서 생성 불가.

## 원인 분석
- SAP 시스템이 `VA01`(주문 생성) 시점에 자동으로 계산한 **배송 예정일(Delivery Date)보다** `VL01N` 조회 시점인 **선택일(Selection Date)이** 더 과거로 설정되어 발생한 조회 필터링 오류.

## 해결 방법
- `VL01N` 초기 화면에서 **Selection Date를 미래 날짜**(예: 일주일 뒤)로 넉넉하게 설정하여 재조회.
- 또는 `VA03`의 [Schedule lines] 탭에서 확정된 실제 배송 예정일을 확인하여 해당 날짜를 입력함.

## 참고 자료
- T-Code: VA03, VL01N
