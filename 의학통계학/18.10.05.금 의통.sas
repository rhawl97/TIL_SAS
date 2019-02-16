/*****3��*****/
DATA test;
INPUT drug $ mi $ count;
CARDS;
1 1 73
1 2 18
2 1 141
2 2 196
;
proc freq ; 
tables drug*mi / measures;  *�๰������ ��������� ���δ� //�ŷڱ��� 1���� x , �����Ȯ��;
weight count;
run;

/*ī������ ���� : ���� 3-3 [ǥ 3.6] */
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
TABLE treat*mi/CHISQ ;  *ī������ ���� �ɼ�;
RUN;  *ī������,pvalueȮ�� -- �͹����� �Ⱒ pvalue �ſ�����;

/*�Ǽ��� ��Ȯ������ : ���� 3-4 [ǥ3.10]*/
/**ī������ ������ ��뵵���� 5�̸��� ĭ�� ��ü 20%�ʰ��� �� ����� �� ������ ���� -- �Ǽ�**/
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
 table treat*rep/exact; *�Ǽ� �ɼ�;
 run;  *��� : 0.26�̶�� pvalue ����ؾ���;

/*�ƴϸ� ���� : ���� 3-5 [ǥ 3.14] */
DATA marriage;   *������ ����� ó��; *�͹����� : H0 : p1 =p2 ;
INPUT before $ after $ count @@; *@@ : �����͸� ������ �о�鿩��;
CARDS;
satisfy satisfy 23
satisfy unsatisfy 7
unsatisfy satisfy 18
unsatisfy unsatisfy 12
;

ODS SELECT McNemarsTest;  *�ƴϸ������� �������;
PROC FREQ order=data;  *�Է������� ������� ����϶�;
WEIGHT count;
TABLES before*after/AGREE; *�ƴϸ� �ɼ�;
RUN;  *pvalue0.0278 < ���Ǽ���0.05 �̹Ƿ� ������ ���̰� �ִ�;


/*��ũ��-����-���� ���� : ���� 3-6 [ǥ 3.18] */
DATA hospital; *4���� ������ ���� ��ǥ; 
INPUT hospital $ trt $ recovery $ count @@;  *�͹����� : H0 : p1 =p2 ;
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
WEIGHT count;  *CMH : ��ũ�� ���� �ɼ�;
TABLES hospital*trt*recovery/CMH NOROW NOCOL; *hospital�� �� �տ� �;� '������ ����' trt �� recovery�� ��ǥ ��� -- ���� �߿�!; 
RUN;  *pvalue 0.0445 < ���Ǽ��� 0.05�̹Ƿ� ġ������ ȣ������ ������ �������� �ִ�. ������ �������� �������� ��!;

/*hospital�� �������� �������� �ʾ��� ��*/
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
run; *ī������ ��跮 Ȯ��, pvalue > 0.05 �̹Ƿ� �͹����� �Ⱒ x -- ġ������ ȣ���� ���̿� ������ �������� ����;

/*****4��*****/
data liver;
infile "C:\Users\���37\Desktop\liver.txt"  dlm ='09'x; *�����ڰ� ������ dlm���� ǥ��. space�� ��� ' ', comma ',';
input trt $ remission y;
run;
*�����м�;
PROC LOGISTIC data=liver DESCENDING; *y=1: ���Ȯ�� �� �������� ������ �ҷ�����;
CLASS trt; *������ ������ trt�̴� ����;
MODEL y=trt remission/SCALE=NONE AGGREGATE;  *Ȩ�� ���� ����;
RUN; 
*���!
response profile ����� ��� 53��, y=1�� ���� �����Ǿ���. design variables ��ȣ �ٲ�. pvalue > 0.05 �̸� ������ ���̴�(�ݴ���)
Analysis of Maximum Likelihood Estimates �߿�!! wald ������跮 ,trt :  pvalue <0.05 �͹����� �Ⱒ -- trt�� ������ �����̴�. 
���� ���� : ln px/(1-px) = 2.04 - 0.59*trt - 0.20*remission ___trt�� A = 1 B = -1
Odds Ratio Estimates : trt ����� 0.308 remission ����� 0.819
ó��A�� ���� ����� ���Ȯ���� ó��B�� ���� ����� 30.8%�̴�.
ó��A�� ��������, �� ȣ���Ⱓ�ϼ��� ���Ȯ�� ������*/

/**��� �׷��� �׸���**/
ods graphics on;
PROC LOGISTIC data=liver  DESCENDING plots(only)=(effect);;
CLASS trt;
MODEL y=trt remission/SCALE=NONE AGGREGATE;  *ȣ���Ⱓ ��������� probability ������, A�Ķ��� < B������ -- A�������� Ȯ�� ������;
output out=pdata  predicted = pred_prob;  *����� pdata�� ����_pdata�� ���� �ϳ� �߰�;
RUN;

/*  ���ο� ����ġ�� ���� Ȯ���� ���� 
���࿡ ���� ���� �м��� ������ �� ���ο� ȯ�ڰ� ��Ÿ���� A ġ�Ḧ �ް�(trt=A) ȣ���Ⱓ�� 13�� �̶�� (remission=12)
��� Ȯ���� �󸶷� �����ϰڴ°�?*/
DATA new; 
INPUT trt $ remission ; *���ο� ����ġ ������ ����;
CARDS;
A   13
B  7
;
run;
PROC LOGISTIC DESCENDING data=liver  outmodel=predmodel noprint   ;  *���� �� outmodel�ɼ����� ����;
CLASS trt;
MODEL y=trt remission/SCALE=NONE AGGREGATE;
RUN;

PROC LOGISTIC inmodel=predmodel  ;  *predmodel�� ����ض�;
    score data=new out=newprob;  *score��� �ɼ����� new ��� ������ �߰� , ����� newprob���� ����;
RUN;

proc print data=newprob; run;  
*1�� ��� ������� ���� ���̴� WHY? ���Ȯ���� 24��, ��߾���Ȯ���� 75���̱� ����_���� ���� 50��
  2�� ��� ����� ���̴�.;

/*���� �м� : ���� 4-2 [ǥ 4.9]*/
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
*���!
Probability modeled is outcome='cured'. : ����Ʈ ascending�̱� ����
Deviance and Pearson Goodness-of-Fit Statistics >0.05 �̹Ƿ� �� �����ϴ�
Analysis of Maximum Likelihood Estimates ���� �������� �����
Odds Ratio Estimates ���� ����� ���ϱ�
;
