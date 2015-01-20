#read features names
features = read.table("features.txt",header=F)
#check the number of names
dim(features)

#read training data and use the features name as variable names
train_data = read.table("train/X_train.txt",header=F, col.names=features$V2)

train_label = read.csv("train/y_train.txt",header=F)

train_subject = read.csv("train/subject_train.txt",header = F)

train_data$label = train_label$V1

train_data$subject = train_subject$V1

#read test data

test_data = read.table("test/X_test.txt",header=F, col.names=features$V2)

test_label = read.csv("test/y_test.txt",header=F)

test_subject = read.csv("test/subject_test.txt",header = F)


test_data$label = test_label$V1
test_data$subject = test_subject$V1

#check if test and train have the same number of columns
length(names(train_data))
length(names(test_data))

#merge
data = rbind(train_data,test_data)

dim(train_data)[1] + dim(test_data)[1]
dim(data)

#2. Extracts only the measurements on the mean and standard deviation for each measurement
mean_std_names = grep("[mM]ean|std",names(data),value=T)
mean_std_names

extracted_data = data[,c(mean_std_names,"subject")]
dim(extracted_data)


#3. Uses descriptive activity names to name the activities in the data set
activities = read.table("activity_labels.txt",header=F)

extracted_data$activity_label = sapply(data$label, function(i){      
      activities[i,"V2"]
})
names(extracted_data)[1]

#4. already done when reading datasets
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#install.packages("dplyr")
library(dplyr)

#group by subject and activity_label and then take mean of all variables
tidy_data = extracted_data %>% 
      group_by_(.dots = c("subject","activity_label")) %>% 
      summarise_each(funs(mean))

#normalize name of variables
variable_names = gsub("[.]+","_",names(tidy_data)) 
variable_names = gsub("_$","",variable_names)
names(tidy_data) = variable_names

#write the data into a file
write.table(tidy_data,file = "tidy_data.txt", row.names = F)



