package com.school.controller.teacher;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.teacher.TeacherDAO;
import com.school.model.teacher.Teacher;
import com.school.util.DBConnection;

@WebServlet("/teacher/onlineclass")
public class TeacherOnlineClassServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            Connection con = DBConnection.getConnection();
            TeacherDAO dao = new TeacherDAO();
            Teacher teacher = dao.getTeacherByUsername(username);
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
                List<Map<String,String>> liveClasses     = new ArrayList<>();
                List<Map<String,String>> upcomingClasses = new ArrayList<>();

                String sql = "SELECT oc.*, t.name AS teacher_name " +
                             "FROM st_online_class oc " +
                             "LEFT JOIN st_teacher t ON oc.teacher_id = t.teacher_id " +
                             "WHERE oc.class_id = ? " +
                             "ORDER BY oc.start_time";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, classId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String,String> c = new HashMap<>();
                    c.put("online_class_id", String.valueOf(rs.getInt("online_class_id")));
                    c.put("subject",         rs.getString("subject"));
                    c.put("teacher_name",    rs.getString("teacher_name") != null ? rs.getString("teacher_name") : "Teacher");
                    c.put("class_link",      rs.getString("class_link")   != null ? rs.getString("class_link")   : "#");
                    c.put("start_time",      rs.getTimestamp("start_time") != null ? rs.getTimestamp("start_time").toString() : "");
                    c.put("end_time",        rs.getTimestamp("end_time")   != null ? rs.getTimestamp("end_time").toString()   : "");
                    String status = rs.getString("status");
                    c.put("status", status != null ? status : "Upcoming");
                    if ("Live".equalsIgnoreCase(status)) {
                        liveClasses.add(c);
                    } else {
                        upcomingClasses.add(c);
                    }
                }
                request.setAttribute("liveClasses",     liveClasses);
                request.setAttribute("upcomingClasses", upcomingClasses);
            }
        } catch (Exception e) { e.printStackTrace(); }
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/teacher/onlineclass.jsp");
        rd.forward(request, response);
    }
}