# Integrated Process Flow & Consultant Review Prep Meeting

## Date
2026-03-20

## Participants
PM, PL, CL, Team Members (Total 7)

## Agenda
모듈별 실습 결과 공유 및 정유 산업 특화 TO-BE 프로세스 Flow 최종 확정

---

## Discussion

### 1. Module Practice Review (Key Findings)
- **SD (판매)**: '독일 함부르크 주유소' 시나리오를 통해 조계계정(14107000) 연결 및 ATP 재고 부족 시 대응 방안 확인. 견적(Quotation) 참조 기능을 통한 업무 효율성 검증.
- **PP (생산)**: 원유 투입 시 4종 제품이 동시에 나오는 역BOM 구조 구현. C223 생산 버전 체크 및 CK11N을 통한 표준 원가 산출 프로세스 정립.
- **FI/CO (재무/관리)**: OBYC(BSX, GBB)와 VKOA를 통한 자동 분개 설정. 특히 운송비(ERU) 부채 인식 로직을 통해 수익-비용 대응 원칙 구현 가능성 확인.
- **MM (구매)**: 원유(OIL1001) 마스터 및 공급업체 매핑을 통한 PO 생성.

### 2. Refining C-nergy To-Be Process
정유 산업의 비즈니스 챌린지를 해결하기 위한 통합 Flow를 확정함.
- **Problem**: 원유 도입 리드타임(45일+)으로 인해 즉각적인 수요 대응 불가.
- **Solution**: 
    1. **SD 우선**: 판매 오더 시 실시간 가용 재고(완제품) 확인 및 출고.
    2. **Trigger 로직**: 재고 차감과 동시에 생산팀에 생산 요청 전송 (커스텀).
    3. **수율 최적화 (The Synergy)**: 시장 가격(Singapore 시황) 데이터를 수집하여 후공정 촉매 투입량을 조절, 마진이 높은 제품의 수율을 극대화함.

### 3. Consultant Q&A List
1. 역BOM 설계 시 더미 자재 활용의 적절성.
2. SAP Standard 내 배럴(BBL, BB6) 단위 활성화 방법.
3. Sales/Purchase/Production Order 단계별 결재 프로세스 삽입 시점.
4. 해외 은행 연동 및 해징 승인 로직 범위.
5. Fiori 대비 SAP GUI에서의 수동 지급(Payment) 프로그램 확인.
6. CO 설계 시 데이터 가시성 vs 발전 요소 제안 중 우선순위.

---

## Conclusion
모듈별 Standard 기능을 확인 완료하였으며, 이를 기반으로 C-nergy만의 차별화된 '수요 기반 최적 생산 시스템' 설계를 위한 1차 리뷰 준비를 마침.

---

## Next Action
- 3/23(월) 1차 컨설턴트 리뷰 세션 참석
- 리뷰 결과에 따른 ERD 및 테이블 설계 착수
