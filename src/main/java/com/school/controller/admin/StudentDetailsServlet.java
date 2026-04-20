package com.school.controller.admin;

import java.io.IOException;
import java.text.SimpleDateFormat;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.school.dao.admin.AdminStudentDAO;
import com.school.model.student.Student;

@WebServlet("/Admin/StudentDetails")
public class StudentDetailsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        String username = req.getParameter("username");
        AdminStudentDAO dao = new AdminStudentDAO();
        Student s = dao.getStudentByUsername(username);
        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");
        String dobStr = "";
        if (s.getDob() != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            dobStr = sdf.format(s.getDob());
        }
        String photoPath = "";
        if (s.getPhoto() != null && !s.getPhoto().isEmpty()) {
            photoPath = s.getPhoto();
        }
        String json = "{"
                + "\"student_id\":\"" + s.getStudent_id() + "\","
                + "\"name\":\"" + escapeJson(s.getName()) + "\","
                + "\"roll_number\":\"" + s.getRoll_number() + "\","
                + "\"email\":\"" + escapeJson(s.getEmail()) + "\","
                + "\"mobile\":\"" + escapeJson(s.getStudent_mobile()) + "\","
                + "\"gender\":\"" + escapeJson(s.getGender()) + "\","
                + "\"permanent_address\":\"" + escapeJson(s.getPermanent_address()) + "\","
                + "\"temporary_address\":\"" + escapeJson(s.getTemporary_address()) + "\","
                + "\"father_name\":\"" + escapeJson(s.getFather_name()) + "\","
                + "\"mother_name\":\"" + escapeJson(s.getMother_name()) + "\","
                + "\"parents_mobile\":\"" + escapeJson(s.getParents_mobile()) + "\","
                + "\"father_occupation\":\"" + escapeJson(s.getFather_occupation()) + "\","
                + "\"mother_occupation\":\"" + escapeJson(s.getMother_occupation()) + "\","
                + "\"annual_income\":\"" + s.getAnnual_income() + "\","
                + "\"dob\":\"" + dobStr + "\","
                + "\"blood_group\":\"" + escapeJson(s.getBlood_group()) + "\","
                + "\"fees_paid\":\"" + s.getFees_paid() + "\","
                + "\"fees_remaining\":\"" + s.getFees_remaining() + "\","
                + "\"photo\":\"" + escapeJson(photoPath) + "\""
                + "}";
        res.getWriter().write(json);
    }
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}