package com.school.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.school.dao.LoginDAO;
import com.school.util.PasswordUtil;

@WebServlet("/Login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            String remember = request.getParameter("remember");

            String hashedPassword = PasswordUtil.hashPassword(password);

            LoginDAO dao = new LoginDAO();

            boolean status = dao.checkLogin(username, hashedPassword, role);

            if(status){

                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", role);

                // 🔥 COOKIE LOGIC
                if(remember != null){

                    Cookie userCookie = new Cookie("username", username);
                    Cookie passCookie = new Cookie("password", password);

                    userCookie.setMaxAge(7*24*60*60); // 7 days
                    passCookie.setMaxAge(7*24*60*60);

                    response.addCookie(userCookie);
                    response.addCookie(passCookie);
                }

                // 🔥 redirect
                if(role.equals("admin")){
                    response.sendRedirect("jsp/admin/dashboard.jsp");
                }
                else if(role.equals("teacher")){
                    response.sendRedirect("jsp/teacher/dashboard.jsp");
                }
                else{
                    response.sendRedirect("jsp/student/dashboard.jsp");
                }

            } else {
                response.sendRedirect("login.jsp?error=Invalid Credentials");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}