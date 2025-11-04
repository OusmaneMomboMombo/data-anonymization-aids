# 🧩 Data Anonymization Project — Statistical Disclosure Control (SDC) in R

[![R 4.3](https://img.shields.io/badge/R-4.3.1-blue.svg)](https://cran.r-project.org/)
[![sdcMicro](https://img.shields.io/badge/Package-sdcMicro-green.svg)](https://cran.r-project.org/package=sdcMicro)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Made with RStudio](https://img.shields.io/badge/Made%20with-RStudio-75AADB.svg)](https://posit.co/download/rstudio/)

This repository presents a **complete anonymization workflow** developed in **R**, applying *Statistical Disclosure Control (SDC)* methods on an AIDS dataset. The project demonstrates how to **reduce re-identification risk** while preserving the **analytical utility** of sensitive medical data.

---

## 🏫 Academic Context

This project was completed as part of the **Data Anonymization** course at 🎓 *Aivancity School of AI, Data for Business & Society* (Master PGE4), under the supervision of **Professor Amin EHSAN**. 

It was carried out collaboratively by:
- **Ousmane MOMBO MOMBO** (https://www.linkedin.com/in/ousmanemombomombo/)
- **Hergi DIANGUE** (https://www.linkedin.com/in/hergi-diangue-38b2a1252/)
- **Cassandra NONGO** (https://www.linkedin.com/in/cassandra-nongo-9790a5269/)
- **Bally-Stone Papin MOUDIANGO** (https://www.linkedin.com/in/bally-stone-papin/)

---

## 🧠 Project Overview

The goal of this project is to apply anonymization techniques on a sensitive medical dataset to protect individual privacy while maintaining data quality for research use.

We use the **AIDS dataset**, which contains demographic, behavioral, and medical information on patients. This dataset represents a realistic case for data privacy concerns in **digital health** and **biostatistics**.

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
│   ├── aids_original_data.csv
│   ├── aids_subset.csv
│   └── aids_subset_corrected.csv
│
├── scripts/
│   ├── 01_explore_select.R
│   ├── 02_visualize.R
│   ├── 03_anonymize_methods.R
│   ├── 04_utility_measures.R
│   └── 05_extra_credit.R
│
├── outputs/
│   ├── step4_risk_utility_results.csv
│   ├── step4_risk_nonperturbative.png
│   ├── step4_il1_all_methods.png
│   ├── step4_eigen_all_methods.png
│   └── bar_*, box_*, hist_*.png
│
├── report/
│   └── Rapport_Anonymisation_AIDS.pdf
│
└── README_Data_Anonymization_Project.txt

---

## 📊 Results Summary

| Method | Parameter | Global Risk ↓ | IL1 ↓ | Structure Preservation ↑ | Comment |
|---------|------------|---------------|-------|---------------------------|----------|
| Local Suppression | k=5 | 0.017 | 0 | Excellent balance |
| Global Recoding | 2 bands | 0.012 | 0 | Strong anonymization |
| Microaggregation | group=5 | NA | 157k | High distortion |
| Additive Noise | noise=0.05 | NA | 75.5 | Best trade-off |
| PRAM | pd=0.05 | NA | 0 | Minimal distortion |

The baseline risk of 2.85% (≈61 identifiable individuals) dropped below 1.2% after anonymization, while maintaining excellent analytical quality.

---

## 💡 Data Use Case

After anonymization, the dataset remains valid for research — for example, studying treatment effectiveness based on patient characteristics (age, drug use, CD4 count, etc.).

---

## 👥 Team Contributions

| Member | Role |
|---------|------|
| Ousmane MOMBO MOMBO | Risk analysis, data prep, interpretation |
| Hergi DIANGUE | Project setup, code architecture, report writing |
| Cassandra NONGO | Visualization, presentation |
| Bally-Stone Papin MOUDIANGO | Documentation, report integration |

---

## 📬 Contact

📧 **Ousmane MOMBO MOMBO**  
LinkedIn: https://www.linkedin.com/in/ousmanemombomombo/  
GitHub: https://github.com/OusmaneMomboMombo

---

> “Data anonymization is not about hiding information, but about preserving trust while enabling knowledge.”  
> — *Aivancity Data Privacy Team, 2025*"
