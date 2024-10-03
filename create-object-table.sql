CREATE OR REPLACE EXTERNAL TABLE `bqml_codi_map.codi`
  WITH CONNECTION `us.codi_map`
  OPTIONS (
    object_metadata = 'SIMPLE',
    uris =
      ['gs://codi-map-images/downloads/*']);