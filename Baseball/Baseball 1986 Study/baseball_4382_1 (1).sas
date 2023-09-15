options center nodate pagesize=80 ls=70;
libname ldata '/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Class';

/* Simplified LaTeX output that uses plain LaTeX tables  */
ods latex path='/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/clean'
 file='baseball_4382.tex' style=journal 
stylesheet="sas.sty"(url="sas");

/*
http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 
*/
ods graphics / reset width=5in  outputfmt=png
  antialias=on;

*/;
title "1986 Baseball Data";
/*
In 1986 mlb consisted of two leagues - American and National - 
each with two divisions - East and West. There was not a wildcard
so each team played 162 games to determine the 4 league/divisional winners
which each played a best of 7 to determine the league champion who
then played a best of 7 to determine the world champion!  The American league 
used the designated hitter and the National league did not.

The divisional leaders were NY Mets and Houston Astros in the National league.
The divisional leaders were Boston RSox and LA Angels in the American league.

In this analysis I have two problem in mind.
	1. Compare teams from the same division using 1986 data.
	2. Compare the performance of a team versus their career stats
           (yearly average over each players career)
	   
*/

data baseball; set sashelp.baseball;
run;


data baseball; set baseball;
in_fielder = (position in ('1B' '2B' 'SS' '3B'));
out_fielder = (position in ('CF' 'RF' 'LF' 'OF'));
catcher = (position = 'C');
CrHits2 = CrHits*CrHits;
run;

proc freq data=baseball; table league*division; run;


*proc contents data=baseball short;*run;
/*
Problem 1 - comparing the American League East versus
the American League West using seasonal variables
*/
title3 'Comparing Divisions in the American League';
data problem1; set baseball;
if league = 'American';
keep  Salary Team Division YrMajor logSalary nAtBat 
nBB nError nHits nHome nRBI nRuns;
run;

proc freq data=problem1; table division; run;

proc sort data=problem1; by division; run;
/*
proc means data=problem1 mean median; by division;
var Salary YrMajor
nBB nError nHits nHome nRBI nRuns;
run;
*/
title3 'Test for means assuming normal data';
title4 'Using Number of Hits';

proc ttest data=problem1 alpha=.05; class division;
var nHits;			/*   Use which variable you choose  */;
run;

title3 'Test for means assuming non-normal data';
proc npar1way data=problem1 wilcoxon edf normal; class division;
var nHits;			/*   Use which variable you choose  */;
run;

/*
Problem 2 - comparing the National League East with career
variables
*/
title3 'Comparing the National League East with Career numbers';
data temp1; set baseball;
if div = 'NE';
career = 'No ';
*if team in ('New York', 'Boston');
keep  CrAtBat CrBB CrHits CrHits2 CrHome CrRbi CrRuns Div 
Salary YrMajor   nBB  nHits nHome 
nRBI nRuns career;
run;

data temp2; set temp1;
career = 'Yes';
nbb=CRbb/yrmajor;
nhits = crhits/yrmajor;
nhome = CRhome/yrmajor;
nrbi = CRrbi/yrmajor;
nruns = CRruns/yrmajor;
keep  CrAtBat CrBB CrHits CrHits2 CrHome CrRbi CrRuns Div 
Salary YrMajor   nBB  nHits nHome 
nRBI nRuns career;
run;

data problem2; set temp1 temp2; run;
proc sort data=problem2; by career; run;
proc freq data=problem2; table career; run;

/*
proc means data=problem2 mean median; by career;
var nHits;
run;
*/
title3 'Test for means assuming normal data';
proc ttest data=problem2 alpha=.05; class career;
var nHits;			/*   Use which variable you choose  */;
run;

title3 'Test for means assuming non-normal data';
proc npar1way data=problem2 wilcoxon edf normal; class career;
var nHits;			/*   Use which variable you choose  */;
run;
 quit;
