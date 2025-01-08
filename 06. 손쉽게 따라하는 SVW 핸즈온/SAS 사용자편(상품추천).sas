/*****************************************************************************************
** 프로그램 이름: 상품 추천
** 작성자: 이재은 (PSD/AA)
** 작성일: 2025. 1. 8. (수)
******************************************************************************************/

/*****************************************************************************************
** 데이터: usersCommunity 데이터
** 설명  : 게시판(boradId) 내 특정 페이지(itemId)를 클릭한 이력
**         클릭 시 마다 user id 와 item id 가 총 40,000 건의 클릭 이력으로 기록됨
**         recengine 프로시져를 활용하여 user id 2572 에게 적당한 다섯 개의 게시글을 추천
******************************************************************************************/

/* 데이터 가져오기 */
proc import datafile = "sas-viya-workbench-hands-on/01. RAW 데이터/usersCommunity.csv"   /* 가져올 데이터 이름(경로) */
            dbms     = csv                                                     /* 가져올 데이터 파일 유형(엑셀은 XLSX) */
            out      = usersCommunity                                          /* 저장할 데이터 이름 */
            replace                                                            /* 같은 데이터가 이미 있으면, 신규 데이터로 대체 */
            ;
    getnames     = yes;   /* 데이터의 첫 줄이 변수명인 경우 */
    guessingrows = 300;   /* 각 컬럼의 크기 및 타입을 정하기 위해 확인할 데이터 수 */
run;
title "가져온 데이터 상위 10개 출력";
proc print data = usersCommunity(obs = 10) noobs;
run;
title;

/* recengine 프로시져 실행 */
proc recengine data     = usersCommunity 
               method   = dtos     /* Data Translation with Optimal Stepsize method, 
                                      이 외에 Bayesian, k-nearest 방법 또한 지원
                                    */
               outmodel = factors
               ;
    input userid itemid / level=nominal;
    input isSolvedTopic / level=interval;
    userid userid;
    itemid itemid;
    dtos 
        nFactors                = 12  /* 팩터 수 지정 */
        maxIter                 = 20  /* 반복 수 지정 */
        regL2                   = 0.1 /* L2 정규화 파라미터값 지정 */
        feedbackConfidenceSlope = 50 /*confidence=isSolvedTopic*/;
  savestate rstore = astoreModel;
run;

/* user id 2572 추출 */
data user2572;
   input   userid;
   datalines;
   2572
   ;
run;

/* user2572 에 대해 상위 5개의 추천 item 데이터 생성 */
proc astore;
   setoption nTopRecoms 5;
   score 
       data   = user2572 
       rstore = astoreModel 
       out    = rankedItemsDtos
       ;
   run;
quit;

/* 추천된 item 확인 */
title "user Id 2572 의 추천 item Top 5";
proc print data = rankedItemsDtos;
run;
title;


/*****************************************************************************************
** 데이터: movie rating 데이터
** 설명  : 데이터는 userId(사용자Id), movieId(영화고유번호), rating(점수), timestamp 로 구성
**         facmac 프로시져를 활용하여 사용자가 각 영화별 높은 점수를 매길 확률을 계산
******************************************************************************************/

/* 데이터 가져오기 */
proc import datafile = "sas-viya-workbench-hands-on/01. RAW 데이터/ratings.csv" 
            dbms     = csv
            out      = ratings
            replace
            ;
    getnames     = yes;
    guessingrows = 300;
run;
title "가져온 데이터 상위 10개 출력";
proc print data = ratings(obs = 10) noobs;
run;
title;

/* facmac 프로시져를 활용하여 학습 */
proc factmac data      = ratings 
             nfactors  = 10      /* 팩터 수 지정 */
             learnstep = 0.15    /* sgd 알고리즘의 learning step size 지정 */
             maxiter   = 20      /* 최대 학습 횟수 지정 */
             outmodel  = ratings_factors
             seed      = 1234
             ;

   input userid movieid / level = nominal;
   target rating        / level = interval;
   output out=ratings_prd copyvars=(userid movieid rating);
run;

/* user id 1의 상위 5개 추천 영화 추출 */
proc sort data = ratings_prd ; by userid descending p_rating; run;
title "user Id 1 의 추천 item Top 5";
proc print data=ratings_prd(where=(userid=1) obs=5);
run;
title;

