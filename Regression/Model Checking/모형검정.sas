PROC SGPLOT data = tmp1.infludata; *이상치 확인 -> 어떻게 해결할까!;
scatter X = x Y = y;
RUN; QUIT;

PROC REG data = tmp1.infludata2 outest = est1; *infludata2는 infludata1에 index부여한 데이터;
model y = x / OUTSEB noprint;
PROC PRINT data = est1;  
RUN; QUIT;

PROC REG data = tmp1.infludata2 outest = est1; 
model y = x / OUTSEB noprint;
where index ^= 1; *index = 1이 아닌 것만 뽑자; 

PROC PRINT data = est1;  *intercept 계수, 에러;
RUN; QUIT;

PROC REG data = tmp1.infludata2 outest = est1; *intercept는 올라가고 기울기는 내려감;
model y = x / OUTSEB noprint;
where index ^= 2; *index = 2이 아닌 것만 뽑자; 

PROC PRINT data = est1; 
RUN; QUIT;

PROC REG data = tmp1.infludata2 outest = est1; 
model y = x / OUTSEB noprint;
where index not in (10, 11); *index = 10, 11이 아닌 것만 뽑자; 

PROC PRINT data = est1;  *intercept 계수, 에러;
RUN; QUIT;
*model1 seb  -> 절편의 standard error 계수의 standard error; 

*잔차 - 1) 표준화잔차 / 2) 표준화제외잔차  
1) 이상치일 경우 분자 분모가 독립이 아니므로 상쇄시켜 이상치가 있어도 작아지지 않음.
2) i번째 잔차를 계산할 때 i번째 데이터를 제외하고 계산하므로 이상치 영향 안 받음. 
2)표준화제외잔차  > 2.5인 경우 분포에서 매우 낮은 부분이므로 거의 등장하지 않는 이상치라고 보겠다. ;

/* Cook's D: 추정치의 차이 / 추정치의 분산, p+1 --> 통계량 의미 해석하기
  DFBETA: 추정치 전체를 다 봄 (j번째 beta의 i번째 데이터가 얼마나 영향을 미치는가) */


/*영향력 관측치 식별*/
PROC REG data = tmp1.usedcar;
model price = year -- automatic / r influence; *r: residual 값 influence: cookd dffit등; *Rstudent: i번째 제외한 나머지 잔차 기준 2.5; *cookd:계수전체에 대한 영향; 
*covratio: 계수의 분산(test에 영향을 주는) difffits: yhat(예측된값)에의 영향력 dfbetas: 각각의 변수에 대한 영향력;
RUN; QUIT;
