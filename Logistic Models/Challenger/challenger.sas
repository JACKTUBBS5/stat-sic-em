libname LDATA '/home/jacktubbs/my_shared_file_links/jacktubbs/myfolders/SAS Data Sets/';
options center nodate pagesize=100 ls=80;

/* Simplified LaTeX output that uses plain LaTeX tables  *
ods latex path='/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Output'
 file='challenger.tex' style=journal 
stylesheet="sas.sty"(url="sas");

/*
http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 
*
ods graphics / reset width=5in  outputfmt=png
  antialias=on;
  
  */

title "NASA Space Shuttle Failed Launches";
data Challenger;
  input temp td no_td;
  total=td+no_td;
  label temp = "Atmospheric Temperature"
        td = "failed attempts"
        no_td = "successful attempts"
        total = "number of attempts";
 datalines;
 53 1 0
 57 1 0
 58 1 0
 63 1 0
 66 0 1
 67 0 3
 68 0 1
 69 0 1
 70 2 2
 72 0 1
 73 0 1
 75 1 1
 76 0 2
 78 0 1
 79 0 1
 81 0 1
 ;
 title2 'Challenger Data';
title3 "Temperature Statistics at Launch";
proc means data=challenger; var temp; run;
title3 'Observed Percent Failure by Temperature';
data a;set challenger;percent=td/total;
proc sgplot data=a; scatter x=temp y=percent;run;

title3 'Linear Regression - Identity Link';
proc glm data=a; 
  model percent=temp/ solution;run;


title3 'Logistic Regression - LOGIT Link';
proc logistic data=challenger plots=effect;
  model td/total=temp/ link=logit expb;run;
 
title3 'Logistic Regression - CLOGLOG Link';
proc logistic data=challenger plots=effect;
  model td/total=temp/ link=cloglog ;run;
 
/*
 
title3 'Logistic Regression (GENMOD) - LOGIT Link'; 
proc genmod data=Challenger plots=predicted(clm) ;

 model td/total=temp/dist=binomial link=logit type1;
 estimate 'logit at 53 deg' intercept 1 temp 53;
  estimate 'logit at 57 deg' intercept 1 temp 57;
 estimate 'logit at 58 deg' intercept 1 temp 58;
 estimate 'logit at 63 deg' intercept 1 temp 63;
 estimate 'logit at 67 deg' intercept 1 temp 67;
 estimate 'logit at 68 deg' intercept 1 temp 68;
  estimate 'logit at 69 deg' intercept 1 temp 69;
 estimate 'logit at 70 deg' intercept 1 temp 70;
  estimate 'logit at 72 deg' intercept 1 temp 72;
  estimate 'logit at 75 deg' intercept 1 temp 75;
estimate 'logit at 76 deg' intercept 1 temp 76;
   estimate 'logit at 78 deg' intercept 1 temp 78;
    estimate 'logit at 79 deg' intercept 1 temp 79;
 estimate 'logit at 80 deg' intercept 1 temp 80;
 ods output estimates=logit;
 run;
 
 
 title3 'Logistic Regression (GENMOD) - CLOGLOG Link';
 proc genmod data=Challenger plots=predicted(clm);

 model td/total=temp/dist=binomial link=cloglog type1;
 estimate 'logit at 53 deg' intercept 1 temp 53;
  estimate 'logit at 57 deg' intercept 1 temp 57;
 estimate 'logit at 58 deg' intercept 1 temp 58;
 estimate 'logit at 63 deg' intercept 1 temp 63;
 estimate 'logit at 67 deg' intercept 1 temp 67;
 estimate 'logit at 68 deg' intercept 1 temp 68;
  estimate 'logit at 69 deg' intercept 1 temp 69;
 estimate 'logit at 70 deg' intercept 1 temp 70;
  estimate 'logit at 72 deg' intercept 1 temp 72;
  estimate 'logit at 75 deg' intercept 1 temp 75;
estimate 'logit at 76 deg' intercept 1 temp 76;
   estimate 'logit at 78 deg' intercept 1 temp 78;
    estimate 'logit at 79 deg' intercept 1 temp 79;
 estimate 'logit at 80 deg' intercept 1 temp 80;
 ods output estimates=logit;
 run;
 
 
 /* following creates Output 10.4  */
