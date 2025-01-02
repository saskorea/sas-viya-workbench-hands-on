/************************************************************************************************
** 1. 제목: 데이터 처리
** 2. 작업 내용
**    1) 수치형 변수 구간화
**    2) 데이터 분할
** 3. 작성일: 2024년 12월 30일
** 4. 작성자: 한 노아 (SAS Korea PSD/AA) 
** 5. 입력 데이터: WRKLIB.hrd_code (코드 데이터)
**                WRKLIB.hrd_data 
** 6. 기타: n/a
*************************************************************************************************/
libname WRKLIB "SVW-Hands-on-Session-Kor/02. SAS 데이터";
proc format cntlin = WRKLIB.hrd_code; run;

/* 1. 데이터 분할 */
proc partition data = WRKLIB.hrd_data

               samppctevt = 1
               samppct    = 30
               samppct2   = 30
               partind 
               
               ;
    by TRMD_YN;
    output 
        out      = WRKLIB.hrd_data_parted
        copyvars = (_all_)
    ;
run;
proc format;
    value ROLFMT
        0 = '학습'
        1 = '평가'
        2 = '검증'
    ;
    value TGTFMT
        0 = '근속'
        1 = '퇴사'
    ;
run;
proc tabulate data = WRKLIB.hrd_data_parted;
    attrib 
        _partInd_ format = ROLFMT. label = '데이터 역할'
        TRMD_YN   format = TGTFMT. label = '타겟 변수'
    ;
    class _partInd_ TRMD_YN;
    table _partInd_*TRMD_YN
          all='전체'
        , (N='빈도' PCTN='백분율(%)' ROWPCTN='Row백분율(%)')
    ;
run;
