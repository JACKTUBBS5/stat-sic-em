/* chapter 2 */

data pathologists;
 infile 'c:\AMSUS\data\pathologists.dat';
 input A B C D E F G;
run;
proc means data=pathologists;
  var a--g;
run;


proc freq data=pathologists;
  tables a*b*c*d*e*f*g /noprint agree ;
run;

ods output McNemarsTest=mcn;
proc freq data=pathologists;
  tables a*(b--g)
         b*(c--g)
     c*(d--g)
     d*(e--g)
     e*(f--g)
     f*g
   / agree noprint;
run;

proc transpose data=mcn out=mcn2;
 var nvalue1;
 id name1;
 idlabel label1;
 by table;
run;
proc sort data=mcn2; by p_mcnem; run;
proc print label;
 format p_mcnem pvalue6.4;
run;

data p12;
 do p1=1 to 5;
   do p2=1 to 5;
   input num @;
   output;
   end;
 end;
datalines;
22 2 2 0 0
5 7 14 0 0
0 2 36 0 0
0 1 14 7 0
0 0 3 0 3
;


proc freq data=p12;
 tables p1*p2 /agree;
 weight num;
run;


data cat_scan;
 infile 'c:\AMSUS\data\cat_scan.dat' firstobs=2;
 input plan1-plan3 pix1-pix3;
 patient=_n_;
run;

proc means data=cat_scan;
 var plan1-plan3 pix1-pix3;
run;

ods graphics off;
proc corr data=cat_scan nosimple;
 var plan1-plan3 pix1-pix3;
run;

data cat_long;
 set cat_scan;
 array pl {*} plan1-plan3 pix1-pix3;
 do i=1 to 6;
  rater=i;
  type='plan';
  vbr=pl{i};
  if i>3 then do;
         rater=i-3;
         type='pix';
         end;
  output;
 end;
 keep patient rater type vbr;
run;

proc sort data=cat_long; by type; run;
proc anova data=cat_long;
   class rater patient;
   model vbr=rater patient;
by type;
run;


%macro PPV_NPV(data=_last_,test=test,true=true,prevalence=.5);
* macro to calculate PPV and NPV;
proc freq data=&data;
  tables &test*&true / out=freqs;
run;
proc transpose data=freqs out=cells prefix=c;
var count;
id  &test &true;
run;
data cells;
  set cells;
  sensitivity=c11/(c11+c01);
  specificity=c00/(c00+c10);
  prevalence=&prevalence;
  PPV=(sensitivity*prevalence) / ((sensitivity*prevalence) + (1-specificity)*(1- prevalence));
  NPV=(specificity*(1- prevalence)) / ((1-sensitivity)*prevalence + specificity*(1- prevalence));
run;
proc print noobs; 
 var sensitivity--NPV;
run;
%mend;
* example usage - liver.dat contains the 344 individual ratings summarised in table 2.11 coded 0/1;
data liver;
 infile 'c:\AMSUS\data\liver.dat';
 input scan autopsy;
run;
%PPV_NPV(data=liver,test=scan,true=autopsy,prevalence=.5)
%PPV_NPV(data=liver,test=scan,true=autopsy,prevalence=.1)


data imaging;
do disease= 0 to 1;
 do rating=1 to 5; 
 input count @;
 output;
 end;
end;
datalines;
28  14  5   2   1
2   4   10  14  20
;
proc sgplot data=imaging;
  vbar rating /group=disease freq=count;
run;

proc logistic data=imaging ;
  model disease(event='1')=rating /outroc=rocs;
  freq count;
run;
data rocs;
  set rocs;
  sensitivity=_sensit_;
  specificity=1-_1mspec_;
  prevalence=0.5;
  PPV=(sensitivity*prevalence) / ((sensitivity*prevalence) + (1-specificity)*(1- prevalence));
  NPV=(specificity*(1- prevalence)) / ((1-sensitivity)*prevalence + specificity*(1- prevalence));
  drop _sensit_;
run;

proc print data=rocs label;
format PPV NPV 4.2;
run;

ods graphics on;
proc logistic data=imaging ;
  model disease(event='1')=rating /outroc=rocs;
  freq count;
run;
ods graphics off;

data imaging2;
 infile 'c:\AMSUS\data\imaging.dat';
 input disease rating1 rating2;
run;

ods graphics on;
ods rtf select ROCOverlay ROCContrastTest;
proc logistic data=imaging2; 
  model disease(event=last)= rating1 rating2 /nofit;
  roc 'rater 1' rating1;
  roc 'rater 2' rating2;
  roccontrast;
run;
ods graphics off;


