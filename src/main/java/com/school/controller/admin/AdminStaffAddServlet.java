package com.school.controller.admin;

import java.io.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import com.school.dao.admin.AdminStaffDAO;

@WebServlet("/admin/staff/add")
@MultipartConfig
public class AdminStaffAddServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String name        = req.getParameter("name");
        String role        = req.getParameter("role");
        String mobile      = req.getParameter("mobile");
        String email       = req.getParameter("email");
        String gender      = req.getParameter("gender");
        String dob         = req.getParameter("dob");
        String salaryStr   = req.getParameter("salary");
        String status      = req.getParameter("status");
        String address     = req.getParameter("address");
        String joiningDate = req.getParameter("joining_date");

        double salary = 0;
        if (salaryStr != null && !salaryStr.isEmpty()) salary = Double.parseDouble(salaryStr);

        String photoPath = "";
        Part filePart = req.getPart("photo");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String uploadDir = getServletContext().getRealPath("") + "uploads" + File.separator + "staff";
            new File(uploadDir).mkdirs();
            filePart.write(uploadDir + File.separator + fileName);
            photoPath = "uploads/staff/" + fileName;
        }

        AdminStaffDAO dao = new AdminStaffDAO();
        boolean ok = dao.insertStaff(name, role, mobile, email, gender, dob, salary, status, address, joiningDate, photoPath);

        res.sendRedirect(req.getContextPath() + "/admin/staff?msg=" + (ok ? "added" : "error"));
    }
}