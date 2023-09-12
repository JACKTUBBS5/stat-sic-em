
/* Chapter 8 */

data anaesthetic;
  infile 'c:\AMSUS\data\anaesthetic.dat' expandtabs;
  input duration trauma dlt;
run;

proc reg data=anasthetic;
  model dlt=duration trauma;
run;

data water;
  infile 'c:\AMSUS\data\water.dat';
  input location$ mortality calcium;
  if location='N' then region=1; 
     else region=0;
run;

proc sort data=water; by calcium; run;

proc reg data=water;
  model mortality= calcium region;
  output out=regout p=pred uclm=cihi lclm=cilo;
run;

proc sgplot data=regout;
 band x=calcium upper=cihi lower=cilo /group=location ;
 scatter y=mortality x=calcium /  markerchar=location;
 series y=pred x=calcium /group=location;
run;

data water;
  set water;
  reg_calc=region*calcium;
run;

proc reg data=water;
  model mortality= calcium region reg_calc;
  output out=regout p=pred uclm=cihi lclm=cilo;
run; 


proc sgplot data=regout;
 band x=calcium upper=cihi lower=cilo /group=location ;
 scatter y=mortality x=calcium /  markerchar=location;
 series y=pred x=calcium /group=location;
run;

data PhysicalMeasures;
  infile 'c:\AMSUS\data\PhysicalMeasures.dat' expandtabs;
input Mass Fore Bicep Chest Neck Shoulder Waist Height Calf Thigh Head;
run;

proc sgscatter data=PhysicalMeasures;
 matrix mass--head /diagonal=(histogram kernel);
run;

proc reg data=PhysicalMeasures;
  model mass=fore--head /vif;
run;

ods graphics on;
proc reg data=PhysicalMeasures plots(only)=cpplot(labelvars);
  model mass=fore--head / selection=cp best=20;
run;

ods graphics off;
proc reg data=PhysicalMeasures;
forward:  model mass=fore--head / selection=f sle=.05 ;
backward:  model mass=fore--head / selection=b sls=.05 ;
stepwise:  model mass=fore--head / selection=stepwise sle=.05 sls=.05 ;
run;

ods graphics on;
proc reg data=PhysicalMeasures;
  model mass=fore waist height thigh;
run;

data factorial;
do a=1 to 2;
input resp @;
b=1;
if _n_>4 then b=2;
output;
end;
cards;
23  22
25  23
27  21
29  21
26  37
32  38
30  40
31  35
;

data factorial;
  set factorial;
  if a=1 then x1=1;
         else x1=-1;
  if b=1 then x2=1;
         else x2=-1;
  x3=x1*x2;
run;

ods graphics off;
proc reg data=factorial;
x1: model resp=x1;
x12: model resp=x1 x2;
x123: model resp=x1-x3;
run; quit;

