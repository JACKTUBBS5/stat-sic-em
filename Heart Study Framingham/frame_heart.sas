options center nodate pagesize=120 ls=80;
libname ldata  '/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Class/s4382-2024' ;

/* Simplified LaTeX output that uses plain LaTeX tables  *
ods latex path='/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Class'
 file='frame_heart.tex' style=journal 
stylesheet="sas.sty"(url="sas");

/*
http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 
*
ods graphics / reset width=5in  outputfmt=png
  antialias=on;

/*
The Sashelp.heart data set provides results from the Framingham Heart Study. 
The following steps display information about the data set Sashelp.heart. 
The data set contains 5,209 observations.
*/

title "Framingham Heart Study";
data frame; set ldata.framingham; run;
proc contents data=frame short;run;

title2 "The First Five Observations";
proc print data=frame(obs=5) noobs;
run;

title2 'New Sample of Size 2500';
proc surveyselect data=frame out=new_frame method=srs n=2500
                  seed=2024;
run;

proc means data=new_frame;
var BMI BPMeds ID TenYearCHD age cigsPerDay currentSmoker diaBP
 diabetes education glucose heartRate male 
 prevalentHyp prevalentStroke sysBP totChol;
run;

proc freq data=new_frame;
tables male*TenYearCHD*( currentSmoker prevalentStroke);
run;

proc sort data=new_frame; by TenYearCHD; 
run;

proc means data = new_frame n min q1 median mean q3 max std; 
var BMI age cigsPerDay diaBP glucose heartRate sysBP totChol; 
run;

proc means data = new_frame n min q1 median mean q3 max std; 
var BMI age cigsPerDay diaBP glucose heartRate sysBP totChol; 
 by TenYearCHD; 
run;

title2 'Model the Event of having CHD > 10 years';

proc logistic data=new_frame plots=(roc effect);
class currentSmoker prevalentStroke TenYearCHD /param=glm;
model TenYearCHD(event='1') = age male sysBP
                            currentSmoker prevalentStroke /expb;
run;

proc hpsplit data=new_frame ASSIGNMISSING=popular cvmodelfit;* seed=123;* where validation = 1;
   class  TenYearCHD;
   model TenYearCHD(event='1') = male age  
                            heartRate sysBP totChol male  
                            currentSmoker prevalentStroke;
 *  partition fraction(validate=0.2 seed=1234);
   grow entropy;
   prune costcomplexity;
run;

proc hpforest data=new_frame maxtrees=25 INBAGFRACTION=.3 ;
   input BMI age cigsPerDay diaBP glucose 
         heartRate sysBP totChol  /level=interval;
 *  input CRating CCard_NUMBER /level=ordinal;
   input currentSmoker prevalentStroke /level=nominal;
   target TenYearCHD/level=binary;
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
vbox P_TenYearCHD1/group=TenYearCHD;
run;

data temp; set ldata.score;
pred = (P_TenYearCHD1 > .5);
run;

proc freq data=temp; 
tables TenYearCHD * pred/nopercent norow relrisk oddsratio; run;

title3 'Full Model';
proc logistic data=new_frame descending plots=roc;*where race ne 'Native';
class TenYearCHD currentSmoker prevalentStroke/param=glm;
model TenYearCHD (event = '1') = BMI age cigsPerDay diaBP glucose 
         heartRate sysBP totChol currentSmoker prevalentStroke/expb;
output out=b predicted=pred;
run;


data temp; set b;
pred = (pred > .5);
run;

proc freq data=temp; 
tables TenYearCHD * pred/nopercent norow relrisk oddsratio; run;


title3 'Reduced Model';

proc logistic data=new_frame  plots=(roc effect);
class TenYearCHD currentSmoker prevalentStroke/param=glm;
model TenYearCHD (event = '1') = age cigsPerDay  glucose 
         sysBP prevalentStroke/expb;
output out=b predicted=pred;
run;

data temp; set b;
pred = (pred > .5);
run;


proc freq data=temp; 
tables TenYearCHD * pred/nopercent norow relrisk oddsratio; run;




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
