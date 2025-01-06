/*****************************************************************************************
** 프로그램 이름: 모형 학습 코드
** 작성자: 한노아 (PSD/AA)
** 작성일: 2025. 1. 6. (월)
******************************************************************************************/

/*****************************************************************************************
** 1. 사전 작업
******************************************************************************************/
/* 1.1. 라이브러리 할당 */
libname WRKLIB "sas-viya-workbench-hands-on/02. SAS 데이터";

/* 1.2. 사용자 정의 format 할당 */
proc format cntlin = WRKLIB.hrd_code; run;
proc format;
    value ROLFMT
        0 = '0:학습'
        1 = '1:평가'
        2 = '2:검증'
    ;
    value TGTFMT
        0 = '0:근속'
        1 = '1:퇴사'
    ;
run;

/* 1.3. 메타 정보 추출 */
%let IC_VARS =; 
%let IN_VARS =; 
%let TC_VARS =;
proc sql noprint;
    select variable into :IC_VARS separated by ' ' from WRKLIB.HRD_META where role = 'input' and type = 'char'; /* 문자형 입력 변수 */
    select variable into :IN_VARS separated by ' ' from WRKLIB.HRD_META where role = 'input' and type = 'num';  /* 숫자형 입력 변수 */
    select variable into :TC_VARS separated by ' ' from WRKLIB.HRD_META where role = 'target';                  /* 타겟 변수 */
quit;
%put NOTE: &=IC_VARS &=IN_VARS &=TC_VARS;


/*****************************************************************************************
** 2. 모형 적합
******************************************************************************************/

proc 