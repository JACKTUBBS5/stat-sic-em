libname LDATA '/home/jacktubbs/my_shared_file_links/jacktubbs/myfolders/SAS Data Sets/';
options center nodate pagesize=100 ls=80;
title1 'Body Fat Data';

/*
   ods graphics on;
/* Simplified LaTeX output that uses plain LaTeX tables  */
ods latex path='/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/clean'
 file='bf_selection.tex' style=journal 
stylesheet="sas.sty"(url="sas");

/*
http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 
*/
ods graphics / reset width=5in  outputfmt=png
  antialias=on;

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


/*
data bodyfat; set ldata.bodyfat; run;

title2 'Scatterplot of Entire Data';
proc sgscatter data=bodyfat;
  matrix per_fat  age wt ht neck chest abdomen hip 
        /diagonal=(histogram normal);run;
proc sgscatter data=bodyfat;
  matrix per_fat  thigh knee ankle biceps forearm  wrist
        /diagonal=(histogram normal);run;


/* 
Use per_fat or density as the dependent variable with a subset of the data
*/
title2 'Simple Random Sampling of 40 values';
proc surveyselect data=ldata.bodyfat
   method=srs n=40 out=new_bfat seed = 54321;
run;

proc sgplot data=new_bfat;
histogram per_fat;
density per_fat;
density per_fat/ type=kernel;
run;

proc sgscatter data=new_bfat;
matrix per_fat thigh knee ankle abdomen hip chest biceps forearm wrist age
         /diagonal=(histogram normal);
run;


title2 'Multiple Regression';
  proc reg data=new_bfat  plots = (diagnostics partial);
model per_fat=thigh knee ankle abdomen hip chest biceps forearm wrist age
        /partial   ss1 ss2;
run;

title2 'Multiple Regression';
title3 'Ridge and Check for Collinearity';
proc reg data=new_bfat plots(only)=ridge(unpack VIFaxis=log)
outest=b ridge=0 to 0.02 by .002 plots = (diagnostics partial);
model per_fat=thigh knee ankle abdomen hip chest biceps forearm wrist age
        /vif tol collin ;
run;

title2 'Forward Regression';
proc reg data=new_bfat;*   plots = (diagnostics partial);
model per_fat=thigh knee ankle abdomen hip chest biceps forearm wrist age
        /selection=forward details=summary;
run;

title2 'Stepwise Regression';
proc reg data=new_bfat;*   plots = (diagnostics partial);
model per_fat=thigh knee ankle abdomen hip chest biceps forearm wrist age
        /selection=cp best=5 details=summary;
run;

title2 'Stepwise Regression';
proc glmselect data=new_bfat   plots = all;
model per_fat=thigh knee ankle abdomen hip chest biceps forearm wrist age
        /selection=stepwise choose=cp details=summary;
run;

title2 'Lasso Regression';
title3 'Standardize the data';

proc stdize data=new_bfat out=data1; 
var per_fat thigh knee ankle abdomen biceps forearm age wrist;  run;

proc glmselect data=data1   plots = all;
model per_fat=thigh knee ankle abdomen biceps forearm age wrist
      / selection=lasso choose=cp details=summary;
run;

title2 'Correlation and PCR';
proc corr data=new_bfat pearson spearman kendall;
var per_fat thigh knee ankle abdomen biceps forearm age wrist; 
run;

proc princomp data=new_bfat  out=PCmeasures standard
              plots=patternprofile;
var thigh knee ankle abdomen biceps forearm age wrist; 
run;

proc reg data=PCmeasures plots = (diagnostics partial);
model per_fat=Prin1 -- Prin2 / b ss1;
run;

proc reg data=PCmeasures plots(only)= none;
model per_fat=Prin1 -- Prin6 / selection=cp best=10;
run;

quit;

ods graphics off;

