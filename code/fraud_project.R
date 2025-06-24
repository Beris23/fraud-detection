library(tidyverse)
library(skimr)
library(ggplot2)
library(dplyr)
library(janitor)

fraud_data <- read.csv("C:/Users/GIMBIYA BENJAMIN/Desktop/fraud_detection/data2.csv")
fraud_data <- clean_names(fraud_data)
head(fraud_data)
glimpse(fraud_data)
str(fraud_data)
summary(fraud_data)
colSums(is.na(fraud_data))

fraud_data <-  fraud_data%>% select(-Credit_card_number)

fraud_data <- fraud_data %>%
  separate(expiry, into = c("expiry_month", "expiry_year"), sep = "/") %>%
  mutate(across(c(expiry_month, expiry_year), as.integer))

fraud_data$profession <- as.factor(fraud_data$profession)
fraud_data$fraud <- as.factor(fraud_data$fraud)

fraud_data %>%
  count(fraud) %>%
  ggplot(aes(x = fraud, y = n, fill = fraud)) +
  geom_col() +
  labs(title = "Fraud Class Distribution", x = "Fraud", y = "Count")

ggplot(fraud_data, aes(x = income, fill = fraud)) +
  geom_histogram(position = "identity", bins = 50, alpha = 0.6) + 
  labs(title = "income distribution by fraud", x = " income distribution by fraud", y = "Count") 
  

ggplot(fraud_data, aes(x = profession, fill = fraud)) +
  geom_bar(position = "fill")+
  labs(title = "Profession Proportion vs Fraud", y = "Proportion") +
  scale_y_continuous(labels = scales::percent)

set.seed(123)
train_indices <- sample(1:nrow(fraud_data), 0.8 * nrow(fraud_data))
train <- fraud_data[train_indices, ]
test <- fraud_data[-train_indices, ]

fraud_model <- glm(fraud ~ profession + income + security_code + expiry_month + expiry_year,
             data = train, family = binomial)
summary(fraud_model)

test$predicted_prob <- predict(fraud_model, newdata = test, type = "response")
test$predicted_class <- ifelse(test$predicted_prob > 0.5, 1, 0) %>% as.factor()

conf_matrix <- table(predicted = test$predicted_class, Actual = test$fraud)

print(conf_matrix)

library(pROC)
roc_obj <- roc(test$fraud, test$predicted_prob)

plot(roc_obj, main = "ROC Curve - Logistic Regression", col = "blue")
auc(roc_obj)  


summary(fraud_model)$coefficients

# Optional: Plot top features by absolute coefficient value
coef_df <- as.data.frame(summary(fraud_model)$coefficients)
coef_df$Feature <- rownames(coef_df)

coef_df %>%
  filter(Feature != "(Intercept)") %>%
  mutate(abs_coef = abs(Estimate)) %>%
  ggplot(aes(x = reorder(Feature, abs_coef), y = abs_coef)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Feature Importance (Logistic Regression)",
       x = "Feature", y = "Absolute Coefficient")

library(randomForest)
rf_model <- randomForest(fraud ~ profession + income + security_code + expiry_month + expiry_year,
                         data = train, ntree = 5000, importance = TRUE)

rf_preds <- predict(rf_model, newdata = test, type = "prob")[,2]
rf_class <- ifelse(rf_preds > 0.5, 1, 0) %>% as.factor()

conf_matrix <- table(Predicted = rf_class, Actual = test$fraud)

rf_roc <- roc(test$fraud, rf_preds)
plot(rf_roc, main = "ROC Curve - Random Forest", col = "darkgreen")
auc(rf_roc)

library(pheatmap)

numeric_data <- fraud_data %>%
  select(where(is.numeric))

scaled_data <- scale(numeric_data)

cor_matrix <- cor(scaled_data)


pheatmap(cor_matrix, 
         main = "Heatmap of Feature Correlations", 
         color = colorRampPalette(c("blue", "white", "red"))(100),
         border_color = NA)



