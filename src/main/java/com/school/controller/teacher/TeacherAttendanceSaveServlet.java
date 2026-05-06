package com.school.controller.teacher;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.teacher.TeacherDAO;
import com.school.model.teacher.Teacher;
import com.school.util.DBConnection;

@WebServlet("/teacher/attendance/save")
public class TeacherAttendanceSaveServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String classId = request.getParameter("class_id");
        try {
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");
            TeacherDAO dao = new TeacherDAO();
            Teacher teacher = dao.getTeacherByUsername(username);

            String dateStr = request.getParameter("attendance_date");
            java.sql.Date attDate = java.sql.Date.valueOf(dateStr);
            String[] studentIds = request.getParameterValues("student_ids");
            Connection con = DBConnection.getConnection();

            if (studentIds != null) {
                for (String sid : studentIds) {
                    String status = request.getParameter("status_" + sid);
                    if (status == null) status = "Absent";

                    PreparedStatement checkPs = con.prepareStatement("SELECT attendance_id FROM st_attendance WHERE student_id=? AND attendance_date=?");
                    checkPs.setInt(1, Integer.parseInt(sid));
                    checkPs.setDate(2, attDate);
                    ResultSet rs = checkPs.executeQuery();

                    if (rs.next()) {
                        PreparedStatement updatePs = con.prepareStatement("UPDATE st_attendance SET status=? WHERE student_id=? AND attendance_date=?");
                        updatePs.setString(1, status);
                        updatePs.setInt(2, Integer.parseInt(sid));
                        updatePs.setDate(3, attDate);
                        updatePs.executeUpdate();
                    } else {
                        PreparedStatement insertPs = con.prepareStatement("INSERT INTO st_attendance (attendance_id, student_id, class_id, teacher_id, attendance_date, status) VALUES (st_attendance_seq.NEXTVAL, ?, ?, ?, ?, ?)");
                        insertPs.setInt(1, Integer.parseInt(sid));
                        insertPs.setInt(2, Integer.parseInt(classId));
                        insertPs.setInt(3, teacher.getTeacher_id());
                        insertPs.setDate(4, attDate);
                        insertPs.setString(5, status);
                        insertPs.executeUpdate();
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect(request.getContextPath() + "/teacher/attendance?class_id=" + classId);
    }
}