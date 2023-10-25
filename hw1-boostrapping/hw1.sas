options center nodate pagesize=100 ls=70;
title1 'Simulate Data for BootStrap Example';
title2 'Generate Uniform (0, theta) Data';

/********************************************************************
 Simulation by Using the DATA Step and SAS Procedures
 *******************************************************************/

%let theta=12;           /* Right endpoint      */
%let N = 30;             /* size of each sample */
%let NumSamples = 250;   /* number of samples   */  

/* 1. Simulate data */
data SimUni;
call streaminit(123);
   do i = 1 to &N;
      x = &theta*rand("Uniform");
      output;
   end;
run;

******************************************************;
* Using PROC SURVEYSELECT;
******************************************************;

proc surveyselect data=SimUni NOPRINT seed=1       
     out=BootSS                                    
     method=balboot                         
     reps=&NumSamples;                                                                        
run;

proc summary data=BootSS;by replicate;
var x;
   output out=Bootdist (drop=_freq_ _type_) mean=mean_x max=max_x min=min_x;
run;


data OutStatsUni; set Bootdist; 
stat1 = 2*mean_x; stat2=max_x; stat3=min_x + max_x; run;

title3 '2* xbar';
proc sgplot data=OutStatsUni;
   histogram stat1; run;

title3 'x_(n)';
proc sgplot data=OutStatsUni;
   histogram stat2; run;

title3 'x_(1) + x_(n)';
proc sgplot data=OutStatsUni;
   histogram stat3; run;

title3 'Average over bootstrap samples';
proc means data=OutStatsUni mean std min max; var stat1 stat2 stat3; 
output out=Outstats2;run;
