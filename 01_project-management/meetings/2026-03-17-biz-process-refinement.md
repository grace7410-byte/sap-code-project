# C-nergy Business Process Refinement Meeting

## Date
2026-03-17

## Participants
PM, PL, Team Members (Total 7)

## Agenda
C-nergy 기업 포지셔닝 확정 및 5대 Business Challenge 기반 AS-IS/TO-BE 설계

---

## Discussion

### 1. Corporate Positioning
현대오일뱅크를 레퍼런스로 하되, 연 매출 5,000억 규모의 중견 정유사 'C-nergy'로 설정함. 대기업의 복잡한 기능 모방이 아닌, 데이터 단절 해소와 경영 투명성 확보를 목표로 함.

### 2. Business Challenge & Solution (AS-IS/TO-BE)

**[생산 및 재고 관리]**
- **AS-IS**: CDU 연산품 구조로 인해 특정 제품 수요 대응 불가. 탱크 포화 시 공정 중단 발생.
- **TO-BE**: 촉매 기반 **후공정(재가공)** 및 **Reverse BOM** 정의. 수요 기반 수율 조정 체계 구축.

**[원가 및 수익성 분석]**
- **AS-IS**: 3년 장기 계약 기반 원유 도입 중이나 제품별 원가 배분 기준 부재. 실제 마진 파악 불능.
- **TO-BE**: 환율 및 유종별 수율 기반 원가 배분 로직 설계. 시장 가격 변동에 따른 수익 극대화 전략 수립.

**[품질 및 시스템 통합]**
- **AS-IS**: QM-PP 시스템 단절로 부적합 원료 투입 시 수동 차단 의존. 현장 수기 기록으로 인한 데이터 시차 발생.
- **TO-BE**: 품질 데이터 실시간 연동을 통한 자동 루트 차단. 모바일(QR/바코드) 기반 현장 즉시 전표 생성.

**[재고 정합성 확보]**
- **AS-IS**: 온도 변화 및 계기 오차로 인한 장부-실재고 불일치 지속 발생.
- **TO-BE**: **날씨 API** 연동을 통한 온도 기반 부피 보정 로직 적용. 실제 증발 손실과 부피 변화 구분 관리.

---

## Technical Spec Confirmation

### Master Data
- **Vendor**: ARABU(중동), USU(미국), EUU(유럽)
- **Catalyst**: Ni-Mo, Zeolite
- **Product**: LPG, 휘발유, 나프타, 항공유, 디젤, 아스팔트 (+벙커C유)

### Process Condition
- **FCC**: Zeolite 촉매 기반 휘발유 분해
- **Hydrotreating**: Ni-Mo 촉매 기반 항공유 개질 (LHSV 1.5 ~ 3.0)
- **Hydrocracking**: Ni-Mo 촉매 기반 경유 분해 (LHSV 0.5 ~ 1.5)

---

## Result
C-nergy 기업 상황에 최적화된 **5대 비즈니스 개선 시나리오**와 핵심 마스터 데이터를 확정함. 해당 내용을 바탕으로 상세 기능 설계(Features) 단계로 진입하기로 합의함.

---

## Next Action
- 모듈별(MM, SD, PP, FI, CO) 상세 프로세스 맵 작성
- 외환 Hedging 및 원가 리스크 관리 체계 심화 조사
