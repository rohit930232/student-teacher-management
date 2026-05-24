package com.school.controller.student;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.student.StudentDAO;
import com.school.model.student.Student;
import com.school.util.DBConnection;
import com.school.exception.student.*;

@WebServlet("/student/payment/save")
public class StudentPaymentSaveServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            Connection con  = DBConnection.getConnection();
            StudentDAO dao  = new StudentDAO();
            Student student = dao.getStudentByUsername(username);

            if (student == null) {
                response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
                return;
            }

            String amountStr     = request.getParameter("amount");
            String paymentMode   = request.getParameter("payment_mode");
            String transactionId = request.getParameter("transaction_id");
            String remarks       = request.getParameter("remarks");

            double amount = Double.parseDouble(amountStr);

            String receiptNumber = "RCP" + System.currentTimeMillis();

            String insertSql = "INSERT INTO st_student_payment "
                + "(payment_id, student_id, amount, payment_date, payment_mode, status, transaction_id, receipt_number, payment_type, remarks) "
                + "VALUES (st_payment_seq.NEXTVAL, ?, ?, SYSDATE, ?, 'Paid', ?, ?, 'Fees', ?)";
            PreparedStatement ps = con.prepareStatement(insertSql);
            ps.setInt(1, student.getStudent_id());
            ps.setDouble(2, amount);
            ps.setString(3, paymentMode);
            ps.setString(4, transactionId != null && !transactionId.isEmpty() ? transactionId : null);
            ps.setString(5, receiptNumber);
            ps.setString(6, remarks != null && !remarks.isEmpty() ? remarks : null);
            ps.executeUpdate();

            String updateSql = "UPDATE st_student SET fees_paid = fees_paid + ?, fees_remaining = fees_remaining - ? WHERE student_id=?";
            PreparedStatement ups = con.prepareStatement(updateSql);
            ups.setDouble(1, amount);
            ups.setDouble(2, amount);
            ups.setInt(3, student.getStudent_id());
            ups.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/student/payment?success=1");

        } catch (Exception e) {
            StudentExceptionHandler.handle(request, response,
                new StudentPaymentException("Payment could not be processed. Please try again.", e));
        }
    }
}