options center nodate pagesize=100 ls=70;
libname LDATA '/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/';

/* Simplified LaTeX output that uses plain LaTeX tables  */
ods latex path='/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/'
 file='cheese_rater.tex' style=journal 
stylesheet="sas.sty"(url="sas");

/*
http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 
*/
ods graphics / reset width=5in  outputfmt=png
  antialias=on;


title 'Example 1';
title2 'Aspirin use and Myocardinal Infarction';
data aspirin;
 input group $ disease $ count @@;
 datalines;
 placebo yes 189    placebo no 10845  
 aspirin yes 104    aspirin no 10933  
 ;
 proc freq data = aspirin order=data; weight count;
       tables group*disease / chisq oddsratio relrisk riskdiff nocol nopercent nocum;
run;

title2 'Liver Screening Test';
data liver;
   input test $ Disease $ count @@;
   datalines;
   positive  yes 231      positive no 32
   negative yes  27      negative no 54
;   
proc freq data=liver order=data; weight count;
       tables test*disease /  norow nocum nopercent;
run;

proc logistic data=liver noprint;
class test disease;
model disease(event='yes')=test /outroc=rocs; freq count;
run;
data rocs;
set rocs;
sensitivity=_sensit_;
specificity=1-_1mspec_;

   do i = .025 to .75 by .025;
prevalence=i; 
PPV=(sensitivity*prevalence)/((sensitivity*prevalence) +
    (1-specificity)*(1-prevalence)); 
NPV=(specificity*(1-prevalence)) / ((1-sensitivity)*prevalence +
    specificity*(1-prevalence));    
False_pos = 1 - PPV;
False_neg = 1 - NPV;
miss_class = prevalence*(1 - sensitivity) + ( 1 - specificity)*(1 - prevalence);
   output; 
   end; 
drop _sensit_;
run;
data rocs;set rocs; if specificity gt 0;run;
proc print data=rocs label;
var prevalence sensitivity specificity PPV false_pos NPV false_neg miss_class;
format PPV false_pos NPV false_neg miss_class 4.2;
run;

title3 'False Positives';
proc sgplot data=rocs;
series y=False_pos x=prevalence;
run;

title3 'False Negatives';
proc sgplot data=rocs;
series y=False_neg x=prevalence;
run;

title3 'Miss Classification';
proc sgplot data=rocs;
series y=miss_class x=prevalence;
run;

title 'Example 3';
title2 'Soft Drink Choice';
title3 ' ';

data soft;
      input gender $ country $ question $ count @@;
      datalines;
   male   American  y 29 male   American  n  6
   male   British   y 19 male   British   n 15
   female American  y  7 female American  n 23
   female British   y 24 female British   n 29
   ;
proc freq order=data;
      weight count;
	  tables country*question/chisq riskdiff nocol nopercent relrisk oddsratio;
title3 'Combined Table';
 run;
   
proc freq order=data;
      weight count; 
      tables gender*country*question / 
           chisq cmh nocol nopercent relrisk oddsratio;
title3 'Tables for each gender';
run; 



ods graphics off;
ods tagsets.simplelatex close;

