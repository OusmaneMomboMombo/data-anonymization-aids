# Step 3: Prepare, visualize, and save plots

library(ggplot2)
library(GGally)
library(dplyr)

# 1 Define project paths and load the dataset
data_path <- "C:/Users/ousma/OneDrive/Documents/PGE4/Data_Anonymization/Projet/data-anon-aids/datasets/"
output_path <- "C:/Users/ousma/OneDrive/Documents/PGE4/Data_Anonymization/Projet/data-anon-aids/outputs/"
if(!dir.exists(output_path)) dir.create(output_path, recursive = TRUE)

aids_subset <- read.csv(paste0(data_path, "aids_subset.csv"), stringsAsFactors = FALSE)
View(aids_subset)

# 2 Correct variable types for anonymization
aids_subset <- aids_subset %>%
  mutate(
    gender  = factor(gender),
    race    = factor(race),
    homo    = factor(homo),
    drugs   = factor(drugs),
    treat   = factor(treat),
    symptom = factor(symptom),
    cens    = factor(cens)
  )

# 3 Verify corrected structure
str(aids_subset)
summary(aids_subset)

# Save the corrected version
write.csv(aids_subset,
          paste0(data_path, "aids_subset_corrected.csv"),
          row.names = FALSE)

# 4 Visualizations for continuous variables
p_age_hist <- ggplot(aids_subset, aes(x = age)) +
  geom_histogram(binwidth = 5, fill = "#2C7BB6", color = "black", alpha = 0.7) +
  labs(title = "Distribution of Age", x = "Age (years)", y = "Count")
print(p_age_hist)
ggsave(paste0(output_path, "hist_age.png"), p_age_hist, width = 6, height = 4)

p_karnof_box <- ggplot(aids_subset, aes(y = karnof)) +
  geom_boxplot(fill = "#ABD9E9", color = "black") +
  labs(title = "Boxplot of Karnofsky Score", y = "Karnofsky Performance Score")
print(p_karnof_box)
ggsave(paste0(output_path, "box_karnof.png"), p_karnof_box, width = 5, height = 4)

p_cd4_hist <- ggplot(aids_subset, aes(x = cd40)) +
  geom_histogram(binwidth = 50, fill = "#FDAE61", color = "black", alpha = 0.7) +
  labs(title = "Distribution of CD4 Count at Baseline", x = "CD4 Count", y = "Count")
print(p_cd4_hist)
ggsave(paste0(output_path, "hist_cd4.png"), p_cd4_hist, width = 6, height = 4)

p_days_box <- ggplot(aids_subset, aes(y = days)) +
  geom_boxplot(fill = "#D7191C", color = "black") +
  labs(title = "Boxplot of Follow-up Duration", y = "Days")
print(p_days_box)
ggsave(paste0(output_path, "box_days.png"), p_days_box, width = 5, height = 4)

# 5 Visualizations for categorical variables
p_gender_bar <- ggplot(aids_subset, aes(x = gender, fill = gender)) +
  geom_bar() +
  labs(title = "Gender Distribution", x = "Gender", y = "Count") +
  theme(legend.position = "none")
print(p_gender_bar)
ggsave(paste0(output_path, "bar_gender.png"), p_gender_bar, width = 5, height = 4)

p_homo_bar <- ggplot(aids_subset, aes(x = homo, fill = homo)) +
  geom_bar() +
  labs(title = "Homo Distribution", x = "Homo", y = "Count") +
  theme(legend.position = "none")
print(p_homo_bar)
ggsave(paste0(output_path, "bar_homo.png"), p_homo_bar, width = 5, height = 4)

p_drugs_bar <- ggplot(aids_subset, aes(x = drugs, fill = drugs)) +
  geom_bar() +
  labs(title = "Drugs Distribution", x = "Drugs", y = "Count") +
  theme(legend.position = "none")
print(p_drugs_bar)
ggsave(paste0(output_path, "bar_drugs.png"), p_drugs_bar, width = 5, height = 4)

p_race_bar <- ggplot(aids_subset, aes(x = race, fill = race)) +
  geom_bar() +
  labs(title = "Race Distribution", x = "Race", y = "Count") +
  theme(legend.position = "none")
print(p_race_bar)
ggsave(paste0(output_path, "bar_race.png"), p_race_bar, width = 6, height = 4)

# 6 Correlation matrix for continuous variables
num_data <- aids_subset %>% select(age, karnof, cd40, days)
p_corr <- ggpairs(num_data, title = "Scatterplot Matrix - Continuous Variables")
print(p_corr)
ggsave(paste0(output_path, "corr_matrix.png"), p_corr, width = 7, height = 7)


# 7 Interpretation 

# Continuous variables:
# - "age" is concentrated between 25–50 years with some rare extremes (<20, >65);
#    Suggests global recoding into 10-year age bands.
# - "cd40" shows strong skewness with high outliers.
#    Apply microaggregation or top/bottom coding (5th–95th percentiles).
# - "karnof" is mostly 90–100 (low variance); no heavy anonymization needed.
# - "days" (follow-up) has short and long tails; group or microaggregate.

# Categorical variables:
# - Imbalance in "gender", "homo", "drugs", "race" increases re-identification risk
#   when combined with "age" and others variables for example.
#   → Use local suppression or light PRAM on rare categories.

# Relationships:
# - Weak correlations among continuous variables;
#   anonymization (microaggregation, recoding) will not break key patterns.


# End of Step 3:
# - All variables have correct types (factors or numeric)
# - All plots are displayed in RStudio and saved in 'outputs/'
# - Visual patterns will guide anonymization choices in Step 4.

