package com.example.hrms.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Base servlet class that provides common functionality for all servlets.
 */
public abstract class BaseServlet extends HttpServlet {
    
    /**
     * Sets a success message in the session.
     * 
     * @param request The HTTP request
     * @param message The success message
     */
    protected void setSuccessMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("successMessage", message);
    }
    
    /**
     * Sets an error message in the session.
     * 
     * @param request The HTTP request
     * @param message The error message
     */
    protected void setErrorMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("errorMessage", message);
    }
    
    /**
     * Sets an info message in the session.
     * 
     * @param request The HTTP request
     * @param message The info message
     */
    protected void setInfoMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("infoMessage", message);
    }
    
    /**
     * Sets a warning message in the session.
     * 
     * @param request The HTTP request
     * @param message The warning message
     */
    protected void setWarningMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("warningMessage", message);
    }
    
    /**
     * Transfers any messages from the session to request attributes and removes them from the session.
     * 
     * @param request The HTTP request
     */
    protected void transferMessagesFromSessionToRequest(HttpServletRequest request) {
        HttpSession session = request.getSession();
        
        // Transfer success message
        if (session.getAttribute("successMessage") != null) {
            request.setAttribute("successMessage", session.getAttribute("successMessage"));
            session.removeAttribute("successMessage");
        }
        
        // Transfer error message
        if (session.getAttribute("errorMessage") != null) {
            request.setAttribute("errorMessage", session.getAttribute("errorMessage"));
            session.removeAttribute("errorMessage");
        }
        
        // Transfer info message
        if (session.getAttribute("infoMessage") != null) {
            request.setAttribute("infoMessage", session.getAttribute("infoMessage"));
            session.removeAttribute("infoMessage");
        }
        
        // Transfer warning message
        if (session.getAttribute("warningMessage") != null) {
            request.setAttribute("warningMessage", session.getAttribute("warningMessage"));
            session.removeAttribute("warningMessage");
        }
    }
}
