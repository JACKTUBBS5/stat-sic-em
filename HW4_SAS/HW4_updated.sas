/*Problem 1
  Reproduce the JMP analysis using R and SAS.  The original problem was to illustrate different sampling
  strategies in terms of the frequency of inspected parts. 

I have added the following for which I will consider some simple inference procedures.
*/
 
 DATA NEWDATA;
   INFILE '/home/u63549661/sasuser.v94/defects.csv' DLM=',' DSD;
   
   /* The most improtant step:
   we should pay more attention to the type of variables, 
   especially the type of sample var.
   We convert numeric type into character-string.*/
  
   INPUT Day Sample $ Defects; /* List the variables in your CSV file */
RUN;
 
title 'JMP Case Study for Defective Parts';
data defects; set NEWDATA; 
time = sample;  id=_n_; run;
*proc contents; run;

/* Check the type of variables */
PROC CONTENTS DATA=NEWDATA;
RUN;

/* Print the results */
proc print data=variable_types;
  title "Variable Types";
run;


/************Entire Data for defects *********/;
proc univariate data=NEWDATA normal plots;
var defects;
run;

proc sgplot data=NEWDATA;
histogram defects;
density defects/type=kernel;
run;

proc means data=NEWDATA; var defects; by day; run;


proc sgplot data=NEWDATA;
	heatmap x=day y=sample / 
	name='HeatMap' colorresponse=Defects discretex discretey;
	gradlegend 'HeatMap';
	keylegend / linelength=20 fillheight=2.5pct fillaspect=golden;
run;


/************SCHEME One Per day 9:30am *******/;
title 'One sample per day at 9:30 am';
data scheme_a; 
set NEWDATA; 

/*It works. We can fliter the dataset and the new sample is Sample =09:30. 
The number of this dataset is 10.*/

if Sample = '09:30';
run;
 
 
proc univariate data=scheme_a normal plots;
var defects;
run;

proc sgplot data=scheme_a;
histogram defects;
density defects/type=kernel;
run;

proc print data=scheme_a; 

proc means data=scheme_a noprint; var defects; by day;
output out=a mean=mean; run;
proc sgplot data=a;
scatter y=mean x=day;
series y=mean x=day;
loess y=mean x=day;
run;

proc sgplot data=scheme_a;
vbox defects/ group=day;
run;

proc sgplot data=scheme_a;
	heatmap x=day y=sample / 
	name='HeatMap' colorresponse=Defects discretex discretey;
	gradlegend 'HeatMap';
	keylegend / linelength=20 fillheight=2.5pct fillaspect=golden;
run;

/************SCHEME Two Per day 9:30am and 2:30 pm *******/;
title 'Two samples per day at 9:30 am and 2:30 pm';

/*pay more attention to the value in the dataset*/
data scheme_b; set NEWDATA; if sample in ('09:30','14:30'); run;
proc print data=scheme_b; run;

proc univariate data=scheme_b normal plots;
var defects;
run;

proc sgplot data=scheme_b;
histogram defects;
density defects/type=kernel;
run;


proc means data=scheme_b noprint; var defects; by day;
output out=b mean=mean; run;
proc sgplot data=b;
scatter y=mean x=day;
series y=mean x=day;
loess y=mean x=day;
run;

proc sgplot data=scheme_b;
vbox defects/ group=day;
run;

proc sgplot data=scheme_b;
	heatmap x=day y=sample / 
	name='HeatMap' colorresponse=Defects discretex discretey;
	gradlegend 'HeatMap';
	keylegend / linelength=20 fillheight=2.5pct fillaspect=golden;
run;


/************SCHEME Eight Per day 9:30am *******/;
title 'Eight samples per day every hour starting 8:30 am';
data scheme_c; set NEWDATA; 
if sample in ('08:45','09:15','10:15','11:30','12:30','13:30','14:15','15:45'); run;
proc univariate data=scheme_c normal plots;
var defects;
run;

proc sgplot data=scheme_c;
histogram defects;
density defects/type=kernel;
run;


proc means data=scheme_c noprint; var defects; by day;
output out=c mean=mean; run;
proc sgplot data=c;
scatter y=mean x=day;
series y=mean x=day;
loess y=mean x=day;
run;

