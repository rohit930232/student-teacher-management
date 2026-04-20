package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.school.dao.admin.AdminStudentDAO;

@WebServlet("/Admin/ClassStudents")
public class ClassStudentsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        int classId = Integer.parseInt(req.getParameter("classId"));
        String className = req.getParameter("className");
        AdminStudentDAO dao = new AdminStudentDAO();
        req.setAttribute("students", dao.getStudentsByClass(classId));
        req.setAttribute("classId", classId);
        req.setAttribute("className", className);
        req.getRequestDispatcher("/jsp/admin/class-students.jsp")
                .forward(req, res);
    }
}