package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminStaffDAO;

@WebServlet("/admin/staff/delete")
public class AdminStaffDeleteServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        AdminStaffDAO dao = new AdminStaffDAO();
        boolean ok = dao.deleteStaff(id);
        res.sendRedirect(req.getContextPath() + "/admin/staff?msg=" + (ok ? "deleted" : "error"));
    }
}