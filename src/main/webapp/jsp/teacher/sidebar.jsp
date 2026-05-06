<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String _cp = (String) request.getAttribute("currentPage");
    if (_cp == null) _cp = "";
%>
<aside class="sidebar">
    <div class="brand">
        <img src="<%=request.getContextPath()%>/images/logo.png" class="brand-logo-img" alt="Logo">
    </div>
    <nav class="nav">
        <span class="nav-section">Main Menu</span>
        <a href="<%=request.getContextPath()%>/teacher/dashboard"   class="nav-link <% if("dashboard".equals(_cp))   out.print("active"); %>"><i class="fas fa-th-large"></i> Dashboard</a>
        <a href="<%=request.getContextPath()%>/teacher/students"    class="nav-link <% if("students".equals(_cp))    out.print("active"); %>"><i class="fas fa-user-graduate"></i> Students</a>
        <a href="<%=request.getContextPath()%>/teacher/assignments" class="nav-link <% if("assignments".equals(_cp)) out.print("active"); %>"><i class="fas fa-tasks"></i> Assignments</a>
        <a href="<%=request.getContextPath()%>/teacher/attendance"  class="nav-link <% if("attendance".equals(_cp))  out.print("active"); %>"><i class="fas fa-clipboard-check"></i> Attendance</a>
        <a href="<%=request.getContextPath()%>/teacher/exam"        class="nav-link <% if("exam".equals(_cp))        out.print("active"); %>"><i class="fas fa-file-alt"></i> Exam</a>
        <a href="<%=request.getContextPath()%>/teacher/result"      class="nav-link <% if("result".equals(_cp))      out.print("active"); %>"><i class="fas fa-chart-bar"></i> Result</a>
        <a href="<%=request.getContextPath()%>/teacher/timetable"   class="nav-link <% if("timetable".equals(_cp))   out.print("active"); %>"><i class="fas fa-calendar-alt"></i> Timetable</a>
        <a href="<%=request.getContextPath()%>/teacher/notes"       class="nav-link <% if("notes".equals(_cp))       out.print("active"); %>"><i class="fas fa-book"></i> Notes</a>
        <a href="<%=request.getContextPath()%>/teacher/onlineclass" class="nav-link <% if("onlineclass".equals(_cp)) out.print("active"); %>"><i class="fas fa-video"></i> Online Class</a>
        <span class="nav-section">More</span>
        <a href="<%=request.getContextPath()%>/teacher/notices"       class="nav-link <% if("notices".equals(_cp))       out.print("active"); %>"><i class="fas fa-bullhorn"></i> Notices</a>
        <a href="<%=request.getContextPath()%>/teacher/notifications" class="nav-link <% if("notifications".equals(_cp)) out.print("active"); %>"><i class="fas fa-bell"></i> Notifications</a>
        <a href="<%=request.getContextPath()%>/teacher/payment"       class="nav-link <% if("payment".equals(_cp))       out.print("active"); %>"><i class="fas fa-rupee-sign"></i> Payment</a>
        <a href="<%=request.getContextPath()%>/teacher/profile"       class="nav-link <% if("profile".equals(_cp))       out.print("active"); %>"><i class="fas fa-user-cog"></i> Profile</a>
        <a href="<%=request.getContextPath()%>/teacher/settings"      class="nav-link <% if("settings".equals(_cp))      out.print("active"); %>"><i class="fas fa-cog"></i> Settings</a>
        <a href="<%=request.getContextPath()%>/teacher/help"          class="nav-link <% if("help".equals(_cp))          out.print("active"); %>"><i class="fas fa-question-circle"></i> Help</a>
        <div class="nav-divider"></div>
        <a href="<%=request.getContextPath()%>/teacher/logout" class="nav-link logout"><i class="fas fa-power-off"></i> Log Out</a>
    </nav>
</aside>