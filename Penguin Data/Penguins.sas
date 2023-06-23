libname ldata '/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Class';
options center nodate pagesize=120 ls=80;


title 'Penguin Data';
data penguins; set ldata.penguins;
run;


proc contents data=penguins varnum; run;
/*
proc print; run;
*/
PROC SGPLOT data=penguins;
SCATTER Y=body_mass_g X=flipper_length_mm/group=species;
*LOESS Y=body_mass_g X=flipper_length_mm/group=species;
reg Y=body_mass_g X=flipper_length_mm/group=species;

RUN;


PROC SGPLOT data=penguins;
histogram bill_length_mm/group=species;
density bill_length_mm/type=kernel group=species;
RUN;

proc freq data=penguins;
  tables species*island/nopercent nocol; run;



/* Stream a CSV representation of new_bwgt directly to the user's browser. *

data ldata.penguins; set work.import2; run;
proc export data=indy500_winners
            outfile=_dataout
            dbms=csv replace;
run;

%let _DATAOUT_MIME_TYPE=text/csv;
%let _DATAOUT_NAME=indy500_winners.csv;


