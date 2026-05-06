<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "dashboard");
    request.setAttribute("pageTitle", "Dashboard");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <jsp:include page="sidebar.jsp" />
    <div class="main">
        <jsp:include page="topbar.jsp" />
        <div class="page-body">
            <%
                int assignmentCount  = request.getAttribute("assignmentCount")  != null ? (Integer) request.getAttribute("assignmentCount")  : 0;
                int attendancePct    = request.getAttribute("attendancePercent") != null ? (Integer) request.getAttribute("attendancePercent") : 0;
                String upcomingExam  = request.getAttribute("upcomingExam")     != null ? (String)  request.getAttribute("upcomingExam")      : "No Exam";
                String upcomingDate  = request.getAttribute("upcomingExamDate") != null ? (String)  request.getAttribute("upcomingExamDate")  : "";
            %>
            <div class="stats-grid">
                <div class="stat-card orange">
                    <div class="stat-icon"><i class="fas fa-tasks"></i></div>
                    <div class="stat-body"><p class="stat-label">Pending Assignments</p><h3 class="stat-value"><%= assignmentCount %></h3></div>
                </div>
                <div class="stat-card green">
                    <div class="stat-icon"><i class="fas fa-clipboard-check"></i></div>
                    <div class="stat-body"><p class="stat-label">Current Attendance</p><h3 class="stat-value"><%= attendancePct %>% <span>Present</span></h3></div>
                </div>
                <div class="stat-card blue">
                    <div class="stat-icon"><i class="fas fa-file-alt"></i></div>
                    <div class="stat-body"><p class="stat-label">Upcoming Exam</p><h3 class="stat-value-sm"><%= upcomingExam %></h3><p class="stat-date"><%= upcomingDate %></p></div>
                </div>
                <div class="stat-card yellow">
                    <div class="stat-icon"><i class="fas fa-rupee-sign"></i></div>
                    <div class="stat-body"><p class="stat-label">Fees Remaining</p><h3 class="stat-value">&#8377;<%= request.getAttribute("feesRemaining") != null ? request.getAttribute("feesRemaining") : "0" %></h3></div>
                </div>
            </div>

            <div class="mid-grid">
                <div class="card">
                    <div class="card-head"><h3><i class="fas fa-book-open"></i> My Subjects</h3></div>
                    <div class="card-body subjects-grid">
                        <%
                            String subjects = request.getAttribute("subjects") != null ? (String) request.getAttribute("subjects") : "";
                            String[] colors = {"orange","green","blue","purple","teal","pink"};
                            String[] icons  = {"fa-flask","fa-calculator","fa-book","fa-desktop","fa-globe","fa-music"};
                            if (subjects != null && !subjects.trim().isEmpty()) {
                                String[] subArr = subjects.split(",");
                                for (int idx = 0; idx < subArr.length; idx++) {
                        %>
                        <div class="subject-card <%= colors[idx % colors.length] %>">
                            <div class="subject-icon"><i class="fas <%= icons[idx % icons.length] %>"></i></div>
                            <div class="subject-name"><%= subArr[idx].trim() %></div>
                        </div>
                        <% } } else { %><p class="empty-text">No subjects assigned</p><% } %>
                    </div>
                </div>

                <div class="card">
                    <div class="card-head"><h3><i class="fas fa-calendar-day"></i> Today's Schedule</h3><a href="<%=request.getContextPath()%>/student/timetable" class="card-link">View All &rsaquo;</a></div>
                    <div class="card-body">
                        <%
                            List<Map<String,String>> todaySchedule = (List<Map<String,String>>) request.getAttribute("todaySchedule");
                            String[] schedColors = {"green","blue","orange","purple","teal"};
                            if (todaySchedule != null && !todaySchedule.isEmpty()) {
                                int si = 0;
                                for (Map<String,String> slot : todaySchedule) {
                        %>
                        <div class="schedule-item <%= schedColors[si % schedColors.length] %>">
                            <div class="schedule-time"><%= slot.get("start_time") %> - <%= slot.get("end_time") %></div>
                            <div class="schedule-subject"><%= slot.get("subject") %></div>
                        </div>
                        <% si++; } } else { %><div class="empty-state"><i class="fas fa-calendar-times"></i><p>No classes today</p></div><% } %>
                    </div>
                </div>
            </div>

            <div class="bottom-grid">
                <div class="card">
                    <div class="card-head"><h3><i class="fas fa-tasks"></i> Pending Assignments</h3><a href="<%=request.getContextPath()%>/student/assignments" class="card-link">View All &rsaquo;</a></div>
                    <div class="card-body">
                        <%
                            List<Map<String,String>> assignments = (List<Map<String,String>>) request.getAttribute("assignments");
                            if (assignments != null && !assignments.isEmpty()) {
                                for (Map<String,String> a : assignments) {
                        %>
                        <div class="assign-item">
                            <div class="assign-icon"><i class="fas fa-file-alt"></i></div>
                            <div class="assign-info"><p class="assign-title"><%= a.get("title") %></p><span class="assign-due">Uploaded: <%= a.get("upload_date") != null ? a.get("upload_date").substring(0,10) : "-" %></span></div>
                            <a href="<%=request.getContextPath()%>/student/assignments" class="assign-link">View &rsaquo;</a>
                        </div>
                        <% } } else { %><div class="empty-state"><i class="fas fa-check-circle"></i><p>No pending assignments</p></div><% } %>
                    </div>
                </div>

                <div class="card">
                    <div class="card-head"><h3><i class="fas fa-calendar-alt"></i> Upcoming Events</h3><a href="<%=request.getContextPath()%>/student/notifications" class="card-link">View All &rsaquo;</a></div>
                    <div class="card-body">
                        <%
                            List<Map<String,String>> events = (List<Map<String,String>>) request.getAttribute("notifications");
                            if (events != null && !events.isEmpty()) {
                                for (Map<String,String> ev : events) {
                        %>
                        <div class="event-item">
                            <div class="event-icon"><i class="fas fa-bell"></i></div>
                            <div class="event-info"><p class="event-title"><%= ev.get("message") %></p><span class="event-date"><%= ev.get("date") != null ? ev.get("date").substring(0,10) : "" %></span></div>
                        </div>
                        <% } } else { %><div class="empty-state"><i class="fas fa-calendar-times"></i><p>No upcoming events</p></div><% } %>
                    </div>
                </div>

                <div class="card">
                    <div class="card-head"><h3><i class="fas fa-chart-bar"></i> Recent Results</h3><a href="<%=request.getContextPath()%>/student/result" class="card-link">View All &rsaquo;</a></div>
                    <div class="card-body">
                        <%
                            List<Map<String,String>> results = (List<Map<String,String>>) request.getAttribute("recentResults");
                            if (results != null && !results.isEmpty()) {
                                for (Map<String,String> r : results) {
                                    String grade = r.get("grade");
                                    boolean pass = !"F".equals(grade);
                        %>
                        <div class="result-item">
                            <div class="result-subject"><%= r.get("subject") %></div>
                            <div class="result-marks"><%= r.get("marks") %>/<%= r.get("max_marks") %></div>
                            <span class="grade-badge grade-<%= grade %>"><%= grade %></span>
                            <span class="<%= pass ? "pass-badge" : "fail-badge" %>"><%= pass ? "Pass" : "Fail" %></span>
                        </div>
                        <% } } else { %><div class="empty-state"><i class="fas fa-chart-bar"></i><p>No results yet</p></div><% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>