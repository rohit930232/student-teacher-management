package com.school.controller.teacher;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.util.DBConnection;

@WebServlet("/teacher/assignments/delete")
public class TeacherAssignmentDeleteServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String classId = request.getParameter("class_id");
        try {
            int assignmentId = Integer.parseInt(request.getParameter("assignment_id"));
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("DELETE FROM st_assignment WHERE assignment_id=?");
            ps.setInt(1, assignmentId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect(request.getContextPath() + "/teacher/assignments?class_id=" + classId);
    }
}