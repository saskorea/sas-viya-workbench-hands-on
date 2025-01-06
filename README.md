# **SAS Viya Workbench: Hands-on Session (KOR)**

## **1. GitHub Repository 복제**
 - SAS Viya Workbench에 Workbench를 생성
 - 하단의 터미널(terminal) 탭을 클릭
 - 터미널에 아래 복제 프롬프트 입력
```
git -C "$WORKSPACE" clone https://github.com/saskorea/sas-viya-workbench-hands-on.git
```

## **2. 사용 가이드**

- [일반 사용자를 위한 Trial 환경](https://engage-wmt001.workbench.sas.com)
  - 이 환경은 Hands-on Session에 한하여 사용 가합니다.
  - 만약, 이후 추가 사용을 원하신다면, SAS Korea로 따로 문의 주시기 바랍니다.
- [아카데미 사용자를 위한 Free 환경](https://www.sas.com/en_us/software/viya-workbench-for-learners.html)
  - SAS Viya Workbench for learners는 **아카데미 사용자에게 무료**로 제공됩니다.
  - 다만, 계정당 **사용 가능한 리소스 범위가 제한** 되어 있습니다(디스크: **최대 10GB**).
  - 아카데미 버전 역시 클라우드 환경에서 제공되며, **가입 후 즉시** 이용 가능합니다.
  - 다만, 아카데미 사용자는 '.ac.kr'과 같이 **아카데미 이메일 주소에 한하여** 가입이 가능합니다.


## **3. 핸즈온 진행 개요**
- 데이터 로드
  - CSV, Excel 등의 파일을 SAS 데이터로 로드
  - 사용자 정의 format 및 메타 데이터 생성
- 데이터 탐색
  - 데이터 구조, 분포 등을 살펴봄
  - 데이터 시각화(히스토그램, 상자그림, 산점도 행렬 등)
- 데이터 및 표본 추출
  - 훈련, 평가, 검증 데이터 분할
  - Over Sampling, Under Sampling
  - 데이터 증강(CPCTGAN 모형 이용)
- 데이터 처리
  - 비닝을 활용한 결측치, 이상치 처리
- 모형 학습
  - 트리 기반 모형, 로지스틱 회귀, SVM 등 모형 학습
- 모형 평가
  - ROC, Lift 등 그래프를 통한 모형 평가
  - 모형 편향 평가


## **4. 관련 코드 자료들**

- [실습 데이터](https://github.com/saskorea/sas-viya-workbench-hands-on/tree/main/01.%20RAW%20%EB%8D%B0%EC%9D%B4%ED%84%B0)
- [SAS 핸즈온 코드](https://github.com/saskorea/sas-viya-workbench-hands-on/tree/main/03.%20SAS%20%ED%95%B8%EC%A6%88%EC%98%A8%20%EC%BD%94%EB%93%9C)
- [Python 핸즈온 코드](https://github.com/saskorea/sas-viya-workbench-hands-on/tree/main/04.%20Python%20%ED%95%B8%EC%A6%88%EC%98%A8%20%EC%BD%94%EB%93%9C)
- [기타 참고 코드](https://github.com/saskorea/sas-viya-workbench-hands-on/tree/main/00.%20%EC%B0%B8%EA%B3%A0%20%EC%BD%94%EB%93%9C)


## **참고. 관련 문서 및 학습 자료**

- [사용자 매뉴얼 문서(eng)](https://documentation.sas.com/doc/en/workbenchcdc/v_001/workbenchwlcm/home.htm)
- [본사 데모 영상(eng)](https://www.youtube.com/playlist?list=PLVV6eZFA22QzkSYKD4vbZFkq3VYDWvcb_)
- [웨비나 영상(kor)](https://www.sas.com/ko_kr/events/2024/idg-workbench-webinar.html)
