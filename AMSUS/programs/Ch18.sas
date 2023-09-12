/* Chapter 18 */

data usair;
  infile 'c:\amsus\data\usairmiss.dat';
  input city $16. so2 Temp Manu Pop Wind Precip Days;
run;

data usair;
  set usair;
  array xs {*} So2 Temp Manu Pop Wind Precip Days;
  array mx {*} m_so2 m_Temp m_Manu m_Pop m_Wind m_Precip m_Days;
  do i=1 to 7;
   if xs{i}=. then mx{i}=1;
              else mx{i}=0;
  end;
  nmvars=nmiss(of so2--days);
run;

proc print data=usair noobs ;
 var city m_so2--m_days;
run;

proc means data=usair n nmiss mean std min max  maxdec=2;
 var so2 -- Days;
run;

proc mi data=usair nimpute=0;
 var so2 -- Days;
run;

data  btbl;
  infile 'c:\amsus\data\btb.dat' missover;
  input sub drug$ Duration$ Treatment$ BDIpre BDI2m BDI3m BDI5m BDI8m;
  array bdis {*} BDIpre BDI2m BDI3m BDI5m BDI8m;
  array t {*} t1-t5 (0 2 3 5 8);
  do i=1 to 5;
    bdi=bdis{i};
    time=t{i};                             
    if time<8 and bdis{i+1}~=. then next=1;  
    else next=0;
    nexttime=time-.1+next*.2;
    if bdi~=. then output btbl;
  end;
run;

proc sgpanel data=btbl;
   panelby treatment / rows=2 spacing=10;
   scatter y=bdi x=nexttime / group=next;
   colaxis label='time'; 
   where time<8;
run;


proc mi data=usair out=usimp nimpute=10 minimum=0 seed=123 noprint ;
 var so2 -- Days;
 mcmc;
run;
proc means data=usimp;
 var so2;
 by _imputation_;
 output out=mimpout mean=so2 stderr=sso2;
run;
proc mianalyze data=mimpout edf=40;
   modeleffects so2;
   stderr sso2;
run;

proc reg data=usimp outest=rout covout noprint;
  model so2=Temp -- Days;
  by _imputation_;
run;

proc mianalyze data=rout edf=34; 
 modeleffects intercept Temp Manu Pop Wind Precip Days;
run;

proc reg data=usair;
  model so2=Temp -- Days;
run;

data usairfull;
  infile 'c:\amsus\data\usairfull.dat' expandtabs;
  input city $16. so2 Temp Manu Pop Wind Precip Days;
run;
proc reg data=usairfull;
  model so2=Temp -- Days;
run;

data boys;
  infile 'c:\amsus\data\boysgrowth.dat';
  input id age  height weight bmi tanner phair tv;
  ageyrs=int(age);
run;

proc means data=boys n nmiss mean min max maxdec=2;
 var height weight bmi tanner phair tv ;
run;


proc means data=boys n nmiss mean min max maxdec=2;
 var tanner ;
 class ageyrs;
run;

proc sgpanel data=boys;
 panelby ageyrs / rows=5;
 histogram tanner;
run;


proc mi data=boys nimpute=20 out=impboys seed=123
              min=. . 1 1 0 . 
              max=. . 5 6 . . 
            round=. . 1 1 . . ;
 var height weight tanner phair tv age;
 mcmc;
run;

proc sgpanel data=impboys;
 panelby ageyrs / rows=5;
 histogram tanner;
run;
 
