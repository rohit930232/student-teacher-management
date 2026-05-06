package com.school.controller.teacher;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import com.school.dao.teacher.TeacherDAO;
import com.school.model.teacher.Teacher;
import com.school.util.DBConnection;

@WebServlet("/teacher/notes/upload")
@MultipartConfig(fileSizeThreshold = 1024*1024, maxFileSize = 10*1024*1024)
public class TeacherNotesUploadServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String classId = request.getParameter("class_id");
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            TeacherDAO dao = new TeacherDAO();
            Teacher teacher = dao.getTeacherByUsername(username);

            String title   = request.getParameter("title");
            String subject = request.getParameter("subject");
            String link    = request.getParameter("link");

            String filePath = null;
            Part filePart = request.getPart("file");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadDir = getServletContext().getRealPath("/uploads/notes/");
                new File(uploadDir).mkdirs();
                filePart.write(uploadDir + File.separator + fileName);
                filePath = "uploads/notes/" + fileName;
            }

            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("INSERT INTO st_notes (note_id, teacher_id, class_id, subject, title, link, file_path, created_date) VALUES (st_notes_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, SYSDATE)");
            ps.setInt(1, teacher.getTeacher_id());
            ps.setInt(2, Integer.parseInt(classId));
            ps.setString(3, subject);
            ps.setString(4, title);
            ps.setString(5, link != null && !link.isEmpty() ? link : null);
            ps.setString(6, filePath);
            ps.executeUpdate();

        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect(request.getContextPath() + "/teacher/notes?class_id=" + classId);
    }
}