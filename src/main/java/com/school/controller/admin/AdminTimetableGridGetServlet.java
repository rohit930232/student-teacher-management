package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminTimetableGridDAO;

@WebServlet("/admin/timetable/grid/get")
public class AdminTimetableGridGetServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        int gridId = Integer.parseInt(req.getParameter("gridId"));
        AdminTimetableGridDAO dao = new AdminTimetableGridDAO();
        String data = dao.getGridData(gridId);

        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");
        res.getWriter().write(data != null ? data : "[]");
    }
}