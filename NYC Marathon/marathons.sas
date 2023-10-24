libname ldata '/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Class';
options center nodate pagesize=120 ls=80;


/*
data ldata.NYCmarathon_females; set work.import; run;
*/
/***************************************************
*************Male Data******************************
***************************************************/;

title 'NYC Marathon';
title2 'Male Times';
data NYCmales; set ldata.NYCmarathon_males;
nyc_rt = input(time, best12.);
gender = 'males';
if year = 1972 then base = nyc_rt;
if year > 1972; if time ne '.';
perform = 100*(8872 - nyc_rt)/8872;
run;
*proc contents; run; 
proc sort; by year; run;
proc print; *where year > 2000; 
run;

proc sgplot data=nycmales;
histogram perform;
density perform/type=kernel;
run;

proc orthoreg data=nycmales;
   effect xMod = polynomial(year / degree=3);
   model perform = xMod;
   effectplot fit / obs;
   store OStore;
run;


/***************************************************
*************Female Data****************************
***************************************************/;


title 'NYC Marathon';
title2 'Female Times';
data NYCfemales; set ldata.NYCmarathon_females;
nyc_rt = input(time, best12.);
gender = 'femal';
if year = 1972 then base = nyc_rt;
if year > 1972; if time ne '.';
perform = 100*(11321 - nyc_rt)/11321;
run;
*proc contents; run; 
proc sort; by year; run;
proc print; *where year > 2000; 
run;

proc sgplot data=nycfemales;
histogram perform;
density perform/type=kernel;
run;

proc orthoreg data=nycfemales;
   effect xMod = polynomial(year / degree=3);
   model perform = xMod;
   effectplot fit / obs;
   store OStore;
run;


/***************************************************
*********Combined Data******************************
***************************************************/;

title2 ' ';
data ldata.NYCmarathon; set nycmales nycfemales;* by year; run;
data NYCmarathon; set ldata.NYCmarathon; run;

proc sgplot data=nycmarathon;
scatter y=time x=year/group=gender;
series y=time x=year/group=gender;
run;

data nycmarathon; set nycmarathon;
win_time= nyc_rt/3600;
run;

proc glm data=nycmarathon  plots=all;*where year > 2000; 
class gender;
model win_time=year | gender/solution;
run;

proc univariate data=nycmarathon normal plots  ;
var perform; class gender;
run;

proc npar1way data=nycmarathon edf wilcoxon;
class gender;
var perform;
run;

proc glm data=nycmarathon  plots=all;*where year > 2000; 
class gender;
model perform=year | gender/clm solution;
run;

proc orthoreg data=nycmarathon;
   effect xMod = polynomial(year / degree=3);
   class gender;
   model perform = xMod | gender;
   effectplot fit (plotby=gender)/obs;
   store OStore;
run;


