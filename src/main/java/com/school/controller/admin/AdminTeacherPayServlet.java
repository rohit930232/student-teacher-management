package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminPaymentDAO;

@WebServlet("/admin/payment/teacher/pay")
public class AdminTeacherPayServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        int    teacherId      = Integer.parseInt(req.getParameter("teacher_id"));
        double amount         = Double.parseDouble(req.getParameter("amount"));
        String paymentMode    = req.getParameter("payment_mode");
        String transactionId  = req.getParameter("transaction_id");
        String accountHolder  = req.getParameter("account_holder");
        String accountNumber  = req.getParameter("account_number");
        String bankName       = req.getParameter("bank_name");
        String ifscCode       = req.getParameter("ifsc_code");
        String upiId          = req.getParameter("upi_id");
        boolean useEdit       = "true".equals(req.getParameter("use_edit"));

        AdminPaymentDAO dao = new AdminPaymentDAO();
        boolean ok = dao.payTeacherSalary(teacherId, amount, paymentMode, transactionId,
                                           accountHolder, accountNumber, bankName, ifscCode, upiId, useEdit);

        res.sendRedirect(req.getContextPath() + "/admin/payment?msg=" + (ok ? "paid" : "error"));
    }
}