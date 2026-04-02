package com.school.filter.teacher;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

@WebFilter("/teacher/*")
public class TeacherFilter implements Filter {

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        if (session != null && "teacher".equals(session.getAttribute("role"))) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
        }
    }
}