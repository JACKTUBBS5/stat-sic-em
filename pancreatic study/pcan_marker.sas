libname ldata  '/home/jacktubbs/my_shared_file_links/jacktubbs/myfolders/Disease/pancreatic cancer' ;
options nodate center nonumber ps=200 ls=80 formdlim=' ';
title 'Biomarkers for Pancreatic Cancer';
title2 'creatinine';
/*
data ldata.pancreatic; set work.import; run;
*/
proc contents data=ldata.pancreatic varnum; run;

data pan_cancer; set ldata.pancreatic;
drop benign_sample_diagnosis sample_origin stage;
l_plasma_CA19_9 = log(plasma_CA19_9); 
l_LYVE1 = log(LYVE1);
l_REG1B = log(REG1B);
l_TFF1 = log(TFF1);
l_REG1A = log(REG1A);
run;
proc print data=pan_cancer (obs=10); run;

proc sgplot data=pan_cancer;
vbar diagnosis;
run;
/*
proc sgplot data=pan_cancer;
histogram creatinine /group = diagnosis;
density creatinine /group = diagnosis;
run;
*/

data pcan_marker; set pan_cancer;
marker = creatinine;
keep age sex diagnosis marker;
run;

proc sgplot data=pan_marker;
histogram marker /group = diagnosis;
density marker /group = diagnosis;
run;

title3 'Test Biomarker versus Control';
data borrow ; set pcan_marker;
label
 	diagnosis = '1 Control 2 chronic 3 cancer';
if diagnosis = 1 then LA=0;
if diagnosis = 3 then LA=1;	
if LA ne '.';	
run;


proc means data=borrow q1 q3 median mean std n; 
var marker; 
run;

proc sort data=borrow; by LA; run;

proc means data=borrow q1 q3 median mean std n; by LA;
var marker; 
run;

proc univariate data=borrow noprint;
  class LA;
  histogram marker/ nobars normal(noprint);
  ods output histogram=hist;
run;
data hist; set hist; lower=0; run;
proc sgplot data=hist;
  series x=CurveX y=CurveY/group=class1;
  band x=CurveX lower=lower upper=CurveY/group=class1 transparency=.5;
run;

title4 'Frequentist AUC';
proc logistic data=borrow plots(only)=roc;
   model LA(event='1') = marker ;
 *  ROC ODI;
   ods select  Association ROCcurve OddsRatios;
run;

data binorm; set borrow;
*y=ldl;
y=marker;
  run;

title4 'Placement Value Method with Beta Distribution';
proc lifereg data=binorm plots=probplot; where LA=0;
   model y = / d=weibull;
   ods select ParameterEstimates; 
*   output out=tempa  xbeta=xbeta cres=cres cdf=cdf;* censored=censored;
*      probplot
*      ppout;
*     inset;
   run;
proc lifereg data=binorm noprint  plots=probplot; where LA=0;
   model y = / d=weibull;
   output out=tempa  xbeta=xbeta cres=cres cdf=cdf;* censored=censored;
      probplot
      ppout;
      inset;
   run;
 
data tempb; set tempa; surv=exp(-1*cres); cdf2=1-surv; 
            keep  LA y  surv cdf; run; 

proc sort data=tempb; by LA; run;
proc sort data=binorm; by LA; run;

data temp3; merge tempb binorm; by LA;  keep   y  LA  surv; run;
proc sort data=temp3; by y; run;


proc iml;
 
    use temp3; 
    read all into tc;
    LA=tc[,1];
    y = tc[,2];
    surv = tc[,3];
    n    = nrow(tc);
    la[1]=0;surv[1]=1;
    do j = 2 to n;
    if LA[j]=1 then surv[j]=surv[j-1];
    end;
new = LA||y||surv;
create temp from new;
  append from new;

run;
quit; 

data f1; set temp; LA=col1; y=col2; PV=col3; keep LA y PV;

proc sort data=f1; by la; run;

proc sgplot data=f1;
 density PV / group=LA type=kernel ;
 run;
 
proc sgplot data=f1;
 hbox PV / group=LA;
 run;

 /*
proc univariate data=f1; by la; where pv < 1;
ods output cdfplot=cfdplot;
ods select cdfplot;
cdfplot pv /beta(theta=0 sigma=1 alpha=1 beta=1);

run;
*/
proc glimmix data=f1;where LA=1; 
ods select ParameterEstimates; 
ods output ParameterEstimates=parms; 
    model PV =  /dist=beta solution ; 
run; 
 
proc transpose data=parms out = mn; 
run; 


data mn (keep=  mu omega tau roc s  auc youden);  
	set mn; 
if _NAME_='Estimate'   
	then do; 
 		Intercept = col1;  
 		scale = col2;  
 		mu= 1/(1+exp(-Intercept));  
 		omega = mu*scale; 
 		tau = (1 - mu)*scale;
 		auc = tau / (omega + tau); 
 	   do s = 0.001 to 0.999 by .005; 
 	    ROC = cdf("beta",s, omega, tau); 
 	    youden=ROC - s;
 		output;  
	   end; 	 
    end;
run; 

proc means data=mn mean max; var auc youden;* by visit; run;

proc sgplot data=mn;
 series y=s x=s;
 series y=roc x=s;
 run;



