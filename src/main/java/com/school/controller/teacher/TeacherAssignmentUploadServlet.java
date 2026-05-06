package com.school.controller.teacher;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import com.school.dao.teacher.TeacherDAO;
import com.school.model.teacher.Teacher;
import com.school.util.DBConnection;

@WebServlet("/teacher/assignments/upload")
@MultipartConfig(fileSizeThreshold = 1024*1024, maxFileSize = 10*1024*1024)
public class TeacherAssignmentUploadServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String classId = request.getParameter("class_id");
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            TeacherDAO dao = new TeacherDAO();
            Teacher teacher = dao.getTeacherByUsername(username);

            String title       = request.getParameter("title");
            String description = request.getParameter("description");
            String deadline    = request.getParameter("deadline");

            String filePath = null;
            Part filePart = request.getPart("file");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadDir = getServletContext().getRealPath("/uploads/assignments/");
                new File(uploadDir).mkdirs();
                filePart.write(uploadDir + File.separator + fileName);
                filePath = "uploads/assignments/" + fileName;
            }

            Connection con = DBConnection.getConnection();
            String sql = "INSERT INTO st_assignment (assignment_id, teacher_id, class_id, title, description, file_path, upload_date, deadline) VALUES (st_assignment_seq.NEXTVAL, ?, ?, ?, ?, ?, SYSDATE, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, teacher.getTeacher_id());
            ps.setInt(2, Integer.parseInt(classId));
            ps.setString(3, title);
            ps.setString(4, description);
            ps.setString(5, filePath);
            ps.setDate(6, deadline != null && !deadline.isEmpty() ? java.sql.Date.valueOf(deadline) : null);
            ps.executeUpdate();

        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect(request.getContextPath() + "/teacher/assignments?class_id=" + classId);
    }
}