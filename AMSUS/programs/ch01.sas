/* chapter 1 */

data bodyfat;
 input age pctfat sex $;
cards;
23  9.5 M
23 27.9 F
27  7.8 M
27 17.8 M
39 31.4 F
41 25.9 F
45 27.4 M
49 25.2 F
50 31.1 F
53 34.7 F
53 42.0 F
54 29.1 F
56 32.5 F
57 30.3 F
58 33.0 F
58 33.8 F
60 41.1 F
61 34.5 F
; 
proc print data=bodyfat;
run;
proc corr data=bodyfat;
run;
 
data SlimmingClub;
input idno team $ startweight weightnow;
cards;
1023 red    189 165
1049 yellow 145 124
1219 red    210 192
1246 yellow 194 177
1078 red    127 118
1221 yellow 220   .
1095 blue   135 127
1157 green  155 141
1331 blue   187 172
1067 green  135 122
1251 blue   181 166
1333 green  141 129
1192 yellow 152 139
1352 green  156 137
1262 blue   196 180
1087 red    148 135
1124 green  156 142
1197 red    138 125
1133 blue   180 167
1036 green  135 123
1057 yellow 146 132
1328 red    155 142
1243 blue   134 122
1177 red    141 130
1259 green  189 172
1017 blue   138 127
1099 yellow 148 132
1329 yellow 188 174
run;


data SlimmingClub;
 input name $ 1-18 team $ 20-25 startweight 27-29 weightnow 31-33;
cards;
David Shaw         red    189 165
Amelia Serrano     yellow 145 124
Alan Nance         red    210 192
Ravi Sinha         yellow 194 177
Ashley McKnight    red    127 118
Jim Brown          yellow 220    
Susan Stewart      blue   135 127
Rose Collins       green  155 141
Jason Schock       blue   187 172
Kanoko Nagasaka    green  135 122
Richard Rose       blue   181 166
Li-Hwa Lee         green  141 129
Charlene Armstrong yellow 152 139
Bette Long         green  156 137
Yao Chen           blue   196 180
Kim Blackburn      red    148 135
Adrienne Fink      green  156 142
Lynne Overby       red    138 125
John VanMeter      blue   180 167
Becky Redding      green  135 123
Margie Vanhoy      yellow 146 132
Hisashi Ito        red    155 142
Deanna Hicks       blue   134 122
Holly Choate       red    141 130
Raoul Sanchez      green  189 172
Jennifer Brooks    blue   138 127
Asha Garg          yellow 148 132
Larry Goss         yellow 188 174
;

data SlimmingClub;
 input name $19. team $7. startweight 4. weightnow 3.;
cards;
David Shaw         red    189 165
Amelia Serrano     yellow 145 124
Alan Nance         red    210 192
Ravi Sinha         yellow 194 177
Ashley McKnight    red    127 118
Jim Brown          yellow 220    
Susan Stewart      blue   135 127
Rose Collins       green  155 141
Jason Schock       blue   187 172
Kanoko Nagasaka    green  135 122
Richard Rose       blue   181 166
Li-Hwa Lee         green  141 129
Charlene Armstrong yellow 152 139
Bette Long         green  156 137
Yao Chen           blue   196 180
Kim Blackburn      red    148 135
Adrienne Fink      green  156 142
Lynne Overby       red    138 125
John VanMeter      blue   180 167
Becky Redding      green  135 123
Margie Vanhoy      yellow 146 132
Hisashi Ito        red    155 142
Deanna Hicks       blue   134 122
Holly Choate       red    141 130
Raoul Sanchez      green  189 172
Jennifer Brooks    blue   138 127
Asha Garg          yellow 148 132
Larry Goss         yellow 188 174
;

* SAS dates example;
data days;
input day ddmmyy8.;
cards;
020160
01/02/60
31 12 59
231019
231020
23101919
;
run;
proc print data=days;
run;
proc print data=days;
 format day ddmmyy10.;
run;


* implied and actual decimal places ;
data decimals;
 input realnum 5.2;
cards;
1234 
 4567
123.4
  6789
;
proc print;
run;

proc import datafile='c:\amsus\data\SlimmingClub.tab' out=SlimmingClub 
   dbms=tab replace;
   getnames=yes;
run;

proc import datafile='c:\amsus\data\SlimmingClub.csv' out=SlimmingClub 
   dbms=csv replace;
   getnames=yes;
run;

proc import datafile='c:\amsus\data\usair.xls' out=usairmiss dbms=excel replace;
   sheet=usairmiss;
run;

proc import datafile='c:\amsus\data\usair.xls' out=usairsub dbms=excel replace;
   getnames=no;
   range="usairfull$a8:f42";
run;

proc export data=usairmiss file='c:\amsus\data\myExcel.xls' dbms=excel replace;
run;


libname db 'c:\amsus\data';
data db.SlimmingClub;
 set SlimmingClub;
run;

libname db 'c:\amsus\data';
data SlimmingClub2;
  set db.slimmingclub;
run;

data women;
  set bodyfat;
  if sex='F';
run;

proc sgplot data=bodyfat;
  scatter y=pctfat x=age;
run;

proc sgplot data=bodyfat;
  scatter y=pctfat x=age /group=sex;
run;


proc sgplot data=bodyfat;
  reg y=pctfat x=age ;
  loess y=pctfat x=age / nomarkers;
run;

data bodyfat;
  set bodyfat;
  decade=int(age/10);
run;

proc sgplot data=bodyfat;
  vline decade / response=pctfat stat=mean limitstat=stddev;
run;

proc sgplot data=bodyfat;
  vbar decade / response=pctfat stat=mean limitstat=stddev;
run;

proc sgplot data=bodyfat;
  vbox pctfat / category=sex;
run;

ods rtf;
proc print data=bodyfat;
proc corr data=bodyfat;
run;
ods rtf close;

proc template;
  list styles;
run;
ods html gpath='c:\amsus\figures';
ods graphics on / outputfmt =jpeg;



options papersize=a4 orientation=portrait
        bottommargin=1in topmargin=1in 
        leftmargin=1in rightmargin=1in ;


data bodyfat;
  set bodyfat;
  label pctfat='Fat as % of body mass';
run;

proc format;
  value $sex 'M'='Male' 'F'='Female';
run;

proc sgplot data=bodyfat;
  scatter y=pctfat x=age /group=sex;
  format sex $sex.;
  label pctfat='Fat as % of body mass';
run;


data bodyfat;
  set bodyfat;
  if upcase(sex)='M' then gender=1;
     else gender=2;
run;

proc format;
  value gender 1='Male' 2='Female';
run;

proc sgplot data=bodyfat;
  scatter y=pctfat x=age /group=gender;
  format gender gender.;
run;

ods rtf;
proc print data=bodyfat;
proc corr data=bodyfat;
run;
ods rtf close;

%macro xyplot(data=,x=,y=);
proc sgplot data=&data;
  scatter y=&y x=&x;
run;
%mend xyplot;

options mprint;
%xyplot(data=bodyfat,x=age,y=pctfat);

%macro xyplot(data,x,y);
proc sgplot data=&data;
  scatter y=&y x=&x;
run;
%mend xyplot;

%xyplot(bodyfat,age,pctfat);
