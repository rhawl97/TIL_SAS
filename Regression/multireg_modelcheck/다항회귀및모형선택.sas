PROC REG data = tmp1.wine_tmp (where = (type = "red"));
model quality = fixed_acidity -- alcohol / spec dw;
output out = tmp1.wine_out COOKD = cookd DFFITS = diffit COVRATIO = covratio
RSTUDENT = rstudent H = hatval;
RUN; QUIT;

DATA tmp1.wine_inf;
set tmp1.wine_out;
obs_index = cookd < (4 / 483) & abs(rstudent) < 2.5;
RUN; QUIT;

/*method1*/
PROC REG data = tmp1.wine_inf (where = (obs_index = 1 & type = "red"));
model quality = fixed_acidity -- alcohol / r;
RUN; QUIT;

/*method2*/
DATA tmp1.tar_dat (drop = obs_index type); *�ʿ���°� ����;
set tmp1.wine_inf (where = (obs_index = 1 & type = "red"));
RUN; QUIT;

PROC REG data = tmp1.tar_dat;  *����ġ �� �پ�����; *cook'sD ���سѴ� ���� �� ����;
model quality = fixed_acidity -- alcohol / r;
RUN; QUIT;

/*���� ����*/
PROC REG data = tmp1.tar_dat;
model quality = fixed_acidity -- alcohol / selection = rsquare mse cp aic bic sbc best = 1;  
*forward�� ����� ���� ������ 2^p���� ������ �� ���ս�����; *�� 2^p���� rsquare�� ���ض�; *�ʹ� ������ best=1�ϸ� ���� �Ѱ� �� �� �� ���� ���� ��;
RUN; QUIT;

/*���迡 ����*/
PROC REG data = tmp1.tar_dat outest = tmp1.step_out;
model quality = fixed_acidity -- alcohol / selection = stepwise sle=0.1 sls=0.1;  *������ ������ given�� �� ����Ȯ���� ���� ���� ������ ��; *�ִ� 0.157����! ;
PROC REG data = tmp1.tar_dat outest = tmp1.forward;
model quality = fixed_acidity -- alcohol / selection = forward sle=0.1; *������ 0.157�� ���� ����Ȯ�� 0.1�� �ϰ� ���� ��;
PROC REG data = tmp1.tar_dat outest = tmp1.backward; *full model���� �ϳ��� ����;
model quality = fixed_acidity -- alcohol / selection = backward sls=0.1;
RUN; QUIT;


PROC REG data = tmp1.tar_dat outest = tmp1.step_out;  *stepwise�� ���� ����;
model quality = fixed_acidity -- alcohol / selection = stepwise sle=0.1 sls=0.1; *dw�� �ɼ����� ������ ������ ���������� ���� dw�� ������ ���� �´��� Ȯ��!;
run; quit;

PROC SCORE data = tmp1.test_wine score = tmp1.step_out out = tmp1.step_pred 
type = parms;  *stepwise parameter! type�� step_out�� type(���� Ȯ��);
var fixed_acidity -- alcohol;
RUN; QUIT;

DATA tmp1.mse;
set tmp.step_pred;
square = (quality-model1)**2;
run; quit;

PROC MEANS data = tmp1.mse;  *������ ��հ��� prediction �� ����  ���� mse! model�� mse�ƴ�! ;
var square;
run;


