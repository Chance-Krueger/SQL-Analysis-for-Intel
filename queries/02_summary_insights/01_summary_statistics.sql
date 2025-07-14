WITH intel_data AS (
  SELECT
    model_year,
    COUNT(i.device_id) AS n_devices,
    (2024 - model_year) AS device_age,
    AVG(i.energy_savings_yr) AS avg_energy_savings,
    SUM(i.co2_saved_kg_yr) AS total_co2_saved_kg,
    CASE
      WHEN (2024 - model_year) <= 3 THEN 'newer'
      WHEN (2024 - model_year) > 3
      AND (2024 - model_year) <= 6 THEN 'mid-range'
      ELSE 'older'
    END AS device_age_bucket
  FROM
    intel.impact_data AS i
    INNER JOIN intel.device_data AS d ON i.device_id = d.device_id
  GROUP BY
    model_year
)
SELECT
  SUM(n_devices) AS total_devices_repurposed_2024,
  ROUND(AVG(device_age), 2) AS avg_age_repurposed,
  ROUND(AVG(avg_energy_savings), 2) AS avg_estimated_energy_savings,
  ROUND(SUM(total_co2_saved_kg) / 1000.0, 2) AS total_CO2_emissions_saved_tons
FROM
  intel_data;
