
/* Chapter 4 */

proc power;
   twosamplefreq 
      oddsratio = 2
      refproportion = 0.3
      power = 0.9
      npergroup = .
      ;
run;

proc power;
   twosamplefreq 
      oddsratio = 2
      refproportion = 0.3
      power = 0.9
      groupweights=(5 1)
      ntotal = .
      ;
run;

proc power;
   twosamplefreq 
      relativerisk = 1.5
      refproportion = 0.005
      power = 0.9
      npergroup = .
      ;
run;

proc power plotonly;
   twosamplefreq 
      relativerisk = 2 to 10 by .5
      refproportion = 0.005
      power = .
      groupns =(600 400)
      ;
      plot x=effect ;
run;


data self_exam;
input agegroup $ frequency $ num;
datalines;
Under45 Monthly  91 
Under45 Rarely  141
Over45  Monthly 259
Over45  Rarely  705
;

data ca_cervix;
 input debutage $ status $ num;
 datalines;
  Under15 case    36    
  Under15 control 78
  Over15  case    11
  Over15  control 95
 ;

data ca_lung;
 input group $ lung_ca $ num;
 datalines;
  Smoker    Yes 45    
  Smoker    No  355
  Nonsmoker Yes 5
  Nonsmoker No  595
 ;

proc freq data=self_exam order=data;
 tables agegroup*frequency /chisq;
 weight num;
run;

proc freq data=ca_cervix order=data;
 tables Debutage*status /chisq;
 weight num;
run;

proc freq data=ca_lung order=data;
 tables Group*lung_ca /chisq;
 weight num;
run;

proc freq data=self_exam order=data;
 tables agegroup*frequency /relrisk;
 weight num;
run;

proc freq data=ca_cervix order=data;
 tables Debutage*status /relrisk;
 weight num;
run;

proc freq data=ca_lung order=data;
 tables Group*lung_ca /relrisk;
 weight num;
run;

data delinquency;
  input specs$ delinquent$ n;
cards;
Y Y 1
Y N 5
N Y 8
N N 2
;

proc freq data=delinquency;
  tables specs*delinquent / chisq;
  weight n;
run;

data lesions;
  length region $8.;
  input site $ 1-16 n1 n2 n3;
  region='Keral';   n=n1;  output;
  region='Gujarat'; n=n2;  output;
  region='Anhara';  n=n3;  output;
  drop n1-n3;
cards;
Buccal Mucosa    8  1  8
Labial Mucosa    0  1  0
Commissure       0  1  0
Gingiva          0  1  0
Hard palate      0  1  0
Soft palate      0  1  0
Tongue           0  1  0
Floor of mouth   1  0  1
Alveolar ridge   1  0  1
;
run;

proc freq data=lesions order=data;
  tables site*region /exact;
  weight n;
run;


data pill_use;
  input caseused $ controlused $ num;
cards;
Y Y 10
Y N 57
N Y 13
N N 95
;
run;

proc freq data=pill_use order=data;
 tables caseused*controlused / agree;
 weight num;
run;

data bronchitis;
  input agegrp level $ bronch $ num;
cards;
1 H Y 62
1 H N 915
1 L Y 7 
1 L N 442
2 H Y 20
2 H N 382
2 L Y 9 
2 L N 214
3 H Y 10
3 H N 172
3 L Y 7
3 L N 120
4 H Y 12
4 H N 327
4 L Y 6
4 L N 183
;

proc freq data=bronchitis order=data;
  Tables agegrp*level*bronch / cmh noprint;
  weight num;
run;

proc freq data=bronchitis order=data;
  Tables agegrp*level*bronch / relrisk noprint;
  weight num;
ods output RelativeRisks=rr;
run;
proc print data=rr(where=(StudyType=:'Case'));
var table value--uppercl;
run;

proc freq data=bronchitis order=data;
  Tables agegrp*level*bronch / cmh noprint;
  weight num;
  where agegrp>1;
run;

