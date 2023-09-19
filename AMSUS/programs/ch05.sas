/* Chapter 5 */

data quitting;
 length study $14.;
infile 'c:\AMSUS\data\quitting.txt';
input study qt tt qc tc;
run;

proc print data=quitting noobs; run;

data quitting;
 set quitting;
 nqt=tt-qt;
 nqc=tc-qc;
 lor=log((qt/nqt)/(qc/nqc));
 selor=sqrt(1/qt+1/nqt+1/qc+1/nqc);
 wgt=1/selor**2;
 ss=tt+tc;
run;

proc means data=quitting;
 var lor;
 weight wgt;
 output out=mout mean=mes sumwgt=sumwgt css=Q n=k;
run;
proc means data=quitting;
 var wgt;
 output out=mout2 uss=ssqwgt;
run;
data mout;
  merge mout mout2;
  u=(sumwgt-ssqwgt/sumwgt);
  tau2=max(0,(q-k+1)/u);
run;
data quitting;
  set quitting;
  if _n_=1 then set mout(keep=tau2);
  DSL_wgt=1/(1/wgt + tau2);
run;
proc means data=quitting;
 var lor;
 weight DSL_wgt;
 output out=mout3 mean=mes sumwgt=sumwgt;
run;
data MA_summary;
  set mout(in=inf) mout3;
  if inf then type='Fixed ';
         else type='Random';
  sem=sqrt(1/sumwgt);
  Z=mes/sem;
  cil=mes-1.96*sem;
  ciu=mes+1.96*sem;
  ProbZ  = (1-probnorm(abs(z)))*2 ;
  ProbQ  = 1-probchi(q,k-1) ;
run;
proc print noobs; 
 var type mes sem cil ciu z probz q probq;
 format probz probq pvalue6.4;
run;


%inc "C:\AMSUS\macros\MA_summary.sas";
%MA_summary(data=quitting,es=lor,wgt=wgt)

proc sgplot data=quitting;
  scatter y=wgt x=lor;
  refline 0  /axis=x lineattrs=(pattern=dash);
  refline .56 /axis=x;
  xaxis label="log(OR)"values=(-1 to 2);
  yaxis label="1/Var(Log(OR))";
run;

* a basic forest plot could be constructed as follows;
data quitting;
  set quitting nobs=nobs;
  yv=nobs-_n_+3;
  xlab=3;
  cil=lor-1.96*selor;
  ciu=lor+1.96*selor;
run;
data summary;
  retain id 1 study 'Summary' lor .56 cil .39 ciu .73;
run;
data fplot;
  set quitting summary;
run;
proc sgplot data=fplot noautolegend ;
  scatter y=yv x=lor / markerattrs=(symbol=squarefilled);
  scatter y=yv x=xlab / markerchar=study;
  vector y=yv x=ciu / xorigin=cil yorigin=yv noarrowheads  lineattrs=(pattern=solid);
  refline 0  /axis=x lineattrs=(pattern=dash);
  refline .56 /axis=x;
run;
******************************************;

%inc "C:\AMSUS\macros\forest.sas";
%forest(data=quitting,es=lor,se=selor,type=random)

data catheters;
  infile 'c:\amsus\data\catheters.dat';
  input study y1 n1 y0 n0 ;
  if y1=0 then do;
                  y1=.5;
                  n1=n1+.5;
                  end;
  if y0=0 then do;
                  y0=.5;
                  n0=n0+.5;
                  end;
 lor=log((y1/(n1-y1))/(y0/(n0-y0)));
 selor=sqrt(1/y1 + 1/(n1-y1) + 1/y0 + 1/(n0-y0));
 wgt=1/selor**2;
run;

%inc "C:\AMSUS\macros\MA_summary.sas";
%MA_summary(data=catheters,es=lor,wgt=wgt)

data bcg;
 infile 'c:\AMSUS\data\bcg.dat';
 input study BCGTB BCGnoTB noBCGTB noBCGnoTB Latitude Year;
 lor=log((BCGTB/BCGnoTB)/(noBCGTB/noBCGnoTB));
 se=sqrt(1/BCGTB+1/BCGnoTB+1/noBCGTB+1/noBCGnoTB);
 wgt=1/se**2;
run;

%MA_summary(data=bcg,es=lor,wgt=wgt)

proc reg data=bcg;
 model lor=latitude year;
 weight dsl_wgt;
run;

proc sgplot data=bcg noautolegend;
   bubble y=lor x=latitude size=wgt ;
   reg y=lor x=latitude /nomarkers weight=wgt;
   label lor="log(OR)";
run;

