# Process Standardization & System Practice Meeting

## Date
2026-03-19

## Participants
PM(팀원1), PL(팀원4), 팀원3(CL), 팀원2, 팀원5, 팀원6, 팀원7 (Total 7)

---

## Key Discussion

### 1. Standard Configuration & Flow Refinement
실제 시스템 구축을 위한 기초 마스터 데이터 및 프로세스 흐름을 재정의함.
- **기초 세팅**: Company Code, Plant, SLoC, Cost/Profit Center, BP(Vendor/Customer) Role 정의.
- **구매(MM)**: ME49(Price Comparison) 기반 최적 공급처 선정 로직 검토. 운송 단계는 별도 CBO로 분리하여 비용 및 일정 관리.
- **생산(PP)**: 자재 단가 확정 시 공정별 투입 시간 및 단가 반영. MD04(Stock/Requirement List)의 오더 전환 기능을 CBO 설계에 참고.
- **판매(SD)**: 가용성 체크 및 Condition Type 기반 가격 결정(Pricing) 프로세스 정립.

### 2. Module Integration (FI/CO Focus)
SCM 중심 흐름에서 FCM 모듈의 개입 포인트를 명확화함.
- **FI**: 자재/BP 생성 시 계정 연결, 지급(Payment), 해징(Hedging), 반제(Clearing) 등 전 과정 모니터링.
- **CO**: Cost Center/Profit Center 생성, 자재 단가 확정 및 공정별 투입 비용 배부 참여.

### 3. Instructor Feedback & Strategy
- **결재(Approval)**: 모든 트랜잭션에 승인 로직을 추가하여 시스템 완성도 제고.
- **원가 체계**: 정유 공정(전처리/상압/후공정)별 세부 원가 집계 포인트 조사 필요.
- **사용자 편의성**: 인보이스 미리보기 등 'Simulation' 버튼 구현을 통해 CBO의 장점 극대화.

---

## Result (Hands-on Practice)

| 모듈 | 담당 | 주요 실습 내용 (T-Code) | 비고 |
| :--- | :--- | :--- | :--- |
| **FI** | 팀원2,5 | F-44(Clearing), F-53(Outgoing Payment) | 공급업체(10300001) 미결 전표 반제 완료 |
| **CO** | 팀원3,6 | FS00(G/L), KS01(Cost Center), KL01(Activity) | 전력비 계정(51001000) 및 인사 코스트센터 생성 |
| **SD** | 팀원1,7 | Condition Master, Sales Area 설정 | 마스터 생성 및 가격 결정 로직 분석 중 |
| **PP** | 팀원4 | Work Center, Routing 분석 | 공정별 투입 소요시간 및 단가 산출 구조 파악 |

---

## Next Action
- **조직정의서** 작성 및 **프로그램 계획서** 내 WBS 업데이트.
- 모듈별 핵심 기능/프로세스 Flow 구분 (Basic vs Additional).
