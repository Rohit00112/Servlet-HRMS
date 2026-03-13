ALTER TABLE attendance DROP COLUMN IF EXISTS latitude;
ALTER TABLE attendance DROP COLUMN IF EXISTS longitude;
ALTER TABLE attendance DROP COLUMN IF EXISTS location_verified;
ALTER TABLE attendance DROP COLUMN IF EXISTS location_address;
DROP TABLE IF EXISTS allowed_locations;
