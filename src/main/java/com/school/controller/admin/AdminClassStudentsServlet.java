package com.school.controller.admin;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminClassDAO;
import com.school.exception.admin.*;

@WebServlet("/admin/students/class")
public class AdminClassStudentsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            String classIdStr = req.getParameter("classId");
            String className  = req.getParameter("className");
            if (classIdStr == null || classIdStr.isEmpty()) {
                res.sendRedirect(req.getContextPath() + "/admin/students");
                return;
            }
            int classId = Integer.parseInt(classIdStr);
            AdminClassDAO dao = new AdminClassDAO();
            List<Map<String,String>> students = dao.getStudentsByClass(classId);
            req.setAttribute("students",      students);
            req.setAttribute("classId",       classId);
            req.setAttribute("className",     className);
            req.setAttribute("classTeacher",  dao.getClassTeacherByClassId(classId));
            req.setAttribute("totalStudents", students.size());
        } catch (Exception e) {
            AdminExceptionHandler.handle(req, res,
                new AdminStudentException("We could not load class students. Please try again later.", e));
            return;
        }
        req.getRequestDispatcher("/jsp/admin/class-students.jsp").forward(req, res);
    }
}