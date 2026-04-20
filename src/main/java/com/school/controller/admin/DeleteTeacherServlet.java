package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.school.dao.teacher.TeacherDAO;

@WebServlet("/Admin/DeleteTeacher")
public class DeleteTeacherServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        String username = req.getParameter("username");
        TeacherDAO dao = new TeacherDAO();
        dao.deleteTeacher(username);
        res.sendRedirect("Teachers");
    }
}