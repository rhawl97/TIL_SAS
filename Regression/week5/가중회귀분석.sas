/**�߿�**/
proc reg data = tmp1.houseprice;
model price = tax -- year;
H1: test tax=year=0; 
H2: test year=ground=0;
H3: test tax = 2 *ground;
RUN; QUIT;


DATA tmp1.wine;
set tmp1.redwine tmp1.whitewine(in = x);  *white�� x�� 1�� ��;
length type $ 5; *���ڱ��� 5 ����; *���� �� �� ��� red �ּұ��� 3���� ������;
if x = 0 then type = "red"; 
else type = "white";
RUN; QUIT;

/*root MSE: s(root sigma) Adj R-Sq: ������ �������� R-Square�� ������ �� �ۿ� x -> 1- (SSE/(n-p))/(SST/(n-1))*/
PROC REG data = tmp1.wine;
model quality = fixed_acidity -- alcohol / vif;  *���߰����� üũ; *vif>10���� check;
ods select ParameterEstimates; *ȸ�Ͱ���� �� �� ����;
RUN; QUIT;
PROC REG data = tmp1.wine (where = (type = "red")); 
model quality = fixed_acidity -- alcohol / vif;
ods select ParameterEstimates;
RUN; QUIT;
PROC REG data = tmp1.wine (where = (type = "white"));
model quality = fixed_acidity -- alcohol / vif; *vif > 10�� density���� ���� �ٽ� �غ���; *delete density; 
*collin: �л�� eigenvalue�� ���� ���� ���� ����� ���� ����  ������ ���߰����� ����Ŵ;
ods select ParameterEstimates;
RUN; QUIT;
PROC GLM data = tmp1.wine;
class type;
model quality = fixed_acidity -- alcohol type / tolerance solution;
RUN; QUIT;

PROC IMPORT datafile = "C:\Users\Kim Yuum\Desktop\19-1 ���\ȸ�ͺм��׽ǽ�\Regression\week5\data\airline_passengers.csv"
dbms = csv replace out = passengers; *��л꼺 ���� x: scatter plot�� ���� �� �� o!; *���콺 ������ ����: �л��� �ּ��� ���� ���� good;
getnames = yes;
RUN;

DATA passengers2;
set passengers;
ind = _n_;
RUN;

PROC REG data = passengers2;
model passengers = ind / spec r; *spec: ��л꼺 test ;
output out = passenger_out p = pred r = resid; *residual ���� ���� -> ��л꼺 ���� x; *prediction value/residual �ְڴ�;
RUN; QUIT;

DATA abs_resid;
set passenger_out;
abs_resid = abs(resid); *����ġ ����; 
RUN; QUIT;

PROC REG data = abs_resid NOPRINT;
model abs_resid = ind;
output out = passenger_abs_resid p = pred;
RUN; QUIT;

DATA weight_dat;
set passenger_abs_resid;
w = 1 / (pred**2);
PROC REG data = weight_dat;
model passengers = ind / spec r; *��л꼺 ���� ���; *������ �����׷��� Ȯ��;
weight w;
output out = fpassenger p = wp student = wr r = wr0;
RUN; QUIT;
