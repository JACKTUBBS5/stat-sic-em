libname jmp 
	'/home/u63555033/STA 4382/Data';
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
title2 'Correlation and Scatterplot for all the variables';
data PhysicalMeasures;
	set jmp.physicalmeasures;
run;
/*
proc contents short;
run;
*/
proc sgscatter data=PhysicalMeasures;
	matrix mass--head /diagonal=(histogram kernel);
run;

proc corr data=physicalmeasures pearson spearman kendall;
	var mass--head;
run;

/********************************************************;
*********************************************************;
********   Building New Models   ************************;
*********************************************************;
*********************************************************/;

* New data set;
data new; set physicalmeasures; 
fore2 = fore*fore;
run;

title2 'Scatterplot of Data';
proc sgplot data=new;
  scatter y=mass x=fore;
  reg y=mass x=fore;
  loess y=mass x=fore;
run;

title2 'Scatterplot of Data';
proc sgplot data=new;
  scatter y=mass x=waist;
  reg y=mass x=waist;
  loess y=mass x=waist;
run;

title2 'Linear Regression ';
proc reg data=new  plots(only)=(diagnostics residuals 
		fitplot observedbypredicted);
model mass=fore;
run;

proc reg data=new alpha=0.05 plots(only)=(diagnostics residuals 
		fitplot observedbypredicted);
	model mass=waist;
run;

proc sgscatter data=new;
	matrix mass fore bicep chest neck shoulder waist height calf thigh head/diagonal = (histogram kernel);
	run;
	
proc corr data=new pearson spearman;
var mass fore bicep chest neck shoulder waist height calf thigh head;
run;

ods graphics on;
title 'Model Selection with Proc Reg';
proc reg data=new plots(only)=cpplot(labelvars);
model mass=fore bicep chest neck shoulder waist height calf 
	thigh head/selection=cp best=10;
	run;

ods graphics off;
proc reg data=new;
forward: model mass=fore bicep chest neck shoulder waist height calf 
	thigh head / selection=f sle=0.05 details=summary;
	
backward: model mass=fore bicep chest neck shoulder waist height calf 
	thigh head / selection=b sls=0.05 details=summary;
	
stepwaise:  model mass=fore bicep chest neck shoulder waist height calf 
	thigh head / selection=stepwise sle=0.05 sls=0.05 details=summary;
	run;
	
ods graphics on;
proc glmselect data=new plots=all;
	model mass=fore bicep chest neck shoulder waist height calf 
	thigh head / selection=lasso details=summary;
	run;
	
proc glmselect data=new plots=all;
	model mass=fore bicep chest neck shoulder waist height calf 
	thigh head / selection = lasso(steps=3 choose=validate) details=summary;
	partition FRACTION(TEST=.2 VALIDATE=.3);
	run;
	

proc glmselect data=new plots=all;
partition FRACTION(TEST=.2 VALIDATE=.3);

stepwise: model mass=fore bicep chest neck shoulder waist height calf 
	thigh head / selection=stepwise(CHOOSE=VALIDATE) details=summary;
run;

proc glmselect data=new plots=all;
partition FRACTION(TEST=.2 VALIDATE=.3);
lasso: model mass=fore bicep chest neck shoulder waist height calf 
	thigh head / selection=lasso (steps=5 choose=validate) details=summary;
	run;
	
proc glmselect data=new plots=all;
partition FRACTION(TEST=.2 VALIDATE=.3);
elasticnet: model mass=fore bicep chest neck shoulder waist height calf 
	thigh head / selection=elasticnet(steps=5 L2=0.01 choose=validate)
	details=summary;
	run;




