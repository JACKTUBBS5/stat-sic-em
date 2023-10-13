libname LDATA '/home/jacktubbs/my_shared_file_links/jacktubbs/myfolders/SAS Data Sets/';
options center nodate pagesize=100 ls=80;
/*
   ods graphics on;
/* Simplified LaTeX output that uses plain LaTeX tables  */
ods latex path='/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/clean'
 file='bf_diag.tex' style=journal 
stylesheet="sas.sty"(url="sas");

/*
http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 
*/
ods graphics / reset width=5in  outputfmt=png
  antialias=on;


*/
title1 'Body Fat Data';
/*
Density determined from underwater weighing
 Percent body fat from Siri's (1956) equation
 Age (years)
 Weight (lbs)
 Height (inches)
 Neck circumference (cm)
 Chest circumference (cm)
 Abdomen 2 circumference (cm)
 Hip circumference (cm)
 Thigh circumference (cm)
 Knee circumference (cm)
 Ankle circumference (cm)
 Biceps (extended) circumference (cm)
 Forearm circumference (cm)
 Wrist circumference (cm)
*/


data bodyfat; set ldata.bodyfat; run;

/*
Use per_fat or density as the dependent variable with a subset of the data
*/
title2 'Simple Random Sampling of size = 40';
proc surveyselect data=bodyfat
   method=srs n=40 out=new_bfat seed = 12345;
run;
*proc contents data=bodyfat short; run;
/* 
if you wish to save this new data set of size n=120
in the SAS DATA SET folder with tag ldata in the libname command
You can do this with any data set after running the 
proc surveyselect command;
 
data ldata.bfat_50; set new_bfat; run;

data new_bfat; set new_bfat; 
run;
*/
title2 'Scatterplot of Data';
proc sgplot data=new_bfat;
  scatter y=per_fat x=thigh ;
  reg y=per_fat x=thigh;
*  loess y=per_fat x=thigh;
run;
/*
proc sgplot data=new_bfat;
  scatter y=per_fat x=abdomen ;
  reg y=per_fat x=abdomen;
  loess y=per_fat x=abdomen;
run;


proc sgplot data=new_bfat;
histogram per_fat;
density per_fat;
density per_fat/ type=kernel;
run;
/*

proc sgscatter data=new_bfat;
  matrix per_fat density thigh knee ankle biceps forearm  
  wrist/diagonal=(histogram normal);run;
*/
title2 'Simple Linear Model - Neck';
  proc reg data=new_bfat   plots = diagnostics;
model per_fat=thigh;
run;


title2 'Multiple Regression';
  
proc reg data=new_bfat  plots = diagnostics;
model per_fat=neck thigh wrist/press influence ss2;
run;

