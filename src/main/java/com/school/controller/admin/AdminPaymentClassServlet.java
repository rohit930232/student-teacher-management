package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminPaymentDAO;

@WebServlet("/admin/payment/class")
public class AdminPaymentClassServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int classId     = Integer.parseInt(req.getParameter("classId"));
        String className = req.getParameter("className");

        AdminPaymentDAO dao = new AdminPaymentDAO();

        req.setAttribute("students",       dao.getStudentFeesByClass(classId));
        req.setAttribute("className",      className);
        req.setAttribute("totalStudents",  dao.getStudentCountByClass(classId));
        req.setAttribute("paidStudents",   dao.getPaidStudentCountByClass(classId));
        req.setAttribute("pendingStudents",dao.getPendingStudentCountByClass(classId));

        req.getRequestDispatcher("/jsp/admin/payment-class.jsp").forward(req, res);
    }
}