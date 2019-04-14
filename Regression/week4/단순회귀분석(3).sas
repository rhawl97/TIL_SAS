libname reg "C:\Users\Kim Yuum\Desktop\19-1 ���\ȸ�ͺм��׽ǽ�\Regression\week4\data";

PROC IMPORT datafile = "C:\Users\Kim Yuum\Desktop\19-1 ���\ȸ�ͺм��׽ǽ�\Regression\week4\data\train_car.csv" dbms = csv replace
out = reg.train_car;
getnames = yes; *ù ���� �� �̸��̳�;
RUN;
PROC IMPORT datafile = "C:\Users\Kim Yuum\Desktop\19-1 ���\ȸ�ͺм��׽ǽ�\Regression\week4\data\test_car.csv" dbms = csv replace
out = reg.test_car;
getnames = yes;
RUN;
PROC IMPORT datafile = "C:\Users\Kim Yuum\Desktop\19-1 ���\ȸ�ͺм��׽ǽ�\Regression\week4\data\test_y.csv" dbms = csv replace
out = reg.test_y;
getnames = yes;
RUN;

/*Training �����Ϳ��� �ڵ��� ����(Price)�� �ڵ��� ����(Weight)�� �������� ǥ���������� �����ϰ� ��������� 0���� �����Ͽ���.*/
PROC CORR data = reg.train_car FISHER(rho0=0);   *����;
var price weight;
run;
/*�ڵ����� ����(Y)�� ����(X)�� �̷���� ȸ�͸��� ����*/
PROC reg data = reg.train_car; /*t-value �����ϸ� F value*/
model price = weight/CLM CLI; *��տ� ���� �ŷڱ���; *���� ����;
RUN;



