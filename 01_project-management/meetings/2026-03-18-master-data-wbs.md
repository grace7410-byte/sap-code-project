# Master Data Analysis & WBS Planning Meeting

## Date
2026-03-18

## Participants
PM(팀원1), PL(팀원4), 팀원3(CL, 나), 팀원2, 팀원5, 팀원6, 팀원7 (Total 7)

## Agenda
1. Fiori 데모 서버 기반 마스터 데이터 필드 분석
2. C-nergy 핵심 비즈니스 키포인트 정의
3. 프로젝트 전체 일정(WBS) 및 산출물 정의

---

## Discussion

### 1. Module-based Research & Analysis
각 담당 영역별로 Fiori Launchpad 데모 서버를 활용하여 스탠다드 테이블 구조를 분석함.

- **SCM 파트**: SD(팀원7), MM(팀원3), PP(팀원4)
- **FCM 파트**: 팀원2, 팀원5, 팀원6
- **Total Process**: PM(팀원1)

**[BP & Material 분석 결과]**
- **BP**: Role(Supplier/Customer), Company Code, Purchasing/Sales Org 단위에 따라 최소 3개 이상의 DB 테이블 연관성 확인.
- **Material**: Plant 및 Valuation Area 단위 연동 확인. ERD 설계 시 Object Page 간의 연결 관계 반영 필요.
- **Material Type**: 연산품을 FERT(완제품)로 볼 것인지, 후공정 투입을 고려해 HALB(반제품)로 볼 것인지 논의. CBO 설계이므로 프로세스 연결성에 초점을 두어 유연하게 정의하기로 합의.

### 2. Industry Deep Dive (PM 공유)
정유/석유화학 산업의 큰 그림을 바탕으로 시나리오 확장.
- **Process**: 전처리 → 상압증류 → 후공정(벙커C유 재가공)의 흐름 구체화.
- **Scenario Extension**: 나프타를 경질/중질로 구분하여 석유화학 산업 파트로 연계하는 컨셉 검토 (방향성 명확화).

### 3. WBS (Work Breakdown Structure)
프로젝트 주요 마일스톤 및 산출물 일정 수립.
- **준비/분석**: 프로젝트 계획서, WBS, AS-IS/TO-BE, 조직정의서 (~3/20)
- **설계**: ERD, 테이블 정의서, 개발 리스트 및 스펙서 (~4/3)
- **구현/완료**: 통합 테스트(~6/5), 최종보고서 및 시연영상(~7/3)

---

## Conclusion
팀원3을 **CL(Module Design Leader)로** 선출하여 설계 단계의 전문성을 강화함. 확정된 4대 Key-Point를 중심으로 1차 컨설턴트 리뷰를 대비하기로 함.

---

## Next Action
- 금요일까지 조직정의서 및 1차 리뷰 산출물 완료
- 모듈별 핵심 기능/프로그램/프로세스 키포인트 도출
