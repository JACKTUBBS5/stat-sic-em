libname files base "/home/u63546204/STA4382"; 

title1 "Red Wine Sas Analysis: Rita Dicarlo, Katie Clewett, Chang Guo"; 

data wine; 
attrib quality length = 8;
set files.wines_red; 
run; 

title1 "Scatterplot of data";
proc sgscatter data=wine;
	matrix quality -- ph /diagonal=(histogram kernel);
run;
title1; 

title2 "Stepwise Selection"; 
proc reg data=wine;
    model quality = vol_acidity  chlorides free_sulfur total_sulfur 
    pH sulphates alcohol/ selection=adjrsq aic ;
run;
quit; 
title2; 

title3 "Forward Selection";
proc reg data=wine;
    model quality = vol_acidity  chlorides free_sulfur total_sulfur 
    pH sulphates alcohol/ selection= forward aic;
run;
quit;
title3; 

title4 "Backward Selection";
proc reg data=wine;
    model quality = vol_acidity  chlorides free_sulfur total_sulfur 
    pH sulphates alcohol/ selection= backward aic;
run;
quit;
title4; 

ods graphics on;

title5 "Lasso procedure";
proc glmselect data=wine;
  model quality = vol_acidity  chlorides free_sulfur total_sulfur 
    pH sulphates alcohol/ selection=lasso ;
run;
title5;

title6 "Ridge procedure";
proc reg data=wine ridge=0 to .04 by .005 outest=out;
 model quality = vol_acidity  chlorides free_sulfur total_sulfur 
    pH sulphates alcohol;

run;
title6;


