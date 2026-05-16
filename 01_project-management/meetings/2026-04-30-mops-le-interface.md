# MOPS & LE Interface Meeting

## Date
2026-04-30

## Participants
- PM: [Index 01](../../04_design/Program_Specification.md#index-01-pm--le-member-1)
- PL: [Index 02](../../04_design/Program_Specification.md#index-02-co-member-2)
- CL: [Index 03](../../04_design/Program_Specification.md#index-03-mm-member-3)
- Team Members: 
  - [Index 04](../../04_design/Program_Specification.md#index-04-pp-member-4)
  - [Index 05](../../04_design/Program_Specification.md#index-05-fi-member-5)
  - [Index 06](../../04_design/Program_Specification.md#index-06-fi-member-6)
  - [Index 07](../../04_design/Program_Specification.md#index-07-sd-member-7)
  (Total 7)

## Agenda
SD 외부 MOPS 제품가 실시간 연동 및 MM 원유 단가 산정 로직 조율, MM-LE 구매프로세스 아이템 상태 연동 구조 조율

## Discussion
SD 모듈([Index 07](../../04_design/Program_Specification.md#index-07-sd-member-7))에서 매일 변동되는 오피넷 싱가포르 국제 제품가(MOPS) 지표의 실제 금액을 시스템에 매일 반영하여 판매 기본가를 설정하기로 함. 정유 산업 특성상 기본가가 외부 지표로 통제되므로 MOPS 금액에 기타 마진 가격을 더하는 판가 로직을 수립하고, 디스코드를 통해 확정된 6개 유종 매핑 기준을 검토함.

반면, 당초 외부 사이트에서 실시간 원유가(dubai, wti, brent)를 인입하려던 MM 모듈([Index 03](../../04_design/Program_Specification.md#index-03-mm-member-3))은 현재 100 USD를 초과하는 고유가를 적용할 시 CO 마진 산정이 심각하게 꼬일 수 있다는 점을 공유함. 이에 따라 MM 쪽은 동적 수집안을 철회하고 기존 설계 단가인 75~85 USD 선을 유지하여 원가 마진 안정성을 방어하기로 합의함.

이어서 MM과 LE([Index 01](../../04_design/Program_Specification.md#index-01-pm--le-member-1)) 모듈 간의 대외 인터페이스 회의를 진행함. LE 모듈의 선적/실측별 부분 운송 프로세스를 반영하기 위해, 기존 구매오더 헤더에 존재하던 `POSTAT` 필드를 삭제하고 아이템 단위의 상태 관리로 전환하기로 함. 이에 따라 종속된 CDS 뷰 수정을 거쳐 점심시간 이후 DB 테이블 리팩토링 및 액티베이션을 완료하기로 함.

## Conclusion
* SD 판매가는 오피넷 공시 실가격을 매일 추적 매핑하여 현실성을 높이고, MM 원유가는 내부 시뮬레이션 안정화를 위해 75~85 USD 범위로 고정 고수함.
* 프로젝트 통합 데이터 정합성을 위해 구매오더 상태 관리를 아이템 단위로 이관함. 헤더 필드가 제외됨에 따라 구매오더 프로그램 화면 및 후속 송장/입고 관리 스크린에서 헤더 상태를 표현할 때는, 내부적으로 전체 아이템을 오름차순 정렬(`SORT lt_item BY postat ASCENDING`)한 뒤 INDEX 1번의 가장 낮은 단계를 대표 상태값으로 동적 표기하는 예외 처리 알고리즘을 구축하기로 결정함.
* 구매오더 프로그램 저장 및 변경 시에는 Memory ID(`SAVE_CHECK`, `ZPO_DATA`)를 활용하여 `EXPORT` 후 서비스 PO 전용 티코드인 `ZB1MM0005`를 호출하는 인터페이스 흐름을 확정함.

## Next Action
* **[Index 03 (MM)](../../04_design/Program_Specification.md#index-03-mm-member-3)**: CDS 뷰 및 DB 반영 후 구매오더 프로그램 내 오름차순 정렬 기반 대표 상태 역산 기능 구현 완료.
* **[Index 01 (LE)](../../04_design/Program_Specification.md#index-01-pm--le-member-1)**: 일요일까지 서비스오더 프로그램 스크린에서 `IMPORT`로 메모리 데이터를 수신하여 상태를 동기화하는 로직 개발 및 상호 테스트 완료.
