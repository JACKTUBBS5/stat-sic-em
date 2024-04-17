options center nodate pagesize=80 ls=70;
libname LDATA '/home/jacktubbs/my_shared_file_links/jacktubbs/myfolders/SAS Data Sets/';

/* Simplified LaTeX output that uses plain LaTeX tables  *
ods latex path='/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Class'
 file='prostrate_sel.tex' style=journal 
stylesheet="sas.sty"(url="sas");

/*
http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 
*
ods graphics / reset width=5in  outputfmt=png
  antialias=on;

*/;

title1 'HTpostrate Data';
data prostrate; set ldata.HTpostrate; 
high_lpsa = (lpsa > 3.5);        /*your choice for cut off  */
*drop lpsa;
run;

*proc contents data=prostrate short; 
run;

proc means data=prostrate q1 median q3;* where train = 'T';
var age gleason lbph lcavol lcp lweight pgg45; run;

*proc freq data=prostrate;* table train;* run;

proc sgplot data=prostrate;* where train = 'T';
histogram lpsa;
density lpsa;
density lpsa/ type= kernel;
run;

/*
proc sgplot data=prostrate;
vbox lpsa/group=train;
run;
*/

proc glmselect data=prostrate
plot=CriterionPanel; where train = 'T';
model lpsa = age gleason lbph lcavol lcp lweight pgg45 
            / selection=stepwise(select=SL stop=PRESS) ;
run;
/*
proc glmselect data=prostrate plots=(CriterionPanel ASE) seed=1;
partition fraction(validate=0.3 test=0.2) ;
model lpsa = age gleason lbph lcavol lcp lweight pgg45 
selection=forward(choose=validate stop=5) ;
run;

proc glmselect
data=prostrate plot=CriterionPanel; where train = 'T';
model lpsa = age gleason lbph lcavol lcp lweight pgg45 
             / selection=lasso (choose=CP steps=10) ;
run;

proc glmselect data=prostrate plot=CriterionPanel; where train = 'T';
model lpsa = age gleason lbph lcavol lcp lweight pgg45 
             / selection=ELASTICNET (choose=CP steps=10) ;
run;

proc reg data=prostrate outvif outest=b ridge=0 to .4 by .02;
             where train = 'T';
model lpsa = age gleason lbph lcavol lcp lweight pgg45 ;
run;

*proc print data=b;
run;

title2 'Regression';
proc hpsplit data=bodyfat cvmodelfit seed=123;
   class high_fat;
   model high_fat =
      abdomen age ankle biceps chest forearm hip ht 
      knee neck thigh wrist wt;
   grow entropy;
   prune costcomplexity;
run;

proc sgplot data=hpsplout;
reg y=mvalue x=p_mvalue;
run;



/* Stream a CSV representation of new_bwgt directly to the user's browser. */
/*
proc export data=prostrate
            outfile=_dataout
            dbms=csv replace;
run;

%let _DATAOUT_MIME_TYPE=text/csv;
%let _DATAOUT_NAME=high_prostrate.csv;
*/
title2 'Regression';

proc hpsplit data=prostrate seed=123 ;
*   class high_fat;
   model lpsa =
      age gleason lbph lcavol lcp  lweight pgg45 svi;
*   grow entropy;
*   prune costcomplexity;
partition fraction(validate=0.1 seed=1234);
output out=hpsplout;
run;
title2 'Predicted LPSA';
proc sgplot data=hpsplout;
scatter y=lpsa x=P_lpsa;
reg y=lpsa x=P_lpsa;

run;

proc hpforest data=prostrate maxtrees=40 inbagfraction=.3;;
   input age gleason lbph lcavol lcp  lweight pgg45 svi/level=interval;
   target lpsa/level=interval;
   score out=score;
   ods output  FitStatistics=fitstats(rename=(Ntrees=Trees)) ;
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


title2 'Predicted LPSA';
proc sgplot data=hpsplout;
scatter y=lpsa x=P_lpsa;
reg y=lpsa x=P_lpsa;

run;
title 'High_lpsa Analysis';
proc hpsplit data=prostrate assignmissing=similar cvmodelfit  seed=123 MINLEAFSIZE=10;
   class  high_lpsa;
   model high_lpsa(event='1') = age gleason lbph lcavol lcp lweight 
   pgg45 svi;
*   partition fraction(validate=0.2 seed=1234);
   grow entropy;
   prune costcomplexity;
*output out=hpsplout;* high_lpsa p_high_lpsa;
run;


proc hpforest data=prostrate maxtrees=30 INBAGFRACTION=.5 ;
   input age gleason lbph lcavol lcp  lweight pgg45 svi  /level=interval;
   target high_lpsa/level=binary;
   score out=ldata.score;
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
vbox P_high_lpsa1/group=high_lpsa;
run;


data temp; set ldata.score;
pred = (P_high_lpsa1 > .5);
run;

proc freq data=temp; 
tables high_lpsa * pred/nopercent norow relrisk oddsratio; run;



proc logistic data=prostrate  plots=(roc effect);
class high_lpsa /param=glm;
model high_lpsa (event = '1') = age lcavol  /expb;
output out=b predicted=pred;
run;

data temp; set b;
pred = (pred > .5);
run;

proc freq data=temp; 
tables high_lpsa * pred/nopercent norow relrisk oddsratio; run;

