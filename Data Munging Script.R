#Set
WD and load data
setwd("D:\\RWD\\Kaggle\\Redhat")
#
load data training data
RH.people
<- read.csv("D:\\RWD\\Kaggle\\Redhat\\data\\people.csv", na.strings = c("NA", ""))
RH.activity
<- read.csv("D:\\RWD\\Kaggle\\Redhat\\data\\act_train.csv", na.strings = c("NA", ""))

#
people is a unique list of customers, activity is a unique list of actions
#
the data sets should be merged somehow

head(RH.people)
head(RH.activity)

#
people_id is the key to merge
#
but we need to change the 'char_x' column names in RH.activity

RH.activity$char_40
<- RH.activity$char_1
RH.activity$char_41
<- RH.activity$char_2
RH.activity$char_42
<- RH.activity$char_3
RH.activity$char_43
<- RH.activity$char_4
RH.activity$char_44
<- RH.activity$char_5
RH.activity$char_45
<- RH.activity$char_6
RH.activity$char_46
<- RH.activity$char_7
RH.activity$char_47
<- RH.activity$char_8
RH.activity$char_48
<- RH.activity$char_9
RH.activity$char_49
<- RH.activity$char_10
#
in the merged data set, activites will be all the 40s charecteristics
#
now i need to remove the columns ive duplicated before merging
head(RH.activity)
RH.activity$char_1
<- NULL
RH.activity$char_2
<- NULL
RH.activity$char_3
<- NULL
RH.activity$char_4
<- NULL
RH.activity$char_5
<- NULL
RH.activity$char_6
<- NULL
RH.activity$char_7
<- NULL
RH.activity$char_8
<- NULL
RH.activity$char_9
<- NULL
RH.activity$char_10
<- NULL

head(RH.activity)

RH.training
<- merge(RH.people, RH.activity)
head(RH.training)

#
now need to start looking at an understanding the columns
summary(RH.training)
#
there are some NAs in there
install.packages("Amelia")
library(Amelia)

missmap(RH.training)
#
the missmap shows only activities have missing values, however they are in two groups which when combined make 100%
#
char_40 to 48 is one group, 49 is the other
#
we therefore do not need to handle missing values

#####################################
#
creating a validation set

#
install 'caret' package
set.seed(45)
RH.trainIndex
<- createDataPartition(RH.training$outcome, p =0.8, list = FALSE)

head(RH.trainIndex)

RH.train
<- RH.training[RH.trainIndex,]
RH.valid
<- RH.training[-RH.trainIndex,]

dim(RH.train)
#106,000 rows
dim(RH.valid)
# 26,000 rows

mean(RH.train$outcome)
# 37.2%
mean(RH.valid$outcome)
# 37.3%
#
outcome is roughly equal so hopefully the validation set is representative of the training set

install.packages("rpart")
library('rpart')

#
now lets start building a tree to predict the outcomes
#
tutorial can be seen here http://www.statmethods.net/advstats/cart.html

rpart(RH.training$outcome
      ~ RH.training$char_40, data = RH.training, method = 'class')