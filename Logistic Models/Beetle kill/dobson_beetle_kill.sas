libname LDATA '/home/jacktubbs/my_shared_file_links/jacktubbs/myfolders/SAS Data Sets/';
options center nodate pagesize=100 ls=80;

/* Simplified LaTeX output that uses plain LaTeX tables  *
ods latex path='/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Output'
 file='beetle.tex' style=journal 
stylesheet="sas.sty"(url="sas");

/*
http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 
*
ods graphics / reset width=5in  outputfmt=png
  antialias=on;

*/
title1 'Dobson Table 7.2 Beetle mortality';		
data beetle; SET SASUSER.dobson_beetle; RUN;
data beetle; set beetle; rate=kill/number; 
run;
title2 'GLM Model for Rate';

title2 'Linear';
proc reg data=beetle plots=observedbypredicted;
  model rate = dose;
run;

title2 'PROBIT';
proc logistic data=beetle plots=effect;
model kill/number = dose/link=probit cl  ;
run;  

title2 'LOGIT';  
proc logistic data=beetle plots=effect;
  model kill/number = dose/link=logit expb cl ;
run;

title2 'CLOGLOG';
proc logistic data=beetle plots=effect;
  model kill/number = dose/link=cloglog cl ;
run;
