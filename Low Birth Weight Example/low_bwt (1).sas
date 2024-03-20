options center nodate pagesize=120 ls=80;
libname ldata '/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Class';

/* Simplified LaTeX output that uses plain LaTeX tables  *
ods latex path='/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Class'
 file='low_bwt1a.tex' style=journal 
stylesheet="sas.sty"(url="sas");

/*
http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 
*
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
proc contents data=birthwgt short;
ods select position;
run;
title "The First Ten Observations Out of 100,000";
proc print data=birthwgt(obs=10);
run;

*Create a new smaller datat set;
title 'New Sample of Size 2,500';
proc surveyselect data=birthwgt out=new2 method=srs n=5000
                  seed=2021;
run;


/* I needed more death records than the srs gave me */
data new; set birthwgt; if death = 'Yes'; 
run;

/*merge the two files into one */
data new_bwgt; set new new2; 
run;


data new_bwgt; set new_bwgt;
if LowBirthWgt = 'Yes' then LowBirthWgt = 'Affirm';
if Death = 'Yes' then Death = 'Affirm';
if Smoking = 'Yes' then Smoking = 'Affirm';
if Drinking = 'Yes' then Drinking = 'Affirm';
if somecollege = 'Yes' then somecollege = 'Affirm';

run;



title 'Test for Association between Low Birth Weight and death';
title2 '';
proc freq data=new_bwgt;* order=freq; 
tables LowBirthWgt*death/norow nocol nopercent chisq relrisk riskdiff or; 
run;

/*
title 'Test for Association between Low Birth Weight and Death by Smoking';
proc freq data=new_bwgt;* order=freq; 
tables smoking*LowBirthWgt*death/norow nocol nopercent chisq relrisk  cmh; 
run;

title 'Test for Association between Low Birth Weight and Death by Drinking';
proc freq data=new_bwgt;* order=freq; 
tables drinking*LowBirthWgt*death/norow nopercent nocol  chisq relrisk  cmh; 
run;

title 'Test for Association between Low Birth Weight and Smoking by College';
proc freq data=new_bwgt;* order=freq; 
tables somecollege*LowBirthWgt*death/norow nopercent nocol chisq relrisk  cmh; 
run;


/*

title 'Test for Association between Low Birth Weight and drinking';
proc freq data=new_bwgt;* order=freq; 
tables drinking*LowBirthWgt/norow nopercent chisq relrisk riskdiff; 
run;

title 'Test for Association between Low Birth Weight and Smoking';
title2 'Controlling for Death';
proc freq data=new_bwgt;* order=freq;  
tables death*smoking*LowBirthWgt /nopercent norow chisq cmh; 
run;

title 'Test for Association between Low Birth Weight and Drinking';
title2 'Controlling for Death';
proc freq data=new_bwgt;* order=freq;  
tables death*drinking*LowBirthWgt /nopercent norow chisq cmh; 
run;

title 'Test for Association between Low Birth Weight and death';
title2 '';
proc freq data=new_bwgt;* order=freq; 
tables LowBirthWgt*death/norow nopercent chisq relrisk riskdiff; 
run;
*/

title 'Two Way Model';
title2 'Death vs Smoking';
proc freq data=new_bwgt;
tables smoking*death/norow nopercent chisq relrisk;
run;

proc catmod data=new_bwgt;
   model smoking*death=_response_
         / noparm pred=freq;
   loglin death smoking;
run;

proc logistic data=new_bwgt plots=oddsratio;*where race ne 'Native';
class AgeGroup Death Drinking LowBirthWgt Married Smoking somecollege;
model death(event='Aff') = LowBirthWgt /expb;
run;

/*
title 'Two Way Model';
title2 'Low Birth Weight vs Smoking';
proc freq data=new_bwgt;
tables smoking*lowbirthwgt/norow nopercent chisq relrisk;
run;

proc catmod data=new_bwgt;
   model smoking*lowbirthwgt=_response_
         / noparm pred=freq;
   loglin lowbirthwgt smoking;
run;
*/

title 'Four-Way Model';
title2 'Death, Low Birth Weight Smoking and Drinking';
proc catmod data=new_bwgt;
   model death*smoking*lowbirthwgt*drinking=_response_
         / noparm pred=freq;
   loglin death|smoking|drinking|lowbirthwgt @ 2; 
run;

title2 'Final Model';
proc catmod data=new_bwgt;
   model death*smoking*lowbirthwgt*drinking*somecollege=_response_
         / noparm pred=freq;
   loglin death|smoking|drinking @ 2
          death|lowbirthwgt; 
run;
/*


proc logistic data=new_bwgt plots=oddsratio;*where race ne 'Native';
class AgeGroup Death Drinking LowBirthWgt Married Smoking somecollege;
model death(event='Aff') = 
             Drinking LowBirthWgt Married Smoking somecollege/expb;
run;
*/

proc logistic data=new_bwgt plots=(oddsratio effect) ;*where race ne 'Native';
class AgeGroup Death Drinking LowBirthWgt Married Smoking somecollege;
model death(event='Aff') = 
             Drinking LowBirthWgt Smoking /expb;
run;


ods latex close;


/* Stream a CSV representation of new_bwgt directly to the user's browser. *
/*
proc export data=new_bwgt
            outfile=_dataout
            dbms=csv replace;
run;

%let _DATAOUT_MIME_TYPE=text/csv;
%let _DATAOUT_NAME=bwgt.csv;