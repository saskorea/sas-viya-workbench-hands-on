/************************************************************************************
** 프로그램 이름: 예제 데이터 로드
** 작성일: 2024년 12월 27일
** 작성자: Han, Noah (SAS Korea, PSD/AA)
*************************************************************************************/

/* 1. Data Preparation */
libname  svwlib '/workspaces/handson/svwWork';                                                           /* library 할당 */
%let file_path = https://github.com/Hannoah/SVW-Hands-on-Session-Kor/raw/refs/heads/main/Data/churn.csv; /* 파일 경로   */
filename fp "/workspaces/handson/data/churn.csv";                                                        /* SAS Viya Workbench에 파일을 저장할 경로 */

proc http
    url ="&file_path"
    method ="GET"
    out = fp;
run;

data svwlib.churn;
infile fp dsd firstObs = 2;
attrib 
    Call_Failure             length =  8 format = comma8.       
    Complains                length =  8 format = comma8. 
    Subscription_Length      length =  8 format = comma8. 
    Charge_Amount            length =  8 format = comma8. 
    Seconds_of_Use           length =  8 format = comma8. 
    Frequency_of_Use         length =  8 format = comma8. 
    Frequency_of_SMS         length =  8 format = comma8. 
    Distinct_Called_Numbers  length =  8 format = comma8. 
    Age_Group                length = $1       
    Tariff_Plan              length = $1       
    Status                   length = $1       
    Age                      length =  8 format = comma8.
    Customer_Value           length =  8 format = comma8.2
    Churn                    length = $1 
    ;
input
    Call_Failure
    Complains
    Subscription_Length
    Charge_Amount
    Seconds_of_Use
    Frequency_of_Use
    Frequency_of_SMS
    Distinct_Called_Numbers
    Age_Group               $
    Tariff_Plan             $
    Status                  $
    Age
    Customer_Value
    Churn                   $
   ;
run;

/* 2. Data Exploration */
/* 2.1. first 10 observation of source table */
proc print data = svwlib.churn(obs = 10) noobs;
run;

/* 2.2. Simple Descriptive Statistics */
proc means data = svwlib.churn maxdec = 2;
    var _numeric_;
run;

