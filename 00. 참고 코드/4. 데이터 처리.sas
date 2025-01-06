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
/* 2.1. 학습용 데이터 추출 */
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
    code file  = "05. 스코어링 코드/hrd_data_bin.sas";
run;