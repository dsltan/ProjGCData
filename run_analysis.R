###COURSERA 3: PROJECT
# Final: 2015.09.24

##Project output requirements and posting:
#goes on github: a run_analysis R script, a ReadMe markdown document, a Codebook markdown document, and
#a tidy data text file (this last goes on Coursera).


rm(list=ls())
setwd("D:/Coursera/20153GetCleanData")

install.packages("sqldf")
install.packages("data.table")
install.packages("gdata")
install.packages("tidyr")
library(RCurl)
library(dplyr)
library(sqldf)
library(data.table)
library(tidyr)
library(gdata)


##Verify project data directory created, else create it for data download
# Location of working directory
workdir <- getwd()
# Location of source data directory
destdir <-file.path(workdir,"UCI HAR Dataset")
if (!file.exists(destdir)) {
    dir.create(destdir)
}

### Name of source zip file 
#from http://archive.ics.uci.edu/ml/machine-learning-databases/00240/
#   that was referenced in the description of the source data at this link- 
#   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

#  Assign source zip file name with destination directory path to zipfn
sourceURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfn <- file.path(destdir,"UCI HAR Dataset.zip")

#######################################
###1. DOWNLOAD AND READ SOURCE DATA 
#######################################

### Download the zip file and unzip the files
download.file(sourceURL, destfile=zipfn)
#Unzip the zip file - unzipped files will be in a new folder with the name of the zip file, "UCI HAR Dataset"
unzip(zipfn)

#View content in destdir - should see the zip file that was downloaded
list.files(destdir)
#View contents of the unzipped files in the directory "UCI HAR Dataset"
list.files("./UCI HAR Dataset", full.names = TRUE, recursive = TRUE)


#### Read the source data labels 
#Read the activity label file
actlabels <- read.table(paste(workdir, "/UCI HAR Dataset/activity_labels.txt", sep=""))
dim(actlabels)
head(actlabels)

#Read the feature labels file
raw.features <- read.table(paste(workdir, "/UCI HAR Dataset/features.txt", sep=""))
dim(raw.features)
head(raw.features)

##################################################
###2. CREATE 1 TEST datafile, 1 TRAINING datafile
##################################################

### Read the TEST datasets: subject, measurements(x), activity(y)
raw.test.subject <- read.table(paste(destdir, "/test/subject_test.txt", sep=""), col.names=c("Subject"))
raw.test.x <- read.table(paste(destdir, "/test/X_test.txt", sep=""))
raw.test.y <- read.table(paste(destdir, "/test/y_test.txt", sep=""), col.names=c("Activity"))
dim(raw.test.subject)
dim(raw.test.x)
dim(raw.test.y)

head(raw.test.subject)
raw.test.x[c(5:10),c(1:5)]
head(raw.test.y)

### Read the TRAIN datasets: : subject, measurements(x), activity(y)
raw.train.subject <- read.table(paste(destdir, "/train/subject_train.txt", sep=""), col.names=c("Subject"))
raw.train.x <- read.table(paste(destdir, "/train/X_train.txt", sep=""))
raw.train.y <- read.table(paste(destdir, "/train/y_train.txt", sep=""), col.names=c("Activity"))
dim(raw.train.subject)
dim(raw.train.x)
dim(raw.train.y)


#########################################################
###3. COMBINE THE TRAIN and TEST DATA INTO 1 FILE 
#########################################################
#There is no subject ID on the .x ad .y files; ASSUME each row corresponds
# to the subject in the same row number in the .subject file,
# i.e. a simple merge by row and not subject ID.

##Create 1 TRAIN file:  merge in activity labels with measurements
tmp <-cbind(raw.train.subject, raw.train.y, raw.train.x)
#Add variable to identify the group the subjects belong to
dtrain<-mutate(tmp, group="train")
dim(dtrain)
names(dtrain)
##Create 1 TEST file:  merge in activity labels with measurements
tmp <-cbind(raw.test.subject, raw.test.y, raw.test.x)
#Add variable to identify the group the subjects belong to
dtest<-mutate(tmp, group="test")
dim(dtest)
names(dtest)
##Stack (append) TRAIN and TEST files to form 1 data file
#Both files have the same number and sequence of variables  
dcombine <- rbind(dtrain, dtest)
dim(dcombine)
names(dcombine)
str(dcombine)

