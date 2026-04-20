package com.school.controller.admin;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.school.dao.admin.AdminDAO;
import com.school.model.admin.Admin;
import com.school.util.PasswordUtil;

@WebServlet("/Admin/Register")
@MultipartConfig
public class AdminRegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            Admin a = new Admin();

            // 🔐 Password
            String password = request.getParameter("password");
            a.setPassword(PasswordUtil.hashPassword(password));

            // 👤 Basic Info
            a.setUsername(request.getParameter("username"));
            a.setFullname(request.getParameter("fullname"));
            a.setEmail(request.getParameter("email"));
            a.setMobile(request.getParameter("mobile"));
            a.setGender(request.getParameter("gender"));
            a.setAddress(request.getParameter("address"));

            // 📅 DOB
            a.setDob(new SimpleDateFormat("yyyy-MM-dd")
                    .parse(request.getParameter("dob")));

            // 🔥 PHOTO UPLOAD
            Part filePart = request.getPart("photo");
            String fileName = filePart.getSubmittedFileName();

            String uploadPath = getServletContext().getRealPath("") + "uploads";

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            filePart.write(uploadPath + File.separator + fileName);

            a.setPhoto("uploads/" + fileName);

            // 💾 DAO
            AdminDAO dao = new AdminDAO();
            boolean status = dao.insertAdmin(a);

            if (status) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/jsp/admin/register.jsp?error=Failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}