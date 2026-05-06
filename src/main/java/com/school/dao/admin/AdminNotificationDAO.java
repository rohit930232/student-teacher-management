package com.school.dao.admin;

import java.sql.*;
import java.util.*;
import com.school.util.DBConnection;

public class AdminNotificationDAO {

    private Connection getConn() {
        return DBConnection.getConnection();
    }

    public boolean sendNotification(String message) {
        try {
            Connection con = getConn();
            String sql = "INSERT INTO st_notification (notification_id, message, created_date) VALUES (st_notification_seq.NEXTVAL, ?, SYSDATE)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, message);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteNotification(int id) {
        try {
            Connection con = getConn();
            String sql = "DELETE FROM st_notification WHERE notification_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Map<String, String>> getAllNotifications() {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT notification_id, message, created_date FROM st_notification ORDER BY created_date DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("notification_id", rs.getString("notification_id"));
                m.put("message",         rs.getString("message"));
                m.put("created_date",    rs.getString("created_date"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}