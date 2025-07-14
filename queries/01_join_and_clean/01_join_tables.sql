SELECT
  *
FROM
  intel.impact_data
  INNER JOIN intel.device_data ON intel.impact_data.device_id = intel.device_data.device_id;

