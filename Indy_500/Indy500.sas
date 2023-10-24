libname ldata '/home/jacktubbs/my_shared_file_links/jacktubbs/LaTeX/Class';
options center nodate pagesize=120 ls=80;


title 'History of Indy 500';
data indy500_winners; set ldata.indy500_winners; run;

/*
   input Year SP CAR DRIVER :$100. QUALIFY_SPEED RACE_TIME :$15. RACE_SPEED;
   informat RACE_TIME hhmmss12.;
   format RACE_TIME hhmmss12.;
   datalines;
1911 28 32 RHarroun  .     6:42:08.000 74.602
1912  7  8 JDawson 86.130  6:21:06.000 78.719
1913  7 16 JGoux   86.030  6:35:05.000 75.933
1914 15 16 RThomas 94.540  6:03:45.000 82.474
1915  2  2 RDePalma 98.580 5:33:55.510 89.840
1916  4 17 DResta   94.400 3:34:17.000 84.001
1919  2  3 HWilcox 100.010 5:40:42.870 88.050
1920  6  4 Gaston   91.550 5:38:32.000 88.618
1921 20  2 TMilton  93.050 5:34:44.650 89.621
1922  1 35 JMurphy 100.500 5:17:30.790 94.484
1923  1  1 TMilton 108.170 5:29:50.170 90.954
1924 21 15 LCorum   93.330 5:05:23.510 98.234
1925  2 12 PDePaolo 113.080 4:56:39.460 101.127
1926 20 15 FLockhart 95.780 4:10:14.950 95.904
1927 22 32 GSouders 111.550 5:07:33.080 97.545
1928 13 14 LMeyer 111.350 5:01:33.750 99.482
1929  6  2 RKeech 114.900 5:07:25.420 97.585
1930  1  4 BArnold 113.260 4:58:39.720 100.448
1931 13 23 LSchneider 107.210 5:10:27.930 96.629
1932 27 34 FFrame 113.850 4:48:03.790 104.144
1933  6 36 LMeyer 116.970 4:48:00.750 104.162
1934 10  7 BCummings 116.110 4:46:05.200 104.863
1935 22  5 KPetillo 115.090 4:42:22.710 106.240
1936 28  8 LMeyer 114.170 4:35:03.390 109.069
1937  2  6 WShaw 122.790 4:24:07.800 113.580
1938  1 23 FRoberts 125.680 4:15:58.400 117.200
1939  3  2 WShaw 128.970 4:20:47.390 115.035
1940  2  1 WShaw 127.060 4:22:31.170 114.277
1941 17 16 FDavis 121.100 4:20:36.240 115.117
1946 15 16 GRobson 125.540 4:21:16.700 114.820
1947  3 27 MRose 120.040 4:17:52.170 116.338
1948  3  3 MRose 129.120 4:10:23.330 119.814
1949  4  7 BHolland 128.670 4:07:15.970 121.327
1950  5  1 JParsons 132.040 2:46:55.970 124.002
1951  2 99 LWallard 135.030 3:57:38.050 126.244
1952  7 98 TRuttman 135.360 3:52:41.880 128.922
1953  1 14 BVukovich 138.390 3:53:01.690 128.740
1954 19 14 BVukovich 138.470 3:49:17.270 130.840
1955 14  6 BSweikert 145.590 3:53:28.840 128.490
1957 13  9 SHanks 142.810 3:41:14.250 135.601
1958  7  1 JBryan 144.180 3:44:13.800 133.791
1959  6  5 RWard 144.030 3:40:49.200 135.857
1960  2  4 JRathmann 146.370 3:36:11.360 138.767
1961  7  1 A.J.Foyt 145.900 3:35:37.490 139.130
1962  2  3 RWard 151.150 3:29:35.400 143.137
1965  2 82 JClark 160.720 3:19:05.340 150.686
1966 15 24 GHill 159.240 3:27:52.530 144.317
1967  4 14 A.J.Foyt 166.280 3:18:24.220 151.207
1968  3  3 BUnser 169.500 3:16:13.760 152.882
1969  2  2 MAndretti 169.850 3:11:14.710 156.867
1970  1  2 AUnser 170.220 3:12:37.040 155.749
1971  5  1 AUnser 174.520 3:10:11.560 157.735
1972  3 66 MDonohue 191.400 3:04:05.540 162.962
1973 11 20 GJohncock 192.550 2:05:26.590 159.036
1974 25  3 JRutherford 190.440 3:09:10.060 158.589
1975  3 48 BUnser 191.070 2:54:55.080 149.213
1976  1  2 JRutherford 188.950 1:42:52.000 148.725
1977  4 14 A.J.Foyt 194.560 3:05:57.160 161.331
1978  5  2 AUnser 196.470 3:05:54.990 161.363
1979  1  9 RMears 193.730 3:08:47.970 158.899
1980  1  4 JRutherford 192.520 3:29:59.560 142.862
1981  1  3 BUnser 200.540 3:35:41.780 139.084
1982  5 20 GJohncock 201.880 3:05:09.140 162.029
1983  4  5 TSneva 203.680 3:05:03.066 162.117
1984  3  6 RMears 207.840 3:03:21.660 163.612
1985  8  5 DSullivan 210.290 3:16:06.069 152.982
1986  4  3 BRahal 213.550 2:55:43.480 170.722
1987 20 25 AUnser 207.420 3:04:59.147 162.175
1988  1  5 RMears 219.190 3:27:10.204 144.809
1989  3 20 EFittipaldi 222.320 2:59:01.049 167.581
1990  3 30 ALuyendyk 223.300 2:41:18.404 185.981
1991  1  3 RMears 224.113 2:50:00.791 176.457
1992 12  3 AUnser 222.989 3:43:05.148 134.477
1993  9  4 EFittipaldi 220.150 3:10:49.860 157.207
1994  1 31 AUnser 228.011 3:06:29.006 160.872
1995  5 27 JVilleneuve 228.397 3:15:17.561 153.616
1996  5 91 BLazier 231.468 3:22:45.753 147.956
1997  1  5 ALuyendyk 218.263 3:25:43.388 145.827
1998 17 51 ECheever 217.334 3:26:40.524 145.155
1999  8 14 KBrack 222.659 3:15:51.182 153.176
2000  2  9 JPablo 223.372 2:58:59.431 167.607
2001 11 68 HCastroneves 224.142 3:31:54.180 141.574
2002 13  3 HCastroneves 229.052 3:00:10.8714 166.499
2003 10  6 GFerran 228.633 3:11:56.9891 156.291
2004  1 15 BRice 222.024 3:14:55.2395 138.518
2005 16 26 DWheldon 224.308 3:10:21.0769 157.603
2006  1  6 SHornish 228.985 3:10:58.7590 157.085
2007  3 27 DFranchitti 225.191 2:44:03.5608 151.774
2008  1  9 SDixon 226.366 3:28:57.6792 143.567
2009  1  3 HCastroneves 224.864 3:19:34.6427 150.318
2010  3  9 DFranchitti 226.990 3:05:37.0131 161.623
2011  6 98 DWheldon 226.490 2:56:11.7267 170.265
2012 16 50 DFranchitti 223.582 2:58:51.2532 167.734
2013 12 11 TKanaan 226.949 2:40:03.4181 187.433
2014 19 28 RHunter-Reay 229.719 2:40:48.2305 186.563
2015 15  2 JPablo 224.657 3:05:56.5286 161.341
2016 11 98 ARossi 228.473 3:00:02.0872 166.634
2017  4 26 TSato 231.365 3:13:03.3584 155.395
2018  3 12 WPower 228.607 2:59:42.6365 166.935
2019  1 22 SPagenaud 229.992 2:50:39.2797 175.794
2020  3 30 TSato 230.725 3:10:05.0880 157.824
2021  8  6 HCastroneves 230.355 2:37:19.3846 190.690
2022  5  8 MEricsson 232.764 2:51:00.6
;
*/
*proc contents data=indy500_winners varnum; run;
data indy500_winners; set indy500_winners; if year > 1960; run;
title2 'Year > 1960';
proc print; run;

