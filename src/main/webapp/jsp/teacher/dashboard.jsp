<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.school.model.teacher.Teacher" %>
<%@ page import="java.util.*" %>
<%
    Teacher teacher        = (Teacher) request.getAttribute("teacher");
    String className       = (String)  request.getAttribute("className");
    Integer totalStudentsObj  = (Integer) request.getAttribute("totalStudents");
    Integer totalSubjectsObj  = (Integer) request.getAttribute("totalSubjects");
    Integer assignCountObj    = (Integer) request.getAttribute("assignmentCount");
    Integer attendanceObj     = (Integer) request.getAttribute("attendancePercent");

    int totalStudents   = (totalStudentsObj  != null) ? totalStudentsObj  : 0;
    int totalSubjects   = (totalSubjectsObj  != null) ? totalSubjectsObj  : 0;
    int assignmentCount = (assignCountObj    != null) ? assignCountObj    : 0;
    int attendancePercent = (attendanceObj   != null) ? attendanceObj     : 0;

    String subjectList  = (String) request.getAttribute("subjectList");

    List<Map<String,String>> assignments   = (List<Map<String,String>>) request.getAttribute("assignments");
    List<Map<String,String>> notices       = (List<Map<String,String>>) request.getAttribute("notices");
    List<Map<String,String>> notifications = (List<Map<String,String>>) request.getAttribute("notifications");

    String teacherName     = (teacher != null && teacher.getName()     != null) ? teacher.getName()     : "Teacher";
    String teacherEmail    = (teacher != null && teacher.getEmail()    != null) ? teacher.getEmail()    : "";
    String teacherMobile   = (teacher != null && teacher.getMobile()   != null) ? teacher.getMobile()   : "-";
    String teacherPhoto    = (teacher != null) ? teacher.getPhoto()    : null;
    String teacherUsername = (teacher != null) ? teacher.getUsername() : "";
    String classTeacher    = (teacher != null && teacher.getClass_teacher() != null) ? teacher.getClass_teacher() : "No";

    String initials = (teacherName.length() > 0) ? String.valueOf(teacherName.charAt(0)).toUpperCase() : "T";

    double r = 28;
    double circumference = 2 * Math.PI * r;
    double dashOffset    = circumference - (attendancePercent / 100.0) * circumference;

    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("EEEE, dd MMM yyyy");
    String todayDate = sdf.format(new java.util.Date());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Dashboard</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon">S</div>
        <span>SchoolMS</span>
    </div>

    <nav class="sidebar-nav">
        <div class="nav-label">Main Menu</div>

        <a href="<%=request.getContextPath()%>/teacher/dashboard" class="nav-item active">
            <span class="nav-icon"><i class="fas fa-th-large"></i></span> Dashboard
        </a>
        <a href="<%=request.getContextPath()%>/teacher/students" class="nav-item">
            <span class="nav-icon"><i class="fas fa-user-graduate"></i></span> Students
        </a>
        <a href="<%=request.getContextPath()%>/teacher/assignments" class="nav-item">
            <span class="nav-icon"><i class="fas fa-tasks"></i></span> Assignments
        </a>
        <a href="<%=request.getContextPath()%>/teacher/attendance" class="nav-item">
            <span class="nav-icon"><i class="fas fa-clipboard-check"></i></span> Attendance
        </a>
        <a href="<%=request.getContextPath()%>/teacher/results" class="nav-item">
            <span class="nav-icon"><i class="fas fa-chart-bar"></i></span> Results
        </a>
        <a href="<%=request.getContextPath()%>/teacher/timetable" class="nav-item">
            <span class="nav-icon"><i class="fas fa-calendar-alt"></i></span> Timetable
        </a>
    </nav>

    <div class="sidebar-footer">
        <a href="<%=request.getContextPath()%>/logout" class="nav-item">
            <span class="nav-icon"><i class="fas fa-power-off"></i></span> Log Out
        </a>
    </div>
</aside>

