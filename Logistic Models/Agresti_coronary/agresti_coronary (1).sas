libname LDATA '/home/jacktubbs/my_shared_file_links/jacktubbs/myfolders/SAS Data Sets/';
options center nodate pagesize=100 ls=80;

/* Simplified LaTeX output that uses plain LaTeX tables  *
ods latex path='/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/clean'
 file='coronary3.tex' style=journal 
stylesheet="sas.sty"(url="sas");

/*
http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 
*
ods graphics / reset width=5in  outputfmt=png
  antialias=on;

*/



title 'Agresti Coronary Example 1';

data coronary;
  input sex ecg ca count @@;
datalines;
0 0 0  11 0 0 1  4
0 1 0  10 0 1 1  8
1 0 0   9 1 0 1  9
1 1 0   6 1 1 1 21
;
run;
title2 'LOGIT Link';
proc logistic data=coronary desc plots=(oddsratio);
class sex ecg;
      freq count;
      model ca=sex ecg / expb scale=none aggregate;
   output out=predict pred=prob;
run;
   data predict; set predict; prob = 1 - prob; drop _level_;

proc print data=predict;  
run;

title2 'CLOGLOG Link';
proc logistic data=coronary desc plots=(oddsratio);
class sex ecg;
      freq count;
      model ca=sex ecg / scale=none aggregate link=cloglog;
   output out=predict pred=prob;
run;
   data predict; set predict; prob = 1 - prob; drop _level_;

proc print data=predict;  
run;
  

title 'Agresti Coronary Example 2';

data coronary2;
  input sex ecg age ca @@  ;
datalines;
   0 0 28 0   1 0 42 1    0 1 46 0  1 1 45 0
   0 0 34 0   1 0 44 1    0 1 48 1  1 1 45 1
   0 0 38 0   1 0 45 0    0 1 49 0  1 1 45 1
   0 0 41 1   1 0 46 0    0 1 49 0  1 1 46 1
   0 0 44 0   1 0 48 0    0 1 52 0  1 1 48 1
   0 0 45 1   1 0 50 0    0 1 53 1  1 1 57 1
   0 0 46 0   1 0 52 1    0 1 54 1  1 1 57 1
   0 0 47 0   1 0 52 1    0 1 55 0  1 1 59 1
   0 0 50 0   1 0 54 0    0 1 57 1  1 1 60 1
   0 0 51 0   1 0 55 0    0 2 46 1  1 1 63 1
   0 0 51 0   1 0 59 1    0 2 48 0  1 2 35 0
   0 0 53 0   1 0 59 1    0 2 57 1  1 2 37 1
   0 0 55 1   1 1 32 0    0 2 60 1  1 2 43 1
   0 0 59 0   1 1 37 0    1 0 30 0  1 2 47 1
   0 0 60 1   1 1 38 1    1 0 34 0  1 2 48 1
   0 1 32 1   1 1 38 1    1 0 36 1  1 2 49 0
   0 1 33 0   1 1 42 1    1 0 38 1  1 2 58 1
   0 1 35 0   1 1 43 0    1 0 39 0  1 2 59 1
   0 1 39 0   1 1 43 1    1 0 42 0  1 2 60 1
   0 1 40 0   1 1 44 1
   ;
run;
data coronary2; set coronary2; ecg = (ecg > 0);

title2 'LOGIT Link';
proc logistic  plots=(oddsratio effect);
class sex ecg;
   model ca(event='1')=age sex ecg /expb;
run;


title2 'CLOGLOG Link';
proc logistic  plots=(effect);
class sex ecg;
   model ca(event='1')=age sex ecg/link=cloglog;
run;

ods latex close;

quit;
