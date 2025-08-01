# CodeBook

This code book describes the variables in the `tidydata.txt` file, as well as the transformations applied.

## Source Data

Original data were taken from:
  
  [UCI HAR Dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

## Variables in `tidydata.txt`

Each row represents the **average** of a measurement for one subject and one activity.

Variables include:
  
  - subject: ID of the subject (1–30)
- activity: Activity name (WALKING, LAYING, etc.)
- TimeBodyAccelerometerMeanX
- TimeBodyAccelerometerMeanY
- ...
- FrequencyBodyGyroscopeSTDZ

(Only mean and std variables were included.)

## Transformations

- Merged train and test datasets
- Extracted only variables with `mean()` and `std()`
- Used activity labels for readability
- Cleaned variable names for clarity
- Aggregated by subject and activity using `dplyr::summarise_all(mean)`

