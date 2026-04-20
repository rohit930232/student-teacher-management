package com.school.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.school.dao.LoginDAO;
import com.school.model.admin.Admin;
import com.school.model.teacher.Teacher;
import com.school.model.student.Student;
import com.school.util.PasswordUtil;

@WebServlet("/Login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String username       = request.getParameter("username");
            String password       = request.getParameter("password");
            String role           = request.getParameter("role");
            String remember       = request.getParameter("remember");
            String hashedPassword = PasswordUtil.hashPassword(password);

            LoginDAO dao = new LoginDAO();
            Object user  = dao.checkLogin(username, hashedPassword, role);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", role);

                if (role.equals("admin")) {
                    Admin a = (Admin) user;
                    session.setAttribute("fullname", a.getFullname());
                    session.setAttribute("photo", a.getPhoto());
                } else if (role.equals("teacher")) {
                    Teacher t = (Teacher) user;
                    session.setAttribute("fullname", t.getName());
                    session.setAttribute("photo", t.getPhoto());
                } else {
                    Student s = (Student) user;
                    session.setAttribute("fullname", s.getName());
                    session.setAttribute("photo", s.getPhoto());
                }

                if (remember != null) {
                    Cookie userCookie = new Cookie("username", username);
                    Cookie passCookie = new Cookie("password", password);
                    Cookie roleCookie = new Cookie("role", role);
                    userCookie.setMaxAge(7 * 24 * 60 * 60);
                    passCookie.setMaxAge(7 * 24 * 60 * 60);
                    roleCookie.setMaxAge(7 * 24 * 60 * 60);
                    response.addCookie(userCookie);
                    response.addCookie(passCookie);
                    response.addCookie(roleCookie);
                }

                if (role.equals("admin")) {
                    response.sendRedirect(request.getContextPath() + "/Admin/Dashboard");
                } else if (role.equals("teacher")) {
                    response.sendRedirect(request.getContextPath() + "/teacher/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/student/dashboard");
                }

            } else {
                response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?error=Invalid+Credentials");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}