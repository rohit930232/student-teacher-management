package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.school.dao.teacher.TeacherDAO;
import com.school.model.teacher.Teacher;

@WebServlet("/Admin/ViewTeacher")
public class ViewTeacherServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        TeacherDAO dao = new TeacherDAO();
        Teacher teacher = dao.getTeacherByUsername(username);
        req.setAttribute("teacher", teacher);
        req.getRequestDispatcher("/jsp/admin/view-teacher.jsp").forward(req, res);
    }
}