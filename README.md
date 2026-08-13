# 🍷 Wine Quality Analysis: Exploratory Data Science & Multivariate Statistics

[![Language](https://img.shields.io/badge/Language-R-blue.svg)](https://www.r-project.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Academic Project](https://img.shields.io/badge/TU%20Dresden-Applied%20Statistics-red.svg)](https://tu-dresden.de/)

An applied multivariate statistical analysis of **6,497 wine samples** (1,599 red and 4,898 white variants) of Portuguese *"Vinho Verde"* wine. The study investigates physicochemical properties (acidity, residual sugar, chlorides, sulfur dioxide, pH, sulfates, alcohol) to uncover latent structural differences between wine types and evaluate feature contributions to sensory quality ratings.

---

## 📌 Key Methodologies

* **Exploratory Data Analysis (EDA) & Normalized Differences**: Quantitative comparison of feature distributions across red and white wines using normalized difference of means:
  $$\text{Normalized Difference} = \frac{\mu_{\text{white}} - \mu_{\text{red}}}{\text{SD}_{\text{pooled}}}$$
* **Principal Component Analysis (PCA)**: Unsupervised dimensionality reduction, Scree Plot variance decomposition (selecting components explaining $>85\%$ variance), correlation circles (PC1 vs PC2 loading system), and observation projections.
* **Factor Analysis (FA)**: Maximum Likelihood factor extraction and Varimax orthogonal rotation to identify underlying latent factors.
* **Canonical Correlation Analysis (CCA)**: Assessing canonical correlation relationships between chemical compositions and physical characteristics.

---

## 📊 Key Visual Insights

### 1. Quality Rating Distribution by Wine Type
![Quality Share by Type](figures/quality_share_by_type.png)

### 2. Quality Scores Distribution Boxplot (Red vs. White)
![Quality Boxplot by Type](figures/quality_boxplot_by_type.png)

---

## 📂 Repository Structure

```text
wine-quality-multivariate-analysis/
├── README.md                      # Project documentation and summary
├── LICENSE                        # MIT License
├── .gitignore                     # Git ignore rules for R sessions
│
├── data/                          # Physicochemical datasets (Cortez et al.)
│   ├── winequality-red.csv        # Red wine samples (n = 1,599)
│   └── winequality-white.csv      # White wine samples (n = 4,898)
│
├── R/                             # R Source Scripts
│   ├── 01_data_overview.R         # Data loading, EDA, pooled SD normalization & ggplot2
│   └── 02_multivariate_pca_fa_cca.R # PCA, Factor Analysis & Canonical Correlation Analysis
│
└── figures/                       # Rendered statistical plots & figures
    ├── quality_share_by_type.png
    ├── quality_boxplot_by_type.png
    ├── pca_selection_plots.pdf
    └── pca_vars_PC1vsPC2.pdf
```

---

## 🛠️ How to Run

### Prerequisites
Make sure R and the required R packages are installed:
```R
install.packages(c("ggplot2", "scales"))
```

### Execution
Run the scripts sequentially in R or RStudio:
```bash
# 1. Exploratory Data Analysis & Normalization
Rscript R/01_data_overview.R

# 2. Multivariate Statistics (PCA, FA, CCA)
Rscript R/02_multivariate_pca_fa_cca.R
```

---

## 👤 Author & Acknowledgments

* **Author:** Daria Baranchikova
* **Institution:** Technische Universität Dresden (TU Dresden)
* **Course:** Applied Multivariate Statistics
* **Dataset Source:** UCI Machine Learning Repository / Cortez et al. (2009)
