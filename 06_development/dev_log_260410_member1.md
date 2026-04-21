# [Dev Log] 2026-04-10 (Member 1)

## 1. 개발 진행 내역
- **프로그램**: 서비스 엔트리 관리 (SAPMZB1MM0001)
- **주요 구현 내용**:
    - 현재 날짜와 운송 현황 대조를 통한 서비스 엔트리 헤더 데이터 자동 생성 로직 구현
    - Splitter Container를 활용하여 서비스 아이템과 운송 현황 테이블 화면 분리
    - `excp_fname` 기능을 이용한 운송 상태(신호등) 표시 및 `info_fname`을 통한 라인 하이라이트 적용
    - Database View를 구축하여 서비스 PO 번호와 패키지 번호 간의 데이터 조회 설정

## 2. 기술적 트러블슈팅
### 이슈 1: Field Catalog 간소화 과정 중 Subroutine 에러
- **현상**: Field Symbol을 사용하여 Field Catalog 생성 로직을 Subroutine으로 간소화하는 과정에서 에러 발생
- **원인**: Actual Parameter와 Formal Parameter 간의 대응 관계 및 값 조정 미흡
- **해결**: Parameter 대응 관계 재정리 및 전달 값 수정을 통해 로직 정상화

### 이슈 2: Database View PK 설정 문제
- **현상**: Database View 생성 시 모든 필드가 PK(Primary Key)로 지정됨
- **해결**: 조회 ALV에 대한 Field Catalog를 별도로 생성하고 관리하여 대응

## 3. 향후 계획
- 운송 완료 건에 대한 승인 여부 구분 기능 추가
- 운송 자재 소요 계획 수립을 위한 전용 CDS View 개발 예정
