package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminTeacherDAO;

@WebServlet("/admin/teachers")
public class AdminTeachersServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        AdminTeacherDAO dao = new AdminTeacherDAO();
        req.setAttribute("teachers", dao.getAllTeachersWithDetails());
        req.getRequestDispatcher("/jsp/admin/teachers.jsp").forward(req, res);
    }
}