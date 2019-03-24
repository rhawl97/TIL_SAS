libname reg "C:/Users/Kim Yuum\Desktop/19-1 ���/ȸ�ͺм��׽ǽ�/Regression/week3/data"; *��� ���̺귯�� ����;

/*���� ���� �ùķ��̼�*/
DATA normal(drop = seed n);  *seed�� n�� �ʿ����;
seed = 1;
call streaminit(seed);
do n = 1 to 1000;
  x1 = rand("Normal",0,1);  *ǥ�����Ժ������� ���� ����;
  x2 = x1 ** 2;
  output;
end;
run;
proc univariate data = normal;
var x2;
histogram x2 / gamma(alpha = 0.5 sigma = 2);  *histogram���� ī������ ���� �׷��� overlap; *gamma���� special case;
RUN;

/*�浵 ������*/
PROC REG data = reg.hardness;
model hardness = temp;
RUN;  *���� ��Ÿ 94.13407 ���� -1.26615�� ������;

DATA reg.hardness_test;
set reg.hardness end = last; 
output;
if last then do;
Hardness = .;  *y�� ���� x���� �Է��ؼ� �����ϵ��� ��!;
Temp = 55;
output;
end;
RUN;
PROC REG data = reg.hardness_test;
model hardness = temp / CLM CLI;
output out = test_out(where = (Hardness = .)) p = predicted ucl = UCL_Pred 
lcl = LCL_Pred uclm = UCLM_mean lclm = LCLM_mean; *hardness�� ����ġ�κκи�; *�� predicted�־����;
RUN; QUIT; *run���θ� ������ ������ ������ �ʾҴٰ� ������ output�� ��� ����!;
