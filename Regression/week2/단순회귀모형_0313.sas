libname reg "C:/Users/Kim Yuum/Desktop/19-1 통계/회귀분석및실습/Regression/week2/";

proc import datafile = "C:/Users/Kim Yuum/Desktop/19-1 통계/회귀분석및실습/Regression/week2/aflength.csv"
dbms = csv replace out=reg.aflength;
getnames = yes;
LABEL foot = "발길이" forearm = "팔안쪽길이" gender = "성별";
run;

/*데이터 요약정보*/
proc contents data = reg.aflength;
run;

/*팔안쪽길이와 발길이의 산점도 확인하기*/
TITLE "팔안쪽길이와 발길이의 산점도";
PROC SGPLOT DATA = reg.aflength;
SCATTER X = forearm Y = foot; /* X, Y 변수의 산점도 작성 */
REG X = forearm Y = foot; /* 산점도에 추정회귀직선을 추가로 표시*/
RUN;

/*팔안쪽길이와 발길이에 대한 상관분석하기*/
PROC CORR data = reg.aflength FISHER(rho0 = 0); /* 상관관계분석 */  /*옵션 안 넣었을 때와의 차이 기억!!*/
VAR foot; /* FISHER 옵션: 상관관계에 대한 검정과 신뢰구간을 계산한다*/
WITH forearm;
RUN;

/*최소제곱법을 직접 계산해 회귀계수 구하기*/
proc means data = reg.aflength noprint; *보통SAS에서 안 함;
var foot forearm;
output out = mean_set mean = /autoname;
run;
/*x, y 평균 구해서 저장하기
데이터 가져와서 foot, forearm 두 변수에 대해 평균을 계산해서 mean_set에 저장
이때, 이름은 autoname으로 자동 지정되게 */

data aflength;
if _n_ = 1 then set mean_set (drop = _freq_ _type_);
set reg.aflength;
diff_foot = foot - foot_mean;
diff_forearm = forearm - forearm_mean;
squ_diff_forearm = diff_forearm**2;
pro_var = diff_foot*diff_forearm;
run;
/* mean_set과 example.aflength를 결합하여 한번에 계산하려고 사용한 코드
mean_set에서 _freq_와 _type_을 버리고 가져온 후 밑에 식들을 계산*/
proc means data = aflength noprint;
var pro_var squ_diff_forearm;
output out = sum_set sum = /autoname;
run;
/*mean계산과 마찬가지로 sum 계산하기 위함*/
data beta_set;
if _n_ = 1 then set sum_set;
set mean_set;
4
beta_1 = pro_var_sum / squ_diff_forearm_sum;
beta_0 = foot_mean - beta_1*forearm_mean;
drop _type_ _freq_ pro_var_sum squ_diff_forearm_sum forearm_mean foot_mean;
run;
/*sum_set과 mean_set을 결합하여 beta1과 beta0만 저장할수 있게 만든다*/


/*PROC REG 를 이용한 회귀분석 하기*/
PROC REG data = reg.aflength; /*잔차의 산점도 패널 출력*/
MODEL foot = forearm / R; /* 잔차분석을 위한 통계값을 출력하는 옵션 사용*/
RUN;  /*최소제곱법을 통한 회귀분석 결과*/
*intercept가 베타제로(절편) 추정;


/*추정된 회귀모형을 통한 반응변수 Y 의 평균 추정 값에 대한 신뢰구간 및 새로운 값에 대한 예측구간 구하기*/
PROC REG data = reg.aflength;
MODEL foot = forearm / CLM CLI;
RUN;

