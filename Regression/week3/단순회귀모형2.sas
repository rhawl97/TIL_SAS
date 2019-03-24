libname reg "C:/Users/Kim Yuum\Desktop/19-1 통계/회귀분석및실습/Regression/week3/data"; *경로 라이브러리 지정;

/*분포 유도 시뮬레이션*/
DATA normal(drop = seed n);  *seed랑 n은 필요없어;
seed = 1;
call streaminit(seed);
do n = 1 to 1000;
  x1 = rand("Normal",0,1);  *표준정규분포에서 랜덤 추출;
  x2 = x1 ** 2;
  output;
end;
run;
proc univariate data = normal;
var x2;
histogram x2 / gamma(alpha = 0.5 sigma = 2);  *histogram위에 카이제곱 분포 그래프 overlap; *gamma분포 special case;
RUN;

/*경도 데이터*/
PROC REG data = reg.hardness;
model hardness = temp;
RUN;  *기울기 베타 94.13407 절편 -1.26615로 추정됨;

DATA reg.hardness_test;
set reg.hardness end = last; 
output;
if last then do;
Hardness = .;  *y값 없이 x값만 입력해서 예측하도록 함!;
Temp = 55;
output;
end;
RUN;
PROC REG data = reg.hardness_test;
model hardness = temp / CLM CLI;
output out = test_out(where = (Hardness = .)) p = predicted ucl = UCL_Pred 
lcl = LCL_Pred uclm = UCLM_mean lclm = LCLM_mean; *hardness가 결측치인부분만; *꼭 predicted넣어야해;
RUN; QUIT; *run으로만 끝나면 모형이 끝나지 않았다고 생각해 output에 계속 넣음!;
