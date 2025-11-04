# Step 5: Explain — Understanding Risk and Utility Measures


# 1 Risk Measures
# -----------------
# - Global Risk:
#    Represents the average probability that an individual can be re-identified
#     from the quasi-identifiers (e.g., age, gender, race, homo, drugs).
#    It is derived from the frequency of each unique key combination in the dataset.
#    Example: Global risk = 0.0285 means that each record has, on average,
#     a 2.85% chance of being re-identified.
#
# - Expected Re-ID:
#    The estimated number of individuals who could be re-identified in the dataset.
#    Computed as: Expected Re-ID = Global Risk × Number of Records.
#    In our case: 0.0285 × 2139 ≈ 61.
#
# - For non-perturbative methods (like suppression or recoding),
#   these metrics are valid because the frequency structure is preserved.
#   For perturbative methods (like noise addition or PRAM), 
#   these values are not calculated (NA), since the data values have changed.

# 2 Utility / Information Loss Measures
# ---------------------------------------
# - IL1 (Information Loss Index):
#    Measures how much the numerical values have changed after anonymization.
#    Lower IL1 = better data utility.
#    Example: IL1 = 0 means no numeric change; large IL1 means heavy distortion.
#
# - Eigenvalue Difference (Eigen_Diff):
#    Evaluates how much the internal structure of the dataset (covariances, correlations)
#     was altered after anonymization.
#    Smaller differences (≈ 0) indicate that statistical relationships are preserved.

# 3 Trade-off: Privacy vs. Utility
# ----------------------------------
# - Increasing anonymity (higher k, more grouping, stronger noise) → lowers re-identification risk,
#   but may increase information loss and reduce analytic quality.
#
# - Example from results:
#   - Local Suppression (k=10): lowest risk (≈1.2%), perfect data utility (IL1=0).
#   - Microaggregation: strong protection, but IL1 very high → large loss of accuracy.
#   - Additive Noise: moderate protection, small IL1 → excellent compromise.
#
# - In practice, the goal is to find the balance point where:
#       Privacy risk < 0.02   AND   Information loss remains acceptable.
#
# In our analysis:
#   - The best balance is obtained with:
#       Global Recoding (2 bands) + Local Suppression (k=5)
#       + optional 5% Additive Noise for sensitive continuous variables.
#   - This combination ensures strong privacy while preserving data usability.
