package com.school.controller.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.school.dao.admin.AdminStudentDAO;

@WebServlet("/Admin/Students")
public class AdminStudentsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        AdminStudentDAO dao = new AdminStudentDAO();
        req.setAttribute("classList", dao.getClassStudentCount());
        req.getRequestDispatcher("/jsp/admin/manage-students.jsp")
                .forward(req, res);
    }
}