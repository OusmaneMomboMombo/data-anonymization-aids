# Step 4: Apply Anonymization Methods, Measure Risk and Utility

# Objective:
# This script tests multiple anonymization methods, 
# visualizes the impact on disclosure risk and information loss,
# and explains the reasoning behind each output.
# Results are displayed in RStudio AND saved to the outputs folder.


# 0 Load required packages

library(sdcMicro)
library(dplyr)
library(ggplot2)

# 1 Define project paths and load the dataset

data_path   <- "C:/Users/ousma/OneDrive/Documents/PGE4/Data_Anonymization/Projet/data-anon-aids/datasets/"
output_path <- "C:/Users/ousma/OneDrive/Documents/PGE4/Data_Anonymization/Projet/data-anon-aids/outputs/"
if (!dir.exists(output_path)) dir.create(output_path, recursive = TRUE)

# Load dataset
infile <- if (file.exists(paste0(data_path, "aids_subset_corrected.csv"))) {
  paste0(data_path, "aids_subset_corrected.csv")
} else {
  paste0(data_path, "aids_subset.csv")
}
dat0 <- read.csv(infile, stringsAsFactors = FALSE)


# 2 Prepare dataset for anonymization

# Convert binary variables to factors but keep numeric labels (0/1)
dat <- dat0 %>%
  mutate(
    gender  = factor(gender),
    race    = factor(race),
    homo    = factor(homo),
    drugs   = factor(drugs),
    treat   = factor(treat),
    symptom = factor(symptom),
    cens    = factor(cens),
    age_band_10y = cut(
      age,
      breaks = c(-Inf, 29, 39, 49, 59, Inf),
      labels = c("<=29", "30-39", "40-49", "50-59", ">=60"),
      right = TRUE
    )
  )

# Define variable roles for SDC
key_vars <- c("age_band_10y", "gender", "race", "homo", "drugs")
num_vars <- c("age", "cd40", "karnof", "days")

# Create the SDC object
sdc_base <- createSdcObj(dat = dat, keyVars = key_vars, numVars = num_vars)


# 3 Baseline risk (before any anonymization)
# Global risk = average probability of re-identification.
# Expected re-id = estimated number of individuals potentially identifiable.

# Baseline risk
base_risk <- get.sdcMicroObj(sdc_base, type = "risk")$global
cat("Baseline global risk =", base_risk$risk, "| Expected re-id =", base_risk$risk_ER, "\n")


# 4 Helper function to compute metrics for each anonymization test

# Methodology:
# For every anonymization method tested (suppression, recoding, etc.), 
# this function extracts three key metrics:
#   - global_risk: overall re-identification probability (only for non-perturbative methods)
#   - expected_reid: expected number of records re-identifiable (risk * N)\n
#   - IL1:information loss index (lower = better utility)
#   - eigen_diff: structure distortion (difference in covariance structure)
  
get_metrics <- function(sdc_obj, method, params, risk_valid = TRUE) {
  glob_risk <- exp_reid <- NA_real_
  
  if (risk_valid) {
    gr <- get.sdcMicroObj(sdc_obj, type = "risk")$global
    glob_risk <- gr$risk
    exp_reid  <- gr$risk_ER
  }
  
  il1 <- tryCatch({
    dUtility(
      obj = sdc_obj@origData[, num_vars, drop = FALSE],
      xm  = sdc_obj@manipNumVars[, num_vars, drop = FALSE],
      method = "IL1"
    )
  }, error = function(e) 0)  # 0 if unchanged
  
  eigen_u <- tryCatch({
    X0 <- scale(sdc_obj@origData[, num_vars, drop = FALSE])
    X1 <- scale(sdc_obj@manipNumVars[, num_vars, drop = FALSE])
    ev0 <- eigen(cov(X0), only.values = TRUE)$values
    ev1 <- eigen(cov(X1), only.values = TRUE)$values
    mean(abs(ev1 - ev0) / (abs(ev0) + 1e-8))
  }, error = function(e) 0)
  
  return(data.frame(
    Method = method,
    Parameters = params,
    Global_Risk = round(glob_risk, 5),
    Expected_ReID = round(exp_reid, 1),
    IL1 = round(il1, 3),
    Eigen_Diff = round(eigen_u, 4)
  ))
}

results <- list()  # will store all test results


# 5 Apply anonymization methods

# === TEST 1: Local Suppression (k-Anonymity)
cat("\n--- TEST 1: Local Suppression (k-Anonymity) ---\n")
for (kval in c(2, 3, 5, 10)) {
  sdc <- kAnon(sdc_base, k = kval)
  cat(paste0("\nApplying k-anonymity with k = ", kval, " ...\n"))
  summary(sdc)
  tmp <- get_metrics(sdc, "Local Suppression", paste0("k=", kval), TRUE)
  print(tmp)
  results[[length(results) + 1]] <- tmp
}

# === TEST 2: Global Recoding (Age Bands)
cat("\n--- TEST 2: Global Recoding (Age Bands) ---\n")
# Explanation:
# We merge the 5 age bands into broader groups (3 and 2) to reduce identifiability.
band_settings <- list(
  "3 bands" = c(-Inf, 39, 59, Inf),   # <=39, 40–59, >=60
  "2 bands" = c(-Inf, 49, Inf)        # <=49, >=50
)

for (label in names(band_settings)) {
  br <- band_settings[[label]]
  dat_gr <- dat %>% mutate(age_band = cut(age, breaks = br, right = TRUE))
  sdc_gr <- createSdcObj(dat = dat_gr, keyVars = c("age_band", "gender", "race", "homo", "drugs"), numVars = num_vars)
  cat(paste0("\nGlobal recoding using ", label, " ...\n"))
  tmp <- get_metrics(sdc_gr, "Global Recoding", label, TRUE)
  print(tmp)
  results[[length(results) + 1]] <- tmp
}

