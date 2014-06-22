Steps for the analysis:

1. Download the zip file from the source
2. Unzip to appropriate directory
3. Read all relevant files using the read.table function. The files required for this excersise are:
    - The Feature list features.txt
    - List of activities, activity_labels.txt
    - Training set and labels
    - Test set and labels
    - Training and test subjects data
4. Merge data sets in the following way:
    - Merge columns of the subject data from training and test files
    - add rows for labels
    - add data rows from the test and training sets
    - assign column names for the subject and class number to avoid confusion
    
5. Extracting only mean and std columns
    - use the features information: manipulate the table to give it column names
    - Use the grepl function to narrow down to features that contain mean or std
    - Create a new data frame called newdt; cbind columns from the merged data that match the narrowed down features using nested ifs
    
6. Use the activities table to import descriptive activity names using the merge function
    - set keys and melt the data table
    
7. Create a tidy data table with averge and count for each subject and feature
