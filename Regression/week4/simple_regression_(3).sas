libname reg "C:\Users\Kim Yuum\Desktop\19-1 통계\회귀분석및실습\Regression\week4\data";

PROC IMPORT datafile = "C:\Users\Kim Yuum\Desktop\19-1 통계\회귀분석및실습\Regression\week4\data\train_car.csv" dbms = csv replace
out = reg.train_car;
getnames = yes; *첫 행이 열 이름이냐;
RUN;
PROC IMPORT datafile = "C:\Users\Kim Yuum\Desktop\19-1 통계\회귀분석및실습\Regression\week4\data\test_car.csv" dbms = csv replace
out = reg.test_car;
getnames = yes;
RUN;
PROC IMPORT datafile = "C:\Users\Kim Yuum\Desktop\19-1 통계\회귀분석및실습\Regression\week4\data\test_y.csv" dbms = csv replace
out = reg.test_y;
getnames = yes;
RUN;

/*Training 데이터에서 자동차 가격(Price)와 자동차 무게(Weight)의 산점도와 표본상관계수를 산출하고 모상관계수가 0인지 검정하여라.*/
PROC CORR data = reg.train_car FISHER(rho0=0);   *검정;
var price weight;
run;
/*자동차의 가격(Y)와 무게(X)로 이루어진 회귀모형 적합*/
PROC reg data = reg.train_car; /*t-value 제곱하면 F value*/
model price = weight/CLM CLI; *평균에 대한 신뢰구간; *예측 구간;
RUN;