/*
title2 'Simple Linear Model - Abdomen';
  proc reg data=new_bfat   plots=(residuals DIAGNOSTICS);
model per_fat=abdomen/ influence;
run;

title2 'Quadratic Linear Model - Abdomen';
  proc reg data=new_bfat   plots=(residuals DIAGNOSTICS);
model per_fat=abdomen abdomen2/ ss1;

title2 'Multiple Regression - Abdomen, Thigh, Knee';
  proc reg data=new_bfat   plots = (diagnostics partial);
model per_fat=abdomen thigh knee/ss1 ss2;
run;
/*
title2 'Polynomial Regression';
  proc reg data=new_bfat   plots = (diagnostics partial);
model per_fat=abdomen abdomen2/ press partial ss1;
run;

proc sgscatter data=new_bfat;
 matrix per_fat abdomen age ankle biceps chest forearm hip ht 
        knee neck thigh wrist wt
                   /diagonal=(histogram kernel);
run;

proc corr data=new_bfat pearson spearman;
var per_fat abdomen age ankle biceps chest forearm hip ht 
        knee neck thigh wrist wt
;
run;
*
title 'Multiple Regression';
proc reg data=new_bfat plots= diagnostics  ;
  model per_fat=abdomen age ankle biceps chest forearm 
    hip ht knee neck thigh wrist wt /vif collin ss1 ss2 partial;
run;
/*
*proc means data=physicalmeasures;* var mass bicep; run;
*
ods graphics on;
title 'Model selection with Proc Reg';
proc reg data=new_bfat plots(only)=cpplot(labelvars);
  model per_fat=abdomen age ankle biceps chest forearm 
    hip ht knee neck thigh wrist wt  / selection=cp best=10;
run;

ods graphics off;
proc reg data=new_bfat;
forward:  model per_fat=abdomen age ankle biceps chest forearm 
    hip ht knee neck thigh wrist wt  / selection=f sle=.05 details=summary;
    
backward:  model per_fat=abdomen age ankle biceps chest forearm 
    hip ht knee neck thigh wrist wt  / selection=b sls=.05 details=summary;
    
stepwise:  model per_fat=abdomen age ankle biceps chest forearm 
    hip ht knee neck thigh wrist wt  / selection=stepwise sle=.05 sls=.05 details=summary;
run;
/*
ods graphics on;
proc reg data=PhysicalMeasures;
  model mass=fore waist height thigh;
run;
/*
data jmp.physicalmeasures; set physicalmeasures; run;


ods graphics on;
proc glmselect data=new_bfat plots=all;
;
  model per_fat=abdomen age ankle biceps chest forearm 
                hip ht knee neck thigh wrist wt/ selection=lasso details=summary;
run;
*
proc glmselect data=new_bfat plots=all;
  model per_fat=abdomen age ankle biceps chest forearm 
                hip ht knee neck thigh wrist wt/ 
                selection=lasso(steps=3 choose=validate) details=summary;
partition FRACTION(TEST=.2 VALIDATE=.3);
                
run;
*
*ods graphics off;
proc glmselect data=new_bfat plots=all;
partition FRACTION(TEST=.2 VALIDATE=.3);

stepwise:   model per_fat=abdomen age ankle biceps chest forearm 
                          hip ht knee neck thigh wrist wt/ 
                          selection=stepwise(CHOOSE=VALIDATE)  details=summary;

run;
proc glmselect data=new_bfat plots=all;
partition FRACTION(TEST=.2 VALIDATE=.3);
lasso:      model per_fat=abdomen age ankle biceps chest forearm
                          hip ht knee neck thigh wrist wt / 
                          selection=lasso(steps=5 choose=validate) details=summary;
run;
proc glmselect data=new_bfat plots=all;
partition FRACTION(TEST=.2 VALIDATE=.3);
elasticnet: model per_fat=abdomen age ankle biceps chest forearm 
                          hip ht knee neck thigh wrist wt/ 
                          selection=elasticnet(steps=5 L2=0.01 choose=validate)
                          details=summary;
run;
*
title 'Robust regression with Bodyfat data';
DATA new_bfat; set new_bfat; labdomen = log(abdomen); run;
proc sort data=new_bfat; by abdomen; run;
/*
*Least Squares Procedure;
title2 'Multipe Regression';
proc reg data=new_bfat;*  plots = (diagnostics partial);
   model density=labdomen;
   output out=a p=yhat;
run;

*Robust procedure using Proc NLIN with iterated reweighted least squares;
title2 'Tukey Biweigth using IRLS';
title3 'Robust = red LS = blue';
proc nlin data=a nohalve;
   parms b0=1.6 b1=-0.12;
   model density = b0 + b1*labdomen;
   resid=density-model.density;
   p=model.density;
   sigma=6;der.b0=1;der.b1=labdomen;
   b=4.685;
   r=abs(resid/sigma);
   if r<=b then _weight_=(1-(r/b)**2);
   else _weight_=0;
   output out=c r=rbi p=p; run;
data c; set c; sigma=2; b=4.685; r=abs(rbi/sigma);
   if r<=b then _weight_=(1-(r/b)**2);
   else _weight_=0;
proc sgplot data=c;
   scatter y=density x=labdomen;
   series y=p x=labdomen; 
   series y=yhat x=labdomen/ ;
   run;
title2 ' ';
title3 ' ';
proc robustreg data=new_bfat plots=all method=m(wf=bisquare); 
model density=labdomen;
run;
/*
proc robustreg data=new_bfat plots=all method=m(wf=huber); 
model density=labdomen;
run;


proc robustreg data=new_bfat plots=all method=mm; 
model density=labdomen;
run;
*
title 'Quantile regression with Bodyfat data';
proc quantreg data=new_bfat ci=none algorithm=interior(tolerance=1e-4) ;
*  class region year;
   model density=labdomen
                    / nosummary quantile=0.1,0.25,0.5,0.75,
                               0.90;
*   output out=outp pred=p/columnwise;
   run;

   

ods graphics off; 
*ods pdf close;

