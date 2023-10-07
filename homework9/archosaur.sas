*Archosaur Assignment
*White group: Rita Dicarlo, Katie Clewett, Chang Zuo
*SAS code; 


*Reading data from SAS Input File; 
libname files base "/home/u63546204/STA4382"; 
proc contents data = brain; 
run; 

*Setting and Transforming the data;  
data brain; 
set files.archosaur; 
log_bw = log(body_weight); 
log_brain = log(brain_weight); 
run; 

*Graphing data; 
title "Brain and body weight";
proc sgplot data=brain;
  scatter x=log_bw y=log_brain;
  reg x=log_bw y=log_brain;
run;
title;

*Results; 
proc reg data = brain; 
model log_brain = log_bw; 
run; 

 