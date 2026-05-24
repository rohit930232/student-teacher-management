package com.school.dao.admin;

import java.sql.*;
import java.util.*;
import com.school.util.DBConnection;

public class AdminAttendanceDAO {

    private Connection getConn() {
        return DBConnection.getConnection();
    }

    public boolean markTeacherAttendance(int teacherId, String date, String status) {
        try {
            Connection con = getConn();
            int year = Integer.parseInt(date.substring(0, 4));

            String checkSql = "SELECT att_id FROM st_teacher_attendance WHERE teacher_id=? AND TRUNC(att_date)=TO_DATE(?,'YYYY-MM-DD')";
            PreparedStatement chk = con.prepareStatement(checkSql);
            chk.setInt(1, teacherId);
            chk.setString(2, date);
            ResultSet rs = chk.executeQuery();

            if (rs.next()) {
                int attId = rs.getInt("att_id");
                String upd = "UPDATE st_teacher_attendance SET status=? WHERE att_id=?";
                PreparedStatement ps = con.prepareStatement(upd);
                ps.setString(1, status);
                ps.setInt(2, attId);
                return ps.executeUpdate() > 0;
            } else {
                String ins = "INSERT INTO st_teacher_attendance (att_id, teacher_id, att_date, status, marked_year) "
                           + "VALUES (st_teacher_att_seq.NEXTVAL, ?, TO_DATE(?,'YYYY-MM-DD'), ?, ?)";
                PreparedStatement ps = con.prepareStatement(ins);
                ps.setInt(1, teacherId);
                ps.setString(2, date);
                ps.setString(3, status);
                ps.setInt(4, year);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean markStaffAttendance(int staffId, String date, String status) {
        try {
            Connection con = getConn();
            int year = Integer.parseInt(date.substring(0, 4));

            String checkSql = "SELECT att_id FROM st_staff_attendance WHERE staff_id=? AND TRUNC(att_date)=TO_DATE(?,'YYYY-MM-DD')";
            PreparedStatement chk = con.prepareStatement(checkSql);
            chk.setInt(1, staffId);
            chk.setString(2, date);
            ResultSet rs = chk.executeQuery();

            if (rs.next()) {
                int attId = rs.getInt("att_id");
                String upd = "UPDATE st_staff_attendance SET status=? WHERE att_id=?";
                PreparedStatement ps = con.prepareStatement(upd);
                ps.setString(1, status);
                ps.setInt(2, attId);
                return ps.executeUpdate() > 0;
            } else {
                String ins = "INSERT INTO st_staff_attendance (att_id, staff_id, att_date, status, marked_year) "
                           + "VALUES (st_staff_att_seq.NEXTVAL, ?, TO_DATE(?,'YYYY-MM-DD'), ?, ?)";
                PreparedStatement ps = con.prepareStatement(ins);
                ps.setInt(1, staffId);
                ps.setString(2, date);
                ps.setString(3, status);
                ps.setInt(4, year);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Map<String, Object> getTeacherAttendanceByMonth(int teacherId, String month) {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, String>> records = new ArrayList<>();
        int present = 0, absent = 0;

        try {
            Connection con = getConn();
            String sql = "SELECT TO_CHAR(att_date,'YYYY-MM-DD') AS att_date, "
                       + "TO_CHAR(att_date,'Day') AS day_name, status "
                       + "FROM st_teacher_attendance "
                       + "WHERE teacher_id=? AND TO_CHAR(att_date,'YYYY-MM')=? "
                       + "ORDER BY att_date";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, teacherId);
            ps.setString(2, month);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, String> r = new HashMap<>();
                r.put("date",   rs.getString("att_date"));
                r.put("day",    rs.getString("day_name").trim());
                r.put("status", rs.getString("status"));
                if ("Present".equals(rs.getString("status"))) present++;
                else absent++;
                records.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        Map<String, Integer> summary = new HashMap<>();
        summary.put("present", present);
        summary.put("absent",  absent);
        summary.put("total",   present + absent);

        result.put("records", records);
        result.put("summary", summary);
        return result;
    }

    public Map<String, Object> getStaffAttendanceByMonth(int staffId, String month) {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, String>> records = new ArrayList<>();
        int present = 0, absent = 0;

        try {
            Connection con = getConn();
            String sql = "SELECT TO_CHAR(att_date,'YYYY-MM-DD') AS att_date, "
                       + "TO_CHAR(att_date,'Day') AS day_name, status "
                       + "FROM st_staff_attendance "
                       + "WHERE staff_id=? AND TO_CHAR(att_date,'YYYY-MM')=? "
                       + "ORDER BY att_date";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, staffId);
            ps.setString(2, month);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, String> r = new HashMap<>();
                r.put("date",   rs.getString("att_date"));
                r.put("day",    rs.getString("day_name").trim());
                r.put("status", rs.getString("status"));
                if ("Present".equals(rs.getString("status"))) present++;
                else absent++;
                records.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        Map<String, Integer> summary = new HashMap<>();
        summary.put("present", present);
        summary.put("absent",  absent);
        summary.put("total",   present + absent);

        result.put("records", records);
        result.put("summary", summary);
        return result;
    }
}