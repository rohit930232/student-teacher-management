package com.school.controller.admin;

import java.io.IOException;
import java.net.URLEncoder;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminTimetableGridDAO;

@WebServlet("/admin/timetable/grid/save")
public class AdminTimetableGridSaveServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        String classIdStr = req.getParameter("class_id");
        String className  = req.getParameter("className");
        String gridName   = req.getParameter("grid_name");
        String gridData   = req.getParameter("grid_data");

        int classId = Integer.parseInt(classIdStr);

        AdminTimetableGridDAO dao = new AdminTimetableGridDAO();
        boolean ok = dao.saveGrid(classId, gridName, gridData);

        res.sendRedirect(req.getContextPath() + "/admin/timetable/class?classId=" + classId
                + "&className=" + URLEncoder.encode(className != null ? className : "", "UTF-8")
                + "&msg=" + (ok ? "gridsaved" : "error"));
    }
}