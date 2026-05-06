package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminClassDAO;

@WebServlet("/admin/timetable/delete")
public class AdminTimetableDeleteServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        int    id        = Integer.parseInt(req.getParameter("id"));
        String classId   = req.getParameter("classId");
        String className = req.getParameter("className");

        AdminClassDAO dao = new AdminClassDAO();
        boolean ok = dao.deleteTimetableSlot(id);

        res.sendRedirect(req.getContextPath() + "/admin/timetable/class?classId=" + classId + "&className=" + className + "&msg=" + (ok ? "deleted" : "error"));
    }
}