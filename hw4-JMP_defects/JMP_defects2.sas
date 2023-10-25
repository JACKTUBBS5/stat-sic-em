options center nodate pagesize=100 ls=70;
libname mydata '/home/jacktubbs/my_shared_file_links/jacktubbs/New';

/* Simplified LaTeX output that uses plain LaTeX tables  *
ods latex path='/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/clean'
 file='JMP_defects1.tex' style=journal stylesheet="sas.sty"(url="sas");

/*
http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 
*
ods graphics / reset width=5in  outputfmt=png
  antialias=on;
*/;



title 'JMP Case Study for Defective Parts';
title2 'Sampling for comparison of defects by time of day';
data defects; set mydata.defects; 
time = sample;  id=_n_; 
if 29700 le time le 36000 then timeofday='early';
if 36900 le time le 43200 then timeofday='midmorn';
if 44100 le time le 50400 then timeofday='midaft';
if 51300 le time le 57600 then timeofday='late';
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

proc means data=defects; var defects; by timeofday; run;

/***********  Heat Map  **************************/;
*ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.DEFECTS;
	heatmap x=timeofday y=sample / 
	name='HeatMap' colorresponse=Defects discretex discretey;
*	reg x=day y=sample / nomarkers;
	gradlegend 'HeatMap';
	keylegend / linelength=20 fillheight=2.5pct fillaspect=golden;
run;


/************ANOVA for defects *******/;
proc glm data=defects;
class timeofday ;
model defects = timeofday;
run; 

