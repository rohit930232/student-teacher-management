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

@WebServlet("/student/onlineclass")
public class StudentOnlineClassServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            Connection con = DBConnection.getConnection();
            StudentDAO dao = new StudentDAO();
            Student student = dao.getStudentByUsername(username);

            List<Map<String,String>> liveClasses = new ArrayList<>();
            List<Map<String,String>> upcomingClasses = new ArrayList<>();

            if (student != null && student.getClass_id() > 0) {
                String sql = "SELECT oc.*, t.name AS teacher_name FROM st_online_class oc LEFT JOIN st_teacher t ON oc.teacher_id=t.teacher_id WHERE oc.class_id=? ORDER BY oc.start_time";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, student.getClass_id());
                ResultSet rs = ps.executeQuery();
                java.util.Date now = new java.util.Date();
                while (rs.next()) {
                    Map<String,String> c = new HashMap<>();
                    c.put("subject", rs.getString("subject"));
                    c.put("teacher_name", rs.getString("teacher_name") != null ? rs.getString("teacher_name") : "Teacher");
                    c.put("class_link", rs.getString("class_link") != null ? rs.getString("class_link") : "#");
                    c.put("start_time", rs.getTimestamp("start_time") != null ? rs.getTimestamp("start_time").toString() : "");
                    c.put("end_time",   rs.getTimestamp("end_time")   != null ? rs.getTimestamp("end_time").toString()   : "");
                    String status = rs.getString("status");
                    if ("Live".equalsIgnoreCase(status)) {
                        liveClasses.add(c);
                    } else {
                        upcomingClasses.add(c);
                    }
                }
            }
            request.setAttribute("liveClasses", liveClasses);
            request.setAttribute("upcomingClasses", upcomingClasses);
        } catch (Exception e) {  
        	 StudentExceptionHandler.handle(request, response,
        		        new StudentOnlineClassException("We could not load your online class details. Please try again later.", e));
        		    return;
        }
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/student/onlineclass.jsp");
        rd.forward(request, response);
    }
}