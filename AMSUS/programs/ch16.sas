/* Chapter 16 */

data HPA;
 infile 'c:\AMSUS\data\hpa.dat';
 input staining weeks censor;
run;

proc phreg data=HPA ;
  model weeks*censor(1)=staining / rl;
run;

data GBSG2;
 infile 'c:\amsus\data\GBSG2.dat' expandtabs;
 input id onhorm $ age menstat $ tsize tgrade $ pnodes progrec estrec time status;
 horm=onhorm='yes';
 mnths=time/30.5;
run;


proc phreg data=GBSG2;
  class  menstat tgrade;
  model mnths*status(0)=horm age menstat tsize tgrade pnodes estrec / rl ;
run;

proc phreg data=GBSG2;
  class  menstat tgrade;
  model mnths*status(0)=horm age menstat tsize tgrade pnodes estrec / rl selection=b;
run;

data covs;
  retain horm 0 tgrade 'III' pnodes 0;
run;
proc phreg data=GBSG2;
  class  tgrade;
  model mnths*status(0)=horm tgrade pnodes  / rl ;
  baseline covariates=covs out=phout survival=surv cumhaz=cumhaz;
run;
data phout;
 set phout;
 lch=lag(cumhaz);
 hazd=cumhaz-lch;
run;
proc print noobs;
 var mnths hazd surv cumhaz ;
 format mnths 4.1 hazd surv cumhaz  4.3;
run;

data covs;
  retain tgrade 'III' pnodes 0;
  horm=1; output; 
  horm=0;  output; 
run;

ods graphics on;
proc phreg data=GBSG2 plots(overlay)=s;
  class tgrade;
  model mnths*status(0)=horm tgrade pnodes / rl ;
  baseline covariates=covs ;
run;

proc phreg data=GBSG2;
  class tgrade;
  model mnths*status(0)=horm tgrade pnodes ;
  output out=phout logsurv=ls ; 
run;
data phout;
  set phout;
  rcs=ls*-1;
run;
proc phreg data=phout noprint;
  class tgrade;
  model rcs*status(0)=horm tgrade pnodes;
  output out=phout2 survival=srcs / method=pl;
run;
data phout2;
  set phout2;
  llsrcs=log(-1*log(srcs));
  lrcs=log(rcs);
run;
proc sgplot data=phout2;
 reg  y=llsrcs x=lrcs;
 refline 0 ;
 refline 0 / axis=x;
run;

proc phreg data=GBSG2;
  class tgrade;
  model mnths*status(0)=horm tgrade pnodes  / rl ;
  output out=phout logsurv=ls resdev=dres resch=sres; 
run;

proc sgscatter data=phout;
  plot dres*(pnodes horm tgrade)/ columns=2;
run;

proc sgscatter data=phout;
  plot sres*(pnodes horm tgrade)/ columns=2;
run;


ods graphics on;
proc phreg data=GBSG2;
  class tgrade ;
  model mnths*status(0)=horm tgrade pnodes / rl ;
  assess ph / resample;
run;

ods graphics off;
proc phreg data=GBSG2;
  class tgrade ;
  model mnths*status(0)=horm pnodes / rl ;
  strata tgrade;
run;

data SHTD;
infile 'c:\AMSUS\data\shtd.dat';
input ID Start Stop Event Age Year Surgery Transplant;
duration=stop-start;
run;

proc phreg data=SHTD;
  model (start,stop)*event(0)=Transplant / rl;
run;

proc phreg data=SHTD;
  model (start,stop)*event(0)=Age Year Surgery Transplant / rl;
run;

proc phreg data=SHTD;
  model (start,stop)*event(0)=Age Year Surgery Transplant year*transplant / rl;
run;

proc phreg data=SHTD;
  model (start,stop)*event(0)=Age Year Surgery  / rl;
  strata transplant;
run;

ods graphics on;
proc phreg data=SHTD plots(cl overlay=stratum)=s;
  model (start,stop)*event(0)=Age Year Surgery  / rl;
  strata transplant;
run;

data leukemia2;
  infile 'c:\amsus\data\leukemiapairs.dat';
  input time status treatment pair;
run;

proc phreg data=leukemia2;
 model time*status(0)=treatment / rl;
run;

proc phreg data=leukemia2 covs(aggregate);
 model time*status(0)=treatment / rl;
 id pair;
run;

data catheters;
  infile 'c:\amsus\data\CatheterInfection.dat';
  input Subject Time Status Age Sex Disease; 
  t=mod(_n_,2);
run;

proc phreg data=catheters covs(aggregate);
 class disease sex /ref=first;
 model time*status(0)=age sex disease / rl;
 id subject;
run;

proc phreg data=catheters ;
 class subject disease sex /ref=first;
 model time*status(0)=age sex disease / rl;
 random subject;
run;

