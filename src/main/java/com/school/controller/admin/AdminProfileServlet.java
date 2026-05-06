package com.school.controller.admin;

import java.io.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import com.school.dao.admin.AdminDAO;
import com.school.model.admin.Admin;
import com.school.util.PasswordUtil;

@WebServlet({"/Admin/Profile", "/admin/profile"})
@MultipartConfig
public class AdminProfileServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        String username = (String) session.getAttribute("username");
        if (username == null) { res.sendRedirect(req.getContextPath() + "/login.jsp"); return; }

        AdminDAO dao = new AdminDAO();
        Admin admin  = dao.getAdminByUsername(username);
        req.setAttribute("admin", admin);
        req.getRequestDispatcher("/jsp/admin/profile.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        String username = (String) session.getAttribute("username");
        String action   = req.getParameter("action");
        if (username == null) { res.sendRedirect(req.getContextPath() + "/login.jsp"); return; }

        AdminDAO dao = new AdminDAO();

        if ("changePassword".equals(action)) {
            String oldPassword = req.getParameter("oldPassword");
            String newPassword = req.getParameter("newPassword");
            String hashedOld   = PasswordUtil.hashPassword(oldPassword);
            boolean verified   = dao.verifyPassword(username, hashedOld);
            if (verified) {
                boolean changed = dao.changePassword(username, PasswordUtil.hashPassword(newPassword));
                session.setAttribute(changed ? "message" : "error", changed ? "Password changed successfully!" : "Failed to change password!");
            } else {
                session.setAttribute("error", "Current password is incorrect!");
            }
            res.sendRedirect(req.getContextPath() + "/Admin/Profile");
            return;
        }

        if ("changePhoto".equals(action)) {
            Part filePart = req.getPart("photo");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName  = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadDir = getServletContext().getRealPath("") + "uploads" + File.separator + "admin";
                new File(uploadDir).mkdirs();
                filePart.write(uploadDir + File.separator + fileName);
                String photoPath = "uploads/admin/" + fileName;

                boolean ok = dao.updateAdminPhoto(username, photoPath);
                if (ok) {
                    session.setAttribute("photo", photoPath);
                    session.setAttribute("message", "Photo updated!");
                } else {
                    session.setAttribute("error", "Photo update failed!");
                }
            }
            res.sendRedirect(req.getContextPath() + "/Admin/Profile?success=1");
            return;
        }

        if ("updateProfile".equals(action)) {
            String fullname = req.getParameter("fullname");
            String email    = req.getParameter("email");
            String mobile   = req.getParameter("mobile");
            String address  = req.getParameter("address");
            String gender   = req.getParameter("gender");
            boolean updated = dao.updateAdminProfile(username, fullname, email, mobile, address, gender);
            if (updated) session.setAttribute("fullname", fullname);
            res.sendRedirect(req.getContextPath() + "/Admin/Profile?" + (updated ? "success=1" : "error=1"));
            return;
        }

        res.sendRedirect(req.getContextPath() + "/Admin/Profile");
    }
}