package com.school.controller.student;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import com.school.util.DBConnection;
import com.school.exception.student.*;

@WebServlet("/student/profile/update")
@MultipartConfig(fileSizeThreshold = 1024*1024, maxFileSize = 5*1024*1024)
public class StudentProfileUpdateServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String currentUsername = (String) session.getAttribute("username");

        try {
            String section = request.getParameter("section");
            Connection con = DBConnection.getConnection();

            if ("photo".equals(section)) {
                Part filePart = request.getPart("photo");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName  = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                    String uploadDir = getServletContext().getRealPath("/uploads/student/");
                    new File(uploadDir).mkdirs();
                    filePart.write(uploadDir + File.separator + fileName);
                    String photoPath = "uploads/student/" + fileName;
                    PreparedStatement ps = con.prepareStatement(
                        "UPDATE st_student SET photo=? WHERE username=?");
                    ps.setString(1, photoPath);
                    ps.setString(2, currentUsername);
                    ps.executeUpdate();
                    session.setAttribute("photo", photoPath);
                }

            } else if ("personal".equals(section)) {
                String name        = request.getParameter("name");
                String newUsername = request.getParameter("username").trim();
                String dob         = request.getParameter("dob");
                String gender      = request.getParameter("gender");
                String bloodGroup  = request.getParameter("blood_group");

                if (!newUsername.equals(currentUsername)) {
                    PreparedStatement checkPs = con.prepareStatement(
                        "SELECT username FROM st_student WHERE username=?");
                    checkPs.setString(1, newUsername);
                    ResultSet rs = checkPs.executeQuery();
                    if (rs.next()) {
                        response.sendRedirect(request.getContextPath() + "/student/profile?error=1");
                        return;
                    }
                }
                PreparedStatement ps = con.prepareStatement(
                    "UPDATE st_student SET name=?, username=?, dob=?, gender=?, blood_group=? WHERE username=?");
                ps.setString(1, name);
                ps.setString(2, newUsername);
                ps.setDate(3, dob != null && !dob.isEmpty() ? java.sql.Date.valueOf(dob) : null);
                ps.setString(4, gender);
                ps.setString(5, bloodGroup);
                ps.setString(6, currentUsername);
                ps.executeUpdate();
                session.setAttribute("username", newUsername);
                session.setAttribute("fullname", name);

            } else if ("contact".equals(section)) {
                PreparedStatement ps = con.prepareStatement(
                    "UPDATE st_student SET email=?, mobile=?, temporary_address=?, permanent_address=? WHERE username=?");
                ps.setString(1, request.getParameter("email"));
                ps.setString(2, request.getParameter("student_mobile"));
                ps.setString(3, request.getParameter("temporary_address"));
                ps.setString(4, request.getParameter("permanent_address"));
                ps.setString(5, currentUsername);
                ps.executeUpdate();

            } else if ("family".equals(section)) {
                String income = request.getParameter("annual_income");
                PreparedStatement ps = con.prepareStatement(
                    "UPDATE st_student SET father_name=?, mother_name=?, parents_mobile=?, "
                    + "father_occupation=?, mother_occupation=?, annual_income=? WHERE username=?");
                ps.setString(1, request.getParameter("father_name"));
                ps.setString(2, request.getParameter("mother_name"));
                ps.setString(3, request.getParameter("parents_mobile"));
                ps.setString(4, request.getParameter("father_occupation"));
                ps.setString(5, request.getParameter("mother_occupation"));
                ps.setDouble(6, income != null && !income.isEmpty() ? Double.parseDouble(income) : 0);
                ps.setString(7, currentUsername);
                ps.executeUpdate();
            }

            response.sendRedirect(request.getContextPath() + "/student/profile?success=1");

        } catch (Exception e) {
            StudentExceptionHandler.handle(request, response,
                new StudentProfileException("Your profile could not be updated. Please try again.", e));
        }
    }
}