proc sgplot data=scheme_c;
vbox defects/ group=day;
run;

proc sgplot data=scheme_c;
	heatmap x=day y=sample / 
	name='HeatMap' colorresponse=Defects discretex discretey;
*	reg x=day y=sample / nomarkers;
	gradlegend 'HeatMap';
	keylegend / linelength=20 fillheight=2.5pct fillaspect=golden;
run;


/************SCHEME 16 Per day 8:30am and 16:00 pm *******/;
title '16 samples per day every hour starting 8:30 am';
data scheme_d; set NEWDATA; 
if sample in ('08:30','08:45','09:15','10:00','10:45','11:15','11:30','11:45',
'12:00','12:30','12:45','13:15','13:45','14:30','15:30','15:45'); run;
proc univariate data=scheme_d normal plots;
var defects;
run;

proc sgplot data=scheme_d;
histogram defects;
density defects/type=kernel;
run;


proc means data=scheme_d noprint; var defects; by day;
output out=d mean=mean; run;
proc sgplot data=d;
scatter y=mean x=day;
series y=mean x=day;
loess y=mean x=day;
run;

proc sgplot data=scheme_d;
vbox defects/ group=day;
run;

proc sgplot data=scheme_d;
	heatmap x=day y=sample / 
	name='HeatMap' colorresponse=Defects discretex discretey;
	gradlegend 'HeatMap';
	keylegend / linelength=20 fillheight=2.5pct fillaspect=golden;
run;


/************SCHEME 32 Per day 9:30am and 2:30 pm *******/;
title '32 samples per day every 15-minutes starting 8:15 am';
data scheme_e; set NEWDATA; 
if sample in ('08:15','08:30','08:45','09:00',
			'09:15','09:30','09:45','10:00',
			'10:15','10:30','10:45','11:00',
			'11:15','11:30','11:45','12:00',
			'12:15','12:30','12:45','13:00',
			'13:15','13:30','13:45','14:00',
			'14:15','14:30','14:45','15:00',
			'15:15','15:30','15:45','16:00'); run;

proc univariate data=scheme_e normal plots;
var defects;

run;

proc sgplot data=scheme_e;
histogram defects;
density defects/type=kernel;
run;


proc means data=scheme_e noprint; var defects; by day;
output out=e mean=mean; run;
proc sgplot data=e;
scatter y=mean x=day;
series y=mean x=day;
loess y=mean x=day;
run;
proc sgplot data=scheme_e;
vbox defects/ group=day;
run;

proc sgplot data=scheme_e;
	heatmap x=day y=sample / 
	name='HeatMap' colorresponse=Defects discretex discretey;
	gradlegend 'HeatMap';
	keylegend / linelength=20 fillheight=2.5pct fillaspect=golden;
run;


/*Problem 2
  Are there differences in defects as a function of the time of day? Break the day into 4 parts - time of day
  early 8:00-10:00am, mid morning 10:15-12:00, early afternoon 12:15-2:00 pm, and late afternoon 2:15-4:00 pm. 
  Redo the graphics and descriptive statistics to illustrate how the number of defects is 
  influenced by the */
 
title 'JMP Case Study for Defective Parts';
title2 'Sampling for comparison of defects by time of day';
data data_p2; set NEWDATA; 
time = sample;  id=_n_; 
if  '08:00' le time le '10:00' then timeofday='early';
if  '10:15' le time le '12:00' then timeofday='midmorn';
if  '12:15' le time le '14:00' then timeofday='midaft';
if  '14:15' le time le '16:00' then timeofday='late';
run;

/************Entire Data for defects *********/;
proc univariate data=data_p2 normal plots;
var defects;
run;

proc sgplot data=data_p2;
histogram defects;
density defects/type=kernel;
run;

proc means data=data_p2; var defects; by timeofday; run;

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
proc glm data=data_p2;
class timeofday ;
model defects = timeofday;
run; 
 
 
 
/*Problem 3
  Are there differences in defects as a function of the time of week? Break the week into 2 parts - days 1,2,6,7 and 
  days 4,5,9,10. Redo the graphics and descriptive statistics to illustrate how the number of defects is influenced by
  the day of the week; early,and late.*/





