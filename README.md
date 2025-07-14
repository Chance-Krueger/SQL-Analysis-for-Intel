# 🌱 Sustainability Impact Analysis for Intel

This project explores the environmental and strategic implications of Intel's device repurposing program through structured data analysis using SQL. Built as part of *The Career Accelerator* initiative, the dataset and context were provided by Intel to simulate real-world sustainability challenges and sharpen data analytics skills.

## 📌 Project Overview

Using two datasets — one on environmental impact and one on device specifications — this project leverages SQL to:

- Join, clean, and organize large datasets
- Calculate device age and categorize into meaningful age buckets
- Identify patterns in device reuse, energy savings, and CO₂ emission reductions
- Compare device performance across types, regions, and ages
- Make data-driven recommendations to enhance Intel’s sustainability outcomes

## 💻 Tools & Technologies
- **SQL** (BigQuery syntax)
- **Data Analytics**
- **Relational Joins & CTEs**
- **CASE WHEN logic**
- **Aggregations & Grouping**

## 📊 Key Insights

- **Repurposed Volume**: Over 600,000 devices were repurposed by Intel in 2024.
- **Device Age Impact**: Mid-range devices (4–6 years old) provided the highest energy and CO₂ savings per unit.
- **Device Type Trends**: Laptops accounted for the largest share of savings due to their higher repurposing rates.
- **Regional Differences**: Asia showed the highest CO₂ savings due to its carbon-intensive electricity grid.

## ✅ Recommendations

- **Prioritize mid-range devices** to maximize energy savings and emissions reductions.
- **Focus efforts on high carbon-intensity regions** like Asia to increase environmental impact.
- **Leverage device type insights** to invest more strategically in repurposing laptops over desktops.
- **Incorporate cost data** to optimize for both sustainability and cost-effectiveness.

## 🔍 Example SQL Techniques

```sql
-- Returns total devices, average energy savings, and average CO₂ saved by device type and region,
-- along with each type's percentage contribution to total regional energy and CO₂ savings.
WITH region_totals AS (
  SELECT
    id.region,
    SUM(id.energy_savings_yr) AS total_energy_savings_region,
    SUM(id.co2_saved_kg_yr) AS total_co2_saved_region
  FROM
    intel.impact_data AS id
    INNER JOIN intel.device_data AS dd ON id.device_id = dd.device_id
  GROUP BY
    id.region
),
device_type_totals AS (
  SELECT
    id.region,
    dd.device_type,
    COUNT(id.device_id) AS total_devices,
    SUM(id.energy_savings_yr) AS total_energy_savings,
    SUM(id.co2_saved_kg_yr) AS total_co2_saved_kg
  FROM
    intel.impact_data AS id
    INNER JOIN intel.device_data AS dd ON id.device_id = dd.device_id
  GROUP BY
    id.region,
    dd.device_type
)
SELECT
  dt.region,
  dt.device_type,
  dt.total_devices,
  ROUND(dt.total_energy_savings / dt.total_devices, 2) AS avg_energy_savings,
  ROUND(
    (dt.total_co2_saved_kg / dt.total_devices) / 1000,
    4
  ) AS avg_CO2_emissions_saved_tons,
  ROUND(
    100.0 * dt.total_energy_savings / rt.total_energy_savings_region,
    2
  ) AS pct_energy_savings,
  ROUND(
    100.0 * dt.total_co2_saved_kg / rt.total_co2_saved_region,
    2
  ) AS pct_CO2_reductions
FROM
  device_type_totals dt
  JOIN region_totals rt ON dt.region = rt.region
ORDER BY
  dt.region,
  pct_CO2_reductions DESC;

