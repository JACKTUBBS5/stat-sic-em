options center nodate pagesize=120 ls=80;
libname ldata '/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Class';

/* Simplified LaTeX output that uses plain LaTeX tables  */
ods latex path='/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Class'
 file='low_bwt1.tex' style=journal 
stylesheet="sas.sty"(url="sas");

/*
http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 
*/
ods graphics / reset width=5in  outputfmt=png
  antialias=on;
/*
The Sashelp.BirthWgt data set contains 100,000 random observations about infant mortality in 
2003 fromthe US National Center for Health Statistics. Each observation records infant death 
within one year of birth, birth weight, maternal smoking and drinking behavior, 
and other background characteristics of the mother.
*/

title "Sashelp.bweight --- Infant Birth Weight";
data birthwgt; set sashelp.birthwgt; run;
proc contents data=birthwgt varnum;
ods select position;
run;
title "The First Five Observations Out of 100,000";
proc print data=birthwgt(obs=10);
run;

*Create a new smaller datat set;
title 'New Sample of Size 2,500';
proc surveyselect data=birthwgt out=new2 method=srs n=2500
                  seed=2021;
run;

/* I needed more death records than the srs gave me */
data new; set birthwgt; if death = 'Yes'; 
run;

/*merge the two files into one */
data new_bwgt; set new new2; 
run;

proc freq data=new_bwgt order=freq; 
tables LowBirthWgt*smoking/noCOL nopercent chisq relrisk riskdiff; 
run;

proc freq data=new_bwgt order=freq; 
tables LowBirthWgt*drinking/nocol nopercent chisq relrisk riskdiff; 
run;

proc freq data=new_bwgt order=freq;  
tables death*LowBirthWgt*smoking /nopercent nocol chisq cmh; 
run;

proc freq data=new_bwgt order=freq;  
tables death*LowBirthWgt*drinking /nopercent nocol chisq cmh; 
run;

proc freq data=new_bwgt order=freq; 
tables death*LowBirthWgt/nocol nopercent chisq relrisk riskdiff; 
run;

ods latex close;
/*
proc logistic data=new_bwgt plots=roc;where race ne 'Native';
class race smoking lowbirthwgt death/param=glm;
model death(event='Yes') = race | smoking  lowbirthwgt/expb;
run;
*/

/* Stream a CSV representation of new_bwgt directly to the user's browser. */
/*
proc export data=new_bwgt
            outfile=_dataout
            dbms=csv replace;
run;

%let _DATAOUT_MIME_TYPE=text/csv;
%let _DATAOUT_NAME=bwgt.csv;