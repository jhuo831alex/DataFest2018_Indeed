library(xgboost)
set.seed(1)
final_dat7 <- final_dat12
#[sample(1:nrow(final_dat10),0.5*nrow(final_dat10)),]

dmy <- dummyVars("~.", data=final_dat7)
trainTrsf <- data.frame(predict(dmy, newdata = final_dat7))
outcomeName <- c('resp')
predictors <- names(trainTrsf)[!names(trainTrsf) %in% outcomeName]
trainSet <- trainTrsf

bst <- xgboost(data = as.matrix(trainSet[,predictors]),
               label = trainSet[,outcomeName],nrounds = 100)

dat_target = as.matrix(final_dat7$resp)
importance <- xgb.importance(feature_names = colnames(final_dat7[,-14]),model = bst)
importance




write.csv(importance,"Xgboost_importance_combine.csv")
write.csv(final_dat6,"final_dat6.csv")
xgb.plot.importance(importance)
?xgboost

xgb.preds = predict( bst, as.matrix( trainSet[, predictors ]))
class(xgb.preds)
temp<-cbind(xgb.preds,trainSet)

plot(temp$num_NA,log(temp$xgb.preds))
aggregate(xgb.preds~num_NA,data=temp[is.na(temp$supervisingJob),],FUN = mean,na.rm=T)
