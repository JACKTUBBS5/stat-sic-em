options center nodate pagesize=100 ls=70;
libname mydata '/home/u63555033/STA 4382/Data';


title 'JMP Case Study for Defective Parts';
title2 'Sampling for comparison of defects by day of the week';
data defects; set mydata.defects; 
time = sample;  id=_n_; 
if day in (1,2,6,7) then dayofweek='early';
if day in (4,5,9,10) then dayofweek='late';
/*
if 29700 le time le 36000 then timeofday='early';
if 36900 le time le 43200 then timeofday='midmorn';
if 44100 le time le 50400 then timeofday='midaft';
if 51300 le time le 57600 then timeofday='late';
if day ne 3 or 8;
*/
run;

/************Entire Data for defects *********/;
proc univariate data=defects normal plots;
var defects;
*histogram;
run;

proc sgplot data=defects;
histogram defects;
density defects/type=kernel;
run;

proc sort data=defects; by dayofweek; run;

proc means data=defects; var defects; by dayofweek; run;

/***********  Heat Map  **************************/;
*ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.DEFECTS;
	heatmap x=dayofweek y=sample / 
	name='HeatMap' colorresponse=Defects discretex discretey;
*	reg x=day y=sample / nomarkers;
	gradlegend 'HeatMap';
	keylegend / linelength=20 fillheight=2.5pct fillaspect=golden;
run;


/************ANOVA for defects *******/;
proc glm data=defects;
class dayofweek ;
model defects = dayofweek;
run; 