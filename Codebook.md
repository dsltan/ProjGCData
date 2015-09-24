
#CODE BOOK for HARmean.txt  


Each record in this data file shows a subject's mean measurement for a specific activity-feature_axialdirection combination.

No. observations: 5,940   
No. of variables: 6 variables  

## Variable description

1. **datasource**: Indicates if subject belonged to the Test or Training group.
    + character  
    + permissible values: test, train    
    
2. **subject**: Subject identifer.      
    + integer     
    + permissible value range: 1-30.    
    
  
3. **activity**: description of actions for which measurements were taken.
    + factor  
    + 6 levels - walking, walking upstairs, walking downstairs, sitting, standing, laying.       


4. **feature**: the names of a variety of frequency and time domain signals from the accelerometer and gyroscope in 3 axial directions X, Y, and Z.   
    + factor  
    + 16 levels - *Independent of the X,Y,Z directions. See section "Feature description" below.*   

5. **direction**: denotes signals in one of the 3-axial directions X, Y and Z.  
    + character  
    + permissible values: X, Y, Z  

6. **mean**: mean value      
    + integer     
    
    
## Description of feature levels

*Notation* 
   The prefix 't' denote time domain signals.
   The preix 'f' denotes freqency domain.


The features come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. 
  
These time domain signals were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. 

The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz.  

1. Body and gravity acceleration signals in directions X, Y, Z (Time domain)       
  + tBodyAcc: body acceleration signal (time)    
  + tGravityAcc: gravity acceleration signal(time)
  

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals. 
The magnitude of these three-dimensional signals were also calculated using the Euclidean norm.  

2. Jerk signals
  + tBodyAccJerk: body linear acceleration Jerk signal  
  + tBodyGyroJerk: body angular velocity Jerk signal

3. Jerk signal magnitude using the Euclidean norm (Time domain)   
  + tBodyAccMag: body linear acceleration (Euclidean)  
  + tGravityAccMag: gravity acceleration (Euclidean)   
  + tBodyAccJerkMag: body linear acceleration Jerk signal (Euclidean)  
  + tBodyGyroMag: body angular velocity (Euclidean)
  + tBodyGyroJerkMag:body angular velocit Jerk signal (Euclidean)  
  
  
Finally, a Fast Fourier Transform (FFT) was applied to some of these signals.  

4. Fast Fourier Transform (FFT) was applied to some of these signals (Frequency domain)   
  + fBodyAcc: body linear acceleration (frequency, FFT)  
  + fBodyAccJerk: body linear acceleration Jerk signal (frequency, FFT)   
  + fBodyGyro: body angular velocity (frequency, FFT) 
  + fBodyAccMag: body linear acceleration (Euclidean, frequency, FFT  )  
  + fBodyAccJerkMag: body linear acceleration Jerk signal (Euclidean, frequency, FFT)    
  + fBodyGyroMag: body angular velocity (Euclidean, frequency, FFT )  
  + fBodyGyroJerkMag:body angular velocity Jerk signal (Euclidean, frequency, FFT)       


Vectors obtained by averaging the signals in a signal window sample:     
  + gravityMean  
  + tBodyAccMean  
  + tBodyAccJerkMean  
  + tBodyGyroMean  
  + tBodyGyroJerkMean  
