package com.school.controller.student;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.student.StudentDAO;
import com.school.model.student.Student;
import com.school.util.DBConnection;
import com.school.exception.student.*;

@WebServlet("/student/attendance")
public class StudentAttendanceServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            Connection con  = DBConnection.getConnection();
            StudentDAO dao  = new StudentDAO();
            Student student = dao.getStudentByUsername(username);

            int total = 0, present = 0, absent = 0;
            List<Map<String,String>> records = new ArrayList<>();

            if (student != null) {
                String sql = "SELECT TO_CHAR(attendance_date,'YYYY-MM-DD') AS att_date, "
                           + "TO_CHAR(attendance_date,'Day') AS day_name, status "
                           + "FROM st_attendance WHERE student_id=? ORDER BY attendance_date DESC";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, student.getStudent_id());
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String,String> r = new HashMap<>();
                    r.put("attendance_date", rs.getString("att_date"));
                    r.put("day_name",        rs.getString("day_name").trim());
                    r.put("status",          rs.getString("status"));
                    if ("Present".equals(rs.getString("status"))) present++;
                    else absent++;
                    total++;
                    records.add(r);
                }
            }

            int pct = total > 0 ? (present * 100 / total) : 0;
            request.setAttribute("attendanceRecords", records);
            request.setAttribute("attendancePercent", pct);
            request.setAttribute("totalDays",         total);
            request.setAttribute("presentDays",       present);
            request.setAttribute("absentDays",        absent);

        } catch (Exception e) {
            StudentExceptionHandler.handle(request, response,
                new StudentAttendanceException("We could not load your attendance. Please try again later.", e));
            return;
        }
        request.getRequestDispatcher("/jsp/student/attendance.jsp").forward(request, response);
    }
}