libname jmp 
	'/home/jacktubbs/my_shared_file_links/jacktubbs/myfolders/JMP DATA/';
options center nodate pagesize=100 ls=80;

/* Simplified LaTeX output that uses plain LaTeX tables  *
ods latex path='/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/'
 file='physical_measures.tex' style=journal 
stylesheet="sas.sty"(url="sas");

/*
http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 
*
ods graphics / reset width=5in  outputfmt=png
  antialias=on;

*/
TITLE1 'Physical Measures';

data PhysicalMeasures;
	set jmp.physicalmeasures;
run;
/*
proc contents short;
run;

proc sgscatter data=PhysicalMeasures;
	matrix mass--head /diagonal=(histogram kernel);
run;

/*
proc corr data=physicalmeasures pearson spearman kendall;
	var mass--head;
run;

*
proc reg data=PhysicalMeasures outvif
         outest=b ridge=0 to 0.05 by .005;;
model mass=fore--head/vif tol collinoint ;
run;

proc princomp data=PhysicalMeasures  out=PCmeasures standard
              plots=patternprofile;
   var fore--head;
run;
/*
ods graphics on;
proc reg data=PhysicalMeasures plots(only)= cpplot;
model mass=fore--head / selection=cp best=10;
run;

/*
proc reg data=PCmeasures plots(only)= cpplot;
model mass=Prin1 -- Prin5 / selection=cp best=10;
run;


ods graphics off;
proc reg data=PhysicalMeasures;
forward:  model mass=fore--head / selection=f sle=.05 details=summary;
backward:  model mass=fore--head / selection=b sls=.05 details=summary;
stepwise:  model mass=fore--head / selection=stepwise sle=.05 sls=.05 details=summary;
run;
*

proc glmselect data=PhysicalMeasures plots=coefficientpanel;
 partition fraction(validate=0.3);
stepwise:   model mass=fore--head/ selection=forward(choose=validate stop=4);
run;

proc means data=PhysicalMeasures mean; var mass; run;
*/
proc stdize data=PhysicalMeasures out=stdPM;
var mass Fore--Head;
run;

data stdPM; set stdPM; mass = mass + 79; run;

proc glmselect data=PhysicalMeasures plots=coefficientpanel;
lasso:      model mass=Fore Bicep Chest Neck Shoulder
Waist Height Calf Thigh Head / selection=lasso choose=bic steps=4;
run;

proc glmselect data=stdPM plots=coefficientpanel;
lasso:      model mass=Fore Bicep Chest Neck Shoulder
Waist Height Calf Thigh Head / selection=lasso choose=bic steps=4;
run;


proc glmselect data=PhysicalMeasures plots=coefficientpanel;
elasticnet: model mass=Fore Bicep Chest Neck Shoulder
Waist Height Calf Thigh Head / selection=elasticnet choose=bic steps=4;
run;
/*
ods graphics on;
proc reg data=PhysicalMeasures;
model mass=fore waist height thigh;
run;

*
*****************************************************************;
*   CART AND Random Forest Classification;
*****************************************************************;
proc hpsplit data=PhysicalMeasures seed=123;
   model mass = fore--head;
   partition fraction(validate=0.3 seed=1234);
*   grow entropy;
*   prune costcomplexity;
   output out=hpsplout;
run;

proc sgplot data=hpsplout;
scatter y=mass x=p_mass;
series y=mass x=mass;
run;

title2 'Regression';
proc hpforest data=PhysicalMeasures maxtrees=50 INBAGFRACTION=.3;
   input fore--head /level=interval;
   target mass/level=interval;
*   score out=ldata.score;
 *  save file = ldata;
   ods output VariableImportance = variable;
   * FitStatistics=fitstats(rename=(Ntrees=Trees)) ;
run;
