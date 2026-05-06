package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminClassDAO;

@WebServlet("/admin/students/class")
public class AdminClassStudentsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int classId     = Integer.parseInt(req.getParameter("classId"));
        String className = req.getParameter("className");

        AdminClassDAO dao = new AdminClassDAO();

        req.setAttribute("students",      dao.getStudentsByClass(classId));
        req.setAttribute("classId",       classId);
        req.setAttribute("className",     className);
        req.setAttribute("classTeacher",  dao.getClassTeacherByClassId(classId));
        req.setAttribute("totalStudents", dao.getStudentsByClass(classId).size());

        req.getRequestDispatcher("/jsp/admin/class-students.jsp").forward(req, res);
    }
}