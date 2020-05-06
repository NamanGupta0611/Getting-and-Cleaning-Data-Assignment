## Loading required packages
library(dplyr)

## Download the dataset
file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file_url,"AssignData.zip",method = "curl")
# Check if folder exist.
if(!file_exists("UCI HAR Data"){
  unzip("AssignData.zip")
}
   
##Assigning all the data frames
features <- read.table("UCI HAR Data/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Data/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Data/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Data/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Data/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Data/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Data/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Data/train/y_train.txt", col.names = "code")

# Merging the test and training dataset into one data frame
X <- rbind(x_train,x_test)
Y <- rbind(y_train,y_test)
Subject <- rbind(subject_train,subject_test)
Merged_data <- cbind(Subject,X,Y)

# Extracts only the measurements on the mean and standard deviation for each measurement
TidySet <- Merged_data %>% select(subject,code,contains("mean"),contains("std"))

# Uses descriptive activity names to name the activities in the data set
TidyData$code <- activities[TidyData$code,2]

# Appropriately labels the data set with descriptive variable names.
names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

# From the data set in above step, creates a second, independent tidy data set with the average of each variable 
# for each activity and each subject.
FinalData <- TidyData %>% group_by(subject, acctivity) %>% summarise_all(funs(mean))
write.table(FinalData,"FinalData.txt",row.name=FALSE)

## Final check stage
# Checking variable names
str(FinalData)

# To take a look at the Final Data
FinalData
