package com.school.controller.teacher;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.teacher.TeacherDAO;
import com.school.model.teacher.Teacher;
import com.school.util.DBConnection;

@WebServlet("/teacher/profile")
public class TeacherProfileServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            TeacherDAO dao = new TeacherDAO();
            Teacher teacher = dao.getTeacherByUsername(username);
            request.setAttribute("teacher", teacher);

            if (teacher != null && teacher.getClass_id() > 0) {
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement("SELECT class_name FROM st_class WHERE class_id=?");
                ps.setInt(1, teacher.getClass_id());
                ResultSet rs = ps.executeQuery();
                if (rs.next()) request.setAttribute("className", rs.getString("class_name"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/teacher/profile.jsp");
        rd.forward(request, response);
    }
}