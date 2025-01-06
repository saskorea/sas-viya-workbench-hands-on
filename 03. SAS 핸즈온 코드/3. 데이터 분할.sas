/*****************************************************************************************
** 프로그램 이름: III. 데이터 분할
** 작성자: 한노아 (PSD/AA)
** 작성일: 2024. 12. 31. (화)
******************************************************************************************/

/*****************************************************************************************
** 1. 환경설정
******************************************************************************************/

/* 1.1. 라이브러리 할당 및 포맷 불러오기 */
libname WRKLIB "sas-viya-workbench-hands-on/02. SAS 데이터";

/* 1.2. 사용자 정의 포맷 */
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

/*****************************************************************************************
** 2. 데이터 분할
******************************************************************************************/

/* 2.1. Target 변수 분포 확인 */
title '[ Target 변수 분포 ]';
proc sgplot data  = WRKLIB.hrd_data;
    vbar TRMD_YN 
        / datalabel
          datalabelAttrs = (Family = "Arial" Size = 9 Weight = Bold)  /* 데이터 Label의 스타일 변경(폰트, 크기, 볼드 등) */
          state          = percent                                    /* Y축을 비율로 변경 */
    ;
    xaxis label = '퇴사여부(Target)';
    yaxis label = '비율';
    format TRMD_YN TGTFMT.;
run;
title;

/* 2.2. Proc Partition을 이용한 데이터 분할*/
/*  - SAS Partition Procedure는 **SAS Viya**에 속한 제품입니다.  */
/*  - 절차는 데이터를 분할하기 위한 용도로 활용됩니다.  */
/*  - 데이터 분할은 보통 'Training, Validation, Testing' 세 가지로 나누고, 경우에 따라 'Training, Validation' 두 가지로 나누기도 합니다. */
/*  - 이번 핸즈온에서는 데이터를 **'Train, Valid, Test' 세 가지**로 **4:3:3 비율**로 나누어 보겠습니다. */
title '[ 데이터 분할 ]';
proc partition data = WRKLIB.hrd_data     /* 입력 데이터 */
               samppctevt = 1             /* 관심 이벤트의 level */
               samppct    = 30            /* 두 번째 Sample의 크기(비율) 30% */
               samppct2   = 30            /* 세 번째 Sample의 크기(비율) 30% */
               seed       = 123123
               partind  
               
               ;
    by TRMD_YN;                             /* 타겟 변수 */
    output 
        out        = WRKLIB.hrd_data_parted /* 데이터 분할 결과 테이블 */
        copyvars   = (_all_)                /* 결과 테이블에 포함할 변수 지정 */
        partindname= _PartInd_              /* Partition 변수 이름 */
    ;
    format 
        TRMD_YN   TGTFMT.
    ;
    label 
        TRMD_YN = '퇴사여부'
    ;
run;
title;

/* 2.3. 데이터 분할 결과 확인 */
title '[ 데이터 분할 결과 확인 ]';
proc freq data = WRKLIB.hrd_data_parted;
    format _partInd_  ROLFMT. 
          TRMD_YN     TGTFMT. 
    ;
    label _partInd_ = '데이터 역할'
          TRMD_YN   = '타겟 변수'
    ;
    table TRMD_YN * _PartInd_ / nocol nopercent;
run;
title;

/*****************************************************************************************
** 3. Simple-UnderSampling (SUS)
  - Simple-UnderSampling은 타겟 변수의 소수 class를 추출하여, class 간 균형을 맞춰주는 표본추출 방법
******************************************************************************************/

title '[ Simple-UnderSampling ]';
proc partition data = WRKLIB.hrd_data     /* 입력 데이터 */
               event      = '1'           /* 관심 이벤트의 level */
               eventProp  = 0.5           /* 조정 목표 비율 */
               sampPctEvt = 100           /* 전체 데이터를 모두(100%) 사용 */
               seed       = 123123        /* Random Seed */
               ;
    by TRMD_YN;                           /* 타겟 변수 */
    output 
        out      = WRKLIB.hrd_data_SUS    /* 데이터 분할 결과 테이블 */
        copyvars = (_all_)                /* 결과 테이블에 포함할 변수 지정 */
    ;
