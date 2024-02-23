libname jmp  '/folders/myfolders/JMP DATA Library/AMSUS/PhysicalMeasures' ;
options center nodate pagesize=100 ls=80;
TITLE1 'AMSUS - Mortality Hard Water';
*title2 'Mortal = reduced mortality per 100,000';


data PhysicalMeasures;
  infile '/folders/myfolders/JMP DATA Library/AMSUS/PhysicalMeasures/PhysicalMeasures.dat' expandtabs;
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
  model mass=fore--head / selection=cp best=10;
run;

ods graphics off;
proc reg data=PhysicalMeasures;
forward:  model mass=fore--head / selection=f sle=.05 details=summary;
backward:  model mass=fore--head / selection=b sls=.05 details=summary;
stepwise:  model mass=fore--head / selection=stepwise sle=.05 sls=.05 details=summary;
run;

ods graphics on;
proc reg data=PhysicalMeasures;
  model mass=fore waist height thigh;
run;
/*
data jmp.physicalmeasures; set physicalmeasures; run;
*/

ods graphics on;
proc glmselect data=PhysicalMeasures;* plots(only)=cpplot(labelvars);
  model mass=Fore Bicep Chest Neck Shoulder 
             Waist Height Calf Thigh Head / selection=lasso details=summary;
run;

ods graphics off;
proc glmselect data=PhysicalMeasures;
stepwise:   model mass=Fore Bicep Chest Neck Shoulder 
                  Waist Height Calf Thigh Head/ selection=stepwise  details=summary;

run;
proc glmselect data=PhysicalMeasures;
lasso:      model mass=Fore Bicep Chest Neck Shoulder 
                       Waist Height Calf Thigh Head / selection=lasso details=summary;
run;
proc glmselect data=PhysicalMeasures;
elasticnet: model mass=Fore Bicep Chest Neck Shoulder 
                       Waist Height Calf Thigh Head / selection=elasticnet details=summary;
run;
