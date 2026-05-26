# Global Maritime Trade Analysis

## Overview

This project explores global maritime trade trends using R and tidyverse.

The analysis focuses on:
- Dry cargo transportation
- Crude oil trade flows
- Net trade balances
- Developed vs developing economies
- Regional maritime growth trends

The project applies exploratory data analysis (EDA) techniques
to identify trade patterns, cargo transportation dynamics,
and long-term maritime growth behavior across different economic regions.


---

## Dataset

Dataset source:

https://www.kaggle.com/datasets/illiaparfeniuk/maritime-trading-volumes

The dataset contains aggregated regional maritime trade statistics,
including:
- Dry cargo operations
- Crude oil transportation
- Tanker trade activity
- Total loaded and discharged goods

The analysis primarily focuses on the 2010–2020 period
due to missing observations in several categories before 2010.


---

## Objectives

The main objectives of this project are:

- Analyze global maritime trade evolution
- Compare developed and developing economies
- Evaluate dry cargo transportation growth
- Explore crude oil maritime flows
- Calculate regional net trade balances
- Visualize long-term maritime transportation trends


---

## Tools & Libraries

This project was developed using:

- R
- tidyverse
- dplyr
- tidyr
- ggplot2
- scales


---

## Data Cleaning & Transformation

The dataset required several preprocessing steps, including:

- Converting the first row into column names
- Renaming variables
- Converting yearly observations into numeric format
- Reshaping the dataset from wide to long format
- Removing missing values
- Calculating growth rates and net trade balances


---

## Key Insights

### Developing economies dominate maritime trade growth

Developing economies demonstrate substantially higher
maritime trade volumes across nearly all cargo categories,
particularly in dry cargo transportation.

### Dry cargo transportation experienced strong expansion

Dry cargo operations showed the highest growth rates
during the analyzed period,
reflecting industrialization and export expansion.

### Developed economies display more stable trade patterns

Developed regions exhibit slower but more stable growth trends,
consistent with mature trade systems
and established logistics infrastructure.

### Maritime trade increasingly shifted toward developing regions

The analysis suggests a gradual shift of global maritime
trade activity toward developing economies,
particularly in rapidly industrializing regions.


---

## Visualizations

The project includes multiple visualizations, including:

- Maritime trade trends over time
- Dry cargo loading and discharging analysis
- Net trade balance comparisons
- Crude oil transportation analysis
- Developed vs developing economy comparisons

### Developed vs Developing Maritime Trade

![Developed vs Developing Trade](plots/Developed_vs_Developing_Mairime_Trade.png)

### Net Dry Cargo Trade

![Net Trade](plots/net_trade.png)
---

## Data Limitations

- The dataset contains aggregated regional statistics
  rather than country-level observations.

- Several regions contain incomplete observations
  before 2010.

- Certain maritime categories include missing values,
  particularly in earlier years.


---

## Repository Structure

```text
maritime_data_analysis/

├── data/
├── plots/
├── scripts/
│   └── maritime_trade_analysis.R
├── README.md
├── LICENSE
└── .gitignore
