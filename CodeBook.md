#CodeBook for tidyData.csv
tidyData.csv is a data summary of the data set "Human Activity Recognition Using Smartphones Dataset, Version 1.0".

The data was prepared and reduced using R version 3.0.3 running on Mac OS X 10.9.2. The reduction process should work as provided on Mac and Linux systems.

###The original dataset
The data is "Human Activity Recognition Using Smartphones Dataset, Version 1.0", published as:  
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012. 

This source, as well as the information available with the data itself, should be consulted for details about the data collection process. As a summary I quote from the `README.txt` file provided with the data:

"The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data."

###Acquiring and preparing the data
The data is [described here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones), and can be [downloaded here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). The script `get_data.sh` will download the data, unzip it, and rename the dataset directory as `UCI-HAR-dataset`.

The script also uses some command line tools (`sed` and `tr`) to convert the two largest data files into csv from their original fixed-width format. This allows us to more easily use `fread` when processing the data, which is tremendously faster than using, e.g., `read.table`.

To acquire and prepare the data, from the command line run:  
`bash get_data.sh`

Note that I do not deal directly with the raw data in the `Inertial\ Signals` directories, rather I use the intermediate data products described in the `README.txt` file in the data directory.


###Reducing the data
The R script `run_analysis.R` handles the data merging and reduction. It can be run from the command line in the same working directory that `get_data.sh` was run in:  
`Rscript run_analysis.R`  
 Specifically, the data in `X_train.csv` and `X_test.csv` are imported as data tables and combined (with rbind). The activity codes in `y_train.txt` and `y_test.txt` and the subject identifiers in `subject_train.txt` and `subject_test.txt` are likewise combined, preserving row ordering. 

A new column is created giving names to the activity identifiers, taken from `activity_labels.txt`. The 561 features in the combined X sample are named using the feature labels in `features.txt`. The subject IDs, activity codes and names, and variable observations are combined into a total dataset. This is then trimmed and analysed as described below.

###Variables in tidyData.csv
The first three columns in tidyData.csv are:  
`SubjectID` - the Subject ID as Subject-1, Subject-2,...,Subject-30    
`ActivityCode` - the original activity code, a number 1 through 6  
`ActivityName` - the activity descriptor, one of LAYING, SITTING, STANDING, WALKING, WALKING\_DOWNSTAIRS, WALKING\_UPSTAIRS. This is strictly dependent on `ActivityCode`.  

These serve to identify the combination of subject and activity that the row is concerning. The remaining columns are identified by their original names from the raw dataset. __For each row (i.e. each combination of Subject and Activity), the number in a column is the mean value of all measurements of that variable in the original dataset for that Subject and Activity combination__.  

The columns that I provide this mean value for are a subset of the original data, specifically only those columns dealing with mean or standard deviations of measurements. These were selected by selecting variables containing the strings `mean()` and `std()` in the feature set. This yields the set of features below. For compactness, labels in square brackets can be understood to be iterated over: e.g. `[tf]Foo-mean()-[XYZ]` implies that I provide columns for `tFoo-mean()-X`, `tFoo-mean()-Y`, `tFoo-mean()-Z`, `fFoo-mean()-X`, `fFoo-mean()-Y`, and `fFoo-mean()-Z`. I have opted to leave the variable descriptors as they are in the original data (listed in `features.txt`), since they are reasonably descriptive, human readable, and consistent with any analysis that may have been done already on the raw data.


`[tf]BodyAcc-mean()-[XYZ]`  
`tGravityAcc-mean()-[XYZ]`  
`[tf]BodyAccJerk-mean()-[XYZ]`  
`[tf]BodyGyro-mean()-[XYZ]`  
`tBodyGyroJerk-mean()-[XYZ]`  
`[tf]BodyAccMag-mean()`  
`tGravityAccMag-mean()`  
`tBodyAccJerkMag-mean()`  
`tBodyGyroMag-mean()`  
`tBodyGyroJerkMag-mean()`  
`fBodyBodyAccJerkMag-mean()`  
`fBodyBodyGyroMag-mean()`  
`fBodyBodyGyroJerkMag-mean()`  
`[tf]BodyAcc-std()-[XYZ]`  
`tGravityAcc-std()-[XYZ]`  
`[tf]BodyAccJerk-std()-[XYZ]`  
`[tf]BodyGyro-std()-[XYZ]`  
`tBodyGyroJerk-std()-[XYZ]`  
`[tf]BodyAccMag-std()`  
`tGravityAccMag-std()`  
`tBodyAccJerkMag-std()`  
`tBodyGyroMag-std()`  
`tBodyGyroJerkMag-std()`  
`fBodyBodyAccJerkMag-std()`  
`fBodyBodyGyroMag-std()`  
`fBodyBodyGyroJerkMag-std()`    

The original dataset documentation can be referred to for more details beyond the descriptions provided by the names. Some description is provided in the dataset file `features_info.txt`:  
"The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions."

__IMPORTANT NOTE ON UNITS: this data is dimensionless! The values have all been normalized and scaled to lie in the range [-1, 1].__    

###Structure of tidyData.csv
tidyData.csv contains 181 rows; one header row containing column names and 180 data rows. Each row is a unique combination of one of 30 Subjects and one of 6 Activities.
