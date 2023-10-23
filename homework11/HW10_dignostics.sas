/* Setup and Data Import */
OPTIONS NONOTES NOSTIMER NOSOURCE NOSYNTAXCHECK;

LIBNAME ldata "/home/u63549661/sasuser.v94/";

PROC IMPORT DATAFILE='/home/u63549661/sasuser.v94/bodyfat.csv'
    OUT=ldata.bodyfat
    DBMS=CSV
    REPLACE;
RUN;

ODS GRAPHICS ON;


/* Scatterplot of the entire data set for various variables */
title2 'Scatterplot of Entire Data';
proc sgscatter data=ldata.bodyfat;
  matrix per_fat age wt ht neck chest abdomen hip /diagonal=(histogram normal);
run;
proc sgscatter data=ldata.bodyfat;
  matrix per_fat thigh knee ankle biceps forearm wrist /diagonal=(histogram normal);
run;

/* Sampling 40 random values for analysis */
title2 'Simple Random Sampling of 40 values';
proc surveyselect data=ldata.bodyfat method=srs n=40 out=new_bfat seed=54321;
run;

/* Create ABDOMEN2 variable */
data new_bfat; 
    set new_bfat;
    abdomen2 = abdomen**2;
run;

/* Histograms and density plots for the random sample */
title2 'Histograms and Density Plots';
proc sgplot data=new_bfat;
    histogram per_fat;
    density per_fat;
    density per_fat/ type=kernel;
run;

/* Scatter matrix for the random sample */
title2 'Scatter Matrix for Random Sample';
proc sgscatter data=new_bfat;
    matrix per_fat thigh knee ankle abdomen hip chest biceps forearm wrist age /diagonal=(histogram normal);
run;


/*model*/
/* Various regression methods on the random sample */
title2 'Simple Linear Model - Neck';
proc reg data=new_bfat plots=diagnostics;
model per_fat=thigh;
run;

title2 'Polynomial Regression';
proc reg data=new_bfat plots=(diagnostics partial);
model per_fat=abdomen abdomen2/ press partial ss1;
run;

title2 'Multiple Regression Analysis';
proc reg data=new_bfat plots=(diagnostics partial);
model per_fat=thigh knee ankle abdomen hip chest biceps forearm wrist age;
run;

title2 'Ridge Regression and Collinearity Check';
proc reg data=new_bfat plots(only)=ridge(unpack VIFaxis=log) outest=b ridge=0 to 0.02 by .002;
model per_fat=thigh knee ankle abdomen hip chest biceps forearm wrist age /vif tol collin;
run;

title2 'Forward Regression';
proc reg data=new_bfat;
model per_fat=thigh knee ankle abdomen hip chest biceps forearm wrist age /selection=forward;
run;

title2 'Stepwise Regression with various selection criteria';
proc reg data=new_bfat;
model per_fat=thigh knee ankle abdomen hip chest biceps forearm wrist age /selection=cp best=5;
run;
proc glmselect data=new_bfat plots=all;
model per_fat=thigh knee ankle abdomen hip chest biceps forearm wrist age /selection=stepwise choose=cp;
run;

/* Lasso regression after standardizing the data */
title2 'Lasso Regression with Standardized Data';
proc stdize data=new_bfat out=data1; 
var per_fat thigh knee ankle abdomen biceps forearm age wrist;  
run;
proc glmselect data=data1 plots=all;
model per_fat=thigh knee ankle abdomen biceps forearm age wrist /selection=lasso choose=cp;
run;

/* Correlation and principal component analysis */
title2 'Correlation and Principal Component Analysis';
proc corr data=new_bfat pearson spearman kendall;
var per_fat thigh knee ankle abdomen biceps forearm age wrist; 
run;
proc princomp data=new_bfat out=PCmeasures standard;
var thigh knee ankle abdomen biceps forearm age wrist; 
run;
proc reg data=PCmeasures;
model per_fat=Prin1 -- Prin6 / selection=cp best=10;
run;

title3 'Model selection with Proc Reg';
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


proc glmselect data=new_bfat plots=all;
  model per_fat=abdomen age ankle biceps chest forearm 
                hip ht knee neck thigh wrist wt/ selection=lasso details=summary;
run;

proc glmselect data=new_bfat plots=all;
  model per_fat=abdomen age ankle biceps chest forearm 
                hip ht knee neck thigh wrist wt/ 
                selection=lasso(steps=3 choose=validate) details=summary;
partition FRACTION(TEST=.2 VALIDATE=.3);
                
run;

proc glmselect data=new_bfat plots=all;
partition FRACTION(TEST=.2 VALIDATE=.3);
elasticnet: model per_fat=abdomen age ankle biceps chest forearm 
                          hip ht knee neck thigh wrist wt/ 
                          selection=elasticnet(steps=5 L2=0.01 choose=validate)
                          details=summary;
run;

title 'Robust regression with Bodyfat data';
DATA new_bfat; set new_bfat; labdomen = log(abdomen); run;
proc sort data=new_bfat; by abdomen; run;

title2 'Multipe Regression';
proc reg data=new_bfat;
   model density=labdomen;
   output out=a p=yhat;
run;

title2 'Tukey Biweigth using IRLS';
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

proc robustreg data=new_bfat plots=all method=m(wf=bisquare); 
model density=labdomen;
run;

title 'Quantile regression with Bodyfat data';
proc quantreg data=new_bfat ci=none algorithm=interior; 
    model density=labdomen / quantile=0.5;
run;












