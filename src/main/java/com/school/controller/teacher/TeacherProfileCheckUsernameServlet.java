package com.school.controller.teacher;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.util.DBConnection;

@WebServlet("/teacher/profile/checkUsername")
public class TeacherProfileCheckUsernameServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();
        try {
            String username = request.getParameter("username");
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT username FROM st_teacher WHERE username=?");
            ps.setString(1, username);
            out.print(ps.executeQuery().next() ? "taken" : "available");
        } catch (Exception e) { out.print("error"); }
    }
}