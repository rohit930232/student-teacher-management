package com.school.controller.teacher;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import com.school.util.DBConnection;
import com.school.util.PasswordUtil;

@WebServlet("/teacher/profile/update")
@MultipartConfig(fileSizeThreshold = 1024*1024, maxFileSize = 5*1024*1024)
public class TeacherProfileUpdateServlet extends HttpServlet {

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
                    String uploadDir = getServletContext().getRealPath("/uploads/teacher/");
                    new File(uploadDir).mkdirs();
                    filePart.write(uploadDir + File.separator + fileName);
                    String photoPath = "uploads/teacher/" + fileName;
                    PreparedStatement ps = con.prepareStatement("UPDATE st_teacher SET photo=? WHERE username=?");
                    ps.setString(1, photoPath);
                    ps.setString(2, currentUsername);
                    ps.executeUpdate();
                    session.setAttribute("photo", photoPath);
                }

            } else if ("personal".equals(section)) {
                String name        = request.getParameter("name");
                String newUsername = request.getParameter("username").trim();
                String dob         = request.getParameter("dob");
                String age         = request.getParameter("age");
                String gender      = request.getParameter("gender");
                String mobile      = request.getParameter("mobile");
                String email       = request.getParameter("email");
                String qual        = request.getParameter("qualification");
                String exp         = request.getParameter("experience");

                if (!newUsername.equals(currentUsername)) {
                    PreparedStatement checkPs = con.prepareStatement("SELECT username FROM st_teacher WHERE username=?");
                    checkPs.setString(1, newUsername);
                    if (checkPs.executeQuery().next()) {
                        response.sendRedirect(request.getContextPath() + "/teacher/profile?error=1");
                        return;
                    }
                }

                PreparedStatement ps = con.prepareStatement("UPDATE st_teacher SET name=?, username=?, dob=?, age=?, gender=?, mobile=?, email=?, qualification=?, experience=? WHERE username=?");
                ps.setString(1, name);
                ps.setString(2, newUsername);
                ps.setDate(3, dob != null && !dob.isEmpty() ? java.sql.Date.valueOf(dob) : null);
                ps.setInt(4, age != null && !age.isEmpty() ? Integer.parseInt(age) : 0);
                ps.setString(5, gender);
                ps.setString(6, mobile);
                ps.setString(7, email);
                ps.setString(8, qual);
                ps.setInt(9, exp != null && !exp.isEmpty() ? Integer.parseInt(exp) : 0);
                ps.setString(10, currentUsername);
                ps.executeUpdate();
                session.setAttribute("username", newUsername);
                session.setAttribute("fullname", name);

            } else if ("address".equals(section)) {
                PreparedStatement ps = con.prepareStatement("UPDATE st_teacher SET address=?, permanent_address=? WHERE username=?");
                ps.setString(1, request.getParameter("address"));
                ps.setString(2, request.getParameter("permanent_address"));
                ps.setString(3, currentUsername);
                ps.executeUpdate();

            } else if ("bank".equals(section)) {
                PreparedStatement ps = con.prepareStatement("UPDATE st_teacher SET account_holder=?, account_number=?, bank_name=?, ifsc_code=?, branch=?, pan_number=?, upi_id=? WHERE username=?");
                ps.setString(1, request.getParameter("account_holder"));
                ps.setString(2, request.getParameter("account_number"));
                ps.setString(3, request.getParameter("bank_name"));
                ps.setString(4, request.getParameter("ifsc_code"));
                ps.setString(5, request.getParameter("branch"));
                ps.setString(6, request.getParameter("pan_number"));
                ps.setString(7, request.getParameter("upi_id"));
                ps.setString(8, currentUsername);
                ps.executeUpdate();
            }

            response.sendRedirect(request.getContextPath() + "/teacher/profile?success=1");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/teacher/profile?error=1");
        }
    }
}