libname leo  '/home/jacktubbs/my_shared_file_links/jacktubbs/myfolders/Stamey_police' ;
title1 'Police Data';

data temp1; set leo.data_new2a; n=_N_;
wt=weight;
drop weight;
run;

/*data leo.data_news4382; set temp1; run;*/

*proc contents data=temp1 short; run;
proc contents data=temp1 varnum; run;

*********************************************************;
/*
AGE ApoB BMI Gender HDL HR HTN HbA1c ID1 IR Insulin LDL 
LpPLA2 TC TG hc_CRP high_bp leo n new_cvd pla2_out sdLDL_C wt
*/
*********************************************************;
title2 'Descriptive Statistics';
proc means data=temp1; 
var AGE ApoB BMI HDL HR HbA1c ID1 IR Insulin LDL LpPLA2 TC TG 
hc_CRP sdLDL_C wt; run;

proc freq data=temp1; tables leo*(gender pla2_out htn) ; run;

proc sgplot data=temp1;
density age / type=kernel;
histogram age ;
run;

proc sgplot data=temp1;
density wt / type=kernel;
histogram wt;


title2 'Modelling a Biomarker{pla2_out} for Heart Disease';

proc logistic data=temp1 plots=(effect roc);
class gender leo pla2_out;
 model pla2_out(event='1') = LDL leo gender ;
 output out=pred p=phat lower=lcl upper=ucl
             predprob=(individual crossvalidate);
run;

title3 'CART Models';
proc hpsplit data=temp1 ASSIGNMISSING=popular cvmodelfit;
						* seed=123;* where validation = 1;
class gender leo pla2_out;
   model pla2_out(event='1') = gender leo AGE ApoB BMI HDL HR 
   HbA1c ID1 IR Insulin LDL TC TG 
   hc_CRP sdLDL_C wt;
*  partition fraction(validate=0.2 seed=1234);
   grow entropy;
   prune costcomplexity;
run;

title3 'Random Forest Models';
proc hpforest data=temp1 maxtrees=25 INBAGFRACTION=.3 ;
   input AGE ApoB BMI HDL HR 
   			HbA1c ID1 IR Insulin LDL TC TG 
   			hc_CRP sdLDL_C wt  /level=interval;
*  input CRating CCard_NUMBER /level=ordinal;
   input gender leo  /level=nominal;
   target pla2_out/level=binary;
   score out=leo.score;
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
proc sgplot data=leo.score;
vbox P_pla2_out1/group=leo;
run;

data temp; set leo.score;
pred = (P_pla2_out1 > .5);
run;

proc freq data=temp; 
tables pla2_out * pred/nopercent norow relrisk oddsratio; run;

proc logistic data=temp1 plots=(effect roc);
class gender leo pla2_out;
 model pla2_out(event='1') = LDL leo gender IR;
 output out=pred p=phat lower=lcl upper=ucl
             predprob=(individual crossvalidate);
run;


ods latex close;
quit;

/* Stream a CSV representation of new_bwgt directly to the user's browser. */
/*
proc export data=temp1
            outfile=_dataout
            dbms=csv replace;
run;

%let _DATAOUT_MIME_TYPE=text/csv;
%let _DATAOUT_NAME=LEO_project.csv;


