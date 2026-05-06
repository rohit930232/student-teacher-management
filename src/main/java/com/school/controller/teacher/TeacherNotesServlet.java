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

@WebServlet("/teacher/notes")
public class TeacherNotesServlet extends HttpServlet {

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

            if (classIdParam != null && !classIdParam.isEmpty() && teacher != null) {
                int classId = Integer.parseInt(classIdParam);
                List<Map<String,String>> notes = new ArrayList<>();
                PreparedStatement ps = con.prepareStatement("SELECT * FROM st_notes WHERE teacher_id=? AND class_id=? ORDER BY created_date DESC");
                ps.setInt(1, teacher.getTeacher_id());
                ps.setInt(2, classId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String,String> n = new HashMap<>();
                    n.put("note_id",      String.valueOf(rs.getInt("note_id")));
                    n.put("title",        rs.getString("title"));
                    n.put("subject",      rs.getString("subject")   != null ? rs.getString("subject")   : "");
                    n.put("link",         rs.getString("link")      != null ? rs.getString("link")      : "");
                    n.put("file_path",    rs.getString("file_path") != null ? rs.getString("file_path") : "");
                    n.put("created_date", rs.getDate("created_date") != null ? rs.getDate("created_date").toString() : "");
                    notes.add(n);
                }
                request.setAttribute("notes", notes);
            }
        } catch (Exception e) { e.printStackTrace(); }
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/teacher/notes.jsp");
        rd.forward(request, response);
    }
}