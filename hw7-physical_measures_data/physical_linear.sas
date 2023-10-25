libname jmp 
	'/home/jacktubbs/my_shared_file_links/jacktubbs/myfolders/JMP DATA/';
options center nodate pagesize=100 ls=80;

/* Simplified LaTeX output that uses plain LaTeX tables  *
ods latex path='/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/'
 file='physical_measures.tex' style=journal 
stylesheet="sas.sty"(url="sas");

/*
http://support.sas.com/rnd/base/ods/odsmarkup/latex.html 
*
ods graphics / reset width=5in  outputfmt=png
  antialias=on;

*/
TITLE1 'Physical Measures';

data PhysicalMeasures;
	set jmp.physicalmeasures;
run;

proc contents short;
run;

proc sgscatter data=PhysicalMeasures;
	matrix mass--head /diagonal=(histogram kernel);
run;


proc corr data=physicalmeasures pearson spearman kendall;
	var mass--head;
run;


proc reg data=PhysicalMeasures plots=fitplot;
model mass=fore / b rsquare ;
run;
