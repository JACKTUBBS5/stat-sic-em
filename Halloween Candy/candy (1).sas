libname ldata '/home/jacktubbs/my_shared_file_links/jacktubbs/2022_Exam';
options center nodate pagesize=120 ls=80;


title2 "Halloween Candy";
data candy; set ldata.candy;
n=_n_;
run;
proc contents varnum;  run;
proc print data=candy; where n < 11; run;

proc sgplot data=candy;
histogram win;
density win/type=kernel;
run;   
proc sgscatter data=candy;
   matrix win sugar price/
      ellipse=(type=mean)
      diagonal=(histogram kernel);
run;
quit;
