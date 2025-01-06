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
/* 2.1. 트리기반 모형 */
/* 1) 의사결정나무(viya) */
proc treesplit data = WRKLIB.HRD_DATA_PARTED;
    input  &IN_VARS / level = interval;
    input  &IC_VARS / level = nominal;
    target &TC_VARS / level = nominal;
    partition rolevar = _PartInd_ (train = '0' valid = '1' test = '2');
    format &TC_VARS best8.;
    output out = WRKLIB.HRD_DATA_DTR
        copyvars = ( EMP_ID &TC_VARS. _PartInd_ );
run;

/* 2) 랜덤포레스트(viya) */
proc forest data = WRKLIB.HRD_DATA_PARTED;
    input  &IN_VARS / level = interval;
    input  &IC_VARS / level = nominal;
    target &TC_VARS / level = nominal;
    partition rolevar = _PartInd_ (train = '0' valid = '1' test = '2');
    format &TC_VARS best8.;
    output out = WRKLIB.HRD_DATA_RFM
        copyvars = ( EMP_ID &TC_VARS. _PartInd_ );
run;

/* 3) 그레디언트부스팅(viya) */
proc gradboost data = WRKLIB.HRD_DATA_PARTED;
    input  &IN_VARS / level = interval;
    input  &IC_VARS / level = nominal;
    target &TC_VARS / level = nominal;
    partition rolevar = _PartInd_ (train = '0' valid = '1' test = '2');
    format &TC_VARS best8.;
    output out = WRKLIB.HRD_DATA_GBM
        copyvars = ( EMP_ID &TC_VARS. _PartInd_ );
run;

/* 4) 라이트GBM(viya) */
data train_data
     valid_data;
    set WRKLIB.HRD_DATA_PARTED;
    format &TC_VARS best8.;
    select (_PartInd_);
        when ('0') output train_data;
        when ('1') output valid_data;
        otherwise;
    end;
run;
proc lightgradboost data      = train_data
                    validData = valid_data
    ;
    input  &IN_VARS / level = interval;
    input  &IC_VARS / level = nominal;
    target &TC_VARS / level = nominal;
    saveState rstore = WRKLIB.HRD_DATA_LGB_MODEL;  /* 스코어링 테이블 */
run;
proc astore;
    score 
        rstore   = WRKLIB.HRD_DATA_LGB_MODEL
        data     = WRKLIB.HRD_DATA_PARTED
        out      = WRKLIB.HRD_DATA_LGB
        copyVars = (  EMP_ID &TC_VARS. _PartInd_ )
    ;
run;


/* 2.2. 회귀 모형 */
proc logselect data = WRKLIB.HRD_DATA_PARTED;
    class &IC_VARS &TC_VARS;
    model &TC_VARS = &IN_VARS &IC_VARS / noint;
    partition rolevar = _PartInd_ (train = '0' valid = '1' test = '2');
    selection method = stepwise;
    format &TC_VARS best8.;
    output 
        out      = _temp_pred_log_
        copyVars = (  EMP_ID &TC_VARS. _PartInd_ )
    ;
run;
data WRKLIB.HRD_DATA_LOG;
    set _temp_pred_log_;
    p_&TC_VARS.1 = _pred_;
    p_&TC_VARS.0 = 1- _pred_;
    drop _pred_;
run;


/* 2.3. SVM 모형 */
proc svmachine data   = WRKLIB.HRD_DATA_PARTED;

    input  &IN_VARS / level = interval;
    input  &IC_VARS / level = nominal;
    target &TC_VARS / level = nominal;
    partition rolevar = _PartInd_ (train = '0' valid = '1' test = '2');
    format &TC_VARS best8.;
    output 
        out = WRKLIB.HRD_DATA_SVM
        copyVars = (  EMP_ID &TC_VARS. _PartInd_  )
    ;
run;