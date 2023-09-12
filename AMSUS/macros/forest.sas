%macro forest(data=_last_,es=es,se=se,type=Random,scale=1);
data fplot;
  set &data nobs=nobs;
  yv=nobs-_n_+3;
  xmax=3;
  es=&es;
  cil=es-1.96*&se;
  ciu=es+1.96*&se;
run;

data fsum;
  set ma_summary;
  study='Summary';
  es=mes; 
  if upcase(type)="%upcase(&type)";
  yv=1;
run;
data fplot;
  set fplot fsum;
run;

data rectangles;
 set fplot;
 retain function 'rectangle' x1space  y1space 'datavalue' height 10 heightunit widthunit 'pixel' 
        anchor 'center' display 'all' justify 'center';
 rename  yv=y1 es=x1;
 width=wgt*&scale;
 if study~='Summary';
run;
data diamond;
  length function $8.;
  set fsum;
  retain  x1space  y1space 'datavalue' display 'all' ;
  function='polygon'; x1=cil; y1=1; output;
  function='polycont'; x1=es; y1=1.5; output;
  function='polycont'; x1=ciu; y1=1; output;
  function='polycont'; x1=es; y1=.5; output;
run;

data labels;
 set fplot;
 length function $9. anchor $8.;
 retain function 'text' y1space 'datavalue' x1space 'graphpercent' x1 2 anchor 'left' width 20;
 rename study=label yv=y1;
run;

data annodat;
  set labels rectangles diamond;
run;
proc sgplot data=fplot noautolegend sganno=annodat pad=(left=25%);
  scatter y=yv x=es / transparency=1;
  vector y=yv x=ciu / xorigin=cil yorigin=yv noarrowheads  lineattrs=(pattern=solid);
  refline 0  /axis=x lineattrs=(pattern=dash);
  refline mes /axis=x;
  yaxis display=none;
  xaxis display=(nolabel);
run;
%mend;
