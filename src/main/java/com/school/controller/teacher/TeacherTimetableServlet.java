package com.school.controller.teacher;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminTimetableGridDAO;
import com.school.util.DBConnection;

@WebServlet("/teacher/timetable")
public class TeacherTimetableServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection con = DBConnection.getConnection();
            String classIdParam = request.getParameter("class_id");

            List<Map<String,String>> classes = new ArrayList<>();
            PreparedStatement cPs = con.prepareStatement("SELECT * FROM st_class ORDER BY class_name");
            ResultSet cRs = cPs.executeQuery();
            while (cRs.next()) {
                Map<String,String> c = new HashMap<>();
                c.put("class_id",   String.valueOf(cRs.getInt("class_id")));
                c.put("class_name", cRs.getString("class_name"));
                classes.add(c);
            }
            request.setAttribute("classes", classes);

            if (classIdParam != null && !classIdParam.isEmpty()) {
                int classId = Integer.parseInt(classIdParam);

                // Period mode timetable
                Map<String,List<Map<String,String>>> timetableByDay = new LinkedHashMap<>();
                String sql = "SELECT t.*, te.name AS teacher_name FROM st_timetable t " +
                             "LEFT JOIN st_teacher te ON t.teacher_id=te.teacher_id " +
                             "WHERE t.class_id=? " +
                             "ORDER BY CASE t.day WHEN 'Monday' THEN 1 WHEN 'Tuesday' THEN 2 " +
                             "WHEN 'Wednesday' THEN 3 WHEN 'Thursday' THEN 4 " +
                             "WHEN 'Friday' THEN 5 WHEN 'Saturday' THEN 6 ELSE 7 END, t.start_time";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, classId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    String day = rs.getString("day");
                    Map<String,String> slot = new HashMap<>();
                    slot.put("subject",      rs.getString("subject"));
                    slot.put("start_time",   rs.getString("start_time"));
                    slot.put("end_time",     rs.getString("end_time"));
                    slot.put("teacher_name", rs.getString("teacher_name") != null ? rs.getString("teacher_name") : "");
                    timetableByDay.computeIfAbsent(day, k -> new ArrayList<>()).add(slot);
                }
                request.setAttribute("timetableByDay", timetableByDay);

                // Grid timetables from admin
                AdminTimetableGridDAO gridDao = new AdminTimetableGridDAO();
                List<Map<String,String>> gridList = gridDao.getGridsByClass(classId);
                request.setAttribute("gridList", gridList);
            }
        } catch (Exception e) { e.printStackTrace(); }
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/teacher/timetable.jsp");
        rd.forward(request, response);
    }
}