package com.school.controller.student;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import com.school.dao.student.StudentDAO;
import com.school.model.student.Student;
import com.school.util.DBConnection;

@WebServlet("/student/assignment/submit")
@MultipartConfig(fileSizeThreshold = 1024*1024, maxFileSize = 10*1024*1024)
public class StudentAssignmentSubmitServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            StudentDAO dao = new StudentDAO();
            Student student = dao.getStudentByUsername(username);

            int assignmentId = Integer.parseInt(request.getParameter("assignment_id"));
            String remarks   = request.getParameter("remarks");

            // File upload
            String filePath = null;
            Part filePart = request.getPart("submission_file");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName  = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadDir = getServletContext().getRealPath("/uploads/submissions/");
                new File(uploadDir).mkdirs();
                filePart.write(uploadDir + File.separator + fileName);
                filePath = "uploads/submissions/" + fileName;
            } else {
                response.sendRedirect(request.getContextPath() + "/student/assignments?error=nofile");
                return;
            }

            Connection con = DBConnection.getConnection();

            // Check already submitted
            PreparedStatement checkPs = con.prepareStatement(
                "SELECT submission_id FROM st_assignment_submission WHERE assignment_id=? AND student_id=?"
            );
            checkPs.setInt(1, assignmentId);
            checkPs.setInt(2, student.getStudent_id());
            ResultSet checkRs = checkPs.executeQuery();

            if (checkRs.next()) {
                // Already submitted — update
                PreparedStatement updatePs = con.prepareStatement(
                    "UPDATE st_assignment_submission SET file_path=?, submitted_date=SYSDATE, remarks=? WHERE assignment_id=? AND student_id=?"
                );
                updatePs.setString(1, filePath);
                updatePs.setString(2, remarks);
                updatePs.setInt(3, assignmentId);
                updatePs.setInt(4, student.getStudent_id());
                updatePs.executeUpdate();
            } else {
                // New submission
                PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO st_assignment_submission (submission_id, assignment_id, student_id, file_path, submitted_date, remarks) " +
                    "VALUES (st_submission_seq.NEXTVAL, ?, ?, ?, SYSDATE, ?)"
                );
                ps.setInt(1, assignmentId);
                ps.setInt(2, student.getStudent_id());
                ps.setString(3, filePath);
                ps.setString(4, remarks);
                ps.executeUpdate();
            }

            response.sendRedirect(request.getContextPath() + "/student/assignments?success=submitted");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/student/assignments?error=failed");
        }
    }
}