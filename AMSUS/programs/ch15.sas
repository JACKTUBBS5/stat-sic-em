/* Chapter 15 */

data expo;
do lambda=0.1 to 0.3 by 0.1;
  do i=.001, 0.5 to 20 by 0.5;
  s=exp(-lambda*i);
  output;
  end;
end;
run;
proc sgplot data=expo;
   series y=s x=i /group=lambda;
   label i='Time' s='Survivor Function';
run;

data weibull;
length group $21;
do lambda=.8 ,1.2;
do gamma=.5 , 1.5;
  do i=.001, 0.5 to 20 by 0.5;
  s=exp(-lambda*i**gamma);
  h=lambda*gamma*i**(gamma-1);
  group='lambda='||put(lambda,3.1)||' gamma='||put(gamma,3.1);
  output;
  end;
end;
end;
run;
proc sgplot data=weibull;
   series y=s x=i /group=group;
   label i='Time' s='Survivor Function';
   keylegend / title='';
run;
proc sgplot data=weibull;
   series y=h x=i /group=group;
   label i='Time' h='Hazard Function';
   keylegend / title='';
run;


data melanoma34;
  infile 'c:\AMSUS\data\melanoma34.dat';
  input weeks status$;
  if status='alive' then censor=1;
     else censor=0;
run;

ods graphics on;
proc lifetest data=melanoma34 plots=(survival(cl));
  time weeks*censor(1);
run;

ods graphics on;
proc lifetest data=melanoma34 plots=(h(cl));
  time weeks*censor(1);
run;

proc lifetest data=melanoma34 outsurv=ltout method=lt intervals=1 to 170 noprint ;
  time weeks*censor(1);
run;
data ltout;
  set ltout;
  cumhaz+hazard;
run;
proc sgplot data=ltout;
  series y=cumhaz x=weeks;
run;


data HPA;
 infile 'c:\AMSUS\data\hpa.dat';
 input staining weeks censor;
run;

ods graphics on;
proc lifetest data=HPA plots=(s(cl));
  time weeks*censor(1);
  strata staining;
run;

data leukemia;
 infile cards dsd missover;
  treatment=_n_;
  do until(days=.);
    input number$ @;
    censor=0;
    if indexc(number,'+') then censor=1;
    number=compress(number,'+');
    days=input(number,3.);
    if days~=. then output;
  end;
cards;
4, 5, 9, 10, 11, 12, 13, 23, 28, 28, 28, 29, 31, 32, 37, 41, 41, 57, 62, 74, 100, 139, 200+, 258+, 269+
8, 10, 10, 12, 14, 20, 48, 70, 75, 99, 103, 162, 169, 195, 220, 161+, 199+, 217+, 245
8, 10, 11, 23, 25, 25, 28, 28, 31, 31, 40, 48, 89, 124, 143, 12+, 159+, 190+, 196+, 197+, 205+, 219+
;

proc lifetest data=leukemia plots=(s);
  time days*censor(1);
  strata treatment / test=(all);
run;

data melanoma;
 infile 'c:\AMSUS\data\melanoma.dat';
 input agegrp treatment censor survtime; 
run;

proc lifetest data=melanoma plots=(s);
  time survtime*censor(1);
  strata treatment agegrp ;
run;

proc power;
  twosamplesurvival 
      power=.8
      accrualtime = 12
      followuptime = 24
      groupmedsurvtimes=15 | 20 22 24
      npergroup = .;
run;

proc power plotonly;
  twosamplesurvival 
      power=.8
      accrualtime = 12
      followuptime = 24
      curve('md12')=12:.5
      curve('md15')=15:.5
      curve('md18')=18:.5
      refsurv='md12' 'md15' 'md18'     
      hazardratio=.4 to .8 by .1
      npergroup = .;
  plot x=effect ;
run;

