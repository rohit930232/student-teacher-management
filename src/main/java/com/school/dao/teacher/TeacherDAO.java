package com.school.dao.teacher;

import java.sql.*;
import java.util.*;

import com.school.model.teacher.Teacher;
import com.school.util.DBConnection;

public class TeacherDAO {
    public boolean insertTeacher(Teacher t) {
        boolean status = false;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "INSERT INTO st_teacher (teacher_id, username, name, email, password, mobile, subject, salary, photo, class_id, dob, age, gender, qualification, experience, class_teacher, status, account_holder, account_number, bank_name, ifsc_code, branch, pan_number, upi_id, address, permanent_address, joining_date, created_date, remaining_salary) VALUES (st_teacher_seq.NEXTVAL,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE,SYSDATE,0)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, t.getUsername());
            ps.setString(2, t.getName());
            ps.setString(3, t.getEmail());
            ps.setString(4, t.getPassword());
            ps.setString(5, t.getMobile());
            ps.setString(6, t.getSubject());
            ps.setDouble(7, t.getSalary());
            ps.setString(8, t.getPhoto());
            ps.setInt(9, t.getClass_id());
            ps.setDate(10, new java.sql.Date(t.getDob().getTime()));
            ps.setInt(11, t.getAge());
            ps.setString(12, t.getGender());
            ps.setString(13, t.getQualification());
            ps.setInt(14, t.getExperience());
            ps.setString(15, t.getClass_teacher());
            ps.setString(16, t.getStatus());
            ps.setString(17, t.getAccount_holder());
            ps.setString(18, t.getAccount_number());
            ps.setString(19, t.getBank_name());
            ps.setString(20, t.getIfsc_code());
            ps.setString(21, t.getBranch());
            ps.setString(22, t.getPan_number());
            ps.setString(23, t.getUpi_id());
            ps.setString(24, t.getAddress());
            ps.setString(25, t.getPermanent_address());
            int i = ps.executeUpdate();
            if (i > 0) status = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }
    public List<Teacher> getAllTeachers() {
        List<Teacher> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM st_teacher";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Teacher t = new Teacher();
                t.setUsername(rs.getString("username"));
                t.setName(rs.getString("name"));
                t.setEmail(rs.getString("email"));
                t.setMobile(rs.getString("mobile"));
                t.setSalary(rs.getDouble("salary"));
                t.setSubject(rs.getString("subject"));
                t.setPhoto(rs.getString("photo"));
                t.setClass_teacher(rs.getString("class_teacher"));
                t.setClass_id(rs.getInt("class_id"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public Teacher getTeacherByUsername(String username) {
        Teacher t = null;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM st_teacher WHERE username=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                t = new Teacher();
                t.setTeacher_id(rs.getInt("teacher_id"));
                t.setUsername(rs.getString("username"));
                t.setName(rs.getString("name"));
                t.setEmail(rs.getString("email"));
                t.setPassword(rs.getString("password"));
                t.setMobile(rs.getString("mobile"));
                t.setSubject(rs.getString("subject"));
                t.setSalary(rs.getDouble("salary"));
                t.setPhoto(rs.getString("photo"));
                t.setClass_id(rs.getInt("class_id"));
                t.setDob(rs.getDate("dob"));
                t.setAge(rs.getInt("age"));
                t.setGender(rs.getString("gender"));
                t.setQualification(rs.getString("qualification"));
                t.setExperience(rs.getInt("experience"));
                t.setClass_teacher(rs.getString("class_teacher"));
                t.setStatus(rs.getString("status"));
                t.setAccount_holder(rs.getString("account_holder"));
                t.setAccount_number(rs.getString("account_number"));
                t.setBank_name(rs.getString("bank_name"));
                t.setIfsc_code(rs.getString("ifsc_code"));
                t.setBranch(rs.getString("branch"));
                t.setPan_number(rs.getString("pan_number"));
                t.setUpi_id(rs.getString("upi_id"));
                t.setAddress(rs.getString("address"));
                t.setPermanent_address(rs.getString("permanent_address"));
                t.setJoining_date(rs.getDate("joining_date"));
                t.setRemaining_salary(rs.getDouble("remaining_salary"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return t;
    }
    public boolean updateTeacher(Teacher t) {
        boolean status = false;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "UPDATE st_teacher SET name=?, email=?, mobile=?, salary=?, subject=? WHERE username=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, t.getName());
            ps.setString(2, t.getEmail());
            ps.setString(3, t.getMobile());
            ps.setDouble(4, t.getSalary());
            ps.setString(5, t.getSubject());
            ps.setString(6, t.getUsername());
            int i = ps.executeUpdate();
            if (i > 0) status = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }
    public boolean deleteTeacher(String username) {
        boolean status = false;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "DELETE FROM st_teacher WHERE username=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            int i = ps.executeUpdate();
            if (i > 0) status = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }
    public boolean updateTeacherFull(Teacher t) {
        boolean status = false;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "UPDATE st_teacher SET salary=?, remaining_salary=?, class_teacher=?, class_id=?, subject=?, status=?, experience=? WHERE username=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDouble(1, t.getSalary());
            ps.setDouble(2, t.getRemaining_salary());
            ps.setString(3, t.getClass_teacher());
            ps.setInt(4, t.getClass_id());
            ps.setString(5, t.getSubject());
            ps.setString(6, t.getStatus());
            ps.setInt(7, t.getExperience());
            ps.setString(8, t.getUsername());
            int i = ps.executeUpdate();
            if (i > 0) status = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }
}