# Corona-19_analysis-prediction

## 함께 만든사람
- [황선우](https://github.com/SionHwang)
## 시작한 계기
고2 겨울방학부터 R 공부를 시작<br>
고3 5월 초부터 Deep Learning 공부를 시작<br>

*코로나19*  가 사회적으로 큰 파장을 불러일으켰고,

데이터전처리, 데이터마이닝 연습을 위해 간단하게 시각화를 해보았었다.(4월 중순)

이후 친구한명([SionHwang](https://github.com/SionHwang/COVID-19_forecast_prediction_model_in_ROK)) 과 이야기하던 중, 코로나 예측모델을 만들어보면 어떨까 해서, 5월중순에 다시 진행하게 되었다.


## 연구의 배경 및 목적

  **코로나19 (COVID-19)** 는 2019.12월 중국 우한시에서 최초 감염 보고 이후 급격히 확산되어 여러 국가들에서도 감염 사례가 잇따라 보고되고 있다.   
     
 대한민국은 2020.1월 최초 감염자가 발생한 이후 감염 추세가 크게 늘어나지 않던 와중 2020.2월 중순 부터 지역 사회 감염 및 무증상 전파와 슈퍼 전파 사례 이후 감염 경로가 불확실한 감염자가 증가하면서 확진자 추세가 기하급수적으로 증가하였다.  
    
 우리는 확진자 추세가 늘어나는 것에 규칙이 있을것이라 생각했고, 데이터를 사례에 따라 분류 하였다. 우리는 "이 데이터들을 가지고 사례에 따른 패턴을 유추할 수 있지 않을까?" 라는 궁금증을 갖게 됐다.

우리는 이 문제에 대해 생각하며 여러 상황에서 활용할 수 있는 범용성을 가진 예측 모델을 구축하려 하였으나, 여러 방법을 사용하여 모델을 만들어야하는 등 범용성이 있는 모델을 만들기에는 많은 어려움이 있었다. 게다가 코로나19 예측모델에 대한 연구 및 자료가 부족하여 직접 구축 하기로 하였다. 따라서 데이터 분석을 통하여 여러 예측 모델을 만든 후 그에 따른 근사적 증가 추세를 파악해보려 한다.

## R 데이터 분석
- 1차 시각화
![image](https://user-images.githubusercontent.com/43991816/92218404-07d37f00-eed4-11ea-9962-4170790072eb.png)
- 3차 시각화
![image](https://user-images.githubusercontent.com/43991816/92218597-508b3800-eed4-11ea-9374-c2d7abe637ca.png)


### 1일 평균 증가량
- 신천지 이전 
 - #1.383183
![image](https://user-images.githubusercontent.com/43991816/92218963-dd35f600-eed4-11ea-81e7-302b2da6049e.png)

- 신천지 사태기간 (2/18 ~ 3/8)
 - #462.3271
![image](https://user-images.githubusercontent.com/43991816/92218980-e1621380-eed4-11ea-8a51-d53fe8c726a5.png)

- 구로 콜센터 (3/9~3/25)
 - #98.77206
![image](https://user-images.githubusercontent.com/43991816/92219261-49b0f500-eed5-11ea-8914-38e432dec53b.png)

- 사이 기간 (3/26~5/9)
 - #25.53044
![image](https://user-images.githubusercontent.com/43991816/92219356-6b11e100-eed5-11ea-9543-d8e472af1ffd.png)

- 이태원 (5/10~5/15)
 - #26.14286
![image](https://user-images.githubusercontent.com/43991816/92219517-9eed0680-eed5-11ea-83a3-bb15bc7fb2e0.png)

- 사이 기간2 5/16~5/26
 - #21.4303
![image](https://user-images.githubusercontent.com/43991816/92219598-c2b04c80-eed5-11ea-9730-303db802d513.png)

- 쿠팡 집단감염 (5/27 ~)
 - #38.5
![image](https://user-images.githubusercontent.com/43991816/92219769-f7bc9f00-eed5-11ea-9464-bfe73ad70a3b.png)


### 데이터 트랜드

- 2019 검색 트랜드
![image](https://user-images.githubusercontent.com/43991816/92218803-9d6f0e80-eed4-11ea-9e7b-c83890a7c2ab.png)
- 2020 검색 트랜드
![image](https://user-images.githubusercontent.com/43991816/92218812-a069ff00-eed4-11ea-85f3-1e34f44e473f.png)
- 누적 확진자 성별
![image](https://user-images.githubusercontent.com/43991816/92220005-4e29dd80-eed6-11ea-8743-b671dafa735f.png)
- 연령& 성별
![image](https://user-images.githubusercontent.com/43991816/92220337-d3ad8d80-eed6-11ea-9184-2ea850984cc9.png)
- 성별에 따른 유동인구(수도권)
![image](https://user-images.githubusercontent.com/43991816/92220108-70236000-eed6-11ea-881b-c5783da88f1b.png)
- 성별에 따른 사망률
![image](https://user-images.githubusercontent.com/43991816/92220143-7c0f2200-eed6-11ea-8790-146ca17210c4.png)
- 시간에 따른 유동인구
![image](https://user-images.githubusercontent.com/43991816/92220230-a7920c80-eed6-11ea-8270-c7a5af129ef8.png)
- 연령에 따른 유동인구
![image](https://user-images.githubusercontent.com/43991816/92220277-bc6ea000-eed6-11ea-8a55-9ff75da1686b.png)


## 사용한 모델 별 장단점

우리는 **LSTM, SVM, Polynomial Regression, Bayesian ridge polynomial regression**을 사용하였다.   
아래에서 사용한 모델들의 장단점에 대해 간략히 소개하겠다.    

### LSTM(Long Short-Term Memory)
**LSTM**에 대해 간략히 설명하자면 RNN 모델에서 Vanishing Gradient Problem(기울기값이 사라지는 문제)를 해결하려 등장한 모델 중 하나이다.

#### 장점 :
~~~
1. 각각의 메모리와 결과값이 컨트롤이 가능하다
~~~
   
#### 단점 :
~~~
1. 연산속도가 느리다.
2. 연산 시 많은 메모리를 요구한다.
3. Overfitting 되기 쉽다.
~~~

### SVM(Support Vector Machine)
초평면 : N차원을 N-1차원으로 구현할 수 있게 만들어준다.    

#### 장점 : 
~~~
1. 일반화 오차가 낮다.
2. 과적합(Overfitting)을 방지해준다.
~~~

#### 단점 :   
~~~
1. 확률 추정치 제공해주지 않는다.
2. 5분할 교차검증 -> 자원소비가 크다.
3. 데이터가 많아질수록 연산량이 급증한다.
~~~

### Polynomial Regression (다중 회귀분석)
독립 변수가 다항식으로 구성되는 회귀 모델이다.   

#### 장점 :
~~~
1. 추가적인 독립변수를 도입함으로써 오차항의 값을 줄일 수 있다.
2. 단순회귀분석의 단점을 극복 할 수 있다.
~~~   
   
#### 단점 : 
~~~
1. 사전에 결측치 처리를 해야한다.
2. 변수 간 영향을 주는지 아닌지 유무를 파악해야한다.
3. 선형, 비선형 여부를 파악해야한다.
~~~
### Bayesian Ridge Polynomial Regression (베이지안 다중 회귀분석)
베이지안 추론의 맥락 내에서 통계 분석이 수행되는 선형 회귀에 대한 접근 방식이다.   
회귀 모형에 정규 분포가있는 오차가 있고 특정 형태의 사전 분포가 가정 된 경우 모형 모수의 사후 확률 분포에 대해 명시적인 결과를 사용할 수 있다.

#### 장점 : 
~~~
1. 현재 데이터에 맞게 조정된다.
2. 정규화 모수를 추정 절차에 포함하는 데 사용할 수 있다.
~~~
#### 단점 : 
~~~
1. 모델의 추론 시간이 많이 걸릴 수 있다.
~~~

## 사용된 언어

### *R*
> 데이터 전처리 <br>
> 시각화 <br>
> 분석 <br>

### *Python*
> 데이터 전처리 <br>
> LSTM <br>
> SVM <br>
> Polynomial Regression <br>
> Bayesian ridge polynomial regression <br>


# 일지
|Date|Using|Description|Official source(참고 주소)|
|:---:|---|---|---|
|04_16||Start Project||
|04_17|R|Finding Git_R_Corona data||
|04_18|R|Preprocessing data||
|04_19|R|시각화1||
|04_20|R|시각화2||
|05_05|R|Corona distribute||
|---|---|---|---|
|05_17||Restart Project||
|05_19|R, Python|Collecting data||
|ㄴ|R, Python|Preprocessing||
|---|---|---|---|
|06_01|R|Create Corona Dataframe|about 1/21~5/31|
|06_02|R|Fit data about section||
|---|---|---|---|
|06_06|R|시각화||
|ㄴ|Python|Learning LSTM||
|06_07|R|Make data -> Occurrence_trend.csv||
|06_12|R|Visual data|https://www.kaggle.com/kimjihoo/coronavirusdataset/data?select=Weather.csv|
|06_13|R|Analysis||
|06_14|Python|Make ML Model||
|ㄴ||Using Data|https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv|
|ㄴ|Python|Create LSTM Model||
|ㄴ|Python|Create SVM Model||
|06_15|Python|Learning Polynomial Regression Model||
|06_16|Python|Make ML Model||
|ㄴ|Python|Create Polynomial Regression Model||
|06_17|Python|Update ML Models||
|06_18|Python|Update ML Models||
|06_19|Python|Learning Bayesian Ridge Model||
|ㄴ|Python|Create Bayesian Ridge Model||
|06_20 ~ ||Finding Best Parameter about each models||
|06_23 ~ ||Code cleanup||
|07_09||Update Readme||
|07_10||''||
|07_15||test||
|08_02||Preparing a new model||
|ㄴ||error correction||
|09_04|Python|Covid.csv update||
|09_12|Python|test.py||
|09_13|Python|Update test.py||
|09_19|Python|Make new model, Using TF|https://www.tensorflow.org/api_docs/python/tf/compat/v1/nn/rnn_cell|
|09_20|Python|Error|ValueError: Did you mean to set reuse=True or reuse=tf.AUTO_REUSE in VarScope?|
|ㄴ|||https://stackoverflow.com/questions/47296969/valueerror-variable-rnn-basic-rnn-cell-kernel-already-exists-disallowed-did-y|
===================================================================================

![LSTM0709](https://user-images.githubusercontent.com/63298243/87538268-e970b480-c6d6-11ea-8fbf-91c368284208.png)

![SVM0709](https://user-images.githubusercontent.com/63298243/87538290-f2fa1c80-c6d6-11ea-9db4-dcac4e7e319e.png)

![Polymonial Regression Predictions0709](https://user-images.githubusercontent.com/63298243/87538280-ee356880-c6d6-11ea-86ba-5f742a3786f7.png)

![Bayesian Ridge Polynomial Predictions0709](https://user-images.githubusercontent.com/63298243/87538111-a878a000-c6d6-11ea-8749-684b0a710778.png)
