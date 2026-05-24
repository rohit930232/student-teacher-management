package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.admin.AdminClassDAO;
import com.school.dao.admin.AdminStaffDAO;
import com.school.dao.admin.AdminTeacherDAO;
import com.school.exception.admin.*;

@WebServlet("/admin/attendance")
public class AdminAttendanceServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            AdminClassDAO   classDao   = new AdminClassDAO();
            AdminTeacherDAO teacherDao = new AdminTeacherDAO();
            AdminStaffDAO   staffDao   = new AdminStaffDAO();
            req.setAttribute("classList",   classDao.getClassListWithStudentCount());
            req.setAttribute("teacherList", teacherDao.getAllTeachersWithDetails());
            req.setAttribute("staffList",   staffDao.getAllStaff());
        } catch (Exception e) {
            AdminExceptionHandler.handle(req, res,
                new AdminAttendanceException("We could not load attendance data. Please try again later.", e));
            return;
        }
        req.getRequestDispatcher("/jsp/admin/attendance.jsp").forward(req, res);
    }
}