# [Dev Log] 2026-04-10 (Member 04 - PP)

- **작성자**: 비공개 (1조 / 반: CL2)
- **프로그램**: SAPMZB1PP0005 (모듈: PP)
- **프로젝트 명**: CYNERGY 프로젝트
- **상태**: 구현중

## 1. 진행 내역
1) Function Module ZFB1CM0001 개발. ERNAM ERDAT ERZET AENAM AEDAT AEZET 를 자동으로 업데이트 해주는 공용 Function 모듈을 개발하고 공유했다
2) Splitter 와 ALV 를 활용해 화면 구성했고, DB 테이블 외래키 설정 후 Layout 과 Field catalog 를 활용해 F4Help 를 적용했다
3) ALV 기본 툴바 버튼 정리 후 alv 클래스의 toolbar 와 user_command 이벤트를 활용해 신규 데이터 추가 및 저장 기능을 구현했다.

### 📌 차후 추가 기능 및 프로그램
- 자재 조회 ALV, 공정 조회 ALV. 각각에서 선택하고 버튼을 통해 자재-공정을 자동으로 연결해주는 기능 구현 필요

## 2. 발생한 기술적 오류 및 조치
- [오류] Subroutine이 전역 변수에 접근하면서 발생한 결합도 상승 문제 -> 상세 내용은 [07_issues/2026-04-10-ALL-weekly-dev-errors.md#issue-5](../../07_issues/2026-04-10-ALL-weekly-dev-errors.md#issue-5) 참고
