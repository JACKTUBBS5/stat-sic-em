options center nodate pagesize=100 ls=80;
*Put your data in this location;
libname yourdata 'your data location';

title "1986 Baseball Data";
data baseball; set yourdata.baseball;
run;

proc contents data=baseball;
run;
