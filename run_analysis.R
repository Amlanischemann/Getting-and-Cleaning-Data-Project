# run_analysis.R
# This script performs the following:
# 1. Merges training and test data sets
# 2. Extracts mean and std variables
# 3. Uses descriptive activity names
# 4. Labels variables with descriptive names
# 5. Creates a tidy dataset with the average of each variable by subject and activity

library(dplyr)

# Download and unzip dataset
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "dataset.zip", method = "curl")
unzip("dataset.zip")

# Load metadata
features <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

# Load datasets
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$V2)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity")

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$V2)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity")

# Merge training and test sets
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)
merged <- cbind(subject_data, y_data, x_data)

# Extract mean and std measurements
extracted <- merged %>% select(subject, activity, contains("mean()"), contains("std()"))

# Use descriptive activity names
extracted$activity <- factor(extracted$activity, levels = activities$code, labels = activities$activity)

# Clean variable names
names(extracted) <- gsub("Acc", "Accelerometer", names(extracted))
names(extracted) <- gsub("Gyro", "Gyroscope", names(extracted))
names(extracted) <- gsub("Mag", "Magnitude", names(extracted))
names(extracted) <- gsub("^t", "Time", names(extracted))
names(extracted) <- gsub("^f", "Frequency", names(extracted))
names(extracted) <- gsub("BodyBody", "Body", names(extracted))
names(extracted) <- gsub("-mean\\(\\)", "Mean", names(extracted), ignore.case = TRUE)
names(extracted) <- gsub("-std\\(\\)", "STD", names(extracted), ignore.case = TRUE)

# Create tidy dataset with average for each subject/activity
tidy <- extracted %>%
  group_by(subject, activity) %>%
  summarise_all(list(mean = mean))

# Save output
write.table(tidy, "tidydata.txt", row.names = FALSE)

