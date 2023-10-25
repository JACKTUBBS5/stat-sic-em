options center nodate pagesize=120 ls=80;
libname ldata '/home/u63561478/sasuser.v94/Data';

/* Simplified LaTeX output that uses plain LaTeX tables  */
ods latex path='/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Output'
 file='archosaur.tex' style=journal 
stylesheet="sas.sty"(url="sas");

/*
http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 
*/
ods graphics / reset width=5in  outputfmt=png
  antialias=on;

/*
This data set is from the JMP Case Study Library 
*/

title "Archosaurs: Linear Regression Example";
data brain; set ldata.archosaur; 
run;

proc contents data=brain short; 
run;

data brain; set brain;
log_brain_wt = log(brain_weight);
log_body_wt = log(body_weight);
run;

proc sgplot data=brain;
scatter y=log_brain_wt x=log_body_wt;
reg y=log_brain_wt x=log_body_wt;
run;

proc reg data=brain plots=diagnostics;
model log_brain_wt = log_body_wt;
run;


ods latex close;

/* Stream a CSV representation of new_bwgt directly to the user's browser. */
/*
proc export data=new_heart
            outfile=_dataout
            dbms=csv replace;
run;

%let _DATAOUT_MIME_TYPE=text/csv;
%let _DATAOUT_NAME=heart.csv;
