setwd("./")

# Load all needed data files for test and training sets
testSetData <- read.table("UCI HAR Dataset/test/X_test.txt")
testSetSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
testSetActivities <- read.table("UCI HAR Dataset/test/y_test.txt")
trainingSetData <- read.table("UCI HAR Dataset/train/X_train.txt")
trainingSetSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainingSetActivities <- read.table("UCI HAR Dataset/train/y_train.txt")

# Append colums for subject and activity to test and training sets
names(testSetSubjects)[1]<-"Subject_ID"
names(testSetActivities)[1] <- "Activity_ID"
testSetAnnotated <- cbind(testSetData, testSetSubjects, testSetActivities)
names(trainingSetSubjects)[1]<-"Subject_ID"
names(trainingSetActivities)[1] <- "Activity_ID"
trainingSetAnnotated <- cbind(trainingSetData, trainingSetSubjects, 
                              trainingSetActivities)

remove(testSetData, testSetSubjects, testSetActivities, trainingSetData,
       trainingSetSubjects, trainingSetActivities)

# Merge annotated test and training sets
mergedSet <- rbind(testSetAnnotated, trainingSetAnnotated)
remove(testSetAnnotated, trainingSetAnnotated)

# The documentation in "features_info.txt" clearly describes the mean of each feature as
# being appended with "mean()" and the standard deviation of each feature being
# appended as "std()".  Parsing the "features.txt" file with these rules results in 33
# data points of each type, which is expected as a mean and std are typically computed
# and reported together.
extractCols <- c(1, 2, 3, 41, 42, 43, 81, 82, 83, 121, 122, 123, 161, 162, 163,
                 201, 214, 227, 240, 253, 266, 267, 268, 345, 346, 347, 424, 425,
                 426, 503, 516, 529, 542, 4, 5, 6, 44, 45, 46, 84, 85, 86, 124,
                 125, 126, 164, 165, 166, 202, 215, 228, 241, 254, 269, 270, 271,
                 348, 349, 350, 427, 428, 429, 504, 517, 530, 543)

descriptions <- c("tBodyAcc-mean()-X", "tBodyAcc-mean()-Y", "tBodyAcc-mean()-Z",
                  "tGravityAcc-mean()-X", "tGravityAcc-mean()-Y", "tGravityAcc-mean()-Z",
                  "tBodyAccJerk-mean()-X", "tBodyAccJerk-mean()-Y", "tBodyAccJerk-mean()-Z",
                  "tBodyGyro-mean()-X", "tBodyGyro-mean()-Y", "tBodyGyro-mean()-Z",
                  "tBodyGyroJerk-mean()-X", "tBodyGyroJerk-mean()-Y", "tBodyGyroJerk-mean()-Z",
                  "tBodyAccMag-mean()", "tGravityAccMag-mean()", "tBodyAccJerkMag-mean()", 
                  "tBodyGyroMag-mean()", "tBodyGyroJerkMag-mean()", "fBodyAcc-mean()-X",
                  "fBodyAcc-mean()-Y", "fBodyAcc-mean()-Z", "fBodyAccJerk-mean()-X",
                  "fBodyAccJerk-mean()-Y", "fBodyAccJerk-mean()-Z", "fBodyGyro-mean()-X",
                  "fBodyGyro-mean()-Y", "fBodyGyro-mean()-Z", "fBodyAccMag-mean()", 
                  "fBodyBodyAccJerkMag-mean()", "fBodyBodyGyroMag-mean()", 
                  "fBodyBodyGyroJerkMag-mean()", "tBodyAcc-std()-X", "tBodyAcc-std()-Y",
                  "tBodyAcc-std()-Z", "tGravityAcc-std()-X", "tGravityAcc-std()-Y",
                  "tGravityAcc-std()-Z", "tBodyAccJerk-std()-X", "tBodyAccJerk-std()-Y",
                  "tBodyAccJerk-std()-Z", "tBodyGyro-std()-X", "tBodyGyro-std()-Y",
                  "tBodyGyro-std()-Z", "tBodyGyroJerk-std()-X", "tBodyGyroJerk-std()-Y",
                  "tBodyGyroJerk-std()-Z", "tBodyAccMag-std()", "tGravityAccMag-std()",
                  "tBodyAccJerkMag-std()", "tBodyGyroMag-std()", "tBodyGyroJerkMag-std()",
                  "fBodyAcc-std()-X", "fBodyAcc-std()-Y", "fBodyAcc-std()-Z",
                  "fBodyAccJerk-std()-X", "fBodyAccJerk-std()-Y", "fBodyAccJerk-std()-Z",
                  "fBodyGyro-std()-X", "fBodyGyro-std()-Y", "fBodyGyro-std()-Z", 
                  "fBodyAccMag-std()", "fBodyBodyAccJerkMag-std()", "fBodyBodyGyroMag-std()",
                  "fBodyBodyGyroJerkMag-std()")

# From merged set, extract columns for mean(), std(), subject_id, and activity_id
mergedSet <- mergedSet[, c(extractCols, 562, 563)]
names(mergedSet)[1:66]<- descriptions
remove(descriptions, extractCols)

# Add activity labels
labels <- read.table("UCI HAR Dataset/activity_labels.txt")
names(labels)[1:2] <- c("Activity_ID", "Activity_Label")
mergedSet <- merge(mergedSet, labels, by = "Activity_ID")
remove(labels)

# Remove un-need Activity_ID column and rearrange columns to create the final datset
# which is the solution to project question #4
mergedSet <- mergedSet[, 2:69]
mergedSet <- subset(mergedSet, select = c(67, 68, 1:66))
