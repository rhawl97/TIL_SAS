DATA jail;
INPUT live $ arrest $ jail $ count @@;
CARDS;
n y y 42 n y n 109 n n y 17 n n n 75
y y y 33 y y n 175 y n y 53 y n n 359
;

PROC LOGISTIC DESCENDING;
FREQ count;
CLASS live arrest;
MODEL jail = live arrest / SCALE = NONE AGGREGATE;
RUN;

DATA lungcancer;
INPUT cancer $ smoking $ count @@;
CARDS;
1 1 9
1 0 5
0 1 46
0 0 40
;
RUN;

PROC LOGISTIC DATA = lungcancer DESCENDING; *카이제곱 검정이지만 로지스틱으로 적합 가능;
FREQ count;
CLASS smoking cancer; *cancer 추가;
MODEL cancer = smoking / SCALE = NONE AGGREGATE;
RUN;

/*3번!*/
DATA car;
INPUT x1 x2 y;
CARDS;
45 2 0
40 4 1
60 3 0
50 2 0
55 2 0
50 5 1
35 7 1
65 10 1
53 2 0
48 1 0
37 5 1
31 7 1
40 4 0
75 8 1
43 9 1
49 2 0
37.5 4 1
71 11 1
34 5 0
27 6 1
;
RUN;

PROC LOGISTIC DESCENDING data =car outmodel=predmodel noprint;
MODEL y = x1 x2 / SCALE = NONE AGGREGATE;
RUN;

DATA new; 
INPUT x1 x2 ; 
CARDS;
44 2.5
;
run;

PROC LOGISTIC inmodel=predmodel  ;  
    score data=new out=newprob;  
RUN;

proc print data=newprob; run;  

Data oring; 
input trial failed temp ; 
cards;
6 0 66 
6 1 70 
6 0 69 
6 0 68 
6 0 67 
6 0 72 
6 0 73 
6 0 70 
6 1 57 
6 1 63 
6 1 70 
6 0 78 
6 0 67 
6 2 53 
6 0 67 
6 0 75 
6 0 70 
6 0 81 
6 0 76 
6 0 79 
6 2 75 
6 0 76 
6 1 58 
; 
run;

proc logistic data=oring ;
  model failed/trial = temp ; 
run; 

ods graphics on;
PROC LOGISTIC data=oring  plots(only)=(effect);;
MODEL failed/trial = temp / SCALE=NONE AGGREGATE;  
output out=pdata;
RUN;

PROC LOGISTIC DESCENDING data =oring outmodel=predmodel noprint;
MODEL failed/trial = temp / SCALE = NONE AGGREGATE;
RUN;

DATA new; 
INPUT temp ; 
CARDS;
50
40
30
;
run;

PROC LOGISTIC inmodel=predmodel  ;  
    score data=new out=newprob;  
RUN;

proc print data=newprob; run;  
