library(data.table)
library(FeatureHashing)
library(Matrix)
library(xgboost)

setwd("~/GitHub/Deloitte-Kaggle-Redhat")

people <- fread("people.csv")
people_logical <- names(people)[which(sapply(people, is.logical))]

for (col in people_logical) set(people, j = col,
                        value = as.integer(people[[col]]))

train  <- fread("act_train.csv")
d1     <- merge(train, people, by = "people_id", all.x = T)

Y <- d1$outcome
d1[ , outcome := NULL]

b <- 2 ^ 22
f <- ~ . - people_id - activity_id - date.x - date.y - 1

X_train <- hashed.model.matrix(f, d1, hash.size = b)

set.seed(30000)
unique_p <- unique(d1$people_id)
valid_p  <- unique_p[sample(1:length(unique_p), 30000)]

valid <- which(d1$people_id %in% valid_p)
model <- (1:length(d1$people_id))[-valid]

param <- list(objective = "binary:logistic",
              eval_metric = "auc",
              booster = "gblinear",
              eta = 0.03)

dmodel  <- xgb.DMatrix(X_train[model, ], label = Y[model])
dvalid  <- xgb.DMatrix(X_train[valid, ], label = Y[valid])

m1 <- xgb.train(data = dmodel, param, nrounds = 100,
                watchlist = list(model = dmodel, valid = dvalid),
                print_every_n = 10, early.stop.round = 10)