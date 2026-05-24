package com.school.controller.teacher;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.util.DBConnection;

@WebServlet("/teacher/onlineclass/delete")
public class TeacherOnlineClassDeleteServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String classId = request.getParameter("class_id");
        try {
            String ocId = request.getParameter("class_id_oc");
            System.out.println("Deleting online class id: " + ocId);
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "DELETE FROM st_online_class WHERE online_class_id=?"
            );
            ps.setInt(1, Integer.parseInt(ocId));
            int rows = ps.executeUpdate();
            System.out.println("Deleted rows: " + rows);
        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect(request.getContextPath() + "/teacher/onlineclass?class_id=" + classId);
    }
}