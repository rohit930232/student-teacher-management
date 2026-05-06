package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminStaffDAO;

@WebServlet("/admin/staff/update")
public class AdminStaffUpdateServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int    staffId  = Integer.parseInt(req.getParameter("staff_id"));
        String name     = req.getParameter("name");
        String role     = req.getParameter("role");
        String mobile   = req.getParameter("mobile");
        String email    = req.getParameter("email");
        String salStr   = req.getParameter("salary");
        String status   = req.getParameter("status");
        String address  = req.getParameter("address");

        double salary = 0;
        if (salStr != null && !salStr.isEmpty()) salary = Double.parseDouble(salStr);

        AdminStaffDAO dao = new AdminStaffDAO();
        boolean ok = dao.updateStaff(staffId, name, role, mobile, email, salary, status, address);

        res.sendRedirect(req.getContextPath() + "/admin/staff?msg=" + (ok ? "updated" : "error"));
    }
}