options center nodate pagesize=80 ls=70;
libname ldata '/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Class';

/* Simplified LaTeX output that uses plain LaTeX tables  */
ods latex path='/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/clean'
 file='baseball_boot.tex' style=journal 
stylesheet="sas.sty"(url="sas");

/*
http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 
*/
ods graphics / reset width=5in  outputfmt=png
  antialias=on;

*/;
title "BootStrap with 1986 Baseball Data";
data baseball; set sashelp.baseball;
run;


data baseball; set baseball;
in_fielder = (position in ('1B' '2B' 'SS' '3B'));
out_fielder = (position in ('CF' 'RF' 'LF' 'OF'));
catcher = (position = 'C');
CrHits2 = CrHits*CrHits;
run;

Title2 'Out Fielders from the American League';
data amer_of; set baseball;
if out_fielder = 1 and league = 'American';
run;

proc sgplot data=amer_of;
histogram salary;
run;

/*
title1 'Simulate Data for BootStrap Example';
title2 'Generate Uniform (0, theta) Data';

/********************************************************************
 Simulation by Using the DATA Step and SAS Procedures
 *******************************************************************

%let theta=12;           /* Right endpoint      *
%let N = 30;             /* size of each sample *
%let NumSamples = 250;   /* number of samples   *  

/* 1. Simulate data *
data SimUni;
call streaminit(123);
   do i = 1 to &N;
      x = &theta*rand("Uniform");
      output;
   end;
run;
*/;

******************************************************;
* Using PROC SURVEYSELECT;
******************************************************;

proc surveyselect data=amer_of NOPRINT seed=123       
     out=BootSS                                    
     method=balboot                         
     reps=250;                                                                        
run;

proc summary data=BootSS;by replicate;
var salary;
   output out=Bootdist (drop=_freq_ _type_) median=med p90=p90 p10=p10 min=min max=max;
run;

data OutStatsUni; set Bootdist; stat1 = med; stat2=(min+max)/2; stat3=(p10+p90)/2; 
run;

title3 'Median';
proc sgplot data=OutStatsUni;
   histogram stat1; 
run;

title3 'Midpoint';
proc sgplot data=OutStatsUni;
   histogram stat2; 
run;

title3 'Trimmed Midpoint';
proc sgplot data=OutStatsUni;
   histogram stat3; 
run;

title3 'Average over bootstrap samples';
proc means data=OutStatsUni mean std min max; var stat1 stat2 stat3; 
output out=Outstats2;
run;