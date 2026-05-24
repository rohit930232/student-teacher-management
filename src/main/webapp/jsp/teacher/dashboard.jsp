<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.school.model.teacher.Teacher" %>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "dashboard");
    request.setAttribute("pageTitle", "Dashboard");
    Teacher teacher = (Teacher) request.getAttribute("teacher");
    String className = (String) request.getAttribute("className");
    int totalStudents   = request.getAttribute("totalStudents")    != null ? (Integer) request.getAttribute("totalStudents")    : 0;
    int totalSubjects   = request.getAttribute("totalSubjects")    != null ? (Integer) request.getAttribute("totalSubjects")    : 0;
    int assignmentCount = request.getAttribute("assignmentCount")  != null ? (Integer) request.getAttribute("assignmentCount")  : 0;
    int _tAttPct        = request.getAttribute("teacherAttPercent")!= null ? (Integer) request.getAttribute("teacherAttPercent"): 0;
    int _tPresent       = request.getAttribute("teacherPresent")   != null ? (Integer) request.getAttribute("teacherPresent")   : 0;
    int _tTotal         = request.getAttribute("teacherTotal")     != null ? (Integer) request.getAttribute("teacherTotal")     : 0;
    String subjectList  = (String) request.getAttribute("subjectList");
    double _tCirc       = 2 * Math.PI * 28;
    double _tDash       = _tCirc - (_tAttPct / 100.0) * _tCirc;
    String currentYear  = new java.text.SimpleDateFormat("yyyy").format(new java.util.Date());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Teacher Dashboard</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jsp" %>
    <div class="main">
        <%@ include file="topbar.jsp" %>
        <div class="page-body">

            <!-- TEACHER INFO CARD -->
            <div class="info-card">
                <div class="info-card-inner">
                    <div class="info-details">
                        <h2>Teacher Information</h2>
                        <div class="info-row"><span class="label"><i class="fas fa-user"></i> Name</span><span class="value"><%= teacher != null ? teacher.getName() : "" %></span></div>
                        <div class="info-row"><span class="label"><i class="fas fa-chalkboard"></i> Class</span><span class="value"><%= className != null ? className : "Not Assigned" %></span></div>
                        <div class="info-row"><span class="label"><i class="fas fa-id-badge"></i> Username</span><span class="value"><%= teacher != null ? teacher.getUsername() : "" %></span></div>
                        <div class="info-row"><span class="label"><i class="fas fa-envelope"></i> Email</span><span class="value"><%= teacher != null ? teacher.getEmail() : "" %></span></div>
                        <div class="info-row"><span class="label"><i class="fas fa-phone"></i> Mobile</span><span class="value"><%= teacher != null && teacher.getMobile() != null ? teacher.getMobile() : "-" %></span></div>
                        <% if (teacher != null && "yes".equalsIgnoreCase(teacher.getClass_teacher())) { %>
                        <span class="badge-teacher">&#127775; Class Teacher</span>
                        <% } %>
                    </div>
                    <div class="stat-boxes">
                        <div class="stat-box blue">
                            <div class="stat-num"><%= totalStudents %></div>
                            <div class="stat-label">Total Students</div>
                            <div class="stat-sub">In your class</div>
                        </div>
                        <div class="stat-box orange">
                            <div class="stat-num"><%= totalSubjects %></div>
                            <div class="stat-label">Total Subjects</div>
                            <div class="stat-sub"><%= subjectList != null && subjectList.length() > 20 ? subjectList.substring(0,17) + "..." : subjectList %></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- DASHBOARD GRID -->
            <div class="dashboard-grid">

                <!-- MY ATTENDANCE WIDGET -->
                <div class="widget widget-attendance">
                    <div class="widget-title">My Attendance (<%= currentYear %>)</div>
                    <div class="attendance-big"><%= _tAttPct %>% <small style="font-size:14px;font-weight:600;opacity:0.9;">Present</small></div>
                    <div class="attendance-circle-wrap">
                        <div class="circle-container">
                            <svg width="68" height="68" viewBox="0 0 68 68">
                                <circle class="circle-bg"   cx="34" cy="34" r="28"/>
                                <circle class="circle-fill" cx="34" cy="34" r="28"
                                    stroke-dasharray="<%= String.format("%.2f", _tCirc) %>"
                                    stroke-dashoffset="<%= String.format("%.2f", _tDash) %>"/>
                            </svg>
                            <div class="circle-text"><%= _tAttPct %>%</div>
                        </div>
                        <div class="circle-info">
                            <span>Present: <%= _tPresent %> / <%= _tTotal %></span>
                            <a href="<%=request.getContextPath()%>/teacher/attendance">View Details &rsaquo;</a>
                        </div>
                    </div>
                </div>

                <!-- PENDING ASSIGNMENTS WIDGET -->
                <div class="widget widget-assignment">
                    <div class="widget-title">Pending Assignments</div>
                    <div>
                        <span class="assign-count"><%= assignmentCount %></span>
                        <span class="assign-label"> Uploaded</span>
                    </div>
                    <div class="assign-list">
                        <%
                            List<Map<String,String>> assignments = (List<Map<String,String>>) request.getAttribute("assignments");
                            if (assignments != null && !assignments.isEmpty()) {
                                int cnt = 0;
                                for (Map<String,String> a : assignments) {
                                    if (cnt >= 2) break;
                        %>
                        <div class="assign-item">
                            <div>
                                <div class="assign-item-text"><%= a.get("title") %></div>
                                <div class="assign-item-date">Uploaded: <%= a.get("upload_date") != null && a.get("upload_date").length() >= 10 ? a.get("upload_date").substring(0,10) : "-" %></div>
                            </div>
                        </div>
                        <% cnt++; } } else { %>
                        <div class="assign-item"><div class="assign-item-text">No assignments yet</div></div>
                        <% } %>
                    </div>
                </div>

                <!-- UPCOMING EVENTS WIDGET -->
                <div class="widget widget-events">
                    <div class="widget-title">Upcoming Events</div>
                    <%
                        List<Map<String,String>> notifications = (List<Map<String,String>>) request.getAttribute("notifications");
                        if (notifications != null && !notifications.isEmpty()) {
                            for (Map<String,String> n : notifications) {
                    %>
                    <div class="event-item">
                        <span class="event-icon"><i class="fas fa-calendar-check"></i></span>
                        <span><%= n.get("message") %></span>
                    </div>
                    <% } } else { %>
                    <div class="event-item">
                        <span class="event-icon"><i class="fas fa-info-circle"></i></span>
                        <span>No upcoming events</span>
                    </div>
                    <% } %>
                </div>

                <!-- RECENT NOTICES WIDGET -->
                <div class="widget widget-notices">
                    <div class="widget-title-dark">Recent Notices</div>
                    <%
                        List<Map<String,String>> notices = (List<Map<String,String>>) request.getAttribute("notices");
                        if (notices != null && !notices.isEmpty()) {
                            for (Map<String,String> n : notices) {
                    %>
                    <div class="notice-item">
                        <span class="notice-icon"><i class="fas fa-bullhorn"></i></span>
                        <span class="notice-text"><%= n.get("message") %></span>
                    </div>
                    <% } } else { %>
                    <div class="notice-item">
                        <span class="notice-icon"><i class="fas fa-info-circle"></i></span>
                        <span class="notice-text">No notices available.</span>
                    </div>
                    <% } %>
                    <a href="<%=request.getContextPath()%>/teacher/notices" class="view-all">View All &rsaquo;</a>
                </div>

            </div>

            <!-- QUICK ACTIONS -->
            <div class="quick-actions">
                <h3>Quick Actions</h3>
                <div class="qa-buttons">
                    <a href="<%=request.getContextPath()%>/teacher/assignments" class="qa-btn blue"><i class="fas fa-upload"></i> Upload Assignment</a>
                    <a href="<%=request.getContextPath()%>/teacher/notices"     class="qa-btn orange"><i class="fas fa-bullhorn"></i> Send Notice</a>
                    <a href="<%=request.getContextPath()%>/teacher/attendance"  class="qa-btn green"><i class="fas fa-clipboard-check"></i> Mark Attendance</a>
                    <a href="<%=request.getContextPath()%>/teacher/exam"        class="qa-btn blue"><i class="fas fa-file-alt"></i> Create Exam</a>
                </div>
            </div>

        </div>
    </div>
</div>
</body>
</html>