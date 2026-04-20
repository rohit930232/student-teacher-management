package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.school.dao.admin.AdminDAO;
import com.school.model.admin.Admin;
import com.school.util.PasswordUtil;

@WebServlet("/Admin/Profile")
public class AdminProfileServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        String username = (String) session.getAttribute("username");
        
        if (username == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        
        AdminDAO dao = new AdminDAO();
        Admin admin = dao.getAdminByUsername(username);
        
        req.setAttribute("admin", admin);
        req.getRequestDispatcher("/jsp/admin/profile.jsp").forward(req, res);
    }
    
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        String username = (String) session.getAttribute("username");
        String action = req.getParameter("action");
        
        if (username == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        
        AdminDAO dao = new AdminDAO();
        
        // Check if it's password change request
        if ("changePassword".equals(action)) {
            String oldPassword = req.getParameter("oldPassword");
            String newPassword = req.getParameter("newPassword");
            
            // Hash passwords using existing method
            String hashedOldPassword = PasswordUtil.hashPassword(oldPassword);
            
            // Verify old password
            boolean verified = dao.verifyPassword(username, hashedOldPassword);
            
            if (verified) {
                String hashedNewPassword = PasswordUtil.hashPassword(newPassword);
                boolean changed = dao.changePassword(username, hashedNewPassword);
                
                if (changed) {
                    session.setAttribute("message", "Password changed successfully!");
                } else {
                    session.setAttribute("error", "Failed to change password!");
                }
            } else {
                session.setAttribute("error", "Current password is incorrect!");
            }
            
            res.sendRedirect(req.getContextPath() + "/Admin/Profile");
            return;
        }
        
        // Check if it's username change request
        if ("changeUsername".equals(action)) {
            String newUsername = req.getParameter("newUsername");
            
            // Check if username already exists
            boolean exists = dao.usernameExists(newUsername);
            
            if (exists) {
                session.setAttribute("error", "Username '" + newUsername + "' is already taken! Please choose another.");
                res.sendRedirect(req.getContextPath() + "/Admin/Profile");
                return;
            }
            
            // Update username
            boolean updated = dao.updateUsername(username, newUsername);
            
            if (updated) {
                session.setAttribute("username", newUsername);
                session.setAttribute("message", "Username changed successfully! New username: " + newUsername);
            } else {
                session.setAttribute("error", "Failed to change username!");
            }
            
            res.sendRedirect(req.getContextPath() + "/Admin/Profile");
            return;
        }
        
        // Regular profile update
        String fullname = req.getParameter("fullname");
        String email = req.getParameter("email");
        String mobile = req.getParameter("mobile");
        String address = req.getParameter("address");
        String gender = req.getParameter("gender");
        
        boolean updated = dao.updateAdminProfile(username, fullname, email, mobile, address, gender);
        
        if (updated) {
            session.setAttribute("fullname", fullname);
            session.setAttribute("message", "Profile updated successfully!");
        } else {
            session.setAttribute("error", "Failed to update profile");
        }
        
        res.sendRedirect(req.getContextPath() + "/Admin/Profile");
    }
}