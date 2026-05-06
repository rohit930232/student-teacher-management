package com.school.controller.admin;

import java.io.IOException;
import java.util.Map;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminTeacherDAO;

@WebServlet("/Admin/ViewTeacherDetail")
public class AdminViewTeacherDetailServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        String username = req.getParameter("username");
        AdminTeacherDAO dao = new AdminTeacherDAO();
        Map<String, String> t = dao.getTeacherDetailByUsername(username);

        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        String json = "{"
            + "\"teacher_id\":\"" + esc(t.get("teacher_id")) + "\","
            + "\"name\":\"" + esc(t.get("name")) + "\","
            + "\"email\":\"" + esc(t.get("email")) + "\","
            + "\"mobile\":\"" + esc(t.get("mobile")) + "\","
            + "\"gender\":\"" + esc(t.get("gender")) + "\","
            + "\"dob\":\"" + esc(t.get("dob")) + "\","
            + "\"subject\":\"" + esc(t.get("subject")) + "\","
            + "\"qualification\":\"" + esc(t.get("qualification")) + "\","
            + "\"experience\":\"" + esc(t.get("experience")) + "\","
            + "\"class_name\":\"" + esc(t.get("class_name")) + "\","
            + "\"class_teacher\":\"" + esc(t.get("class_teacher")) + "\","
            + "\"status\":\"" + esc(t.get("status")) + "\","
            + "\"salary\":\"" + esc(t.get("salary")) + "\","
            + "\"remaining_salary\":\"" + esc(t.get("remaining_salary")) + "\","
            + "\"joining_date\":\"" + esc(t.get("joining_date")) + "\","
            + "\"account_holder\":\"" + esc(t.get("account_holder")) + "\","
            + "\"account_number\":\"" + esc(t.get("account_number")) + "\","
            + "\"bank_name\":\"" + esc(t.get("bank_name")) + "\","
            + "\"ifsc_code\":\"" + esc(t.get("ifsc_code")) + "\","
            + "\"upi_id\":\"" + esc(t.get("upi_id")) + "\","
            + "\"address\":\"" + esc(t.get("address")) + "\","
            + "\"permanent_address\":\"" + esc(t.get("permanent_address")) + "\","
            + "\"photo\":\"" + esc(t.get("photo")) + "\""
            + "}";

        res.getWriter().write(json);
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}