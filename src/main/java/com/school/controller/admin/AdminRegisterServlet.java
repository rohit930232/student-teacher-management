package com.school.controller.admin;

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

            String password = request.getParameter("password");
            String hashedPassword = PasswordUtil.hashPassword(password);

            Admin a = new Admin();

            a.setUsername(request.getParameter("username"));
            a.setFullname(request.getParameter("fullname"));
            a.setEmail(request.getParameter("email"));
            a.setPassword(hashedPassword);
            a.setDob(new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("dob")));
            a.setGender(request.getParameter("gender"));
            a.setMobile(request.getParameter("mobile"));
            a.setAddress(request.getParameter("address"));

            Part filePart = request.getPart("photo");
            String fileName = filePart.getSubmittedFileName();

            String uploadPath = getServletContext().getRealPath("") + "uploads";
            filePart.write(uploadPath + "/" + fileName);

            a.setPhoto("uploads/" + fileName);

            AdminDAO dao = new AdminDAO();

            boolean status = dao.insertAdmin(a);

            if(status){
            	response.sendRedirect(request.getContextPath() + "/jsp/admin/register.jsp?message=Registered Successfully");
            } else {
            	response.sendRedirect(request.getContextPath() + "/jsp/admin/register.jsp?error=Failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}