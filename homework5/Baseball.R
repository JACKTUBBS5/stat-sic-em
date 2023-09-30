dat = read.csv("/Users/ritadicarlo/Downloads/baseball.csv"); 

in_fielder <- c('1B', '2B', 'SS', '3B'); 
out_fielder <- c('CF', 'RF', 'LF', 'OF')
catcher <- 'C'; 
CrHits <- dat$CrHits * dat$CrHits; 

df <- data.frame(dat)
print(dat[order(dat$Division),])



t.test(dat$nHits ~ dat$Division, var.equal = TRUE )





#Problem 2
library(dplyr)
library(tidyr)
library(stats)

dat2 = read.csv("/Users/ritadicarlo/Downloads/baseball.csv"); 
career = ifelse(dat2$Div == "NE", "No", "Yes");
new_df = subset(dat2, select = c(CrAtBat, CrBB, CrHits, CrHits2,CrRbi, CrRuns, Div, Salary, YrMajor, nBB, nHits, nHome)); 

                 
dat3 = new_df; 
nbb= dat2$CrBB/dat2$YrMajor;
nhits = dat2$CrHits/dat2$YrMajor;
nhome = dat2$CrHome/dat2$YrMajor;
nrbi = dat2$CrRbi/dat2$YrMajor;
nruns = dat2$CrRuns/dat2$YrMajor;
dat3 = subset(new_df, select = c(CrAtBat, CrBB, CrHits, CrHits2,CrRbi, CrRuns, Div, Salary, YrMajor, nBB, nHits, nHome)); 

problem2 = bind_rows(dat2, dat3)
print(problem2[order(career),])

career_freq <- table(problem2$career)
nhitsdataframe = data_frame(nhits, career)
t_test_normal = t.test(nhits~career, data = nhitsdataframe)

wilcoxon_test = wilcox.test(nhits~career, data = nhitsdataframe)
cat("Frequency table for 'career' variable:\n")
print(career_freq)

cat("\nTest for means assuming normal data:\n")
print(t_test_normal)

cat("\nTest for means assuming non-normal data (Wilcoxon):\n")
print(wilcoxon_test)


