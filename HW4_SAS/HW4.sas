/*Problem 1
  Reproduce the JMP analysis using R and SAS.  The original problem was to illustrate different sampling
  strategies in terms of the frequency of inspected parts. 

I have added the following for which I will consider some simple inference procedures.
*/

DATA NEWDATA;
   INFILE '/home/u63549661/sasuser.v94/defects.csv' DLM=',' DSD;
   INPUT Day Sample Defects; /* List the variables in your CSV file */
RUN;

PROC TRANSPOSE DATA=NEWDATA OUT=transposed_data;
    VAR Defects;
    ID Sample;
    BY Day;
RUN;

/*Distribution of Defects*/
PROC UNIVARIATE DATA=NEWDATA;
    VAR Defects;
    HISTOGRAM;
    INSET MEAN STD N;
    TITLE "Histogram of Defects";
RUN;

PROC SGPLOT DATA=NEWDATA;
    VBOX Defects / CATEGORYVAR=Day GROUPDISPLAY=CLUSTER;
    TITLE "Boxplot of Defects";
RUN;


/*Summary of Defects by Day*/
PROC MEANS DATA=NEWDATA;
    VAR Defects;
    CLASS Day;
    OUTPUT OUT=summary_dat MEAN=mean_Defects;
RUN;

/*Sample Once Per Day*/
DATA sample_once;
    SET NEWDATA;
/*This side reports errors many times, so pay attention to the character of the variables. */
    WHERE put(Sample, TIME8.) = '09:30';
RUN;

PROC UNIVARIATE DATA=sample_once;
    VAR Defects;
    HISTOGRAM;
    INSET MEAN STD N;
    TITLE "Histogram of Defects at 9:30";
RUN;

PROC SGPLOT DATA=sample_once;
    VBOX Defects / CATEGORYVAR=Day GROUPDISPLAY=CLUSTER;
    TITLE "Boxplot of Defects at 9:30";
RUN;

/*Sample Twice Per Day*/
DATA sample_twice;
    SET NEWDATA;
    WHERE put(Sample, TIME8.) IN ('09:30', '14:30');
RUN;

PROC MEANS DATA=sample_twice;
    VAR Defects;
    CLASS Day;
    OUTPUT OUT=summary_twice MEAN=mean_Defects;
RUN;

PROC UNIVARIATE DATA=summary_twice;
    VAR mean_Defects;
    HISTOGRAM;
    INSET MEAN STD N;
    TITLE "Histogram of Defects at 9:30 and 14:30";
RUN;

PROC SGPLOT DATA=summary_twice;
    VBOX mean_Defects / CATEGORYVAR=Day GROUPDISPLAY=CLUSTER;
    TITLE "Boxplot of Defects at 9:30 and 14:30";
RUN;

/*Five Sampling Schemes*/
/* 9:30 */
DATA once_data;
    SET NEWDATA;
    WHERE put(Sample, TIME8.) = '09:30';
RUN;

PROC UNIVARIATE DATA=once_data;
    VAR Defects;
    HISTOGRAM/ BINWIDTH=1;
    TITLE "Histogram of Defects at 9:30";
   
RUN;

/* 9:30 and 14:30 */
DATA twice_data;
    SET NEWDATA;
    WHERE put(Sample, TIME8.) IN ('09:30', '14:30');
RUN;

PROC UNIVARIATE DATA=twice_data;
    VAR Defects;
    HISTOGRAM/ BINWIDTH=1;
    TITLE "Histogram of Defects at 9:30 and 14:30";
    
RUN;

/* Every hour starting at 8:30 */
DATA everyhour_data;
    SET NEWDATA;
    WHERE put(Sample, TIME8.) IN ('08:30', '09:30', '10:30', '11:30', '12:30', '13:30', '14:30', '15:30');
RUN;

PROC UNIVARIATE DATA=everyhour_data;
    VAR Defects;
    HISTOGRAM/ BINWIDTH=1;
    TITLE "Histogram of Defects every hour starting at 8:30";
    
RUN;

/* Every half-hour starting at 8:30 */
DATA everyhalfhour_data;
    SET NEWDATA;
    WHERE put(Sample, TIME8.) IN ('08:30', '09:30', '10:30', '11:30', '12:30', '13:30', '14:30', '15:30', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00');
RUN;

PROC UNIVARIATE DATA=everyhalfhour_data;
    VAR Defects;
    HISTOGRAM/ BINWIDTH=1;
    TITLE "Histogram of Defects every half-hour starting at 8:30";
 
RUN;

/* Every 15 minutes */
PROC UNIVARIATE DATA=NEWDATA;
    VAR Defects;
    HISTOGRAM/ BINWIDTH=1;
    TITLE "Histogram of Defects every 15 minutes";
RUN;

/*Average Defects Plotted Over Time*/
/* 9:30 */
PROC SGPLOT DATA=NEWDATA;
    SERIES X=Day Y=Defects / GROUP=Sample;
    TITLE "Average Defects Plotted Over Time - 9:30";
RUN;

/* Every hour starting at 8:30 */
DATA everyhour_data;
    SET NEWDATA;
    WHERE put(Sample, TIME8.) IN ('08:30', '09:30', '10:30', '11:30', '12:30', '13:30', '14:30', '15:30');
RUN;

PROC MEANS DATA=everyhour_data;
    VAR Defects;
    CLASS Day;
    OUTPUT OUT=avg_defects MEAN=mean_Defects;
RUN;

PROC SGPLOT DATA=avg_defects;
    SERIES X=Day Y=mean_Defects;
    TITLE "Average Defects Plotted Over Time - Every Hour Starting at 8:30";
RUN;

/* Every 15 minutes */
PROC MEANS DATA=NEWDATA;
    VAR Defects;
    CLASS Day;
    OUTPUT OUT=avg_defects MEAN=mean_Defects;
RUN;

PROC SGPLOT DATA=avg_defects;
    SERIES X=Day Y=mean_Defects;
    TITLE "Average Defects Plotted Over Time - Every 15 Minutes";
RUN;







                                                                  