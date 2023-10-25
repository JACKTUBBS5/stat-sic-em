libname ldata '/home/u63576145/sasuser.v94';

*/
*ods graphics on;
title 'Sheather KDE Simulated Data';
ods graphics on;
data bimodal; set ldata.bimodal; run;
proc kde data=bimodal;
   univar x(bwm=1) x(bwm=5) x(bwm=10);
run;

proc sgplot data=bimodal;
histogram x;
density x/type=kernel;
run;

title 'Old Faithful Data';
data faithful; set ldata.faithful;
run;

proc sgplot data=faithful;
scatter y=wait x=duration;
reg y=wait x=duration/ clm;
loess y=wait x=duration;
run;
proc sgplot data=faithful;
histogram wait;
density wait;
run;
ods graphics on;
proc kde data=faithful;
univar wait;
run;

proc kde data=faithful;
   bivar wait duration  ;
run;
quit;