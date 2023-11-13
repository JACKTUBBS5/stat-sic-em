libname LDATA '/home/jacktubbs/my_shared_file_links/jacktubbs/myfolders/Titanic/';
options center nodate pagesize=100 ls=80;
/* Simplified LaTeX output that uses plain LaTeX tables */
ods tagsets.simplelatex file="/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/ROC_sim.tex" 
stylesheet="/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/sas.sty"(url="sas");

/*
The above will create a new file that can be inputed into LaTeX (simple.tex) and the new style needed by LaTex (sas.sty).
In this case I asked that these files be placed in My SAS Files folder in My Documents. You can put these anywhere. 
The following example can be found at

http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 

*/
ods graphics on;

title1 'Simulated Data for ROC';
* Run Macro;
%macro binorm(dsn, title);
title2 &title;
data a;set &dsn;      
  seed=12345;
  do i = 1 to n0;
   group='control';
   y = c0 + rand("Normal", 0, sd_e0);
   output;
  end;
  do i = 1 to n1;
   group='disease';
   y = c1 + rand("Normal", 0, sd_e1);
   output;
  end;
run; 

data a; set a; y_cut = (y > cutoff); run; 

proc sgplot data=a;
density y /type=kernel group=group;
run;

proc freq; table group*y_cut/ nopercent nocol outpct out=b ; run;
data c; set b; 
if group = 'disease' and y_cut = '1' then sensitivity = pct_row;
if group = 'control' and y_cut = '0' then specificity = pct_row;
keep sensitivity specificity;
run;
proc print data=c; var sensitivity specificity; run;
  
proc logistic data=a plots(only)=roc ;
class group ;
model group(event='disease')=y;
run;

%mend binorm;


*Run data gernation;
data parms1; c0=1.5; sd_e0=1.5; n0=100; c1=2.0; sd_e1=1.5; n1=100; cutoff = 3.0;
run;
data parms2; c0=1.5; sd_e0=1.5; n0=100; c1=2.5; sd_e1=1.5; n1=100; cutoff = 3.0;
run;
data parms3; c0=1.5; sd_e0=1.5; n0=100; c1=3.0; sd_e1=1.5; n1=100; cutoff = 3.0;
run;
data parms4; c0=1.5; sd_e0=1.5; n0=100; c1=3.5; sd_e1=1.5; n1=100; cutoff = 3.0;
run;

*%binorm(parms1,'Data set #1');
%binorm(parms2,'Data set #2');
*%binorm(parms3,'Data set #3');
*%binorm(parms4,'Data set #4');




quit;
