WITH intel_data AS (
  SELECT
    model_year,
    d.device_type,
    COUNT(i.device_id) AS n_devices,
    (2024 - model_year) AS device_age,
    AVG(i.energy_savings_yr) AS avg_energy_savings,
    AVG(i.co2_saved_kg_yr) AS avg_co2_saved_kg,
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
    model_year,
    d.device_type
)
SELECT
  device_age_bucket,
  device_type,
  SUM(n_devices) AS total_devices,
  ROUND(AVG(avg_energy_savings), 2) AS avg_energy_savings,
  ROUND(AVG(avg_co2_saved_kg) / 1000, 4) AS avg_CO2_emissions_saved_tons
FROM
  intel_data
GROUP BY
  device_age_bucket,
  device_type
ORDER BY
  avg_CO2_emissions_saved_tons DESC;

