/* Chapter 9 */

data ghq;
  input ghq sex $ cases noncases;
  total=cases+noncases;
  prcase=cases/total;
cards;
0       F       4       80
1       F       4       29
2       F       8       15
3       F       6       3
4       F       4       2
5       F       6       1
6       F       3       1
7       F       2       0
8       F       3       0
9       F       2       0
10      F       1       0
0       M       1       36
1       M       2       25
2       M       2       8
3       M       1       4
4       M       3       1
5       M       3       1
6       M       2       1
7       M       4       2
8       M       3       1
9       M       2       0
10      M       2       0
;

proc sgplot data=ghq;
  series y=prcase x=ghq / group=sex;
  scatter y=prcase x=ghq / group=sex;
run;

proc reg data=ghq;
  model prcase=ghq;
  output out=rout p=rpred;
run;

ods rtf select GlobalTests ParameterEstimates OddsRatios ;
proc logistic data=ghq;
   model cases/total=ghq;
   output out=lout p=lpred;
run;

data lrout;
  set rout;
  set lout;
run;
proc sort data=lrout;
  by ghq;
run;

proc sgplot data=lrout;
  series y=lpred  x=ghq / legendlabel='logistic' lineatts=(pattern=dash);
  series y=rpred  x=ghq   / legendlabel='linear';
  scatter y=prcase x=ghq ;
run;

proc logistic data=ghq;
  class sex /param=ref ref=first;
  model cases/total=sex ;
run;

data ghq2;
 set ghq;
 num=cases;    case=1; output;
 num=noncases; case=0; output;
run;

proc freq data=ghq2;
 tables sex*case / relrisk nopercent norow nocol;
 weight num;
run;

ods graphics on;
proc logistic data=ghq plots=effect(showobs=yes);
  class sex /param=ref ref=first;
  model cases/total=sex ghq sex*ghq / selection=b details; 
run;

data lowbwt;
  infile 'c:\AMSUS\data\lowbwt.dat';
  input id low age lwt race ftv;
run;

proc logistic data=lowbwt desc;
  class race / param=ref ref=first;
  model low=age lwt race ftv;
run;

proc logistic data=lowbwt desc;
  class race / param=ref ref=first;
  model low=age lwt race ftv / selection=b;
run;

proc logistic data=lowbwt desc;
  class race / param=ref ref=first;
  model low=lwt;
  output out=lout p=pred resdev=dres ;
run;

proc sgscatter data=lout;
  plot dres*(id pred lwt) ;
run;

data endoca1;
  input est num;
  resp=1;
cards;
-1 7
 1 43
 0 133
;

proc logistic data=endoca1;
  model resp=est /noint  ;
  freq num;
run;

data lowbwt11;
  infile 'c:\AMSUS\data\lowbwt11.dat';
  input pair LoW Age LWT Smoke PTD HT UI;
run;

proc logistic data=lowbwt11 desc;
 strata pair;
 model low=LWT Smoke PTD HT UI;
run;
 

