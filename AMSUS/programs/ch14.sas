/* Chapter 14 */

data respw;
  infile 'c:\amsus\data\resp.dat';
  input id centre treat sex age bl v1-v4;
run;

data respl;
  set respw;
  array vs {4} v1-v4;
  do time=1 to 4;
  status=vs{time};
  output;
  end;
run;


proc sort data=respl; 
  by id time;
run;
proc genmod data=respl desc;
class id;
 model status=age / d=b;
 repeated subject=id / type=ind modelse;
run;

proc genmod data=respl desc;
class id;
 model status=age / d=b;
 repeated subject=id / logor=fullclust modelse;
run;

proc genmod data=respl desc;
class id;
 model status=centre treat sex age time bl / d=b;
 repeated subject=id / logor=fullclust modelse;
run;
 
proc glimmix data=respl noclprint ;
 class id;
 model status(desc)=centre treat sex age time bl  / d=binary s ddfm=bw;
 random int / subject=id;
run;


data epiw;
  infile 'c:\AMSUS\data\epi.dat';
  input id p1-p4 treat bl age;
run;
data epil;
  set epiw;
  bl=bl/4;
  lbl=log(bl);
  array ps {*} bl p1-p4;
  do time=1 to 5;
  nsz=ps{time};
  output;
  end;
run;

proc format;
  value visits 1='Baseline' 2='Week 2' 3='Week 4' 4='Week 6' 5='Week 8';
run;
proc sgpanel data=epil;
  panelby treat / columns=2 spacing=10;
  vbox nsz / category=time datalabel=id labelfar;
  format time visits.;
run;

proc means data=epil mean var;
  class time;
  var nsz;
run;
 
data epil;
  set epil;
  if time>1;
run;

proc genmod data=epil ;
class id;
 model nsz= treat age time lbl / d=p ;
 repeated subject=id / type=exch modelse;
run;

proc glimmix data=epil noclprint method=mspl;
 class id;
 model nsz= treat age time lbl / s ddfm=bw d=p;
 random int / subject=id;
run;

proc glimmix data=epil noclprint method=mspl;
 class id;
 model nsz= treat age time lbl / s ddfm=bw d=p;
 random int time / subject=id type=un;
run;




