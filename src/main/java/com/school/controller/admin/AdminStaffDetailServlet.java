package com.school.controller.admin;

import java.io.IOException;
import java.util.Map;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminStaffDAO;

@WebServlet("/admin/staff/detail")
public class AdminStaffDetailServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        AdminStaffDAO dao = new AdminStaffDAO();
        Map<String, String> s = dao.getStaffById(id);

        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        String json = "{"
            + "\"name\":\"" + esc(s.get("name")) + "\","
            + "\"role\":\"" + esc(s.get("role")) + "\","
            + "\"mobile\":\"" + esc(s.get("mobile")) + "\","
            + "\"email\":\"" + esc(s.get("email")) + "\","
            + "\"gender\":\"" + esc(s.get("gender")) + "\","
            + "\"dob\":\"" + esc(s.get("dob")) + "\","
            + "\"salary\":\"" + esc(s.get("salary")) + "\","
            + "\"status\":\"" + esc(s.get("status")) + "\","
            + "\"photo\":\"" + esc(s.get("photo")) + "\","
            + "\"address\":\"" + esc(s.get("address")) + "\","
            + "\"joining_date\":\"" + esc(s.get("joining_date")) + "\""
            + "}";

        res.getWriter().write(json);
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}