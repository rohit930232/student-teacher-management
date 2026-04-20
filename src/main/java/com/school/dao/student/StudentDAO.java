package com.school.dao.student;

import java.sql.Connection;
import java.sql.PreparedStatement;

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
            if (s.getClass_id() == 0) {
                throw new RuntimeException("Class ID is 0 (NOT SET)");
            }
            ps.setInt(9, s.getClass_id());
            ps.setString(10, s.getFather_name());
            ps.setString(11, s.getMother_name());
            ps.setString(12, s.getParents_mobile());
            ps.setString(13, s.getFather_occupation());
            ps.setString(14, s.getMother_occupation());
            if (s.getAnnual_income() != 0) {
                ps.setDouble(15, s.getAnnual_income());
            } else {
                ps.setNull(15, java.sql.Types.DOUBLE);
            }
            if (s.getDob() != null) {
                ps.setDate(16, new java.sql.Date(s.getDob().getTime()));
            } else {
                ps.setNull(16, java.sql.Types.DATE);
            }
            ps.setString(17, s.getBlood_group());
            ps.setString(18, s.getGender());
            if (s.getRoll_number() != 0) {
                ps.setInt(19, s.getRoll_number());
            } else {
                ps.setNull(19, java.sql.Types.INTEGER);
            }
            int i = ps.executeUpdate();
            if (i > 0) {
                status = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }
}