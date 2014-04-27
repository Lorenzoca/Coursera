This file explains how to use the provided R script for the analysis.

Download the data from here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

extract the zip file in the same folder where the run_analysis.R script is located and everything should work.

In R set your working directoy where the run_analysis.R and the "UCI HAR Dataset" are located and type:

source("run_analysis.R")

This will create a space-delimited file called "tidy_measurements.txt".


Explanation of run_analysis.R script:

This scripts reads different files in the "UCI HAR Dataset" folder.
First it gets the names of the measurements in the "features" file to assign a 
name to the data columns when importing them.

After merging the train and test data, only the measurements including "mean" or "std" but not "meanF" 
in their name are kept, since we are interested only in mean and standard deviation values (not meanFreq for instance...)

The "activity_labels" file is used to change the "y_train" and "y_test" activity values from simple numeric ids
to  more meaningful string values (SITTING, LAYING etc..)

A data.frame is created including subject_ids, activity_values and the actual measurements; 
subsequently, a "melted" data.frame (using the "reshape2"package) is created 
after specifying the measurement values and the "categorical" values.

This way we can easily calculate the average values for each measurements per category.
In our case we are interested in average values for each activity and each subject, so we will 
consider the interaction between these 2 factors (activity AND subject).
In case the user is interested in averaging the values ONLY per activity or ONLY per subject a short description on
how to do it is present inside the R script.



