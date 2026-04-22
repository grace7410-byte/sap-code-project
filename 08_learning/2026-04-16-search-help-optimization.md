# 서치헬프(Search Help) 효율적 활용 가이드
Date: 2026-04-16

## 1. 학습 배경
SAP 개발할 때 모든 필드에 개별 Search Help Object를 만드는 건 공수가 너무 많이 들고 관리도 힘듦. 이걸 해결하기 위해 **Screen Painter 설정**이나 **ALV Field Catalog의 참조 속성**을 활용해서 최소한의 개발로 표준 서치헬프나 도메인 고정값(Fixed Value)을 호출하는 최적화 방법을 정리함.

---

## 2. 스크린 페인터(Screen Painter)에서 활용하기

스크린 페인터에서 인풋/아웃풋 필드(예: `gs_data-필드`) 클릭 후 **[Program] - Poss.entries Key** 설정을 통해 제어함.

* **설정값 가이드**:
    * `0`: 서치헬프 없음.
    * `1`: 필드 선택(Focus)했을 때만 네모 아이콘(ㅁ) 표시 (**강추**).
    * `2`: 선택 안 해도 기본으로 네모 아이콘 표시.
* **자동 연동 팁**: 
    * 필드에 **Foreign Key(FK)**를 걸어놨거나 도메인에 **Fixed Value(FV)**가 설정되어 있으면 따로 코딩 안 해도 알아서 가져옴.
    * 일반 변수(`gv_~`)라도 도메인에 FV가 있으면 잘 작동함.

---

## 3. ALV 환경에서 서치헬프 구현하기

### [방법 1] 구조체(i_structure_name) 활용 시
ALV 호출할 때 참조하는 테이블/구조체에 이미 마스터 데이터 관계가 설정되어 있다면 가장 편함.
![i_structure_name](./images/img1.png)

* **세팅**: 테이블 각 필드(자재마스터, 플랜트, 저장위치 등)에 FK를 걸어줌.
* **DATS 타입**: 자동으로 표준 달력이 띄워짐.

![dats_search_help](./images/img2.png)
*DATS 타입 서치헬프 예시*

### [방법 2] 필드 카탈로그(FCAT) 수동 설정 시
구조체 참조 안 하고 FCAT 직접 짤 때 참조 필드를 지정해서 서치헬프를 가져오는 방법임.

```abap
" - 마스터 테이블 참조 방식
CLEAR ls_fcat.
ls_fcat-fieldname   = 'MATNR'.
ls_fcat-ref_table   = 'ZTB1MM0007'. " 참조 테이블
ls_fcat-ref_field   = 'MATNR'.      " 참조 필드
ls_fcat-f4availabl  = 'X'.          " F4 아이콘 활성화
APPEND ls_fcat TO lt_fcat.
```
- ls_fcat-rollname 를 사용한다고 도메인의 FV를 가져와서 띄울 순 없었음
- 만약 도메인의 FV를 사용해 ALV 서치헬프를 구성하고 싶다면 아래의 방법 사용 

---

## 4. 직접 드롭다운(Dropdown) 구성하기

마스터 테이블이 없거나 도메인 고정값 외에 동적으로 리스트를 보여줘야 할 때 사용함.

### [방법 1] 데이터 설정 없이 필드 카탈로그만 연결

```abap
ls_fcat-fieldname   = 'MWSKZ'.   " 필드명
ls_fcat-drdn_hndl = '1'. " 지정한 핸들 번호(1) 연결
```
![Dropdown Result](./images/img3.png)
*ALV 드롭다운 적용 화면*

---

### [방법 2] 원하는 데이터로 드롭다운 설정

```abap
DATA: lt_dropdown TYPE lvc_t_drop,
      ls_dropdown TYPE lvc_s_drop.

" 1번 핸들에 들어갈 데이터 채우기 (도메인 FV 값 등)
ls_dropdown-handle = '1'.
ls_dropdown-value  = 'A0 (영세율)'.
APPEND ls_dropdown TO lt_dropdown.

ls_dropdown-handle = '1'.
ls_dropdown-value  = 'V1 (매입부가세 10%)'.
APPEND ls_dropdown TO lt_dropdown.

" ALV 객체 생성 직후(set_fcat 전)에 보따리 전달
go_grid->set_drop_down_table( it_drop_down = lt_dropdown ).
```
![Dropdown Result](./images/img4.png)
*ALV 드롭다운 적용 화면*

---

## 5. 결론

* 직접 드롭다운 하드코딩하는 것보다 마스터 테이블 만들고 FK 거는 게 유지보수 면에서 훨씬 낫다.
* 마스터 테이블이나 SH 오브젝트 만들기 싫으면 드롭다운이 대안이지만, 결국 정석은 마스터 테이블 + SH 연결이다.

![Search Help Creation](./images/img5.png)
*플랜트/저장위치 결합 서치헬프 생성 예시*

---

**관련 파일:**
* ./images/img1.png
* ./images/img2.png
* ./images/img3.png
* ./images/img4.png
* ./images/img5.png
