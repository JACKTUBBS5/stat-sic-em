libname ldata  '/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Class/s4382-2024' ;
title1 'Obesity Level Data';

/*
Overview:

This dataset provides comprehensive information on individuals, 
encompassing key attributes such as gender, age, 
height, weight, family history with overweight, dietary habits, 
physical activity, transportation mode, and the 
corresponding obesity level. 

Assignment Build model to predict obesity level.

Tags:

Gender
Age
Height
Weight
Family_history_with_overweight
FAVC (Frequent consumption of high-caloric food)
FCVC (Frequency of consumption of vegetables)
NCP (Number of main meals)
CAEC (Consumption of food between meals)
SMOKE
CH2O (Daily water consumption)
SCC (Caloric beverages consumption)
FAF (Physical activity frequency)
TUE (Time spent using technological devices)
CALC (Consumption of alcohol)
MTRANS (Mode of transportation)
0be1dad (Target variable representing obesity level)
*/

/*
data ob_level; set ldata.obesitylevel; run;
*proc contents varnum; run;
proc contents short; run;

data temp; set ob_level;
target = '0be1dad'n ;
history = family_history_with_overweight;
trans = (mtrans='Public_Transportation');
drop '0be1dad'n  family_history_with_overweight mtrans;

run;
*/
/*
*  Data set is too large;
title2 'Simple Random Sampling of size = 1500';
proc surveyselect data=temp
   method=srs n=1500 out=obesity seed = 12345;
run;
*/

data obesity; set ldata.obesity; run; 

proc freq data=obesity;
tables target CAEC  Gender TRANS history;
run; 

 /*
title2 'Scatterplot of Obesity Data';
proc sgscatter data=obesity;
matrix Age CH2O FAF FAVC FCVC  
			Height NCP SCC SMOKE TUE Weight
			/diagonal=(histogram normal);
run;
 
proc sgscatter data=new_bfat;
  matrix per_fat density thigh knee ankle biceps forearm  wrist
  /diagonal=(histogram normal);run;
*/
title2 'Simple Descriptive Statistics';
proc means data=obesity;
var Age CH2O FAF FAVC FCVC  
			Height NCP SCC SMOKE TUE Weight;
run;

proc sgplot data=obesity;
histogram Age;
density Age/type=kernel;
run;

ods select BasicMeasures Quantiles TrimmedMeans WinsorizedMeans RobustScale;
proc univariate data=obesity trim=.05 winsor=.05 robustscale;
var Age FAF FAVC ;
run;

title2 'Test for Normality';
ods select TestsForNormality;
  proc univariate data=obesity normal;
var Age FAF FAVC;
run;

proc univariate data=obesity normal noprint;
var Age FAF FAVC ;
histogram Age FAF FAVC /normal ;
run;

title2 'Box Cox for Age';
proc transreg data=obesity;
model BoxCox(Age / convenient lambda=-1.5 to 1.25 by 0.05) =
         monotone(weight);
output out=new; 
run;
title3 'Modified Age measurement';

proc sgplot data=new; 
histogram tAge;
density tAge;
run;
/*
proc kde data=new; 
univar tAge;
run;
*/
proc univariate normal data=new;
var tAge;
run;



/*************************************/;
/* Stream a CSV representation of new_bwgt directly to the user's browser. */
/*
proc export data=obesity
            outfile=_dataout
            dbms=csv replace;
run;

%let _DATAOUT_MIME_TYPE=text/csv;
%let _DATAOUT_NAME=obesity.csv;

