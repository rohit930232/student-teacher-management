package com.school.dao.admin;

import java.sql.*;
import java.util.*;
import com.school.util.DBConnection;

public class AdminStaffDAO {

    private Connection getConn() {
        return DBConnection.getConnection();
    }

    public boolean insertStaff(String name, String role, String mobile, String email,
                                String gender, String dob, double salary, String status,
                                String address, String joiningDate, String photo) {
        try {
            Connection con = getConn();
            String sql = "INSERT INTO st_staff (staff_id, name, role, mobile, email, gender, dob, salary, status, address, joining_date, photo, created_date) "
                       + "VALUES (st_staff_seq.NEXTVAL, ?, ?, ?, ?, ?, "
                       + "(CASE WHEN ? IS NOT NULL AND ? != '' THEN TO_DATE(?, 'YYYY-MM-DD') ELSE NULL END), "
                       + "?, ?, ?, "
                       + "(CASE WHEN ? IS NOT NULL AND ? != '' THEN TO_DATE(?, 'YYYY-MM-DD') ELSE NULL END), "
                       + "?, SYSDATE)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, role);
            ps.setString(3, mobile);
            ps.setString(4, email);
            ps.setString(5, gender);
            ps.setString(6, dob);
            ps.setString(7, dob);
            ps.setString(8, dob);
            ps.setDouble(9, salary);
            ps.setString(10, status);
            ps.setString(11, address);
            ps.setString(12, joiningDate);
            ps.setString(13, joiningDate);
            ps.setString(14, joiningDate);
            ps.setString(15, photo);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Map<String, String>> getAllStaff() {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT staff_id, name, role, mobile, email, gender, "
                       + "TO_CHAR(dob, 'DD-MM-YYYY') AS dob, "
                       + "salary, status, photo, address, "
                       + "TO_CHAR(joining_date, 'DD-MM-YYYY') AS joining_date "
                       + "FROM st_staff ORDER BY staff_id DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("staff_id",     rs.getString("staff_id"));
                m.put("name",         rs.getString("name"));
                m.put("role",         rs.getString("role"));
                m.put("mobile",       rs.getString("mobile"));
                m.put("email",        rs.getString("email"));
                m.put("gender",       rs.getString("gender"));
                m.put("dob",          rs.getString("dob"));
                m.put("salary",       rs.getString("salary"));
                m.put("status",       rs.getString("status"));
                m.put("photo",        rs.getString("photo"));
                m.put("address",      rs.getString("address"));
                m.put("joining_date", rs.getString("joining_date"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, String> getStaffById(int id) {
        Map<String, String> m = new HashMap<>();
        try {
            Connection con = getConn();
            String sql = "SELECT staff_id, name, role, mobile, email, gender, "
                       + "TO_CHAR(dob, 'DD-MM-YYYY') AS dob, "
                       + "salary, status, photo, address, "
                       + "TO_CHAR(joining_date, 'DD-MM-YYYY') AS joining_date "
                       + "FROM st_staff WHERE staff_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                m.put("staff_id",     rs.getString("staff_id"));
                m.put("name",         rs.getString("name"));
                m.put("role",         rs.getString("role"));
                m.put("mobile",       rs.getString("mobile"));
                m.put("email",        rs.getString("email"));
                m.put("gender",       rs.getString("gender"));
                m.put("dob",          rs.getString("dob"));
                m.put("salary",       rs.getString("salary"));
                m.put("status",       rs.getString("status"));
                m.put("photo",        rs.getString("photo"));
                m.put("address",      rs.getString("address"));
                m.put("joining_date", rs.getString("joining_date"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return m;
    }

    public boolean updateStaff(int id, String name, String role, String mobile,
                                String email, double salary, String status, String address) {
        try {
            Connection con = getConn();
            String sql = "UPDATE st_staff SET name=?, role=?, mobile=?, email=?, salary=?, status=?, address=? WHERE staff_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, role);
            ps.setString(3, mobile);
            ps.setString(4, email);
            ps.setDouble(5, salary);
            ps.setString(6, status);
            ps.setString(7, address);
            ps.setInt(8, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteStaff(int id) {
        try {
            Connection con = getConn();
            String sql = "DELETE FROM st_staff WHERE staff_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}