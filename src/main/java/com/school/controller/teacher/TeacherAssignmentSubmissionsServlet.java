package com.school.controller.teacher;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.util.DBConnection;

@WebServlet("/teacher/assignment/submissions")
public class TeacherAssignmentSubmissionsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int assignmentId  = Integer.parseInt(request.getParameter("assignment_id"));
            String classId    = request.getParameter("class_id");
            String assignTitle = request.getParameter("title");

            Connection con = DBConnection.getConnection();

            // Assignment info
            request.setAttribute("assignmentId",  assignmentId);
            request.setAttribute("assignTitle",    assignTitle);
            request.setAttribute("classId",        classId);

            // All students in class with submission status
            String sql =
                "SELECT s.student_id, s.name, s.roll_number, s.photo, " +
                "sub.submission_id, sub.file_path AS submitted_file, " +
                "sub.submitted_date, sub.remarks " +
                "FROM st_student s " +
                "LEFT JOIN st_assignment_submission sub " +
                "  ON s.student_id = sub.student_id AND sub.assignment_id = ? " +
                "WHERE s.class_id = (SELECT class_id FROM st_assignment WHERE assignment_id = ?) " +
                "ORDER BY s.roll_number";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, assignmentId);
            ps.setInt(2, assignmentId);
            ResultSet rs = ps.executeQuery();

            List<Map<String,String>> submissions = new ArrayList<>();
            int submittedCount = 0;
            int pendingCount   = 0;

            while (rs.next()) {
                Map<String,String> sub = new HashMap<>();
                sub.put("student_id",     String.valueOf(rs.getInt("student_id")));
                sub.put("name",           rs.getString("name"));
                sub.put("roll_number",    String.valueOf(rs.getInt("roll_number")));
                sub.put("photo",          rs.getString("photo") != null ? rs.getString("photo") : "");
                String submissionId = rs.getString("submission_id");
                sub.put("submitted",      submissionId != null ? "true" : "false");
                sub.put("submitted_file", rs.getString("submitted_file") != null ? rs.getString("submitted_file") : "");
                sub.put("submitted_date", rs.getDate("submitted_date")   != null ? rs.getDate("submitted_date").toString() : "");
                sub.put("remarks",        rs.getString("remarks")         != null ? rs.getString("remarks") : "");
                submissions.add(sub);
                if (submissionId != null) submittedCount++;
                else pendingCount++;
            }

            request.setAttribute("submissions",    submissions);
            request.setAttribute("submittedCount", submittedCount);
            request.setAttribute("pendingCount",   pendingCount);

        } catch (Exception e) { e.printStackTrace(); }
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/teacher/assignment-submissions.jsp");
        rd.forward(request, response);
    }
}