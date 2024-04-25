libname ldata  '/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Class/s4382-2024' ;
title1 'Pima Indian Diabetes Data';

*part 2 of the analysis of these data;

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

data temp; set ldata.pimaindian; run;
*proc contents varnum; run;
proc contents short; run;

data pima; set temp;
bp = BloodPressure;
d_ped = DiabetesPedigreeFunction;
preg = Pregnancies;
skin = SkinThickness;
drop BloodPressure DiabetesPedigreeFunction 
   Pregnancies SkinThickness;
run;

proc sort data=pima; by outcome; run;

proc means data = pima n min q1 median mean q3 max std; 
var Age BMI Glucose Insulin Outcome bp d_ped preg skin; 
run;

proc means data = pima n min q1 median mean q3 max std; 
var Age BMI Glucose Insulin Outcome bp d_ped preg skin; 
 by outcome; 
run;

title2 'Modeling d_ped';
proc glm data=pima;
class outcome;
model d_ped = Age BMI Glucose Insulin Outcome bp preg skin/solution ss3;
run;

title3 'reduced model';
proc glm data=pima plots=fitplot;
class outcome;
model d_ped = Insulin Outcome skin/solution ss3;
run;

title2 'Modeling d_ped';
title3 ' ';
proc logistic data=pima;* plots=(roc effect);
class outcome /param=glm;
model outcome(event='1') = d_ped Age BMI Glucose Insulin bp preg /expb;
run;

title2 'Modeling d_ped';
title3 'reduced model';
proc logistic data=pima plots=(roc effect);
class outcome /param=glm;
model outcome(event='1') = d_ped BMI Glucose bp preg /expb;
run;


proc hpsplit data=pima ASSIGNMISSING=popular cvmodelfit;* seed=123;* where validation = 1;
   class  outcome;
   model outcome(event='1') = d_ped Age BMI Glucose Insulin bp preg;
*  partition fraction(validate=0.2 seed=1234);
   grow entropy;
   prune costcomplexity;
run;


title2 'Classification';
proc hpforest data=pima maxtrees=25 INBAGFRACTION=.3 ;
   input d_ped Age BMI Glucose Insulin bp preg  /level=interval;
*   input CRating CCard_NUMBER /level=ordinal;
*   input currentSmoker prevalentStroke /level=nominal;
   target outcome/level=binary;
   score out=ldata.score;
 *  save file = ldata;
   ods output VariableImportance = variable
              FitStatistics=fitstats(rename=(Ntrees=Trees));
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

title2 'Predicted Survival';
proc sgplot data=ldata.score;
vbox P_outcome1/group=outcome;
run;

data temp; set ldata.score;
pred = (P_outcome1 > .5);
run;

proc freq data=temp; 
tables outcome * pred/nopercent norow relrisk oddsratio; run;


proc logistic data=pima descending plots=roc;*where race ne 'Native';
*class TenYearCHD currentSmoker prevalentStroke/param=glm;
model outcome (event = '1') =  d_ped Age Glucose Insulin /expb;
output out=b predicted=pred;
run;

data temp; set b;
pred = (pred > .5);
run;

proc freq data=temp; 
tables outcome * pred/nopercent norow relrisk oddsratio; run;


proc logistic data=pima descending plots=roc;*where race ne 'Native';
*class TenYearCHD currentSmoker prevalentStroke/param=glm;
model outcome (event = '1') =  d_ped Age Glucose /expb;
output out=b predicted=pred;
run;

data temp; set b;
pred = (pred > .5);
run;

proc freq data=temp; 
tables outcome * pred/nopercent norow relrisk oddsratio; run;


*Using a mathmatical method for dimension reduction;

title 'Finding PC';
proc princomp data=pima  out=PCmeasures standard
              plots=patternprofile;
var Age BMI Glucose Insulin Outcome bp d_ped preg skin;  
run;

proc logistic desc data=PCmeasures plots = (effect roc);
model outcome =Prin1 - prin5/link=logit; 
*	roc prin1;						
run;

proc logistic desc data=PCmeasures plots = (effect roc);
model outcome =Prin1 prin2/link=logit; 
*	roc prin1;			
effectplot;			
output out=b predicted=pred;
run;

data temp; set b;
pred = (pred > .5);
run;

proc freq data=temp; 
tables outcome * pred/nopercent norow relrisk oddsratio; run;


*
ods latex close;

/* Stream a CSV representation of new_bwgt directly to the user's browser. */
/*
proc export data=new_frame
            outfile=_dataout
            dbms=csv replace;
run;

%let _DATAOUT_MIME_TYPE=text/csv;
%let _DATAOUT_NAME=fram_project.csv;
