package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminPaymentDAO;
import com.school.dao.admin.AdminTeacherDAO;
import com.school.exception.admin.*;

@WebServlet("/admin/payment")
public class AdminPaymentServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            AdminPaymentDAO payDao = new AdminPaymentDAO();
            AdminTeacherDAO tDao  = new AdminTeacherDAO();
            req.setAttribute("totalFeesPaid",      payDao.getTotalFeesPaid());
            req.setAttribute("totalFeesRemaining", payDao.getTotalFeesRemaining());
            req.setAttribute("totalSalaryPaid",    payDao.getTotalSalaryPaid());
            req.setAttribute("totalSalaryDue",     payDao.getTotalSalaryDue());
            req.setAttribute("classList",          payDao.getClassFeeSummary());
            req.setAttribute("teachers",           tDao.getAllTeachersWithDetails());
        } catch (Exception e) {
            AdminExceptionHandler.handle(req, res,
                new AdminPaymentException("We could not load payment data. Please try again later.", e));
            return;
        }
        req.getRequestDispatcher("/jsp/admin/payment.jsp").forward(req, res);
    }
}