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
import com.school.exception.student.*;

@WebServlet("/student/timetable")
public class StudentTimetableServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            Connection con = DBConnection.getConnection();
            StudentDAO dao = new StudentDAO();
            Student student = dao.getStudentByUsername(username);

            Map<String,List<Map<String,String>>> timetableByDay = new LinkedHashMap<>();
            if (student != null && student.getClass_id() > 0) {
                String sql = "SELECT * FROM st_timetable WHERE class_id=? ORDER BY CASE day WHEN 'Monday' THEN 1 WHEN 'Tuesday' THEN 2 WHEN 'Wednesday' THEN 3 WHEN 'Thursday' THEN 4 WHEN 'Friday' THEN 5 WHEN 'Saturday' THEN 6 ELSE 7 END, start_time";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, student.getClass_id());
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    String day = rs.getString("day");
                    Map<String,String> slot = new HashMap<>();
                    slot.put("subject", rs.getString("subject"));
                    slot.put("start_time", rs.getString("start_time"));
                    slot.put("end_time", rs.getString("end_time"));
                    timetableByDay.computeIfAbsent(day, k -> new ArrayList<>()).add(slot);
                }
            }
            request.setAttribute("timetableByDay", timetableByDay);
        } catch (Exception e) {
        	 StudentExceptionHandler.handle(request, response,
        		        new StudentTimetableException("We could not load your timetable. Please try again after some time.", e));
        		    return; 
        	}
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/student/timetable.jsp");
        rd.forward(request, response);
    }
}