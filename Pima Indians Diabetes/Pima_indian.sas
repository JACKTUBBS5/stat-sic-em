libname ldata  '/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Class/s4382-2024' ;
title1 'Pima Indian Diabetes Data';

/*
DESCRIPTION
Predict the onset of diabetes based on diagnostic measures.
SUMMARY
This dataset is originally from the National Institute of Diabetes 
and Digestive and Kidney Diseases. The objective is to predict 
based on diagnostic measurements whether a patient has diabetes.

Several constraints were placed on the selection of these instances 
from a larger database. In particular, all patients here are females 
at least 21 years old of Pima Indian heritage.

Pregnancies: 	Number of times pregnant
Glucose: 		Plasma glucose concentration a 2 hours 
				in an oral glucose tolerance test
BloodPressure: 	Diastolic blood pressure (mm Hg)
SkinThickness: 	Triceps skin fold thickness (mm)
Insulin: 		2-Hour serum insulin (mu U/ml)
BMI: 			Body mass index (weight in kg/(height in m)^2)
DiabetesPedigreeFunction: Diabetes pedigree function
Age: 			Age (years)
Outcome: 		Class variable (0 or 1)

Inspiration:

some values are not in the range where they are supposed to be, 
should be treated as missing value.
What kind of method is better to use to fill this type of missing value? 
How further clasification will be like?
Is there any sub-groups significantly more likely to have diabetes?

*/

data pima; set ldata.pimaindian; run;
*proc contents varnum; run;
proc contents short; run;

data pima; set pima;
bp = BloodPressure;
d_ped = DiabetesPedigreeFunction;
preg = Pregnancies;
skin = SkinThickness;
drop BloodPressure DiabetesPedigreeFunction 
   Pregnancies SkinThickness;
run;

title2 'Scatterplot of Pima Indian Data';
proc sgscatter data=pima;
matrix d_ped Age BMI bp  Glucose Insulin preg Skin
  		/diagonal=(histogram normal);
run;
  /*
proc sgscatter data=new_bfat;
  matrix per_fat density thigh knee ankle biceps forearm  wrist
  /diagonal=(histogram normal);run;
*/
title2 'Simple Descriptive Statistics';
proc means data=pima;
var d_ped Age BMI bp  Glucose Insulin preg Skin ;
run;

proc sgplot data=pima;
histogram d_ped;
density d_ped/type=kernel;
run;

ods select BasicMeasures Quantiles TrimmedMeans WinsorizedMeans RobustScale;
proc univariate data=pima trim=.05 winsor=.05 robustscale;
var d_ped Glucose Insulin ;
run;

title2 'Test for Normality';
ods select TestsForNormality;
  proc univariate data=pima normal;
var d_ped Glucose Insulin ;
run;

proc univariate data=pima normal noprint;
var d_ped Glucose Insulin ;
histogram var Glucose Insulin /normal ;
run;

title2 'Box Cox for d_ped';
proc transreg data=pima;
model BoxCox(d_ped / convenient lambda=-2 to 2 by 0.05) =
         monotone(insulin);
output out=new; 
run;
title3 'Modified d_ped measurement';

proc sgplot data=new; 
histogram td_ped;
density td_ped;
run;

proc kde data=new; 
univar td_ped;
run;

proc univariate normal data=new;
var td_ped;
run;

