package com.school.controller.admin;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.school.dao.teacher.TeacherDAO;
import com.school.model.teacher.Teacher;

@WebServlet("/Admin/Teachers")
public class TeacherListServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        TeacherDAO dao = new TeacherDAO();
        List<Teacher> teachers = dao.getAllTeachers();
        int page = 1;
        int recordsPerPage = 5;       
        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            page = Integer.parseInt(pageParam);
        }    
        int totalRecords = teachers.size();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);        
        int pageStart = (page - 1) * recordsPerPage;
        int pageEnd = Math.min(pageStart + recordsPerPage, totalRecords);       
        req.setAttribute("teachers", teachers);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageStart", pageStart);
        req.setAttribute("pageEnd", pageEnd);        
        req.getRequestDispatcher("/jsp/admin/manage-teachers.jsp")
                .forward(req, res);
    }
}