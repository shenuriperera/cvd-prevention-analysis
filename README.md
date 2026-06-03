#  CVD Prevention Program — Community Health Analysis

Statistical evaluation of an 18-month community-based cardiovascular disease prevention program conducted across three districts in Sri Lanka, using non-parametric hypothesis testing and descriptive analysis in R.

---

## 📌 Project Overview

This case study evaluates the impact of a Ministry of Health CVD prevention program launched across **Colombo, Kandy, and Galle** districts. The program included health education, regular screenings, lifestyle counselling, and group exercise sessions. Pre- and post-program data from **1,500 participants** were analyzed to measure improvements in cardiovascular risk factors.

---

## 🎯 Objectives

- Assess changes in systolic blood pressure, BMI, and smoking status before and after the program
- Measure the effect of the program on exercise frequency
- Estimate the incidence of CVD events during follow-up
- Compare health improvements across districts, age groups, and gender
- Investigate associations between baseline risk factors and CVD events

---

## 📊 Dataset

| Variable | Description |
|----------|-------------|
| `Age` | Participant age (25–80 years) |
| `Gender` | Male / Female |
| `District` | Colombo, Kandy, or Galle |
| `Education` | Primary, Secondary, or Higher |
| `Pre/Post_Systolic_BP` | Systolic blood pressure before and after program |
| `Pre/Post_BMI` | BMI before and after program |
| `Smoking` | Pre-program smoking status |
| `Post_Smoking_Status` | Post-program smoking status |
| `Pre/Post_Exercise_Days` | Exercise days per week before and after |
| `Diabetes` | Diabetes status (Yes/No) |
| `Participated` | Program participation status |
| `Sessions_Attended` | Number of sessions attended |
| `CVD_Event` | CVD event during follow-up (Yes/No) |
| `CVD_Prob` | Estimated probability of CVD event |

---

## 🔬 Methods

| Method | Purpose |
|--------|---------|
| **Shapiro-Wilk Test** | Normality testing for all continuous variables |
| **Wilcoxon Signed-Rank Test** | Pre vs post program comparisons (BP, BMI, Exercise) |
| **Kruskal-Wallis Test** | Comparing improvements across districts and age groups |
| **Wilcoxon Rank-Sum Test** | Comparing improvements across gender |
| **Chi-Square Test** | Association between categorical variables and CVD events |

---

## 📈 Key Findings

| Outcome | Finding |
|---------|---------|
| **Systolic BP** | Significantly reduced post-program (p < 2.2e-16) |
| **BMI** | Significantly decreased post-program (p < 2.2e-16) |
| **Exercise Days** | Significantly increased post-program (p < 2.2e-16) |
| **District Differences** | Significant variation in BP, BMI, and exercise improvements across districts |
| **Age Groups** | No significant difference in improvements across age groups |
| **Gender** | No significant difference in improvements across gender |
| **Smoking & CVD** | Post-smoking status significantly associated with CVD events (p = 0.00048) |
| **Diabetes & CVD** | No significant association found (p = 0.07089) |
| **Participation & CVD** | No significant association found (p = 0.2687) |

---

## 💡 Conclusions

- The program successfully reduced key cardiovascular risk factors across all three districts
- District-level variation suggests local factors influence program effectiveness
- Smoking cessation showed the strongest link to reduced CVD events
- Age and gender did not significantly affect the degree of improvement
- Expanding similar programs to more districts could reduce Sri Lanka's growing CVD burden

---

## 🛠️ Technologies Used

![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)
![Excel](https://img.shields.io/badge/Excel-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white)

**Libraries:** `truncnorm`, `descriptr`

---

## 📁 Repository Structure

```
cvd-prevention-analysis/
├── casestudy.R         # Full R analysis script
├── CVD_Dataset.xlsx    # Dataset
└── README.md           # Project documentation
```

---

*ST 3010 | Case Study | H.S.S Perera — S16661*
