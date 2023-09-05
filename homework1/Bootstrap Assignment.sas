/* Bootstrapping code */
/* Part 1 */
%let theta = 12; /*right endpoint*/
%let N = 30; /*size of each sample*/
%let NumSamples = 250; /*number of samples*/

/* Simulate Data */
data SimUni;
call streaminit(123);
	do i = 1 to &N;
	x = &theta*rand("Uniform");
	output;
	end;
run;

proc surveyselect data=SimUNi NOPRINT seed = 1
	out=BootSS
	method=balboot
	reps=&NumSamples;
run;

proc summary data=BootSS; by replicate;
var x;
	output out=Bootdist (drop=_freq_ _type_) mean=mean_x max = max_x min=min_x;
run;

data OutStatsUni; set Bootdist;
stat1 = min_x + max_x; run;
	
title3 'x_(1)_+x_(n)';
proc sgplot data=OutStatsUni;
	histogram stat1; run;	

title3 'Average_over_bootstrap_samples';
proc means data=OutStatsUni min max; var stat1;
output out=Outstats2;run;

/* Part 2 */
%let theta = 8; /*right endpoint*/
%let N = 30; /*size of each sample*/
%let NumSamples = 250; /*number of samples*/

/* Simulate data */
data simUni;
call streaminit(123);
	do i = 1 to &N;
	x = rand("Exponential", 8);
	output;
	end;
run;

proc surveyselect data=SimUNi NOPRINT seed = 1
	out=BootSS
	method=balboot
	reps=&NumSamples;
run;

proc summary data=BootSS; by replicate;
var x;
	output out=Bootdist (drop=_freq_ _type_) mean=mean_x median = median_x;
run;

data OutStatsUni; set Bootdist;
stat1 = mean_x; stat2=median_x; run;

title3 '2*_xbar';
proc sgplot data=OutStatsUni;
	histogram stat1; run;

title3 'x_median';
proc sgplot data=OutStatsUni;
	histogram stat2; run;			

title3 'Average_over_bootstrap_samples';
proc means data=OutStatsUni mean std median; var stat1 stat2 ;
output out=Outstats2;run;
