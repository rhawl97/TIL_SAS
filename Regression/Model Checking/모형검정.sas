PROC SGPLOT data = tmp1.infludata; *�̻�ġ Ȯ�� -> ��� �ذ��ұ�!;
scatter X = x Y = y;
RUN; QUIT;

PROC REG data = tmp1.infludata2 outest = est1; *infludata2�� infludata1�� index�ο��� ������;
model y = x / OUTSEB noprint;
PROC PRINT data = est1;  
RUN; QUIT;

PROC REG data = tmp1.infludata2 outest = est1; 
model y = x / OUTSEB noprint;
where index ^= 1; *index = 1�� �ƴ� �͸� ����; 

PROC PRINT data = est1;  *intercept ���, ����;
RUN; QUIT;

PROC REG data = tmp1.infludata2 outest = est1; *intercept�� �ö󰡰� ����� ������;
model y = x / OUTSEB noprint;
where index ^= 2; *index = 2�� �ƴ� �͸� ����; 

PROC PRINT data = est1; 
RUN; QUIT;

PROC REG data = tmp1.infludata2 outest = est1; 
model y = x / OUTSEB noprint;
where index not in (10, 11); *index = 10, 11�� �ƴ� �͸� ����; 

PROC PRINT data = est1;  *intercept ���, ����;
RUN; QUIT;
*model1 seb  -> ������ standard error ����� standard error; 

*���� - 1) ǥ��ȭ���� / 2) ǥ��ȭ��������  
1) �̻�ġ�� ��� ���� �и� ������ �ƴϹǷ� ������ �̻�ġ�� �־ �۾����� ����.
2) i��° ������ ����� �� i��° �����͸� �����ϰ� ����ϹǷ� �̻�ġ ���� �� ����. 
2)ǥ��ȭ��������  > 2.5�� ��� �������� �ſ� ���� �κ��̹Ƿ� ���� �������� �ʴ� �̻�ġ��� ���ڴ�. ;

/* Cook's D: ����ġ�� ���� / ����ġ�� �л�, p+1 --> ��跮 �ǹ� �ؼ��ϱ�
  DFBETA: ����ġ ��ü�� �� �� (j��° beta�� i��° �����Ͱ� �󸶳� ������ ��ġ�°�) */


/*����� ����ġ �ĺ�*/
PROC REG data = tmp1.usedcar;
model price = year -- automatic / r influence; *r: residual �� influence: cookd dffit��; *Rstudent: i��° ������ ������ ���� ���� 2.5; *cookd:�����ü�� ���� ����; 
*covratio: ����� �л�(test�� ������ �ִ�) difffits: yhat(�����Ȱ�)���� ����� dfbetas: ������ ������ ���� �����;
RUN; QUIT;
