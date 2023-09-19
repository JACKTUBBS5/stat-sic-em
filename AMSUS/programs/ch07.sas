
/* Chapter 7 */

data drinking;
 input country $ 1-12 alcohol cirrhosis;
cards;
France        24.7  46.1
Italy         15.2  23.6
W.Germany     12.3  23.7
Austria       10.9   7.0
Belgium       10.8  12.3
USA            9.9  14.2
Canada         8.3   7.4
E&W            7.2   3.0
Sweden         6.6   7.2
Japan          5.8  10.6
Netherlands    5.7   3.7
Ireland        5.6   3.4
Norway         4.2   4.3
Finland        3.9   3.6
Israel         3.1   5.4
;

proc corr; run;

proc sgplot data=drinking;
  scatter y=cirrhosis x=alcohol /datalabel=country ;
run;

proc corr data=drinking fisher ;
 var alcohol cirrhosis;
run;

data drinking2;
 set drinking;
 if country~='France';
run;

proc corr; run;

proc corr data=drinking spearman nosimple;
proc corr data=drinking2 spearman nosimple;
run;

ods graphics on;
proc reg data=drinking2; * plot(only)=fitplot;
  model cirrhosis=alcohol ;
run;

data SMRMorb;
input region $15. SMR Morbidity;
datalines;
North          132.7   228.2
Yorkshire      126.8   235.2
North West     132.8   218.6
East Midlands  119.2   222.0
West Midlands  124.8   210.5
East Anglia    108.2   205.0
Greater London 116.3   202.6
South East     109.5   189.6
South West     112.2   186.6
Wales          128.6   249.9
;

proc sgplot data=SMRMorb;
  scatter y=Morbidity x=SMR / datalabel=region ;
run;

ods graphics on;
proc reg data=SMRMorb plot(only)=fitplot;
  model Morbidity=SMR ;
run;

data anaerob;
  infile 'c:\AMSUS\data\anaerob.dat' expandtabs;
  input o2in exp @@;
run;

proc sgplot data=anaerob;
  scatter y=exp x=o2in;
run;

ods graphics on;
proc reg data=anaerob;
 model exp=o2in;
run;

data anaerob;
  set anaerob;
  o2sq=o2in*o2in;
run;

ods graphics off;
proc reg data=anaerob; 
 model exp=o2in o2sq;
 output out=regout p=pr uclm=citop lclm=cibot;
run;

proc sort data=regout; by o2in; run;
proc sgplot data=regout;
  band upper=citop lower=cibot x=o2in;
  series y=pr x=o2in;
  scatter y=exp x=o2in;
run;

* NB order of plot stts;

proc loess data=drinking2;
  model cirrhosis=alcohol /  smooth=.5; * select=gcv is 2 piece linear;
run;

proc sgplot data=drinking2;
  reg y=cirrhosis x=alcohol ;
  loess y=cirrhosis x=alcohol / nomarkers;
run;


data USbirth;
  retain obs 0;
  do year=1940 to 1947;
   do month=1 to 12;
   input rate @@;
   obs=obs+1;
   datestr=('15'||put(month,z2.)||put(year,4.));
   obsdate=input(datestr,ddmmyy8.);
   output;
   end;
  end;
cards;
1890   1957   1925   1885   1896   1934   2036   2069   2060
1922   1854   1852   1952   2011   2015   1971   1883   2070
2221   2173   2105   1962   1951   1975   2092   2148   2114
2013   1986   2088   2218   2312   2462   2455   2357   2309
2398   2400   2331   2222   2156   2256   2352   2371   2356
2211   2108   2069   2123   2147   2050   1977   1993   2134
2275   2262   2194   2109   2114   2086   2089   2097   2036
1957   1953   2039   2116   2134   2142   2023   1972   1942
1931   1980   1977   1972   2017   2161   2468   2691   2890
2913   2940   2870   2911   2832   2774   2568   2574   2641
2691   2698   2701   2596   2503   2424
;

ods graphics / height=480 width=640;
proc sgplot data=usbirth;
 scatter y=rate x=obsdate;
 format obsdate year.;
run;    

ods graphics / height=300 width=1000;
proc sgplot data=usbirth;
 scatter y=rate x=obsdate;
 format obsdate year.;
run;    
    
proc sgplot data=usbirth;
 scatter y=rate x=obsdate;
 format obsdate monyy7.;
 where year<1943;
run;    

proc sgplot data=usbirth;
 series y=rate x=obsdate;
 format obsdate monyy7.;
 where year<1943;
run;    

ods graphics / height=200 width=1000;
proc sgplot data=usbirth;
 series y=rate x=obsdate;
 format obsdate year.;
run;    

data fertility;
  infile 'c:\amsus\data\fertility.dat';
  input country$ birth death;
run;

ods graphics / reset=all;
proc kde data=fertility ;
  bivar birth death / plots=contourscatter noprint;
run;

proc kde data=fertility ;
  bivar birth death / bwm=.5 plots=contourscatter noprint;
run;

proc kde data=fertility ;
  bivar birth death / plots=surface(rotate=30 tilt=45) noprint;
run;

proc kde data=fertility ;
  bivar birth death / bwm=.5 plots=surface(rotate=30 tilt=45) noprint;
run;

data blood;
  infile 'c:\amsus\data\blood_viscosity.dat' firstobs=2;
  input patid viscosity PCV fibrinogen protein;
run;

proc sgscatter data=blood;
  matrix viscosity -- protein / diagonal=(histogram kernel);
run;

proc corr data=blood;
 var viscosity -- protein;
run;

proc corr data=blood nosimple;
 var viscosity fibrinogen protein;
 partial pcv;
run;



