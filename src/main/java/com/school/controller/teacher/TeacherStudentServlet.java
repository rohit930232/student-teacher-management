package com.school.controller.teacher;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.util.DBConnection;

@WebServlet("/teacher/students")
public class TeacherStudentServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection con = DBConnection.getConnection();
            String classIdParam = request.getParameter("class_id");

            List<Map<String,String>> classes = new ArrayList<>();
            PreparedStatement cPs = con.prepareStatement("SELECT * FROM st_class ORDER BY class_name");
            ResultSet cRs = cPs.executeQuery();
            while (cRs.next()) {
                Map<String,String> c = new HashMap<>();
                c.put("class_id",   String.valueOf(cRs.getInt("class_id")));
                c.put("class_name", cRs.getString("class_name"));
                classes.add(c);
            }
            request.setAttribute("classes", classes);

            if (classIdParam != null && !classIdParam.isEmpty()) {
                int classId = Integer.parseInt(classIdParam);
                List<Map<String,String>> students = new ArrayList<>();
                String sql = "SELECT s.*, c.class_name FROM st_student s LEFT JOIN st_class c ON s.class_id=c.class_id WHERE s.class_id=? ORDER BY s.roll_number";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, classId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String,String> s = new HashMap<>();
                    s.put("student_id",        String.valueOf(rs.getInt("student_id")));
                    s.put("name",              rs.getString("name"));
                    s.put("roll_number",       String.valueOf(rs.getInt("roll_number")));
                    s.put("email",             rs.getString("email")             != null ? rs.getString("email")             : "");
                    s.put("mobile",            rs.getString("mobile")            != null ? rs.getString("mobile")            : "");
                    s.put("dob",               rs.getDate("dob")                 != null ? rs.getDate("dob").toString()      : "");
                    s.put("gender",            rs.getString("gender")            != null ? rs.getString("gender")            : "");
                    s.put("blood_group",       rs.getString("blood_group")       != null ? rs.getString("blood_group")       : "");
                    s.put("father_name",       rs.getString("father_name")       != null ? rs.getString("father_name")       : "");
                    s.put("mother_name",       rs.getString("mother_name")       != null ? rs.getString("mother_name")       : "");
                    s.put("parents_mobile",    rs.getString("parents_mobile")    != null ? rs.getString("parents_mobile")    : "");
                    s.put("father_occupation", rs.getString("father_occupation") != null ? rs.getString("father_occupation") : "");
                    s.put("mother_occupation", rs.getString("mother_occupation") != null ? rs.getString("mother_occupation") : "");
                    s.put("annual_income",     rs.getString("annual_income")     != null ? rs.getString("annual_income")     : "0");
                    s.put("address",           rs.getString("temporary_address") != null ? rs.getString("temporary_address") : "");
                    s.put("permanent_address", rs.getString("permanent_address") != null ? rs.getString("permanent_address") : "");
                    s.put("fees_paid",         rs.getString("fees_paid")         != null ? rs.getString("fees_paid")         : "0");
                    s.put("fees_remaining",    rs.getString("fees_remaining")    != null ? rs.getString("fees_remaining")    : "0");
                    s.put("photo",             rs.getString("photo")             != null ? rs.getString("photo")             : "");
                    s.put("class_name",        rs.getString("class_name")        != null ? rs.getString("class_name")        : "");
                    s.put("class_id",          String.valueOf(rs.getInt("class_id")));
                    students.add(s);
                }
                request.setAttribute("students", students);
            }
        } catch (Exception e) { e.printStackTrace(); }
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/teacher/students.jsp");
        rd.forward(request, response);
    }
}