package com.school.dao.admin;

import java.sql.*;
import java.util.*;
import com.school.util.DBConnection;

public class AdminTeacherDAO {

    private Connection getConn() {
        return DBConnection.getConnection();
    }

    public List<Map<String, String>> getAllTeachersWithDetails() {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT t.*, c.class_name, "
                       + "NVL((SELECT SUM(tp.amount) FROM st_teacher_payment tp WHERE tp.teacher_id = t.teacher_id AND tp.status='Paid'), 0) AS total_paid "
                       + "FROM st_teacher t LEFT JOIN st_class c ON t.class_id = c.class_id "
                       + "ORDER BY t.teacher_id";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("teacher_id",      rs.getString("teacher_id"));
                m.put("username",        rs.getString("username"));
                m.put("name",            rs.getString("name"));
                m.put("email",           rs.getString("email"));
                m.put("mobile",          rs.getString("mobile"));
                m.put("subject",         rs.getString("subject"));
                m.put("salary",          rs.getString("salary"));
                m.put("remaining_salary",rs.getString("remaining_salary"));
                m.put("photo",           rs.getString("photo"));
                m.put("class_id",        rs.getString("class_id"));
                m.put("class_name",      rs.getString("class_name"));
                m.put("dob",             rs.getString("dob"));
                m.put("gender",          rs.getString("gender"));
                m.put("qualification",   rs.getString("qualification"));
                m.put("experience",      rs.getString("experience"));
                m.put("class_teacher",   rs.getString("class_teacher"));
                m.put("status",          rs.getString("status"));
                m.put("account_holder",  rs.getString("account_holder"));
                m.put("account_number",  rs.getString("account_number"));
                m.put("bank_name",       rs.getString("bank_name"));
                m.put("ifsc_code",       rs.getString("ifsc_code"));
                m.put("branch",          rs.getString("branch"));
                m.put("upi_id",          rs.getString("upi_id"));
                m.put("address",         rs.getString("address"));
                m.put("permanent_address",rs.getString("permanent_address"));
                m.put("joining_date",    rs.getString("joining_date"));
                m.put("total_paid",      rs.getString("total_paid"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, String> getTeacherDetailByUsername(String username) {
        Map<String, String> m = new HashMap<>();
        try {
            Connection con = getConn();
            String sql = "SELECT t.*, c.class_name FROM st_teacher t LEFT JOIN st_class c ON t.class_id = c.class_id WHERE t.username = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                m.put("teacher_id",       rs.getString("teacher_id"));
                m.put("username",         rs.getString("username"));
                m.put("name",             rs.getString("name"));
                m.put("email",            rs.getString("email"));
                m.put("mobile",           rs.getString("mobile"));
                m.put("subject",          rs.getString("subject"));
                m.put("salary",           rs.getString("salary"));
                m.put("remaining_salary", rs.getString("remaining_salary"));
                m.put("photo",            rs.getString("photo"));
                m.put("class_id",         rs.getString("class_id"));
                m.put("class_name",       rs.getString("class_name"));
                m.put("dob",              rs.getString("dob"));
                m.put("age",              rs.getString("age"));
                m.put("gender",           rs.getString("gender"));
                m.put("qualification",    rs.getString("qualification"));
                m.put("experience",       rs.getString("experience"));
                m.put("class_teacher",    rs.getString("class_teacher"));
                m.put("status",           rs.getString("status"));
                m.put("account_holder",   rs.getString("account_holder"));
                m.put("account_number",   rs.getString("account_number"));
                m.put("bank_name",        rs.getString("bank_name"));
                m.put("ifsc_code",        rs.getString("ifsc_code"));
                m.put("branch",           rs.getString("branch"));
                m.put("pan_number",       rs.getString("pan_number"));
                m.put("upi_id",           rs.getString("upi_id"));
                m.put("address",          rs.getString("address"));
                m.put("permanent_address",rs.getString("permanent_address"));
                m.put("joining_date",     rs.getString("joining_date"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return m;
    }
}