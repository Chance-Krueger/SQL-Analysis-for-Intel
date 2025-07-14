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
