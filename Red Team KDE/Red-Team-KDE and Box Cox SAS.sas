options center nodate pagesize=100 ls=70;
libname LDATA '/home/u63555033/STA 4382/Data';


/*
The above will create a new file that can be inputed into LaTeX (simple.tex) and the new style needed by LaTex (sas.sty).
In this case I asked that these files be placed in My SAS Files folder in My Documents. You can put these anywhere. 
The following example can be found at

http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 

*/
*ods graphics on;
title 'Sheather KDE Simulated Data';
ods graphics on;
data bimodal; set ldata.bimodal; run;
proc kde data=bimodal;
   univar x(bwm=.2) x(bwm=0.4) x(bwm=.6) x(bwm=0.8);
run;

/*1st trial: Increased each bandwidth by 0.1. This removes the variation and creates smoother curves by grouping larger groups of data together. 
* 2nd trial: Decreased each bandwidth by 1/10. Shows a significant increase in variability, very rough curves. Shows us that decreasing the bandwidth increases the variability shown in the curve.
*/

title 'Old Faithful Data';
data faithful; set ldata.faithful;
run;

proc sgplot data=faithful;
scatter y=wait x=duration;
reg y=wait x=duration/ clm;
loess y=wait x=duration;
run;
proc sgplot data=faithful;
histogram wait;
density wait;
run;
ods graphics on;
proc kde data=faithful;
univar wait;
run;

proc kde data=faithful;
   bivar wait duration  ;
run;
quit;
