package com.school.controller.admin;

import java.io.IOException;
import java.util.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminClassDAO;

@WebServlet("/admin/attendance/detail")
public class AdminAttendanceDetailServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        int    studentId = Integer.parseInt(req.getParameter("studentId"));
        String month     = req.getParameter("month");

        AdminClassDAO dao = new AdminClassDAO();
        List<Map<String, String>> records = dao.getAttendanceDetailByStudentMonth(studentId, month);

        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < records.size(); i++) {
            Map<String, String> r = records.get(i);
            if (i > 0) sb.append(",");
            sb.append("{\"date\":\"").append(esc(r.get("date"))).append("\",")
              .append("\"day\":\"").append(esc(r.get("day"))).append("\",")
              .append("\"status\":\"").append(esc(r.get("status"))).append("\"}");
        }
        sb.append("]");
        res.getWriter().write(sb.toString());
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}