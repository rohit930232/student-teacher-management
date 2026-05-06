package com.school.controller.student;
import com.school.exception.student.*;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.student.StudentDAO;
import com.school.model.student.Student;
import com.school.util.DBConnection;

@WebServlet("/student/profile")
public class StudentProfileServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            StudentDAO dao = new StudentDAO();
            Student student = dao.getStudentByUsername(username);
            request.setAttribute("student", student);

            if (student != null && student.getClass_id() > 0) {
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement("SELECT class_name FROM st_class WHERE class_id=?");
                ps.setInt(1, student.getClass_id());
                ResultSet rs = ps.executeQuery();
                if (rs.next()) request.setAttribute("className", rs.getString("class_name"));
            }
        } catch (Exception e) { 
        	 StudentExceptionHandler.handle(request, response,
        		        new StudentProfileException("We could not load your profile information. Please refresh the page or try again later.", e));
        		    return;
        	}
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/student/profile.jsp");
        rd.forward(request, response);
    }
}