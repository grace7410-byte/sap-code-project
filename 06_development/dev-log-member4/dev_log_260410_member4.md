# [Dev Log] 2026-04-10 (Member 4)

## 1. 개발 진행 내역
- **프로그램**: 자재-공정 연결 관리 (SAPMZB1PP0003)
- **주요 구현 내용**:
    - 생성 및 변경 정보(ERNAM, ERDAT, ERZET, AENAM, AEDAT, AEZET)를 자동 업데이트하는 공용 Function Module(ZFB1CM0001) 개발 및 팀 내 공유
    - Splitter Container와 ALV를 활용한 다중 화면 구성
    - DB 테이블 외래키(Foreign Key) 설정을 기반으로 Layout 및 Field Catalog를 활용한 F4 Help(Search Help) 적용
    - ALV 클래스의 `toolbar` 및 `user_command` 이벤트를 활용하여 신규 데이터 추가 및 저장 기능 구현

## 2. 기술적 트러블슈팅
### 이슈: Subroutine의 전역 변수 직접 참조로 인한 유지보수성 저하
- **현상**: 핵심 로직에 변경이 없음에도 불구하고, 전역 변수를 추가하거나 변수명을 수정할 때마다 전체 코드가 영향을 받는 현상 발생
- **원인**: Subroutine이 인터페이스 매개변수를 통하지 않고 전역 변수에 직접 접근하여 결합도가 높아짐
- **해결**: Subroutine 정의 시 인터페이스(Using/Changing)를 명확히 선언하고 로직과 변수를 분리하여 모듈화함으로써 독립성을 확보함

## 3. 향후 계획
- 자재 조회 ALV 및 공정 조회 ALV 구현
- 각 ALV에서 선택된 데이터를 바탕으로 자재와 공정을 자동으로 연결해주는 연동 기능 개발 예정
