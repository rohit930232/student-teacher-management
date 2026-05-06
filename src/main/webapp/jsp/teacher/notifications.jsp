<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "notifications");
    request.setAttribute("pageTitle", "Notifications");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Notifications</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/notifications.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jsp" %>
    <div class="main">
        <%@ include file="topbar.jsp" %>
        <div class="page-body">
            <div class="page-card">
                <div class="page-card-head"><h2><i class="fas fa-bell"></i> All Notifications</h2></div>
                <div class="notif-list">
                    <%
                        List<Map<String,String>> notifs = (List<Map<String,String>>) request.getAttribute("notifications");
                        if (notifs != null && !notifs.isEmpty()) {
                            for (Map<String,String> n : notifs) {
                    %>
                    <div class="notif-item">
                        <div class="notif-dot"></div>
                        <div class="notif-body">
                            <p class="notif-msg"><%= n.get("message") %></p>
                            <span class="notif-time"><i class="fas fa-clock"></i> <%= n.get("date") != null ? n.get("date").substring(0,10) : "" %></span>
                        </div>
                    </div>
                    <% } } else { %><div class="empty-state"><i class="fas fa-bell-slash"></i><p>No notifications</p></div><% } %>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>