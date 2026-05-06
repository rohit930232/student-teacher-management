package com.school.dao.admin;

import java.sql.*;
import java.util.*;
import com.school.util.DBConnection;

public class AdminPaymentDAO {

    private Connection getConn() {
        return DBConnection.getConnection();
    }

    public double getTotalFeesPaid() {
        try {
            Connection con = getConn();
            PreparedStatement ps = con.prepareStatement("SELECT NVL(SUM(fees_paid), 0) FROM st_student");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public double getTotalFeesRemaining() {
        try {
            Connection con = getConn();
            PreparedStatement ps = con.prepareStatement("SELECT NVL(SUM(fees_remaining), 0) FROM st_student");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public double getTotalSalaryPaid() {
        try {
            Connection con = getConn();
            PreparedStatement ps = con.prepareStatement("SELECT NVL(SUM(amount), 0) FROM st_teacher_payment WHERE status='Paid'");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public double getTotalSalaryDue() {
        try {
            Connection con = getConn();
            PreparedStatement ps = con.prepareStatement("SELECT NVL(SUM(remaining_salary), 0) FROM st_teacher");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public List<Map<String, String>> getClassFeeSummary() {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT c.class_id, c.class_name, "
                       + "COUNT(s.student_id) AS total, "
                       + "SUM(CASE WHEN s.fees_remaining = 0 THEN 1 ELSE 0 END) AS paid_count, "
                       + "SUM(CASE WHEN s.fees_remaining > 0 THEN 1 ELSE 0 END) AS pending_count "
                       + "FROM st_class c LEFT JOIN st_student s ON c.class_id = s.class_id "
                       + "GROUP BY c.class_id, c.class_name ORDER BY c.class_id";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("class_id",      rs.getString("class_id"));
                m.put("class_name",    rs.getString("class_name"));
                m.put("total",         rs.getString("total"));
                m.put("paid_count",    rs.getString("paid_count"));
                m.put("pending_count", rs.getString("pending_count"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, String>> getStudentFeesByClass(int classId) {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT student_id, name, roll_number, fees_paid, fees_remaining FROM st_student WHERE class_id = ? ORDER BY roll_number";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("student_id",     rs.getString("student_id"));
                m.put("name",           rs.getString("name"));
                m.put("roll_number",    rs.getString("roll_number"));
                m.put("fees_paid",      rs.getString("fees_paid"));
                m.put("fees_remaining", rs.getString("fees_remaining"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean payTeacherSalary(int teacherId, double amount, String paymentMode,
                                     String transactionId, String accountHolder, String accountNumber,
                                     String bankName, String ifscCode, String upiId, boolean useEdit) {
        try {
            Connection con = getConn();
            con.setAutoCommit(false);

            String insertSql = "INSERT INTO st_teacher_payment (payment_id, teacher_id, amount, payment_date, payment_mode, status, transaction_id) "
                             + "VALUES (st_teacher_payment_seq.NEXTVAL, ?, ?, SYSDATE, ?, 'Paid', ?)";
            PreparedStatement ins = con.prepareStatement(insertSql);
            ins.setInt(1, teacherId);
            ins.setDouble(2, amount);
            ins.setString(3, paymentMode);
            ins.setString(4, transactionId != null && !transactionId.isEmpty() ? transactionId : null);
            ins.executeUpdate();

            String updateSql = "UPDATE st_teacher SET remaining_salary = remaining_salary - ? WHERE teacher_id = ?";
            PreparedStatement upd = con.prepareStatement(updateSql);
            upd.setDouble(1, amount);
            upd.setInt(2, teacherId);
            upd.executeUpdate();

            con.commit();
            con.setAutoCommit(true);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try { DBConnection.getConnection().rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            return false;
        }
    }

    public int getStudentCountByClass(int classId) {
        try {
            Connection con = getConn();
            PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM st_student WHERE class_id = ?");
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int getPaidStudentCountByClass(int classId) {
        try {
            Connection con = getConn();
            PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM st_student WHERE class_id = ? AND fees_remaining = 0");
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int getPendingStudentCountByClass(int classId) {
        try {
            Connection con = getConn();
            PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM st_student WHERE class_id = ? AND fees_remaining > 0");
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}