/*
data prob_hat;
 set logit;
  phat=exp(Meanestimate)/(1+exp(Meanestimate));
  se_phat=phat*(1-phat)*stderr;
  prb_LcL=exp(MeanLowerCL)/(1+exp(MeanLowerCL));
  prb_UcL=exp(MeanUpperCL)/(1+exp(MeanUpperCL));
 run; 

 proc print data=prob_hat;
 run;
/* 
data b;set prob_hat;obs=_N_;run; 
data c;set a;obs=_N_;run; 
data d;merge c b;by obs;run;
proc gplot data=D;plot percent*temp=1 phat*temp=2
prb_LcL*temp=3 prb_UcL*temp=3/

overlay frame vaxis=axis1 vminor=1;
symbol1 v=dot i=none c=blue h=2;
symbol2 v=none i=spline c=black w=5;
symbol3 v=none i=spline c=red l=33 r=2 w=3;
axis1 label=(a=90 'Estimated Failure probability') offset=(3);run;
quit;
/* Use the following DATA step to obtain Outputs 10.5 and 10.6                 */
/*
data O_Ring;
 input flt temp td;
datalines;
 1 66 0
 2 70 1
 3 69 0
 4 68 0
 5 67 0
 6 72 0
 7 73 0
 8 70 0
 9 57 1
10 63 1
11 70 1
12 78 0
13 67 0
14 53 1
15 67 0
16 75 0
17 70 0
18 81 0
19 76 0
20 79 0
21 75 1
22 76 0
23 58 1
;

proc freq;
 tables temp*td;
run;

proc genmod data=O_Ring;
 model td=temp  /dist=binomial link=logit type1;
 estimate 'logit at 50 deg' intercept 1 temp 50;
 estimate 'logit at 60 deg' intercept 1 temp 60;
 estimate 'logit at 64.7 deg' intercept 1 temp 64.7;
 estimate 'logit at 64.8 deg' intercept 1 temp 64.8;
 estimate 'logit at 70 deg' intercept 1 temp 70;
 estimate 'logit at 80 deg' intercept 1 temp 80;
 ods output estimates=logit;
run;

/* following not shown in text, but similar to Output 10.4   */
/*
data prob_hat;
 set logit;
  phat=exp(estimate)/(1+exp(estimate));
  se_phat=phat*(1-phat)*stderr;
  prb_LcL=exp(LowerCL)/(1+exp(LowerCL));
  prb_UcL=exp(UpperCL)/(1+exp(UpperCL));

 proc print data=prob_hat;
 run;
data b;set prob_hat;obs=_N_;run; 
data c;set a;obs=_N_;run; 
data d;merge c b;by obs;run;
proc gplot data=d;plot percent*temp=1 phat*temp=2
prb_LcL*temp=3 prb_UcL*temp=3/overlay;run;
quit;

/* Use the following SAS statements in conjuction with the DATA step used      */
/*    to create data set DATA=Challlenger (Output 10.1)                        */
/*    to obtain Outputs 10.7 and 10.8                                          */ 
/*
proc genmod data=Challenger;
 model td/total=temp/dist=binomial link=probit type1;
 estimate 'logit at 50 deg' intercept 1 temp 50;
 estimate 'logit at 60 deg' intercept 1 temp 60;
 estimate 'logit at 64.7 deg' intercept 1 temp 64.7;
 estimate 'logit at 64.8 deg' intercept 1 temp 64.8;
 estimate 'logit at 70 deg' intercept 1 temp 70;
 estimate 'logit at 80 deg' intercept 1 temp 80;
 ods output estimates=logit;
run;

/* following creates Output 10.8  */
/*
data prob_hat;
 set logit;
  phat=probnorm(estimate);
  pi=3.14159;
  invsqrt=1/(sqrt(2*pi));
  se_phat=invsqrt*exp(-0.5*(estimate**2))*stderr;
  prb_LcL=probnorm(LowerCL);
  prb_UcL=probnorm(UpperCL);
proc print data=prob_hat;
data b;set prob_hat;obs=_N_;run; 
data c;set a;obs=_N_;run; 
data d;merge c b;by obs;run;
proc gplot data=d;plot percent*temp=1 phat*temp=2
prb_LcL*temp=3 prb_UcL*temp=3/overlay;run;
quit;
run;
*/
 quit;
*ods graphics off;
*ods pdf close;
