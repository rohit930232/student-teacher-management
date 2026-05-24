package com.school.controller.student;

import java.io.*;
import java.text.SimpleDateFormat;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import com.school.dao.student.StudentDAO;
import com.school.model.student.Student;
import com.school.util.PasswordUtil;
import com.school.exception.student.*;

@WebServlet("/Student/Register")
@MultipartConfig
public class StudentRegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Student s = new Student();
            s.setPassword(PasswordUtil.hashPassword(request.getParameter("password")));
            s.setUsername(request.getParameter("username"));
            s.setName(request.getParameter("name"));
            s.setEmail(request.getParameter("email"));
            s.setStudent_mobile(request.getParameter("student_mobile"));
            s.setPermanent_address(request.getParameter("permanent_address"));
            s.setTemporary_address(request.getParameter("temporary_address"));
            s.setGender(request.getParameter("gender"));

            String bloodGroup = request.getParameter("blood_group");
            if (bloodGroup != null && !bloodGroup.trim().isEmpty()) s.setBlood_group(bloodGroup);

            String cid = request.getParameter("class_id");
            if (cid == null || cid.isEmpty()) throw new RuntimeException("Class ID missing");
            s.setClass_id(Integer.parseInt(cid));

            s.setFather_name(request.getParameter("father_name"));
            s.setMother_name(request.getParameter("mother_name"));
            s.setParents_mobile(request.getParameter("parents_mobile"));
            s.setFather_occupation(request.getParameter("father_occupation"));
            s.setMother_occupation(request.getParameter("mother_occupation"));

            String incomeStr = request.getParameter("annual_income");
            if (incomeStr != null && !incomeStr.isEmpty()) s.setAnnual_income(Double.parseDouble(incomeStr));

            String dobStr = request.getParameter("dob");
            if (dobStr != null && !dobStr.isEmpty()) s.setDob(new SimpleDateFormat("yyyy-MM-dd").parse(dobStr));

            Part filePart = request.getPart("photo");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName  = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadDir = getServletContext().getRealPath("") + "uploads" + File.separator + "student";
                new File(uploadDir).mkdirs();
                filePart.write(uploadDir + File.separator + fileName);
                s.setPhoto("uploads/student/" + fileName);
            }

            StudentDAO dao  = new StudentDAO();
            boolean status  = dao.insertStudent(s);

            if (status) {
                response.sendRedirect(request.getContextPath() + "/jsp/student/register.jsp?message=Registered Successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/jsp/student/register.jsp?error=Registration Failed");
            }

        } catch (Exception e) {
            StudentExceptionHandler.handle(request, response,
                new StudentRegistrationException("Registration could not be completed. Please check the form and try again.", e));
        }
    }
}