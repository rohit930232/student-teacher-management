<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "dashboard");
    request.setAttribute("pageTitle", "Dashboard");
    int totalStudents = request.getAttribute("totalStudents") != null ? (Integer) request.getAttribute("totalStudents") : 0;
    int totalTeachers = request.getAttribute("totalTeachers") != null ? (Integer) request.getAttribute("totalTeachers") : 0;
    int totalClasses  = request.getAttribute("totalClasses")  != null ? (Integer) request.getAttribute("totalClasses")  : 0;
    int totalStaff    = request.getAttribute("totalStaff")    != null ? (Integer) request.getAttribute("totalStaff")    : 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <jsp:include page="sidebar.jsp" />
    <div class="main">
        <jsp:include page="topbar.jsp" />
        <div class="page-body">
            <div class="stats-grid">
                <div class="stat-card blue">
                    <div class="stat-icon"><i class="fas fa-user-graduate"></i></div>
                    <div class="stat-body"><p class="stat-label">Total Students</p><h3 class="stat-value"><%= totalStudents %></h3></div>
                </div>
                <div class="stat-card green">
                    <div class="stat-icon"><i class="fas fa-chalkboard-teacher"></i></div>
                    <div class="stat-body"><p class="stat-label">Total Teachers</p><h3 class="stat-value"><%= totalTeachers %></h3></div>
                </div>
                <div class="stat-card orange">
                    <div class="stat-icon"><i class="fas fa-users"></i></div>
                    <div class="stat-body"><p class="stat-label">Total Staff</p><h3 class="stat-value"><%= totalStaff %></h3></div>
                </div>
                <div class="stat-card purple">
                    <div class="stat-icon"><i class="fas fa-school"></i></div>
                    <div class="stat-body"><p class="stat-label">Total Classes</p><h3 class="stat-value"><%= totalClasses %></h3></div>
                </div>
            </div>

            <div class="quick-actions-card">
                <div class="card-head"><h3><i class="fas fa-bolt"></i> Quick Actions</h3></div>
                <div class="action-buttons">
                    <a href="<%=request.getContextPath()%>/jsp/student/register.jsp" class="action-btn blue"><i class="fas fa-user-plus"></i> Add Student</a>
                    <a href="<%=request.getContextPath()%>/jsp/teacher/register.jsp" class="action-btn green"><i class="fas fa-chalkboard-teacher"></i> Add Teacher</a>
                    <a href="<%=request.getContextPath()%>/admin/notices" class="action-btn orange"><i class="fas fa-bullhorn"></i> Add Notice</a>
                    <a href="<%=request.getContextPath()%>/admin/notifications" class="action-btn purple"><i class="fas fa-bell"></i> Send Notification</a>
                    <a href="<%=request.getContextPath()%>/admin/payment" class="action-btn teal"><i class="fas fa-rupee-sign"></i> Pay Salary</a>
                    <a href="<%=request.getContextPath()%>/admin/timetable" class="action-btn pink"><i class="fas fa-calendar-alt"></i> Manage Timetable</a>
                </div>
            </div>

            <div class="mid-grid">
                <div class="card">
                    <div class="card-head"><h3><i class="fas fa-bullhorn"></i> Recent Notices</h3><a href="<%=request.getContextPath()%>/admin/notices" class="card-link">View All &rsaquo;</a></div>
                    <div class="card-body">
                        <%
                            List<String> notices = (List<String>) request.getAttribute("notices");
                            if (notices != null && !notices.isEmpty()) {
                                for (String n : notices) {
                        %>
                        <div class="notice-item"><i class="fas fa-circle-dot"></i><p><%= n %></p></div>
                        <% } } else { %>
                        <div class="empty-state"><i class="fas fa-bullhorn"></i><p>No notices yet</p></div>
                        <% } %>
                    </div>
                </div>

                <div class="card">
                    <div class="card-head"><h3><i class="fas fa-bell"></i> Recent Notifications</h3><a href="<%=request.getContextPath()%>/admin/notifications" class="card-link">View All &rsaquo;</a></div>
                    <div class="card-body">
                        <%
                            List<Map<String,String>> notifs = (List<Map<String,String>>) request.getAttribute("notifications");
                            if (notifs != null && !notifs.isEmpty()) {
                                for (Map<String,String> n : notifs) {
                        %>
                        <div class="notif-item">
                            <div class="notif-dot"></div>
                            <div class="notif-body"><p><%= n.get("message") %></p><span><%= n.get("time") != null ? n.get("time").toString().substring(0,10) : "" %></span></div>
                        </div>
                        <% } } else { %>
                        <div class="empty-state"><i class="fas fa-bell-slash"></i><p>No notifications</p></div>
                        <% } %>
                    </div>
                </div>

                <div class="card">
                    <div class="card-head"><h3><i class="fas fa-file-alt"></i> Upcoming Exams</h3><a href="<%=request.getContextPath()%>/admin/exam" class="card-link">View All &rsaquo;</a></div>
                    <div class="card-body">
                        <%
                            List<Map<String,String>> exams = (List<Map<String,String>>) request.getAttribute("upcomingExams");
                            if (exams != null && !exams.isEmpty()) {
                                for (Map<String,String> e : exams) {
                        %>
                        <div class="exam-item">
                            <div class="exam-info">
                                <p class="exam-subject"><%= e.get("subject") %></p>
                                <span class="exam-class">Class: <%= e.get("class_name") %></span>
                            </div>
                            <span class="exam-date"><%= e.get("exam_date") != null ? e.get("exam_date").substring(0,10) : "" %></span>
                        </div>
                        <% } } else { %>
                        <div class="empty-state"><i class="fas fa-file-alt"></i><p>No upcoming exams</p></div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>