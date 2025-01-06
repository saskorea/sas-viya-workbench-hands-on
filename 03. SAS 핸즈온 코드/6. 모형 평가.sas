/*****************************************************************************************
** 프로그램 이름: 모형 평가 코드
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
** 2. 평가 지표 생성
******************************************************************************************/
%macro assess_model(prefix=, var_evt=, var_nevt=);
proc assess data=WRKLIB.&prefix. (where = (_Partind_ = 1));
    input &var_evt.;
    target &TC_VARS / level=nominal event='1';
    fitstat pvar=&var_nevt. / pevent='0';
    
    ods output
      fitstat =WRKLIB.&prefix._fitstat 
      rocinfo =WRKLIB.&prefix._rocinfo 
      liftinfo=WRKLIB.&prefix._liftinfo
      ;
run;
%mend assess_model;

ods exclude all;
%assess_model(prefix=HRD_DATA_DTR,  var_evt=p_&TC_VARS.1, var_nevt=p_&TC_VARS.0);
%assess_model(prefix=HRD_DATA_LOG,  var_evt=p_&TC_VARS.1, var_nevt=p_&TC_VARS.0);
%assess_model(prefix=HRD_DATA_RFM,  var_evt=p_&TC_VARS.1, var_nevt=p_&TC_VARS.0);
%assess_model(prefix=HRD_DATA_SVM,  var_evt=p_&TC_VARS.1, var_nevt=p_&TC_VARS.0);
%assess_model(prefix=HRD_DATA_GBM,  var_evt=p_&TC_VARS.1, var_nevt=p_&TC_VARS.0);
ods exclude none;