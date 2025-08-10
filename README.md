# Getting and Cleaning Data – Course Project

This repo contains:
- `run_analysis.R` – performs steps 1–5 on the UCI HAR Dataset and writes `tidydata.txt`
- `CodeBook.md` – variables, units, and all transformations
- `tidydata.txt` – second tidy dataset (average of each variable for each subject and activity)

## How to run
1. Place the folder `UCI HAR Dataset` in the same directory as `run_analysis.R`.
2. In R/RStudio: `source('run_analysis.R')`
3. The script writes `tidydata.txt` to the working directory.

## Notes
- Only `mean()` and `std()` features are extracted (not `meanFreq()` or `angle(...)`).
- Activity names are descriptive; variable names are cleaned and expanded.
