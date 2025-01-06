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
proc binning data   = WRKLIB.hrd_data_parted(where = (_partind_ = 0))
             method = tree (
                           minnbins = 2 
                           maxnbins = 20
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
    output 
        out      = WRKLIB.hrd_data_bin_trn
        copyvars = (_all_)
        ;
    code file  = "sas-viya-workbench-hands-on/05. 스코어링 코드/hrd_data_bin.sas";
run;

/* 2.2. 범주형 변수 그룹화 */
/* 2.2.1. 변수별 범주별 분포 확인 */
proc freq data=WRKLIB.hrd_data_parted(where = (_partind_ = 0)) nlevels;
    tables _character_;
run;
/* 2.2.2. 범주가 10개 이상일 때(TREE BINNING) : 
          STAT_CD(지역코드)
          POSIT_CD(직위코드)
          MNGR_ID(관리자고유번호) 
*/
proc cattransform data = WRKLIB.hrd_data_parted(where = (_partind_ = 0))
        binmissing 
        /* prefix="CAT_"  */
        evaluationstats
    ;
    input 
        STAT_CD 
        POSIT_CD 
        MNGR_ID
    ;
    method 
        tree(criteria = gini)
    ;
    target
        TRMD_YN / level = nominal
    ;
    output 
        out      = WRKLIB.hrd_data_bin_cat_tree
        copyvars = (EMP_ID)
    ;
    savestate rstore = WRKLIB.hrd_data_bin_cat_tree_str;
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
        /* prefix="CAT_"  */
        evaluationstats
    ;
    input 
        MAR_ST_CD 
        RACE_CD 
        DEPT_ID
        CTZ_CD
        RCRT_CD 
    ;
    method 
        grouprare
    ;
    output 
        out      = WRKLIB.hrd_data_bin_cat_grp
        copyvars = (EMP_ID)
    ;
    savestate rstore = WRKLIB.hrd_data_bin_cat_grp_str;
run;

/* 2.3. 데이터 병합 */
proc sort data = WRKLIB.hrd_data_bin_trn; by EMP_ID; run;
proc sort data = WRKLIB.hrd_data_bin_cat_tree; by EMP_ID; run;
proc sort data = WRKLIB.hrd_data_bin_cat_grp; by EMP_ID; run;
data WRKLIB.hrd_data_bin;
    merge 
        WRKLIB.hrd_data_bin_trn
        WRKLIB.hrd_data_bin_cat_tree
        WRKLIB.hrd_data_bin_cat_grp
    ;
run;
