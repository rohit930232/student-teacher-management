<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String _currentPage = (String) request.getAttribute("currentPage");
    if (_currentPage == null) _currentPage = "";
%>
<aside class="sidebar">
    <div class="brand">
        <img src="<%=request.getContextPath()%>/images/logo.png" class="brand-logo-img" alt="Logo">
    </div>
    <nav class="nav">
        <span class="nav-section">Main Menu</span>
        <a href="<%=request.getContextPath()%>/student/dashboard"    class="nav-link <%="_currentPage".equals("dashboard")    ? "active" : "" %>"><i class="fas fa-th-large"></i> Dashboard</a>
        <a href="<%=request.getContextPath()%>/student/assignments"  class="nav-link <% if("assignments".equals(_currentPage)) out.print("active"); %>"><i class="fas fa-tasks"></i> Assignments</a>
        <a href="<%=request.getContextPath()%>/student/attendance"   class="nav-link <% if("attendance".equals(_currentPage))  out.print("active"); %>"><i class="fas fa-clipboard-check"></i> Attendance</a>
        <a href="<%=request.getContextPath()%>/student/result"       class="nav-link <% if("result".equals(_currentPage))       out.print("active"); %>"><i class="fas fa-chart-bar"></i> Result</a>
        <a href="<%=request.getContextPath()%>/student/timetable"    class="nav-link <% if("timetable".equals(_currentPage))    out.print("active"); %>"><i class="fas fa-calendar-alt"></i> Timetable</a>
        <a href="<%=request.getContextPath()%>/student/exam"         class="nav-link <% if("exam".equals(_currentPage))         out.print("active"); %>"><i class="fas fa-file-alt"></i> Exam</a>
        <a href="<%=request.getContextPath()%>/student/notes"        class="nav-link <% if("notes".equals(_currentPage))        out.print("active"); %>"><i class="fas fa-book"></i> Notes</a>
        <a href="<%=request.getContextPath()%>/student/onlineclass"  class="nav-link <% if("onlineclass".equals(_currentPage))  out.print("active"); %>"><i class="fas fa-video"></i> Online Class</a>
        <span class="nav-section">More</span>
        <a href="<%=request.getContextPath()%>/student/notices"       class="nav-link <% if("notices".equals(_currentPage))       out.print("active"); %>"><i class="fas fa-bullhorn"></i> Notices</a>
        <a href="<%=request.getContextPath()%>/student/notifications" class="nav-link <% if("notifications".equals(_currentPage)) out.print("active"); %>"><i class="fas fa-bell"></i> Notifications</a>
        <a href="<%=request.getContextPath()%>/student/payment"       class="nav-link <% if("payment".equals(_currentPage))       out.print("active"); %>"><i class="fas fa-rupee-sign"></i> Payment</a>
        <a href="<%=request.getContextPath()%>/student/profile"       class="nav-link <% if("profile".equals(_currentPage))       out.print("active"); %>"><i class="fas fa-user"></i> Profile</a>
        <a href="<%=request.getContextPath()%>/student/settings"      class="nav-link <% if("settings".equals(_currentPage))      out.print("active"); %>"><i class="fas fa-cog"></i> Settings</a>
        <a href="<%=request.getContextPath()%>/student/help"          class="nav-link <% if("help".equals(_currentPage))          out.print("active"); %>"><i class="fas fa-question-circle"></i> Help</a>
        <div class="nav-divider"></div>
        <a href="<%=request.getContextPath()%>/student/logout" class="nav-link logout"><i class="fas fa-power-off"></i> Log Out</a>
    </nav>
</aside>