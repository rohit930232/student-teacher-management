package com.school.controller.teacher;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import com.school.util.DBConnection;

@WebServlet("/teacher/students/update")
@MultipartConfig(fileSizeThreshold = 1024*1024, maxFileSize = 5*1024*1024)
public class TeacherStudentUpdateServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String classId = request.getParameter("class_id");
        try {
            int    studentId        = Integer.parseInt(request.getParameter("student_id"));
            int    rollNumber       = Integer.parseInt(request.getParameter("roll_number"));
            String name             = request.getParameter("name");
            String username         = request.getParameter("username");
            String email            = request.getParameter("email");
            String mobile           = request.getParameter("mobile");
            String tempAddress      = request.getParameter("temporary_address");
            String permAddress      = request.getParameter("permanent_address");
            String fatherName       = request.getParameter("father_name");
            String motherName       = request.getParameter("mother_name");
            String parentsMobile    = request.getParameter("parents_mobile");
            String fatherOccupation = request.getParameter("father_occupation");
            String motherOccupation = request.getParameter("mother_occupation");
            String incomeStr        = request.getParameter("annual_income");
            double annualIncome     = (incomeStr != null && !incomeStr.isEmpty()) ? Double.parseDouble(incomeStr) : 0;

            Connection con = DBConnection.getConnection();

            String photoPath = null;
            Part filePart = request.getPart("photo");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName  = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadDir = getServletContext().getRealPath("/uploads/student/");
                new File(uploadDir).mkdirs();
                filePart.write(uploadDir + File.separator + fileName);
                photoPath = "uploads/student/" + fileName;
            }

            StringBuilder sql = new StringBuilder(
                "UPDATE st_student SET roll_number=?, name=?, username=?, email=?, mobile=?, " +
                "temporary_address=?, permanent_address=?, father_name=?, mother_name=?, " +
                "parents_mobile=?, father_occupation=?, mother_occupation=?, annual_income=?"
            );
            if (photoPath != null) sql.append(", photo=?");
            sql.append(" WHERE student_id=?");

            PreparedStatement ps = con.prepareStatement(sql.toString());
            int idx = 1;
            ps.setInt(idx++,    rollNumber);
            ps.setString(idx++, name);
            ps.setString(idx++, username);
            ps.setString(idx++, email);
            ps.setString(idx++, mobile);
            ps.setString(idx++, tempAddress);
            ps.setString(idx++, permAddress);
            ps.setString(idx++, fatherName);
            ps.setString(idx++, motherName);
            ps.setString(idx++, parentsMobile);
            ps.setString(idx++, fatherOccupation);
            ps.setString(idx++, motherOccupation);
            ps.setDouble(idx++, annualIncome);
            if (photoPath != null) ps.setString(idx++, photoPath);
            ps.setInt(idx++, studentId);
            ps.executeUpdate();

        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect(request.getContextPath() + "/teacher/students?class_id=" + classId);
    }
}