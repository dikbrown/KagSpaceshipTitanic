library(dplyr)
seed <- 42

#Read in train and test sets
fulltrain <- read.csv("./data/train.csv")
test <- read.csv("./data/test.csv")

#####################
##### Transform #####
#####################

#separate out cabin info into deck/num/side
fulltrain$deck <- stringr::word(fulltrain$Cabin, 1, sep = "/")
fulltrain$room_num <- stringr::word(fulltrain$Cabin, 2, sep = "/")
fulltrain$side <- stringr::word(fulltrain$Cabin, 3, sep = "/")
fulltrain <- fulltrain[,-4] #remove Cabin column

test$deck <- stringr::word(test$Cabin, 1, sep = "/")
test$room_num <- stringr::word(test$Cabin, 2, sep = "/")
test$side <- stringr::word(test$Cabin, 3, sep = "/")
test <- test[,-4] # remove Cabin column


#pull group number from id
fulltrain$group <- factor(substr(fulltrain$PassengerId, 1, 4))
test$group <- factor(substr(test$PassengerId, 1, 4))

#Calculate group size
train_group_sizes <- fulltrain %>%
  group_by(group) %>%
  summarize(grp_size = n())

test_group_sizes <- test %>%
  group_by(group) %>%
  summarize(grp_size = n())

#add group size to datasets
fulltrain <- inner_join(fulltrain, train_group_sizes)
test <- inner_join(test, test_group_sizes)

############################################
## Convert categoric variables to factors ##
############################################
fulltrain$HomePlanet <- factor(fulltrain$HomePlanet)
fulltrain$CryoSleep <- factor(fulltrain$CryoSleep)
fulltrain$Destination <- factor(fulltrain$Destination)
fulltrain$VIP <- factor(fulltrain$VIP)
fulltrain$deck <- factor(fulltrain$deck)
fulltrain$side <- factor(fulltrain$side)
fulltrain$Transported <- factor(fulltrain$Transported)
fulltrain$room_num <- as.numeric(fulltrain$room_num)

test$HomePlanet <- factor(test$HomePlanet)
test$CryoSleep <- factor(test$CryoSleep)
test$Destination <- factor(test$Destination)
test$VIP <- factor(test$VIP)
test$deck <- factor(test$deck)
test$side <- factor(test$side)
test$room_num <- as.numeric(test$room_num)

############################
## Impute NAs in test set ##
############################

test2 <- na.roughfix(test[,-c(1,12)])

########################################################
### split training data into train and validate sets ###
########################################################
set.seed(seed)
nobs <- nrow(fulltrain)
validate_idx <- sample(nobs, 0.2*nobs) #use 20% for validation
train <- fulltrain[-validate_idx,]
validate <- fulltrain[validate_idx,]
