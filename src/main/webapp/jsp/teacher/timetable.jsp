<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "timetable");
    request.setAttribute("pageTitle", "Timetable");
    String selectedClass = request.getParameter("class_id");
    if (selectedClass == null) selectedClass = "";
    String[] days = {"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"};
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Timetable</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/timetable.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jsp" %>
    <div class="main">
        <%@ include file="topbar.jsp" %>
        <div class="page-body">

            <div class="class-tabs">
                <%
                    List<Map<String,String>> classes = (List<Map<String,String>>) request.getAttribute("classes");
                    if (classes != null) {
                        for (Map<String,String> c : classes) {
                            boolean isActive = c.get("class_id").equals(selectedClass);
                %>
                <a href="<%=request.getContextPath()%>/teacher/timetable?class_id=<%= c.get("class_id") %>"
                   class="class-tab <%= isActive ? "active" : "" %>">
                    <i class="fas fa-chalkboard"></i> <%= c.get("class_name") %>
                </a>
                <% } } %>
            </div>

            <% if (!selectedClass.isEmpty()) { %>
            <div class="page-card">
                <div class="page-card-head">
                    <h2><i class="fas fa-calendar-alt"></i> Class Timetable</h2>
                </div>
                <%
                    Map<String, List<Map<String,String>>> timetableByDay = (Map<String, List<Map<String,String>>>) request.getAttribute("timetableByDay");
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
                                <div class="slot-teacher"><i class="fas fa-user"></i> <%= slot.get("teacher_name") != null ? slot.get("teacher_name") : "Teacher" %></div>
                                <div class="slot-time"><i class="fas fa-clock"></i> <%= slot.get("start_time") %> - <%= slot.get("end_time") %></div>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    <% } } %>
                </div>
                <% } else { %><div class="empty-state"><i class="fas fa-calendar-times"></i><p>No timetable found for this class</p></div><% } %>
            </div>
            <% } else { %>
            <div class="select-class-msg"><i class="fas fa-hand-point-up"></i><p>Please select a class to view timetable</p></div>
            <% } %>
        </div>
    </div>
</div>
</body>
</html>