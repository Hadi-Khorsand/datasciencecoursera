# 0.

library(reshape2)

# Address
data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
data_dir <- "./data"
raw_data_dir <- "./raw_data"
data_address <- paste(raw_data_dir, "/", "raw_data.zip", sep = "")

# Download or Unzip
if (!file.exists(raw_data_dir)) {
  dir.create(raw_data_dir)
  download.file(url = data_url, destfile = data_address)
  }
if (!file.exists(data_dir)) {
  dir.create(data_dir)
  unzip(zipfile = data_address, exdir = data_dir)
  }


#1.

# Load Train Data
x_train <- read.table(paste(sep = "", data_dir, "/UCI HAR Dataset/train/X_train.txt"))
y_train <- read.table(paste(sep = "", data_dir, "/UCI HAR Dataset/train/Y_train.txt"))
s_train <- read.table(paste(sep = "", data_dir, "/UCI HAR Dataset/train/subject_train.txt"))

# Load Test Data
x_test <- read.table(paste(sep = "", data_dir, "/UCI HAR Dataset/test/X_test.txt"))
y_test <- read.table(paste(sep = "", data_dir, "/UCI HAR Dataset/test/Y_test.txt"))
s_test <- read.table(paste(sep = "", data_dir, "/UCI HAR Dataset/test/subject_test.txt"))

# Merge
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
s_data <- rbind(s_train, s_test)


# Feature
features <- read.table(paste(sep = "", data_dir, "/UCI HAR Dataset/features.txt"))
features <- features$V2
colnames(x_data) <- features

# 2.

s_data <- x_data[ , grep("mean|std", colnames(x_data))]

# 3.

activity_labels <- read.table(paste(sep = "", data_dir, "/UCI HAR Dataset/activity_labels.txt"))
y_data$activity <- activity_labels[y_data$V1, 2]

# 4.

names(y_data) <- c("ActivityID", "ActivityLabel")
names(s_data) <- "Subject"

# 5.

data <- cbind(s_data, y_data, x_data)
data_label <- c("Subject", "ActivityID", "ActivityLabel")

labels = setdiff(colnames(data), data_label)
melted_data = melt(data, id = data_label, measure.vars = labels, na.rm=TRUE)
tidy_data = dcast(melted_data, Subject + ActivityLabel ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt", row.names = FALSE)

