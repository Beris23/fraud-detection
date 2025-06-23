🛡️ Fraud Detection Project

 Overview

This project focuses on detecting fraudulent transactions using customer and card-related data. It applies exploratory data analysis and machine learning techniques to identify patterns associated with fraudulent behavior.


 Dataset Description

The dataset contains 10,000 records with the following features:

| Feature             | Description                                           
|---------------------|---------------------------------------------
| Profession        | Customer's profession (e.g., Doctor, Engineer)       
| Income            | Annual income of the customer                        
|Credit_card_number | Credit card ID (removed for modeling)                
| Expiry            | Card expiry date (split into month and year)         
|Security_code      | Security code on the card                            
| Fraud             | Target variable: 1 = Fraud, 0 = Not Fraud           


 Data Cleaning & Preprocessing

- Removed "Credit_card_number" as it is not predictive.
- Split "expiry" into "expiry_month" and "expiry_year".
- Converted categorical variables into factors.
- Checked for and confirmed absence of missing values.
- Scaled numeric variables for heatmap analysis.

 Exploratory Data Analysis (EDA)

- **Fraud Distribution:** The dataset is balanced.
- **Profession vs Fraud:** Certain professions are more fraud-prone.
- **Income Distribution:** Differences in income trends between fraud classes.
- **Correlation Heatmap:** Weak-to-moderate correlations between numeric features.

 Models Built

🔹 Logistic Regression
- Interpretable linear model.
- Achieved ROC AUC ~ 0.85–0.9.
- Key features: income, expiry_month, profession.

🔹 Random Forest
- Handles non-linear relationships and feature interactions.
- Improved performance over logistic regression.
- Visualized feature importance using Gini impurity.

 Evaluation Metrics

**Confusion Matrix** for both models.
**ROC Curve** and **AUC** to assess classification performance.
 **Feature Importance** visualized for both models.


📌 Key Findings
1) Income, security code, and expiry date are important fraud indicators.
2) Random Forest performs better than Logistic Regression on this dataset.
3) Some professions show a higher risk of fraudulent behavior.

 Visual Tools Used

- "ggplot2" for distribution and bar plots.
- "pROC" for ROC/AUC analysis.
- "pheatmap" for correlation matrix.
- "randomForest" for feature importance.


