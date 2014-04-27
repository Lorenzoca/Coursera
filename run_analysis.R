## To make it work, place this script in the same directory where
## the "UCI HAR Dataset" folder is located, and install the "reshape2" package if not present

library("reshape2")


## read the train/test files and all the info about the different
## variables, and assigns names to each one of the imported measurements


features<-read.table("UCI HAR Dataset/features.txt",header=F,stringsAsFactors=F)
features_names<-t(features[,2])
activity_names<-read.table("UCI HAR Dataset/activity_labels.txt",header=F)


test_data <- read.table("UCI HAR Dataset/test/X_test.txt",header=F,col.names=features_names)
test_activity_lab <- read.table("UCI HAR Dataset/test/y_test.txt",header=F)
test_subject_lab <- read.table("UCI HAR Dataset/test/subject_test.txt",header=F)

train_data <- read.table("UCI HAR Dataset/train/X_train.txt",header=F,col.names=features_names)
train_activity_lab <- read.table("UCI HAR Dataset/train/y_train.txt",header=F)
train_subject_lab <- read.table("UCI HAR Dataset/train/subject_train.txt",header=F)



## Merge train and test data, and select only the measurements for mean and std values


merged_data<-rbind(train_data,test_data)
merged_activity_lab<-rbind(train_activity_lab,test_activity_lab)
merged_subject_lab<-rbind(train_subject_lab,test_subject_lab)

mean_or_std<-intersect(grep(pattern="mean|std" ,x=features_names,fixed=F,),grep("meanF",x=features_names,invert=TRUE))

merged_data<-merged_data[,c(mean_or_std)]

## Change activity ids to activity names, using the "activity_names" file content

for(i in seq(1:dim(merged_activity_lab)[1])){
        merged_activity_lab[i,]=as.character(activity_names[merged_activity_lab[i,],2])
}

names(merged_activity_lab)<-"activity_name"
names(merged_subject_lab)<-"subject_id"

## Merge the subject ids, the activity names and the actual measurements in one object

merged_all<-cbind(merged_subject_lab,merged_activity_lab,merged_data)

## Now we can use melt and dcast (from "reshape2" package) to easily compute 
## the mean of all the measurement per subject*activity

mergedMelt<-melt(merged_all,id.vars=c(names(merged_all[,c(1:2)])),measure.vars<-c(names(merged_all[,3:ncol(merged_all)])))
tidy_data<-dcast(mergedMelt,activity_name + subject_id~variable,mean)


## WARNING: it was not clear from the assignment description if we had to compute average values
## for subject-only or activity-only values. This script by default calculates 
## average values for the INTERACTIONS between subjects AND activities (30*6 combinations): in case
## the user wants to calculate average values only PER SUBJECT or PER ACTIVITY, please use one these 
## 2 small modifications
## PER SUBJECT :
## tidy_data<-dcast(mergedMelt,subject_id~variable,mean)
## PER ACTIVITY:
## tidy_data<-dcast(mergedMelt,activity_name~variable,mean) 


## Writes the new formatted dataset as a space-delimited txt file

write.table(tidy_data,file="tidy_measurements.txt",row.names=F,quote=F)


