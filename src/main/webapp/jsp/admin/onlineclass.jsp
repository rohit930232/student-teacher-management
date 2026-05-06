<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "onlineclass");
    request.setAttribute("pageTitle", "Online Class");
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
                <h2 class="page-title"><i class="fas fa-video"></i> Online Class — Select Class</h2>
                <div class="class-grid">
                    <%
                        List<Map<String,String>> classList = (List<Map<String,String>>) request.getAttribute("classList");
                        if (classList != null && !classList.isEmpty()) {
                            for (Map<String,String> c : classList) {
                                boolean hasLive = "true".equals(c.get("has_live"));
                    %>
                    <a href="<%=request.getContextPath()%>/admin/onlineclass/class?classId=<%= c.get("class_id") %>&className=<%= c.get("class_name") %>" class="class-card <%= hasLive ? "has-live" : "" %>">
                        <div class="class-card-icon">
                            <i class="fas fa-video"></i>
                            <% if (hasLive) { %><span class="live-dot"></span><% } %>
                        </div>
                        <div class="class-card-info">
                            <h3><%= c.get("class_name") %></h3>
                            <% if (hasLive) { %><p class="live-text"><i class="fas fa-circle"></i> Live Now</p><% } else { %><p><i class="fas fa-clock"></i> <%= c.get("upcoming_count") != null ? c.get("upcoming_count") : "0" %> Upcoming</p><% } %>
                        </div>
                        <i class="fas fa-chevron-right arrow"></i>
                    </a>
                    <% } } else { %>
                    <div class="empty-state"><i class="fas fa-school"></i><p>No classes found</p></div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>