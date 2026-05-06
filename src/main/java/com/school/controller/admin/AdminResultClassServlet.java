package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminClassDAO;

@WebServlet("/admin/result/class")
public class AdminResultClassServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int classId     = Integer.parseInt(req.getParameter("classId"));
        String className = req.getParameter("className");

        AdminClassDAO dao = new AdminClassDAO();
        req.setAttribute("results",   dao.getResultsByClass(classId));
        req.setAttribute("classId",   String.valueOf(classId));
        req.setAttribute("className", className);

        req.getRequestDispatcher("/jsp/admin/result-class.jsp").forward(req, res);
    }
}