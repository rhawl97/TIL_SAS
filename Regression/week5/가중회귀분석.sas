/**중요**/
proc reg data = tmp1.houseprice;
model price = tax -- year;
H1: test tax=year=0; 
H2: test year=ground=0;
H3: test tax = 2 *ground;
RUN; QUIT;


DATA tmp1.wine;
set tmp1.redwine tmp1.whitewine(in = x);  *white면 x에 1이 들어감;
length type $ 5; *문자길이 5 지정; *지정 안 할 경우 red 최소길이 3으로 지정됨;
if x = 0 then type = "red"; 
else type = "white";
RUN; QUIT;

/*root MSE: s(root sigma) Adj R-Sq: 변수가 많아지면 R-Square는 증가할 수 밖에 x -> 1- (SSE/(n-p))/(SST/(n-1))*/
PROC REG data = tmp1.wine;
model quality = fixed_acidity -- alcohol / vif;  *다중공선성 체크; *vif>10인지 check;
ods select ParameterEstimates; *회귀계수만 알 수 있음;
RUN; QUIT;
PROC REG data = tmp1.wine (where = (type = "red")); 
model quality = fixed_acidity -- alcohol / vif;
ods select ParameterEstimates;
RUN; QUIT;
PROC REG data = tmp1.wine (where = (type = "white"));
model quality = fixed_acidity -- alcohol / vif; *vif > 10인 density먼저 빼서 다시 해보기; *delete density; 
*collin: 분산비 eigenvalue가 아주 작은 값과 상관이 높은 변수  때문에 다중공선성 일으킴;
ods select ParameterEstimates;
RUN; QUIT;
PROC GLM data = tmp1.wine;
class type;
model quality = fixed_acidity -- alcohol type / tolerance solution;
RUN; QUIT;

PROC IMPORT datafile = "C:\Users\Kim Yuum\Desktop\19-1 통계\회귀분석및실습\Regression\week5\data\airline_passengers.csv"
dbms = csv replace out = passengers; *등분산성 만족 x: scatter plot을 통해 알 수 o!; *가우스 마코프 정리: 분산이 최소인 것이 가장 good;
getnames = yes;
RUN;

DATA passengers2;
set passengers;
ind = _n_;
RUN;

PROC REG data = passengers2;
model passengers = ind / spec r; *spec: 등분산성 test ;
output out = passenger_out p = pred r = resid; *residual 점점 퍼짐 -> 등분산성 만족 x; *prediction value/residual 넣겠다;
RUN; QUIT;

DATA abs_resid;
set passenger_out;
abs_resid = abs(resid); *가중치 지정; 
RUN; QUIT;

PROC REG data = abs_resid NOPRINT;
model abs_resid = ind;
output out = passenger_abs_resid p = pred;
RUN; QUIT;

DATA weight_dat;
set passenger_abs_resid;
w = 1 / (pred**2);
PROC REG data = weight_dat;
model passengers = ind / spec r; *등분산성 검정 결과; *수정된 잔차그래프 확인;
weight w;
output out = fpassenger p = wp student = wr r = wr0;
RUN; QUIT;
