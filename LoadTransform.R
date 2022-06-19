library(dplyr)

#Read in train and test sets
fulltrain <- read.csv("./data/train.csv")
test <- read.csv("./data/test.csv")

#split training data into train and validate sets
nobs <- nrow(fulltrain)
validate_idx <- sample(nobs, 0.2*nobs) #use 20% for validation
train <- fulltrain[-validate_idx,]
validate <- fulltrain[validate_idx,]

#separate out cabin info into deck/num/side
train$deck <- substr(train$Cabin, 1, 1)
train$room_num <- substr(train$Cabin, 3, 3)
train$side <- substr(train$Cabin, 5, 5)
train <- train[,-4] #remove Cabin column

test$deck <- substr(test$Cabin, 1, 1)
test$room_num <- substr(test$Cabin, 3, 3)
test$side <- substr(test$Cabin, 5, 5)
test <- test[,-4] # remove Cabin column


#pull group number from id
train$group <- factor(substr(train$PassengerId, 1, 4))
test$group <- factor(substr(test$PassengerId, 1, 4))

#Calculate group size
group_sizes <- train %>%
                group_by(group) %>%
                summarize(grp_size = n())

#add group size to dataset
train2 <- inner_join(train, group_sizes)
