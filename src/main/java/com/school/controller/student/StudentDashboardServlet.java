package com.school.controller.student;
import com.school.exception.student.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.student.StudentDAO;
import com.school.model.student.Student;
import com.school.util.DBConnection;

@WebServlet("/student/dashboard")
public class StudentDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            Connection con = DBConnection.getConnection();
            StudentDAO dao = new StudentDAO();
            Student student = dao.getStudentByUsername(username);

            if (student == null) { response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return; }

            String classNameStr = "";
            String subjects = "";
            if (student.getClass_id() > 0) {
                PreparedStatement ps = con.prepareStatement("SELECT class_name FROM st_class WHERE class_id=?");
                ps.setInt(1, student.getClass_id());
                ResultSet rs = ps.executeQuery();
                if (rs.next()) classNameStr = rs.getString("class_name");

                PreparedStatement tps = con.prepareStatement("SELECT DISTINCT subject FROM st_timetable WHERE class_id=?");
                tps.setInt(1, student.getClass_id());
                ResultSet trs = tps.executeQuery();
                StringBuilder sb = new StringBuilder();
                while (trs.next()) { if (sb.length() > 0) sb.append(","); sb.append(trs.getString("subject")); }
                subjects = sb.toString();
            }
            request.setAttribute("className", classNameStr);
            request.setAttribute("subjects", subjects);

            int attTotal = 0, attPresent = 0;
            PreparedStatement attPs = con.prepareStatement("SELECT COUNT(*) AS total, SUM(CASE WHEN status='Present' THEN 1 ELSE 0 END) AS present_count FROM st_attendance WHERE student_id=?");
            attPs.setInt(1, student.getStudent_id());
            ResultSet attRs = attPs.executeQuery();
            if (attRs.next()) { attTotal = attRs.getInt("total"); attPresent = attRs.getInt("present_count"); }
            int attPct = attTotal > 0 ? (int) Math.round(attPresent * 100.0 / attTotal) : 0;
            request.setAttribute("attendancePercent", attPct);

            PreparedStatement examPs = con.prepareStatement("SELECT subject, exam_date FROM st_exam WHERE class_id=? AND exam_date >= SYSDATE ORDER BY exam_date FETCH FIRST 1 ROW ONLY");
            examPs.setInt(1, student.getClass_id());
            ResultSet examRs = examPs.executeQuery();
            if (examRs.next()) {
                request.setAttribute("upcomingExam", examRs.getString("subject"));
                request.setAttribute("upcomingExamDate", examRs.getDate("exam_date").toString());
            } else {
                request.setAttribute("upcomingExam", "No Exam");
                request.setAttribute("upcomingExamDate", "");
            }

            request.setAttribute("feesRemaining", student.getFees_remaining());

            PreparedStatement aPs = con.prepareStatement("SELECT * FROM st_assignment WHERE class_id=? ORDER BY upload_date DESC FETCH FIRST 5 ROWS ONLY");
            aPs.setInt(1, student.getClass_id());
            ResultSet aRs = aPs.executeQuery();
            List<Map<String,String>> assignments = new ArrayList<>();
            while (aRs.next()) {
                Map<String,String> a = new HashMap<>();
                a.put("title", aRs.getString("title"));
                a.put("upload_date", aRs.getDate("upload_date") != null ? aRs.getDate("upload_date").toString() : "");
                assignments.add(a);
            }
            request.setAttribute("assignments", assignments);
            request.setAttribute("assignmentCount", assignments.size());

            String today = new java.text.SimpleDateFormat("EEEE").format(new java.util.Date());
            PreparedStatement ttPs = con.prepareStatement("SELECT * FROM st_timetable WHERE class_id=? AND day=? ORDER BY start_time");
            ttPs.setInt(1, student.getClass_id());
            ttPs.setString(2, today);
            ResultSet ttRs = ttPs.executeQuery();
            List<Map<String,String>> todaySchedule = new ArrayList<>();
            while (ttRs.next()) {
                Map<String,String> s = new HashMap<>();
                s.put("subject", ttRs.getString("subject"));
                s.put("start_time", ttRs.getString("start_time"));
                s.put("end_time", ttRs.getString("end_time"));
                todaySchedule.add(s);
            }
            request.setAttribute("todaySchedule", todaySchedule);

            PreparedStatement notiPs = con.prepareStatement("SELECT * FROM st_notification ORDER BY created_date DESC FETCH FIRST 3 ROWS ONLY");
            ResultSet notiRs = notiPs.executeQuery();
            List<Map<String,String>> notifications = new ArrayList<>();
            while (notiRs.next()) {
                Map<String,String> n = new HashMap<>();
                n.put("message", notiRs.getString("message"));
                n.put("date", notiRs.getDate("created_date") != null ? notiRs.getDate("created_date").toString() : "");
                notifications.add(n);
            }
            request.setAttribute("notifications", notifications);

            PreparedStatement rPs = con.prepareStatement("SELECT r.*, e.total_marks AS max_marks FROM st_result r LEFT JOIN st_exam e ON r.exam_id=e.exam_id WHERE r.student_id=? ORDER BY r.result_id DESC FETCH FIRST 3 ROWS ONLY");
            rPs.setInt(1, student.getStudent_id());
            ResultSet rRs = rPs.executeQuery();
            List<Map<String,String>> results = new ArrayList<>();
            while (rRs.next()) {
                Map<String,String> r = new HashMap<>();
                r.put("subject", rRs.getString("subject"));
                r.put("marks", String.valueOf(rRs.getInt("marks")));
                r.put("max_marks", String.valueOf(rRs.getInt("max_marks")));
                r.put("grade", rRs.getString("grade"));
                results.add(r);
            }
            request.setAttribute("recentResults", results);

        } catch (Exception e) {
        	StudentExceptionHandler.handle(request, response,
                new StudentDashboardException("We could not load your dashboard details. Please try again after some time.", e));
        return;
}
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/student/dashboard.jsp");
        rd.forward(request, response);
    }
}