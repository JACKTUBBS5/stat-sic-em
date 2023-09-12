
/* Chapter 17 */

data ghq;
  input ghq sex $ cases noncases;
  total=cases+noncases;
  prcase=cases/total;
  female=sex='F';
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


data priors;
 input _type_ $ intercept female ghq;
datalines;
Mean 0 0 0
Var 1 .25 .25
;
ods graphics on;
proc genmod data=ghq;
  model cases/total=female ghq /dist=b link=logit;
  bayes seed=12345 cprior=normal(input=priors);
run;
ods graphics off;

data priors;
 input _type_ $ intercept female ghq;
datalines;
Mean 0 0 0
Var 1 .5 .5
;
ods graphics on;
proc genmod data=ghq;
  model cases/total=female ghq /dist=b link=logit;
  bayes seed=12345 cprior=normal(input=priors);
run;
ods graphics off;

data paeds;
input hospital $ operations deaths;
id=_n_;
datalines;
A  47  0
B 148 18
C 119  8
D 810 46
E 211  8
F 196 13
G 148  9
H 215 31
I 207 14
J  97  8
K 256 29
L 360 24
;

proc mcmc data=paeds seed=123 nbi=1000 nmc=10000 stats(percent=2.5 97.5);
 array pr[12];
 parms pr1-pr12;
 prior pr1-pr12 ~ beta(1,1);
 model deaths~binomial(operations,pr[id]);
ods output postsummaries=fixsum geweke=fgew;
run;

proc mcmc data=paeds seed=123 nbi=2000 nmc=20000 stats(percent=2.5 97.5);
 array pr[12];
 parms pr1-pr12;
 prior pr1-pr12 ~ beta(1,1);
 model deaths~binomial(operations,pr[id]);
ods output postsummaries=fixsum geweke=fgew;
run;

proc mcmc data=paeds seed=123 nbi=2000 nmc=20000 monitor=(pr) stats(percent=2.5 97.5);
  array pr[12];
  parms mu sigma;
  prior mu ~normal(0,v=100000);
  prior sigma~gamma(.001,is=.001);
  random bi ~ normal(mu,sd=sigma) subject=id; 
  pi=logistic(bi);
  model deaths~binomial(operations,p=pi);
  pr[id] = pi;
ods output postsummaries=randsum geweke=rgew;
run;

data results;
  set fixsum(in=in1) randsum;
  set fgew rgew;
 if in1 then Model='Fixed ';
    else  Model='Random';
  mn=mean;
run;

proc tabulate data=results order=data f=8.3;
  class parameter model;
  var mn p25 p975 zscore pvalue;
  table parameter,
        model*((mn p25 p975 zscore )*sum='' pvalue*sum=''*f=pvalue6.3);
  label pvalue='p';
run;

data sumstats;
 set fixsum (rename=(mean=fmean p2_5=fp2_5 p97_5=fp97_5));
 set randsum(rename=(mean=rmean p2_5=rp2_5 p97_5=rp97_5));
 set paeds;
run;
proc sort data=sumstats out=sumstats;
  by fmean;
run;
data sumstats;
  set sumstats;
  fy=_n_;
  ry=fy-.3;
  x0=-.01;
run;
proc sgplot data=sumstats noautolegend;
  scatter x=fmean y=fy / markerattrs=(symbol=circlefilled); 
  scatter x=rmean y=ry / markerattrs=(symbol=circle);
  highlow y=fy high=fp97_5 low=fp2_5 / lineattrs=(pattern=solid);
  highlow y=ry high=rp97_5 low=rp2_5;
  scatter x=x0 y=fy /  markerchar=hospital;
  refline .073 / axis=x ;
  yaxis display=(noticks novalues) label='Hospital';
  xaxis label='Proportion of deaths';
run;



*  rank plots ;
proc mcmc data=paeds seed=123 nbi=2000 nmc=20000 stats(percent=2.5 97.5) outpost=randout;
  parms mu sigma;
  prior mu ~normal(0,v=100000);
  prior sigma~gamma(.001,is=.001);
 random bi ~ normal(mu,sd=sigma) subject=id monitor=(bi);
 model deaths~binomial(operations,p=logistic(bi));
run;
proc transpose data=randout out=trand;
 var bi_1-bi_12;
 by iteration;
run;
proc rank data=trand out=ranks;
var col1;
ranks rank;
by iteration;
run;
proc sgpanel data=ranks;
  panelby _name_ /columns=2 rows=6 novarname spacing=10;
  histogram rank ;
  colaxis label='rank order' integer;
run;






