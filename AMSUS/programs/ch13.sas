/* Chapter 13 */

data pip;
 infile 'c:\amsus\data\pip.dat';
 input id x1-x8;
 if id>13 then group=2;
 else group=1;
run;

data pipl;
  set pip;
  array xs {*} x1-x8;
  array t{8} t1-t8 (0 .5 1 1.5 2 3 4 5);
  do i=1 to 8;
    time=t{i};
    pip=xs{i};
    output;
  end;
  label time='hours after glucose'; 
  keep id time group pip;
run;

proc format;
  value group 1='Control' 2='Obese';
run;

proc print data=pipl ;
  where id in(1 13 14 33);
  format group group.;
run;

proc sgpanel data=pipl noautolegend;
  panelby group /columns=2 spacing=10 novarname;
  series y=pip x=time /group=id; 
  format group group.;
run;

proc sgscatter data=pip;
  matrix x1-x8;
  by group notsorted;
  format group group.;
run;

proc stdize data=pipl out=pipl method=mean;
   var time;
run;

proc sort data=pipl; by id time; run;

proc mixed data=pipl covtest noclprint=10;
  class group id;
  model pip=group time|time /s ddfm=bw;
  random int time /subject=id type=un;
run;

proc glm data=pipl;
 class group;
 model pip=group time|time /solution;
run;

proc mixed data=pipl covtest noclprint;
  class group id;
  model pip=group time|time /s ddfm=bw outp=mixout;
 random int time /subject=id type=un;
run;

proc sgpanel data=mixout noautolegend;
  panelby group /columns=2 spacing=10 novarname;
  series y=pred x=time /group=id; 
  format group group.;
run;

proc mixed data=pipl covtest noclprint;
  class group id;
  model pip=group time|time group*time /s ddfm=bw outp=mixout;
 random int time /subject=id type=un;
run;

proc sgpanel data=mixout noautolegend;
  panelby group /columns=2 spacing=10 novarname;
  series y=pred x=time /group=id; 
  format group group.;
run;

proc mixed data=pipl covtest noclprint;
  class group id;
  model pip=group time|time group*time/s ddfm=bw outp=mixout;
  random int time /subject=id type=un s;
  ods output solutionr=reffs;
  ods listing exclude solutionr;
run;

proc sort data=reffs; by effect; run;
proc univariate data=reffs noprint;
  var estimate;
  probplot estimate /normal(mu=est sigma=est);
  by effect;
run;
proc univariate data=mixout noprint;
  var resid;
  probplot resid /normal(mu=est sigma=est);
run;

proc sgscatter data=mixout;
   plot resid *(pred time)/group=group loess=(clm);
run;

proc mixed data=pipl covtest noclprint;
  class group id;
  model pip=group time group*time/s ddfm=bw outp=mixout;
  random int time /subject=id type=un s;
run;

proc sgscatter data=mixout;
   plot resid *(pred time)/group=group loess=(clm);
run;


data btb  (keep=sub--treatment BDIpre--BDI8m)
     btbl (keep=sub--treatment bdi time);
 infile 'c:\amsus\data\btb.dat' missover;
  array bdis {*} BDIpre BDI2m BDI3m BDI5m BDI8m;
  array t {*} t1-t5 (0 2 3 5 8);
  input sub drug$ Duration$ Treatment$ @;
  do i=1 to 5;
    input bdi @;
    bdis{i}=bdi;
    time=t{i};
    output btbl;
  end;
  output btb;
run;

proc sort data=btbl;
  by treatment time;
run;

proc sgpanel data=btbl;
  panelby treatment /spacing=10 novarname;
  vbox bdi / category=time ;
run;

proc mixed data=btbl covtest noclprint=3;
 class drug duration treatment sub;
 model bdi=drug duration treatment time / s cl ddfm=bw;
 random int time /subject=sub type=un;
run;

proc mixed data=btbl covtest noclprint=3 plots=pearsonpanel(blup noblup);
 class drug duration treatment sub;
 model bdi=drug duration treatment time / s cl ddfm=bw;
 random int /subject=sub;
run;

