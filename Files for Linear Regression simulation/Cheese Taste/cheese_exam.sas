options center nodate pagesize=100 ls=70;
libname LDATA '/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/';

/* Simplified LaTeX output that uses plain LaTeX tables  *
ods latex path='/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Output'
 file='cheese_taste_2.tex' style=journal 
stylesheet="sas.sty"(url="sas");
/*
As cheddar cheese matures, a variety of chemical processes 
take place. The taste of matured cheese is related to the concentration 
of several chemicals in the final product. In a study of cheddar cheese
from the LaTrobe Valley of Victoria, Australia, samples of cheese were analyzed
for their chemical composition and were subjected to taste tests. 
Overall taste scores were obtained by combining the scores from several tasters.
*

ods graphics / reset width=5in  outputfmt=png
  antialias=on;
*/
 title1 'Cheese Data ';
 data cheese;set ldata.cheese;
 run ;

proc means;var taste lactic h2s; run; 
run;
 title2 'Linear Fit for Taste = Lactic';
proc reg data=cheese plots=fitplot;
   model taste = lactic/corrb b;
run;


 title2 'Linear Fit for Taste = H2S';
proc reg data=cheese plots=fitplot;
   model taste = h2s/corrb b;
run;   
quit;

