package com.school.controller.teacher;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.util.DBConnection;

@WebServlet("/teacher/notices")
public class TeacherNoticeServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection con = DBConnection.getConnection();
            String classIdParam = request.getParameter("class_id");

            List<Map<String,String>> classes = new ArrayList<>();
            PreparedStatement cPs = con.prepareStatement("SELECT * FROM st_class ORDER BY class_name");
            ResultSet cRs = cPs.executeQuery();
            while (cRs.next()) {
                Map<String,String> c = new HashMap<>();
                c.put("class_id",   String.valueOf(cRs.getInt("class_id")));
                c.put("class_name", cRs.getString("class_name"));
                classes.add(c);
            }
            request.setAttribute("classes", classes);

            List<Map<String,String>> notices = new ArrayList<>();
            PreparedStatement ps;

            if (classIdParam != null && !classIdParam.isEmpty()) {
                // Sirf us class ke notices — class_id IS NULL wale nahi
                ps = con.prepareStatement(
                    "SELECT * FROM st_notice WHERE class_id = ? ORDER BY created_date DESC"
                );
                ps.setInt(1, Integer.parseInt(classIdParam));
            } else {
                // All Classes tab — saare notices
                ps = con.prepareStatement(
                    "SELECT * FROM st_notice ORDER BY created_date DESC"
                );
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String,String> n = new HashMap<>();
                n.put("notice_id", String.valueOf(rs.getInt("notice_id")));
                n.put("message",   rs.getString("message"));
                n.put("date",      rs.getDate("created_date") != null ? rs.getDate("created_date").toString() : "");
                n.put("class_id",  rs.getString("class_id") != null ? rs.getString("class_id") : "");
                notices.add(n);
            }
            request.setAttribute("notices", notices);

        } catch (Exception e) { e.printStackTrace(); }
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/teacher/notices.jsp");
        rd.forward(request, response);
    }
}