#Clean up work space
rm(tmp, dtest, dtrain, raw.test.subject, raw.test.x, raw.test.y, raw.train.subject, raw.train.x, raw.train.y)


####################################################################
###4. CREATE FILE WITH MEASUREMENTS FOR MEAN and STANDARD DEVIATIONS
####################################################################
###Use dplyr data table
dtable <- tbl_df(dcombine)

##Construct a vector of variable names to extract from dcombine data file
names(dcombine)

##Create list object of desired Feature statistics -
#From the features file, get row no. of feature names (variable V2) that contain the values "mean" and "std"
#and their associated values (to get strings that are variable names of the measurement)
FeatList <- list(findx=grep("[Mm]ean\\()|[Ss]td\\()", raw.features$V2), 
                 fvalue=grep("[Mm]ean\\()|[Ss]td\\()", raw.features$V2, value=TRUE) )
FeatList$findx
 
#Since the dcombine data file has the sequence of variables 1.Subject, 2.Activity, 3.V1, 4.V2,..
# ..563. V561, need to add 2 to V2indx
collist <-FeatList$findx+2
#Insert index values 1, 2, 564 for "Subject", "Activity", "group" before index values for the Mean, SD variables 
collist2 <-c(1,2,564, collist)
#Create data file by extracting desired variables with Mean and SD measurements
dtable_sub <-dtable[, c(collist2)]

##Rename variables in the extracted data frame
#Construct vector with original names of variables 
origvar <-names(dtable_sub)
#Construct vector with updated names of variables 
colnames <-c("subject","activity", "datasource", FeatList$fval)

##Data table with only mean and sd values for all subjects
#Rename using function from "gdata" package
dtable_sub <-rename.vars(dtable_sub, from=origvar, to=colnames)

rm(tmp)

