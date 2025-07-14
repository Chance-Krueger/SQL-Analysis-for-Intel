SELECT
  model_year,
  COUNT(intel.impact_data.device_id) AS n_devices,
  (2024 - model_year) AS device_age,
  CASE
    WHEN (2024 - model_year) <= 3 THEN 'newer'
    WHEN (
      (2024 - model_year) > 3
      AND (2024 - model_year) <= 6
    ) THEN 'mid-range'
    ELSE 'older'
  END AS device_age_bucket
FROM
  intel.impact_data
  INNER JOIN intel.device_data ON intel.impact_data.device_id = intel.device_data.device_id
GROUP BY
  model_year
ORDER BY
  n_devices DESC;
