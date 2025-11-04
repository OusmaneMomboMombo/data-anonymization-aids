# Step 2: Explore and select variables


# Load required packages
library(dplyr)


# 1 Define file paths (adapted to your project structure)

# Define the paths for data input and output folders.
data_path <- "C:/Users/ousma/OneDrive/Documents/PGE4/Data_Anonymization/Projet/data-anon-aids/datasets/"
output_path <- "C:/Users/ousma/OneDrive/Documents/PGE4/Data_Anonymization/Projet/data-anon-aids/outputs/"

# 2 Load the dataset (semicolon-separated)

# The original dataset is semicolon-separated.
# Using sep = ";" ensures correct column parsing.
aids_data <- read.csv(paste0(data_path, "aids_original_data.csv"),
                      sep = ";", stringsAsFactors = TRUE)

# Visualize the dataset in RStudio viewer 
View(aids_data)


# 3 Explore the dataset structure

# Check dimensions (rows × columns)
dim(aids_data)

# Display variable names
names(aids_data)

# Examine the structure: data types, factors, numeric variables
str(aids_data)

# Show the first few rows
head(aids_data)

# Generate a summary for all variables
summary(aids_data)

# 4 Identify numeric and categorical variables

# This step helps to know which variables are continuous (potentially sensitive)
# and which are categorical (potential quasi-identifiers).
num_vars <- names(aids_data)[sapply(aids_data, is.numeric)]
cat_vars <- names(aids_data)[sapply(aids_data, is.factor)]

cat("Numeric variables:\n"); print(num_vars)
cat("Categorical variables:\n"); print(cat_vars)

# 5 Select a relevant subset for anonymization

# Justification of variable selection:
# - age, gender, race, homo, drugs → quasi-identifiers
#   (can indirectly identify individuals when combined)
# - karnof, cd40 → continuous sensitive medical variables
#   (reflect health status)
# - treat, symptom, cens, days → treatment/outcome-related variables
# - pidnum → direct identifier (will be removed during anonymization)
aids_subset <- aids_data %>%
  select(pidnum, age, gender, race, homo, drugs,
         karnof, cd40, treat, symptom, cens, days)

# 6 Save the new subset for next steps

# Export the selected dataset to the "datasets" folder
write.csv(aids_subset,
          paste0(data_path, "aids_subset.csv"),
          row.names = FALSE)

# Preview the new subset
head(aids_subset)

# End of Step 2

# The subset now includes:
# - categorical quasi-identifiers
# - continuous sensitive medical variables
# - treatment/outcome indicators
# This subset will be used to create the SDC object in Step 3.

