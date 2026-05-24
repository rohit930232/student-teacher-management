package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminTeacherDAO;
import com.school.exception.admin.*;

@WebServlet("/admin/teachers")
public class AdminTeachersServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            AdminTeacherDAO dao = new AdminTeacherDAO();
            req.setAttribute("teachers", dao.getAllTeachersWithDetails());
        } catch (Exception e) {
            AdminExceptionHandler.handle(req, res,
                new AdminTeacherException("We could not load teachers. Please try again later.", e));
            return;
        }
        req.getRequestDispatcher("/jsp/admin/teachers.jsp").forward(req, res);
    }
}