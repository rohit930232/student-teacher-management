package com.school.controller.student;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.util.DBConnection;
import com.school.exception.student.*;

@WebServlet("/student/notifications")
public class StudentNotificationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM st_notification ORDER BY created_date DESC");
            ResultSet rs = ps.executeQuery();
            List<Map<String,String>> notifications = new ArrayList<>();
            while (rs.next()) {
                Map<String,String> n = new HashMap<>();
                n.put("message", rs.getString("message"));
                n.put("date",    rs.getDate("created_date") != null ? rs.getDate("created_date").toString() : "");
                notifications.add(n);
            }
            request.setAttribute("notifications", notifications);

        } catch (Exception e) {
            StudentExceptionHandler.handle(request, response,
                new StudentNotificationException("We could not load your notifications. Please try again later.", e));
            return;
        }
        request.getRequestDispatcher("/jsp/student/notifications.jsp").forward(request, response);
    }
}