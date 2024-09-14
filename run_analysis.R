# Filename: run_analysis.R
# Author: syeboah1
# Date Created: 2024-08-30
# Description: File to tidy up movement dataset


library(dplyr)
library(stringr)
library(tidyr)
library(tidyverse)
library(reshape2)

# Read in the training data 


training_set_measurement <- read.table("./UCI HAR Dataset/train/X_train.txt", header=F, sep="\t",
                           col.names = "Measurement")
training_set_labels <- read.table("./UCI HAR Dataset/train/y_train.txt",
                                  header=F, sep="\t", col.names = "Activity")
training_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt",
                                sep = "\t", col.names= "Subject")
training_set <- cbind(training_subjects, training_set_labels, training_set_measurement)
  

# Read in the test data
  
test_set_measurement <- read.table("./UCI HAR Dataset/test/X_test.txt", header=F, sep="\t",
                       col.names = "Measurement")
test_set_labels <- read.table("./UCI HAR Dataset/test/y_test.txt",
                              header=F, sep="\t", col.names = "Activity")
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt",
                            sep = "\t", col.names= "Subject")
test_set <- cbind(test_subjects, test_set_measurement, test_set_labels)


### Merge the training set and test set data into one data frame.

complete_data <- rbind(training_set, test_set)

# clean up measurement vectors by removing excess white space 
# also split single string into multiple 
complete_data$Measurement <- lapply(complete_data$Measurement,
  function(string) str_squish(string) %>% str_split_1(" "))

# make the measurement vectors numeric instead of character
complete_data$Measurement <- lapply(complete_data$Measurement, as.numeric)



### Extract the measurements on mean and standard deviation for each measurement

# read in features list 
features <- read.table("./UCI HAR Dataset/features.txt", header=F, sep="\t")[[1]]

# clean up by removing numbers in the beginning
features <- gsub("^[0-9]+ ", "", features)

# get logical vector for the features for mean and std deviation
mean_features <- grepl("mean()", features, fixed = T) 

std_features <- grepl("std()", features, fixed = T) 

# get the names of the features
mean_feature_names <-  grep("mean()", features, value = T, fixed = T) 

std_feature_names <- grep("std()", features, value = T, fixed = T)

# remove mean() and std() identifier so they are general variable names
mean_feature_names <- gsub("-mean()", "", fixed = T, mean_feature_names)
std_feature_names <- gsub("-std()", "", fixed = T, std_feature_names)

# extract the mean values for each feature by subsetting with logical vector
subset_mean_data <- lapply(complete_data$Measurement, function(vector) vector[mean_features])

# unlist the measurements and apply cbind with feature names
mean_data <- data.frame("Mean" = unlist(subset_mean_data, recursive = F))



# extract the standard dev values for each feature by subsetting with logical vector 
subset_std_data <- lapply(complete_data$Measurement, function(vector) vector[std_features])

# unlist the measurements and apply cbind with feature names
std_data <- data.frame("Standard_Deviation" = unlist(subset_std_data, recursive = F))


# Take subject and activity from full dataset, expand to long form
subset_complete_data <- select(complete_data, Subject, Activity) 

tidy_subject <- rep(subset_complete_data$Subject, each = 33)
tidy_activity <- rep(subset_complete_data$Activity, each = 33)

# join the mean and standard deviation to the ids from the full dataset

almost_tidy <- cbind("Subject" = tidy_subject, "Activity" = tidy_activity,
                     "Feature" = mean_feature_names, mean_data, std_data)



### Uses descriptive activity names to name the activities in the data set

# read in the activity names file
activity_names <- read.table("./UCI HAR Dataset/activity_labels.txt", header=F, 
                             sep=" ", row.names = 1)[[1]]
# change the values to the activity descriptions
almost_tidy$Activity <- sapply(almost_tidy$Activity, function(x) x <- activity_names[x])

avg_mean <- sapply(almost_tidy$Mean_Measurements, mean)
avg_std <- sapply(almost_tidy$Standard_Deviation_Measurements, mean)



### Finally create tidy dataset where we have the mean for each subject and each activity


melt_almost_tidy <- melt(almost_tidy, id=c("Subject", "Activity", "Feature"),
                  measure.vars = c("Mean", "Standard_Deviation"))


tidy <- dcast(melt_almost_tidy, Subject + Activity + Feature ~ variable, mean) 

write.csv(tidy, "tidy_data.csv")
