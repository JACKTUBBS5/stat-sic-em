libname LDATA '/home/jacktubbs/my_shared_file_links/jacktubbs/myfolders/SAS Data Sets/';
options center nodate pagesize=100 ls=80;
*ods pdf; 
   ods graphics on;

/* Simplified LaTeX output that uses plain LaTeX tables  *
ods latex path='/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Output'
 file='body_fat_rf.tex' style=journal 
stylesheet="sas.sty"(url="sas");

/*
http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 
*
ods graphics / reset width=5in  outputfmt=png
  antialias=on;

*/

title1 'Body Fat Data';
data bodyfat; set ldata.bodyfat; 
high_fat = (per_fat > 24);
run;


title2 'Classification';
/*
proc logistic data=bodyfat plots=roc;
class high_fat;
model high_fat = abdomen wt;
run;
*/

proc hpsplit data=bodyfat cvmodelfit seed=123;
   class high_fat;
   model high_fat =
      abdomen age ankle biceps chest forearm hip ht 
      knee neck thigh wrist wt;
   grow entropy;
   prune costcomplexity;
run;


proc hpforest data=bodyfat maxtrees=100 inbagfraction=.3;
   input abdomen age ankle biceps chest forearm hip ht 
        knee neck thigh wrist wt/level=interval;
   target high_fat/level=binary;
   ods output FitStatistics=fitstats(rename=(Ntrees=Trees));
run;

data fitstats;
   set fitstats;
   label Trees = 'Number of Trees';
   label MiscAll = 'Full Data';
   label Miscoob = 'OOB';
run;

proc sgplot data=fitstats;
   title "OOB vs Training";
   series x=Trees y=MiscAll;
   series x=Trees y=MiscOob/lineattrs=(pattern=shortdash thickness=2);
   yaxis label='Misclassification Rate';
run;
title;


title2 'Regression';

proc hpsplit data=bodyfat cvmodelfit seed=123;
*   class high_fat;
   model per_fat =
      abdomen age ankle biceps chest forearm hip ht 
      knee neck thigh wrist wt;
*   grow entropy;
*   prune costcomplexity;
  output out=hpsplout;
run;


title2 'Classification';
proc hpforest data=bodyfat maxtrees=100 inbagfraction=.3;
   input abdomen age ankle biceps chest forearm hip ht 
        knee neck thigh wrist wt/level=interval;
   target per_fat/level=interval;
   ods output VariableImportance = variable;
   * FitStatistics=fitstats(rename=(Ntrees=Trees)) ;
run;

data fitstats;
   set fitstats;
   label Trees = 'Number of Trees';
   label MiscAll = 'Full Data';
   label Miscoob = 'OOB';
run;

proc sgplot data=fitstats;
   title "OOB vs Training";
   series x=Trees y=predall;
   series x=Trees y=predOob/lineattrs=(pattern=shortdash thickness=2);
   yaxis label='Average Squared Error';
run;
quit;

