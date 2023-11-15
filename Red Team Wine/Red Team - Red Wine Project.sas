libname ldata '/home/u63555033/STA 4382/Data';
options center nodate pagesize=120 ls=80;
/*
Citation Request:
  This dataset is public available for research. The details are described 
  in [Cortez et al., 2009]. 
  Please include this citation if you plan to use this database:

  P. Cortez, A. Cerdeira, F. Almeida, T. Matos and J. Reis. 
  Modeling wine preferences by data mining from physicochemical properties.
  In Decision Support Systems, Elsevier, 47(4):547-553. ISSN: 0167-9236.

  Available at: [@Elsevier] http://dx.doi.org/10.1016/j.dss.2009.05.016
                [Pre-press (pdf)] http://www3.dsi.uminho.pt/pcortez/winequality09.pdf
                [bib] http://www3.dsi.uminho.pt/pcortez/dss09.bib

1. Title: Wine Quality 

2. Sources
   Created by: Paulo Cortez (Univ. Minho), Antonio Cerdeira, 
   Fernando Almeida, Telmo Matos and Jose Reis (CVRVV) @ 2009
   
3. Past Usage:

  P. Cortez, A. Cerdeira, F. Almeida, T. Matos and J. Reis. 
  Modeling wine preferences by data mining from physicochemical properties.
  In Decision Support Systems, Elsevier, 47(4):547-553. ISSN: 0167-9236.

  In the above reference, two datasets were created, using red and white wine samples.
  The inputs include objective tests (e.g. PH values) and the output is based on sensory data
  (median of at least 3 evaluations made by wine experts). Each expert graded the wine quality 
  between 0 (very bad) and 10 (very excellent). Several data mining methods were applied to model
  these datasets under a regression approach. The support vector machine model achieved the
  best results. Several metrics were computed: MAD, confusion matrix for a fixed error tolerance (T),
  etc. Also, we plot the relative importances of the input variables (as measured by a sensitivity
  analysis procedure).
 
4. Relevant Information:

   The two datasets are related to red and white variants of the Portuguese "Vinho Verde" wine.
   For more details, consult: http://www.vinhoverde.pt/en/ or the reference [Cortez et al., 2009].
   Due to privacy and logistic issues, only physicochemical (inputs) 
   and sensory (the output) variables 
   are available (e.g. there is no data about grape types, wine brand, wine selling price, etc.).

   These datasets can be viewed as classification or regression tasks.
   The classes are ordered and not balanced (e.g. there are munch more normal wines than
   excellent or poor ones). Outlier detection algorithms could 
   be used to detect the few excellent
   or poor wines. Also, we are not sure if all input variables are relevant. So
   it could be interesting to test feature selection methods. 

5. Number of Instances: red wine - 1599; white wine - 4898. 

6. Number of Attributes: 11 + output attribute
  
   Note: several of the attributes may be correlated, thus it makes sense to 
   apply some sort of
   feature selection.

7. Attribute information:

   For more information, read [Cortez et al., 2009].

   Input variables (based on physicochemical tests):
   1 - fixed acidity (tartaric acid - g / dm^3)
   2 - volatile acidity (acetic acid - g / dm^3)
   3 - citric acid (g / dm^3)
   4 - residual sugar (g / dm^3)
   5 - chlorides (sodium chloride - g / dm^3
   6 - free sulfur dioxide (mg / dm^3)
   7 - total sulfur dioxide (mg / dm^3)
   8 - density (g / cm^3)
   9 - pH
   10 - sulphates (potassium sulphate - g / dm3)
   11 - alcohol (% by volume)
   Output variable (based on sensory data): 
   12 - quality (score between 0 and 10)

8. Missing Attribute Values: None

9. Description of attributes:

   1 - fixed acidity: most acids involved with wine or fixed or nonvolatile 
   (do not evaporate readily)

   2 - volatile acidity: the amount of acetic acid in wine, which at too 
   high of levels can lead to an unpleasant, vinegar taste

   3 - citric acid: found in small quantities, citric acid can add 'freshness' 
   and flavor to wines

   4 - residual sugar: the amount of sugar remaining after fermentation stops, 
   it's rare to find wines with less than 1 gram/liter and wines with greater 
   than 45 grams/liter are considered sweet

   5 - chlorides: the amount of salt in the wine

   6 - free sulfur dioxide: the free form of SO2 exists in equilibrium between 
   molecular SO2 (as a dissolved gas) and bisulfite ion; it prevents microbial 
   growth and the oxidation of wine

   7 - total sulfur dioxide: amount of free and bound forms of S02; 
   in low concentrations, SO2 is mostly undetectable in wine, but at 
   free SO2 concentrations over 50 ppm, SO2 becomes evident in the nose and taste of wine

   8 - density: the density of water is close to that of water depending 
   on the percent alcohol and sugar content

   9 - pH: describes how acidic or basic a wine is on a scale 
   from 0 (very acidic) to 14 (very basic); most wines are between 3-4 on the pH scale

   10 - sulphates: a wine additive which can contribute to sulfur 
   dioxide gas (S02) levels, wich acts as an antimicrobial and antioxidant

   11 - alcohol: the percent alcohol content of the wine

   Output variable (based on sensory data): 
   12 - quality (score between 0 and 10)

data ldata.wines_red; set work.import; run;	
	

*/

