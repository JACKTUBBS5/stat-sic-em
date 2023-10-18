libname ldata '/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Class';
options center nodate pagesize=120 ls=80;



title 'Binge Drinking US 18-25 by gender';
data binge; set ldata.binge_drinking; 
drop var4; run;

proc sgplot data=binge;
scatter y=female x=year;
reg y=female x=year;
run;

proc sgplot data=binge;
scatter y=male x=year;
reg y=male x=year;
run;

data new_binge; set binge;
gender = 'male';   percent = male; output;
gender = 'female'; percent = female; output;
drop male female;
run;

proc sgplot data=new_binge;
scatter y=percent x=year;
reg y=percent x=year/ group=gender;
run;


/* Stream a CSV representation of new_bwgt directly to the user's browser. *

proc export data=new_binge
            outfile=_dataout
            dbms=csv replace;
run;

%let _DATAOUT_MIME_TYPE=text/csv;
%let _DATAOUT_NAME=new_binge_drinking.csv;

