package com.school.controller.teacher;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.util.DBConnection;
import com.school.util.PasswordUtil;

@WebServlet("/teacher/password/change")
public class TeacherPasswordChangeServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username    = (String) session.getAttribute("username");
            String oldPassword = request.getParameter("old_password");
            String newPassword = request.getParameter("new_password");
            String confirmPass = request.getParameter("confirm_password");

            if (!newPassword.equals(confirmPass)) {
                response.sendRedirect(request.getContextPath() + "/teacher/settings?error=1");
                return;
            }

            String hashedOld = PasswordUtil.hashPassword(oldPassword);
            String hashedNew = PasswordUtil.hashPassword(newPassword);

            Connection con = DBConnection.getConnection();
            PreparedStatement checkPs = con.prepareStatement("SELECT teacher_id FROM st_teacher WHERE username=? AND password=?");
            checkPs.setString(1, username);
            checkPs.setString(2, hashedOld);

            if (checkPs.executeQuery().next()) {
                PreparedStatement updatePs = con.prepareStatement("UPDATE st_teacher SET password=? WHERE username=?");
                updatePs.setString(1, hashedNew);
                updatePs.setString(2, username);
                updatePs.executeUpdate();
                response.sendRedirect(request.getContextPath() + "/teacher/settings?success=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/teacher/settings?error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/teacher/settings?error=1");
        }
    }
}