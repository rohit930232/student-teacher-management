package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminClassDAO;

@WebServlet("/admin/assignments/class")
public class AdminAssignmentsClassServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int classId     = Integer.parseInt(req.getParameter("classId"));
        String className = req.getParameter("className");

        AdminClassDAO dao = new AdminClassDAO();
        req.setAttribute("assignments", dao.getAssignmentsByClass(classId));
        req.setAttribute("classId",     String.valueOf(classId));
        req.setAttribute("className",   className);

        req.getRequestDispatcher("/jsp/admin/assignments-class.jsp").forward(req, res);
    }
}