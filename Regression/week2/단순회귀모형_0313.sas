libname reg "C:/Users/Kim Yuum/Desktop/19-1 ���/ȸ�ͺм��׽ǽ�/Regression/week2/";

proc import datafile = "C:/Users/Kim Yuum/Desktop/19-1 ���/ȸ�ͺм��׽ǽ�/Regression/week2/aflength.csv"
dbms = csv replace out=reg.aflength;
getnames = yes;
LABEL foot = "�߱���" forearm = "�Ⱦ��ʱ���" gender = "����";
run;

/*������ �������*/
proc contents data = reg.aflength;
run;

/*�Ⱦ��ʱ��̿� �߱����� ������ Ȯ���ϱ�*/
TITLE "�Ⱦ��ʱ��̿� �߱����� ������";
PROC SGPLOT DATA = reg.aflength;
SCATTER X = forearm Y = foot; /* X, Y ������ ������ �ۼ� */
REG X = forearm Y = foot; /* �������� ����ȸ�������� �߰��� ǥ��*/
RUN;

/*�Ⱦ��ʱ��̿� �߱��̿� ���� ����м��ϱ�*/
PROC CORR data = reg.aflength FISHER(rho0 = 0); /* �������м� */  /*�ɼ� �� �־��� ������ ���� ���!!*/
VAR foot; /* FISHER �ɼ�: ������迡 ���� ������ �ŷڱ����� ����Ѵ�*/
WITH forearm;
RUN;

/*�ּ��������� ���� ����� ȸ�Ͱ�� ���ϱ�*/
proc means data = reg.aflength noprint; *����SAS���� �� ��;
var foot forearm;
output out = mean_set mean = /autoname;
run;
/*x, y ��� ���ؼ� �����ϱ�
������ �����ͼ� foot, forearm �� ������ ���� ����� ����ؼ� mean_set�� ����
�̶�, �̸��� autoname���� �ڵ� �����ǰ� */

data aflength;
if _n_ = 1 then set mean_set (drop = _freq_ _type_);
set reg.aflength;
diff_foot = foot - foot_mean;
diff_forearm = forearm - forearm_mean;
squ_diff_forearm = diff_forearm**2;
pro_var = diff_foot*diff_forearm;
run;
/* mean_set�� example.aflength�� �����Ͽ� �ѹ��� ����Ϸ��� ����� �ڵ�
mean_set���� _freq_�� _type_�� ������ ������ �� �ؿ� �ĵ��� ���*/
proc means data = aflength noprint;
var pro_var squ_diff_forearm;
output out = sum_set sum = /autoname;
run;
/*mean���� ���������� sum ����ϱ� ����*/
data beta_set;
if _n_ = 1 then set sum_set;
set mean_set;
4
beta_1 = pro_var_sum / squ_diff_forearm_sum;
beta_0 = foot_mean - beta_1*forearm_mean;
drop _type_ _freq_ pro_var_sum squ_diff_forearm_sum forearm_mean foot_mean;
run;
/*sum_set�� mean_set�� �����Ͽ� beta1�� beta0�� �����Ҽ� �ְ� �����*/


/*PROC REG �� �̿��� ȸ�ͺм� �ϱ�*/
PROC REG data = reg.aflength; /*������ ������ �г� ���*/
MODEL foot = forearm / R; /* �����м��� ���� ��谪�� ����ϴ� �ɼ� ���*/
RUN;  /*�ּ��������� ���� ȸ�ͺм� ���*/
*intercept�� ��Ÿ����(����) ����;


/*������ ȸ�͸����� ���� �������� Y �� ��� ���� ���� ���� �ŷڱ��� �� ���ο� ���� ���� �������� ���ϱ�*/
PROC REG data = reg.aflength;
MODEL foot = forearm / CLM CLI;
RUN;

