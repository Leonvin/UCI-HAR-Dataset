## Step 1 - reading data from the UCI HAR Dataset
setwd("C:/Users/Vin/Desktop/Edu/Coursera/Specialization - Data Science/03. Getting and Cleaning Data/Assignments")
test.labels <- read.table("UCI HAR Dataset/test/y_test.txt", col.names="label")
test.subjects <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names="subject")
test.data <- read.table("UCI HAR Dataset/test/X_test.txt")
train.labels <- read.table("UCI HAR Dataset/train/y_train.txt", col.names="label")
train.subjects <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names="subject")
train.data <- read.table("UCI HAR Dataset/train/X_train.txt")

## Step 2 - Combining the above into a dataframe having labels, subjects, and data
data <- rbind(cbind(test.subjects, test.labels, test.data),
              cbind(train.subjects, train.labels, train.data))
head(data) # checking to see if the data has been loaded successfully into a table

## Step 3 - read the features.txt file and retain only the mean and standard deviation elements
# a new data frame having the subjects, labels, and the features (mean and std) are created

features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors=FALSE, strip.white=TRUE)
features.mean.std <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]
data.mean.std <- data[, c(1, 2, features.mean.std$V1+2)] # increment by 2 because data has subjects and labels in the beginning

## Step 4 - read the activity labels text file and replace labels in data with label names
labels <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors=FALSE)
data.mean.std$label <- labels[data.mean.std$label, 2]

## Step 5 - tidy the column names by removing non-alphabetic character and converting to lowercase
good.colnames <- c("subject", "label", features.mean.std$V2)
good.colnames <- tolower(gsub("[^[:alpha:]]", "", good.colnames))
colnames(data.mean.std) <- good.colnames

## Step 6 - compute the mean for each combination of subject and label
aggr.data <- aggregate(data.mean.std[, 3:ncol(data.mean.std)],
                       by=list(subject = data.mean.std$subject, 
                               label = data.mean.std$label),
                       mean)

## Step 7 - writing the output to a text file
write.table(format(aggr.data, scientific=T), "tidy.txt",
            row.names=F, col.names=F, quote=2)
