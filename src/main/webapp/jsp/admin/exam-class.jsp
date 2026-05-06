<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "exam");
    request.setAttribute("pageTitle", "Exam");
    String className = (String) request.getAttribute("className");
    String classId   = (String) request.getAttribute("classId");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Exam</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/exam.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <jsp:include page="sidebar.jsp" />
    <div class="main">
        <jsp:include page="topbar.jsp" />
        <div class="page-body">
            <div class="page-container">
                <div class="class-header">
                    <a href="<%=request.getContextPath()%>/admin/exam" class="back-btn"><i class="fas fa-arrow-left"></i> Back</a>
                    <h2><i class="fas fa-file-alt"></i> <%= className %> — Exams</h2>
                </div>
                <div class="exam-grid">
                    <%
                        List<Map<String,String>> exams = (List<Map<String,String>>) request.getAttribute("exams");
                        String[] exColors = {"blue","green","orange","purple","teal"};
                        if (exams != null && !exams.isEmpty()) {
                            int ei = 0;
                            for (Map<String,String> e : exams) {
                                boolean upcoming = false;
                                try { java.sql.Date ed = java.sql.Date.valueOf(e.get("exam_date")); upcoming = !ed.before(new java.util.Date()); } catch(Exception ex) {}
                    %>
                    <div class="exam-card <%= exColors[ei % exColors.length] %>">
                        <div class="exam-card-head">
                            <i class="fas fa-file-alt"></i>
                            <span class="<%= upcoming ? "status-upcoming" : "status-done" %>"><%= upcoming ? "Upcoming" : "Completed" %></span>
                        </div>
                        <h3><%= e.get("subject") %></h3>
                        <div class="exam-details">
                            <div><i class="fas fa-chalkboard-teacher"></i> <%= e.get("teacher_name") != null ? e.get("teacher_name") : "-" %></div>
                            <div><i class="fas fa-calendar"></i> <%= e.get("exam_date") != null ? e.get("exam_date").substring(0,10) : "-" %></div>
                            <div><i class="fas fa-clock"></i> <%= e.get("start_time") %> - <%= e.get("end_time") %></div>
                            <div><i class="fas fa-star"></i> Total Marks: <%= e.get("total_marks") %></div>
                        </div>
                    </div>
                    <% ei++; } } else { %>
                    <div class="empty-state-full"><i class="fas fa-file-alt"></i><p>No exams scheduled</p></div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>