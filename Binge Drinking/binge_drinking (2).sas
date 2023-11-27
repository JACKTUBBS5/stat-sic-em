libname ldata '/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Class';
options center nodate pagesize=120 ls=80;



title 'Binge Drinking US 18-25 by gender';
data binge; set ldata.binge_drinking; 
rr = male/female;
ln_rr = log(rr);
drop var4; run;

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

proc sgplot data=new_binge;
scatter y=percent x=year;
reg y=percent x=year/ group=gender;
run;

proc sgplot data=new_binge;
scatter y=percent x=year;
loess y=percent x=year/ group=gender;
run;

proc orthoreg data=new_binge;
   effect xMod = polynomial(year / degree=3);
   class gender;
   model percent = xMod | gender;
   effectplot fit (x=year plotby=gender)/obs;
*   store OStore;
run;


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
   estimate "Diff at year=2010" gender 1 -1 gender*spl 
             [1,1  2010] [-1,2  2010] / cl;* adjust=simulate seed=1 stepdown;
   estimate "Diff at year=2015" gender 1 -1 gender*spl 
             [1,1  2015] [-1,2  2015] / cl;* adjust=simulate seed=1 stepdown;
   estimate "Diff at year=2018" gender 1 -1 gender*spl 
             [1,1  2018] [-1,2  2018] / cl;* adjust=simulate seed=1 stepdown;
   estimate "Diff at year=2020" gender 1 -1 gender*spl 
             [1,1  2020] [-1,2  2020] / cl;* adjust=simulate seed=1 stepdown;
   estimate "Diff at year=2021" gender 1 -1 gender*spl 
             [1,1  2021] [-1,2  2021] / cl;* adjust=simulate seed=1 stepdown;
run;



/* Stream a CSV representation of new_bwgt directly to the user's browser. *

proc export data=new_binge
            outfile=_dataout
            dbms=csv replace;
run;

%let _DATAOUT_MIME_TYPE=text/csv;
%let _DATAOUT_NAME=new_binge_drinking.csv;

