package com.school.controller.admin;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminClassDAO;

@WebServlet("/admin/attendance/class")
public class AdminAttendanceClassServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String classIdStr = req.getParameter("classId");
        String className  = req.getParameter("className");
        String month      = req.getParameter("month");

        if (classIdStr == null || classIdStr.isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/admin/attendance");
            return;
        }

        int classId = Integer.parseInt(classIdStr);
        if (month == null || month.isEmpty()) {
            month = new SimpleDateFormat("yyyy-MM").format(new Date());
        }

        AdminClassDAO dao = new AdminClassDAO();
        req.setAttribute("attendanceSummary", dao.getAttendanceSummaryByClass(classId, month));
        req.setAttribute("classId",   String.valueOf(classId));
        req.setAttribute("className", className);

        req.getRequestDispatcher("/jsp/admin/attendance-class.jsp").forward(req, res);
    }
}