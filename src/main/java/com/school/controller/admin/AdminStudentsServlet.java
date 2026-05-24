package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminClassDAO;
import com.school.exception.admin.*;

@WebServlet("/admin/students")
public class AdminStudentsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            AdminClassDAO dao = new AdminClassDAO();
            req.setAttribute("classList", dao.getClassListWithTeacher());
        } catch (Exception e) {
            AdminExceptionHandler.handle(req, res,
                new AdminStudentException("We could not load students. Please try again later.", e));
            return;
        }
        req.getRequestDispatcher("/jsp/admin/students.jsp").forward(req, res);
    }
}