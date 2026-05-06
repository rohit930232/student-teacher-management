package com.school.controller.admin;

import java.io.IOException;
import java.net.URLEncoder;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminClassDAO;

@WebServlet("/admin/timetable/add")
public class AdminTimetableAddServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        String classIdStr = req.getParameter("class_id");
        String className  = req.getParameter("className");
        String day        = req.getParameter("day");
        String subject    = req.getParameter("subject");
        String teacherStr = req.getParameter("teacher_id");
        String startTime  = req.getParameter("start_time");
        String endTime    = req.getParameter("end_time");

        System.out.println("=== TIMETABLE ADD ===");
        System.out.println("classId=" + classIdStr);
        System.out.println("className=" + className);
        System.out.println("day=" + day);
        System.out.println("subject=" + subject);
        System.out.println("teacherId=" + teacherStr);
        System.out.println("startTime=" + startTime);
        System.out.println("endTime=" + endTime);

        if (classIdStr == null || classIdStr.isEmpty()) {
            System.out.println("ERROR: classId is null/empty");
            res.sendRedirect(req.getContextPath() + "/admin/timetable");
            return;
        }

        if (day == null || day.isEmpty() || subject == null || subject.isEmpty()) {
            System.out.println("ERROR: day or subject is empty");
            res.sendRedirect(req.getContextPath() + "/admin/timetable/class?classId=" + classIdStr
                    + "&className=" + URLEncoder.encode(className != null ? className : "", "UTF-8")
                    + "&msg=error");
            return;
        }

        int classId = 0;
        try {
            classId = Integer.parseInt(classIdStr);
        } catch (Exception e) {
            System.out.println("ERROR: classId parse failed: " + e.getMessage());
            res.sendRedirect(req.getContextPath() + "/admin/timetable");
            return;
        }

        Integer teacherId = null;
        if (teacherStr != null && !teacherStr.isEmpty()) {
            try {
                teacherId = Integer.parseInt(teacherStr);
            } catch (Exception e) {
                teacherId = null;
            }
        }

        AdminClassDAO dao = new AdminClassDAO();
        boolean ok = dao.addTimetableSlot(classId, day, subject, teacherId, startTime, endTime);

        System.out.println("TIMETABLE ADD result: " + ok);

        String redirectUrl = req.getContextPath() + "/admin/timetable/class?classId=" + classId
                + "&className=" + URLEncoder.encode(className != null ? className : "", "UTF-8")
                + "&msg=" + (ok ? "added" : "error");

        System.out.println("Redirecting to: " + redirectUrl);
        res.sendRedirect(redirectUrl);
    }
}