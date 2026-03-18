# Business Model & Master Data Decision

Date: 2026-03-17

## Decision
C-nergy 비즈니스 모델 및 핵심 Master Data 확정.

**1. Positioning**
- Target: C-nergy (연 매출 5,000억 규모 중견 정유사)
- Reference: 현대오일뱅크 (Process 최적화 모델)
- Goal: 현장-전산 데이터 단절 해소 및 경영 투명성 확보

**2. Master Data**
- Vendor: ARABU(중동), USU(미국), EUU(유럽)
- Crude Oil: WTI, Brent, Dubai
- Catalyst: Ni-Mo(NIMO), Zeolite(ZEOL)
- Product: LPG, 휘발유, 나프타, 항공유, 디젤, 아스팔트 (+벙커C유)
- Customer: 국내 5개사(지수화학 등), 국외 4개사(WS Airlines 등)

**3. Process Spec (Catalyst & Condition)**
| 제품 | 공정명 | 사용 촉매 | 상세 조건 |
| :--- | :--- | :--- | :--- |
| 휘발유 | FCC | Zeolite | 유동층 촉매 분해 |
| 항공유 | Hydrotreating | Ni-Mo | LHSV $1.5 \sim 3.0$ |
| 경유 | Hydrocracking | Ni-Mo | LHSV $0.5 \sim 1.5$ |

## Reason
- 성장기 중견 기업에 최적화된 데이터 경영 체계 수립 필요
- 연산품 구조 및 후공정(재가공) 로직의 시스템화 근거 마련
- Standard 기능 외 CBO 개발 범위(원가/품질 연동/부피 보정)의 데이터 기준 확립
