***********************************************************;
*Author: Rita Dicarlo, Katie Clewett, Chang Guo
*Assignment 10: Multiple and Polynomial Regression
*Fall 2023                    
***********************************************************;
libname files base "/home/u63546204/STA4382"; 

data physical; 
set files.physicalmeasures; 
calf2 = calf * calf; 
run; 


proc sgscatter data=physical;
 matrix mass--head /diagonal=(histogram kernel);

run;
proc reg data = physical; 
model mass = calf calf2; 
run; 


run;
proc reg data = physical; 
model mass = bicep height; 
run;
