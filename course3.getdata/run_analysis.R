# download and unzip the data
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile <- "getdata.zip"
download.file(fileurl, destfile)
unzip(destfile)
rm(fileurl, destfile)
# read the data
train.set <- read.table("UCI HAR Dataset/train/X_train.txt", 
    colClasses = "numeric")
test.set <- read.table("UCI HAR Dataset/test/X_test.txt", 
    colClasses = "numeric")
# read sujects               
train.subject <- scan("UCI HAR Dataset/train/subject_train.txt", what = 0)
test.subject <- scan("UCI HAR Dataset/test/subject_test.txt", what = 0)
# read activity types
train.label <- scan("UCI HAR Dataset/train/y_train.txt", what = 0)  
test.label <- scan("UCI HAR Dataset/test/y_test.txt", what = 0)
activity.label <- read.table("UCI HAR Dataset/activity_labels.txt", 
	stringsAsFactor = F)
activity.label$V2 <- tolower(activity.label$V2)
# read feature names for both datasets
col.names <- scan("UCI HAR Dataset/features.txt", what = list(NULL, ""))
col.names <- unlist(col.names)

# merge the training and the test sets to create one data set.
dat <- rbind(train.set, test.set)
colnames(dat) <- col.names

# extract only the measurements on the mean and standard deviation. 
mt <- grepl("mean\\(|std\\(", col.names)  # grep("mean") would include meanFreq
dat.meanstd <- dat[, mt]

# use descriptive activity names to name the activities in the data set.
mt <- match(c(train.label, test.label), activity.label$V1)
dat.meanstd$activity <- activity.label[mt, 2]
dat.meanstd$subject <- c(train.subject, test.subject)

# creates a second, independent tidy data set with the average of each
# variable for each activity and each subject.
library(dplyr)
dat.tidy <- dat.meanstd %>% group_by(activity, subject) %>%
	summarize_all(.funs = mean)

# appropriately label the data set with descriptive variable names.
col.tidy <- colnames(dat.tidy)
col.tidy <- gsub("\\(\\)", "", col.tidy)
col.tidy <- gsub("-", ".", col.tidy)
col.tidy <- gsub("(X|Y|Z)$", "\\L\\1axis", col.tidy, perl = T)
col.tidy <- gsub("^t", "time.", col.tidy)
col.tidy <- gsub("^f", "frequency.", col.tidy)
col.tidy <- gsub("(Body|Gravity)\\.?", "\\L\\1.", col.tidy, perl = T)
col.tidy <- gsub("Acc\\.?", "acceleration.", col.tidy)
col.tidy <- gsub("Gyro\\.?", "gyroscope.", col.tidy)
col.tidy <- gsub("Mag\\.?", "magnitude.", col.tidy)
col.tidy <- gsub("Jerk\\.?", "jerk.", col.tidy)
colnames(dat.tidy) <- col.tidy

# export the tidy data to a tab-delimited file
write.table(dat.tidy, "dat.tidy.txt", sep = "\t", row.names = F)
