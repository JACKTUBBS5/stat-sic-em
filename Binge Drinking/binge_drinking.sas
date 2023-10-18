libname ldata '/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Class';
options center nodate pagesize=120 ls=80;



title 'Binge Drinking US 18-25 by gender';
data binge; set ldata.binge_drinking; 
rr = male/female;
ln_rr = log(rr);
drop var4; run;

title 'Relative Risk by year';
proc sgplot data=binge;
scatter y=rr x=year;
loess y=rr x=year;
run;

/*
proc sgplot data=binge;
scatter y=male x=year;
reg y=male x=year;
run;

*/

proc glm data=binge PLOT=MEANPLOT(CLBAND);
*class gender;
model rr = year / clm solution;
*test gender;
run;

proc loess data=binge plots=fitplot;
*class gender;
model rr = year / clm degree=2;
* select=AICC(steps) smooth = 0.6 
                   direct alpha=.05;
run;

proc kde data=binge ;
*univar rr/bwm=.6 noprint;
bivar year rr/bwm=.6;
run;


/************** using new_binge  ***************/;

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
   class gender;
   effect spl = spline(year);
   model percent = gender spl*gender / noint;
   store ortho_spline;
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
/*
%macro GroupDiff;
   %do x=2002 %to 2020 %by 1;
      "Diff at year=&x" gender 1 -1 gender*spl [1,1  &x] [-1,2  &x],
   %end;
%mend;
*/
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

