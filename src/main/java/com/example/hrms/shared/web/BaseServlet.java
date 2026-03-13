package com.example.hrms.shared.web;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public abstract class BaseServlet extends HttpServlet {

    protected void setSuccessMessage(HttpServletRequest request, String message) {
        request.getSession().setAttribute("successMessage", message);
    }

    protected void setErrorMessage(HttpServletRequest request, String message) {
        request.getSession().setAttribute("errorMessage", message);
    }

    protected void setInfoMessage(HttpServletRequest request, String message) {
        request.getSession().setAttribute("infoMessage", message);
    }

    protected void setWarningMessage(HttpServletRequest request, String message) {
        request.getSession().setAttribute("warningMessage", message);
    }

    protected void transferMessagesFromSessionToRequest(HttpServletRequest request) {
        HttpSession session = request.getSession();
        transferMessage(session, request, "successMessage");
        transferMessage(session, request, "errorMessage");
        transferMessage(session, request, "infoMessage");
        transferMessage(session, request, "warningMessage");
    }

    private void transferMessage(HttpSession session, HttpServletRequest request, String key) {
        Object value = session.getAttribute(key);
        if (value != null) {
            request.setAttribute(key, value);
            session.removeAttribute(key);
        }
    }
}
