PROC IMPORT datafile= "C:\Users\Kim Yuum\Desktop\19-1 통계\회귀분석및실습\Regression\0515\data/expdata.csv" dbms= csv
out = expdata;
getnames = yes;
run; quit;

proc sgscatter data = expdata;  *그냥sgplot scatter는 x y하나씩만!;
matrix y--x2;  *y x1 x2; /*산점도를 통해 회귀계수 양일지 음일지 판단 가능*/
run; quit;

proc reg data = expdata; *하나씩 넣는거 말고 다중회귀가 맞음;
m1: model y = x1;
m2: model y = x2;
m3: model y = x1 x2; *둘을 함께 넣으면 음의 계수도 나옴 -> 설명변수 모두를 같이 봐야된다!;
run; quit;

PROC IMPORT datafile= "C:\Users\Kim Yuum\Desktop\19-1 통계\회귀분석및실습\Regression\0515\data/usedcars.csv" dbms= csv
out = usedcar;
getnames = yes;
run; quit;

proc sgscatter data = usedcar;
matrix price -- automatic/diagonal = (kernel histogram);
run; quit;

proc reg data = usedcar; *adj r-squre 보기;
model price = year -- automatic;
run; quit;
