CREATE OR REPLACE MODEL `bqml_codi_map.gemini-pro-vision`
  REMOTE WITH CONNECTION `us.codi_map`
  OPTIONS (ENDPOINT = 'gemini-pro-vision');