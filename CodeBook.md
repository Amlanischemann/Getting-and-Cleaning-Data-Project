# CodeBook

## Source data
UCI HAR Dataset: Human Activity Recognition Using Smartphones (Samsung Galaxy S). The original signals are accelerometer (in g) and gyroscope (in rad/s). Magnitude features are Euclidean norms.

## Processing steps
1. Merged training and test sets.
2. Extracted only features with `mean()` or `std()` in their original names (excluded `meanFreq()` and `angle(...)`).
3. Replaced activity codes with descriptive names.
4. Cleaned variable names:
   - Removed `()` and replaced `-` with `_`.
   - `t` → `Time_`; `f` → `Freq_`
   - `Acc` → `Accelerometer`; `Gyro` → `Gyroscope`; `Mag` → `Magnitude`; `BodyBody` → `Body`.
5. Created a second, independent tidy dataset: the **mean** of each measurement for each **subject** and **activity**.
6. Wrote `tidydata.txt` with `row.name = FALSE`.

## Variables in `tidydata.txt`
- `subject` (integer 1–30)
- `activity` (character): WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
- All remaining columns: **averages** of the corresponding Time/Freq Accelerometer/Gyroscope features (units inherited from source: g or rad/s).

## Tidy data principles
- One variable per column, one observation (subject × activity) per row, one table per observational unit.
