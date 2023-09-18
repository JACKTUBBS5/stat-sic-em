
title1 'Simulated Linear Regression';

/********************************************************************
 Simple Linear Regression Models
 *******************************************************************/
       
%let N = 30;                            /* size of each sample      */
%let beta_0 = 10;                       /* true y-intercept         */
%let beta_1 = 2;                        /* true slope               */
%let sigma=9;                           /* true sigma               */
data Reg1(keep=x y);
call streaminit(1);
do i = 1 to &N;
   x = 10*rand("Uniform");              /* explanatory variable     */
   eps = rand("Normal", 0, &sigma);     /* error term N(0,sigma)    */
   y = &beta_0 + &beta_1*x + eps;                   
   output;
end;
run;

data reg_out; set Reg1;

proc sgplot data=reg_out;
scatter y=y x=x;
reg y=y x=x;
run;

proc reg data=Reg1 plots=FITPLOT;
   model y = x;
*   ods exclude NObs;
   run;
quit;
