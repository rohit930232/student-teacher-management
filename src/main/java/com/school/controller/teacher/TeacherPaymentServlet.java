package com.school.controller.teacher;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.teacher.TeacherDAO;
import com.school.model.teacher.Teacher;
import com.school.util.DBConnection;

@WebServlet("/teacher/payment")
public class TeacherPaymentServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            Connection con = DBConnection.getConnection();
            TeacherDAO dao = new TeacherDAO();
            Teacher teacher = dao.getTeacherByUsername(username);

            request.setAttribute("salary",          teacher != null ? teacher.getSalary()           : 0);
            request.setAttribute("remainingSalary",  teacher != null ? teacher.getRemaining_salary() : 0);

            double totalReceived = 0;
            List<Map<String,String>> payments = new ArrayList<>();
            if (teacher != null) {
                PreparedStatement ps = con.prepareStatement("SELECT * FROM st_teacher_payment WHERE teacher_id=? ORDER BY payment_date DESC");
                ps.setInt(1, teacher.getTeacher_id());
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String,String> p = new HashMap<>();
                    double amount = rs.getDouble("amount");
                    totalReceived += amount;
                    p.put("amount",         String.valueOf(amount));
                    p.put("payment_mode",   rs.getString("payment_mode")   != null ? rs.getString("payment_mode")   : "-");
                    p.put("transaction_id", rs.getString("transaction_id") != null ? rs.getString("transaction_id") : "-");
                    p.put("payment_date",   rs.getDate("payment_date")     != null ? rs.getDate("payment_date").toString() : "-");
                    p.put("status",         rs.getString("status")         != null ? rs.getString("status")         : "-");
                    payments.add(p);
                }
            }
            request.setAttribute("totalReceived", totalReceived);
            request.setAttribute("payments",      payments);

        } catch (Exception e) { e.printStackTrace(); }
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/teacher/payment.jsp");
        rd.forward(request, response);
    }
}