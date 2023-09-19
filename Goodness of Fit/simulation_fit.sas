options center nodate pagesize=100 ls=70;
libname LDATA '/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/';

/* Simplified LaTeX output that uses plain LaTeX tables  */
ods latex path='/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/clean'
 file='baseball_boot.tex' style=journal 
stylesheet="sas.sty"(url="sas");

/*
http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 
*/
ods graphics / reset width=5in  outputfmt=png
  antialias=on;

*/;



title 'Simulated Normal Data';
%let n=50;

data cert;
  do group = 1 to 2;
     do i = 1 to &n;
        x = rand('normal', 0, 1);
      output;
      end;
  end;
run;
data cert; set cert;
   if group = 1 then x = 2*x + 10;
   else x = 2*x + 14;
run;   

proc sgplot data=cert; 
density x /group=group;
run;

title2 'Descriptive Statistics';
proc univariate data=cert normal trim=.05 winsor=.05 mu0=12; 
var x;
run;

title2 'Nonparametric Test of Hypothesis';
proc npar1way data=cert wilcoxon edf ; 
class group;
var x;
run;

title2 'T Test';
proc ttest data=cert ; 
class group;
var x;
run;



title2 'Fit for 2 populations';
proc univariate data=cert normal; 
class group;
var x;
run;

quit;
ods latex close;
