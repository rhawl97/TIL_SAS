/* 폐암환자의 모수적 모형적합을 위한 SAS 프로그램*/;

DATA lung;
INPUT time censor x1 x2 x3 trt type @@;
CARDS;
411 1 70 64  5 1 1   126 1 60 63  9 1 1   118 1 70 65 11 1 1   82 1 40 69 10 1 1
  8 1 40 63 58 1 1    25 0 70 48  9 1 1    11 1 70 48 11 1 1   54 1 80 63  4 1 2 
153 1 60 63 14 1 2    16 1 30 53  4 1 2    56 1 80 43 12 1 2   21 1 40 55  2 1 2 
287 1 60 66 25 1 2    10 1 40 67 23 1 2     8 1 20 61 19 1 3   12 1 50 63  4 1 3
177 1 50 66 16 1 4    12 1 40 68 12 1 4   200 1 80 41 12 1 4  250 1 70 53  8 1 4
100 1 60 37 13 1 4   999 1 90 54 12 2 1   231 0 50 52  8 2 1  991 1 70 50  7 2 1
  1 1 20 65 21 2 1   201 1 80 52 28 2 1    44 1 60 70 13 2 1   15 1 50 40 13 2 1
103 0 70 36 22 2 2     2 1 40 44 36 2 2    20 1 30 54  9 2 2   51 1 30 59 87 2 2
 18 1 40 69  5 2 3    90 1 60 50 22 2 3    84 1 80 62  4 2 3  164 1 70 68 15 2 4 
 19 1 30 39  4 2 4    43 1 60 49 11 2 4   340 1 80 64 10 2 4  231 1 70 67 18 2 4
;


DATA diabetes;
INPUT censor time age bmi dage smoke @@;
CARDS;
1 3.6 63 25.1 46 1 1 15.4 71 26 59 0 1 11.3 51 32 49 1
1 10.3 59 28.1 57 1 1 5.8 50 26.1 49 1 0 8 66 45.3 49 0
1 14.6 42 30 41 1 1 11.4 40 35.7 36 1 1 7.2 67 28.1 61 0
1 5.5 86 32.9 61 0 1 11.1 52 37.6 46 1 1 16.5 42 43.4 37 0
1 10.9 60 25.4 60 0 1 2.5 75 49.7 57 1 0 10.8 81 35.2 81 0
1 4.7 60 37.3 39 0 0 5.5 60 26 42 0 1 4.5 63 21.8 60 1 
1 9 62 18.2 43 0 1 6.8 57 34.1 41 1 0 3.6 71 25.6 54 1
1 12.1 58 35.1 45 0 1 8.1 42  32.5 28 1 1 11.1 45 44.1 40 0
0 7 66 29.7 59 1 1 1.5 61 29.2 54 0 1 11.7 48 25.2 30 1
1 0.3 82 25.3 50 0
;

PROC LIFEREG DATA=diabetes;
       CLASS smoke;
       MODEL time*censor(0) = age bmi dage smoke/ DIST=WEIBULL;      
RUN;
PROC LIFEREG DATA=lung;
       CLASS trt type;
       MODEL time*censor(0) = x1 x2 x3 trt type/ DIST=WEIBULL;      
RUN;
/* 지수분포, 와이블분포의 적합성 검토를 위한 SAS 프로그램 */

PROC LIFETEST  PLOTS=(LS, LLS) GRAPHICS;
     TIME  time*censor(0);
RUN;

/* 로그-정규분포, 로그-로지스틱분포 검토를 위한 SAS 프로그램 */;

PROC LIFETEST DATA=lung OUTSURV=a;
      TIME time*censor(0);
DATA b; SET a;
         S=SURVIVAL;
         LOGIT=LOG((1-S)/S);
         LNORM=PROBIT(1-S);
         LTIME=LOG(time);
PROC GPLOT;
       SYMBOL1 VALUE=NONE I=JOIN;
       PLOT LOGIT*LTIME LNORM*LTIME;
RUN;


