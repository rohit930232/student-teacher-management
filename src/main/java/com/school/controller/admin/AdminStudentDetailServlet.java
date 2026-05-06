package com.school.controller.admin;

import java.io.IOException;
import java.text.SimpleDateFormat;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminStudentDAO;
import com.school.model.student.Student;

@WebServlet("/admin/students/detail")
public class AdminStudentDetailServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");

        if (username == null || username.isEmpty()) {
            res.getWriter().write("{}");
            return;
        }

        try {
            AdminStudentDAO dao = new AdminStudentDAO();
            Student s = dao.getStudentByUsername(username);

            if (s == null) {
                res.getWriter().write("{}");
                return;
            }

            String dob = "";
            if (s.getDob() != null) {
                dob = new SimpleDateFormat("dd-MM-yyyy").format(s.getDob());
            }

            StringBuilder json = new StringBuilder("{");
            json.append("\"student_id\":\"").append(s.getStudent_id()).append("\",");
            json.append("\"name\":\"").append(esc(s.getName())).append("\",");
            json.append("\"roll_number\":\"").append(s.getRoll_number()).append("\",");
            json.append("\"email\":\"").append(esc(s.getEmail())).append("\",");
            json.append("\"mobile\":\"").append(esc(s.getStudent_mobile())).append("\",");
            json.append("\"gender\":\"").append(esc(s.getGender())).append("\",");
            json.append("\"dob\":\"").append(dob).append("\",");
            json.append("\"blood_group\":\"").append(esc(s.getBlood_group())).append("\",");
            json.append("\"fees_paid\":\"").append(s.getFees_paid()).append("\",");
            json.append("\"fees_remaining\":\"").append(s.getFees_remaining()).append("\",");
            json.append("\"father_name\":\"").append(esc(s.getFather_name())).append("\",");
            json.append("\"mother_name\":\"").append(esc(s.getMother_name())).append("\",");
            json.append("\"parents_mobile\":\"").append(esc(s.getParents_mobile())).append("\",");
            json.append("\"father_occupation\":\"").append(esc(s.getFather_occupation())).append("\",");
            json.append("\"mother_occupation\":\"").append(esc(s.getMother_occupation())).append("\",");
            json.append("\"annual_income\":\"").append(s.getAnnual_income()).append("\",");
            json.append("\"temporary_address\":\"").append(esc(s.getTemporary_address())).append("\",");
            json.append("\"permanent_address\":\"").append(esc(s.getPermanent_address())).append("\",");
            json.append("\"photo\":\"").append(esc(s.getPhoto())).append("\"");
            json.append("}");

            res.getWriter().write(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            res.getWriter().write("{}");
        }
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}