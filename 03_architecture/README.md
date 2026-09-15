# System Architecture

프로젝트 전체 시스템 구조와  
모듈 간 연결 관계를 정리하는 공간입니다.

## System Flow 변천사

설계가 진행되며 통합 프로세스 흐름이 총 5차례 개정되었습니다. 버전별로 무엇이 왜 바뀌었는지는 아래에서 확인할 수 있습니다.

| 버전 | 날짜 | 문서 | 핵심 변경점 |
| --- | --- | --- | --- |
| v1 | 2026-03-18~20 | [system-flow.md](system-flow.md) | 최초 통합 To-Be 흐름도 (수요 기반 최적 수율 생산) |
| v2 | 2026-03-23 | [system-flow-v2.md](system-flow-v2.md) | Inbound/Outbound Delivery 구체화, 물류센터(DC) 중심 구조 도입 |
| v3 | 2026-03-30 | [system-flow-v3.md](system-flow-v3.md) | 1차 컨설턴트 리뷰 반영 — 대금 지급 시점·재고 인식 시점 재설계 |
| v4 | 2026-04-03 | [system-flow-v4.md](system-flow-v4.md) | 구매·물류 이원화 정산 및 부피 보정(MM-FI) 고도화 |
| v5 (Final) | 2026-07-15 | [system-flow-final.md](system-flow-final.md) | 품질 조건문(염분 수치) 추가, CO 원가 분석 시점 정교화, 최종 시연 프로세스 확정 |

## 기타 문서

- [2026-04-23-advanced-module-interface.md](2026-04-23-advanced-module-interface.md) — 모듈 간 고급 인터페이스 설계
- [2026-05-11-advanced-cost-interface.md](2026-05-11-advanced-cost-interface.md) — 원가 연동 고급 인터페이스 설계
- `images/` — 버전별 Process Flow 다이어그램 원본