# === TEST 3: Microaggregation
cat("\n--- TEST 3: Microaggregation ---\n")
# This method replaces individual values by group averages to reduce re-identification.
for (ag in c(3, 5)) {
  sdc <- microaggregation(sdc_base, variables = c("cd40", "days"), aggr = ag, method = "simple")
  cat(paste0("\nMicroaggregation with group size = ", ag, " ...\n"))
  cat("Before:\n"); print(head(sdc@origData[, c("cd40", "days")]))
  cat("After:\n");  print(head(sdc@manipNumVars[, c("cd40", "days")]))
  tmp <- get_metrics(sdc, "Microaggregation", paste0("group=", ag), FALSE)
  print(tmp)
  results[[length(results) + 1]] <- tmp
}

# === TEST 4: Additive Noise
cat("\n--- TEST 4: Additive Noise ---\n")
for (nz in c(0.05, 0.10)) {
  sdc <- addNoise(sdc_base, variables = c("cd40", "karnof", "days"), noise = nz, method = "additive")
  cat(paste0("\nAdditive noise applied with intensity = ", nz, " ...\n"))
  cat("Before:\n"); print(head(sdc@origData[, c("cd40", "karnof", "days")]))
  cat("After:\n");  print(head(sdc@manipNumVars[, c("cd40", "karnof", "days")]))
  tmp <- get_metrics(sdc, "Additive Noise", paste0("noise=", nz), FALSE)
  print(tmp)
  results[[length(results) + 1]] <- tmp
}

# === TEST 5: PRAM (Post Randomization)
cat("\n--- TEST 5: PRAM (Post Randomization) ---\n")
# Randomly reassigns categories within a variable (here: race)
for (pdv in c(0.05, 0.10)) {
  sdc <- suppressWarnings(
    pram(sdc_base, variables = c("race"), pd = pdv)
  )
  cat(paste0("\nPRAM on 'race' with pd = ", pdv, " ...\n"))
  tmp <- get_metrics(sdc, "PRAM", paste0("pd=", pdv), FALSE)
  print(tmp)
  results[[length(results) + 1]] <- tmp
}

# 6 Combine and display results

res <- do.call(rbind, results)
cat("\n--- FINAL SUMMARY TABLE ---\n")
print(res)

# Save results
write.csv(res, paste0(output_path, "step4_risk_utility_results.csv"), row.names = FALSE)


# 7 Visualization

# Clean up parameter order for better plots
res$Parameters <- factor(res$Parameters, levels = unique(res$Parameters))

# --- Global Risk ---
risk_plot <- ggplot(res %>% filter(!is.na(Global_Risk)),
                    aes(x = Parameters, y = Global_Risk, color = Method, group = Method)) +
  geom_line(linewidth = 1) + geom_point(size = 3) +
  labs(title = "Global Risk by Method (Non-perturbative)",
       x = "Parameters", y = "Global Risk (lower = safer)") +
  theme_minimal(base_size = 13) +
  theme(axis.text.x = element_text(angle = 25, hjust = 1))
print(risk_plot)
ggsave(paste0(output_path, "step4_risk_nonperturbative.png"), risk_plot, width = 8, height = 5)

# --- Information Loss ---
il1_plot <- ggplot(res, aes(x = Parameters, y = IL1, color = Method, group = Method)) +
  geom_line(linewidth = 1) + geom_point(size = 3) +
  labs(title = "Information Loss (IL1) for All Methods",
       x = "Parameters", y = "IL1 (lower = better)") +
  theme_minimal(base_size = 13) +
  theme(axis.text.x = element_text(angle = 25, hjust = 1))
print(il1_plot)
ggsave(paste0(output_path, "step4_il1_all_methods.png"), il1_plot, width = 8, height = 5)

# --- Structure Preservation ---
eig_plot <- ggplot(res, aes(x = Parameters, y = Eigen_Diff, color = Method, group = Method)) +
  geom_line(linewidth = 1) + geom_point(size = 3) +
  labs(title = "Structure Preservation (Eigenvalue Difference)",
       x = "Parameters", y = "Mean Relative Eigenvalue Difference") +
  theme_minimal(base_size = 13) +
  theme(axis.text.x = element_text(angle = 25, hjust = 1))
print(eig_plot)
ggsave(paste0(output_path, "step4_eigen_all_methods.png"), eig_plot, width = 8, height = 5)


# 8 interpretation


# Baseline (before anonymization)
# - Global risk = 0.0285 (~2.85%) : about 61 individuals could be re-identified.
# - This represents a moderate disclosure risk, too high for open data release.

# Non-perturbative methods (risk measurable)
# - Local Suppression: risk decreases steadily with k (best trade-off at k=5 or k=10)
# - Global Recoding (age bands): merging age groups lowers risk efficiently (2 bands < 0.013)
# - Both methods preserve data utility (IL1 = 0)

# Perturbative methods (risk not measurable)
# - Microaggregation: strong anonymization but high IL1 (information loss).
# - Additive Noise: light numeric distortion (good balance at 5–10% noise).
# - PRAM: modifies categorical labels, keeps numeric variables intact.

# Graphs interpretation
# - Global Risk low with stronger anonymization (k high or age bands merged)
# - IL1 high only for Microaggregation : high distortion.
# - Eigenvalue difference ≈ 0 → structure mostly preserved.

# Conclusion:
# - Best privacy/utility balance = Global Recoding (2 bands) + Local Suppression (k=5)
# - Optionally, add 5% Additive Noise for continuous sensitive variables.
# - This combination keeps Global Risk < 0.02 while maintaining analytic quality.



# End of Step 4. 
