PROC IMPORT datafile= "C:\Users\Kim Yuum\Desktop\19-1 ���\ȸ�ͺм��׽ǽ�\Regression\0515\data/expdata.csv" dbms= csv
out = expdata;
getnames = yes;
run; quit;

proc sgscatter data = expdata;  *�׳�sgplot scatter�� x y�ϳ�����!;
matrix y--x2;  *y x1 x2; /*�������� ���� ȸ�Ͱ�� ������ ������ �Ǵ� ����*/
run; quit;

proc reg data = expdata; *�ϳ��� �ִ°� ���� ����ȸ�Ͱ� ����;
m1: model y = x1;
m2: model y = x2;
m3: model y = x1 x2; *���� �Բ� ������ ���� ����� ���� -> ������ ��θ� ���� ���ߵȴ�!;
run; quit;

PROC IMPORT datafile= "C:\Users\Kim Yuum\Desktop\19-1 ���\ȸ�ͺм��׽ǽ�\Regression\0515\data/usedcars.csv" dbms= csv
out = usedcar;
getnames = yes;
run; quit;

proc sgscatter data = usedcar;
matrix price -- automatic/diagonal = (kernel histogram);
run; quit;

proc reg data = usedcar; *adj r-squre ����;
model price = year -- automatic;
run; quit;
