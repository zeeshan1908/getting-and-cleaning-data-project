# Reading trainings tables:
x_train<-read.table("./UCI HAR Dataset/train/x_train.txt")
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")

# Reading test tables:
x_test<-read.table("./UCI HAR Dataset/test/x_test.txt")
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features<-read.table("./UCI HAR Dataset/features.txt")

# Reading activity labels:
activityLabels<-read.table("./UCI HAR Dataset/activity_labels.txt")

#Assigning column names
colnames(x_train)<-features[,2]
colnames(y_train)<-"activityID"
colnames(subject_train)<-"subjectID"

colnames(x_test)<-features[,2]
colnames(y_test)<-"activityID"
colnames(subject_test)<-"subjectID"

colnames(activityLabels) <- c("activityID","activityType")

#Merging all data in one set
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

#Extracting only the measurements on the mean and standard deviation for each measurement

#Reading column names
colNames <- colnames(setAllInOne)

#Create vector for defining ID, mean and standard deviation
mean_and_std <- (grepl("activityID" , colNames) | grepl("subjectID" , colNames) | 
grepl("mean.." , colNames) | grepl("std.." , colNames) )

#Making nessesary subset from setAllInOne
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

#Using descriptive activity names to name the activities in the data set
setWithActivityNames <- merge(setForMeanAndStd, activityLabels, by='activityID', all.x=TRUE)

#Creating a second, independent tidy data set with the average of each variable for each activity and each subject

#Making second tidy data set
secTidySet <- aggregate(. ~subjectID + activityID, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectID, secTidySet$activityID),]

#Writing second tidy data set in txt file
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)