package com.school.controller.teacher;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.teacher.TeacherDAO;
import com.school.model.teacher.Teacher;
import com.school.util.DBConnection;

@WebServlet("/teacher/attendance")
public class TeacherAttendanceServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            Connection con = DBConnection.getConnection();
            TeacherDAO dao = new TeacherDAO();
            Teacher teacher = dao.getTeacherByUsername(username);
            String classIdParam = request.getParameter("class_id");

            // All classes for tabs
            List<Map<String,String>> classes = new ArrayList<>();
            PreparedStatement cPs = con.prepareStatement(
                "SELECT * FROM st_class ORDER BY class_name");
            ResultSet cRs = cPs.executeQuery();
            while (cRs.next()) {
                Map<String,String> c = new HashMap<>();
                c.put("class_id",   String.valueOf(cRs.getInt("class_id")));
                c.put("class_name", cRs.getString("class_name"));
                classes.add(c);
            }
            request.setAttribute("classes", classes);

            // ===== TEACHER KI APNI ATTENDANCE =====
            String selectedMonth = request.getParameter("month");
            if (selectedMonth == null || selectedMonth.isEmpty()) {
                selectedMonth = new java.text.SimpleDateFormat("yyyy-MM")
                    .format(new java.util.Date());
            }
            request.setAttribute("selectedMonth", selectedMonth);

            int currentYear = Integer.parseInt(selectedMonth.substring(0, 4));

            if (teacher != null) {
                // Month-wise records
                List<Map<String,String>> myAttRecords = new ArrayList<>();
                int myPresent = 0, myAbsent = 0;

                PreparedStatement myPs = con.prepareStatement(
                    "SELECT TO_CHAR(att_date,'YYYY-MM-DD') AS att_date, " +
                    "TO_CHAR(att_date,'Day') AS day_name, status " +
                    "FROM st_teacher_attendance " +
                    "WHERE teacher_id=? AND TO_CHAR(att_date,'YYYY-MM')=? " +
                    "ORDER BY att_date"
                );
                myPs.setInt(1, teacher.getTeacher_id());
                myPs.setString(2, selectedMonth);
                ResultSet myRs = myPs.executeQuery();
                while (myRs.next()) {
                    Map<String,String> r = new HashMap<>();
                    r.put("date",   myRs.getString("att_date"));
                    r.put("day",    myRs.getString("day_name").trim());
                    r.put("status", myRs.getString("status"));
                    if ("Present".equals(myRs.getString("status"))) myPresent++;
                    else myAbsent++;
                    myAttRecords.add(r);
                }

                int myTotal = myPresent + myAbsent;
                int myPct   = myTotal > 0 ? (int) Math.round((myPresent * 100.0) / myTotal) : 0;

                request.setAttribute("myAttRecords", myAttRecords);
                request.setAttribute("myPresent",    myPresent);
                request.setAttribute("myAbsent",     myAbsent);
                request.setAttribute("myTotal",      myTotal);
                request.setAttribute("myPct",        myPct);

                // Year summary
                int yearPresent = 0, yearAbsent = 0;
                PreparedStatement yearPs = con.prepareStatement(
                    "SELECT COUNT(*) AS total, " +
                    "SUM(CASE WHEN status='Present' THEN 1 ELSE 0 END) AS present_count, " +
                    "SUM(CASE WHEN status='Absent'  THEN 1 ELSE 0 END) AS absent_count " +
                    "FROM st_teacher_attendance " +
                    "WHERE teacher_id=? AND marked_year=?"
                );
                yearPs.setInt(1, teacher.getTeacher_id());
                yearPs.setInt(2, currentYear);
                ResultSet yearRs = yearPs.executeQuery();
                if (yearRs.next()) {
                    yearPresent = yearRs.getInt("present_count");
                    yearAbsent  = yearRs.getInt("absent_count");
                }
                int yearTotal = yearPresent + yearAbsent;
                int yearPct   = yearTotal > 0 ? (int) Math.round((yearPresent * 100.0) / yearTotal) : 0;

                request.setAttribute("yearPresent", yearPresent);
                request.setAttribute("yearAbsent",  yearAbsent);
                request.setAttribute("yearTotal",   yearTotal);
                request.setAttribute("yearPct",     yearPct);
                request.setAttribute("currentYear", currentYear);
            }

            // ===== STUDENTS ATTENDANCE (class-wise) =====
            if (classIdParam != null && !classIdParam.isEmpty()
                    && !classIdParam.equals("null")) {
                int classId = Integer.parseInt(classIdParam);

                List<Map<String,String>> students = new ArrayList<>();
                PreparedStatement ps = con.prepareStatement(
                    "SELECT student_id, name, roll_number FROM st_student " +
                    "WHERE class_id=? ORDER BY roll_number");
                ps.setInt(1, classId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String,String> s = new HashMap<>();
                    s.put("student_id",  String.valueOf(rs.getInt("student_id")));
                    s.put("name",        rs.getString("name"));
                    s.put("roll_number", String.valueOf(rs.getInt("roll_number")));
                    students.add(s);
                }
                request.setAttribute("students", students);

                // Attendance report
                List<Map<String,String>> report = new ArrayList<>();
                String sql =
                    "SELECT s.student_id, s.name, s.roll_number, " +
                    "COUNT(a.attendance_id) AS total, " +
                    "SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END) AS present_count, " +
                    "SUM(CASE WHEN a.status='Absent'  THEN 1 ELSE 0 END) AS absent_count " +
                    "FROM st_student s " +
                    "LEFT JOIN st_attendance a ON s.student_id=a.student_id " +
                    "WHERE s.class_id=? " +
                    "GROUP BY s.student_id, s.name, s.roll_number " +
                    "ORDER BY s.roll_number";
                PreparedStatement rPs = con.prepareStatement(sql);
                rPs.setInt(1, classId);
                ResultSet rRs = rPs.executeQuery();
                while (rRs.next()) {
                    Map<String,String> r = new HashMap<>();
                    int total   = rRs.getInt("total");
                    int present = rRs.getInt("present_count");
                    int absent  = rRs.getInt("absent_count");
                    double pct  = total > 0 ? (present * 100.0 / total) : 0;
                    r.put("student_id",  String.valueOf(rRs.getInt("student_id")));
                    r.put("name",        rRs.getString("name"));
                    r.put("roll_number", String.valueOf(rRs.getInt("roll_number")));
                    r.put("total",       String.valueOf(total));
                    r.put("present",     String.valueOf(present));
                    r.put("absent",      String.valueOf(absent));
                    r.put("percentage",  String.format("%.1f", pct));
                    report.add(r);
                }
                request.setAttribute("attendanceReport", report);
            }

        } catch (Exception e) { e.printStackTrace(); }
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/teacher/attendance.jsp");
        rd.forward(request, response);
    }
}