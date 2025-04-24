-- Remove geolocation fields from attendance table
ALTER TABLE attendance 
DROP COLUMN IF EXISTS latitude,
DROP COLUMN IF EXISTS longitude,
DROP COLUMN IF EXISTS location_verified,
DROP COLUMN IF EXISTS location_address;

-- Drop allowed_locations table
DROP TABLE IF EXISTS allowed_locations;
