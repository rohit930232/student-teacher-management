package com.school.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.school.model.admin.Admin;
import com.school.model.teacher.Teacher;
import com.school.model.student.Student;
import com.school.util.DBConnection;

public class LoginDAO {
    public Object checkLogin(String username, String password, String role) {
        Object user = null;
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
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                if(role.equals("admin")) {
                    Admin a = new Admin();
                    a.setUsername(rs.getString("username"));
                    a.setFullname(rs.getString("fullname"));
                    a.setPhoto(rs.getString("photo"));
                    user = a;
                }
                else if(role.equals("teacher")) {
                    Teacher t = new Teacher();
                    t.setUsername(rs.getString("username"));
                    t.setName(rs.getString("name"));
                    t.setPhoto(rs.getString("photo"));
                    user = t;
                }
                else {
                    Student s = new Student();
                    s.setUsername(rs.getString("username"));
                    s.setName(rs.getString("name"));
                    s.setPhoto(rs.getString("photo"));
                    user = s;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }
}