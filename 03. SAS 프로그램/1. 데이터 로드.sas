/*****************************************************************************************
** 프로그램 이름: I. 데이터 로드
** 작성자: 한노아 (PSD/AA)
** 작성일: 2024. 12. 31. (화)
******************************************************************************************/

/*****************************************************************************************
** 1. 라이브러리 할당
  - 실습에 활용할 작업 공간을 **Wrklib**으로 할당
  - **XLSX**로 저장되어 있는 데이터를 **Library로 할당**하여, 각 Sheet를 SAS 데이터로 변환 
******************************************************************************************/

libname WRKLIB "sas-viya-workbench-hands-on/02. SAS 데이터";
libname HRDATA xlsx "sas-viya-workbench-hands-on/01. RAW 데이터/HRData.xlsx";

/*****************************************************************************************
** 2. 포맷 파일 로드
******************************************************************************************/

/* 2.1 Xlsx에서 Wrklib으로 이동 */
data Wrklib.hrd_code;
    set HRData.codebook;
run;

/* 2.2. 데이터 확인 */
proc print data = Wrklib.hrd_code noobs;
run;

/* 2.3. 사용자 정의 포멧 적용 */ 
/*  - 사용자 정의 포맷은 **proc format** 프로시저로 적용할 수 있습니다. */
/*  - 적용 방법은 크게 두 가지가 있는데, 직접 값을 입력하는 방식과 아래와 같이 **데이터**를 이용하는 방법입니다. */
/*  - 보통은 사용자 정의 포맷이 많지 않은 경우에는 전자를 위와 같이 다양한 포맷이 있는 경우 후자를 이용합니다. */
proc format cntlin = Wrklib.hrd_code;
run;

/*****************************************************************************************
** 3. 데이터 로드
******************************************************************************************/

/* 3.1. 엑셀에서 SAS 데이터 셋으로 가져오기 */
data WRKLIB.hrd_data;
    set HRDATA.hrdata;
    attrib
        EMP_ID                           label = '[KN] 직원고유번호'
        SEX	                             label = '[IC] 성별'
        AGE	                             label = '[IN] 나이'
        MAR_ST_CD   format = $MAR_ST_CD. label = '[IC] 결혼상태코드'
        RACE_CD	    format = $RACE_CD.   label = '[IC] 인종코드'
        STAT_CD	    format = $STAT_CD.   label = '[IC] 지역코드'
        POSIT_CD    format = $POSIT_CD.  label = '[IC] 직위코드'
        DEPT_ID	    format = $DEPT_ID.   label = '[IC] 부서고유번호'
        MNGR_ID	    format = $MNGR_ID.   label = '[IC] 관리자고유번호'
        KPI_CD	    format = $KPI_CD.    label = '[IC] 핵심성과코드'
        SAL_AM	    format = comma8.     label = '[IN] 연봉'
        CTZ_CD	    format = $CTZ_CD.    label = '[IC] 시민권상태코드'
        TNR_DD	    format = comma8.     label = '[IN] 최소근속일수'
        RCRT_CD	    format = $RCRT_CD.   label = '[IC] 취업경로코드'
        ENG_SCR	    format = comma8.2    label = '[IN] 참여도설문점수'
        SAT_SCR	    format = comma8.2    label = '[IN] 직원만족도'
        PRJ_CN	    format = comma8.     label = '[IN] 특별프로젝트수행횟수'
        LT_DD	    format = comma8.     label = '[IN] 지각일수'
        ABSN	    format = comma8.     label = '[IN] 결근일수'
        TRMD_YN	                         label = '[TC] 퇴사여부'
    ;
run;

/* 3.2. 데이터 로드 결과 확인 */
proc print data = Wrklib.HRD_DATA(obs = 10) label noobs; run;

/*****************************************************************************************
** 4. Meta 데이터 만들어 두기
******************************************************************************************/

/* 4.1. Meta 데이터 추출 */
ods output Position=hrd_meta;
proc contents data = WRKLIB.hrd_data
              order= varnum
              ;
run;

/* 4.2. 역할, 유형 할당 */
data WRKLIB.hrd_meta;
    length
        num      8
        variable $32
        label    $40
        len       8
        role     $8
        type     $5
        format   $10
    ;
    set hrd_meta;
    /* 역할 할당 */
    select (substr(label,2,1));
        when ('K') role = 'key';
        when ('I') role = 'input';
        when ('T') role = 'target';
    end;
    select (substr(label,3,1));
        when ('N') type = 'num';
        when ('C') type = 'char';
    end;
    label = substr(label, 5);
    rename num = no;
    drop Member Informat;
run;

proc sort data = wrkLib.hrd_meta; by no; run;

proc print data = wrkLib.hrd_meta noobs; run;