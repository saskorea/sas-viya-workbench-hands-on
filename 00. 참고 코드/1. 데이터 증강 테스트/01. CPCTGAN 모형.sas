/* 1. 환경 설정 */
/** 1) 라이브러리 할당 **/
libname WRKLIB "/workspaces/svw_handson/SVW-Hands-on-Session-Kor/02. SAS 데이터";

/** 2) 사용자 정의 포맷 할당 **/
proc format cntlin = WRKLIB.hrd_code; run;

/* 2. 데이터 증강 */
proc tabulargan data       = WRKLIB.HRD_DATA 
                seed       = 123 
                numSamples = 100
                ;

      input ENG_SCR
            SAT_SCR
            AGE
            SAL_AM
            TNR_DD
            PRJ_CN
            LT_DD
            ABSN
          / level = interval;
      input SEX
            MAR_ST_CD
            RACE_CD
            STAT_CD
            POSIT_CD
            DEPT_ID
            MNGR_ID
            KPI_CD
            CTZ_CD
            RCRT_CD 
            TRMD_YN
          / level = nominal;
      gmm                 alpha       = 1 
                          maxClusters = 10 
                          seed        = 42 
                          VB(maxVbIter=30)
      ;

      aeoptimization      ADAM 
                          LearningRate = 0.0001
                          numEpochs    = 3
      ;

      ganoptimization     ADAM(beta1=0.55 beta2=0.95)  
                          numEpochs     = 5
      ;
      train               embeddingDim  = 64 
                          miniBatchSize = 300 
                          useOrigLevelFreq
      ;
      savestate           rstore = WRKLIB.CPCTGAN_MODEL; 
      output              out    = WRKLIB.HRD_AUG_DATA;
run;


