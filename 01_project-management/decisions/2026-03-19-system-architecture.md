# System Architecture & Core Logic Decision

Date: 2026-03-19

## Decision
C-nergy 프로젝트의 시스템 아키텍처 핵심 설계 원칙 및 마스터 데이터 구조 확정.

**1. Master Data Structure**
- **BP(Business Partner)**: FI 단에서 선행 정의 후 MM(Purchasing Org), SD(Sales Area) 확장 구조 적용.
- **Material Type**: 연산품(6종)에 대해 FERT/HALB 타입을 고정하지 않고, 후공정 재투입 및 배치 관리 편의성에 따라 CBO 상에서 유연하게 정의.
- **Bank Master**: 해징 및 대금 지급 프로세스를 위해 은행 마스터 및 관련 승인 로직 추가.

**2. Core Process Logic**
- **Interlock & Approval**: 해징 및 고액 구매 건에 대해 '승인 대기' 상태값을 도입하여 프로세스 분기 처리.
- **Cost Allocation**: 공정별(전처리/상압/후공정) Cost Center를 세분화하여 원가 집계의 정밀도 향상.
- **Unit Management**: 실무 단위(BBL 등)와 시스템 기본 단위 간의 변환 테이블 및 부피 보정 로직 설계.

## Reason
- 강사님 피드백을 반영하여 실제 엔터프라이즈 환경과 유사한 '통제(Control)' 기능을 강화함.
- 정유 산업 특유의 복잡한 원가 구조를 명확히 함으로써 CO 모듈의 존재 가치 확보.
- Hands-on Practice를 통해 확인된 SAP Standard 테이블 구조(SKA1, COEP 등)를 설계(ERD)에 직접 반영하기 위함.
