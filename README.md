<div align="center">

# 💳 UPI Transaction Analytics 

### Turning 250,000+ raw UPI transactions into fraud, revenue & growth insights

**Excel** → **SQL (MySQL)** → **Power BI**

![SQL](https://img.shields.io/badge/SQL-MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Excel](https://img.shields.io/badge/Excel-Data%20Cleaning-217346?style=for-the-badge&logo=microsoftexcel&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Status](https://img.shields.io/badge/Status-Ongoing-success?style=for-the-badge)

</div>

---

## 📖 The Story

Every second, UPI processes thousands of payments across India — and every one of those transactions leaves a trail: *when it happened, where it happened, how much it was for, and whether it succeeded.*

This project puts on the hat of a fintech analyst and asks a simple question: **"What is this data actually telling us?"**

Starting from a raw 250,000+ row CSV, I cleaned it in Excel, modeled and analyzed it in SQL, and told its story through an interactive Power BI dashboard — the same end-to-end pipeline a real analytics team would use to catch fraud, track growth, and report to stakeholders.

---

## 🧰 Tech Stack

| Layer | Tool | Purpose |
|---|---|---|
| 🧹 Data Cleaning | **Excel** | Deduplication, validation rules, pivot-table sanity checks |
| 🗃️ Data Modeling & Analysis | **MySQL (SQL)** | Staging tables, joins, CTEs, window functions, date functions |
| 📊 Visualization | **Power BI** | DAX measures, KPI cards, drill-through reports |

---

## 📁 Dataset

- 📦 **Size:** 250,000+ synthetic UPI transactions (Jan–Dec 2024)
- 📊 **Fields:** transaction ID, timestamp, amount, status, sender/receiver bank, merchant category, state, device, network, fraud flag
- 🔗 **Source:** Kaggle — `skullagos5246/upi-transactions-2024-dataset`

---

## 🔍 What I Analyzed

### 📈 Transaction Trends
- Month-over-month growth using **CTEs + `LAG()` window function**
- Peak transaction hours & weekday vs. weekend behavior

### 🏦 Geographic Analysis
- State-wise and region-wise transaction volume via **JOINs**
- High vs. low UPI adoption states

### 🛍️ Merchant Performance
- Top-performing merchant categories ranked with **`RANK()` window function**
- Share of total spend per category

### ❌ Failure Analysis
- Success vs. failure rate as a core KPI
- Failure patterns across banks and categories

### 🚨 Fraud Pattern Detection (Rule-Based)
- Fraud rate by state, device type, and network type
- Statistical outlier detection using **mean + 3×standard deviation** thresholds

---

## 📊 Dashboard Features

✅ KPI Cards — Total Transactions, Total Amount, Success Rate %, Fraud Rate %
✅ Time-intelligence line chart with MoM Growth % (using `DATEADD`)
✅ State-wise filled map with region breakdown
✅ Merchant category performance chart
✅ Fraud rate matrix (device × network)
✅ **Drill-through page** — click any state to see its full transaction detail
✅ Fully interactive slicers (category, transaction type, month, region)

---

## 💡 Key Insights

- 🕖 Peak transaction activity occurs in the **evening window (7–10 PM)**
- 📊 A small handful of merchant categories account for the **majority of total spend**
- 🗺️ UPI adoption is **heavily skewed** toward a few leading states
- 🏦 Certain **bank–network combinations show disproportionately higher failure and fraud rates**
- 🚩 Rule-based outlier detection flagged high-value transactions worth deeper investigation

---

## 🧗 Challenges & How I Solved Them

> **The dataset (250,000+ rows) was too large to load smoothly through MySQL Workbench's import wizard** — imports kept timing out and freezing the UI.
>
> **Fix:** I connected my MySQL server directly through a **different SQL editor inside VS Code** and ran the load + all analytical queries from there instead. This gave me faster query execution, better error visibility, and a more stable workflow for handling large-scale data — a good reminder that being tool-agnostic matters more than being tool-loyal.

---

## 🧠 Business Impact

This project reflects the kind of work a UPI/fintech analytics team does daily:

- 📌 **KPI tracking & reporting** for leadership dashboards
- 📌 **Fraud monitoring** to flag suspicious transaction patterns early
- 📌 **Growth tracking** via month-over-month revenue and volume trends
- 📌 **Operational health monitoring** through failure-rate analysis by bank/channel

---

## 🗂️ Project Structure

```
📦 upi-transaction-analytics
 ┣ 📜 upi_clean.csv              # Cleaned dataset (Excel output)
 ┣ 📜 sql_analysis.sql           # All SQL queries (staging → analysis → view)
 ┣ 📊 UPI_Dashboard.pbix         # Power BI dashboard
 ┣ 🖼️ screenshots/               # Dashboard preview images
 ┗ 📄 README.md
```

---

## 🚀 Future Improvements

- 🤖 Machine learning-based fraud detection model
- ⏱️ Real-time streaming dashboard
- 🔮 Predictive transaction forecasting
- 🔌 Live API-based data integration

---

## 👩‍💻 Author

**Suhani Chauhan**
*Aspiring Data Analyst | SQL • Power BI • Excel*

---

<div align="center">

⭐ **If this project helped you or you found it interesting, consider giving it a star!**

*Built as a portfolio project to demonstrate real-world fintech analytics skills — from raw data to business-ready insight.*

</div>
