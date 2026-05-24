package com.school.controller.admin;

import java.io.IOException;
import java.net.URLEncoder;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminTimetableGridDAO;

@WebServlet("/admin/timetable/grid/delete")
public class AdminTimetableGridDeleteServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        int    gridId   = Integer.parseInt(req.getParameter("gridId"));
        String classId  = req.getParameter("classId");
        String className= req.getParameter("className");

        AdminTimetableGridDAO dao = new AdminTimetableGridDAO();
        boolean ok = dao.deleteGrid(gridId);

        res.sendRedirect(req.getContextPath() + "/admin/timetable/class?classId=" + classId
                + "&className=" + URLEncoder.encode(className != null ? className : "", "UTF-8")
                + "&msg=" + (ok ? "griddeleted" : "error"));
    }
}