# [Issue] 자재 마스터 Work Scheduling 뷰 누락

Date: 2026-03-20
- Status: Resolved
- Module: PP/MM

## 발생 상황
- 생산 버전(`C223`) 생성 또는 라우팅 연결 시 특정 자재에 대해 진행 불가 메시지 발생.

## 원인 분석
- 자재 생성(`MM01`) 시 생산 실행에 필수적인 **Work Scheduling 뷰**를 선택하지 않아 관련 데이터(Production Supervisor 등)가 생성되지 않음.

## 해결 방법
- `MM01`에서 기존 자재 번호를 입력하고 **Work Scheduling 뷰만 체크**하여 추가 생성.
- Production Supervisor(001 등) 필수 필드 입력 후 저장.
- 이후 `C223`에서 Group Counter(1) 입력 및 [Check] 버튼을 통해 BOM/Routing 유효성 최종 승인.

## 참고 자료
- T-Code: MM01, C223
