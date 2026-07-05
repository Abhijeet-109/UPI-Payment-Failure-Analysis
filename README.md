# UPI Payment Failure Analysis

![Python](https://img.shields.io/badge/Python-3.x-blue?logo=python)
![MySQL](https://img.shields.io/badge/MySQL-8.0-orange?logo=mysql)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow?logo=powerbi)
![pandas](https://img.shields.io/badge/pandas-2.2.2-150458?logo=pandas)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)

An end-to-end Data Analysis project investigating why UPI payments fail — across banks, time windows, states, merchant categories, and transaction types — using 2,70,000 real transaction records, 12 SQL scripts, 10 Python EDA plots, and a 6-page interactive Power BI dashboard benchmarked against official NPCI data.

---

## Business Problem

UPI processes over 18 billion transactions monthly in India. Even a 6% failure rate translates to hundreds of crores in lost transaction value and significant user trust erosion. This project answers three core questions:

1. Which banks have the highest failure rates — and is it time-specific or consistent?
2. What time windows and transaction amount ranges correlate with elevated failures?
3. Is failure driven by bank infrastructure, geography, transaction type, or user behaviour?

---

## Tech Stack

| Layer | Tool |
|---|---|
| Language | Python 3.x |
| Libraries | pandas 2.2.2 · numpy · matplotlib · seaborn 0.13.2 |
| Database | MySQL 8.0 |
| Visualization | Power BI Desktop |
| Data Sources | Kaggle · NPCI Official · Data.Gov.in |
| Version Control | Git + GitHub |
| IDE | VS Code · Jupyter Notebook |

---

## Dataset Overview

| File | Source | Rows | Role |
|---|---|---|---|
| upi_transactions_2024.csv | Kaggle (DF1) | 2,50,000 | Primary dataset |
| UPI_transactions.xlsx | Kaggle (DF2) | 20,000 | Secondary dataset |
| merged_upi_transactions.csv | Python merge | 2,70,000 | MySQL source |
| NPCI-Product-Stats-Master_workbook.xlsx | NPCI Official | Aggregated | FY-wise monthly benchmark |
| NPCI-Ecosystem-Stats-Master_workbook.xlsx | NPCI Official | Aggregated | Bank · State · P2P benchmark |

### Schema — merged_upi_transactions.csv (17 columns)

| Column | Type | Source |
|---|---|---|
| transaction_id | VARCHAR(50) | Both |
| timestamp | DATETIME | Both |
| transaction_type | VARCHAR(50) | Both |
| merchant_category | VARCHAR(100) | DF1 only |
| amount | DECIMAL(12,2) | Both |
| status | VARCHAR(20) | Both |
| sender_age_group | VARCHAR(20) | DF1 only |
| receiver_age_group | VARCHAR(20) | DF1 only |
| sender_state | VARCHAR(50) | DF1 only |
| sender_bank | VARCHAR(100) | Both |
| receiver_bank | VARCHAR(100) | Both |
| device_type | VARCHAR(50) | Both |
| payment_mode | VARCHAR(50) | Both |
| city | VARCHAR(50) | DF2 only |
| gender | VARCHAR(20) | DF2 only |
| purpose | VARCHAR(100) | DF2 only |
| source_file | VARCHAR(20) | Derived |

**NULL pattern:** DF1-only columns carry 20K NULLs (DF2 rows). DF2-only columns carry 2,50,000 NULLs (DF1 rows). Core analytical columns — transaction_id, timestamp, amount, status, sender_bank, receiver_bank — have zero NULLs.

---

## Key Findings

### Executive KPIs
- **2,70,000 transactions · ₹34.78 Cr total value · 6.07% overall failure rate · ₹2.08 Cr lost to failures**
- Average transaction value: ₹1,288

### Bank Analysis
- **Axis Bank is the systemic outlier** — worst sender failure rate (7.45%) and worst receiver failure rate (7.60%)
- Axis → Axis same-bank transfers fail at **15.13%** — 2.5× the dataset average
- HDFC → ICICI: 12.84% · ICICI → SBI: 11.04%
- **PNB leads reliability** at 95.11% success rate
- Banks dominate the cross-dimensional failure leaderboard — no geography, transaction type, or merchant category comes close

### Time Analysis
- **Monday 4 AM is the single worst window: 24.85% failure rate** — 1 in 4 transactions fails
- Hours 2–5 AM sustain 9–11% failure — double the daytime average (bank batch processing + maintenance overlap)
- **Monday failure rate (8.73%) is 84% higher than Sunday (4.75%)**
- Monthly variation is extremely narrow (5.85%–6.44%) — no seasonal pattern

### Geographic Analysis
- **Uttar Pradesh: highest failure rate (5.22%) with 12.05% volume** — High Volume High Risk
- **Maharashtra: highest volume (14.97%) with below-average failure (4.92%)** — benchmark state
- Tamil Nadu has the worst failed value percentage (5.41% of transacted ₹)
- All top-10 states by volume fall below the overall failure average — confirming bank-side, not geography-side, root cause

### Transaction Type & Merchant Analysis
- All four transaction types fail within a **0.21% band (4.88%–5.09%)** — failure is systemic, not type-driven
- All ten merchant categories fail within a **0.49% band (4.76%–5.25%)** — same conclusion
- Recharge worst rate (5.09%) due to third-party telecom API dependency
- Shopping: highest absolute ₹ loss at ₹39.60 Lac (volume effect)
- Education: worst failed value % at 5.66%

### Core Conclusion
> UPI payment failures are **bank-infrastructure-driven**, not use-case, geography, or demographic driven. Axis Bank is the primary systemic outlier. Monday early morning is the peak stress window. The narrow failure bands across all other dimensions point to backend settlement infrastructure as the root cause.

---

## Power BI Dashboard — 6 Pages

| Page | Focus | Key Visuals |
|---|---|---|
| 1 — Executive Summary | Top-level KPIs and failure overview | 5 KPI cards · Failure by amount range · Bank volume vs failure scatter |
| 2 — Bank Analysis | Sender/receiver failure rates · pair analysis | Failure rate bar · Receiver comparison · Bank pair heatmap · Market share treemap |
| 3 — Time Analysis | Hourly and daily failure patterns | Day × Hour heatmap · Hourly line chart · Day-of-week bar · Failed ₹ by hour |
| 4 — State Analysis | Geographic failure distribution | Filled map · State risk matrix scatter · Top/bottom states bar |
| 5 — Transaction & Merchant | Type and category failure breakdown | Dual-axis combo · Payment mode donut · Merchant horizontal bar |
| 6 — NPCI Benchmark | Official macro data vs micro findings | Monthly volume/value trend · Top banks bar · Market share treemap · KPI cards |

**Design:** Dark fintech theme — canvas `#0D1B2A` · accent cyan `#00C6FF` · danger `#E74C3C` · success `#2ECC71`

---

## SQL Analysis — 12 Scripts

| File | Purpose |
|---|---|
| 1_Data_Loading.sql | Database creation · table schema · LOAD DATA INFILE |
| 2_Data_Validation.sql | NULL checks · empty string fix · status distribution |
| 3_Overview_analysis.sql | Total KPIs · avg/min/max amount · source breakdown |
| 4_Failure_analysis.sql | Failure by amount range · payment mode · top failed transactions |
| 5_Bank_analysis.sql | Sender/receiver failure rates · bank pair analysis · market share |
| 6_State_analysis.sql | State failure rates · volume share · failed ₹ by state |
| 7_Transaction_type_analysis.sql | Type distribution · failure rate · failed ₹ by type |
| 8_Time_analysis.sql | Hourly/daily/monthly failure · Day × Hour combination |
| 9_merchant_analysis.sql | Category failure rates · failed ₹ · bank × category cross-tab |
| 10_Demographic_analysis.sql | Documented and dropped — see Data Decisions section |
| 11_Views.sql | 6 reusable SQL views for Power BI and reporting |
| 12_Final_business_insights.sql | Executive summary · risk matrix · cross-dimensional leaderboard |

---

## Python EDA — 10 Plots

| Plot | Insight |
|---|---|
| plot_01_status_distribution | 93.93% success · 6.07% failure confirmed |
| plot_02_bank_failure_rate | Axis, ICICI, HDFC clearly above avg line |
| plot_03_hourly_failure_rate | 11 PM–6 AM danger window visible |
| plot_04_day_failure_rate | Monday spike (8.73%) dominant vs Sunday (4.75%) |
| plot_05_state_failure_rate | All top-10 states below avg — confirms systemic failure |
| plot_06_amount_distribution | Both distributions right-skewed · similar mean |
| plot_07_merchant_failure_rate | Tight 0.49% band — no category is an outlier |
| plot_08_transaction_type_failure | 0.21% band — failure is type-agnostic |
| plot_09_age_group_failure | 0.29% band — age is not a failure driver |
| plot_10_day_hour_heatmap | Monday 4 AM: 24.8% — single worst cell in dataset |

---

## Folder Structure

```
UPI-Payment-Failure-Analysis/
│
├── README.md
│
├── Dashboard/
│   └── UPI_Payment_Failure_Analysis.pbix
│
├── Datasets/
│   ├── Kaggle/
│   │   └── Cleaned/
│   │        └── Datasets.zip
│   └── NPCI/
│        ├── NPCI-Ecosystem-Stats-Master_workbook.xlsx
│        └── NPCI-Product-Stats-Master_workbook.xlsx
│
├── MySQL/
│   ├── 1_Data_Loading.sql
│   ├── 2_Data_Validation.sql
│   ├── 3_Overview_analysis.sql
│   ├── 4_Failure_analysis.sql
│   ├── 5_Bank_analysis.sql
│   ├── 6_State_analysis.sql
│   ├── 7_Transaction_type_analysis.sql
│   ├── 8_Time_analysis.sql
│   ├── 9_merchant_analysis.sql
│   ├── 10_Demographic_analysis.sql
│   ├── 11_Views.sql
│   └── 12_Final_business_insights.sql
│
├── Python/
│   ├── Data Preprocessing.ipynb
│   ├── EDA.ipynb
│   └── Plots/
│       ├── plot_01_status_distribution.png
│       ├── plot_02_bank_failure_rate.png
│       ├── plot_03_hourly_failure_rate.png
│       ├── plot_04_day_failure_rate.png
│       ├── plot_05_state_failure_rate.png
│       ├── plot_06_amount_distribution.png
│       ├── plot_07_merchant_failure_rate.png
│       ├── plot_08_transaction_type_failure.png
│       ├── plot_09_age_group_failure.png
│       └── plot_10_day_hour_heatmap.png
│
└── Documentation/
```

---

## How to Run

### MySQL Setup

```sql
-- 1. Create database and table
SOURCE MySQL/1_Data_Loading.sql;

-- 2. Validate data and fix nulls
SOURCE MySQL/2_Data_Validation.sql;

-- 3. Run analysis scripts in order (3 through 12)
SOURCE MySQL/3_Overview_analysis.sql;
-- ... continue through 12_Final_business_insights.sql
```

> Update the file path in `1_Data_Loading.sql` to match your MySQL upload directory before running LOAD DATA INFILE.

### Python Setup

```bash
pip install pandas numpy matplotlib seaborn openpyxl
```

Run notebooks in order:
1. `Data Preprocessing.ipynb` — cleaning, merging, export
2. `EDA.ipynb` — all 10 plots

### Power BI

Open `Dashboard/UPI_Payment_Failure_Analysis.pbix` in Power BI Desktop.
Update data source paths if prompted (MySQL connection string + NPCI file paths).

---

## Data Decisions & Limitations

**Demographic analysis dropped (10_Demographic_analysis.sql):** The gender and purpose columns exist only in the secondary dataset (20K rows). That dataset shows exactly 10K Male / 10K Female and exactly 4K rows per purpose — uniform synthetic distributions. A 20% flat failure rate for gender and 100%/0% split for purpose confirmed these are generation artifacts, not real behavioral signals. Including them would produce misleading conclusions.

**NPCI data isolated:** NPCI and Data.Gov files are not merged into MySQL. They connect directly to Power BI as separate data sources with no relationships to the main fact table — preventing cross-contamination of micro transaction-level analysis with macro aggregated benchmarks.

**Monthly variation excluded from conclusions:** The monthly failure rate range (5.85%–6.44%) is too narrow and consistent to reflect real seasonality — it is a characteristic of the Kaggle dataset's synthetic generation. No seasonal conclusions are drawn.

**DF2 demographic columns (city, gender, purpose):** These exist only in the 20K secondary dataset. They are loaded into the schema to maintain structural integrity but are excluded from all analytical conclusions.

---

## Author

**Abhijeet Lahade**
MCA — Data Science Specialization 

[![GitHub](https://img.shields.io/badge/GitHub-Abhijeet--109-black?logo=github)](https://github.com/Abhijeet-109)

[![LinkedIn](https://img.shields.io/badge/LinkedIn-abhijeet--lahade09-blue?logo=linkedin)](https://www.linkedin.com/in/abhijeet-lahade09)

---

*Stack: Python · pandas · seaborn · MySQL · Power BI · NPCI Official Data*
