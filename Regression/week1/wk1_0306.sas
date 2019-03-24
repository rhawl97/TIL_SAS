DATA distance;
miles = 26.22;
kilometer = 1.61 * miles;
PROC PRINT DATA = distance;
run;

libname reg "C:/Users/Kim Yuum/Desktop/19-1 ���/ȸ�ͺм��׽ǽ�/Regression/";  *reg��� �̸����� �۾�ȯ���� ��θ� ����;
options validvarname = any; *�ѱ� ������ ����� �� �ְ� �ϴ� �ɼ�;

PROC contents data = distance; /*���̺귯��.�������̸� --> work���̺귯���� �� �ʿ� ����!*/
RUN;

DATA one;
input ph Time Temperature;
cards;
4.5 20 125
4.1 22 133
2.8 18 149
4.0 26 120
5.0 25 120
6.0 21 138
;
run;
proc print data = one;
run;

proc import datafile = "C:/Users/Kim Yuum/Desktop/19-1 ���/ȸ�ͺм��׽ǽ�/Regression/iris.xlsx" dbms = xlsx replace
out  = reg.iris_dat; *���ϴ� ���̺귯���� ����;
getnames = yes;
run;



