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

@WebServlet("/student/timetable")
public class StudentTimetableServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            Connection con  = DBConnection.getConnection();
            StudentDAO dao  = new StudentDAO();
            Student student = dao.getStudentByUsername(username);

            Map<String, List<Map<String,String>>> timetableByDay = new LinkedHashMap<>();
            if (student != null && student.getClass_id() > 0) {
                String sql = "SELECT tt.*, t.name AS teacher_name FROM st_timetable tt "
                           + "LEFT JOIN st_teacher t ON tt.teacher_id = t.teacher_id "
                           + "WHERE tt.class_id=? ORDER BY tt.day, tt.start_time";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, student.getClass_id());
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    String day = rs.getString("day");
                    Map<String,String> slot = new HashMap<>();
                    slot.put("subject",      rs.getString("subject"));
                    slot.put("start_time",   rs.getString("start_time"));
                    slot.put("end_time",     rs.getString("end_time"));
                    slot.put("teacher_name", rs.getString("teacher_name") != null ? rs.getString("teacher_name") : "-");
                    timetableByDay.computeIfAbsent(day, k -> new ArrayList<>()).add(slot);
                }
            }
            request.setAttribute("timetableByDay", timetableByDay);

        } catch (Exception e) {
            StudentExceptionHandler.handle(request, response,
                new StudentTimetableException("We could not load your timetable. Please try again later.", e));
            return;
        }
        request.getRequestDispatcher("/jsp/student/timetable.jsp").forward(request, response);
    }
}