package com.school.controller.student;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.student.StudentDAO;
import com.school.model.student.Student;
import com.school.util.DBConnection;
import com.school.exception.student.*;

@WebServlet("/student/payment")
public class StudentPaymentServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            Connection con = DBConnection.getConnection();
            StudentDAO dao = new StudentDAO();
            Student student = dao.getStudentByUsername(username);

            request.setAttribute("feesPaid",     student != null ? student.getFees_paid()     : 0);
            request.setAttribute("feesRemaining", student != null ? student.getFees_remaining() : 0);

            List<Map<String, String>> payments = new ArrayList<>();
            if (student != null) {
                String sql = "SELECT * FROM st_student_payment WHERE student_id=? ORDER BY payment_date DESC";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, student.getStudent_id());
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String, String> p = new HashMap<>();
                    p.put("amount",         String.valueOf(rs.getDouble("amount")));
                    p.put("payment_mode",   rs.getString("payment_mode") != null ? rs.getString("payment_mode") : "-");
                    p.put("transaction_id", rs.getString("transaction_id") != null ? rs.getString("transaction_id") : "-");
                    p.put("payment_date",   rs.getDate("payment_date") != null ? rs.getDate("payment_date").toString() : "-");
                    p.put("status",         rs.getString("status") != null ? rs.getString("status") : "-");
                    p.put("receipt_number", rs.getString("receipt_number") != null ? rs.getString("receipt_number") : "-");
                    p.put("payment_type",   rs.getString("payment_type") != null ? rs.getString("payment_type") : "-");
                    p.put("remarks",        rs.getString("remarks") != null ? rs.getString("remarks") : "-");
                    payments.add(p);
                }
            }
            request.setAttribute("payments", payments);

        } catch (Exception e) {  
        	StudentExceptionHandler.handle(request, response,
                new StudentPaymentException("We could not load your payment details. Please try again after some time.", e));
        return;
        }
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/student/payment.jsp");
        rd.forward(request, response);
    }
}