#Getting and Cleaning Data Course Project
-----------------

##Author
-----------------
James Brink - james.p.brink@gmail.com
http://www.github.com/jamespbrink

##Project Introduction
-----------------
The purpose of this project is to demonstrate my ability to collect, work with, and clean a dataset.  The dataset used in this project can be downloaded from the link below.  The dataset contains data collected from the accelerometer in a Samsung Galaxy S smartphone.  In this project we select a specific set of measurements from the larger dataset and organize them according to different test subjects and activities.

Data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
More info: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

##Project Objectives
------------------
Create an R script that does the following:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##run_analysis.R: Step by Step
------------------
Requirements:  This script requires that the data was unzipped in the same directory as where run_analysis.R resides.  There should be two folers in the working directory, test and train, as well as the files activity_labels.txt and features.txt.

1. All of the code inside the file is within a single function, runAnalysis().  The function creates the dataset required for objective 4 and saves it to a file (tidy.txt), then the function outputs the dataset required for objective 5.
2. The function reads into R using read.table() all of the data files.
3. Rename the first column in the Subject Test, Subject Train, Y Test, and Y Train datasets.
4. Bind together (cbind()) all of the Test data and all of the Train data into two datasets.
5. Bind together (rbind()) the newly created Test and Train datasets.
6. Replace the values in the Activity column of our bound dataset with descriptive names for each value, do this using data in the activity_labels.txt file.
7. Replace the column names in our dataset with the correct features using data from features.txt.
8. Use regular expressions and grep to create a logical vector that returns TRUE only for the features that are measurements of mean and standard deviation.
9. Subset our data using the logical vector in step 8.
10. Write this dataset to a file called tidy.txt, this is the data required by objective 4.
11. Using factoring find the number of subjects in our dataset.
12. Create a loop and a sub loop.  The first loop finds out how many activities there are for each subject, the subloop then finds the means of every feature for EACH activity performed by EACH subject and adds the results to a new row in a second dataset.  This second dataset is the one we are building for objective 5.
13. The function outputs the dataset that achieves objective 5.
