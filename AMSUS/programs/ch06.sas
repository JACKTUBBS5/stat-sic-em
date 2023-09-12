/* Chapter 6 */

data sickle;
  do type=1 to 3;
  input hglevel 5. @;
  if hglevel~=. then output;
  end;
datalines;
  7.2  8.1 10.7
  7.7  9.2 11.3
  8.0 10.0 11.5
  8.1 10.4 11.6
  8.3 10.6 11.7
  8.4 10.9 11.8
  8.4 11.1 12.0
  8.5 11.9 12.1
  8.6 12.0 12.3
  8.7 12.1 12.6
  9.1      12.6
  9.1      13.3
  9.1      13.3
  9.8      13.8
 10.1      13.9
 10.3      
;                        

proc sort data=sickle;
  by type;
run;

proc boxplot data=sickle;
  plot hglevel*type / boxstyle=schematic;
run;

ods graphics on;
proc glm data=sickle plots=diagnostics(unpack);
  class type;
  model hglevel=type;
run;
ods graphics off;

proc glm data=sickle;
  class type;
  model hglevel=type;
  contrast '3 vs 1 & 2' type -1 -1 2;
  contrast '1 vs 2'     type  1 -1 0;
run;

proc glm data=sickle;
  class type;
  model hglevel=type;
  means type / scheffe;
run;

* Or the previous three glm steps could be run as follows;
ods graphics on;
proc glm data=sickle plots(unpack)=diagnostics;
  class type;
  model hglevel=type;
run;
  contrast '3 vs 1 & 2' type -1 -1 2;
  contrast '1 vs 2'     type  1 -1 0;
run;
  means type / scheffe;
run;


data hyper;                            
  input n1-n12;
  if _n_<4 then biofeed='P';
           else biofeed='A';
  if _n_ in(1,4) then drug='X';
  if _n_ in(2,5) then drug='Y';
  if _n_ in(3,6) then drug='Z';
  array nall {12} n1-n12;
  do i=1 to 12;
      if i>6 then diet='Y';
                 else diet='N';
          bp=nall{i};
          cell=drug||biofeed||diet;
          output;
  end;
  drop i n1-n12;
cards;
170 175 165 180 160 158 161 173 157 152 181 190
186 194 201 215 219 209 164 166 159 182 187 174
180 187 199 170 204 194 162 184 183 156 180 173
173 194 197 190 176 198 164 190 169 164 176 175
189 194 217 206 199 195 171 173 196 199 180 203
202 228 190 206 224 204 205 199 170 160 179 179
;
 
proc means data=hyper noprint;
  class cell;
  var bp;
  output out=cellmeans mean= std= var= /autoname;
run;

proc sgscatter data=cellmeans;
  plot (bp_stddev bp_var)*bp_mean ;
run;

proc template;
  define statgraph gridtplt;
    begingraph;
       layout gridded /columns=3 rows=1;
       boxplot y=bp x=drug ;
       boxplot y=bp x=diet ;
       boxplot y=bp x=biofeed ;
       endlayout;
    endgraph;
  end;
run;

proc sgrender data=hyper template=gridtplt;
run;
 
proc anova data=hyper;
  class diet biofeed drug;
  model bp=diet|drug|biofeed;
run;
  means diet*drug*biofeed;
ods output means=cellmeans2;
run; quit;

proc sgpanel data=cellmeans2;
 panelby drug / columns=1 spacing=10;
 series y=mean_bp x=biofeed /group=diet;
run;


data antipyrine;
input sex$ stage hours;
cards;
M 1 7.4
M 1 5.6
M 1 6.6
M 1 6.0
M 2 3.7
M 2 10.9
M 2 12.2
M 3 11.3
M 3 13.3
M 3 10.0
F 1 9.1
F 1 11.3
F 1 6.3
F 1 9.4
F 2 7.1
F 2 7.9
F 2 11.0
F 3 8.3
F 3 4.3
;

proc glm data=antipyrine;
  class sex stage;
  model hours=sex|stage / ss1 ss2 ss3;
run;
  means sex*stage;
  ods output means=antmns;
run;
proc sgplot data=antmns;
  series y=mean_hours x=stage/ group=sex;
run;

data grsites;
  infile 'c:\amsus\data\grsites.dat';
  input group$ ngrs;
run;

proc npar1way data=grsites wilcoxon;
  class group;
  var ngrs;
run;

data pip;
 infile 'c:\amsus\data\pip03.dat';
 input group $ id pip1 pip2;
run;

proc sgplot data=pip;
 reg y=pip2 x=pip1 / group=group;
run;

proc glm data=pip;
  class group;
  model pip2=pip1 group pip1*group;
run;

data dentists;
input id age anx1 anx2;
method=1;
if id>10 then method=2;
if id>20 then method=3;
datalines;
1   27  30.2    32.0
3   32  35.3    34.8
3   23  32.4    36.0
4   28  31.9    34.2
5   30  28.4    30.3
6   35  30.5    33.2
7   32  34.8    35.9
8   21  32.5    34.0
9   26  33.0    34.2
10  27  29.9    31.1
11  29  32.6    31.5
12  29  33.0    32.9
13  31  31.7    34.3
14  36  34.0    32.8
15  23  29.9    32.5
16  26  32.2    32.9
17  22  31.0    33.1
18  20  32.0    30.4
19  28  33.0    32.6
20  32  31.1    32.8
21  33  29.9    34.1
22  35  30.0    34.1
23  21  29.0    33.2
24  28  30.0    33.0
25  27  30.0    34.1
26  23  29.6    31.0
27  25  32.0    34.0
28  26  31.0    34.0
29  27  30.1    35.0
30  29  31.0    36.0
;

proc sgscatter data=dentists;
 plot  anx2*(anx1 age) /group=method reg rows=1;
run;
 
proc means data=dentists maxdec=2;
  class method;
  var age anx1 anx2 ;
run;
 
proc glm data=dentists;
  class method;
  model anx2=anx1 age method  ;
  lsmeans method / at means adjust=scheffe cl;
run;

