library(dplyr)

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("no","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
test_x <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
test_y <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
train_x <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
train_y <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

data_x <- rbind(test_x, train_x)
data_y <- rbind(test_y, train_y)
subject_bind <- rbind(subject_test, subject_train)
data_merged <- cbind(data_x, data_y, subject_bind)
extract <- select(data_merged, subject, code, contains("mean"), contains("std"))
extract_activities <- activities[extract$code, 2]

names(extract)[2] = "activity"
names(extract)<-gsub("Acc", "Accelerometer", names(extract))
names(extract)<-gsub("Gyro", "Gyroscope", names(extract))
names(extract)<-gsub("BodyBody", "Body", names(extract))
names(extract)<-gsub("Mag", "Magnitude", names(extract))
names(extract)<-gsub("^t", "Time", names(extract))
names(extract)<-gsub("^f", "Freq", names(extract))
names(extract)<-gsub("tBody", "Time", names(extract))
names(extract)<-gsub("-mean()", "Mean", names(extract))
names(extract)<-gsub("-std()", "STD", names(extract))
names(extract)<-gsub("-freq()", "Frequency", names(extract))

final_average <- extract %>% 
  group_by(subject, activity) %>% 
  summarise_all(list(mean))
write.table(final_average, "FinalAverage.txt", row.names = FALSE)
