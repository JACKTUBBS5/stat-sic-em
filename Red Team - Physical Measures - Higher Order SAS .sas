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
head2 = head*head;
chest2 = chest*chest;
waist2=waist*waist; 
shoulder2 = shoulder*shoulder; 
thigh2 = thigh*thigh; run;

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

title2 'Polynomial Regression - second degree Quadratic - head';
  proc reg data=new  plots = (diagnostics partial);
model mass=head head2/ b ss1;
run;

title2 'Polynomial Regression - second degree Quadratic - chest';
  proc reg data=new  plots = (diagnostics partial);
model mass=chest chest2/ b ss1;
run;

title2 'Polynomial Regression - second degree Quadratic - fore';
  proc reg data=new  plots = (diagnostics partial);
model mass=fore fore2/ b ss1;
run;

title2 'Polynomial Regression - second degree Quadratic - shoulder';
  proc reg data=new  plots = (diagnostics partial);
model mass=shoulder shoulder2/ b ss1;
run;

title2 'Polynomial Regression - second degree Quadratic - thigh';
  proc reg data=new  plots = (diagnostics partial);
model mass=thigh thigh2/ b ss1;
run;


title2 'Multiple Regression (height, chest, head)';
  proc reg data=new  plots = (diagnostics partial);
model mass=height chest head/b ss1 ss2 ;
run;

title2 'Multiple Regression (chest calf height)';
  proc reg data=new  plots = (diagnostics partial);
model mass= chest calf height/b ss1 ss2 ;
run;

title2 'Multiple Regression (fore waist thigh)';
  proc reg data=new  plots = (diagnostics partial);
model mass= fore waist thigh/b ss1 ss2 ;
run;

title2 'Multiple Regression (chest calf height fore)';
  proc reg data=new  plots = (diagnostics partial);
model mass= chest calf height fore/b ss1 ss2 ;
run;

title2 'Multiple Regression (fore height chest)';
  proc reg data=new  plots = (diagnostics partial);
model mass= fore height chest/b ss1 ss2 ;
run;

title2 'Multiple Regression (fore height waist)';
  proc reg data=new  plots = (diagnostics partial);
model mass= fore height waist/b ss1 ss2 ;
run;

title2 'Multiple Regression (fore waist height)';
  proc reg data=new  plots = (diagnostics partial);
model mass= fore waist height/b ss1 ss2 ;
run;