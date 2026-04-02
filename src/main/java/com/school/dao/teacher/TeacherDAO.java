package com.school.dao.teacher;

import java.sql.Connection;
import java.sql.PreparedStatement;

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

            // 🔥 important part
            ps.setString(24, t.getAddress());
            ps.setString(25, t.getPermanent_address());

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