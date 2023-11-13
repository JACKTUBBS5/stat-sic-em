libname files base "/home/u63546204/STA4382"; 

title1 'Wine Data SAS Analysis: Rita Dicarlo, Katie Clewett, Chang Guo';
data wine; set files.wines_red; 
run;


title2 'Classification';


proc hpsplit data=wine cvmodelfit seed=123;
   class quality;
   model quality =vol_acidity  chlorides free_sulfur total_sulfur 
    pH sulphates alcohol;
   grow entropy;
   prune costcomplexity;
run;


proc hpforest data=wine maxtrees=100 inbagfraction=.3;
   input vol_acidity  chlorides free_sulfur total_sulfur 
    pH sulphates alcohol/level=interval;
   target quality/level=binary;
   ods output FitStatistics=fitstats(rename=(Ntrees=Trees));
run;


title1 'High Quality Wine';
data wine; 
set files.wines_red; 
high_quality = (quality > 6);
run;


title2 'Classification';

proc logistic data=wine plots=roc;
class high_quality;
model high_quality = alcohol sulphates;
run;

proc hpsplit data=wine cvmodelfit seed=123;
   class high_quality;
   model high_quality =
      vol_acidity  chlorides free_sulfur total_sulfur 
    pH sulphates alcohol;
   grow entropy;
   prune costcomplexity;
run;



