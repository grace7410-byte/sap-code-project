# Process Redesign & Inventory Logic Decision

Date: 2026-03-23

## Decision
1st 컨설턴트 리뷰 피드백을 반영하여 C-nergy 프로젝트의 핵심 프로세스 및 관리 지표 전면 수정.

**1. Process Layout Change**
- **Production Strategy**: 실시간 수요 대응 생산 로직을 폐기하고, 정유 산업 특성인 MTS(Make-to-Stock) 기반 '장기/계절 수요 예측 생산' 모델로 전환.
- **Logistics Center**: 생산 플랜트와 판매처 사이에 '물류센터(Distribution Center)' 거점을 추가하여 재고 이동(Plant Transfer) 및 배분 관리 로직 도입.
- **Hedging Removal**: 구현 복잡성 대비 프로젝트 몰입도 저해 우려로 해징(Hedging) 프로세스 삭제.

**2. Core Management Logic**
- **Aging & Loss Control**: 물류센터 입고 시점 기준 '재고 체류 시간(Aging)' 모니터링 및 온도/밀도 차이에 따른 '증발 손실(Loss)' 자동 전표 처리 로직 설계.
- **Approval Workflow**: 고액 거래 리스크 관리를 위해 구매(PR to PO) 및 판매(SO Creation) 단계에 배럴/금액 임계치 기반 승인 프로세스 강제 적용.
- **Delivery Detail**: 선박/유조차 기반 운송 관리를 위해 인바운드/아웃바운드 딜리버리(In/Outbound Delivery) 단계를 프로세스에 명문화.

## Reason
- 정유 산업의 긴 리드타임과 연속 공정 특성을 고려할 때, 기존의 실시간 생산 트리거 방식은 비현실적이라는 컨설턴트 피드백 수렴.
- '이익 극대화'보다 실무적인 '비용 최소화(손실 및 재고 관리)'에 집중하여 시스템의 실효성 확보.
- 불필요한 금융 로직(해징)을 걷어내고 SAP Standard 모듈(MM, SD, PP) 간의 데이터 정합성과 물류 흐름 구현에 리소스 집중.
