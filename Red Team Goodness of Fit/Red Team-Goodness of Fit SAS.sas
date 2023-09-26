options center nodate pagesize=100 ls=70;

ods graphics / reset width=5in  outputfmt=png
  antialias=on;




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

/*1st trial: we changed the mean to 2 and the graph shifted to the right and made the peak of each curve increase by around 3.
*2nd Trial: we changed the mean to 4 and the graph shifted further to the right. The peaks of each curve increased around another 4 units.
*3rd Trial: we changed the standard deviation from 1 to 5, and the range of x increased drastically for both curves, however the center of each peak remained the same.
*4th Trial: we changed the standard deviation to 10, and the range increased further, and gives the impression that they have the same mean, however this is because the scale is so large.
*/

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