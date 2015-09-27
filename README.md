#BACKGROUND
This project is for the COURSERA Getting and Cleaning Data course (September 2015).

The source data for this project were collected from experiments which measured select activities of human subjects using the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The experiments involved 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING-UPSTAIRS, WALKING-DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist.  Using the smartphone's embedded accelerometer and gyroscope, measurements for 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz were captured. 
The experiments have been video-recorded to label the data manually. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

The data from the 30 volunteers were randomly partitioned into two sets, where 70% of the volunteers was selected for generating the **Training data** and 30% the **Test data**. 




#R SCRIPT: run_analysis.R

This script does the following: 

1. Read in the source data which consists of multiple text files for the Test and Training subjects from a zipped file.
2. Create one Test data file by merging the subject, labels and measurements files for the Test group. Similarly, create one Training data file for the Training group.

        There is no subject identifier on the measurment (x) and label(y) files. 
        ASSUMPTION made: each row corresponds to the subject in the same row number in the subject file, 
        i.e. merge simply by row.
        
3. Test and Train datasets have the same number of variables locaated in the same sequence of positions in each file. Append (or stack) the Test and Train datasets to form a single data file.
4. From step 3., create a file that contains only the mean and standard deviation measurments.
5. Assign meaningful variable names and factor labels to the data file.  
6. Create a tidy data file, HARmean.txt, where each record contains the mean measurement of a specific feature-axis direction per activity for each subject.
       + check label values and edit variable names before outputting tidy data file.
       

# TIDY DATA FILE
file name:  HARmean.txt  

This is the data file created at the end (Step 6.) of the run_analysis.R script. In this data set, each record shows a subject's mean measurement for a unique combination of activity-feature-axial direction.

No. observations: 5,940   
No. of variables: 6 variables  

Variables:  
   - datasource  
   - subject    
   - activity  
   - feature     
   - direction  
   - mean       
 
See Codebook.md for descriptions of the variables.
