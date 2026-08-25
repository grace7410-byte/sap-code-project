# [Anvil Integrated Issue Log] 2026-06-05 전사 통합 개발 이슈 모음집

목적: 전사 모듈(MM/SD/PP/FI/CO) 구현 과정에서 발생한 모든 기술적 오류, 시스템 버그 및 트러블슈팅 내역을 한 번에 통합 관리함.
1) 발생 현상, 2) 해결 방안 및 조치 순으로 기재.

---

## [Issue #1] 서비스 오더 금액 100배 오적재 (PP) <a id="issue-1"></a>

### 1) 발생 현상

- 서비스 오더에 금액 입력 시, 금액이 100배 곱해져서 DB TABLE에 반영됨

### 2) 해결 방안 및 조치

- 초기에 CDS VIEW에서 금액을 KRW가 아닌 USD로 대응시켜 놓았던 것이 원인. DB TABLE 저장 시 `CURRENCY_AMOUNT_IDOC_TO_SAP` FUNCTION MODULE을 사용하여 대응 CURRENCY를 KRW로 변경

---

## [Issue #2] DB VIEW 연동 후 덤프 발생 (CO) <a id="issue-2"></a>

### 1) 발생 현상

- 기존 프로그램에서 하드코딩 형식을 지우고 DB VIEW를 추가하였으나, 덤프가 발생

### 2) 해결 방안 및 조치

- 기존 테이블과 DB의 연동이 프로그램과 맞지 않아 발생한 문제로, 새 테이블을 만들어서 해결

---

## [Issue #3] PDF 변환 시 보안 경고 창 중복 및 오픈 오류 (MM) <a id="issue-3"></a>

### 1) 발생 현상

- PDF 변환을 위해 PC 환경변수(TEMP) 조회 과정에서 SAP 보안 경고 창이 중복 발생, 사용자가 Deny 선택 시 오히려 불일치하는 임시 경로가 생성되면서 파일이 오픈되는 에러 발생

### 2) 해결 방안 및 조치

- 윈도우 환경 변수를 매번 조회하는 불안정한 방식 대신, 로컬 다이얼로그(file_save_dialog)로 사용자가 명시적으로 선택한 안전한 경로를 전달받아 PDF를 변환하도록 구조 변경(기존: 바로 파일 오픈 → 수정: 선택 경로 저장 후 오픈)

---

## [Issue #4] 송장 검증 헤더-아이템 금액 밸런스 불일치 (MM) <a id="issue-4"></a>

### 1) 발생 현상

- 송장 검증 시 헤더 외화 총액과 아이템 원화 총합 간 금액 밸런스가 맞지 않아 저장이 거부되는 정합성 오류 발생

### 2) 해결 방안 및 조치

- 선행 프로세스인 서비스 PO 아이템 생성 단계부터 원화 금액 데이터가 실제보다 100배 부풀려져 적재된 것이 원인. 송장 프로그램 구조는 유지하고, 서비스 PO 담당자에게 원천 데이터가 CURRENCY_AMOUNT_IDOC_TO_SAP로 정상 포맷 적재되도록 요청

---

## [Issue #5] 헤더-아이템 원화 금액 자릿수 불일치로 인한 연산 경고 (MM) <a id="issue-5"></a>

### 1) 발생 현상

- 헤더-아이템 원화 금액 차이(lv_compare) 계산 시, 소수점이 남아있는 아이템 누적액과 펑션을 거쳐 .00으로 닫힌 헤더 변수 간 자릿수 불일치로 SAP 컴파일러가 임의 P(8,0) 가정 연산 경고를 출력

### 2) 해결 방안 및 조치

- 연산 전용 변수(lv_compare, lv_rounded_item) 타입을 p LENGTH 13 DECIMALS 2로 명시 선언해 경고 제거, 아이템 누적액을 round(dec=0)로 반올림 후 헤더와 비교·오차 보정(±2원) 수행하도록 수정

---

## [Issue #6] CDS 뷰 OData 노출 시 Parameter has no data element 오류 (MM) <a id="issue-6"></a>

### 1) 발생 현상

- Fiori 연동을 위해 CDS 뷰를 OData 서비스로 노출할 때, Parameter has no data element 정합성 오류가 발생

### 2) 해결 방안 및 조치

- 입력 파라미터가 단순 ABAP 내장 타입(abap.dats)으로 선언되어 통신 규격이 모호했던 것이 원인. 표준 데이터 엘리먼트 타입(zeb1_mm_bldat)으로 변경

---

## [Issue #7] 집계 함수 포함 CDS 뷰의 OData 매핑 호환성 오류 (MM) <a id="issue-7"></a>

### 1) 발생 현상

- 환율 테이블 조인을 위해 max(b.ukurs) 집계 함수와 거대한 GROUP BY 구문이 포함된 zcds_b1_mm_0001 CDS 뷰를 OData Service로 매핑하려 하자 호환성 오류 발생

