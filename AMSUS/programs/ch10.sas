/* Chapter 10 */

data PhysicalMeasures;
  infile 'c:\AMSUS\data\PhysicalMeasures.dat' expandtabs;
input Mass Fore Bicep Chest Neck Shoulder Waist Height Calf Thigh Head;
run;

proc genmod data=PhysicalMeasures;
  model mass=fore waist height thigh / dist=normal link=id;
run;

data lowbwt;
  infile 'c:\AMSUS\data\lowbwt.dat';
  input id low age lwt race ftv;
run;

proc genmod data=lowbwt desc;
  class race ;
  model low=race age lwt ftv / dist=b link=logit;
run;

data bladder;
  input time x n;
  logtime=log(time);
cards;
2   0   1
3   0   1
6   0   1
8   0   1
9   0   1
10  0   1
11  0   1
13  0   1
14  0   1
16  0   1
21  0   1
22  0   1
24  0   1
26  0   1
27  0   1
7   0   2
13  0   2
15  0   2
18  0   2
23  0   2
20  0   3
24  0   4
1   1   1
5   1   1
17  1   1
18  1   1
25  1   1
18  1   2
25  1   2
4   1   3
19  1   4
;

proc genmod data=bladder;
  model n=x / offset=logtime dist=p;
run;

data CHDrisk;
 input pyears smoking BP TypeA Ncases;
 lpyears=log(pyears);
datalines;
5268.2  0   0   0   20
2542.0  10  0   0   16
1140.7  20  0   0   13
614.6   30  0   0   3
4451.1  0   0   1   41
2243.5  10  0   1   24
1153.6  20  0   1   27
925.0   30  0   1   17
1366.8  0   1   0   8
497.0   10  1   0   9
238.1   20  1   0   3
146.3   30  1   0   7
1251.9  0   1   1   29
640.0   10  1   1   21
374.5   20  1   1   7
338.2   30  1   1   12
;

ods select ParameterEstimates(persist);
proc genmod data=CHDrisk;
  model ncases=smoking / offset=lpyears dist=p;
run;
proc genmod data=CHDrisk;
  model ncases= smoking BP TypeA/ offset=lpyears dist=p;
run;
ods select all;

data fap;
  input male treat base_n age r_n;
cards;
0   1   7   17  6
0   0   77  20  67
1   1   7   16  4
0   0   5   18  5
1   1   23  22  16
0   0   35  13  31
0   1   11  23  6
1   0   12  34  20
1   0   7   50  7
1   0   318 19  347
1   1   160 17  142
0   1   8   23  1
1   0   20  22  16
1   0   11  30  20
1   0   24  27  26
1   1   34  23  27
0   0   54  22  45
1   1   16  13  10
1   0   30  34  30
0   1   10  23  6
0   1   20  22  5
1   1   12  42  8
;

proc genmod data=fap;
  model r_n=male treat base_n age / dist=p;
run;

proc genmod data=fap;
  model r_n=male treat base_n age / dist=g link=log;  
run;

proc genmod data=fap ;
  model r_n=male treat base_n age / dist=p;
  output out=pout reschi=rs;
run;
proc univariate data=pout noprint;
  var rs;
  probplot rs / normal(mu=est sigma=est);
run;
proc genmod data=fap;
  model r_n=male treat base_n age / dist=g link=log;  
  output out=gout reschi=rs;
run;
proc univariate data=gout noprint;
  var rs;
  probplot rs / normal(mu=est sigma=est);
run;

proc genmod data=fap;
  model r_n=male treat base_n age /  dist=p scale=d;
run;

