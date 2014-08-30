## Execute this script from the working directory where 'test' and 'train' are subdirectories of 
## the working directory and they contain 'subject_test.txt', 'X_test.txt', 'Y_test.txt', and 
## 'subject_train.txt', 'X_train.txt', 'Y_train.txt, respectively.

runAnalysis <- function () {

        #read data into R
        subTest <- read.table("test/subject_test.txt")
        testX <- read.table("test/X_test.txt")
        testY <- read.table("test/Y_test.txt")
        subTrain <- read.table("train/subject_train.txt")
        trainX <- read.table("train/X_train.txt")
        trainY <- read.table("train/Y_train.txt")
        activities <- read.table("activity_labels.txt")
        features <- read.table("features.txt")

        #change names of first column in testY, subTest, trainY, and subTrain so as not to be confused with V1 in X data
        names(testY)[1] <- "Activity"
        names(subTest)[1] <- "Subject"
        names(trainY)[1] <- "Activity"
        names(subTrain)[1] <- "Subject"
        
        
        #cbind test data and training data into two datasets
        dataTest <- cbind(subTest,testY,testX)
        dataTrain <- cbind(subTrain,trainY,trainX)
        
        #rbind the two datasets created in the last step
        data <- rbind(dataTest,dataTrain)
        
        #Replace values is Activity with descriptive name
        for (i in activities$V1) {
                data$Activity <- gsub(paste0("^", i, "$"),activities[i,2],data$Activity)
        }
        
        #Replace column names in dataset using data from features.txt
        nrows <- nrow(features)
        end <- ncol(data)
        start <- end - nrows + 1
        names(data)[start:end] <- as.character(features$V2)
        
        #subset to just std() and mean() measurements, use regex to avoid selecting freqmean()
        stdMean <- grepl("((mean\\(\\)-([xX]|[yY]|[zZ])$|mean\\(\\)$)|(std\\(\\)$|std\\(\\)-([xX]|[yY]|[zZ])$))", names(data))
        
        #assign true values to the first two values in the vector to preserve the activity and subject columns
        stdMean[1:2] <- c(TRUE,TRUE)
        
        #subset data with stdMean
        data <- data[,stdMean]
        
        #write first dataset to a file
        write.table(data, "tidy.txt")
        
        #begin work on second dataset
        #find number of subjects using factoring
        dataFac <- factor(data$Subject)
        subjects <- as.numeric(levels(dataFac))
        
        #set second dataset to null and then find the number of columns in the dataset, store
        #number of columns in a variable so you only calculate once
        dataTwo <- NULL
        numCols <- ncol(data)
        
        #start a loop of all the subjects
        for (i in subjects){
                
                #for each subject find out how many activities there are using factoring
                dataFacAct <- factor(data[data$Subject == i,2])
                activitiesSub <- levels(dataFacAct)
                
                        #create a sub loop for EACH activity performed by EACH subject
                        for (a in activitiesSub){
                          
                                #subset the data to the current subject and activity within
                                #the loop, then remove the 'Subject' and 'Activity' columns so
                                #we can use colMeans function on remaining columns
                                subset <- data[data$Subject == i & data$Activity == a,]
                                subset <- subset[,3:numCols]
                                
                                #use colMeans function to calculate means, then add back
                                #'Subject' and 'Activity' columns
                                result <- colMeans(subset)
                                result <- c(i, a, result)
                                names(result)[1] <- "Subject"
                                names(result)[2] <- "Activity"
                                
                                #if this is the first row then assign it to the null dataTwo variable,
                                #if not then bind this row to the existing dataTwo variable
                                if (length(dataTwo) == 0) dataTwo <- result
                                else if (length(dataTwo) != 0) dataTwo <- rbind(dataTwo, result)
                        }
        }
        
        #remove row names so that you can coerce to a data frame
        row.names(dataTwo) <- NULL
        dataTwo <- as.data.frame(dataTwo)
        
        #return second dataset
        dataTwo
}