/* HSV-2 자료의 비례위험모형분석 SAS 프로그램 */;

 DATA hsv2;
   INPUT grp $ x time censor @@;
   IF grp="gd2" THEN trt=1;
   ELSE IF grp="pbo" THEN trt=0;
   CARDS;
     gd2 12   8 1  gd2 10  12 0  gd2  7  52 0  gd2 10  28 1
     gd2  6  44 1  gd2  8  14 1  gd2  8   3 1  gd2  9  52 0
     gd2 11  35 1  gd2 13   6 1  gd2  7  12 1  gd2 13   7 0
     gd2  9  52 0  gd2 12  52 0  gd2 13  36 1  gd2  8  52 0
     gd2 10   9 1  gd2 16  11 0  gd2  6  52 0  gd2 14  15 1
     gd2 13  13 1  gd2 13  21 1  gd2 16  24 0  gd2 13  52 0
     gd2  9 28 1  pbo 9   15 1  pbo 10  44 0  pbo 12   2 0  
     pbo 7    8 1  pbo 7   12 1  pbo 7   52 0  pbo 7   21 1
     pbo 11  19 1  pbo 16   6 1  pbo 16  10 1  pbo 6   15 0 
     pbo 15   4 1  pbo 9    9 0  pbo 10  27 1  pbo 17   1 1 
     pbo 8   12 1  pbo 8   20 1  pbo 8   32 0  pbo 8   15 1
     pbo 14   5 1  pbo 13  35 1  pbo 9   28 1  pbo 15   6 1 
   ;
   PROC PHREG DATA=hsv2;
        MODEL time*censor(0) =x  trt;
   RUN;

 /* 폐암자료의 비례위험모형분석  SAS 프로그램 */;
   DATA lung;
   INPUT time censor x1 x2 x3 trt type @@;
   IF trt=1 then trt1=1;  ELSE trt1=0;
   IF type=1 then type1=1; ELSE type1=0;
   IF type=2 then type2=1; ELSE type2=0;
   IF type=3 then type3=1; ELSE type3=0;
   CARDS;
411 1 70 64  5 1 1   126 1 60 63  9 1 1   118 1 70 65 11 1 1   82 1 40 69 10 1 1
  8 1 40 63 58 1 1    25 0 70 48  9 1 1    11 1 70 48 11 1 1   54 1 80 63  4 1 2 
153 1 60 63 14 1 2    16 1 30 53  4 1 2    56 1 80 43 12 1 2   21 1 40 55  2 1 2 
287 1 60 66 25 1 2    10 1 40 67 23 1 2     8 1 20 61 19 1 3   12 1 50 63  4 1 3
177 1 50 66 16 1 4    12 1 40 68 12 1 4   200 1 80 41 12 1 4  250 1 70 53  8 1 4
100 1 60 37 13 1 4   999 1 90 54 12 2 1   231 0 50 52  8 2 1  991 1 70 50  7 2 1
  1 1 20 65 21 2 1   201 1 80 52 28 2 1    44 1 60 70 13 2 1   15 1 50 40 13 2 1
103 0 70 36 22 2 2     2 1 40 44 36 2 2    20 1 30 54  9 2 2   51 1 30 59 87 2 2
 18 1 40 69  5 2 3    90 1 60 50 22 2 3    84 1 80 62  4 2 3  164 1 70 68 15 2 4 
 19 1 30 39  4 2 4    43 1 60 49 11 2 4   340 1 80 64 10 2 4  231 1 70 67 18 2 4
; 
   PROC PHREG DATA=lung;
        MODEL time*censor(0) =x1 x2 x3 trt1 type1 type2 type3 ;
    RUN;


	DATA acute;
   INPUT time censor age bone @@;
   cards;
   18 1 0 0 9 1 0 1 28 0 0 0 31 1 0 1
   39 0 0 1 19 0 0 1 45 0 0 1 6 1 0 1
   8 1 0 1 15 1 0 1 23 1 0 0 28 0 0 0
   7 1 0 1 12 1 1 0 9 1 1 0 8 1 1 0
   2 1 1 1 26 0 1 0 10 1 1 1 4 1 1 0
   3 1 1 0 4 1 1 0 18 1 1 1 8 1 1 1
   3 1 1 1 14 1 1 1 3 1 1 0 13 1 1 1
   13 1 1 1 35 0 1 0
   ;
   run;
 PROC PHREG DATA=acute;
        MODEL time*censor(0) =age bone ;
    RUN;

 /* 비례위험모형에서 생존함수의 추정을 위한 SAS 프로그램 */;

 PROC PHREG DATA=lung;
      MODEL time*censor(0) =x1 x2 x3 trt1 type1 type2 type3;
      BASELINE OUT=a SURVIVAL=s LOGSURVIVAL=ls LOGLOGS=lls; 
run;

PROC PRINT DATA=a; 
run;

DATA b; 
   SET a; ls=-ls;
run;

PROC GPLOT DATA=b;
      PLOT ls*time;
      SYMBOL1 VALUE=NONE INTERPOL=JOIN; 
 RUN;

 /*비례성 검토를 위한 SAS 프로그램 */; 
 PROC PHREG DATA=lung;
          MODEL time*censor(0) =x1 x2 x3 type1 type2 type3 ;
          STRATA trt;
          BASELINE OUT=c SURVIVAL=s LOGLOGS=lls; 
run;

PROC GPLOT DATA=c;
         PLOT lls*time=trt;
         SYMBOL1 INTERPOL=JOIN COLOR=BLACK LINE=1;
         SYMBOL2 INTERPOL=JOIN COLOR=BLACK LINE=2;
  RUN;




