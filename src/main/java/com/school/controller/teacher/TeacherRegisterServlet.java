package com.school.controller.teacher;

import java.io.IOException;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.school.dao.teacher.TeacherDAO;
import com.school.model.teacher.Teacher;
import com.school.util.PasswordUtil;

@WebServlet("/Teacher/Register")
@MultipartConfig
public class TeacherRegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            Teacher t = new Teacher();

            // 🔐 Password
            String password = request.getParameter("password");
            t.setPassword(PasswordUtil.hashPassword(password));

            // 👤 Basic info
            t.setUsername(request.getParameter("username"));
            t.setName(request.getParameter("name"));
            t.setEmail(request.getParameter("email"));
            t.setMobile(request.getParameter("mobile"));
            t.setSubject(request.getParameter("subject"));
            t.setSalary(Double.parseDouble(request.getParameter("salary")));

            // 🔥 IMPORTANT FIX (FK)
            String cid = request.getParameter("class_teacher"); // JSP se yahi aa raha hai

            System.out.println("CLASS_ID = " + cid);

            if (cid != null && !cid.isEmpty()) {
                t.setClass_id(Integer.parseInt(cid));
            } else {
                throw new RuntimeException("Class ID missing");
            }

            // 👤 Other details
            t.setDob(new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("dob")));
            t.setAge(Integer.parseInt(request.getParameter("age")));
            t.setGender(request.getParameter("gender"));
            t.setQualification(request.getParameter("qualification"));
            t.setExperience(Integer.parseInt(request.getParameter("experience")));
            t.setClass_teacher(request.getParameter("class_teacher"));
            t.setStatus(request.getParameter("status"));

            // 🏦 Bank
            t.setAccount_holder(request.getParameter("account_holder"));
            t.setAccount_number(request.getParameter("account_number"));
            t.setBank_name(request.getParameter("bank_name"));
            t.setIfsc_code(request.getParameter("ifsc_code"));
            t.setBranch(request.getParameter("branch"));
            t.setPan_number(request.getParameter("pan_number"));
            t.setUpi_id(request.getParameter("upi_id"));

            // 📍 Address
            t.setAddress(request.getParameter("address"));
            t.setPermanent_address(request.getParameter("permanent_address"));

            // 📸 Photo
            Part filePart = request.getPart("photo");
            String fileName = filePart.getSubmittedFileName();

            if (fileName != null && !fileName.isEmpty()) {
                String uploadPath = getServletContext().getRealPath("") + "uploads";
                filePart.write(uploadPath + "/" + fileName);
                t.setPhoto("uploads/" + fileName);
            }

            // 💾 DAO
            TeacherDAO dao = new TeacherDAO();
            boolean status = dao.insertTeacher(t);

            if (status) {
                response.sendRedirect(request.getContextPath() + "/jsp/teacher/register.jsp?message=Registered Successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/jsp/teacher/register.jsp?error=Failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/jsp/teacher/register.jsp?error=Exception");
        }
    }
}