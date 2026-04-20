package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.school.dao.teacher.TeacherDAO;
import com.school.model.teacher.Teacher;

@WebServlet("/Admin/UpdateTeacher")
public class UpdateTeacherServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        TeacherDAO dao = new TeacherDAO();
        Teacher teacher = dao.getTeacherByUsername(username);
        req.setAttribute("teacher", teacher);
        req.getRequestDispatcher("/jsp/admin/edit-teacher.jsp").forward(req, res);
    }
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        try {
            Teacher t = new Teacher();
            t.setUsername(req.getParameter("username"));
            t.setName(req.getParameter("name"));
            t.setEmail(req.getParameter("email"));
            t.setMobile(req.getParameter("mobile"));          
            String salaryStr = req.getParameter("salary");
            if (salaryStr != null && !salaryStr.isEmpty()) {
                t.setSalary(Double.parseDouble(salaryStr));
            } else {
                t.setSalary(0);
            }          
            String remainingStr = req.getParameter("remaining_salary");
            if (remainingStr != null && !remainingStr.isEmpty()) {
                t.setRemaining_salary(Double.parseDouble(remainingStr));
            }           
            t.setClass_teacher(req.getParameter("class_teacher"));          
            String classIdStr = req.getParameter("class_id");
            if (classIdStr != null && !classIdStr.isEmpty()) {
                t.setClass_id(Integer.parseInt(classIdStr));
            }            
            t.setSubject(req.getParameter("subject"));
            t.setStatus(req.getParameter("status"));            
            String expStr = req.getParameter("experience");
            if (expStr != null && !expStr.isEmpty()) {
                t.setExperience(Integer.parseInt(expStr));
            }
            TeacherDAO dao = new TeacherDAO();
            dao.updateTeacherFull(t);
            res.sendRedirect("Teachers?update=success");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("Teachers?update=error");
        }
    }
}