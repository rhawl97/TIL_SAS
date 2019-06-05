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
DATA tmp1.tar_dat (drop = obs_index type); *필요없는거 제거;
set tmp1.wine_inf (where = (obs_index = 1 & type = "red"));
RUN; QUIT;

PROC REG data = tmp1.tar_dat;  *관측치 수 줄어들었음; *cook'sD 기준넘는 값이 또 있음;
model quality = fixed_acidity -- alcohol / r;
RUN; QUIT;

/*변수 선택*/
PROC REG data = tmp1.tar_dat;
model quality = fixed_acidity -- alcohol / selection = rsquare mse cp aic bic sbc best = 1;  
*forward나 등등을 적지 않으면 2^p개의 모형을 다 적합시켜줌; *이 2^p개의 rsquare를 구해라; *너무 많으니 best=1하면 변수 한개 들어간 것 중 가장 좋은 것;
RUN; QUIT;

/*시험에 나옴*/
PROC REG data = tmp1.tar_dat outest = tmp1.step_out;
model quality = fixed_acidity -- alcohol / selection = stepwise sle=0.1 sls=0.1;  *나머지 변수가 given일 때 유의확률이 제일 낮은 변수가 들어감; *최대 0.157까지! ;
PROC REG data = tmp1.tar_dat outest = tmp1.forward;
model quality = fixed_acidity -- alcohol / selection = forward sle=0.1; *기준을 0.157로 말고 유의확률 0.1로 하고 싶을 때;
PROC REG data = tmp1.tar_dat outest = tmp1.backward; *full model에서 하나씩 제거;
model quality = fixed_acidity -- alcohol / selection = backward sls=0.1;
RUN; QUIT;


PROC REG data = tmp1.tar_dat outest = tmp1.step_out;  *stepwise로 최종 저장;
model quality = fixed_acidity -- alcohol / selection = stepwise sle=0.1 sls=0.1; *dw를 옵션으로 넣으면 마지막 최종모형에 대한 dw값 나와줌 가정 맞는지 확인!;
run; quit;

PROC SCORE data = tmp1.test_wine score = tmp1.step_out out = tmp1.step_pred 
type = parms;  *stepwise parameter! type은 step_out에 type(파일 확인);
var fixed_acidity -- alcohol;
RUN; QUIT;

DATA tmp1.mse;
set tmp.step_pred;
square = (quality-model1)**2;
run; quit;

PROC MEANS data = tmp1.mse;  *나오는 평균값이 prediction 한 것의  최종 mse! model의 mse아님! ;
var square;
run;


