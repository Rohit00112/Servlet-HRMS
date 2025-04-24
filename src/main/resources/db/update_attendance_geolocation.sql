-- Add geolocation fields to attendance table
ALTER TABLE attendance 
ADD COLUMN IF NOT EXISTS latitude DECIMAL(10, 8),
ADD COLUMN IF NOT EXISTS longitude DECIMAL(11, 8),
ADD COLUMN IF NOT EXISTS location_verified BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS location_address TEXT;

-- Create a table for allowed locations
CREATE TABLE IF NOT EXISTS allowed_locations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    radius INTEGER NOT NULL DEFAULT 100, -- Radius in meters
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add some sample allowed locations
INSERT INTO allowed_locations (name, latitude, longitude, radius)
VALUES 
('Main Office', 27.7172, 85.3240, 200),  -- Example: Kathmandu coordinates
('Branch Office', 27.6710, 85.4298, 150); -- Example: Bhaktapur coordinates
