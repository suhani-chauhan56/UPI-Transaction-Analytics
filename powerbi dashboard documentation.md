# UPI-Transition Analysis Dashboard

A Power BI dashboard analyzing UPI (Unified Payments Interface) transaction data — covering transaction volume, success/fraud rates, merchant category breakdown, peak usage hours, sender/receiver age-group patterns, and state-wise success rates.

---

## Project Overview

This project takes raw UPI transaction data (MySQL / CSV), models it in Power BI with a proper date dimension and DAX measures, and surfaces it through an interactive dashboard with drill-through detail pages.

**Stack:** MySQL → Power Query → Power BI (DAX measures + visuals)

---

## Data Source

- **Database:** `upi_analytics` (MySQL)
- **Primary tables/views:**
  - `transactions` (or `v_transition` view) — core transaction-level fact table
  - `state_region` — maps sender states to regions (East / North / South / West)

### Key columns

| Column | Type | Notes |
|---|---|---|
| `transaction_id` | Text | Unique transaction identifier |
| `txn_ts` | Date/Time | Full timestamp of transaction |
| `amount_inr` | Decimal | Transaction amount in ₹ |
| `transaction_status` | Text | e.g. SUCCESS, FAILED |
| `transaction_type` | Text | Recharge, Bill Payment, P2P, P2M |
| `merchant_category` | Text | Shopping, Utilities, Grocery, Fuel, Education, Food, Healthcare, Entertainment, Other, Transport |
| `sender_state` | Text | Indian state |
| `region` | Text | East / North / South / West (from `state_region`) |
| `txn_hour` | Whole number | Hour of day (0–23) extracted from `txn_ts` |
| `device_type` | Text | Device used for the transaction |
| `network_type` | Text | Network used (e.g. 4G, 5G, WiFi) |
| `fraud_flag` | Whole number (0/1) | Fraud indicator |
| `sender_age_group` | Text | Age bracket of sender (e.g. 18-25, 26-35, 36-45) |
| `receiver_age_group` | Text | Age bracket of receiver |

