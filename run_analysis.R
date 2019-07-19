## Get dplyr package
install.packages("dplyr")
library(plyr)

## Get the raw data
if (!file.exists("data")) {
        dir.create("data")
}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destination_file_url <- "./data/Dataset.zip"
if (!file.exists(destination_file_url)) {
        download.file(fileurl, destfile = destination_file_url ,method ="curl")
        unzip(destination_file_url)
}



## Train data
training_subjects <- read.table(file.path("UCI HAR Dataset", "train", "subject_train.txt"),header = FALSE)
training_normalized_observations <-read.table(file.path("UCI HAR Dataset", "train", "X_train.txt"),header = FALSE)
training_labels <-read.table(file.path("UCI HAR Dataset", "train", "Y_train.txt"),header = FALSE)

## Test data
test_subjects <- read.table(file.path("UCI HAR Dataset", "test", "subject_test.txt"),header = FALSE)
test_normalized_observations <-read.table(file.path("UCI HAR Dataset", "test", "X_test.txt"),header = FALSE)
test_labels <-read.table(file.path("UCI HAR Dataset", "test", "Y_test.txt"),header = FALSE)

## Metadata
feature_names <- read.table("UCI HAR Dataset/features.txt",header = FALSE)
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",header = FALSE)

## Merge rows of these 2 datasets
total_subjects <- rbind(training_subjects, test_subjects)
total_labels <- rbind(training_labels, test_labels)
total_normalized_observations <- rbind(training_normalized_observations,test_normalized_observations)

## Change column names
colnames(total_subjects) <- c('subject_id')
colnames(total_labels) <- c('activity')
colnames(total_normalized_observations) <- feature_names$V2

total_data <- cbind(total_subjects,total_labels,total_normalized_observations)

## Get rid of data which we don't use
columns_logical_vector <- grepl("subject_id|activity|mean|std", names(total_data))

## Filter on remaining columns
total_data <- total_data[, columns_logical_vector]

## Change id to descriptive activity name
total_data$activity <- factor(total_data$activity, labels=activity_labels$V2)
total_data_col_names <- colnames(total_data)
total_data_col_names <-gsub("-"," ",total_data_col_names)
total_data_col_names <-gsub("fBody"," ",total_data_col_names)
total_data_col_names <-gsub("mean()",'Mean',total_data_col_names)
total_data_col_names <-gsub("std()",'Standard Deviation',total_data_col_names)
total_data_col_names <-gsub("^t",'Time ',total_data_col_names)
total_data_col_names <-gsub("^f","Frequency domain signals",total_data_col_names)
total_data_col_names <-gsub("Acc",' Acceleration',total_data_col_names)
total_data_col_names <-gsub("Jerk",' Jerk Signals ',total_data_col_names)
total_data_col_names <-gsub("Mag",' Magnitude ',total_data_col_names)
total_data_col_names <-gsub("Gyro",' Gyroscope ',total_data_col_names)
total_data_col_names <-gsub("Freq",' Frequency ',total_data_col_names)
total_data_col_names <-gsub("()",'',total_data_col_names)
total_data_col_names <-gsub("^[ \t]+",'',total_data_col_names)

colnames(total_data) <- total_data_col_names
head(total_data)

## Create a new dataset by getting the mean of the variable for each subject and activity
data_set_2 <-aggregate(. ~subject_id + activity, total_data, mean)
data_set_2<-data_set_2[order(data_set_2$subject_id,data_set_2$activity),]
write.table(data_set_2, file = "tidydata.txt",row.name=FALSE)