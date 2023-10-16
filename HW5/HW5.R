#Problem 2 - comparing the 1986 the National League East with
#historical NL East teams using career averages for each
# Load necessary libraries
library(dplyr)
library(tidyr)
library(car)
library(ggplot2)
library(e1071)  
library(knitr)

# Load the data 
baseball <- read.csv("C:\\Users\\Chang\\Downloads\\baseball.csv",sep = ","
                     , header=TRUE)  

# Create a frequency table for league and division
freq_table <- table(baseball$League, baseball$Division)
print(freq_table)

# Create new variables in_fielder, out_fielder, catcher, and CrHits2
baseball <- baseball %>%
  mutate(
    in_fielder = Position %in% c('1B', '2B', 'SS', '3B'),
    out_fielder = Position %in% c('CF', 'RF', 'LF', 'OF'),
    catcher = Position == 'C',
    CrHits2 = CrHits * CrHits
  )


# Create a temporary dataset temp1
temp1 <- baseball %>%
  dplyr::filter(Div == 'NE') %>%
  mutate(career = 'No ') %>%
  select(CrAtBat, CrBB, CrHits, CrHits2, CrHome, CrRbi, CrRuns, Div,
         Salary, YrMajor, nBB, nHits, nHome, nRBI, nRuns, career)

# Create a temporary dataset temp2
temp2 <- temp1 %>%
  mutate(
    career = 'Yes',
    nBB = CrBB / YrMajor,
    nHits = CrHits / YrMajor,
    nHome = CrHome / YrMajor,
    nRBI = CrRbi / YrMajor,
    nRuns = CrRuns / YrMajor
  )

# Combine temp1 and temp2 into problem2

problem2 <- rbind(temp1, temp2)

career_freq <- table(problem2$career)

# Print the frequency table

print(career_freq)


# Perform a t-test assuming normal data
ttest_normal_Pooled <- t.test(problem2$nHits ~ problem2$career, var.equal = TRUE)

print(ttest_normal_Pooled)

ttest_normal_Satterthwait <- t.test(problem2$nHits ~ problem2$career, var.equal = FALSE)
print(ttest_normal_Satterthwait)



# Perform a non-parametric test assuming non-normal data (Wilcoxon rank-sum test)
wilcoxon_test <- wilcox.test(problem2$nHits ~ problem2$career)
print(wilcoxon_test)


# Store the t-test and Wilcoxon test results
ttest_normal_Pooled <- t.test(problem2$nHits ~ problem2$career, var.equal = TRUE)
ttest_normal_Satterthwait <- t.test(problem2$nHits ~ problem2$career, var.equal = FALSE)
wilcoxon_test <- wilcox.test(problem2$nHits ~ problem2$career)

# Create a data frame to store the results
summary_table <- data.frame(
  Test = c("T-Test (Pooled Variance)", "T-Test (Satterthwait)", "Wilcoxon Rank-Sum Test"),
  Mean_Group_No = c(ttest_normal_Pooled$estimate[1], ttest_normal_Satterthwait$estimate[1], NA),
  Mean_Group_Yes = c(ttest_normal_Pooled$estimate[2], ttest_normal_Satterthwait$estimate[2], NA),
  Std_Dev_Group_No = c(ttest_normal_Pooled$sd[1], ttest_normal_Satterthwait$sd[1], NA),
  Std_Dev_Group_Yes = c(ttest_normal_Pooled$sd[2], ttest_normal_Satterthwait$sd[2], NA),
  P_Value = c(ttest_normal_Pooled$p.value, ttest_normal_Satterthwait$p.value, wilcoxon_test$p.value)
)

# Print the summary table in a nicely formatted way using kable
kable(summary_table, format = "markdown")

