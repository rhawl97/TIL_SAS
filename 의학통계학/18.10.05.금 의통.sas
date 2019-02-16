/*****3장*****/
DATA test;
INPUT drug $ mi $ count;
CARDS;
1 1 73
1 2 18
2 1 141
2 2 196
;
proc freq ; 
tables drug*mi / measures;  *약물남용이 심장발작을 높인다 //신뢰구간 1포함 x , 오즈비확인;
weight count;
run;

/*카이제곱 검정 : 예제 3-3 [표 3.6] */
DATA test1;
INPUT treat $ mi $ count;
CARDS;
a yes 139 
a no 10898
p yes 239
p no 10795
;
PROC FREQ DATA=test1;
WEIGHT count;
TABLE treat*mi/CHISQ ;  *카이제곱 검정 옵션;
RUN;  *카이제곱,pvalue확인 -- 귀무가설 기각 pvalue 매우작음;

/*피셔의 정확검정법 : 예제 3-4 [표3.10]*/
/**카이제곱 겁정은 기대도수가 5미만인 칸이 전체 20%초과할 때 결과가 잘 나오지 않음 -- 피셔**/
DATA test2;
INPUT treat $ rep $ count;
CARDS;
 a yes 1
 a no 4
 b yes 3
 b no 2
 ;
 proc freq data = test2;
 weight count;
 table treat*rep/exact; *피셔 옵션;
 run;  *결과 : 0.26이라는 pvalue 사용해야함;

/*맥니마 검정 : 예제 3-5 [표 3.14] */
DATA marriage;   *동일한 대상의 처리; *귀무가설 : H0 : p1 =p2 ;
INPUT before $ after $ count @@; *@@ : 데이터를 줄줄이 읽어들여라;
CARDS;
satisfy satisfy 23
satisfy unsatisfy 7
unsatisfy satisfy 18
unsatisfy unsatisfy 12
;

ODS SELECT McNemarsTest;  *맥니마검정만 보여줘라;
PROC FREQ order=data;  *입력정보를 순서대로 출력하라;
WEIGHT count;
TABLES before*after/AGREE; *맥니마 옵션;
RUN;  *pvalue0.0278 < 유의수준0.05 이므로 유의한 차이가 있다;


/*코크란-맨텔-핸젤 검정 : 예제 3-6 [표 3.18] */
DATA hospital; *4개의 병원에 관한 빈도표; 
INPUT hospital $ trt $ recovery $ count @@;  *귀무가설 : H0 : p1 =p2 ;
CARDS;  
A old yes 9 A old no   5
A new yes 11 A new no  6
B old yes 7 B old no   5
B new yes 8 B new no   3
C old yes 4 C old no   6
C new yes 7 C new no   5
D old yes 18 D old no  11
D new yes 26 D new no  4
;
PROC FREQ;
WEIGHT count;  *CMH : 코크란 검정 옵션;
TABLES hospital*trt*recovery/CMH NOROW NOCOL; *hospital이 맨 앞에 와야 '병원에 대한' trt 와 recovery의 빈도표 출력 -- 순서 중요!; 
RUN;  *pvalue 0.0445 < 유의수준 0.05이므로 치료제와 호전도에 유의한 연관성이 있다. 병원을 층변수로 제어했을 때!;

/*hospital을 층변수로 제어하지 않았을 때*/
data hospital2;
input trt $ recovery $ count @@;
cards;
old yes 9 old no 5
new yes 11 new no 6
old yes 7 old no 5
new yes 8 new no 3
old yes 4 old no 6
new yes 7 new no 5
old yes 18 old no 11
new yes 26 new no 4
;
proc freq;
weight count;
tables trt*recovery/CHISQ;
run; *카이제곱 통계량 확인, pvalue > 0.05 이므로 귀무가설 기각 x -- 치료제와 호전도 사이에 유의한 연관성이 없다;

/*****4장*****/
data liver;
infile "C:\Users\통계37\Desktop\liver.txt"  dlm ='09'x; *구분자가 탭임을 dlm으로 표시. space일 경우 ' ', comma ',';
input trt $ remission y;
run;
*로짓분석;
PROC LOGISTIC data=liver DESCENDING; *y=1: 재발확률 을 기준으로 데이터 불러오기;
CLASS trt; *범주형 변수는 trt이다 지정;
MODEL y=trt remission/SCALE=NONE AGGREGATE;  *홈피 설명 참조;
RUN; 
*결과!
response profile 재발한 사람 53명, y=1로 모델이 형성되었다. design variables 부호 바뀜. pvalue > 0.05 이면 적합한 모델이다(반대임)
Analysis of Maximum Likelihood Estimates 중요!! wald 검정통계량 ,trt :  pvalue <0.05 귀무가설 기각 -- trt는 유의한 변수이다. 
로짓 모형 : ln px/(1-px) = 2.04 - 0.59*trt - 0.20*remission ___trt에 A = 1 B = -1
Odds Ratio Estimates : trt 오즈비 0.308 remission 오즈비 0.819
처리A를 받은 사람의 재발확률이 처리B를 받은 사람의 30.8%이다.
처리A를 받을수록, 긴 호전기간일수록 재발확률 낮아짐*/

/**결과 그래프 그리기**/
ods graphics on;
PROC LOGISTIC data=liver  DESCENDING plots(only)=(effect);;
CLASS trt;
MODEL y=trt remission/SCALE=NONE AGGREGATE;  *호전기간 길어질수록 probability 낮아짐, A파란색 < B빨간색 -- A받을수록 확률 낮아짐;
output out=pdata  predicted = pred_prob;  *결과를 pdata에 저장_pdata에 변수 하나 추가;
RUN;

/*  새로운 관측치에 대한 확률의 추정 
만약에 위와 같은 분석을 시행한 후 새로운 환자가 나타나서 A 치료를 받고(trt=A) 호전기간이 13일 이라면 (remission=12)
재발 확률은 얼마로 추정하겠는가?*/
DATA new; 
INPUT trt $ remission ; *새로운 관측치 데이터 생성;
CARDS;
A   13
B  7
;
run;
PROC LOGISTIC DESCENDING data=liver  outmodel=predmodel noprint   ;  *로짓 모델 outmodel옵션으로 저장;
CLASS trt;
MODEL y=trt remission/SCALE=NONE AGGREGATE;
RUN;

PROC LOGISTIC inmodel=predmodel  ;  *predmodel을 사용해라;
    score data=new out=newprob;  *score라는 옵션으로 new 라는 데이터 추가 , 결과는 newprob으로 저장;
RUN;

proc print data=newprob; run;  
*1번 사람 재발하지 않을 것이다 WHY? 재발확률이 24퍼, 재발안할확률이 75퍼이기 때문_보통 기준 50퍼
  2번 사람 재발할 것이다.;

/*로짓 분석 : 예제 4-2 [표 4.9]*/
DATA cure;
INPUT type $ trt $ outcome $ count @@;
CARDS;
T A cured 65  T A uncured 18
M B cured 100 M B uncured 13
T C cured 56  T C uncured 38
M A cured 80  M A uncured 15
T B cured 29  T B uncured 9
M C cured 78  M C uncured 22
;

PROC LOGISTIC;
FREQ count;
CLASS type trt;
MODEL outcome =type trt/SCALE=NONE AGGREGATE;
RUN;
*결과!
Probability modeled is outcome='cured'. : 디폴트 ascending이기 때문
Deviance and Pearson Goodness-of-Fit Statistics >0.05 이므로 모델 적합하다
Analysis of Maximum Likelihood Estimates 으로 로짓모형 만들기
Odds Ratio Estimates 으로 오즈비 구하기
;
