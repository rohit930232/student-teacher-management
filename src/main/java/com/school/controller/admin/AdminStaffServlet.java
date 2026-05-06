package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminStaffDAO;

@WebServlet("/admin/staff")
public class AdminStaffServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        AdminStaffDAO dao = new AdminStaffDAO();
        req.setAttribute("staffList", dao.getAllStaff());
        req.getRequestDispatcher("/jsp/admin/staff.jsp").forward(req, res);
    }
}