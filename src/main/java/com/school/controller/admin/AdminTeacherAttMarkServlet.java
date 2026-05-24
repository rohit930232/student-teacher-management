package com.school.controller.admin;

import java.io.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminAttendanceDAO;
import org.json.*;

@WebServlet("/admin/attendance/teacher/mark")
public class AdminTeacherAttMarkServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        res.setContentType("text/plain");
        res.setCharacterEncoding("UTF-8");

        try {
            StringBuilder sb = new StringBuilder();
            String line;
            BufferedReader reader = req.getReader();
            while ((line = reader.readLine()) != null) sb.append(line);

            JSONObject body    = new JSONObject(sb.toString());
            String date        = body.getString("date");
            JSONArray records  = body.getJSONArray("records");

            AdminAttendanceDAO dao = new AdminAttendanceDAO();
            boolean allOk = true;

            for (int i = 0; i < records.length(); i++) {
                JSONObject rec = records.getJSONObject(i);
                int tid        = Integer.parseInt(rec.getString("id"));
                String status  = rec.getString("status");
                if (!dao.markTeacherAttendance(tid, date, status)) allOk = false;
            }

            res.getWriter().write(allOk ? "ok" : "error");

        } catch (Exception e) {
            e.printStackTrace();
            res.getWriter().write("error");
        }
    }
}