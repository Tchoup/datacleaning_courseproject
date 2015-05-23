library(plyr)


# Merge the training and test sets to create one data set

x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")

x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# Extract only the measurements on the mean and standard deviation for each measurement

features <- read.table("features.txt")
mean_std <- grep("-(mean|std)\\(\\)", features[, 2])
x_data <- x_data[, mean_std]
names(x_data) <- features[mean_std, 2]

# Use descriptive activity names to name the activities in the data set

actLabels <- read.table("activity_labels.txt")
y_data[, 1] <- actLabels[y_data[, 1], 2]
names(y_data) <- "activity"

# Appropriately label the data set with descriptive variable names

names(subject_data) <- "subject"
all_data <- cbind(x_data, y_data, subject_data)

# Create a second, independent tidy data set with the average of each 
# variable for each activity and each subject

avgData<- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(avgData, "avgData.txt", row.name=FALSE)