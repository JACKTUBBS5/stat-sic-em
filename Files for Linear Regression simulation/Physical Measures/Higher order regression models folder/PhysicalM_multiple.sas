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
waist2=waist*waist; run;

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

title2 'Polynomial Regression - second degree Quadratic';
  proc reg data=new  plots = (diagnostics partial);
model mass=fore fore2/ b ss1;
run;

title2 'Multiple Regression';
  proc reg data=new  plots = (diagnostics partial);
model mass=fore waist thigh/b ss1 ss2 ;
run;
