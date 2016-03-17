library(tidyr)
library(dplyr)

titanic <- tbl_df(read.csv("titanic_original.csv"))

# 1: Port of embarkation
# Instructions say that there is one blank value, but there are actually 2
# I am replacing both

titanic <- titanic %>% 
  mutate(embarked = replace(embarked, embarked == '' & name != '', "S"))

# 2: Age
titanic <- titanic %>% 
  mutate(age = replace(age, is.na(age), mean(age[!is.na(age)])))
# Alternate ways to populate empty values: median? 
# If you have knowledge that the group with missing values is skewed
# older than the mean (for example if birth records only started being kept
# after a certain year), than you would not want to use the mean or median.

# 3: Lifeboat
titanic <- titanic %>% 
  mutate(boat = replace(boat, boat == "", NA))

# 4: Cabin
# Q: Does it make sense to fill missing cabin numbers with a value? What
#    does a missing value here mean?
# A: They were probably the ship's crew.
titanic <- titanic %>% 
  mutate(has_cabin_number = as.numeric(cabin != ""))

write.csv(titanic,"titanic_clean.csv")
