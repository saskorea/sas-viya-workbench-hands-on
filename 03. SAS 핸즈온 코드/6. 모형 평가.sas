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
%assess_model(prefix=HRD_DATA_LGB,  var_evt=p_&TC_VARS.1, var_nevt=p_&TC_VARS.0);
ods exclude none;


/*****************************************************************************************
** 3. 시각화를 위한 데이터 구성
******************************************************************************************/
/* 3.1. ROC 그래프 */
data WRKLIB.all_rocinfo;
  set WRKLIB.HRD_DATA_LOG_rocinfo (in=m1)
      WRKLIB.HRD_DATA_RFM_rocinfo (in=m2)
      WRKLIB.HRD_DATA_GBM_rocinfo (in=m3)
      WRKLIB.HRD_DATA_SVM_rocinfo (in=m4)
      WRKLIB.HRD_DATA_DTR_rocinfo (in=m5)
      WRKLIB.HRD_DATA_LGB_rocinfo (in=m6)
  ;
  length model $ 30;
  if m1 then model = '로지스틱회귀';
  if m2 then model = '랜덤포레스트';
  if m3 then model = '그레디언트부스팅';
  if m4 then model = '서포트벡터머신';
  if m5 then model = '의사결정나무';
  if m6 then model = '라이트GBM';
run;
ods graphics on / width=8in height=6in;
proc sgplot data=WRKLIB.all_rocinfo aspect=1;
  title "ROC Curve";
  xaxis values=(0 to 1 by 0.25) grid offsetmin=.05 offsetmax=.05; 
  yaxis values=(0 to 1 by 0.25) grid offsetmin=.05 offsetmax=.05;
  lineparm x=0 y=0 slope=1 / transparency=.7;
  series x=fpr y=sensitivity / group=model;
run;
title;
ods graphics off;


/* 3.2. 향상도 그래프 */
data WRKLIB.all_liftinfo;
  set WRKLIB.HRD_DATA_LOG_liftinfo (in=m1)
      WRKLIB.HRD_DATA_RFM_liftinfo (in=m2)
      WRKLIB.HRD_DATA_GBM_liftinfo (in=m3)
      WRKLIB.HRD_DATA_SVM_liftinfo (in=m4)
      WRKLIB.HRD_DATA_DTR_liftinfo (in=m5)
      WRKLIB.HRD_DATA_LGB_liftinfo (in=m6)
  ;
  length model $ 30;
  if m1 then model = '로지스틱회귀';
  if m2 then model = '랜덤포레스트';
  if m3 then model = '그레디언트부스팅';
  if m4 then model = '서포트벡터머신';
  if m5 then model = '의사결정나무';
  if m6 then model = '라이트GBM';
run;
ods graphics on / width=8in height=6in;
proc sgplot data=WRKLIB.all_liftinfo; 
  title "Lift Chart (using validation data)";
  yaxis label=' ' grid;
  series x=depth y=CumLift / group=model markers markerattrs=(symbol=circlefilled);
run;
title;
ods graphics off;