##################################################
####5a. Assign descriptions to Activity variable
# Activity labels file:  actlabels
# Target data file:  dtable_sub
##################################################
#MERGE the activity names from actlabels file by activity index in dtable_sub file using sql
# Keep the original activity index variable "Activity"; 
#label the activity name variable "activitydescription"
dtable_sub2 <-sqldf('select dtable_sub.*, actlabels.V2 as "activitydescription"
                      from dtable_sub left join actlabels
                      on dtable_sub.Activity = actlabels.V1')
					  
## Reorder the variable positions in the data frame so that Activity_name(col#70) and "Activity"(col#2) are dropped
# Make subject group (col#3) the 1st variable.
dtable_sub2b<-dtable_sub2[, c(3,1,70,4:69)]
#'data.frame':	10299 obs. of  69 variables

#Clean up workspace
rm(dtable_sub, dtable_sub2)

##################################################
####5b. Assign descriptive variable names 
# Variable labels file:  colnames
# Target data file:  dtable_sub2b
##################################################

##Convert data structure of dtable_sub2b to into long-and-narrow strudure using tidyr functions
# The variables to become values are feature, axix, and type of statistic
tmp <-gather(dtable_sub2b, key=type_stat_dir, value=statvalue, -(datasource:activitydescription) )
dim(tmp)
#[1] 679734      5
names(tmp)
#[1] "datasource"          "subject"             "activitydescription" "type_stat_dir"      
#[5] "statval"     

#Separate out the values of the type_stat_dir variable into 3 variables corresponding to 
# feature, statistic, and axis direction
tmp2 <-separate(data = tmp, col = type_stat_dir, into = c("feature", "statistic","direction"))


## Preliminary tidy data set with mean and sd values (before checks)
#  Rearrange variable positions 
MeanStdData <-tmp2[ , c(1:4,6,5,7)]
str(MeanStdData)
#'data.frame':    679734 obs. of  7 variables:
#$ datasource         : chr  "train" "train" "train" "train" ...
#$ subject            : int  1 1 1 1 1 1 1 1 1 1 ...
#$ activitydescription: chr  "STANDING" "STANDING" "STANDING" "STANDING" ...
#$ feature            : chr  "tBodyAcc" "tBodyAcc" "tBodyAcc" "tBodyAcc" ...
#$ direction          : chr  "X" "X" "X" "X" ...
#$ statistic          : chr  "mean" "mean" "mean" "mean" ...
#$ statvalue          : num  0.289 0.278 0.28 0.279 0.277 ...

##clean up workspace
rm(tmp, tmp2)


###########################################################################################
####6. Create tidy data file with the average of each variable by activity, for each subject
# Use input data file:  MeanStdData
###########################################################################################

##Subset input file to where statistic=mean (want only mean values in the final file)
mean_sub <-filter(MeanStdData, statistic=="mean")
xtabs(~statistic, data=mean_sub)
#statistic  -- no. of records after subset
#mean 
#339867 
head(mean_sub)

##Create summary file: specify class of variables for the level at which mean statistic will be computed
#Specify the variables by which the data would be grouped  
tmp <-tbl_df(mean_sub)
by_activity <-group_by(tmp, datasource, subject, activitydescription, feature, direction)
#Compute mean values by the group
meandata <-summarize(by_activity, mean(statvalue))

dim(meandata)
#[1] 5940    6
head(meandata)
tail(meandata)

##Examine levels of variable=feature,subject, direction
#Found some values that needed editing
xtabs(~feature, data=meandata)
xtabs(~subject, data=meandata)
xtabs(~direction, data=meandata)

## Correct labels of the levels of the Feature variable 

# Convert to factor variables
activity <-factor(meandata$activitydescription)
featuretype <-factor(meandata$feature)
dir <-factor(meandata$direction)
# Include the factor variables in the file, and drop those character vectors the factors replaced
tmp <-cbind(meandata, activity, featuretype, dir)
meanfinal <-select(tmp, -feature, -activitydescription)
str(meanfinal)

# Correct labels of featuretype factor variable -- revalue() and mapvalues() DID NOT WORK
levels(meanfinal$featuretype)
levels(meanfinal$featuretype)[levels(meanfinal$featuretype)=="fBodyBodyGyroMag"] <- "fBodyGyroMag"
levels(meanfinal$featuretype)[levels(meanfinal$featuretype)=="fBodyBodyGyroJerkMag"]<-"fBodyGyroJerkMag" 
levels(meanfinal$featuretype)[levels(meanfinal$featuretype)=="fBodyBodyAccJerkMag" ] <- "fBodyAccJerkMag" 

## Rearrange columns in the final data file
meanfinal[ , c(1:2,5,6,3,4)]

# Edit of variable names for final tidy data
names(meanfinal)[names(meanfinal)=="mean(statvalue)"] <- "mean"
names(meanfinal)[names(meanfinal)=="featuretype"] <- "feature"
names(meanfinal)[names(meanfinal)=="direction"] <- "axisdirection"
names(meanfinal)

str(meanfinal)
#data.frame':	5940 obs. of  6 variables:
#$ datasource: chr  "test" "test" "test" "test" ...
#$ subject   : int  2 2 2 2 2 2 2 2 2 2 ...
#$ activity  : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
#$ feature   : Factor w/ 16 levels "fBodyAcc","fBodyAccJerk",..: 1 1 1 2 2 2 3 4 5 6 ...
#$ axisdirection : chr  "X" "Y" "Z" "X" ...
#$ mean      : num  -0.977 -0.98 -0.984 -0.986 -0.983 ...
 

##Output the tidy data to a comma delimited text file
write.table(tmp, file="./HARmean.txt", row.names=FALSE, col.names=TRUE, sep=",")