> **Note:** `txn_ts` includes a time component. A separate date-only column (`txn_date`, created via Power Query's *Date Only* transform or `DATEVALUE(txn_ts)`) is required to build a valid relationship to the Date table — see [Data Model](#data-model) below.

---

## Data Model

### Date Table

A dedicated `DateTable` was built via DAX to enable time-intelligence functions:

```dax
DateTable =
ADDCOLUMNS(
    CALENDAR(DATE(2024,1,1), DATE(2024,12,31)),
    "Year", YEAR([Date]),
    "MonthNo", MONTH([Date]),
    "Month", FORMAT([Date], "MMM"),
    "YearMonth", FORMAT([Date], "YYYY-MM"),
    "Weekday", FORMAT([Date], "ddd")
)
```

- Marked as an official **Date Table** (Modeling → Mark as Date Table).
- Related to `transactions[txn_date]` (date-only column — **not** the raw timestamp) via a **One-to-Many, single-direction, active** relationship.

### Relationships

```
DateTable[Date]  1 ────< *  transactions[txn_date]
state_region[state] 1 ────< *  transactions[sender_state]   (if using separate region table)
```

---

## DAX Measures

| Measure | Formula | Format |
|---|---|---|
| Total Transactions | `COUNTROWS('transactions')` | Whole number |
| Total Amount | `SUM('transactions'[amount_inr])` | ₹ currency |
| Avg Transaction Value | `DIVIDE([Total Amount], [Total Transactions])` | ₹ currency |
| Successful Txns | `CALCULATE([Total Transactions], 'transactions'[transaction_status] = "SUCCESS")` | Whole number |
| Success Rate % | `DIVIDE([Successful Txns], [Total Transactions], 0)` | Percentage |
| Fraud Count | `SUM('transactions'[fraud_flag])` | Whole number |
| Fraud Rate % | `DIVIDE([Fraud Count], [Total Transactions], 0)` | Percentage |
| Amount LM | `CALCULATE([Total Amount], DATEADD('DateTable'[Date], -1, MONTH))` | ₹ currency |
| MoM Growth % | `DIVIDE([Total Amount] - [Amount LM], [Amount LM])` | Percentage |

---

## Dashboard Layout

### Header

- Title banner: **"UPI-Transition Analysis Dashboard"** with app icon.
- **Transaction Type** filter buttons (top-right): Bill Payment, P2M, P2P, Recharge — styled as tiles for one-click filtering across the whole page.

### KPI Row

| Card | Measure | Notes |
|---|---|---|
| Total Amount by YearMonth | `Total Amount` | Shown as a rounded KPI-style card (₹1.29M) |
| Total Transactions | `Total Transactions` | 1000 |
| Success Rate % | `Success Rate %` | 95.40%, with trend icon |
| Fraud Rate % | `Fraud Rate %` | 0.10%, with trend icon |
| Avg Transaction Value | `Avg Transaction Value` | ₹1.29K |
| Total Amount | `Total Amount` | ₹1.29M |

### Filters / Slicer

- **Merchant category** — vertical list-style slicer (left rail): Education, Entertainment, Food, Fuel, Grocery, Healthcare, Other, Shopping, Transport.

### Visuals

- **Successful Txns by merchant_category** — Horizontal bar chart, `Successful Txns` measure by `merchant_category`, log-scale x-axis (1 → 10 → 100 → 1000) to handle the wide value spread.
- **Total Transactions by txn_hour** — Column chart, `Total Transactions` by `txn_hour`, log-scale y-axis (1 → 10 → 100). Shows the peak usage window roughly between hour 10 and hour 20.
- **Total Amount and Avg Transaction Value by merchant_category** — Horizontal bar chart, `Total Amount` by `merchant_category`, log-scale x-axis; `Avg Transaction Value` available via tooltip.
- **Total Amount by txn_ts** — Line/area chart, `Total Amount` across the raw timestamp axis (Jan 2024 – Dec 2024), log-scale y-axis. Shows daily volume fluctuation rather than a smoothed monthly trend.
- **Count of receiver_age_group by sender_age_group and region** — Stacked horizontal bar chart, `receiver_age_group` count broken down by `sender_age_group` (18-25, 26-35, 36-45), colored/legended by `region` (East, North, South, West).
- **Success Rate % by sender_state and region** — Filled map, color intensity by `Success Rate %`, colored/legended by `region`.

> **Not yet included on this page:** a dedicated Fraud Rate % by state chart, a device_type × network_type fraud matrix, a clean monthly (YearMonth) growth line with MoM Growth %, and a drill-through detail page. These were part of the original plan (see [Suggested Next Steps](#suggested-next-steps)) but aren't visible in the current build — add them if you want the full drill-through / fraud-deep-dive experience.

## Suggested Next Steps

- Replace **Total Amount by txn_ts** with a **Total Amount by `DateTable[YearMonth]`** line chart (plus `MoM Growth %` on a secondary axis) for a cleaner month-over-month trend, with a Year → Month → Day drill-down hierarchy.
- Add a **Fraud Rate % by sender_state** bar chart and a **device_type × network_type** matrix shaded by Fraud Rate %, per the original fraud-analysis plan.
- Add a **State Detail** drill-through page (drill-through field: `sender_state`) so users can right-click a state on the map and see transaction-level detail.
- Consider linear-scale alternatives or annotated log-scale axes on the bar/column charts — log scales are useful for the wide value spread here but can be confusing for non-technical viewers unless labeled clearly.

---

## Known Data Caveats

- **Fraud is sparse.** In this dataset, `fraud_flag = 1` occurs in only a handful of the ~1,000 transactions (overall Fraud Rate % ≈ 0.10%). As a result, per-state and per-category fraud breakdowns will show a single dominant bar (or none at all) rather than a smooth distribution. This is an honest reflection of low fraud incidence in the sample data, not a chart/measure error — verify by placing a temporary `Fraud Count` card on the canvas before assuming a bug.
- **Timestamp vs. date-only relationship.** The Date table must relate to a **date-only** column (not the raw `txn_ts` timestamp), or the relationship will silently fail to match rows outside midnight, breaking all time-intelligence measures (`Amount LM`, `MoM Growth %`, Year/Month drill-down).
- **Date range is fixed to calendar year 2024** (`CALENDAR(DATE(2024,1,1), DATE(2024,12,31))`). Update this range if the source data covers a different period.
- **Several visuals use log-scale axes** (Successful Txns by merchant_category, Total Transactions by txn_hour, Total Amount by merchant_category, Total Amount by txn_ts). This was likely done to compress a wide value range into a readable chart, but log scales can misrepresent proportional differences to viewers unfamiliar with them — consider adding an axis label/footnote noting the scale is logarithmic, not linear.

---

## How to Rebuild / Refresh

1. Update source data in MySQL (`upi_analytics` database) or replace the CSV.
2. Open `UPI_Dashboard.pbix` → **Home → Refresh**.
3. If new months are added beyond Dec 2024, update the `DateTable` DAX formula's end date accordingly.
4. Re-check the fraud visuals if the fraud rate materially changes — the dashboard was designed around a low-fraud-incidence dataset.

---

## File

- `UPI_Transition_Analysis_Dashboard.pbix` — main Power BI report file (rename to match your saved filename)

## Author / Project Context

Built as a UPI transaction analytics exercise: MySQL data modeling → Power Query cleaning → Power BI DAX + visualization → interactive drill-through reporting.
