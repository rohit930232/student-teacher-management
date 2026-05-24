package com.school.dao.admin;

import java.sql.*;
import java.util.*;
import com.school.util.DBConnection;

public class AdminTimetableGridDAO {

    private Connection getConn() {
        return DBConnection.getConnection();
    }

    public boolean saveGrid(int classId, String gridName, String gridData) {
        try {
            Connection con = getConn();
            String sql = "INSERT INTO st_timetable_grid (grid_id, class_id, grid_name, grid_data, created_date) "
                       + "VALUES (st_timetable_grid_seq.NEXTVAL, ?, ?, ?, SYSDATE)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, classId);
            ps.setString(2, gridName);
            ps.setString(3, gridData);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Map<String, String>> getGridsByClass(int classId) {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT grid_id, grid_name, TO_CHAR(created_date,'DD-MM-YYYY') AS created_date "
                       + "FROM st_timetable_grid WHERE class_id = ? ORDER BY created_date DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("grid_id",      rs.getString("grid_id"));
                m.put("grid_name",    rs.getString("grid_name"));
                m.put("created_date", rs.getString("created_date"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public String getGridData(int gridId) {
        try {
            Connection con = getConn();
            String sql = "SELECT grid_data FROM st_timetable_grid WHERE grid_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, gridId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("grid_data");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "[]";
    }

    public boolean deleteGrid(int gridId) {
        try {
            Connection con = getConn();
            String sql = "DELETE FROM st_timetable_grid WHERE grid_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, gridId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}