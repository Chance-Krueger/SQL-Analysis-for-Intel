SELECT
  *,
  (2024 - model_year) as device_age
FROM
  intel.impact_data
  INNER JOIN intel.device_data ON intel.impact_data.device_id = intel.device_data.device_id
WHERE model_year = 2019;
