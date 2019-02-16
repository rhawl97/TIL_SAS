
/* <표 7.3> 협심증자료의 생명표를 위한 SAS program */;

DATA angina;
  INPUT  time censor rep @@;
CARDS;
0.5  1 456   0.5 0  0    1.5  1  226  1.5 0  39
2.5  1 152   2.5 0  22   3.5  1 171   3.5 0  23
4.5  1 135   4.5 0  24   5.5  1 125   5.5 0 107
6.5  1  83   6.5 0 133   7.5  1  74   7.5 0 102
8.5  1  51   8.5 0  68   9.5  1  42   9.5 0  64
10.5  1  43  10.5 0  45  11.5  1  34  11.5 0  53
12.5  1  18  12.5 0  33  13.5  1   9  13.5 0  27
14.5  1   6  14.5 0  23  15.5  1   0  15.5 0  30
;

PROC LIFETEST data=angina METHOD=LIFE
    INTERVALS= 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
    PLOTS=(S, H)
    GRAPHICS;
   TIME time*censor(0);
   FREQ rep;
RUN;
/*7_1*/
DATA lungcancer;
  INPUT  time censor rep @@;
CARDS;
0.5  1 82   0.5 0  0    1.5  1  30  1.5 0  8
2.5  1 27   2.5 0  8   3.5  1 22   3.5 0  7
4.5  1 26  4.5 0  7   5.5  1 25   5.5 0 28
6.5  1  20   6.5 0 31   7.5  1  11   7.5 0 32
8.5  1  14   8.5 0  24   9.5  1  13   9.5 0  27
10.5  1  5  10.5 0  22  11.5  1  5  11.5 0  23
12.5  1  5 12.5 0  18  13.5  1   2  13.5 0  9
14.5  1   3  14.5 0  7  15.5  1   3  15.5 0  11
;

PROC LIFETEST data=lungcancer METHOD=LIFE
    INTERVALS= 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
    PLOTS=(S, H)
    GRAPHICS;
   TIME time*censor(0);
   FREQ rep;
RUN;



/* <표 7.6> 신장이식환자자료의 누적한계추정법을 위한 SAS 프로그램 */;


DATA cancer;
INPUT time censor @@;
CARDS;
 2.0  1    4.0  1    5.0  1    10.0  1
 10.0  0    12  1    12  0    14  1
 14  1    15  1    16  0   18  1
19  0   23  1   25  1  26 0
27  1  30  0  31  1 34  1
35  1  37  0  38  1  39  1
42  0  43  0  46  1  47  0
49  1  50  1  53  0  54  0
;

PROC LIFETEST data=cancer  METHOD=KM PLOTS=survival graphics outsurv = a;
     TIME  time*censor(0); 
RUN;
proc print data = a;
run;
/* <표 7.9> 흑색종환자들의 생존함수비교  SAS프로그램 */;

DATA hodgkin;
INPUT time censor group @@ ;
CARDS;
1 1 1  2 1 1 5 1 1  5 1 1 5 1 1
7 1 1  9 1 1 11 1 1 11 1 1 13 1 1
13 1 1  16 1 1  20 1 1  21 1 1  22 0 1
22 1 1  31 0 1  33 0 1  37 0 1  43 1 1
1 1 2  3 1 2  4  1 2  4 1 2  5 1 2 7 1 2 
7 1 2  9 1 2  9 1 2  14 0 2  17 1 2  19 0 2
27 0 2  30 0 2  41 0 2
;
PROC LIFETEST data=hodgkin PLOTS=(S) ;
     TIME  time*censor(0);
     STRATA group;
     SYMBOL1 V=NONE COLOR=BLACK LINE=1;
     SYMBOL2 V=NONE COLOR=BLACK LINE=2;
RUN;



