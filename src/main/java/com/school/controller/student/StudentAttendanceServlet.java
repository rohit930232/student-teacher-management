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
import com.school.exception.student.*;

@WebServlet("/student/attendance")
public class StudentAttendanceServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            Connection con = DBConnection.getConnection();
            StudentDAO dao = new StudentDAO();
            Student student = dao.getStudentByUsername(username);

            int total = 0, present = 0, absent = 0;
            List<Map<String,String>> records = new ArrayList<>();

            if (student != null) {
                PreparedStatement ps = con.prepareStatement("SELECT attendance_date, status FROM st_attendance WHERE student_id=? ORDER BY attendance_date DESC");
                ps.setInt(1, student.getStudent_id());
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    total++;
                    String status = rs.getString("status");
                    if ("Present".equals(status)) present++; else absent++;
                    Map<String,String> r = new HashMap<>();
                    java.sql.Date d = rs.getDate("attendance_date");
                    r.put("attendance_date", d != null ? d.toString() : "");
                    r.put("status", status);
                    if (d != null) {
                        Calendar cal = Calendar.getInstance();
                        cal.setTime(d);
                        String[] days = {"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"};
                        r.put("day_name", days[cal.get(Calendar.DAY_OF_WEEK) - 1]);
                    }
                    records.add(r);
                }
            }
            int pct = total > 0 ? (int) Math.round(present * 100.0 / total) : 0;
            request.setAttribute("attendancePercent", pct);
            request.setAttribute("totalDays", total);
            request.setAttribute("presentDays", present);
            request.setAttribute("absentDays", absent);
            request.setAttribute("attendanceRecords", records);
        } catch (Exception e) {
        	 StudentExceptionHandler.handle(request, response,
        		        new StudentAssignmentException("We could not load your assignments. Please try again after some time.", e));
        		    return;
}
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/student/attendance.jsp");
        rd.forward(request, response);
    }
}