title 'Red Wine Data';
data wines_red; set ldata.wines_red;
if quality < 6 then r_quality = 0;
if quality > 6 then r_quality = 1;
good_quality = (r_quality = 0);
run;


proc contents data=wines_red short; run;

proc sort data=wines_red; by quality;  run;

proc means data=wines_red; var  alcohol chlorides citric_acid density fix_acidity 
free_sulfur pH  sugar sulphates total_sulfur vol_acidity ;
    run;
    
proc means data=wines_red; var  alcohol chlorides citric_acid density fix_acidity 
free_sulfur pH  sugar sulphates total_sulfur vol_acidity ; by quality;
    run;
        

PROC SGPLOT data=wines_red;
vbox sugar/group=quality;
RUN;

PROC SGPLOT data=wines_red;
histogram sugar;
density sugar /type=kernel group=quality;
RUN;

proc sgscatter data=wines_red;
matrix quality alcohol chlorides citric_acid density fix_acidity 
free_sulfur pH  sugar sulphates total_sulfur vol_acidity /diagonal=(histogram);
    run;
    
PROC SGPLOT data=wines_red;
SCATTER Y=sugar X=citric_acid;
LOESS Y=sugar X=citric_acid/group=r_quality;
reg Y=sugar X=citric_acid/group=r_quality;
RUN;

data new; set wines_red; 
alcohol2 = alcohol*alcohol;
run;

title2 'Correlation and Scatterplot for all the variables';
data wines_red;
	set ldata.wines_red;
run;
    
proc corr data=wines_red pearson spearman kendall;
	var fix_acidity--quality;
run;

title2 'Classification - Random Forest';
proc hpforest data=wines_red maxtrees=100 inbagfraction=0.3;
	input alcohol chlorides citric_acid density fix_acidity 
free_sulfur pH  sugar sulphates total_sulfur vol_acidity/level=interval;
	target quality/level=binary;
	ods output WineStatistics=winestats(rename=(Ntrees=Trees));
run;

data winestats;
	set winestats;
	label Trees = 'Number of Trees';
	label MiscAll = 'Full Data';
	label MiscOob = 'OOB';
run;  

proc sgplot data=winestats;
	title "OOB vs Training";
	series x=Trees y=MiscAll;
	series x=Trees y=MiscOob/lineattrs=(pattern=shortdash thickness=2);
	yaxis label='Misclassification Rate';
run;
title;


title2 'Multiple Regression (citric_acid, pH, and fix_acidity)';
  proc reg data=wines_red  plots = (diagnostics partial);
model quality=citric_acid pH fix_acidity /b ss1 ss2 ;
run;
    
title2 'Multiple Regression (citric_acid, pH, and sugar)';
  proc reg data=wines_red  plots = (diagnostics partial);
model quality=citric_acid pH sugar /b ss1 ss2 ;
run;  

title2 'Multiple Regression (alcohol, density, and sulphates)';
  proc reg data=wines_red  plots = (diagnostics partial);
model quality=alcohol density sulphates /b ss1 ss2 ;
run;  
//chosen based off of variable importance in random forest procedure. R squared still not very high (0.27)

title2 'Polynomial Regression - second degree Quadratic - alcohol';
  proc reg data=new  plots = (diagnostics partial);
model quality=alcohol alcohol2/ b ss1;
run;
//not working(?)

/*ods graphics on;
title 'Model Selection with Proc Reg';
proc reg data=new plots(only)=cpplot(labelvars);
model mass=fore bicep chest neck shoulder waist height calf 
	thigh head/selection=cp best=10;
	run;
	do for wine*/
