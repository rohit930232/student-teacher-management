package com.school.dao.admin;
import java.sql.*;
import java.util.*;
import com.school.model.student.Student;
import com.school.util.DBConnection;

public class AdminStudentDAO {
    private Connection con;
    public AdminStudentDAO() {
        con = DBConnection.getConnection();
    }
    public List<String[]> getClassStudentCount() {
        List<String[]> list = new ArrayList<>();
        try {
            String sql = "SELECT c.class_id, c.class_name, COUNT(s.username) total "
                    + "FROM st_class c LEFT JOIN st_student s "
                    + "ON c.class_id = s.class_id "
                    + "GROUP BY c.class_id, c.class_name";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new String[]{
                        rs.getString("class_id"),
                        rs.getString("class_name"),
                        rs.getString("total")
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Student> getStudentsByClass(int classId) {
        List<Student> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM st_student WHERE class_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Student s = new Student();
                s.setRoll_number(rs.getInt("roll_number"));
                s.setName(rs.getString("name"));
                s.setPhoto(rs.getString("photo"));
                s.setUsername(rs.getString("username"));
                s.setEmail(rs.getString("email"));
                s.setStudent_mobile(rs.getString("mobile"));
                s.setGender(rs.getString("gender"));
                list.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public Student getStudentByUsername(String username) {
        Student s = new Student();
        try {
            String sql = "SELECT * FROM st_student WHERE username=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                s.setStudent_id(rs.getInt("student_id"));
                s.setName(rs.getString("name"));
                s.setRoll_number(rs.getInt("roll_number"));
                s.setEmail(rs.getString("email"));
                s.setStudent_mobile(rs.getString("mobile"));
                s.setPermanent_address(rs.getString("permanent_address"));
                s.setTemporary_address(rs.getString("temporary_address"));
                s.setPhoto(rs.getString("photo"));
                s.setClass_id(rs.getInt("class_id"));
                s.setFees_paid(rs.getDouble("fees_paid"));
                s.setFees_remaining(rs.getDouble("fees_remaining"));
                s.setUsername(rs.getString("username"));
                s.setFather_name(rs.getString("father_name"));
                s.setMother_name(rs.getString("mother_name"));
                s.setParents_mobile(rs.getString("parents_mobile"));
                s.setFather_occupation(rs.getString("father_occupation"));
                s.setMother_occupation(rs.getString("mother_occupation"));
                s.setAnnual_income(rs.getDouble("annual_income"));
                s.setDob(rs.getDate("dob"));
                s.setBlood_group(rs.getString("blood_group"));
                s.setGender(rs.getString("gender"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return s;
    }
}