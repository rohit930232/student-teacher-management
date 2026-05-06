package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminClassDAO;

@WebServlet("/admin/attendance")
public class AdminAttendanceServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        AdminClassDAO dao = new AdminClassDAO();
        req.setAttribute("classList", dao.getClassListWithStudentCount());
        req.getRequestDispatcher("/jsp/admin/attendance.jsp").forward(req, res);
    }
}