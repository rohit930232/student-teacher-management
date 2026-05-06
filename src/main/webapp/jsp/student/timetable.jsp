<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "timetable");
    request.setAttribute("pageTitle", "Timetable");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Timetable</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/timetable.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <jsp:include page="sidebar.jsp" />
    <div class="main">
       <jsp:include page="topbar.jsp" />
        <div class="page-body">
            <div class="page-card">
                <div class="page-card-head"><h2><i class="fas fa-calendar-alt"></i> Weekly Timetable</h2></div>
                <%
                    Map<String,List<Map<String,String>>> timetableByDay = (Map<String,List<Map<String,String>>>) request.getAttribute("timetableByDay");
                    String[] days = {"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"};
                %>
                <% if (timetableByDay != null && !timetableByDay.isEmpty()) { %>
                <div class="timetable-grid">
                    <% for (String day : days) {
                        List<Map<String,String>> slots = timetableByDay.get(day);
                        if (slots != null && !slots.isEmpty()) { %>
                    <div class="day-card">
                        <div class="day-head"><%= day %></div>
                        <div class="day-body">
                            <% for (Map<String,String> slot : slots) { %>
                            <div class="slot">
                                <div class="slot-subject"><i class="fas fa-book"></i> <%= slot.get("subject") %></div>
                                <div class="slot-time"><i class="fas fa-clock"></i> <%= slot.get("start_time") %> - <%= slot.get("end_time") %></div>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    <% } } %>
                </div>
                <% } else { %><div class="empty-state"><i class="fas fa-calendar-times"></i><p>No timetable found</p></div><% } %>
            </div>
        </div>
    </div>
</div>
</body>
</html>