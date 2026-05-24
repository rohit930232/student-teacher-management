package com.school.controller.teacher;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminTimetableGridDAO;

@WebServlet("/teacher/timetable/grid/get")
public class TeacherTimetableGridGetServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int gridId = Integer.parseInt(request.getParameter("gridId"));
        AdminTimetableGridDAO dao = new AdminTimetableGridDAO();
        String data = dao.getGridData(gridId);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(data != null ? data : "[]");
    }
}