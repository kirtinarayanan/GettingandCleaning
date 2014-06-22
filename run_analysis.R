## Download the data file

if(!file.exists("./data")){dir.create("./data")}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./data/dataset.zip")

## Unzip the data file to new directory

unzip("./data/dataset.zip", exdir = "./data")

dir <- file.path("./data/UCI HAR Dataset")

## Read all relevant files

testset <- read.table(file.path(dir, "test", "X_test.txt"))
testlabels <- read.table(file.path(dir, "test", "y_test.txt"))
trainingset <- read.table(file.path(dir, "train", "X_train.txt"))
traininglabels <- read.table(file.path(dir, "train", "y_train.txt"))
subjecttest <- read.table(file.path(dir, "test", "subject_test.txt"))
subjecttrain <- read.table(file.path(dir, "train", "subject_train.txt"))
featureslist <- fread(file.path(dir, "features.txt"))
activitylabels <- read.table(file.path(dir, "activity_labels.txt"))

## Q.1 Merging training and test rows

datasubject <- rbind(subjecttrain, subjecttest)
datalabels <- rbind(traininglabels, testlabels)
data <- rbind(trainingset, testset)

## Merging columns 
fulldata <- cbind(datasubject, datalabels, data)

fulldata <- as.data.frame(fulldata)

## Assigning column names
names(fulldata)[1] <- "Subject"
names(fulldata)[2] <- "Class.Number"

## Q.2 Extracting only mean and std

setnames(featureslist, names(featureslist), c("featureNum", "featureName"))
dtFeatures <- featureslist[grepl("mean\\(\\)|std\\(\\)", featureName)]
dtFeatures$featureCode <- dtFeatures[, paste0("V", featureNum)]

## Crate new data frame for Q2 called newdt: 
newdt <- cbind(fulldata[1], fulldata[2])
dtFeatures <- as.matrix(dtFeatures)

## Importing column names along with data

for(i in c(3:563)){
  for(j in c(1:66)){
    if(names(fulldata[i]) %in% dtFeatures[j,3])
    {
      names(fulldata)[i] <- dtFeatures[j,2]
      newdt <- cbind(newdt, fulldata[i])
    }
  }
}

## Labeling with descriptive activity names
names(activitylabels)[1] <- "Class.Number"
names(activitylabels)[2] <- "Activity.Name"
newdt <- merge(newdt, activitylabels, by="Class.Number", all = TRUE)

## Convert newdt to data.table
newdt <- as.data.table(newdt)

#Set Key for reshaping data
setkey(newdt, Subject, Class.Number, Activity.Name)

##Melt data table
newdt <- data.table(melt(newdt, key(newdt), variable.name="Feature"))


##Create tidy data table
setkey(newdt, Subject, Activity.Name, Feature)
TidyData <- newdt[, list(count = .N, average = mean(value)), by=key(newdt)]
write.table(TidyData, "./TidyData.txt", sep="\t")
