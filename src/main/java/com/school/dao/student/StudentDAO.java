package com.school.dao.student;

import java.sql.*;
import java.util.*;
import com.school.model.student.Student;
import com.school.util.DBConnection;

public class StudentDAO {

    public boolean insertStudent(Student s) {
        boolean status = false;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "INSERT INTO st_student (student_id, username, name, email, password, mobile, permanent_address, temporary_address, photo, class_id, father_name, mother_name, parents_mobile, father_occupation, mother_occupation, annual_income, dob, blood_group, gender, roll_number) VALUES (st_student_seq.NEXTVAL,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, s.getUsername());
            ps.setString(2, s.getName());
            ps.setString(3, s.getEmail());
            ps.setString(4, s.getPassword());
            ps.setString(5, s.getStudent_mobile());
            ps.setString(6, s.getPermanent_address());
            ps.setString(7, s.getTemporary_address());
            ps.setString(8, s.getPhoto());
            if (s.getClass_id() == 0) throw new RuntimeException("Class ID is 0");
            ps.setInt(9, s.getClass_id());
            ps.setString(10, s.getFather_name());
            ps.setString(11, s.getMother_name());
            ps.setString(12, s.getParents_mobile());
            ps.setString(13, s.getFather_occupation());
            ps.setString(14, s.getMother_occupation());
            if (s.getAnnual_income() != 0) ps.setDouble(15, s.getAnnual_income());
            else ps.setNull(15, java.sql.Types.DOUBLE);
            if (s.getDob() != null) ps.setDate(16, new java.sql.Date(s.getDob().getTime()));
            else ps.setNull(16, java.sql.Types.DATE);
            ps.setString(17, s.getBlood_group());
            ps.setString(18, s.getGender());
            if (s.getRoll_number() != 0) ps.setInt(19, s.getRoll_number());
            else ps.setNull(19, java.sql.Types.INTEGER);
            int i = ps.executeUpdate();
            if (i > 0) status = true;
        } catch (Exception e) { e.printStackTrace(); }
        return status;
    }

    public Student getStudentByUsername(String username) {
        Student s = null;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM st_student WHERE username=?");
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                s = new Student();
                s.setStudent_id(rs.getInt("student_id"));
                s.setUsername(rs.getString("username"));
                s.setName(rs.getString("name"));
                s.setEmail(rs.getString("email"));
                s.setPassword(rs.getString("password"));
                s.setStudent_mobile(rs.getString("mobile"));
                s.setPermanent_address(rs.getString("permanent_address"));
                s.setTemporary_address(rs.getString("temporary_address"));
                s.setPhoto(rs.getString("photo"));
                s.setClass_id(rs.getInt("class_id"));
                s.setFather_name(rs.getString("father_name"));
                s.setMother_name(rs.getString("mother_name"));
                s.setParents_mobile(rs.getString("parents_mobile"));
                s.setFather_occupation(rs.getString("father_occupation"));
                s.setMother_occupation(rs.getString("mother_occupation"));
                s.setAnnual_income(rs.getDouble("annual_income"));
                s.setDob(rs.getDate("dob"));
                s.setBlood_group(rs.getString("blood_group"));
                s.setGender(rs.getString("gender"));
                s.setRoll_number(rs.getInt("roll_number"));
                s.setFees_paid(rs.getDouble("fees_paid"));
                s.setFees_remaining(rs.getDouble("fees_remaining"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return s;
    }

    public Student getStudentById(int studentId) {
        Student s = null;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM st_student WHERE student_id=?");
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                s = new Student();
                s.setStudent_id(rs.getInt("student_id"));
                s.setUsername(rs.getString("username"));
                s.setName(rs.getString("name"));
                s.setEmail(rs.getString("email"));
                s.setStudent_mobile(rs.getString("mobile"));
                s.setPermanent_address(rs.getString("permanent_address"));
                s.setTemporary_address(rs.getString("temporary_address"));
                s.setPhoto(rs.getString("photo"));
                s.setClass_id(rs.getInt("class_id"));
                s.setFather_name(rs.getString("father_name"));
                s.setMother_name(rs.getString("mother_name"));
                s.setParents_mobile(rs.getString("parents_mobile"));
                s.setFather_occupation(rs.getString("father_occupation"));
                s.setMother_occupation(rs.getString("mother_occupation"));
                s.setAnnual_income(rs.getDouble("annual_income"));
                s.setDob(rs.getDate("dob"));
                s.setBlood_group(rs.getString("blood_group"));
                s.setGender(rs.getString("gender"));
                s.setRoll_number(rs.getInt("roll_number"));
                s.setFees_paid(rs.getDouble("fees_paid"));
                s.setFees_remaining(rs.getDouble("fees_remaining"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return s;
    }

    public List<Student> getAllStudents() {
        List<Student> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM st_student ORDER BY name");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Student s = new Student();
                s.setStudent_id(rs.getInt("student_id"));
                s.setUsername(rs.getString("username"));
                s.setName(rs.getString("name"));
                s.setEmail(rs.getString("email"));
                s.setStudent_mobile(rs.getString("mobile"));
                s.setPhoto(rs.getString("photo"));
                s.setClass_id(rs.getInt("class_id"));
                s.setRoll_number(rs.getInt("roll_number"));
                s.setFees_paid(rs.getDouble("fees_paid"));
                s.setFees_remaining(rs.getDouble("fees_remaining"));
                s.setGender(rs.getString("gender"));
                list.add(s);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Student> getStudentsByClass(int classId) {
        List<Student> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM st_student WHERE class_id=? ORDER BY roll_number");
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Student s = new Student();
                s.setStudent_id(rs.getInt("student_id"));
                s.setUsername(rs.getString("username"));
                s.setName(rs.getString("name"));
                s.setEmail(rs.getString("email"));
                s.setStudent_mobile(rs.getString("mobile"));
                s.setPhoto(rs.getString("photo"));
                s.setClass_id(rs.getInt("class_id"));
                s.setRoll_number(rs.getInt("roll_number"));
                s.setFees_paid(rs.getDouble("fees_paid"));
                s.setFees_remaining(rs.getDouble("fees_remaining"));
                s.setGender(rs.getString("gender"));
                s.setBlood_group(rs.getString("blood_group"));
                s.setFather_name(rs.getString("father_name"));
                s.setMother_name(rs.getString("mother_name"));
                s.setParents_mobile(rs.getString("parents_mobile"));
                s.setFather_occupation(rs.getString("father_occupation"));
                s.setMother_occupation(rs.getString("mother_occupation"));
                s.setAnnual_income(rs.getDouble("annual_income"));
                s.setDob(rs.getDate("dob"));
                s.setPermanent_address(rs.getString("permanent_address"));
                s.setTemporary_address(rs.getString("temporary_address"));
                list.add(s);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean updateStudentPersonal(String currentUsername, String name, String newUsername,
                                          String dob, String gender, String bloodGroup, String photoPath) {
        boolean status = false;
        try {
            Connection con = DBConnection.getConnection();
            StringBuilder sql = new StringBuilder("UPDATE st_student SET name=?, username=?, dob=?, gender=?, blood_group=?");
            if (photoPath != null) sql.append(", photo=?");
            sql.append(" WHERE username=?");
            PreparedStatement ps = con.prepareStatement(sql.toString());
            int i = 1;
            ps.setString(i++, name);
            ps.setString(i++, newUsername);
            ps.setDate(i++, dob != null && !dob.isEmpty() ? java.sql.Date.valueOf(dob) : null);
            ps.setString(i++, gender);
            ps.setString(i++, bloodGroup);
            if (photoPath != null) ps.setString(i++, photoPath);
            ps.setString(i++, currentUsername);
            if (ps.executeUpdate() > 0) status = true;
        } catch (Exception e) { e.printStackTrace(); }
        return status;
    }

    public boolean updateStudentContact(String username, String email, String mobile,
                                         String tempAddress, String permAddress) {
        boolean status = false;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("UPDATE st_student SET email=?, mobile=?, temporary_address=?, permanent_address=? WHERE username=?");
            ps.setString(1, email);
            ps.setString(2, mobile);
            ps.setString(3, tempAddress);
            ps.setString(4, permAddress);
            ps.setString(5, username);
            if (ps.executeUpdate() > 0) status = true;
        } catch (Exception e) { e.printStackTrace(); }
        return status;
    }

    public boolean updateStudentFamily(String username, String fatherName, String motherName,
                                        String parentsMobile, String fatherOcc, String motherOcc, double income) {
        boolean status = false;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("UPDATE st_student SET father_name=?, mother_name=?, parents_mobile=?, father_occupation=?, mother_occupation=?, annual_income=? WHERE username=?");
            ps.setString(1, fatherName);
            ps.setString(2, motherName);
            ps.setString(3, parentsMobile);
            ps.setString(4, fatherOcc);
            ps.setString(5, motherOcc);
            ps.setDouble(6, income);
            ps.setString(7, username);
            if (ps.executeUpdate() > 0) status = true;
        } catch (Exception e) { e.printStackTrace(); }
        return status;
    }

    public boolean updateStudentFees(int studentId, double feesPaid, double feesRemaining) {
        boolean status = false;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("UPDATE st_student SET fees_paid=?, fees_remaining=? WHERE student_id=?");
            ps.setDouble(1, feesPaid);
            ps.setDouble(2, feesRemaining);
            ps.setInt(3, studentId);
            if (ps.executeUpdate() > 0) status = true;
        } catch (Exception e) { e.printStackTrace(); }
        return status;
    }

    public boolean updatePassword(String username, String hashedNewPassword) {
        boolean status = false;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("UPDATE st_student SET password=? WHERE username=?");
            ps.setString(1, hashedNewPassword);
            ps.setString(2, username);
            if (ps.executeUpdate() > 0) status = true;
        } catch (Exception e) { e.printStackTrace(); }
        return status;
    }

    public boolean verifyPassword(String username, String hashedPassword) {
        boolean verified = false;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT student_id FROM st_student WHERE username=? AND password=?");
            ps.setString(1, username);
            ps.setString(2, hashedPassword);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) verified = true;
        } catch (Exception e) { e.printStackTrace(); }
        return verified;
    }

    public boolean usernameExists(String username) {
        boolean exists = false;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT username FROM st_student WHERE username=?");
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) exists = true;
        } catch (Exception e) { e.printStackTrace(); }
        return exists;
    }

    public boolean deleteStudent(int studentId) {
        boolean status = false;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("DELETE FROM st_student WHERE student_id=?");
            ps.setInt(1, studentId);
            if (ps.executeUpdate() > 0) status = true;
        } catch (Exception e) { e.printStackTrace(); }
        return status;
    }

    public int getTotalStudents() {
        int count = 0;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM st_student");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    public int getTotalStudentsByClass(int classId) {
        int count = 0;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM st_student WHERE class_id=?");
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }
}