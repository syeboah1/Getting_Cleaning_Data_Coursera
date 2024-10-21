# CodeBook.md

## Author:

Sheila Yeboah

### Description:

Codebook for explaining operations done on UCI HAR Dataset

`/UCI HAR Dataset` : folder containing all the data for the project

-   `/test`: holds the testing set data

-   `/train`: holds the training set data

### Libraries used for analysis:

-   `dplyr`
-   `stringr`
-   `tidyr`
-   `tidyverse`
-   `reshape2`

Cleaning the data involved removing excessive whitespace with stringr and merging the test and train datasets. Tidyr and tidyverse helped to get the dataset tidy

Variables:

-   `activity_names`: 6 activity names from the UCI HAR dataset
-   `almost_tidy`: Data with subject, activity and feature, but activity are integers
-   `complete_data`: merged raw training and testing data
-   `features`: char vector, read in feature names from UCI HAR dataset
-   `mean_data`: char vector, all the observations of mean features in the dataset
-   `mean_feature_names`: char vector, names of the features where mean was the measurement
-   `mean_features`: logical vector, where TRUE represents name in `features` where "mean" was in
-   `melt_almost_tidy`: melted dataset where each patient was an observation
-   `std_data`: char vector, all the observations of std features in the dataset
-   `std_feature_names`: char vector, names of the features where std was the measurement
-   `std_features`: logical vector, where TRUE represents name in `features` where "std" was in
-   `subset_complete_data`: complete data, selecting only subject and activity
-   `subset_mean_data`: Extract the mean values for each feature from `completedata$Measurement` by subsetting with logical vector, `mean_features`
-   `subset_std_data`: Extract the std values for each feature from `completedata$Measurement` by subsetting with logical vector,`std_features`
-   `test_set_*`: Read in training set data, split itno labels, measurements and subjects.
-   `tidy`: Final tidy data set
-   `tidy_activity`: activities for tidy data set
-   `tidy_subject`: subjects for tidy dataset
-   `training_set_*`: Read in training set data, split itno labels, measurements and subjects. `training_set` is all of these bound by column
