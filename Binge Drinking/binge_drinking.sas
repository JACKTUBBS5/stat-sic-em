libname ldata '/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Class';
options center nodate pagesize=120 ls=80;

*ods pdf; 
   ods graphics on;
/* Simplified LaTeX output that uses plain LaTeX tables  *
ods latex path='/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/clean'
 file='binge_drinking_rr.tex' style=journal 
stylesheet="sas.sty"(url="sas");

/*
http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 
*
ods graphics / reset width=5in  outputfmt=png
  antialias=on;
*/;

title 'Binge Drinking US 18-25 by gender';
data binge; set ldata.binge_drinking; 
rr = male/female;
ln_rr = log(rr);
drop var4; run;

proc print data=binge;var year rr ln_rr; run;

proc sgplot data=binge;
histogram rr;
run;

title2 'Relative Risk by year';
proc sgplot data=binge;
scatter y=rr x=year;
loess y=rr x=year;
run;

proc glm data=binge PLOT=MEANPLOT(CLBAND);
model rr = year / clm solution;
run;

proc loess data=binge plots=fitplot;
model rr = year / clm degree=2;
run;

proc kde data=binge ;
bivar year rr/bwm=.6;
run;

title2 'Log Relative Risk by year';
proc sgplot data=binge;
histogram ln_rr;
run;

proc sgplot data=binge;
scatter y=ln_rr x=year;
loess y=ln_rr x=year;
run;

proc glm data=binge PLOT=MEANPLOT(CLBAND);
model ln_rr = year / clm solution;
run;

proc loess data=binge plots=fitplot;
model ln_rr = year / clm degree=2;
run;

proc kde data=binge ;
bivar year ln_rr/bwm=.6;
run;

/************** using new_binge  ***************/;
title2 'Percent Binge by Gender';
data new_binge; set binge;
gender = 'male';   percent = male; output;
gender = 'female'; percent = female; output;
drop male female;
run;

proc sort data=new_binge; by gender; run;

proc print data=new_binge; var year percent; by gender; run;

proc sgplot data=new_binge;
scatter y=percent x=year;
reg y=percent x=year/ group=gender;
run;

proc sgplot data=new_binge;
scatter y=percent x=year;
loess y=percent x=year/ group=gender;
run;


title3 'Polynomial of degree 3';
/*******************************
Ill-Conditioned Data: 
		The ORTHOREG Procedure
PROC ORTHOREG performs linear least squares regression by using 
the Gentleman-Givens computational method (Gentleman 1972, 1973), 
and it can produce more accurate parameter estimates for 
ill-conditioned data. PROC GLM and PROC REG produce very 
ccurate estimates for most problems. However, if you have 
very ill-conditioned data, consider using PROC ORTHOREG. 
The collinearity diagnostics in PROC REG can help you 
determine whether PROC ORTHOREG would be useful.

********************************/;
proc orthoreg data=new_binge;
   effect xMod = polynomial(year / degree=2);
   class gender;
   model percent = gender | xMod;
   effectplot fit (x=year plotby=gender)/obs;
   store OStore;
run;

/*******************************
The PLM procedure, unlike most SAS/STAT procedures, 
does not operate primarily on an input data set. 
Instead, the procedure requires you to specify an 
item store with the RESTORE= option in the PROC PLM 
statement. The item store contains the necessary 
information and context about the statistical model 
that was fit when the store was created. SAS data 
sets are used only to provide input information in 
some circumstances. For example, when scoring a data 
set or when computing least squares means with 
specially defined population margins. In other words, 
instead of reading raw data and fitting a model, 
the PLM procedure reads the results of a model 
having been fit.

********************************/;

proc plm restore=OStore;
   score data=new_binge out=OStore_pred predicted=p;
run;

proc sgplot data=OStore_pred;
   series  y=p x=year / group=gender name="fit";
   scatter y=percent x=year / group=gender;
   keylegend "fit" / title="Group";
run;


title3 'Diff = female - male percent binge drinking';
proc plm restore=OStore;
   show effects;
   estimate "Diff at year=2015" gender 1 -1 gender*xMod
             [1,1  2015] [-1,2  2015] / cl;
   estimate "Diff at year=2016" gender 1 -1 gender*xMod
             [1,1  2016] [-1,2  2016] / cl;
   estimate "Diff at year=2017" gender 1 -1 gender*xMod 
             [1,1  2017] [-1,2  2017] / cl;
   estimate "Diff at year=2018" gender 1 -1 gender*xMod
             [1,1  2018] [-1,2  2018] / cl;
   estimate "Diff at year=2019" gender 1 -1 gender*xMod
             [1,1  2019] [-1,2  2019] / cl;
   estimate "Diff at year=2020" gender 1 -1 gender*xMod
             [1,1  2020] [-1,2  2020] / cl;
   estimate "Diff at year=2021" gender 1 -1 gender*xMod 
             [1,1  2021] [-1,2  2021] / cl;
run;

title3 'Bspline of degree=3';
proc orthoreg data=new_binge;
   class gender;
   effect spl = spline(year /basis=bspline degree=3);
   model percent = gender | spl / noint;
   store ortho_spline;
   effectplot fit (x=year plotby=gender)/obs;
   title 'B-splines Comparisons';
run;

proc plm restore=ortho_spline;
   score data=new_binge out=ortho_pred predicted=p;
run;

proc sgplot data=ortho_pred;
   series  y=p x=year / group=gender name="fit";
   scatter y=percent x=year / group=gender;
   keylegend "fit" / title="Group";
run;


title3 'Diff = female - male percent binge drinking';
proc plm restore=ortho_spline;
   show effects;
   estimate "Diff at year=2015" gender 1 -1 gender*spl 
             [1,1  2015] [-1,2  2015] / cl;
   estimate "Diff at year=2016" gender 1 -1 gender*spl 
             [1,1  2016] [-1,2  2016] / cl;
   estimate "Diff at year=2017" gender 1 -1 gender*spl 
             [1,1  2017] [-1,2  2017] / cl;
   estimate "Diff at year=2018" gender 1 -1 gender*spl 
             [1,1  2018] [-1,2  2018] / cl;
   estimate "Diff at year=2019" gender 1 -1 gender*spl 
             [1,1  2019] [-1,2  2019] / cl;
   estimate "Diff at year=2020" gender 1 -1 gender*spl 
             [1,1  2020] [-1,2  2020] / cl;
   estimate "Diff at year=2021" gender 1 -1 gender*spl 
             [1,1  2021] [-1,2  2021] / cl;
run;



/* Stream a CSV representation of new_bwgt directly to the user's browser. *

proc export data=new_binge
            outfile=_dataout
            dbms=csv replace;
run;

%let _DATAOUT_MIME_TYPE=text/csv;
%let _DATAOUT_NAME=new_binge_drinking.csv;

