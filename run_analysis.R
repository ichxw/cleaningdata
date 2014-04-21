library(plyr)
library(data.table)

## set up directories for the datasets
dataDir <- "UCI-HAR-Dataset/"
trainDir <- paste0(dataDir, "train/")
testDir <- paste0(dataDir, "test/")

## read in labels for the activities and features
labelY <- read.table(paste0(dataDir, "activity_labels.txt"))
labelX <- read.table(paste0(dataDir, "features.txt"))

## read the training and test datasets into data frames
trainX <- fread(paste0(trainDir, "X_train.csv"), sep=",")
trainY <- read.table(paste0(trainDir, "y_train.txt"))
trainSubject <- read.table(paste0(trainDir, "subject_train.txt"))
testX <- fread(paste0(testDir, "X_test.csv"), sep=",")
testY <- read.table(paste0(testDir, "y_test.txt"))
testSubject <- read.table(paste0(testDir, "subject_test.txt"))

## combine the datasets preserving original order
allX <- rbind(trainX, testX)
allY <- rbind(trainY, testY)
allSubject <- rbind(trainSubject, testSubject)

## join (from the plyr package) is like merge but without sorting.
## this adds labels to the activities.
allY <- join(allY, labelY)

## add names to the columns for all of X, Y, Subject
setnames(allX, as.character(labelX[[2]]))
colnames(allY) <- c("ActivityCode","ActivityName") 
colnames(allSubject) <- "SubjectID"

## select only the columns relating to a mean or std
sel <- c(grep("mean()", labelX[[2]], fixed=TRUE), grep("std()",labelX[[2]], fixed=TRUE))
subX <- allX[, sel, with=FALSE]

## combine subject ID, activity, and features
subData <- cbind(allSubject, allY, subX)

##  use aggregate to group by subject and activity, and create mean values
meanData <- aggregate(subData,by=list(subData$SubjectID, subData$ActivityName),FUN=mean)
## re-attach activity names, add subject names, and trim for output
meanData[5] <- meanData[2]
addSubjectText = function(x){return(paste("Subject", as.character(x), sep="-"))}
meanData[3]<-sapply(meanData[3], FUN=addSubjectText)
write.csv(meanData[3:ncol(meanData)], file="tidyData.csv", row.names=FALSE)
