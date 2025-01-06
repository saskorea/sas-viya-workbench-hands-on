/*****************************************************************************************
** 프로그램 이름: II. 데이터 탐색
** 작성자: 한노아 (PSD/AA)
** 작성일: 2024. 12. 31. (화)
******************************************************************************************/

/*****************************************************************************************
** 1. 환경설정
******************************************************************************************/
libname WRKLIB "sas-viya-workbench-hands-on/02. SAS 데이터";
proc format cntlin = WRKLIB.hrd_code; run;

/*****************************************************************************************
** 2. 데이터 구조 살펴보기
******************************************************************************************/

/* 2.1. 데이터 저장 순서대로 상위 10개 데이터 출력 */
proc print data = WRKLIB.HRD_DATA /* 입력 데이터 */
                  (obs = 10)      /* 저장 순서에 맞게 10건만 노출 */
           label                  /* 변수 이름 보이도록 */
           noobs                  /* 연번 제외 */
           ;
run;

/* 2.2. 메타 데이터 출력 */
proc contents data  = WRKLIB.HRD_DATA /* 입력 데이터 */
              order = varnum          /* 변수가 데이터에 배열되어 있는 순서로 출력 */
              ;
run;

/*****************************************************************************************
** 3. 데이터 분포 분석
******************************************************************************************/

/* 3.1. 수치형 변수의 기술 통계 */
proc print data = WRKLIB.HRD_META(where = (role = 'input' and type = 'num')) noobs; run;

proc means data   = WRKLIB.HRD_DATA 
           maxdec = 2               /* 출력할 소숫점 자리수 */
           N NMISS VAR STD KURT SKEW MIN Q1 MEAN MEDIAN Q3 MAX
           ;
    var 
        AGE
        SAL_AM
        TNR_DD
        ENG_SCR
        SAT_SCR
        PRJ_CN
        LT_DD
        ABSN
    ;
run;

/* 3.2. 문자형 변수의 분포 분석 */
proc print data = WRKLIB.HRD_META(where = (role = 'input' and type = 'char')) noobs; run;

proc freq data    = WRKLIB.HRD_DATA 
          order   = FREQ        /* 빈도가 높은 순으로 */
          nlevels               /* 각 범주형 변수의 수준수 출력 */
          ;
    tables 
        SEX
        MAR_ST_CD
        RACE_CD
        DEPT_ID
        KPI_CD
        CTZ_CD
        RCRT_CD
        / missing /* 결측도 하나의 level로 취급 */
    ;
    * format _all_;             /* 원래 코드 값으로 확인하고 싶은 경우 */ 
run;

/* 3.3. 수치형 변수들 간 관계 분석 */
proc corr data  = WRKLIB.HRD_DATA /* 입력 데이터 */
          ;
    var
        AGE
        SAL_AM
        TNR_DD
        ENG_SCR
        SAT_SCR
        PRJ_CN
        LT_DD
        ABSN
    ;
run;

proc freq data = WRKLIB.HRD_DATA;
    table ( SEX MAR_ST_CD RACE_CD DEPT_ID KPI_CD CTZ_CD RCRT_CD ) * TRMD_YN
        / chisq 
          plots = freqplot ( type  = dotplot
                             scale = groupPercent )
          ;
run;

/*****************************************************************************************
** 4. 데이터 시각화
******************************************************************************************/

/* 4.1. 1차원 그래프 */

/* 4.1.1. 히스토그램 */
title '[ 나이 분포 ]';
proc sgplot data=WRKLIB.HRD_DATA;
  histogram age  / fillattrs    = (color = '#D9D9D9');
  density   age  / lineattrs    = (color = '#000000' pattern = ShortDash);
  xaxis label = '나이';
  yaxis label = '비율';
run;
title;

/* 4.1.2. 상자그림 */
proc sgplot data = WRKLIB.HRD_DATA;
  hbox age 
    / fillattrs    = (color = '#D9D9D9') /* 박스면 색 */
      lineattrs    = (color = '#BFBFBF') /* 박스선 색 */
      medianattrs  = (color = '#000000') /* 중위수 색 */
      meanattrs    = (color = '#000000') /* 평균값 색 */
      whiskerattrs = (color = '#BFBFBF') /* 울타리 색 */
      outlierattrs = (color = '#FF5050') /* 이상치 색 */
  ;
run;

/* 4.2. 다차원 그래프 */

/* 4.2.1. 산점도 행렬 */
proc sgscatter data = WRKLIB.HRD_DATA;
/* 나이, 연봉, 경력, 프로젝트 횟수 */
    matrix AGE 
           SAL_AM 
           TNR_DD 
           PRJ_CN 
        / group    = TRMD_YN                   /* 각 점을 Target 변수를 기준으로 색상 구분 */
          diagonal = (histogram kenel normal)  /* 대각선 행렬을 히스토그램으로 */
        ;
run;

proc sgscatter data = WRKLIB.HRD_DATA;
/* 지각 일수, 결근 일수, 참여도 설문 점수, 직원 만족도*/
    matrix LT_DD
           ABSN
           ENG_SCR
           SAT_SCR
        / group    = TRMD_YN                   /* 각 점을 Target 변수를 기준으로 색상 구분 */
          diagonal = (histogram kenel normal)  /* 대각선 행렬을 히스토그램으로 */
        ;
run;

/* 4.2.2. 모자이크 그래프 */
proc freq data = WRKLIB.HRD_DATA;
    tables SEX * MAR_ST_CD / plots = mosaicPlot;
    tables SEX * RACE_CD   / plots = mosaicPlot;
    tables SEX * DEPT_ID   / plots = mosaicPlot;
    tables SEX * KPI_CD    / plots = mosaicPlot;
    tables SEX * CTZ_CD    / plots = mosaicPlot;
    tables SEX * RCRT_CD   / plots = mosaicPlot;
run;