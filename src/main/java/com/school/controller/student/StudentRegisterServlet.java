package com.school.controller.student;

import java.io.IOException;
import java.text.SimpleDateFormat;

import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.school.dao.student.StudentDAO;
import com.school.model.student.Student;
import com.school.util.PasswordUtil;

import javax.servlet.ServletException;

@WebServlet("/Student/Register")
@MultipartConfig
public class StudentRegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Student s = new Student();
            String password = request.getParameter("password");
            s.setPassword(PasswordUtil.hashPassword(password));
            s.setUsername(request.getParameter("username"));
            s.setName(request.getParameter("name"));
            s.setEmail(request.getParameter("email"));
            s.setStudent_mobile(request.getParameter("student_mobile"));
            s.setPermanent_address(request.getParameter("permanent_address"));
            s.setTemporary_address(request.getParameter("temporary_address"));
            String cid = request.getParameter("class_id");
            System.out.println("CLASS_ID = " + cid);
            if (cid == null || cid.isEmpty()) {
                throw new RuntimeException("Class ID missing");
            }
            int classId = Integer.parseInt(cid);
            s.setClass_id(classId);
            s.setFather_name(request.getParameter("father_name"));
            s.setMother_name(request.getParameter("mother_name"));
            s.setParents_mobile(request.getParameter("parents_mobile"));
            s.setFather_occupation(request.getParameter("father_occupation"));
            s.setMother_occupation(request.getParameter("mother_occupation"));
            String incomeStr = request.getParameter("annual_income");
            if (incomeStr != null && !incomeStr.isEmpty()) {
                s.setAnnual_income(Double.parseDouble(incomeStr));
            }
            String dobStr = request.getParameter("dob");
            if (dobStr != null && !dobStr.isEmpty()) {
                s.setDob(new SimpleDateFormat("yyyy-MM-dd").parse(dobStr));
            }
            s.setBlood_group(request.getParameter("blood_group"));
            s.setGender(request.getParameter("gender"));

            // 🎓 Roll number
            String roll = request.getParameter("roll_number");
            if (roll != null && !roll.isEmpty()) {
                s.setRoll_number(Integer.parseInt(roll));
            }
            Part filePart = request.getPart("photo");
            String fileName = filePart.getSubmittedFileName();

            if (fileName != null && !fileName.isEmpty()) {
                String uploadPath = getServletContext().getRealPath("") + "uploads";
                filePart.write(uploadPath + "/" + fileName);
                s.setPhoto("uploads/" + fileName);
            }
            StudentDAO dao = new StudentDAO();
            boolean status = dao.insertStudent(s);
            if (status) {
                response.sendRedirect(request.getContextPath() + "/jsp/student/register.jsp?message=Success");
            } else {
                response.sendRedirect(request.getContextPath() + "/jsp/student/register.jsp?error=Failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/jsp/student/register.jsp?error=Exception");
        }
    }
}