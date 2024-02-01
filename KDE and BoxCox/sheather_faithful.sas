options center nodate pagesize=100 ls=70;
libname LDATA '/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/';

/* Simplified LaTeX output that uses plain LaTeX tables */
ods tagsets.simplelatex file="/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/sheather_faithful.tex" 
stylesheet="/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/sas.sty"(url="sas");

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

% Using default graphics method;
proc sgplot data=bimodal;
histogram x;
density x/type=kernel;
run;


proc kde data=bimodal;
   univar x(bwm=.2) x(bwm=0.4) x(bwm=.6) x(bwm=0.8);
run;


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

