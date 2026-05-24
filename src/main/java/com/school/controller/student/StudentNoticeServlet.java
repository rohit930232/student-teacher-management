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

@WebServlet("/student/notices")
public class StudentNoticeServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            Connection con  = DBConnection.getConnection();
            StudentDAO dao  = new StudentDAO();
            Student student = dao.getStudentByUsername(username);

            List<Map<String,String>> notices = new ArrayList<>();
            if (student != null) {
                String sql = "SELECT * FROM st_notice WHERE class_id=? OR class_id IS NULL "
                           + "ORDER BY created_date DESC";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, student.getClass_id());
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String,String> n = new HashMap<>();
                    n.put("message", rs.getString("message"));
                    n.put("date",    rs.getDate("created_date") != null ? rs.getDate("created_date").toString() : "");
                    notices.add(n);
                }
            }
            request.setAttribute("notices", notices);

        } catch (Exception e) {
            StudentExceptionHandler.handle(request, response,
                new StudentNoticeException("We could not load notices. Please try again later.", e));
            return;
        }
        request.getRequestDispatcher("/jsp/student/notices.jsp").forward(request, response);
    }
}