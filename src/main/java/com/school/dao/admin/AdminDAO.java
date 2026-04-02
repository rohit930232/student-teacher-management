package com.school.dao.admin;

import java.sql.Connection;
import java.sql.PreparedStatement;

import com.school.model.admin.Admin;
import com.school.util.DBConnection;

public class AdminDAO {

    public boolean insertAdmin(Admin a) {

        boolean status = false;

        try {

            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO st_admin (admin_id, username, fullname, email, password, dob, gender, mobile, photo, address, created_date, status) VALUES (st_admin_seq.NEXTVAL,?,?,?,?,?,?,?,?,?,SYSDATE,'ACTIVE')";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, a.getUsername());
            ps.setString(2, a.getFullname());
            ps.setString(3, a.getEmail());
            ps.setString(4, a.getPassword());
            ps.setDate(5, new java.sql.Date(a.getDob().getTime()));
            ps.setString(6, a.getGender());
            ps.setString(7, a.getMobile());
            ps.setString(8, a.getPhoto());
            ps.setString(9, a.getAddress());

            int i = ps.executeUpdate();

            if(i > 0) status = true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
}