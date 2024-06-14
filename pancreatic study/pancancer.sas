libname ldata  '/home/jacktubbs/my_shared_file_links/jacktubbs/myfolders/Disease/pancreatic cancer' ;
options nodate center nonumber ps=200 ls=80 formdlim=' ';

/*
data ldata.pancreatic; set work.import; run;
*/
proc contents data=ldata.pancreatic varnum; run;

data pan_cancer; set ldata.pan_cancer;
drop benign_sample_diagnosis sample_origin diagnosis stage; run;
proc print data=pan_cancer (obs=10); run;

proc sgplot data=pan_cancer;
vbar patient_cohort;
run;

proc sgplot data=pan_cancer;
histogram creatinine /group = patient_cohort;
density creatinine /group = patient_cohort;
run;