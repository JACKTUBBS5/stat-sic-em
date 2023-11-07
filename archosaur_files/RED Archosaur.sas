options center nodate pagesize=120 ls=80;
libname ldata '/home/u63561478/sasuser.v94/Data';


/*
http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 
*/
ods graphics / reset width=5in  outputfmt=png
  antialias=on;

/*
This data set is from the JMP Case Study Library 
*/


title "Archosaurs: Linear Regression";
data brain; set ldata.archosaur; 
data body; set ldata.archosaur;
run;

proc univariate data=ldata.archosaur;
var brain_weight;
histogram;
run;

proc sgplot data=ldata.archosaur;
vbox brain_weight;
run;

proc univariate data=ldata.archosaur;
var body_weight;
histogram;
run;

proc sgplot data=ldata.archosaur;
vbox body_weight;
run;

proc contents data=brain short; 
run;

data brain; set brain;
brain_wt = brain_weight;
body_wt = body_weight;
run;

proc sgplot data=brain;
scatter y=brain_wt x=body_wt;
reg y=brain_wt x=body_wt;
run;

proc reg data=ldata.archosaur plots=diagnostics;
model brain_weight = body_weight;
run;


title "Archosaurs: Linear Regression with Logarithm";
data brain; set ldata.archosaur; 
run;


proc contents data=brain short; 
run;

data brain; set brain;
log_brain_wt = log(brain_weight);
log_body_wt = log(body_weight);
run;

proc univariate data=brain;
var log_brain_wt;
histogram;
run;

proc sgplot data=brain;
vbox log_brain_wt;
run;

proc univariate data=brain;
var log_body_wt;
histogram;
run;

proc sgplot data=brain;
vbox log_body_wt;
run;

proc sgplot data=brain;
scatter y=log_brain_wt x=log_body_wt;
reg y=log_brain_wt x=log_body_wt;
run;

proc reg data=brain plots=diagnostics;
model log_brain_wt = log_body_wt;
run;


/* Overall, the data does not support the theory because the slope generated (0.51621)
 is too far from the power law regression line's slope of 2/3. The power law regression 
 model fits the data better. */

