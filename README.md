# 🚴‍♀️ Cyclistic Case Study — Google Data Analytics Capstone (Self-Guided Project)

## 📘 Overview
This self-guided project explores **Cyclistic**, a fictional Chicago-based bike-share program.  
The analysis focuses on understanding how annual members and casual riders use Cyclistic bikes differently — aiming to design data-driven marketing strategies that increase the conversion of casual riders to annual memberships.

---

## 🎯 Business Task
Analyze ride-usage differences between **annual members** and **casual riders**, and develop **three data-backed recommendations** to support marketing initiatives that increase membership conversion.

---

## 🗂️ Data Sources
1. **[Cyclistic 2024 Monthly Trip Data](https://divvy-tripdata.s3.amazonaws.com/index.html)** (January–December 2024):  
   Includes detailed trip records such as ride duration, rideable type, start and end station, and user type.  

   **Note:** Several fields contained incomplete or missing values, particularly:  
   - `start_station_name`  
   - `start_station_id`  
   - `end_station_name`  
   - `end_station_id`

---

## 🧹 Data Cleaning & Preparation
Performed in **BigQuery (SQL)** with manual validation in CSV.

- **Duplicates:** Removed duplicate rows and created a cleaned version of the dataset.  
- **Null values:** Verified — no nulls in key analytical fields.  
- **Unrealistic data:** Deleted **7,596 rows** where ride durations exceeded **24 hours**, as they were deemed invalid and could distort averages.  

All cleaning steps and transformation logic are stored in:  
`data_clean/cleaning_queries.sql`

---

## 📊 Summary of Analysis
**Key Metrics:** Average Trip Duration, Average Ride Frequency  

**Findings:**
- Casual riders take trips that are approximately **40% longer** than members.  
- Members ride **~45% more frequently** than casual riders.  

**Trends & Patterns:**
- **Average Trip Duration:** Increases steadily from January to May–June, then declines gradually through December for both user types.  
- **Average Ride Frequency:** Peaks around September, then falls sharply through December — showing similar seasonality for both groups.  

---

## 💡 Key Insights
- **Behavioral Split:** Members use bikes for **shorter, consistent commutes**, while casual riders favor **longer, leisure-oriented rides**.  
- **Seasonality:** High-activity months (March–October) present the best window for targeted marketing.  
- **Data Gaps:** Missing station-location data limits route-level optimization opportunities.

---

## 📈 Recommendations
1. **Target Seasonal Promotions:**  
   - Launch conversion campaigns between **March–October**, when casual ridership peaks.  
   - Avoid low-activity periods (**November–February**) to optimize marketing ROI.  

2. **Behavior-Triggered Discounts:**  
   - Offer limited-time membership discounts to **casual riders taking >3 rides/month** between March–September.  
   - Skip this offer during colder months (October–February) due to reduced ridership.  

3. **Improve Data Collection:**  
   - Standardize collection of **start/end station fields** to enhance station-level demand forecasting and placement optimization.

---

## 🧰 Tools & Techniques
- **SQL (BigQuery)** — Data cleaning, transformation, and aggregation  
- **Tableau** — Visualization and storytelling of behavioral trends and KPIs  
- **Spreadsheet / CSV** — Validation, quick exploration, and summary checks  
- **Google Slides** — Final presentation deck summarizing insights and recommendations  

---

## 🗂️ Repository Structure
- **data_raw/** — Original monthly trip data (Jan–Dec 2024)  
  - Only **two sample months** (`202401`, `202402`) are included due to GitHub size limits  
  - Full dataset (12 months) available at the official [Divvy Trip Data Portal](https://divvy-tripdata.s3.amazonaws.com/index.html)  
- **data_clean/**  
  - `sample_cyclistic_cleaned.csv` — Preview of the cleaned dataset (first 500 rows)  
  - `cleaning_queries.sql` — SQL cleaning and wrangling queries  
- **Cyclistic_Presentation.pdf** — Final summary presentation  
- **README.md**

---

## ⚙️ Data Access
Due to GitHub file size limits:
- The **raw data folder** includes only **two sample months** (January & February 2024).  
  The full dataset can be downloaded directly from the official [Divvy Trip Data Portal](https://divvy-tripdata.s3.amazonaws.com/index.html).  
- The **cleaned dataset** is represented by a **500-row sample file** (`sample_cyclistic_cleaned.csv`) for structure reference.  
  The complete cleaned dataset (~1 GB) is available upon request.

---

## 🧭 Lessons Learned
This project improved my ability to:
- Design reproducible **SQL workflows** for large datasets  
- Translate analytical findings into **practical marketing strategies**  
- Evaluate seasonality and behavioral segmentation using trip-level data  

---

## 🪄 About Me
Logistics specialist turned data analyst, building projects in Excel, Python, and SQL to uncover insights and drive operational improvement.