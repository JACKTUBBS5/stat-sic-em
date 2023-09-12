/* Chapter 3 */

data cointoss;
call streaminit(12345);
do set=1 to 10;
do toss=1 to 100;
  result=rand('bernoulli',.5);
  output;
  end;
end;
run;

proc freq data=cointoss;
  tables set*result /norow nocol nopercent; 
run;

* Randomized blocks;
data blkdes;
 call streaminit(12345);
 do block=1 to 50;
   do unit=1 to 6;
   rndx=rand('uniform');
   if unit<4 then assignment='A';
             else assignment='B';
   output;
   end;
  end;
run;
proc sort data=blkdes ;
by block rndx;
run;
proc print data=blkdes(obs=12);
run;

proc plan seed=12345;
  factors block=50 ordered unit=6 random;
  output out=blkdes2 unit cvals=('A' 'A' 'A' 'B' 'B' 'B') random;
run;

proc print data=blkdes2(obs=12);
run;

* stratified ;
proc plan seed=12345;
  factors stratum=6 ordered block=10 ordered unit=4 random;
  output out=stdesign unit cvals=('A' 'A' 'B' 'B') random;
run;
proc print; run;

data stdesign;
  set stdesign;
  id=_n_;
run;


*minimization ;

libname db "c:\AMSUS\data";
ods output OneWayFreqs(persist)=marginals;
proc freq data=db.minimize; tables treat; where agegrp=1; run;
proc freq data=db.minimize; tables treat; where Lepi=2;   run;
proc freq data=db.minimize; tables treat; where sex=2;    run;
proc freq data=db.minimize; tables treat; where onmed=1;  run;
ods output close;

proc means data=marginals sum;
  class treat;
  var frequency;
run;

data _null_;
  rx=rand('bernoulli',.5);
  if rx=0 then put "allocation is to group A";
          else put "allocation is to group B";
run;
 
data newpt;
 input id agegrp Lepi sex onmed treat $; 
datalines;
61 1 2 2 1 B
;
data db.minimize;
 set db.minimize newpt;
run;


proc power;
  twosamplemeans
    meandiff=1 
    stddev=4
    power=.9 
    npergroup=.;
run;

proc power;
  twosamplemeans
    groupmeans=0 | 2 
    groupstddevs=8 | 12
    test=diff_satt
    power=.8
    npergroup=.;
run;


data folates;
 do group=1 to 3;
  input rfl 4. @;
  if rfl~=. then output;
 end;
datalines;
243 206 241
251 210 258
275 226 270
291 249 293
347 255 328
354 273 
380 285 
392 295 
    309 
;

proc sgplot data=folates;
  vbox rfl / category=group;
run;

ods graphics off;
proc ttest data=folates;
  class group;
  var rfl;
where group in(1 2);
run;

proc ttest data=folates;
  class group;
  var rfl;
where group in(1 3);
run;

proc ttest data=folates;
  class group;
  var rfl;
where group in(2 3);
run;

data nausea;
 do treatment='A', 'B';
 input nausea @;
 output;
 end;
datalines;
0   0
0   10
0   12
0   15
0   15
2   30
7   35
8   38
10  42
13  45
15  50
18  50
20  60
20  64
21  68
22  71
25  74
30  82
52  86
76  95
;

ods graphics on;
proc ttest data=nausea;
  class treatment;
  var nausea;
run;

proc npar1way data=nausea wilcoxon;
  class treatment;
  var nausea;
run;

data captopril;
  do treatment='Captopril', 'Placebo';
  input id basebp week1bp @; 
  if id~=. then output;
  end;
datalines;
1 147 137 1 133 139
2 129 120 2 129 134
3 158 141 3 152 136
4 164 137 4 161 151
5 134 140 5 154 147
6 155 144 6 141 137
7 151 134 7 156 149
8 141 123 . .   .   
9 153 142 . .   .    
;

proc sort data=captopril;
 by treatment;
run;
proc ttest data=captopril ;
 paired basebp*week1bp;
 by treatment;
run;

data captopril;
  set captopril;
  bpdiff=basebp-week1bp;
run;

proc ttest data=captopril;
  class treatment;
  var bpdiff;
run;


