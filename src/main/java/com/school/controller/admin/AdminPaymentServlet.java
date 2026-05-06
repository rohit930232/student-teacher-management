package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminPaymentDAO;
import com.school.dao.admin.AdminTeacherDAO;

@WebServlet("/admin/payment")
public class AdminPaymentServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        AdminPaymentDAO payDao  = new AdminPaymentDAO();
        AdminTeacherDAO tDao    = new AdminTeacherDAO();

        req.setAttribute("totalFeesPaid",      payDao.getTotalFeesPaid());
        req.setAttribute("totalFeesRemaining", payDao.getTotalFeesRemaining());
        req.setAttribute("totalSalaryPaid",    payDao.getTotalSalaryPaid());
        req.setAttribute("totalSalaryDue",     payDao.getTotalSalaryDue());
        req.setAttribute("classList",          payDao.getClassFeeSummary());
        req.setAttribute("teachers",           tDao.getAllTeachersWithDetails());

        req.getRequestDispatcher("/jsp/admin/payment.jsp").forward(req, res);
    }
}