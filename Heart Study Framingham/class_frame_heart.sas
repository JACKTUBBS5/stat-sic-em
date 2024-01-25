options center nodate pagesize=100 ls=80;
*Put your data in this location;
libname yourdata 'your data location';

/*
The Sashelp.heart data set provides results from the Framingham Heart Study. 
The following steps display information about the data set Sashelp.heart. 
The data set contains 5,209 observations.
*/

title "Framingham Heart Study";
data frame; set yourdata.framingham; 
run;

proc contents data=frame varname;
run;

