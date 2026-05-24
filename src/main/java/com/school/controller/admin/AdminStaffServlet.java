package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminStaffDAO;
import com.school.exception.admin.*;

@WebServlet("/admin/staff")
public class AdminStaffServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            AdminStaffDAO dao = new AdminStaffDAO();
            req.setAttribute("staffList", dao.getAllStaff());
        } catch (Exception e) {
            AdminExceptionHandler.handle(req, res,
                new AdminStaffException("We could not load staff. Please try again later.", e));
            return;
        }
        req.getRequestDispatcher("/jsp/admin/staff.jsp").forward(req, res);
    }
}