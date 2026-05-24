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

@WebServlet("/student/result")
public class StudentResultServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            Connection con  = DBConnection.getConnection();
            StudentDAO dao  = new StudentDAO();
            Student student = dao.getStudentByUsername(username);

            List<Map<String,String>> results = new ArrayList<>();
            if (student != null) {
                String sql = "SELECT r.*, e.total_marks AS max_marks, e.exam_date "
                           + "FROM st_result r LEFT JOIN st_exam e ON r.exam_id = e.exam_id "
                           + "WHERE r.student_id=? ORDER BY r.result_id DESC";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, student.getStudent_id());
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String,String> r = new HashMap<>();
                    r.put("subject",   rs.getString("subject"));
                    r.put("marks",     String.valueOf(rs.getInt("marks")));
                    r.put("max_marks", String.valueOf(rs.getInt("max_marks")));
                    r.put("grade",     rs.getString("grade"));
                    r.put("exam_date", rs.getDate("exam_date") != null ? rs.getDate("exam_date").toString() : "-");
                    results.add(r);
                }
            }
            request.setAttribute("results", results);

        } catch (Exception e) {
            StudentExceptionHandler.handle(request, response,
                new StudentResultException("We could not load your results. Please try again later.", e));
            return;
        }
        request.getRequestDispatcher("/jsp/student/result.jsp").forward(request, response);
    }
}