package com.school.controller.admin;

import java.io.*;
import java.util.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminAttendanceDAO;

@WebServlet("/admin/attendance/staff/view")
public class AdminStaffAttViewServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        try {
            int    id    = Integer.parseInt(req.getParameter("id"));
            String month = req.getParameter("month");

            AdminAttendanceDAO dao = new AdminAttendanceDAO();
            Map<String, Object> data = dao.getStaffAttendanceByMonth(id, month);

            res.getWriter().write(toJson(data));
        } catch (Exception e) {
            e.printStackTrace();
            res.getWriter().write("{\"records\":[],\"summary\":{\"present\":0,\"absent\":0,\"total\":0}}");
        }
    }

    private String toJson(Map<String, Object> data) {
        List<Map<String, String>> records = (List<Map<String, String>>) data.get("records");
        Map<String, Integer> summary      = (Map<String, Integer>) data.get("summary");

        StringBuilder sb = new StringBuilder("{");
        sb.append("\"summary\":{")
          .append("\"present\":").append(summary.get("present")).append(",")
          .append("\"absent\":").append(summary.get("absent")).append(",")
          .append("\"total\":").append(summary.get("total"))
          .append("},");
        sb.append("\"records\":[");
        for (int i = 0; i < records.size(); i++) {
            if (i > 0) sb.append(",");
            Map<String, String> r = records.get(i);
            sb.append("{\"date\":\"").append(esc(r.get("date"))).append("\",")
              .append("\"day\":\"").append(esc(r.get("day"))).append("\",")
              .append("\"status\":\"").append(esc(r.get("status"))).append("\"}");
        }
        sb.append("]}");
        return sb.toString();
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}