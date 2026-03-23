# Integrated Process Flow v2.0

## 주요 흐름 변경점 (2026-03-23 반영)

1. **Inbound/Outbound Delivery 구체화**: 단순히 오더에서 입/출고로 가는 것이 아니라, 선박/유조차 기반의 운송 관리(Delivery Order) 단계를 명확히 함.
2. **물류센터(Distribution Center) 중심**:
   - 생산(Plant) -> 이동(STO) -> 물류센터(SLoc) -> 판매(Customer)
   - 모든 재고 파악 및 에이징 관리는 물류센터(SLoc) 레벨에서 수행.
3. **생산-판매 분리**: 실시간 연동을 끊고, 물류센터의 '재고 적정성'을 피드백으로 받아 PP의 생산 계획을 보정하는 루프(Loop) 구조 채택.
