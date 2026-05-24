package com.school.controller.student;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminTimetableGridDAO;

@WebServlet("/student/timetable/grid/get")
public class StudentTimetableGridGetServlet extends HttpServlet {

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