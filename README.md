# 🧩 Data Anonymization Project — Statistical Disclosure Control (SDC) in R

[![R 4.3](https://img.shields.io/badge/R-4.3.1-blue.svg)](https://cran.r-project.org/)
[![sdcMicro](https://img.shields.io/badge/Package-sdcMicro-green.svg)](https://cran.r-project.org/package=sdcMicro)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Made with RStudio](https://img.shields.io/badge/Made%20with-RStudio-75AADB.svg)](https://posit.co/download/rstudio/)

This repository presents a **complete anonymization workflow** developed in **R**, applying *Statistical Disclosure Control (SDC)* methods on an AIDS dataset.  
The project demonstrates how to **reduce re-identification risk** while preserving the **analytical utility** of sensitive medical data.

---

## 🏫 Academic Context

This project was completed as part of the **Data Anonymization** course at  
🎓 *Aivancity School of AI, Data for Business & Society* (Master PGE4),  
under the supervision of **Professor Amin EHSAN**.  

It was carried out collaboratively by:

| Name | LinkedIn |
|------|-----------|
| **Ousmane MOMBO MOMBO** | [LinkedIn](https://www.linkedin.com/in/ousmanemombomombo/) |
| **Hergi DIANGUE** | [LinkedIn](https://www.linkedin.com/in/hergi-diangue-38b2a1252/) |
| **Cassandra NONGO** | [LinkedIn](https://www.linkedin.com/in/cassandra-nongo-9790a5269/) |
| **Bally-Stone Papin MOUDIANGO** | [LinkedIn](https://www.linkedin.com/in/bally-stone-papin/) |

---

## 🧠 Project Overview

The goal of this project is to apply **anonymization techniques** on a sensitive medical dataset to protect individual privacy while maintaining data quality for research use.

We use the **AIDS dataset**, which contains demographic, behavioral, and medical information on patients.  
This dataset represents a realistic case for data privacy concerns in **digital health** and **biostatistics**.

The project follows the full anonymization workflow:
1. Data exploration and variable selection  
2. Risk identification and visualization  
3. Application of multiple anonymization techniques  
4. Evaluation of disclosure risk and information loss  
5. Interpretation and ethical discussion

---

## 📂 Repository Structure

data-anon-aids/
│
├── datasets/
│   ├── aids_original_data.csv         # Raw dataset
│   ├── aids_subset.csv                # Selected subset for analysis
│   └── aids_subset_corrected.csv      # Cleaned and typed version
│
├── scripts/
│   ├── 01_explore_select.R            # Exploration & variable selection
│   ├── 02_visualize.R                 # Exploratory visualizations
│   ├── 03_anonymize_methods.R         # SDC anonymization methods
│   ├── 04_utility_measures.R          # Risk & information loss evaluation
│   └── 05_extra_credit.R              # Real-world data use case
│
├── outputs/
│   ├── step4_risk_utility_results.csv # Summary of all anonymization tests
│   ├── step4_risk_nonperturbative.png # Risk comparison graph
│   ├── step4_il1_all_methods.png      # Information loss graph
│   ├── step4_eigen_all_methods.png    # Structure preservation graph
│   └── bar_*, box_*, hist_*.png       # Exploratory visualizations
│
├── report/
│   └── Rapport_Anonymisation_AIDS.pdf # Final project report
│
├── .gitignore
├── LICENSE
└── README.md

---

## 🔬 Key Features

- **Variable selection & risk assessment**
  - Identification of quasi-identifiers and sensitive variables
  - Exploration of frequency patterns and risk of uniqueness

- **Non-perturbative anonymization**
  - *k-Anonymity (Local Suppression)*
  - *Global Recoding* (age band grouping)

- **Perturbative anonymization**
  - *Microaggregation* (group-based averaging)
  - *Additive Noise* (controlled numeric perturbation)
  - *PRAM* (Post-Randomization of categorical values)

- **Evaluation metrics**
  - *Global Risk* and *Expected Re-Identification*
  - *IL1* (Information Loss Index)
  - *Eigenvalue Difference* (structure preservation)

- **Visualization & Interpretation**
  - Comparative plots to visualize risk vs. utility trade-offs

---

## ⚙️ Installation & Setup

### Prerequisites
- **R version ≥ 4.0**
- Recommended IDE: [RStudio](https://posit.co/download/rstudio/)
- Required R packages:
install.packages(c("sdcMicro", "dplyr", "ggplot2", "GGally", "openxlsx"))

### Clone the repository
git clone https://github.com/OusmaneMomboMombo/data-anon-aids.git
cd data-anon-aids

---

## 🚀 Usage

### 1. Run exploration and selection
source("scripts/01_explore_select.R")

### 2. Generate exploratory visualizations
source("scripts/02_visualize.R")

### 3. Apply anonymization techniques
source("scripts/03_anonymize_methods.R")

### 4. Compute risk and utility measures
source("scripts/04_utility_measures.R")

### 5. Extra credit use case
source("scripts/05_extra_credit.R")

---

## 📊 Results Summary

| Method | Parameter | Global Risk ↓ | IL1 ↓ | Structure Preservation ↑ | Comment |
|---------|------------|---------------|-------|---------------------------|----------|
| Local Suppression | k=5 | 0.017 | 0 | Excellent balance |
| Global Recoding | 2 bands | 0.012 | 0 | Strong anonymization |
| Microaggregation | group=5 | NA | 157k | High distortion |
| Additive Noise | noise=0.05 | NA | 75.5 | Best trade-off |
| PRAM | pd=0.05 | NA | 0 | Minimal distortion |

The **baseline risk** of 2.85% (≈61 identifiable individuals) dropped below 1.2% after anonymization, while maintaining excellent analytical quality.

---

## 💡 Data Use Case: Medical Treatment Analysis

After anonymization, the dataset remains statistically valid for research.  
A realistic application is **analyzing treatment effectiveness** based on patient characteristics:

> “How do factors like age, drug use, and baseline CD4 count influence treatment success and survival duration?”

---

## 👥 Team Contributions

| Member | Role |
|---------|------|
| **Ousmane MOMBO MOMBO** | Risk analysis, data preparation, interpretation |
| **Hergi DIANGUE** | Project setup, code architecture, scripts integration, report writing |
| **Cassandra NONGO** | Visualization, presentation, and result interpretation |
| **Bally-Stone Papin MOUDIANGO** | Documentation, testing, and final report compilation |

---

## 📬 Contact

📧 **Ousmane MOMBO MOMBO**  
[LinkedIn](https://www.linkedin.com/in/ousmanemombomombo/) • [GitHub](https://github.com/OusmaneMomboMombo)

---

> “Data anonymization is not about hiding information,  
> but about preserving trust while enabling knowledge.”  
> — *Aivancity Data Privacy Team, 2025*
