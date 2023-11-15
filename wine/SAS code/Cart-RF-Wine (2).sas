libname files base "/home/u63546204/STA4382"; 

title1 'Wine Data SAS Analysis: Rita Dicarlo, Katie Clewett, Chang Guo';

data wine; set files.wines_red; 
run;

data Have;             /* the data to partition  */
   set files.wines_red;  
run;
/* If propTrain + propValid = 1, then no observation is assigned to testing */
%let propTrain = 0.6;         /* proportion of trainging data */
%let propValid = 0.3;         /* proportion of validation data */
%let propTest = %sysevalf(1 - &propTrain - &propValid);

/* create a separate data set for each role */
data Train Validate Test;
array p[2] _temporary_ (&propTrain, &propValid);
set Have;
call streaminit(123);         /* set random number seed */
/* RAND("table") returns 1, 2, or 3 with specified probabilities */
_k = rand("Table", of p[*]);
if      _k = 1 then output Train;
else if _k = 2 then output Validate;
else                output Test;
drop _k;
run;

*we now have three data sets, one to train the model, one to validate the model, and one to test the model;

title2 'Classification';

*modeling all wine data;
proc hpsplit data=Train cvmodelfit seed=123;
   class quality;
   model quality =vol_acidity  chlorides free_sulfur total_sulfur 
    pH sulphates alcohol;
   grow entropy;
   prune costcomplexity;
run;


proc hpforest data=Train maxtrees=100 inbagfraction=.3;
   input vol_acidity  chlorides free_sulfur total_sulfur 
    pH sulphates alcohol/level=interval;
   target quality/level=binary;
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


*now only checking for high quality wine, breaking it down by quality index > 6 or < 6;
title1 'High Quality Wine';
data validation_set; 
set validate;
high_quality = (quality > 6);
run;


title2 'Classification using validation data set';

proc logistic data=validation_set plots=roc;
class high_quality;
model high_quality = alcohol sulphates total_sulfur vol_acidity;
run;


proc hpsplit data=validation_set cvmodelfit seed=123;
   class high_quality;
   model high_quality =
      vol_acidity  total_sulfur 
    pH sulphates alcohol;
   grow entropy;
   prune costcomplexity;
run;






