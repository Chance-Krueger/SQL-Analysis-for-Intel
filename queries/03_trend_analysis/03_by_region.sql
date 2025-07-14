SELECT
  i.region,
  d.device_type,
  COUNT(i.device_id) AS total_devices,
  ROUND(AVG(i.energy_savings_yr), 2) AS avg_energy_savings,
  ROUND(AVG(i.co2_saved_kg_yr) / 1000,4) AS avg_CO2_emissions_saved_tons
FROM
  intel.impact_data AS i
  INNER JOIN intel.device_data AS d ON i.device_id = d.device_id
GROUP BY
  i.region, d.device_type;