### 2) 해결 방안 및 조치

- 0001 뷰를 감싸는 Consumption View인 zcds_b1_mm_0004를 만들어 이를 통해 Service를 생성

---

## [Issue #8] SEGW UPDATE_ENTITY 반영 누락 (MM) <a id="issue-8"></a>

### 1) 발생 현상

- SEGW UPDATE_ENTITY(PUT) 요청 시 데이터 반영 누락 및 빈 값 반환 오류 발생(HTTP 상태코드는 204/200 성공이지만 실제 DB와 응답 결과에는 공백). 디버깅 결과 read_entry_data로 가공된 새 데이터(ls_entity)를 기존 DB 레코드(ls_data)에 덮어쓰는 MOVE-CORRESPONDING 구문 누락 확인

### 2) 해결 방안 및 조치

- UPDATE_ENTITY 메서드 내부 DB 존재 여부 체크 직후 `MOVE-CORRESPONDING ls_entity TO ls_data.` 구문을 삽입해 요청된 변경값(ZSEL='X')이 정상 반영되도록 수정

---

## [Issue #9] Fiori GeoMap 라이브러리 미로딩 (MM) <a id="issue-9"></a>

### 1) 발생 현상

- Fiori 프로그램 구현 중 Geomap이 반복적으로 뜨지 않는 현상 발생

### 2) 해결 방안 및 조치

- sap.ui.geomap 라이브러리 파일 자체를 불러오지 못해 404(Not Found) 에러 발생 확인. 로컬 개발 환경의 라이브러리 참조 주소에 해당 기능이 없거나 권한이 맞지 않는 인프라 문제로 판단, AnalyticMap으로 변경 결정

---

## [Issue #10] Fiori-Gateway 날짜 전달 시 Timezone Shift 오차 (PP) <a id="issue-10"></a>

### 1) 발생 현상

- Fiori에서 날짜 데이터를 gateway로 보내면 timezone shift로 인해 오차가 발생

### 2) 해결 방안 및 조치

- urlParameters에 문자열로 추가 후 새로운 method(zcl_b1_pp_toolbox=>get_url_paramters)를 활용해 문자열로 받도록 변경

---

## [Issue #11] CDS 뷰 서치헬프 Selection Method 미지원 (FI) <a id="issue-11"></a>

### 1) 발생 현상

- 서치헬프를 만들려는데, Selection Method에 CDS VIEW를 넣을 수 없었음

### 2) 해결 방안 및 조치

- (신) CDS VIEW는 Selection Method에 넣을 수 없어, 서치헬프를 넣으려는 스크린의 Flow logic에서 PROCESS ON VALUE-REQUEST.로 서치헬프를 구현

---

## [Issue #12] ALV 트리 단일 데이터 노드 중복 구성 (FI) <a id="issue-12"></a>

### 1) 발생 현상

- 자산-건물과 같이 데이터가 하나뿐인 경우에도 부모노드-자식노드-LEAF 노드로 구성되어, 굳이 폴더를 하나 더 열도록 구성됨

### 2) 해결 방안 및 조치

- 그룹별 행의 개수를 세서 IF문으로 1개일 때와 1개 이상일 때를 나누어 노드를 다르게 추가 설정하도록 함

---

## [Issue #13] Update_entity 실행 시 501 에러 발생 (SD) <a id="issue-13"></a>

### 1) 발생 현상

- Update_entity 실행 시 501 에러 발생

### 2) 해결 방안 및 조치

- get_entity 없이 update하려다 501 에러가 발생한 것으로 확인. get_entity와 update는 세트로 재정의해야 함

---

## [Issue #14] 필드 심볼 하드코딩 시 필드명 인식 오류 (SD) <a id="issue-14"></a>

### 1) 발생 현상

- `<fs>-pv_fname` 형태로 컴파일 시점에 하드코딩하려 했으나, 시스템이 변수 내부 값이 아닌 문자 그대로의 pv_fname을 필드로 인식해 에러 발생

### 2) 해결 방안 및 조치

- 필드 심볼 내부의 필드명을 변수로 지정할 때는 직접 접근(-)이 불가능함. `ASSIGN COMPONENT [변수] OF STRUCTURE [구조체] TO [필드심볼]` 구문을 사용해 동적으로 바인딩

---

## [Issue #15] get_domain_values 호출 시 타입 불일치 오류 (SD) <a id="issue-15"></a>

### 1) 발생 현상

- get_domain_values 호출 시 domname 부분에서 에러 발생

### 2) 해결 방안 및 조치

- 서브루틴 파라미터를 가변 길이 문자열(TYPE string)로 선언했으나, 펑션 인터페이스의 domname은 고정 길이 문자 타입이라 타입 에러 발생. 정의부 파라미터 타입을 표준 타입 domname으로 선언해 해결
