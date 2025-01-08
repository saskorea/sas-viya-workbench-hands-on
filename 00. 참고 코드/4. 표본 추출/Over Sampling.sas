libname WRKLIB "sas-viya-workbench-hands-on/02. SAS 데이터";
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


%macro OverSampling(source_table=, target_table=, target_nm=, targetResponse=0.5, randomSeed=123123);
/*********************************************************************************
%let source_table  = WRKLIB.hrd_data;
%let target_table  = WRKLIB.hrd_data_SOS;
%let randomSeed    = 123123123;
%let targetResponse= 0.5;
%let target_nm     = TRMD_YN;
*********************************************************************************/
/* 1. majority class, total sample size 산출 */
/* 1.1. 각 class별 빈도 산출 */
proc freq data = &source_table. noprint;
    tables &target_nm. / out = _sos_temp_01_;
run;

/* 1.2. 빈도 내림차순으로 Target 변수의 각 class 이름 정렬*/
proc sort data = _sos_temp_01_;
    by descending count;
run;

/* 1.3. 빈도 및 class 이름 산출 결과 매크로 변수에 저장 */
proc sql;
    select &target_nm.
         , max(count) as majorityClassSize
         , sum(count) as totalSampleNumber
      into:class1-
         ,:majorityClassSize
         ,:totalSampleNumber
      from _sos_temp_01_
    ;
quit;

/* 2. 데이터 증강 */
/* 2.1. 요구 Sample Size 계산 */
%let requiredDataSize = %sysevalf( ( &majorityClassSize/(1-&targetResponse.) ) - &totalSampleNumber. );
%put NOTE: &=requiredDataSize.;

/* 2.2. 소수 Class에 속한 데이터만 추출 */
data _sos_temp_02_;
    set &source_table.;
    if &target_nm. = "&class2.";
run;

/* 2.3. 데이터 증강 */
proc surveyselect data     = _sos_temp_02_       /* 소수 Class 데이터 */
                  out      = _sos_temp_03_       /* 증강 결과 데이터 */
                  method   = urs                 /* 표본 추출 방법: Unrestricted Random Sampling */
                  sampsize = &requiredDataSize.  /* 추출할 표본 크기 */
                  seed     = &randomSeed.        /* 랜덤시드 */
                  outhits                        /* 출력 방식: 같은 데이터도 복사하여 행을 추가 */
                  ;
run;

/* 3. 결과 생성 */
/* 3.1. 원본 데이터와 증강 데이터 결합 */
data &target_table.;
    set &source_table.
        _sos_temp_03_
    ;
run;

/* 3.2. 결과 출력 */
proc freq data = &target_table.;
    tables &target_nm.;
    label &target_nm. = 'Target';
run;

/* 3.3. 임시 데이터 삭제 */
proc datasets lib = work nolist;
    delete _sos_temp_0:;
run;quit;

%mend OverSampling;