run;
title;
proc freq data = WRKLIB.hrd_data_SUS;
    format TRMD_YN TGTFMT.;
    label TRMD_YN   = '타겟 변수'
    ;
    table TRMD_YN / nocum;
run;

/*****************************************************************************************
** 4. Simple-OverSampling (SOS)
  - Simple-OverSampling은 소수 Class 데이터를 복제하여, 데이터 불균형을 해소하는 방법
******************************************************************************************/

%let source_table  = WRKLIB.hrd_data;
%let target_table  = WRKLIB.hrd_data_SOS;
%let randomSeed    = 123123123;
%let targetResponse= 0.5;
%let target_nm     = TRMD_YN;

%macro OverSampling(source_table=, target_table=, target_nm=, targetResponse=0.5, randomSeed=123123);
/*********************************************************************************
%let source_table  = WRKLIB.hrd_data;
%let target_table  = WRKLIB.hrd_data_SOS;
%let randomSeed    = 123123123;
%let targetResponse= 0.5;
%let target_nm     = TRMD_YN;
*********************************************************************************/
/* 4.1. majority class, total sample size 산출 */

/* 4.1.1. 각 class별 빈도 산출 */
proc freq data = &source_table. noprint;
    tables &target_nm. / out = _sos_temp_01_;
run;

/* 4.1.2. 빈도 내림차순으로 Target 변수의 각 class 이름 정렬*/
proc sort data = _sos_temp_01_;
    by descending count;
run;

/* 4.1.3. 빈도 및 class 이름 산출 결과 매크로 변수에 저장 */
proc sql noprint;
    select &target_nm.
         , max(count) as majorityClassSize
         , sum(count) as totalSampleNumber
      into:class1-
         ,:majorityClassSize
         ,:totalSampleNumber
      from _sos_temp_01_
    ;
quit;

/* 4.2. 데이터 증강 */

/* 4.2.1. 요구 Sample Size 계산 */
%let requiredDataSize = %sysevalf( ( &majorityClassSize/(1-&targetResponse.) ) - &totalSampleNumber. );
%put NOTE: &=requiredDataSize.;

/* 4.2.2. 소수 Class에 속한 데이터만 추출 */
data _sos_temp_02_;
    set &source_table.;
    if &target_nm. = "&class2.";
run;

/* 4.2.3. 데이터 증강 */
proc surveyselect data     = _sos_temp_02_       /* 소수 Class 데이터 */
                  out      = _sos_temp_03_       /* 증강 결과 데이터 */
                  method   = urs                 /* 표본 추출 방법: Unrestricted Random Sampling */
                  sampsize = &requiredDataSize.  /* 추출할 표본 크기 */
                  seed     = &randomSeed.        /* 랜덤시드 */
                  outhits                        /* 출력 방식: 같은 데이터도 복사하여 행을 추가 */
                  noprint
                  ;
run;

/* 4.3. 결과 생성 */

/* 4.3.1. 원본 데이터와 증강 데이터 결합 */
data &target_table.;
    set &source_table.
        _sos_temp_03_
    ;
run;

/* 4.3.2. 결과 출력 */
title "Oversampling 결과: 목표 반응률   : &targetResponse. / 증강 데이터 수: &requiredDataSize.";
proc freq data = &target_table.;
    tables &target_nm.;
    label &target_nm. = 'Target';
run;
title;

/* 4.3.3. 임시 데이터 삭제 */
proc datasets lib = work nolist;
    delete _sos_temp_0:;
run;quit;

%mend OverSampling;

%OverSampling(
              source_table  = &source_table.
            , target_table  = &target_table.
            , target_nm     = &target_nm.
            , randomSeed    = &randomSeed.
            , targetResponse= &targetResponse.
            );