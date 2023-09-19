/* Chapter 11 */

data oxygen;
  infile 'c:\amsus\data\oxygen.dat';
  input id o2uptake expired;
run;

proc gam data=oxygen;
  model expired=loess(o2uptake) / method=gcv;
  output out=gamout pred ;
run;

proc sgplot data=gamout;
  scatter y=expired x=o2uptake ;
  series y=p_expired x=o2uptake ;
run;

proc sgplot data=oxygen;
  scatter y=expired x=o2uptake / legendlabel='observed';
  reg y=expired x=o2uptake /degree=2 nomarkers lineattrs=(pattern=dot) legendlabel='quadratic';
  reg y=expired x=o2uptake /degree=3 nomarkers lineattrs=(pattern=dash) legendlabel='cubic';
  reg y=expired x=o2uptake /degree=4 nomarkers lineattrs=(pattern=solid) legendlabel='quartic';
run;

data respdeaths;
 infile cards missover;
 retain obs 0;
 input year @;
 do month=1 to 12;
 input deaths @;
 output;
 obs=obs+1;
 end;
cards;
1974    3035    2552    2704    2554    2014    1655    1721    1524    1596    2074    2199    2512
1975    2933    2889    2938    2497    1870    1726    1607    1545    1396    1787    2076    2837
1976    2787    3891    3179    2011    1636    1580    1489    1300    1356    1653    2013    2823
1977    2996    2523    2540    2520    1994    1964    1691    1479    1596    1877    2032    2484
1978    2899    2990    2890    2379    1933    1734    1617    1495    1440    1777    1970    2745
1979    2841    3535    3010    2091    1667    1589    1518    1348    1392    1619    1954    2633
run;

proc gam data=respdeaths;
  model deaths=loess(year) loess(month)/ method=gcv;
  id obs;
  output out=respout all;
run;

proc sgplot data=respout;
  scatter y=deaths x=obs ;
  series y=p_deaths x=obs;
run;

ods graphics on;
proc gam data=respdeaths plots=components(clm commonaxes);
  model deaths=loess(year) loess(month)/ method=gcv;
run;

proc sgplot data=respdeaths;
  pbspline y=deaths x=obs ;
  loess y=deaths x=obs;
run;

data diabetes;
  infile 'c:\amsus\data\diabetes.dat';
  input id age base peptide;
  logpeptide=log10(peptide);
run;

proc sgscatter data=diabetes;
   plot logpeptide*(age base)/reg pbspline ;
run;

ods graphics on;
proc gam data=diabetes plots=components(clm commonaxes);;
  model logpeptide=loess(age) loess(base) / method=gcv;
run;
ods graphics off;

proc gam data=diabetes;
  model logpeptide= param(base) loess(age)/ method=gcv;
run;

proc gam data=diabetes;
  model logpeptide= param(base age)/ method=gcv;
run;

data usair;
  infile 'c:\amsus\data\usair.dat';
  input city $16. hiso2 temperature factories population windspeed rain rainydays;
run;

proc logistic data=usair desc;
 model hiso2=temperature factories population windspeed rain rainydays /selection=b;
run;

proc sgplot data=usair;
 vbox population / category=hiso2 datalabel=city;
run;
proc sgplot data=usair;
 vbox rain / category=hiso2 datalabel=city;
run;

data usair;
  set usair;
  if city=:'Chicago' then delete;
run;

proc sgscatter data=usair;
  plot hiso2*(population rain) /pbspline;
run;

ods graphics on;
proc gam data=usair ;
 model hiso2(event='1')=spline(rain,df=2) /dist=binary ;
 output out=gamout p;
run;
ods graphics off;

data gamout;
  set gamout;
  odds=exp(P_hiso2);
  pred=odds/(1+odds);
run;

proc sort data=gamout; by rain; run;
proc sgplot data=gamout;
 series y=pred x=rain;
run;

