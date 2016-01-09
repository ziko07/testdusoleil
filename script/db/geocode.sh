database="$1"
msql_options="$2"

query="
  DROP TABLE IF EXISTS geocode_locations_updates;
  CREATE TABLE geocode_locations_updates LIKE geocode_locations;
  LOAD DATA CONCURRENT LOCAL INFILE 'db/geo-csv/GeoIPCity-134-Location.csv' INTO TABLE geocode_locations_updates 
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' IGNORE 2 LINES
  (id, country, region, city, postal_code, \`lat\`, \`long\`, geocode_metro_code_id, area_code);
  DROP TABLE IF EXISTS geocode_locations;
  RENAME TABLE geocode_locations_updates TO geocode_locations;

  DROP TABLE IF EXISTS geocode_blocks_updates;
  CREATE TABLE geocode_blocks_updates LIKE geocode_blocks;
  LOAD DATA CONCURRENT LOCAL INFILE 'db/geo-csv/GeoIPCity-134-Blocks.csv' INTO TABLE geocode_blocks_updates 
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' IGNORE 2 LINES
  (start_ipnum, end_ipnum, geocode_location_id);
  DROP TABLE IF EXISTS geocode_blocks;
  RENAME TABLE geocode_blocks_updates TO geocode_blocks;

  TRUNCATE geocode_metro_codes_from_csv;
  LOAD DATA CONCURRENT LOCAL INFILE 'db/geo-csv/metrocodes.csv' 
  INTO TABLE geocode_metro_codes_from_csv 
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' IGNORE 1 LINES
  (province_name, metro_name, metro_code, criteria_id);

  DROP TABLE IF EXISTS geocode_metro_codes_updates;
  CREATE TABLE geocode_metro_codes_updates LIKE geocode_metro_codes;
  TRUNCATE geocode_metro_codes_updates;
  INSERT INTO geocode_metro_codes_updates (id, metro_name)
  SELECT DISTINCT metro_code, metro_name FROM geocode_metro_codes_from_csv;
  DROP TABLE IF EXISTS geocode_metro_codes;
  RENAME TABLE geocode_metro_codes_updates TO geocode_metro_codes;
  "
echo $query | mysql --local-infile $msql_options $database
