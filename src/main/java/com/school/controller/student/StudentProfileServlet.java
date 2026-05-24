package com.school.controller.student;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.student.StudentDAO;
import com.school.model.student.Student;
import com.school.util.DBConnection;
import com.school.exception.student.*;

@WebServlet("/student/profile")
public class StudentProfileServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            Connection con  = DBConnection.getConnection();
            StudentDAO dao  = new StudentDAO();
            Student student = dao.getStudentByUsername(username);

            String className = "";
            if (student != null && student.getClass_id() > 0) {
                PreparedStatement ps = con.prepareStatement(
                    "SELECT class_name FROM st_class WHERE class_id=?");
                ps.setInt(1, student.getClass_id());
                ResultSet rs = ps.executeQuery();
                if (rs.next()) className = rs.getString("class_name");
            }
            request.setAttribute("student",   student);
            request.setAttribute("className", className);

        } catch (Exception e) {
            StudentExceptionHandler.handle(request, response,
                new StudentProfileException("We could not load your profile. Please try again later.", e));
            return;
        }
        request.getRequestDispatcher("/jsp/student/profile.jsp").forward(request, response);
    }
}