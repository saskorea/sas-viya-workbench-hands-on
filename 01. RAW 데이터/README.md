# 실습 데이터

## **1. 통신 이탈 예측(Churn)**
- **(데이터 정보)** 이 데이터는 이란의 한 통신사 데이터베이스에서 12개월 동안 무작위로 수집되었다. 데이터는 총 3,150개의 행과 13개 열로 구성되어 있으며, 각 행은 고객을 의미한다. 이 데이터는 '통화 실패, SMS 빈도, 불만 건수, 고유 통화 수, 가입 기간, 연령대, 요금 금액, 서비스 유형, 사용 시간(초), 상태, 사용 빈도, 고객 가치' 변수를 가지고 있다. 이탈(churn) 속성을 제외한 모든 속성은 처음 9개월 동안 집계했다. 이탈(churn labels)은 12개월 말의 고객 상태를 나타낸다. 3개월은 이탈 여부를 판단하기 위한 기간(planning gap)이다.
- **데이터 정보 개요**
    | **구분** | **내용** |
    | --- | --- |
    | 데이터 이름 | Churn |
    | 영역 | 비즈니스 |
    | 관련 주제 | 분류 |
    | 관측 단위 | 고객 |
    | 관측치 수 | 3,150 |
    | 입력 | 13 |
    | 타겟 | Churn (Binary) |
- **출처:** Iranian Churn Dataset. UCI Machine Learning Repository. https://archive.ics.uci.edu/dataset/563/iranian+churn+dataset.
- **라이센스:** Creative Commons Attribution 4.0 International
- **변경 및 재가공 이력:** 이 데이터는 원본 데이터의 변수명을 변경하였음
- **메타 데이터**
    | **No** | **컬럼** | **한글명** | **설명** | **역할** | **유형** |
    | --- | --- | --- | --- | --- | --- |
    | 1 | CallFail | 통화 실패 | 통화 실패 횟수 | 입력 | num |
    | 2 | Complains | 불만 여부 | 고객 불만 상태 (0: 없음, 1: 있음) | 입력 | char |
    | 3 | SubLength | 가입 기간 | 총 가입 기간(개월) | 입력 | num |
    | 4 | ChargeAmt | 요금 수준 | 고객 요금 수준 (0: 최저 금액, 9: 최고 금액) | 입력 | char |
    | 5 | SecOfUse | 통화 시간 | 총 통화 시간(초) | 입력 | num |
    | 6 | FreqOfUse | 통화 횟수 | 총 통화 횟수 | 입력 | num |
    | 7 | FreqSMS | 문자 횟수 | 총 문자 메시지 발송 횟수 | 입력 | num |
    | 8 | DistCallNum | 고유 통화 수 | 고유 통화 상대방 수 | 입력 | num |
    | 9 | AgeGroup | 연령대 | 연령대 (1: 젊은 연령, 5: 고령) | 입력 | char |
    | 10 | TariffPlan | 요금제 | 고객의 요금제 유형 (1: 선불, 2: 계약) | 입력 | char |
    | 11 | Status | 상태 | 고객 현재 상태 (1: 활성, 2: 비활성) | 입력 | char |
    | 12 | Age | 연령 | 고객 연령 | 입력 | num |
    | 13 | CustValue | 고객 가치 | 고객 가치 계산 값 | 입력 | num |
    | 14 | Churn | 이탈 여부 | 이탈 여부 (1: 이탈, 0: 유지) | 타겟 | char |

---

## **2. 음용수 예측 (Water Quality and Potability)**

- **(데이터 정보)** 이 데이터는 다양한 수질 지표를 기반으로 물의 음용 가능성을 예측하기 위해 수집되었다. 데이터는 **총 3,276개의 행과 10개의 열로 구성**되어 있으며, 각 행은 특정 수질 샘플을 나타낸다. 각 열은 수질 특성을 나타내며, 'Potability' 열은 물이 음용 가능한지 여부를 나타낸다.
- **데이터 정보 개요**
    
    
    | **구분** | **내용** |
    | --- | --- |
    | 데이터 이름 | Water Quality and Potability |
    | 영역 | 환경 |
    | 관련 주제 | 분류 |
    | 관측 단위 | 수질 샘플 |
    | 관측치 수 | 3,276 |
    | 입력 | 9 |
    | 타겟 | Potability (Binary) |
