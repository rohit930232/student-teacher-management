package com.school.controller.teacher;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.school.model.teacher.Teacher;
import com.school.dao.teacher.TeacherDAO;
import com.school.util.DBConnection;

@WebServlet("/teacher/dashboard")
public class TeacherDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String username = (String) session.getAttribute("username");
        try {
            Connection con = DBConnection.getConnection();
            TeacherDAO dao = new TeacherDAO();
            Teacher teacher = dao.getTeacherByUsername(username);
            request.setAttribute("teacher", teacher);
            if (teacher != null && teacher.getClass_id() > 0) {
                String classSql = "SELECT class_name FROM st_class WHERE class_id = ?";
                PreparedStatement classPs = con.prepareStatement(classSql);
                classPs.setInt(1, teacher.getClass_id());
                ResultSet classRs = classPs.executeQuery();
                if (classRs.next()) {
                    request.setAttribute("className", classRs.getString("class_name"));
                }
            }
            int totalStudents = 0;
            if (teacher != null) {
                String studentSql = "SELECT COUNT(*) FROM st_student WHERE class_id = ?";
                PreparedStatement studentPs = con.prepareStatement(studentSql);
                studentPs.setInt(1, teacher.getClass_id());
                ResultSet studentRs = studentPs.executeQuery();
                if (studentRs.next()) {
                    totalStudents = studentRs.getInt(1);
                }
            }
            request.setAttribute("totalStudents", totalStudents);
            String subject = teacher != null ? teacher.getSubject() : "";
            int totalSubjects = 0;
            if (subject != null && !subject.trim().isEmpty()) {
                totalSubjects = subject.split(",").length;
            }
            request.setAttribute("totalSubjects", totalSubjects);
            request.setAttribute("subjectList", subject);
            int attendancePercent = 0;
            if (teacher != null && teacher.getClass_id() > 0) {
                String attSql = "SELECT COUNT(*) AS total, " +
                    "SUM(CASE WHEN status = 'Present' THEN 1 ELSE 0 END) AS present_count " +
                    "FROM st_attendance WHERE class_id = ?";
                PreparedStatement attPs = con.prepareStatement(attSql);
                attPs.setInt(1, teacher.getClass_id());
                ResultSet attRs = attPs.executeQuery();
                if (attRs.next()) {
                    int total   = attRs.getInt("total");
                    int present = attRs.getInt("present_count");
                    if (total > 0) {
                        attendancePercent = (int) Math.round((present * 100.0) / total);
                    }
                }
            }
            request.setAttribute("attendancePercent", attendancePercent);
            List<Map<String, String>> assignments = new ArrayList<>();
            if (teacher != null) {
                String assignSql = "SELECT * FROM st_assignment WHERE teacher_id = ? " +
                    "ORDER BY upload_date DESC FETCH FIRST 5 ROWS ONLY";
                PreparedStatement assignPs = con.prepareStatement(assignSql);
                assignPs.setInt(1, teacher.getTeacher_id());
                ResultSet assignRs = assignPs.executeQuery();
                while (assignRs.next()) {
                    Map<String, String> a = new HashMap<>();
                    a.put("title",       assignRs.getString("title"));
                    a.put("description", assignRs.getString("description"));
                    a.put("upload_date", assignRs.getString("upload_date"));
                    assignments.add(a);
                }
            }
            request.setAttribute("assignments", assignments);
            request.setAttribute("assignmentCount", assignments.size());
            List<Map<String, String>> notices = new ArrayList<>();
            String noticeSql = "SELECT * FROM st_notice ORDER BY created_date DESC FETCH FIRST 3 ROWS ONLY";
            PreparedStatement noticePs = con.prepareStatement(noticeSql);
            ResultSet noticeRs = noticePs.executeQuery();
            while (noticeRs.next()) {
                Map<String, String> n = new HashMap<>();
                n.put("message", noticeRs.getString("message"));
                n.put("date",    noticeRs.getString("created_date"));
                notices.add(n);
            }
            request.setAttribute("notices", notices);
            List<Map<String, String>> notifications = new ArrayList<>();
            String notiSql = "SELECT * FROM st_notification ORDER BY created_date DESC FETCH FIRST 3 ROWS ONLY";
            PreparedStatement notiPs = con.prepareStatement(notiSql);
            ResultSet notiRs = notiPs.executeQuery();
            while (notiRs.next()) {
                Map<String, String> n = new HashMap<>();
                n.put("message", notiRs.getString("message"));
                n.put("date",    notiRs.getString("created_date"));
                notifications.add(n);
            }
            request.setAttribute("notifications", notifications);

        } catch (Exception e) {
            e.printStackTrace();
        }

        RequestDispatcher rd = request.getRequestDispatcher("/jsp/teacher/dashboard.jsp");
        rd.forward(request, response);
    }
}
