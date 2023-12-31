options center nodate pagesize=100 ls=70;
libname mydata '/home/u63555033/STA 4382/Data';


title 'JMP Case Study for Defective Parts';
data defects; set mydata.defects; 
time = sample;  id=_n_; run;
*proc contents; run;

/************Entire Data for defects *********/;
proc univariate data=defects normal plots;
var defects;
*histogram;
run;

proc sgplot data=defects;
histogram defects;
density defects/type=kernel;
run;

proc means data=defects; var defects; by day; run;

/***********  Heat Map  **************************/;
*ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.DEFECTS;
	heatmap x=day y=sample / 
	name='HeatMap' colorresponse=Defects discretex discretey;
*	reg x=day y=sample / nomarkers;
	gradlegend 'HeatMap';
	keylegend / linelength=20 fillheight=2.5pct fillaspect=golden;
run;

*ods graphics / reset;

/************SCHEME One Per day 9:30am *******/;
title 'One sample per day at 9:30 am';
data scheme_a; set defects; if sample = 34200; run;
proc univariate data=scheme_a normal plots;
var defects;
*histogram;
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
*	reg x=day y=sample / nomarkers;
	gradlegend 'HeatMap';
	keylegend / linelength=20 fillheight=2.5pct fillaspect=golden;
run;


/************SCHEME Two Per day 9:30am and 2:30 pm *******/;
title 'Two samples per day at 9:30 am and 2:30 pm';
data scheme_b; set defects; if sample in (34200,52200); run;
*proc print data=scheme_b; run;
proc univariate data=scheme_b normal plots;
var defects;
*histogram;
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
*	reg x=day y=sample / nomarkers;
	gradlegend 'HeatMap';
	keylegend / linelength=20 fillheight=2.5pct fillaspect=golden;
run;


/************SCHEME Eight Per day 9:30am *******/;
title 'Eight samples per day every hour starting 8:30 am';
data scheme_c; set defects; 
if sample in (30600,34200,37800,41400,45000,48600,52200,55800); run;
proc univariate data=scheme_c normal plots;
var defects;
*histogram;
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


/************SCHEME 16 Per day 9:30am and 2:30 pm *******/;
title '16 samples per day every hour starting 8:30 am';
data scheme_d; set defects; 
if sample in (30600,32400,34200,36000,37800,39600,41400,43200,
              45000,46800,48600,50400,52200,54000,55800,57600); run;
proc univariate data=scheme_d normal plots;
var defects;
*histogram;
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
*	reg x=day y=sample / nomarkers;
	gradlegend 'HeatMap';
	keylegend / linelength=20 fillheight=2.5pct fillaspect=golden;
run;


/************SCHEME 32 Per day 9:30am and 2:30 pm *******/;
title '32 samples per day every 15-minutes starting 8:15 am';
data scheme_e; set defects; 
*if sample in (30600,32400,34200,36000,37800,39600,41400,43200,
              45000,46800,48600,50400,52200,54000,55800,57600); run;
proc univariate data=scheme_e normal plots;
var defects;
*histogram;
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
*	reg x=day y=sample / nomarkers;
	gradlegend 'HeatMap';
	keylegend / linelength=20 fillheight=2.5pct fillaspect=golden;
run;