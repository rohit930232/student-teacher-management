<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "onlineclass");
    request.setAttribute("pageTitle", "Online Class");
    String className = (String) request.getAttribute("className");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Online Class</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/onlineclass.css">
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
                    <a href="<%=request.getContextPath()%>/admin/onlineclass" class="back-btn"><i class="fas fa-arrow-left"></i> Back</a>
                    <h2><i class="fas fa-video"></i> <%= className %> — Online Classes</h2>
                </div>
                <div class="section-title"><i class="fas fa-circle live-dot"></i> Live Now</div>
                <div class="class-grid">
                    <%
                        List<Map<String,String>> liveClasses = (List<Map<String,String>>) request.getAttribute("liveClasses");
                        if (liveClasses != null && !liveClasses.isEmpty()) {
                            for (Map<String,String> c : liveClasses) {
                    %>
                    <div class="online-card live">
                        <div class="online-card-head">
                            <span class="live-badge"><i class="fas fa-circle"></i> LIVE</span>
                            <span class="class-subject"><%= c.get("subject") %></span>
                        </div>
                        <div class="online-info">
                            <p><i class="fas fa-chalkboard-teacher"></i> <%= c.get("teacher_name") %></p>
                            <p><i class="fas fa-clock"></i> Ends at: <%= c.get("end_time") %></p>
                        </div>
                        <a href="<%= c.get("class_link") %>" target="_blank" class="btn-join"><i class="fas fa-video"></i> Join Now</a>
                    </div>
                    <% } } else { %>
                    <div class="empty-card"><i class="fas fa-video-slash"></i><p>No live classes right now</p></div>
                    <% } %>
                </div>
                <div class="section-title" style="margin-top:24px;"><i class="fas fa-calendar-alt"></i> Upcoming Classes</div>
                <div class="class-grid">
                    <%
                        List<Map<String,String>> upcomingClasses = (List<Map<String,String>>) request.getAttribute("upcomingClasses");
                        if (upcomingClasses != null && !upcomingClasses.isEmpty()) {
                            for (Map<String,String> c : upcomingClasses) {
                    %>
                    <div class="online-card upcoming">
                        <div class="online-card-head">
                            <span class="upcoming-badge"><i class="fas fa-clock"></i> Upcoming</span>
                            <span class="class-subject"><%= c.get("subject") %></span>
                        </div>
                        <div class="online-info">
                            <p><i class="fas fa-chalkboard-teacher"></i> <%= c.get("teacher_name") %></p>
                            <p><i class="fas fa-calendar"></i> <%= c.get("start_time") != null && c.get("start_time").length() >= 10 ? c.get("start_time").substring(0,10) : "" %></p>
                            <p><i class="fas fa-clock"></i> <%= c.get("start_time") != null && c.get("start_time").length() > 10 ? c.get("start_time").substring(11,16) : "" %></p>
                        </div>
                        <div class="link-info"><i class="fas fa-link"></i> Link available when class starts</div>
                    </div>
                    <% } } else { %>
                    <div class="empty-card"><i class="fas fa-calendar-times"></i><p>No upcoming classes</p></div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>