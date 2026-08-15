# Project Management

프로젝트 진행 과정에서 발생 일지, 회의록, 주요 의사결정 사항을 기록하는 공간입니다.

## Directory Structure

* **daily-log/**: 일별 진행 상황 요약 (개별 파일: `YYYY-MM-DD.md`)
* **meetings/**: 회의록 및 논의 내용 기록 (개별 파일: `YYYY-MM-DD-topic.md`)
* **decisions/**: 최종 확정된 의사결정 사항 아카이브 (개별 파일: `YYYY-MM-DD-topic.md`)

---

## Document Guidelines

### 1. daily-log
* **목적**: 당일 작업 내용과 핵심 포커스 기록
* **원칙**: 1~2분 내로 스캔 가능하도록 최대한 간결하게 작성
* **템플릿**:

  `# YYYY-MM-DD`
  `## Summary`
  `- 당일 진행한 작업 간략 요약`

  `## Key Discussion`
  `- 주요 논의 포인트`

  `## Decision`
  `- 확정 사항 (있을 경우만 작성, 없으면 생략 가능)`

  `## Tomorrow Focus / Next Week Focus`
  `- 다음 행동 및 우선 과제`

---

### 2. meetings

* **목적**: 회의에서 언급된 팀원들의 실제 발언, 아이디어, 논의 흐름 보존
* **원칙**: 단순 장황한 보고서 형식을 지양하고 Agenda, Key Discussion, Result 중심 구성
* **템플릿**:

  `# [회의 주제]`

  `- **Date**: YYYY-MM-DD`
  `- **Agenda**: 회의 목적 및 안건`
  
  `## Key Discussion`
  `- 팀원별 의견 및 논의 상세 흐름`
  
  `## Result / Conclusion`
  `- 회의 결론 및 역할 분담`

---

### 3. decisions

* **목적**: 프로젝트 방향성을 결정짓는 핵심 선택지 확정건 기록
* **원칙**: 회의 과정이나 검토 단계는 제외하고 '최종 결과'만 기록
* **템플릿**:

`# [의사결정 주제]`

`- **Date**: YYYY-MM-DD`
`- **Status**: Approved / Deprecated`

`## Context`
`- 결정이 필요했던 배경`

`## Decision`
`- 확정된 최종 내용`

