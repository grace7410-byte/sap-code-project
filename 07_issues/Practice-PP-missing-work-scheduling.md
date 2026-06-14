# Standard Practice
## 자재 마스터 Work Scheduling 뷰 누락

Date: 2026-03-20
- Status: Resolved
- Module: PP/MM

## 발생 상황
- **Standard 실습 단계**: 생산 버전(`C223`) 생성 및 라우팅(Routing) 연결 단계.
- **현상**: "Material XXXX does not exist in plant XXXX (Work Scheduling)" 등의 에러 메시지가 발생하며 생산 버전 저장 불가.

## 원인 분석
- **마스터 데이터 설정 누락**: 자재 마스터(`MM01`) 초기 생성 시, 구매(Purchasing)나 회계(Accounting) 뷰는 생성했으나 생산 실행에 필수적인 **Work Scheduling(작업 스케줄링) 뷰**를 선택하지 않음.
- **영향**: 해당 뷰가 없으면 생산 관리자(Production Supervisor)나 공정 관리 데이터가 존재하지 않아 시스템이 해당 자재를 '생산 가능한 상태'로 인식하지 못함.

## 해결 방법
- **Step 1. 뷰 확장(Extension)**: `MM01`에서 기존에 만든 자재 번호를 다시 입력함. (새로 만드는 것이 아니라 기존 번호에 뷰만 추가하는 과정)
- **Step 2. 뷰 선택**: [Select View] 창에서 **Work Scheduling** 뷰만 체크하여 확인.
- **Step 3. 필수 값 입력**: 플랜트(1010) 입력 후, 내부 데이터에서 **Production Supervisor(001 등)와** **Production Scheduling Profile**을 입력하고 저장.
- **Step 4. 재연결**: 이후 `C223`으로 돌아가 Group Counter(1)를 입력하고 [Check] 버튼을 눌러 BOM/Routing에 초록불이 들어오는지 확인.

## 참고 자료
- T-Code: MM01 (View Extension), C223 (Production Version)
- 주요 필드: Production Supervisor (생산 담당자 구분을 위해 필수)
