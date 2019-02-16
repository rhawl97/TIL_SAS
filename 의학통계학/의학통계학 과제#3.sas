/*=================================================*/;
/*교과서 예제 5.1 */

DATA medicine;
INPUT trt x y @@ ;
CARDS;
1 27.2 32.6 1 22.0 36.6 
1 33.0 37.7 1 26.8 31.0
2 28.6 33.8 2 26.8 31.7
2 26.5 30.7 2 26.8 30.4
3 28.6 35.2 3 22.4 29.1 
3 23.2 28.9 3 24.4 30.2
4 29.3 35.0 4 21.8 27.0
4 30.3 36.4 4 24.3 30.5
5 20.4 24.6 5 19.6 23.4
5 25.1 30.3 5 18.1 21.8
                     ;
/*박스그림을 ㄱ,리려면 처리(trt)순으로 자료를 정렬해야함 */;
proc sort data=medicine; by trt; run;

/*박스그림 그리기*/;
proc boxplot data=medicine;
  plot y*trt;
run;

/* 공변량 x와 반응변수 y 의 관계 산포도 */;
proc sgplot data=medicine;
   scatter x=x y=y / group=trt;
run;

/* ANOVA 실행 */;
PROC GLM data=medicine ;
CLASS trt;
MODEL y=trt  /SOLUTION; 
LSMEANS trt/TDIFF;
RUN;

/* ANCOVA 실행 */;
PROC GLM data=medicine ;
CLASS trt;
MODEL y=trt x /SOLUTION; 
LSMEANS trt/TDIFF;
RUN;

/*박스그림 그리기*/;
proc boxplot data=medicine;
  plot x*trt;
run;

/*=========================================*/;

/* 연습문제 5장 1번 */;

data data1;
	input trt $ x y;
cards;
A  5 20
A 10 23
A 12 30
A 9 25
A 23 34
A 21 40
A 14 27
A 18 38
A 6 24
A 13 31
B 7 19
B 12 26
B 27 33
B 24 35
B 18 30
B 22 31
B 26 34
B 21 28
B 14 23
B 9 22
;

proc boxplot data=data1;
  plot y*trt;
run;
proc sgplot data=data1;
   scatter x=x y=y / group=trt;
run;

PROC GLM data=data1 ;
CLASS trt;
MODEL y=trt  /SOLUTION; 
LSMEANS trt/TDIFF;
RUN;

PROC GLM data=data1 ;
CLASS trt;
MODEL y=trt x /SOLUTION; 
LSMEANS trt/TDIFF;
RUN;

DATA edu;
input method x y @@;
cards;
1 29 39 1 4 34 1 18 36
2 17 35 2 35 38 2 3 32
3 1 38 3 15 43 3 32 44
;
PROC GLM data=edu ;
CLASS method;
MODEL y=method x /SOLUTION; 
LSMEANS method/TDIFF;
RUN;

DATA na;
input trt $ x y @@;
cards;
A 11 6 A 8 0 A 5 2 A 14 8 A 19 11 A 6 4 A 10 13 A 6 1 A 11 8 A 3 0
B 6 0 B 6 2 B 7 3 B 8 1 B 18 18 B 8 4 B 19 14 B 8 9 B 5 1 B 15 9
C 16 13 C 13 10 C 11 18 C 9 5 C 21 23 C 16 12 C 12 5 C 12 16 C 7 1 C 12 20
;
PROC GLM data=na ;
CLASS trt;
MODEL y=trt x /SOLUTION; 
LSMEANS trt/TDIFF;
RUN;

DATA sale;
input type x y @@;
cards;
1 38 21 1 39 26 1 36 22 1 45 28 1 33 19
2 43 34 2 38 26 2 38 29 2 27 18 2 34 25
3 24 23 3 32 29 3 31 30 3 21 16 3 28 29
;
PROC GLM data=sale ;
CLASS type;
MODEL y=type x /SOLUTION; 
LSMEANS type/TDIFF;
RUN;
