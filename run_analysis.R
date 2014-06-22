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

# Create second tidy dataset
mergedSetMeans <- ddply(mergedSet, c("Subject_ID", "Activity_Label"), 
                        function(x) c('mean-tBodyAcc-mean()-X'=mean(x$'tBodyAcc-mean()-X'),
                                      'mean-tBodyAcc-mean()-Y'=mean(x$'tBodyAcc-mean()-Y'),
                                      'mean-tBodyAcc-mean()-Z'=mean(x$'tBodyAcc-mean()-Z'),
                                      'mean-tGravityAcc-mean()-X'=mean(x$'tGravityAcc-mean()-X'),
                                      'mean-tGravityAcc-mean()-Y'=mean(x$'tGravityAcc-mean()-Y'),
                                      'mean-tGravityAcc-mean()-Z'=mean(x$'tGravityAcc-mean()-Z'),
                                      'mean-tBodyAccJerk-mean()-X'=mean(x$'tBodyAccJerk-mean()-X'),
                                      'mean-tBodyAccJerk-mean()-Y'=mean(x$'tBodyAccJerk-mean()-Y'),
                                      'mean-tBodyAccJerk-mean()-Z'=mean(x$'tBodyAccJerk-mean()-Z'),
                                      'mean-tBodyGyro-mean()-X'=mean(x$'tBodyGyro-mean()-X'),
                                      'mean-tBodyGyro-mean()-Y'=mean(x$'tBodyGyro-mean()-Y'),
                                      'mean-tBodyGyro-mean()-Z'=mean(x$'tBodyGyro-mean()-Z'),
                                      'mean-tBodyGyroJerk-mean()-X'=mean(x$'tBodyGyroJerk-mean()-X'),
                                      'mean-tBodyGyroJerk-mean()-Y'=mean(x$'tBodyGyroJerk-mean()-Y'),
                                      'mean-tBodyGyroJerk-mean()-Z'=mean(x$'tBodyGyroJerk-mean()-Z'),
                                      'mean-tBodyAccMag-mean()'=mean(x$'tBodyAccMag-mean()'),
                                      'mean-tGravityAccMag-mean()'=mean(x$'tGravityAccMag-mean()'),
                                      'mean-tBodyAccJerkMag-mean()'=mean(x$'tBodyAccJerkMag-mean()'),
                                      'mean-tBodyGyroMag-mean()'=mean(x$'tBodyGyroMag-mean()'),
                                      'mean-tBodyGyroJerkMag-mean()'=mean(x$'tBodyGyroJerkMag-mean()'),
                                      'mean-fBodyAcc-mean()-X'=mean(x$'fBodyAcc-mean()-X'),
                                      'mean-fBodyAcc-mean()-Y'=mean(x$'fBodyAcc-mean()-Y'),
                                      'mean-fBodyAcc-mean()-Z'=mean(x$'fBodyAcc-mean()-Z'),
                                      'mean-fBodyAccJerk-mean()-X'=mean(x$'fBodyAccJerk-mean()-X'),
                                      'mean-fBodyAccJerk-mean()-Y'=mean(x$'fBodyAccJerk-mean()-Y'),
                                      'mean-fBodyAccJerk-mean()-Z'=mean(x$'fBodyAccJerk-mean()-Z'),
                                      'mean-fBodyGyro-mean()-X'=mean(x$'fBodyGyro-mean()-X'),
                                      'mean-fBodyGyro-mean()-Y'=mean(x$'fBodyGyro-mean()-Y'),
                                      'mean-fBodyGyro-mean()-Z'=mean(x$'fBodyGyro-mean()-Z'),
                                      'mean-fBodyAccMag-mean()'=mean(x$'fBodyAccMag-mean()'),
                                      'mean-fBodyBodyAccJerkMag-mean()'=mean(x$'fBodyBodyAccJerkMag-mean()'),
                                      'mean-fBodyBodyGyroMag-mean()'=mean(x$'fBodyBodyGyroMag-mean()'),
                                      'mean-fBodyBodyGyroJerkMag-mean()'=mean(x$'fBodyBodyGyroJerkMag-mean()'),
                                      'mean-tBodyAcc-std()-X'=mean(x$'tBodyAcc-std()-X'),
                                      'mean-tBodyAcc-std()-Y'=mean(x$'tBodyAcc-std()-Y'),
                                      'mean-tBodyAcc-std()-Z'=mean(x$'tBodyAcc-std()-Z'),
                                      'mean-tGravityAcc-std()-X'=mean(x$'tGravityAcc-std()-X'),
                                      'mean-tGravityAcc-std()-Y'=mean(x$'tGravityAcc-std()-Y'),
                                      'mean-tGravityAcc-std()-Z'=mean(x$'tGravityAcc-std()-Z'),
                                      'mean-tBodyAccJerk-std()-X'=mean(x$'tBodyAccJerk-std()-X'),
                                      'mean-tBodyAccJerk-std()-Y'=mean(x$'tBodyAccJerk-std()-Y'),
                                      'mean-tBodyAccJerk-std()-Z'=mean(x$'tBodyAccJerk-std()-Z'),
                                      'mean-tBodyGyro-std()-X'=mean(x$'tBodyGyro-std()-X'),
                                      'mean-tBodyGyro-std()-Y'=mean(x$'tBodyGyro-std()-Y'),
                                      'mean-tBodyGyro-std()-Z'=mean(x$'tBodyGyro-std()-Z'),
                                      'mean-tBodyGyroJerk-std()-X'=mean(x$'tBodyGyroJerk-std()-X'),
                                      'mean-tBodyGyroJerk-std()-Y'=mean(x$'tBodyGyroJerk-std()-Y'),
                                      'mean-tBodyGyroJerk-std()-Z'=mean(x$'tBodyGyroJerk-std()-Z'),
                                      'mean-tBodyAccMag-std()'=mean(x$'tBodyAccMag-std()'),
                                      'mean-tGravityAccMag-std()'=mean(x$'tGravityAccMag-std()'),
                                      'mean-tBodyAccJerkMag-std()'=mean(x$'tBodyAccJerkMag-std()'),
                                      'mean-tBodyGyroMag-std()'=mean(x$'tBodyGyroMag-std()'),
                                      'mean-tBodyGyroJerkMag-std()'=mean(x$'tBodyGyroJerkMag-std()'),
                                      'mean-fBodyAcc-std()-X'=mean(x$'fBodyAcc-std()-X'),
                                      'mean-fBodyAcc-std()-Y'=mean(x$'fBodyAcc-std()-Y'),
                                      'mean-fBodyAcc-std()-Z'=mean(x$'fBodyAcc-std()-Z'),
                                      'mean-fBodyAccJerk-std()-X'=mean(x$'fBodyAccJerk-std()-X'),
                                      'mean-fBodyAccJerk-std()-Y'=mean(x$'fBodyAccJerk-std()-Y'),
                                      'mean-fBodyAccJerk-std()-Z'=mean(x$'fBodyAccJerk-std()-Z'),
                                      'mean-fBodyGyro-std()-X'=mean(x$'fBodyGyro-std()-X'),
                                      'mean-fBodyGyro-std()-Y'=mean(x$'fBodyGyro-std()-Y'),
                                      'mean-fBodyGyro-std()-Z'=mean(x$'fBodyGyro-std()-Z'),
                                      'mean-fBodyAccMag-std()'=mean(x$'fBodyAccMag-std()'),
                                      'mean-fBodyBodyAccJerkMag-std()'=mean(x$'fBodyBodyAccJerkMag-std()'),
                                      'mean-fBodyBodyGyroMag-std()'=mean(x$'fBodyBodyGyroMag-std()'),
                                      'mean-fBodyBodyGyroJerkMag-std()'=mean(x$'fBodyBodyGyroJerkMag-std()')
                                      ))
                        
tidyDataSet <- write.csv(mergedSetMeans, file = "tidyDataSet.csv")
