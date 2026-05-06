package com.school.dao.admin;

import java.sql.*;
import java.util.*;
import com.school.util.DBConnection;

public class AdminNoticeDAO {

    private Connection getConn() {
        return DBConnection.getConnection();
    }

    public boolean addNotice(String message, int classId) {
        try {
            Connection con = getConn();
            String sql = "INSERT INTO st_notice (notice_id, message, class_id, created_date) VALUES (st_notice_seq.NEXTVAL, ?, ?, SYSDATE)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, message);
            if (classId == 0) {
                ps.setNull(2, Types.INTEGER);
            } else {
                ps.setInt(2, classId);
            }
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteNotice(int noticeId) {
        try {
            Connection con = getConn();
            String sql = "DELETE FROM st_notice WHERE notice_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, noticeId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Map<String, String>> getAllNotices() {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT n.notice_id, n.message, n.created_date, c.class_name "
                       + "FROM st_notice n LEFT JOIN st_class c ON n.class_id = c.class_id "
                       + "ORDER BY n.created_date DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("notice_id",    rs.getString("notice_id"));
                m.put("message",      rs.getString("message"));
                m.put("created_date", rs.getString("created_date"));
                m.put("class_name",   rs.getString("class_name"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, String>> getClassList() {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT class_id, class_name FROM st_class ORDER BY class_id";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("class_id",   rs.getString("class_id"));
                m.put("class_name", rs.getString("class_name"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}