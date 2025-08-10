# run_analysis.R
# Getting and Cleaning Data - Course Project
suppressPackageStartupMessages(library(dplyr))

# ---- 0) Verify data folder ----
droot <- file.path(getwd(), 'UCI HAR Dataset')
if (!dir.exists(droot)) stop('Folder "UCI HAR Dataset" not found in working directory.')

# ---- 1) Read metadata ----
features   <- read.table(file.path(droot, 'features.txt'), col.names = c('idx','name'), stringsAsFactors = FALSE)
activities <- read.table(file.path(droot, 'activity_labels.txt'), col.names = c('code','activity'), stringsAsFactors = FALSE)

# ---- 2) Helper to read a split (train/test) ----
read_split <- function(split = c('train','test')) {
  split <- match.arg(split)
  x <- read.table(file.path(droot, split, paste0('X_', split, '.txt')))
  y <- read.table(file.path(droot, split, paste0('y_', split, '.txt')), col.names = 'activity_code')
  subj <- read.table(file.path(droot, split, paste0('subject_', split, '.txt')), col.names = 'subject')
  cbind(subj, y, x)
}

train <- read_split('train')
test  <- read_split('test')

# ---- 3) Merge training and test sets ----
merged <- rbind(train, test)
colnames(merged) <- c('subject', 'activity_code', features$name)

# ---- 4) Extract only mean() and std() features ----
wanted_idx <- grep('mean\(\)|std\(\)', features$name)
keep_cols  <- c(1, 2, wanted_idx + 2)
data2 <- merged[, keep_cols]

# ---- 5) Use descriptive activity names ----
data2 <- merge(data2, activities, by.x = 'activity_code', by.y = 'code', all.x = TRUE)
data2 <- data2[, c('subject', 'activity', setdiff(names(data2), c('subject','activity','activity_code')))]

# ---- 6) Label variables with descriptive names ----
clean_names <- function(x) {
  x <- gsub('\u005c\u005c(\u005c\u005c)', '', x)
  x <- gsub('-', '_', x)
  x <- gsub('^t', 'Time_', x)
  x <- gsub('^f', 'Freq_', x)
  x <- gsub('Acc', 'Accelerometer', x)
  x <- gsub('Gyro', 'Gyroscope', x)
  x <- gsub('Mag', 'Magnitude', x)
  x <- gsub('BodyBody', 'Body', x)
  x
}
names(data2) <- c('subject', 'activity', clean_names(names(data2)[-c(1,2)]))

# ---- 7) Create second tidy dataset: mean by subject & activity ----
tidy <- data2 %>%
  group_by(subject, activity) %>%
  summarise(across(everything(), mean), .groups = 'drop') %>%
  arrange(subject, activity)

# ---- 8) Write output exactly as required ----
write.table(tidy, file = 'tidydata.txt', row.name = FALSE)
message('Wrote tidydata.txt in: ', getwd())