PROC SGPLOT data=indy500_winners;
SCATTER Y=RACE_SPEED X=YEAR;
LOESS Y=RACE_SPEED X=YEAR;
reg Y=RACE_SPEED X=YEAR;

RUN;


PROC SGPLOT data=indy500_winners;
histogram RACE_SPEED;
density RACE_SPEED/type=kernel;
RUN;


proc tpspline data=indy500_winners; plots=fitplot(clm);
   model race_speed = (year);
*   score data = pred out  = predy;
run;

proc loess data=indy500_winners;
   ods output OutputStatistics = sj_Fit
              FitSummary=Summary;
   model race_speed = year / degree=2 select=AICC(steps) smooth = 0.6 1.0
                   direct alpha=.01 all details;
run;

proc orthoreg data=indy500_winners;
   effect xMod = polynomial(year / degree=3);
*   class gender;
   model race_speed = xMod;
   effectplot fit /obs;
   store OStore;
run;

proc orthoreg data=indy500_winners;
   effect xMod = spline(year / basis=bspline degree=3);
*   class gender;
   model race_speed = xMod;
   effectplot fit /obs;
   store OStore;
run;

proc orthoreg data=indy500_winners;
   effect xMod = spline(year / basis=tpf degree=3);
*   class gender;
   model race_speed = xMod;
   effectplot fit /obs;
   store OStore;
run;

title 'Moving Average Chart for Indy Winning Times';
proc macontrol data=indy500_winners;
   machart RACE_SPEED*YEAR / span=5;
run;

proc arima data=indy500_winners;
  identify var=race_speed;
  run;
  estimate q=1 ;
  run;



/* Stream a CSV representation of new_bwgt directly to the user's browser. *

data ldata.indy500_winners; set work.import; run;
proc export data=indy500_winners
            outfile=_dataout
            dbms=csv replace;
run;

%let _DATAOUT_MIME_TYPE=text/csv;
%let _DATAOUT_NAME=indy500_winners.csv;


