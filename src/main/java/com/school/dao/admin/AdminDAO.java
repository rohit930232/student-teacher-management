package com.school.dao.admin;

import java.sql.*;
import java.util.*;

import com.school.model.admin.Admin;
import com.school.util.DBConnection;

public class AdminDAO {
    public boolean insertAdmin(Admin a) {

        boolean status = false;

        try {
            Connection con = DBConnection.getConnection();
            String sql = "INSERT INTO st_admin "
                    + "(admin_id, username, fullname, email, password, dob, gender, mobile, photo, address, created_date, status) "
                    + "VALUES (st_admin_seq.NEXTVAL,?,?,?,?,?,?,?,?,?,SYSDATE,'ACTIVE')";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, a.getUsername());
            ps.setString(2, a.getFullname());
            ps.setString(3, a.getEmail());
            ps.setString(4, a.getPassword());
            ps.setDate(5, new java.sql.Date(a.getDob().getTime()));
            ps.setString(6, a.getGender());
            ps.setString(7, a.getMobile());
            ps.setString(8, a.getPhoto());
            ps.setString(9, a.getAddress());
            int i = ps.executeUpdate();
            if (i > 0) status = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }
    private int getCount(String table) {
        int count = 0;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM " + table);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
    public int getTotalStudents() {
        return getCount("st_student");
    }
    public int getTotalTeachers() {
        return getCount("st_teacher");
    }
    public int getTotalClasses() {
        return getCount("st_class");
    }
    public List<String> getNotices() {
        List<String> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT message FROM st_notice ORDER BY created_date DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("message"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public double getTotalFees() {
        double total = 0;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT NVL(SUM(amount),0) FROM st_fees";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                total = rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }
    public List<Map<String, String>> getNotifications() {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT message, created_date FROM st_notification ORDER BY created_date DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> map = new HashMap<>();
                map.put("message", rs.getString("message"));
                map.put("time", rs.getString("created_date"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public Admin getAdminByUsername(String username) {
        Admin admin = null;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM st_admin WHERE username = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                admin = new Admin();
                admin.setUsername(rs.getString("username"));
                admin.setFullname(rs.getString("fullname"));
                admin.setEmail(rs.getString("email"));
                admin.setMobile(rs.getString("mobile"));
                admin.setPhoto(rs.getString("photo"));
                admin.setAddress(rs.getString("address"));
                admin.setGender(rs.getString("gender"));
                admin.setDob(rs.getDate("dob"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return admin;
    }
    public boolean updateAdminProfile(String username, String fullname, String email, 
                                      String mobile, String address, String gender) {
        boolean updated = false;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "UPDATE st_admin SET fullname = ?, email = ?, mobile = ?, address = ?, gender = ? WHERE username = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, fullname);
            ps.setString(2, email);
            ps.setString(3, mobile);
            ps.setString(4, address);
            ps.setString(5, gender);
            ps.setString(6, username);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                updated = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return updated;
    })
    public boolean changePassword(String username, String oldPassword, String newPassword) {
        boolean changed = false;
        try {
            Connection con = DBConnection.getConnection();
            String checkSql = "SELECT * FROM st_admin WHERE username = ? AND password = ?";
            PreparedStatement checkPs = con.prepareStatement(checkSql);
            checkPs.setString(1, username);
            checkPs.setString(2, oldPassword);
            ResultSet rs = checkPs.executeQuery();
            
            if (rs.next()) {
                String updateSql = "UPDATE st_admin SET password = ? WHERE username = ?";
                PreparedStatement updatePs = con.prepareStatement(updateSql);
                updatePs.setString(1, newPassword);
                updatePs.setString(2, username);
                
                int rows = updatePs.executeUpdate();
                if (rows > 0) {
                    changed = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return changed;
    }
    public boolean verifyPassword(String username, String hashedPassword) {
        boolean verified = false;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM st_admin WHERE username = ? AND password = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, hashedPassword);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                verified = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return verified;
    }
    public boolean changePassword(String username, String hashedNewPassword) {
        boolean changed = false;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "UPDATE st_admin SET password = ? WHERE username = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, hashedNewPassword);
            ps.setString(2, username);
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                changed = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return changed;
    }
    public boolean usernameExists(String username) {
        boolean exists = false;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM st_admin WHERE username = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                exists = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return exists;
    }
    public boolean updateUsername(String oldUsername, String newUsername) {
        boolean updated = false;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "UPDATE st_admin SET username = ? WHERE username = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, newUsername);
            ps.setString(2, oldUsername);
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                updated = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return updated;
    }
    }
