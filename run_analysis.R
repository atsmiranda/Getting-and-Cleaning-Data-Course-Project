library(plyr)
############################################################################### 
# Combine the training and test sets to create one data set
###############################################################################

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# create 'xtt' data set using rbind
xtt_data <- rbind(x_train, x_test)

# create 'ytt' data set
ytt_data <- rbind(y_train, y_test)

# create 'subject' data set
subject_datatt <- rbind(subject_train, subject_test)

######################################################################################
# Extract only the measurements on the mean and standard deviation for each measurement
######################################################################################

features <- read.table("features.txt")

# get columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the mean and std columns
xtt_data <- xtt_data[, mean_and_std_features]

# review the column names
names(xtt_data) <- features[mean_and_std_features, 2]

###############################################################################
# take descriptive activity names to name the activities in the data set
###############################################################################

activities <- read.table("activity_labels.txt")

# select values with correct activity names
ytt_data[, 1] <- activities[ytt_data[, 1], 2]

# review column name
names(ytt_data) <- "activity"

###############################################################################
# Appropriately label the data set with descriptive variable names
###############################################################################

# review column name
names(subject_datatt) <- "subject"

# link all the data in a single data set
all_datatt <- cbind(xtt_data, ytt_data, subject_datatt)

###############################################################################
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################

# 66 <- 68 columns but last two (activity & subject)
averages_datatt <- ddply(all_datatt, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_datatt, "averages.txt", row.name=FALSE)
