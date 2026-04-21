# Feature List

Date: 2026-04-22 (v1)

프로젝트에서 구현할 주요 기능 및 프로그램 목록을 관리합니다.

| Feature | Description | Related Module | Owner | Status |
|:---|:---|:---|:---|:---|
| **구매오더 관리** | 원유 및 부자재 구매 오더 생성 및 변경(CU) | MM | Team | Implemented |
| **서비스 엔트리 관리** | 운송 등 서비스 용역에 대한 실적 기록 및 조회 | MM | Team | Implemented |
| **선적 입고 관리** | 정유 특화 선적 서류 기반 입고 및 부피 보정(CRU) | MM | Team | Development |
| **자재-공정 연결** | BOM 및 Routing 정보를 연계한 공정 마스터 관리 | PP | Team | Implemented |
| **MRP 실행 및 조회** | 자재 소요량 계획 수립 및 결과 모니터링 | PP | Team | Development |
| **주문 관리** | 고객사 석유 제품 판매 오더 관리 | SD | Team | Implemented |
| **출고 관리** | 판매 오더 기반의 물류 센터 출고 처리 | SD | Team | Development |
| **시즌별 판매 분석** | 기간별/제품별 판매 실적 시각화 대시보드 | SD | Team | Implemented |
| **물류센터 MRP/운송 요청** | 거점별 재고 보충 계획 및 본사 운송 요청 | SD | Team | Development |
| **구매 전표 관리** | 매입 관련 회계 전표 자동 생성 및 조회 | FI | Team | Development |
| **판매 전표 관리** | 매출 관련 회계 전표 자동 생성 및 조회 | FI | Team | Development |
| **생산 전표 관리** | 생산 원가 및 투입/산출 전표 관리 | FI | Team | Development |
| **전표 조회 대시보드** | 전사 모듈 통합 회계 전표 모니터링 및 상세 조회 | FI | Team | Implemented |
| **공정 계획/실적 조회** | 생산 공정별 계획 대비 실적 분석 및 리포트 | CO | Team | Implemented |
| **PO 승인 프로세스** | 구매 오더 승인 및 이력 관리(CRUD) | MM | Team | Planning |
| **실재고 입고 및 로스 처리** | 창고 실재고 입고 및 증발 로스(Loss) 계정 처리 | MM | Team | Planning |
| **송장 검증** | 송장(Invoice) 대조 및 회계 전표 생성 연동(CR) | MM | Team | Planning |
| **공급업체 관리** | 원유 공급사 및 서비스 벤더 마스터 관리(CRUD) | MM | Team | Planning |
| **전처리 공정 관리** | 원유 증류 전 불순물 제거 및 전처리 단계 실적 관리 | PP | Team | Planning |
| **BOM 관리** | 연산품 및 부산물 구성을 위한 BOM 마스터(CRUD) | PP | Team | Planning |
| **생산 오더 Release** | 계획 오더의 실행 전환 및 가용성 점검 | PP | Team | Planning |
| **WC 상태 수정** | Work Center 가동 상태 모니터링 및 변경 | PP | Team | Planning |
| **WC 일정 추적/변경** | 설비 일정 스케줄링 및 부하 조정 | PP | Team | Planning |
| **대금 청구 관리** | 판매 실적 기반 Billing Document 생성 및 관리 | SD | Planning |
| **마진 분석** | 원가 대비 판매가 분석을 통한 수익성 검토 | SD | Team | Planning |
| **본사 운송 승인 처리** | 물류센터 보충 요청에 대한 본사 승인 및 배분 | SD | Team | Planning |
| **재무상태표 (B/S)** | 특정 시점의 기업 재무 상태 보고서 | FI | Team | Planning |
| **손익계산서 (P/L)** | 일정 기간의 경영 성과 및 손익 분석 보고서 | FI | Team | Planning |
| **결산 - 월/연** | 월말 및 연말 회계 마감 프로세스 자동화 | FI | Team | Planning |
| **세금 추적 조회** | 매입/매출 부가세 및 세금 코드별 추적 리포트 | FI | Team | Planning |
| **G/L 계정 관리** | 총계정원장 계정 생성 및 마스터 관리 | FI | Team | Planning |
| **공정 실적 입력** | 생산 단계별 실제 투입 및 산출량 기록 | CO | Team | Planning |
| **원가 계산** | 제품별 실제 원가 계산 및 표준 원가 차이 분석 | CO | Team | Planning |
| **공정 시뮬레이터** | 변수 기반 생산 수율 및 원가 시뮬레이션 | CO | Team | Planning |
| **공정 계획 관리** | 공정 계획 수립, 추가 및 삭제 프로세스 | CO | Team | Planning |

## Status Guide

- **Planning** : 요구사항 정의 및 프로세스 설계 단계
- **Design** : 테이블 및 상세 UI 설계 진행 중
- **Development** : 핵심 로직(CUD 등) 코딩 진행 중
- **Implemented** : 1차 기능 구현 완료 (기능 단위 테스트 완료)
- **In-Review** : 피드백 반영 및 고도화 중 (5월/6월 시연용)
- **Done** : 최종 안정화 및 배포 완료 (7월 최종본)