- **원천:** [Water Quality and Potability Dataset](https://www.kaggle.com/datasets/uom190346a/water-quality-and-potability)
- **사용권:** 공개 데이터셋으로, Kaggle의 이용 약관에 따름
- **변경 및 재가공 이력:** 이 데이터는 원본 데이터의 변수명을 변경하였음.
- **메타 데이터**
    
    
    | **No** | **컬럼** | **한글명** | **설명** | **역할** | **유형** |
    | --- | --- | --- | --- | --- | --- |
    | 1 | pH | 수소이온농도 | 산성 또는 알칼리성 정도 (0-14 범위) | 입력 | num |
    | 2 | Hard | 경도 | 용해 칼슘 및 마그네슘 이온 농도 (mg/L) | 입력 | num |
    | 3 | TDS | 총용존고형물 | 용해 고형물 총량 (ppm) | 입력 | num |
    | 4 | Chlrmns | 클로라민 | 클로라민 농도 (ppm) | 입력 | num |
    | 5 | Sulf | 황산염 | 용해 황산염 농도 (mg/L) | 입력 | num |
    | 6 | Cond | 전도도 | 전기 전도도 (μS/cm) | 입력 | num |
    | 7 | OrgC | 유기탄소 | 유기 탄소 농도 (mg/L) | 입력 | num |
    | 8 | THMs | 트리할로메탄 | 트리할로메탄 농도 (μg/L) | 입력 | num |
    | 9 | Turb | 탁도 | 혼탁도 (NTU) | 입력 | num |
    | 10 | Potability | 음용 가능 여부 | 음용 가능 여부 (0: 불가능, 1: 가능) | 타겟 | char |
- **변수 특징**
    
    
    | **변수명** | **정의** | **음용 가능성에 대한 영향** | **권장 범위** |
    | --- | --- | --- | --- |
    | pH | 수소이온농도 | pH 값이 적절하지 않으면 맛과 냄새에 영향을 주고 중금속 오염을 유발 | pH 6.5~8.5 범위 |
    | Hard | 경도 | 비누 거품 형성 방해, 석회질 형성 촉진(배관 문제 유발) | 300 mg/L 이하 |
    | TDS | 총용존고형물 | TDS가 높으면 물의 맛에 영향을 주고, 특정 미네랄의 과다 섭취를 유발 가능 | 500 ppm 이하 |
    | Chlrmns | 클로라민 | 과도한 경우 물 맛과 냄새에 부정적 영향을 주며, 일부 사람에 한하여 건강 문제 유발 | 4.0 mg/L 이하 |
    | Sulf | 황산염 | 황산염 농도가 높은 경우 위장 문제 유발 가능하며, 금속 부식 유발 | 250 mg/L 이하 |
    | Cond | 전도도 | 전도도가 높으면 용존 이온 농도가 높아, 물의 맛과 금속 부식 유발 | 500 μS/cm 이하 |
    | OrgC | 유기탄소 | 과도하게 높으면 미생물 증식을 촉진 및 수질 악화, 소독 부산물(DBPs) 생성 촉진 | 가능한 낮은 수준 |
    | THMs | 트리할로메탄 | 발암성 등의 건강 위험 초래, 농도가 높을 경우 음용에 부적합 | 0.1 mg/L 이하 |
    | Turb | 탁도 | 탁도가 높으면 미생물 및 오염 물질 존재 가능성이 높아지고, 소독 효과 저하 | 1 NTU 이하 |

---

## 3. **퇴사자 예측 (HRData)**

- **(데이터 정보)** 이 데이터는 뉴잉글랜드 경영 대학(New England College of Business)의 인적자원관리(HRM) 과정에서 활용하기 위해 Dr. Carla Patalano와 Dr. Rich Huebner가 생성한 합성 데이터이다. 이 데이터의 각 행은 직원을 나타낸다. 또한 이 데이터에는 직원의 성과와 만족도, 근무 부서 등 다양한 HR 정보가 포함되어 있으며, 퇴사 여부를 예측하는 것을 주 목적으로 한다. 데이터는 총 311개 관측치와 00개의 입력 변수로 구성되어 있다.
- **데이터 정보 개요**
    
    
    | **구분** | **내용** |
    | --- | --- |
    | 데이터 이름 | HRData |
    | 영역 | 인사 관리 |
    | 관련 주제 | 분류 |
    | 관측 단위 | 직원 |
    | 관측치 수 | 311 |
    | 입력 | 18 |
    | 타겟 | 퇴사 여부 |
- **원천:** [Human Resources Data Set](https://www.kaggle.com/datasets/rhuebner/human-resources-data-set)
- **사용권:** **CC-BY-NC-ND** (Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License)
- **변경 및 재가공 이력:** 원 데이터에서 불필요한 변수를 제거했고, 연령과 근속 일수를 계산하여 추가함
- **메타 데이터**
    | **No** | **변수명** | **한글명** | **설명** | **역할** | **타입** |
    | --- | --- | --- | --- | --- | --- |
    | 1 | EMP_ID | 직원고유번호 | 직원의 고유 식별 번호 | 키값 | num |
    | 2 | SEX | 성별 | 남성=M / 여성=F | 입력 | char |
    | 3 | AGE | 나이 | 2018년 기준 나이 | 입력 | num |
    | 4 | MAR_ST_CD | 결혼상태코드 | 미혼, 기혼, 이혼, 별거, 사별 (코드: 1, …, 4) | 입력 | char |
    | 5 | RACE_CD | 인종코드 | 백인, 흑인, 원주민, 히스패닉, 아시아인, 혼혈(코드: 1,…,6) | 입력 | char |
    | 6 | STAT_CD | 지역코드 | 직원이 거주하는 주 (뉴욕, 플로리다 등) | 입력 | char |
    | 7 | POSIT_CD | 직위코드 | 직원의 직위 | 입력 | char |
    | 8 | DEPT_ID | 부서고유번호 | 부서 ID 코드 (직원이 소속된 부서와 매칭됨) | 입력 | char |
    | 9 | MNGR_ID | 관리자고유번호 | 각 관리자의 고유 식별 번호 | 입력 | char |
    | 10 | KPI_CD | 핵심성과코드 | 저성과, 개선필요, 성과충족, 고성과 (코드: 1, ..., 4) | 입력 | char |
    | 11 | SAL_AM | 연봉 | 연봉(환율: 1,200원으로 산출 / 단위: 만원) | 입력 | num |
    | 12 | CTZ_CD | 시민권상태코드 | 시민권자, 영주권자, 취업비자 (코드: 1, 2, 3) | 입력 | char |
    | 13 | TNR_DD | 최소 근속 일수 (월 단위) | 퇴사자(근속자) 퇴사일(2018년 12월 31일)과 고용일 간 일차 | 입력 | num |
    | 14 | RCRT_CD | 취업경로코드 | 직원이 채용된 경로(링크드인, 웹 등) | 입력 | char |
    | 15 | ENG_SCR | 참여도설문점수 | 외부 파트너가 관리한 최근 참여도 설문조사 결과(높을 수록 만족) | 입력 | num |
    | 16 | SAT_SCR | 직원만족도 | 직원 만족도 점수(1~5점) | 입력 | num |
    | 17 | PRJ_CN | 특별프로젝트수행횟수 | 최근 6개월 동안 직원이 참여한 특별 프로젝트 수 | 입력 | num |
    | 18 | LT_DD | 지각일수 | 최근 30일 동안 직원의 지각 횟수 | 입력 | num |
    | 19 | ABSN | 결근일수 | 직원 결근 횟수 | 입력 | num |
    | 20 | TRMD_YN | 퇴사여부 | 직원이 퇴사했는지 여부 (1: 예, 0: 아니오) | 타겟 | char |
