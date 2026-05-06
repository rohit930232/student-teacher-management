package com.school.controller.student;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.util.DBConnection;
import com.school.exception.student.*;

@WebServlet("/student/notices")
public class StudentNoticeServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM st_notice ORDER BY created_date DESC");
            ResultSet rs = ps.executeQuery();
            List<Map<String,String>> notices = new ArrayList<>();
            while (rs.next()) {
                Map<String,String> n = new HashMap<>();
                n.put("message", rs.getString("message"));
                n.put("date", rs.getDate("created_date") != null ? rs.getDate("created_date").toString() : "");
                notices.add(n);
            }
            request.setAttribute("notices", notices);
        } catch (Exception e) { 
        	StudentExceptionHandler.handle(request, response,
                new StudentNoticeException("We could not load the school notices. Please try again later.", e));
        return;
        }
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/student/notices.jsp");
        rd.forward(request, response);
    }
}