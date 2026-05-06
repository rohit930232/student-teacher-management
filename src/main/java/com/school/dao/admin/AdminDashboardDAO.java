package com.school.dao.admin;

import java.sql.*;
import java.util.*;
import com.school.util.DBConnection;

public class AdminDashboardDAO {

    private Connection getConn() {
        return DBConnection.getConnection();
    }

    public int getTotalStudents() {
        try {
            PreparedStatement ps = getConn().prepareStatement("SELECT COUNT(*) FROM st_student");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int getTotalTeachers() {
        try {
            PreparedStatement ps = getConn().prepareStatement("SELECT COUNT(*) FROM st_teacher");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int getTotalClasses() {
        try {
            PreparedStatement ps = getConn().prepareStatement("SELECT COUNT(*) FROM st_class");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int getTotalStaff() {
        try {
            PreparedStatement ps = getConn().prepareStatement("SELECT COUNT(*) FROM st_staff");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public List<String> getRecentNotices() {
        List<String> list = new ArrayList<>();
        try {
            String sql = "SELECT message FROM st_notice ORDER BY created_date DESC FETCH FIRST 5 ROWS ONLY";
            PreparedStatement ps = getConn().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(rs.getString("message"));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, String>> getRecentNotifications() {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            String sql = "SELECT message, created_date FROM st_notification ORDER BY created_date DESC FETCH FIRST 5 ROWS ONLY";
            PreparedStatement ps = getConn().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("message", rs.getString("message"));
                m.put("time",    rs.getString("created_date"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, String>> getUpcomingExams() {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            String sql = "SELECT e.subject, e.exam_date, c.class_name FROM st_exam e "
                       + "LEFT JOIN st_class c ON e.class_id = c.class_id "
                       + "WHERE e.exam_date >= TRUNC(SYSDATE) "
                       + "ORDER BY e.exam_date FETCH FIRST 5 ROWS ONLY";
            PreparedStatement ps = getConn().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("subject",    rs.getString("subject"));
                m.put("exam_date",  rs.getString("exam_date"));
                m.put("class_name", rs.getString("class_name"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}