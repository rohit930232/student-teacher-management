package com.school.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.school.util.DBConnection;

public class LoginDAO {

    public boolean checkLogin(String username, String password, String role) {

        boolean status = false;

        try {

            Connection con = DBConnection.getConnection();

            String sql = "";

            if(role.equals("admin")) {
                sql = "SELECT * FROM st_admin WHERE username=? AND password=?";
            }
            else if(role.equals("teacher")) {
                sql = "SELECT * FROM st_teacher WHERE username=? AND password=?";
            }
            else if(role.equals("student")) {
                sql = "SELECT * FROM st_student WHERE username=? AND password=?";
            }

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, username);
            ps.setString(2, password); // already hashed from servlet

            ResultSet rs = ps.executeQuery();

            if(rs.next()) {
                status = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
}