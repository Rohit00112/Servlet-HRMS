package com.example.hrms.servlet;

import com.example.hrms.dao.AllowedLocationDAO;
import com.example.hrms.dao.UserActivityDAO;
import com.example.hrms.model.AllowedLocation;
import com.example.hrms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "allowedLocationsServlet", value = {
    "/admin/locations",
    "/hr/locations"
})
public class AllowedLocationsServlet extends HttpServlet {
    private AllowedLocationDAO allowedLocationDAO;
    private UserActivityDAO userActivityDAO;

    @Override
    public void init() {
        allowedLocationDAO = new AllowedLocationDAO();
        userActivityDAO = new UserActivityDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the current user from the session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is admin or HR
        if (!user.getRole().equals("ADMIN") && !user.getRole().equals("HR")) {
            response.sendRedirect(request.getContextPath() + "/employee/dashboard");
            return;
        }

        // Get all allowed locations
        List<AllowedLocation> locations = allowedLocationDAO.getAllAllowedLocations();
        request.setAttribute("locations", locations);

        // Get location ID for edit mode
        String locationIdStr = request.getParameter("id");
        if (locationIdStr != null && !locationIdStr.isEmpty()) {
            try {
                int locationId = Integer.parseInt(locationIdStr);
                AllowedLocation location = allowedLocationDAO.getAllowedLocationById(locationId);
                if (location != null) {
                    request.setAttribute("location", location);
                    request.setAttribute("editMode", true);
                }
            } catch (NumberFormatException e) {
                // Invalid ID, ignore
            }
        }

        request.getRequestDispatcher("/WEB-INF/admin/allowed-locations.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the current user from the session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is admin or HR
        if (!user.getRole().equals("ADMIN") && !user.getRole().equals("HR")) {
            response.sendRedirect(request.getContextPath() + "/employee/dashboard");
            return;
        }

        // Get form data
        String action = request.getParameter("action");
        String message = "";
        boolean success = false;

        if ("add".equals(action) || "update".equals(action)) {
            // Get location data
            String name = request.getParameter("name");
            String latitudeStr = request.getParameter("latitude");
            String longitudeStr = request.getParameter("longitude");
            String radiusStr = request.getParameter("radius");
            String isActiveStr = request.getParameter("isActive");

            // Validate data
            if (name == null || name.trim().isEmpty() || 
                latitudeStr == null || latitudeStr.trim().isEmpty() ||
                longitudeStr == null || longitudeStr.trim().isEmpty() ||
                radiusStr == null || radiusStr.trim().isEmpty()) {
                
                message = "All fields are required";
                request.getSession().setAttribute("errorMessage", message);
                response.sendRedirect(request.getContextPath() + "/admin/locations");
                return;
            }

            try {
                double latitude = Double.parseDouble(latitudeStr);
                double longitude = Double.parseDouble(longitudeStr);
                int radius = Integer.parseInt(radiusStr);
                boolean isActive = isActiveStr != null && isActiveStr.equals("on");

                if ("add".equals(action)) {
                    // Create new location
                    AllowedLocation location = new AllowedLocation();
                    location.setName(name);
                    location.setLatitude(latitude);
                    location.setLongitude(longitude);
                    location.setRadius(radius);
                    location.setActive(isActive);

                    success = allowedLocationDAO.createAllowedLocation(location);
                    if (success) {
                        message = "Location added successfully";
                        
                        // Log the activity
                        userActivityDAO.logActivity(
                            user.getId(),
                            user.getUsername(),
                            user.getRole(),
                            "CREATE",
                            "Added new allowed location: " + name,
                            "LOCATION",
                            null,
                            request.getRemoteAddr()
                        );
                    } else {
                        message = "Failed to add location";
                    }
                } else if ("update".equals(action)) {
                    // Update existing location
                    String locationIdStr = request.getParameter("locationId");
                    if (locationIdStr != null && !locationIdStr.isEmpty()) {
                        int locationId = Integer.parseInt(locationIdStr);
                        AllowedLocation location = allowedLocationDAO.getAllowedLocationById(locationId);
                        
                        if (location != null) {
                            location.setName(name);
                            location.setLatitude(latitude);
                            location.setLongitude(longitude);
                            location.setRadius(radius);
                            location.setActive(isActive);

                            success = allowedLocationDAO.updateAllowedLocation(location);
                            if (success) {
                                message = "Location updated successfully";
                                
                                // Log the activity
                                userActivityDAO.logActivity(
                                    user.getId(),
                                    user.getUsername(),
                                    user.getRole(),
                                    "UPDATE",
                                    "Updated allowed location: " + name,
                                    "LOCATION",
                                    locationId,
                                    request.getRemoteAddr()
                                );
                            } else {
                                message = "Failed to update location";
                            }
                        } else {
                            message = "Location not found";
                        }
                    } else {
                        message = "Invalid location ID";
                    }
                }
            } catch (NumberFormatException e) {
                message = "Invalid number format";
            }
        } else if ("delete".equals(action)) {
            // Delete location
            String locationIdStr = request.getParameter("locationId");
            if (locationIdStr != null && !locationIdStr.isEmpty()) {
                try {
                    int locationId = Integer.parseInt(locationIdStr);
                    AllowedLocation location = allowedLocationDAO.getAllowedLocationById(locationId);
                    
                    if (location != null) {
                        success = allowedLocationDAO.deleteAllowedLocation(locationId);
                        if (success) {
                            message = "Location deleted successfully";
                            
                            // Log the activity
                            userActivityDAO.logActivity(
                                user.getId(),
                                user.getUsername(),
                                user.getRole(),
                                "DELETE",
                                "Deleted allowed location: " + location.getName(),
                                "LOCATION",
                                locationId,
                                request.getRemoteAddr()
                            );
                        } else {
                            message = "Failed to delete location";
                        }
                    } else {
                        message = "Location not found";
                    }
                } catch (NumberFormatException e) {
                    message = "Invalid location ID";
                }
            } else {
                message = "Location ID is required";
            }
        }

        // Set message and redirect
        if (success) {
            request.getSession().setAttribute("successMessage", message);
        } else {
            request.getSession().setAttribute("errorMessage", message);
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/locations");
    }
}
