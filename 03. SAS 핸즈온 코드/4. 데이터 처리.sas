/*****************************************************************************************
* Data preprocessing
******************************************************************************************/

/*****************************************************************************************
* 1. 사전 작업
******************************************************************************************/
/* 1.1. 라이브러리 할당 */
libname WRKLIB "sas-viya-workbench-hands-on/02. SAS 데이터";

/* 1.2. 포맷 정의 */
proc format cntlin = WRKLIB.hrd_code; run;

/*****************************************************************************************
* 2. 변수 변환(결측 및 이상치 처리)
******************************************************************************************/
/* 2.1. 연속형 변수 범주화 - TREE BINNING */
proc binning data   = WRKLIB.hrd_data_parted (where = (_partind_ = 0))
             method = tree (
                           minnbins = 2   /* 최소 범주 수 */
                           maxnbins = 20  /* 최대 범주 수 */
                           )
             ;
    input 
        AGE
        SAL_AM
        TNR_DD
        ENG_SCR
        SAT_SCR
        PRJ_CN
        LT_DD
        ABSN
        
        / level = interval
    ;
    target
        TRMD_YN / level = nominal
    ;
*    output 
        out      = WRKLIB.hrd_data_bin_trn
        copyvars = (_all_)
    ;
    code file  = "sas-viya-workbench-hands-on/05. 스코어링 코드/hrd_data_bin.sas"; /* 스코어링 코드 저장 */
run;

/* 2.2. 범주형 변수 그룹화 */
/* 2.2.1. 변수별 범주별 분포 확인 */
proc freq data=WRKLIB.hrd_data_parted nlevels;
    tables _character_;
run;
/* 2.2.2. 범주가 10개 이상일 때(TREE BINNING) : 
          STAT_CD(지역코드)
          POSIT_CD(직위코드)
          MNGR_ID(관리자고유번호) 
*/
proc cattransform data = WRKLIB.hrd_data_parted (where = (_partind_ = 0))
        binmissing       /* 결측치를 그룹화 과정에 포함 */
        evaluationstats  /* 변수 별 그룹화 결과 평가값 확인 */
        prefix = 'BIN'   /* 그룹화 결과 변수명 지정 */
    ;
    input 
        STAT_CD 
        POSIT_CD 
        MNGR_ID
    ;
    method 
        tree(criteria = gini) /* 나무 성장 기준으로 gini 통계 사용 */
    ;
    target
        TRMD_YN / level = nominal
    ;
    savestate rstore = WRKLIB.hrd_data_bin_cat_tree_str; /* 스코어링 파일 저장 */
run;
/* 2.2.3. 특정 카테고리의 빈도가 너무 낮을 때(GROUPRARE) : 
          MAR_ST_CD (결혼상태코드)
          RACE_CD (인종코드)
          DEPT_ID (부서고유번호)
          CTZ_CD (시민권상태코드)
          RCRT_CD (취업경로코드)
          그룹화 X : SEX(성별) KPI_CD(핵심성과코드)
*/
proc cattransform data = WRKLIB.hrd_data_parted (where = (_partind_ = 0))
        binmissing 
        evaluationstats
        prefix = 'BIN'
    ;
    input 
        MAR_ST_CD 
        RACE_CD 
        DEPT_ID
        CTZ_CD
        RCRT_CD 
    ;
    method 
        grouprare /* 모든 범주의 비율이 최소 5% 될때까지 범주를 병합 */
    ;
*    output 
        out      = WRKLIB.hrd_data_bin_cat_grp
        copyvars = (EMP_ID)
    ;
    savestate rstore = WRKLIB.hrd_data_bin_cat_grp_str;
run;


/* 2.3. 전체 데이터셋에 대해 그룹화 수행 */
/* 2.3.1. 연속형 변수 */
data WRKLIB.hrd_data_bin_trn;
    set WRKLIB.hrd_data;
    %include 'sas-viya-workbench-hands-on/05. 스코어링 코드/hrd_data_bin.sas' ;
run;
/* 2.3.2. 범주형 변수 - tree binned */
ods exclude all; /* 결과창 숨김 */
proc astore;
    score data    = WRKLIB.hrd_data
          rstore  = WRKLIB.hrd_data_bin_cat_tree_str
          out     = WRKLIB.hrd_data_bin_cat_tree
          copyvar = EMP_ID
    ;
quit;
ods exclude none; /* 결과창 재활성화 */
/* 2.3.3. 범주형 변수 - grouprare binned */
ods exclude all; /* 결과창 숨김 */
proc astore;
    score data    = WRKLIB.hrd_data
          rstore  = WRKLIB.hrd_data_bin_cat_grp_str
          out     = WRKLIB.hrd_data_bin_cat_grp
          copyvar = EMP_ID
    ;
quit;
ods exclude none; /* 결과창 재활성화 */


/* 3. 데이터 결합 및 후처리 */
/* 3.1. 데이터 결합 */
proc sort data = WRKLIB.hrd_data_bin_trn; by EMP_ID; run;
proc sort data = WRKLIB.hrd_data_bin_cat_tree; by EMP_ID; run;
proc sort data = WRKLIB.hrd_data_bin_cat_grp; by EMP_ID; run;
data WRKLIB.hrd_data_bin_tmp;
    merge 
        WRKLIB.hrd_data_bin_trn
        WRKLIB.hrd_data_bin_cat_tree
        WRKLIB.hrd_data_bin_cat_grp
    ;
run;

/* 3.2. 그룹화된 변수명 원래대로 변경 */
/* 3.2.1. 데이터셋의 변수 목록 추출 */
proc contents
        data = WRKLIB.hrd_data_bin_tmp 
        out  = WRKLIB.hrd_data_var_list (keep=name) 
        noprint
    ;
run;
/* 3.2.2. 변경할 변수 목록 매크로화 */
data _null_;
    set WRKLIB.hrd_data_var_list (where = (name like 'BIN%' ));
    length keep_var $ 300;
    /* 원변수명 추출 */
    call symputx('new_var_'||strip(_N_), tranwrd(upcase(name),'BIN_','')); 
    /* 결과 데이터에 보존할 전체 변수명 및 변경할 변수갯수 추출 */
    retain keep_var 'EMP_ID SEX KPI_CD TRMD_YN  ';
    keep_var = catx(' ', keep_var, name);
    if _n_ then do;
        call symput('keep_var', keep_var);
        call symput('nobs', _n_);
    end;
run;
%put _user_; /* 새로운 변수명 확인 */
/* 3.2.3. 동적으로 생성된 변수명에 대해 RENAME 구문을 적용 */
%macro renaming_data;
    data WRKLIB.hrd_data_bin;
        set WRKLIB.hrd_data_bin_tmp (keep = &keep_var.); /* 그룹화된 변수 포함한 최종변수 추출 */
        rename 
            %do i = 1 %to &nobs.;
                &&new_var_&i. = old_&i.
            %end;
        ;                                            /* 그룹화된 변수명 원 변수명으로 수정 */
    run;
%mend;
%renaming_data; /* 매크로 수행 */