package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminClassDAO;
import com.school.dao.admin.AdminTimetableGridDAO;
import com.school.exception.admin.*;

@WebServlet("/admin/timetable/class")
public class AdminTimetableClassServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            String classIdStr = req.getParameter("classId");
            String className  = req.getParameter("className");
            if (classIdStr == null || classIdStr.isEmpty()) {
                res.sendRedirect(req.getContextPath() + "/admin/timetable");
                return;
            }
            int classId = Integer.parseInt(classIdStr);
            AdminClassDAO         dao     = new AdminClassDAO();
            AdminTimetableGridDAO gridDao = new AdminTimetableGridDAO();
            req.setAttribute("timetableByDay", dao.getTimetableByClass(classId));
            req.setAttribute("teachers",       dao.getAllTeachers());
            req.setAttribute("gridList",       gridDao.getGridsByClass(classId));
            req.setAttribute("classId",        String.valueOf(classId));
            req.setAttribute("className",      className);
        } catch (Exception e) {
            AdminExceptionHandler.handle(req, res,
                new AdminTimetableException("We could not load timetable. Please try again later.", e));
            return;
        }
        req.getRequestDispatcher("/jsp/admin/timetable-class.jsp").forward(req, res);
    }
}