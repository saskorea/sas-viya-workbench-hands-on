/***************************************************************************************************************
* Github 에서 SVW 환경으로 파일 가져오기
****************************************************************************************************************/

libname svwWrk '/workspaces/handson/svwWork';                                                    /* library 할당 */
%let source_path = https://github.com/Hannoah/SVW-Hands-on-Session-Kor/raw/refs/heads/main/Data; /* Github Path */
%let target_path = /workspaces/handson/data;                                                     /* Workbench Path*/

/* Macro Program 정의 */
%macro github_to_sas(dsn=, source_path=, target_path=, libnm=);
    %let file_path   = &source_path./&dsn..csv; /* 파일 경로   */
    filename fp "&target_path./&dsn..csv";      /* SAS Viya Workbench에 파일을 저장할 경로 */
    proc http
        url ="&file_path"
        method ="GET"
        out = fp;
    run;
    options nosource;
    proc import
        datafile= fp
        out     = &libnm..&dsn. 
        dbms    = csv 
        replace
        ;
    run;
    options source;
%mend github_to_sas;

/* Macro 실행 */
%github_to_sas(dsn=churn         , source_path=&source_path., target_path=&target_path., libnm=svwWrk);
%github_to_sas(dsn=Faults        , source_path=&source_path., target_path=&target_path., libnm=svwWrk);
%github_to_sas(dsn=datacreditos  , source_path=&source_path., target_path=&target_path., libnm=svwWrk);
%github_to_sas(dsn=heart_disease , source_path=&source_path., target_path=&target_path., libnm=svwWrk);
%github_to_sas(dsn=StudentDropout, source_path=&source_path., target_path=&target_path., libnm=svwWrk);
