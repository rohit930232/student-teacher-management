package com.school.controller.teacher;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.util.DBConnection;

@WebServlet("/teacher/attendance/detail")
public class TeacherAttendanceDetailServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        try {
            int studentId = Integer.parseInt(request.getParameter("student_id"));
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT attendance_date, status FROM st_attendance WHERE student_id=? ORDER BY attendance_date DESC");
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            StringBuilder json = new StringBuilder("[");
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                json.append("{\"date\":\"").append(rs.getDate("attendance_date")).append("\",\"status\":\"").append(rs.getString("status")).append("\"}");
                first = false;
            }
            json.append("]");
            out.print(json.toString());
        } catch (Exception e) { out.print("[]"); }
    }
}