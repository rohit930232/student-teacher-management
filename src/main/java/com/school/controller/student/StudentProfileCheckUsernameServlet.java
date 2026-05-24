package com.school.controller.student;

import java.io.IOException;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.util.DBConnection;

@WebServlet("/student/profile/checkUsername")
public class StudentProfileCheckUsernameServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String username = request.getParameter("username");
        response.setContentType("text/plain");
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT username FROM st_student WHERE username=?");
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            response.getWriter().write(rs.next() ? "taken" : "available");
        } catch (Exception e) {
            response.getWriter().write("error");
        }
    }
}