<div class="main-content">
    <header class="topbar">
        <div class="topbar-left">
            <h1>Welcome, <%= teacherName %>!</h1>
            <p><%= todayDate %></p>
        </div>
        <div class="topbar-right">
            <button class="notif-btn" title="Notifications">
                <i class="fas fa-bell"></i>
                <% if (notifications != null && !notifications.isEmpty()) { %>
                <span class="notif-badge"></span>
                <% } %>
            </button>
            <div class="teacher-avatar">
                <% if (teacherPhoto != null && !teacherPhoto.trim().isEmpty()) { %>
                    <img src="<%=request.getContextPath()%>/<%= teacherPhoto %>" alt="Photo">
                <% } else { %>
                    <div class="avatar-placeholder"><%= initials %></div>
                <% } %>
                <div class="avatar-info">
                    <span><%= teacherName %></span>
                    <small>
                        <%= ("yes".equalsIgnoreCase(classTeacher)) ? "Class Teacher" : "Subject Teacher" %>
                    </small>
                </div>
            </div>
        </div>
    </header>

    <div class="page-body">

        <div class="info-card">
            <div class="info-card-inner">
                <div class="info-details">
                    <h2>Teacher Information</h2>
                    <div class="info-row">
                        <span class="label"><i class="fas fa-user"></i>&nbsp; Name</span>
                        <span class="value"><%= teacherName %></span>
                    </div>
                    <div class="info-row">
                        <span class="label"><i class="fas fa-chalkboard"></i>&nbsp; Class</span>
                        <span class="value">
                            <%= (className != null && !className.isEmpty()) ? className : "Not Assigned" %>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="label"><i class="fas fa-id-badge"></i>&nbsp; Username</span>
                        <span class="value"><%= teacherUsername %></span>
                    </div>
                    <div class="info-row">
                        <span class="label"><i class="fas fa-envelope"></i>&nbsp; Email</span>
                        <span class="value"><%= teacherEmail %></span>
                    </div>
                    <div class="info-row">
                        <span class="label"><i class="fas fa-phone"></i>&nbsp; Mobile</span>
                        <span class="value"><%= teacherMobile %></span>
                    </div>
                    <% if ("yes".equalsIgnoreCase(classTeacher)) { %>
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
                        <div class="stat-sub">
                            <%
                                String subDisp = (subjectList != null) ? subjectList : "-";
                                out.print(subDisp.length() > 28 ? subDisp.substring(0,25) + "..." : subDisp);
                            %>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="dashboard-grid">
            <div class="widget widget-attendance">
                <div class="widget-title">Attendance</div>
                <div class="attendance-big">
                    <%= attendancePercent %>% <small style="font-size:15px;font-weight:600;">Present</small>
                </div>
                <div class="attendance-circle-wrap">
                    <div class="circle-container">
                        <svg width="68" height="68" viewBox="0 0 68 68">
                            <circle class="circle-bg"   cx="34" cy="34" r="28"/>
                            <circle class="circle-fill" cx="34" cy="34" r="28"
                                stroke-dasharray="<%= String.format("%.2f", circumference) %>"
                                stroke-dashoffset="<%= String.format("%.2f", dashOffset) %>"/>
                        </svg>
                        <div class="circle-text"><%= attendancePercent %>%</div>
                    </div>
                    <div class="circle-info">
                        <span>Present</span>
                        <a href="<%=request.getContextPath()%>/teacher/attendance">View Details &rsaquo;</a>
                    </div>
                </div>
            </div>
            <div class="widget widget-assignment">
                <div class="widget-title">Pending Assignments</div>
                <div>
                    <span class="assign-count"><%= assignmentCount %></span>
                    <span class="assign-label">Uploaded</span>
                </div>
                <div class="assign-list">
                    <% if (assignments != null && !assignments.isEmpty()) {
                        int cnt = 0;
                        for (Map<String,String> a : assignments) {
                            if (cnt >= 2) break; %>
                    <div class="assign-item">
                        <div>
                            <div class="assign-item-text"><%= a.get("title") %></div>
                            <div class="assign-item-date">
                                Uploaded:
                                <%= (a.get("upload_date") != null && a.get("upload_date").length() >= 10)
                                    ? a.get("upload_date").substring(0,10) : "-" %>
                            </div>
                        </div>
                    </div>
                    <% cnt++; }
                    } else { %>
                    <div class="assign-item">
                        <div class="assign-item-text">No assignments yet</div>
                    </div>
                    <% } %>
                </div>
            </div>
            <div class="widget widget-events">
                <div class="widget-title">Upcoming Events</div>
                <% if (notifications != null && !notifications.isEmpty()) {
                    for (Map<String,String> n : notifications) { %>
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
            <div class="widget widget-notices">
                <div class="widget-title-dark">Recent Notices</div>
                <% if (notices != null && !notices.isEmpty()) {
                    for (Map<String,String> n : notices) { %>
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
        <div class="quick-actions">
            <h3>Quick Actions</h3>
            <div class="qa-buttons">
                <a href="<%=request.getContextPath()%>/teacher/students/add" class="qa-btn blue">
                    <i class="fas fa-user-plus"></i> Add Student
                </a>
                <a href="<%=request.getContextPath()%>/teacher/notice/send" class="qa-btn orange">
                    <i class="fas fa-bullhorn"></i> Send Notice
                </a>
                <a href="<%=request.getContextPath()%>/teacher/fees" class="qa-btn green">
                    <i class="fas fa-rupee-sign"></i> Manage Fees
                </a>
                <a href="<%=request.getContextPath()%>/teacher/assignments/upload" class="qa-btn blue">
                    <i class="fas fa-upload"></i> Upload Assignment
                </a>
            </div>
        </div>

    </div>
</div>

</body>
</html>
