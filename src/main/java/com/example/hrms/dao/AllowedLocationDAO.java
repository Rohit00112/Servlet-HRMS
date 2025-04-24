package com.example.hrms.dao;

import com.example.hrms.model.AllowedLocation;
import com.example.hrms.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AllowedLocationDAO {

    public List<AllowedLocation> getAllAllowedLocations() {
        List<AllowedLocation> locations = new ArrayList<>();
        String sql = "SELECT * FROM allowed_locations ORDER BY name";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                AllowedLocation location = mapAllowedLocationFromResultSet(rs);
                locations.add(location);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return locations;
    }

    public List<AllowedLocation> getActiveAllowedLocations() {
        List<AllowedLocation> locations = new ArrayList<>();
        String sql = "SELECT * FROM allowed_locations WHERE is_active = true ORDER BY name";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                AllowedLocation location = mapAllowedLocationFromResultSet(rs);
                locations.add(location);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return locations;
    }

    public AllowedLocation getAllowedLocationById(int id) {
        AllowedLocation location = null;
        String sql = "SELECT * FROM allowed_locations WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                location = mapAllowedLocationFromResultSet(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return location;
    }

    public boolean createAllowedLocation(AllowedLocation location) {
        String sql = "INSERT INTO allowed_locations (name, latitude, longitude, radius, is_active) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, location.getName());
            pstmt.setDouble(2, location.getLatitude());
            pstmt.setDouble(3, location.getLongitude());
            pstmt.setInt(4, location.getRadius());
            pstmt.setBoolean(5, location.isActive());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateAllowedLocation(AllowedLocation location) {
        String sql = "UPDATE allowed_locations SET name = ?, latitude = ?, longitude = ?, radius = ?, is_active = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, location.getName());
            pstmt.setDouble(2, location.getLatitude());
            pstmt.setDouble(3, location.getLongitude());
            pstmt.setInt(4, location.getRadius());
            pstmt.setBoolean(5, location.isActive());
            pstmt.setInt(6, location.getId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteAllowedLocation(int id) {
        String sql = "DELETE FROM allowed_locations WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Checks if a given location is within any of the allowed locations
     * @param latitude The latitude to check
     * @param longitude The longitude to check
     * @return The name of the allowed location if within range, null otherwise
     */
    public String isLocationAllowed(double latitude, double longitude) {
        List<AllowedLocation> allowedLocations = getActiveAllowedLocations();
        
        for (AllowedLocation location : allowedLocations) {
            if (isWithinRadius(latitude, longitude, location.getLatitude(), location.getLongitude(), location.getRadius())) {
                return location.getName();
            }
        }
        
        return null;
    }
    
    /**
     * Calculate if a point is within a radius of another point using the Haversine formula
     * @param lat1 Latitude of point 1
     * @param lon1 Longitude of point 1
     * @param lat2 Latitude of point 2
     * @param lon2 Longitude of point 2
     * @param radius Radius in meters
     * @return true if point 1 is within the radius of point 2
     */
    private boolean isWithinRadius(double lat1, double lon1, double lat2, double lon2, int radius) {
        // Earth's radius in meters
        final int R = 6371000;
        
        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);
        
        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
        
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        
        double distance = R * c;
        
        return distance <= radius;
    }

    private AllowedLocation mapAllowedLocationFromResultSet(ResultSet rs) throws SQLException {
        AllowedLocation location = new AllowedLocation();
        location.setId(rs.getInt("id"));
        location.setName(rs.getString("name"));
        location.setLatitude(rs.getDouble("latitude"));
        location.setLongitude(rs.getDouble("longitude"));
        location.setRadius(rs.getInt("radius"));
        location.setActive(rs.getBoolean("is_active"));
        location.setCreatedAt(rs.getTimestamp("created_at"));
        location.setUpdatedAt(rs.getTimestamp("updated_at"));
        return location;
    }
}
