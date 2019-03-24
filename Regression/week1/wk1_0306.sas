DATA distance;
miles = 26.22;
kilometer = 1.61 * miles;
PROC PRINT DATA = distance;
run;

libname reg "C:/Users/Kim Yuum/Desktop/19-1 통계/회귀분석및실습/Regression/";  *reg라는 이름으로 작업환경의 경로를 설정;
options validvarname = any; *한글 변수를 사용할 수 있게 하는 옵션;

PROC contents data = distance; /*라이브러리.데이터이름 --> work라이브러리는 쓸 필요 없음!*/
RUN;

DATA one;
input ph Time Temperature;
cards;
4.5 20 125
4.1 22 133
2.8 18 149
4.0 26 120
5.0 25 120
6.0 21 138
;
run;
proc print data = one;
run;

proc import datafile = "C:/Users/Kim Yuum/Desktop/19-1 통계/회귀분석및실습/Regression/iris.xlsx" dbms = xlsx replace
out  = reg.iris_dat; *원하는 라이브러리에 저장;
getnames = yes;
run;



