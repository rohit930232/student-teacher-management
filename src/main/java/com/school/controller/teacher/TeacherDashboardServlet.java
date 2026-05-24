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

@WebServlet("/teacher/dashboard")
public class TeacherDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            Connection con = DBConnection.getConnection();
            TeacherDAO dao = new TeacherDAO();
            Teacher teacher = dao.getTeacherByUsername(username);
            request.setAttribute("teacher", teacher);

            if (teacher != null && teacher.getClass_id() > 0) {
                PreparedStatement ps = con.prepareStatement(
                    "SELECT class_name FROM st_class WHERE class_id=?");
                ps.setInt(1, teacher.getClass_id());
                ResultSet rs = ps.executeQuery();
                if (rs.next()) request.setAttribute("className", rs.getString("class_name"));
            }

            int totalStudents = 0;
            if (teacher != null) {
                PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM st_student WHERE class_id=?");
                ps.setInt(1, teacher.getClass_id());
                ResultSet rs = ps.executeQuery();
                if (rs.next()) totalStudents = rs.getInt(1);
            }
            request.setAttribute("totalStudents", totalStudents);

            String subject = teacher != null ? teacher.getSubject() : "";
            int totalSubjects = 0;
            if (subject != null && !subject.trim().isEmpty())
                totalSubjects = subject.split(",").length;
            request.setAttribute("totalSubjects", totalSubjects);
            request.setAttribute("subjectList", subject);

            // ===== TEACHER KI APNI ATTENDANCE (st_teacher_attendance se) =====
            int teacherPresent = 0, teacherAbsent = 0, teacherTotal = 0;
            int currentYear = Calendar.getInstance().get(Calendar.YEAR);
            if (teacher != null) {
                PreparedStatement attPs = con.prepareStatement(
                    "SELECT COUNT(*) AS total, " +
                    "SUM(CASE WHEN status='Present' THEN 1 ELSE 0 END) AS present_count, " +
                    "SUM(CASE WHEN status='Absent'  THEN 1 ELSE 0 END) AS absent_count " +
                    "FROM st_teacher_attendance " +
                    "WHERE teacher_id=? AND marked_year=?"
                );
                attPs.setInt(1, teacher.getTeacher_id());
                attPs.setInt(2, currentYear);
                ResultSet attRs = attPs.executeQuery();
                if (attRs.next()) {
                    teacherTotal   = attRs.getInt("total");
                    teacherPresent = attRs.getInt("present_count");
                    teacherAbsent  = attRs.getInt("absent_count");
                }
            }
            int teacherAttPct = teacherTotal > 0
                ? (int) Math.round((teacherPresent * 100.0) / teacherTotal) : 0;
            request.setAttribute("teacherAttPercent", teacherAttPct);
            request.setAttribute("teacherPresent",    teacherPresent);
            request.setAttribute("teacherAbsent",     teacherAbsent);
            request.setAttribute("teacherTotal",      teacherTotal);

            // Student attendance (class ki)
            int studentAttPct = 0;
            if (teacher != null && teacher.getClass_id() > 0) {
                PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) AS total, " +
                    "SUM(CASE WHEN status='Present' THEN 1 ELSE 0 END) AS present_count " +
                    "FROM st_attendance WHERE class_id=?");
                ps.setInt(1, teacher.getClass_id());
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    int t = rs.getInt("total"), p = rs.getInt("present_count");
                    if (t > 0) studentAttPct = (int) Math.round((p * 100.0) / t);
                }
            }
            request.setAttribute("attendancePercent", studentAttPct);

            List<Map<String,String>> assignments = new ArrayList<>();
            if (teacher != null) {
                PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM st_assignment WHERE teacher_id=? ORDER BY upload_date DESC FETCH FIRST 5 ROWS ONLY");
                ps.setInt(1, teacher.getTeacher_id());
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String,String> a = new HashMap<>();
                    a.put("title",       rs.getString("title"));
                    a.put("upload_date", rs.getDate("upload_date") != null ? rs.getDate("upload_date").toString() : "");
                    assignments.add(a);
                }
            }
            request.setAttribute("assignments",    assignments);
            request.setAttribute("assignmentCount", assignments.size());

            List<Map<String,String>> notices = new ArrayList<>();
            PreparedStatement nPs = con.prepareStatement(
                "SELECT * FROM st_notice ORDER BY created_date DESC FETCH FIRST 3 ROWS ONLY");
            ResultSet nRs = nPs.executeQuery();
            while (nRs.next()) {
                Map<String,String> n = new HashMap<>();
                n.put("message", nRs.getString("message"));
                n.put("date",    nRs.getDate("created_date") != null ? nRs.getDate("created_date").toString() : "");
                notices.add(n);
            }
            request.setAttribute("notices", notices);

            List<Map<String,String>> notifications = new ArrayList<>();
            PreparedStatement ntPs = con.prepareStatement(
                "SELECT * FROM st_notification ORDER BY created_date DESC FETCH FIRST 3 ROWS ONLY");
            ResultSet ntRs = ntPs.executeQuery();
            while (ntRs.next()) {
                Map<String,String> n = new HashMap<>();
                n.put("message", ntRs.getString("message"));
                n.put("date",    ntRs.getDate("created_date") != null ? ntRs.getDate("created_date").toString() : "");
                notifications.add(n);
            }
            request.setAttribute("notifications", notifications);

        } catch (Exception e) { e.printStackTrace(); }
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/teacher/dashboard.jsp");
        rd.forward(request, response);
    }
}