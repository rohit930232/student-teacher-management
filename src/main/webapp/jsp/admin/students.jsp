<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "students");
    request.setAttribute("pageTitle", "Students");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Students</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/students.css">
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
                <div class="page-title-row">
                    <h2><i class="fas fa-user-graduate"></i> All Classes</h2>
                    <a href="<%=request.getContextPath()%>/jsp/student/register.jsp" class="add-btn"><i class="fas fa-plus"></i> Add Student</a>
                </div>
                <div class="class-grid">
                    <%
                        List<Map<String,String>> classList = (List<Map<String,String>>) request.getAttribute("classList");
                        if (classList != null && !classList.isEmpty()) {
                            for (Map<String,String> c : classList) {
                    %>
                    <div class="class-card">
                        <div class="class-card-icon"><i class="fas fa-chalkboard"></i></div>
                        <div class="class-card-info">
                            <h3><%= c.get("class_name") %></h3>
                            <p><i class="fas fa-users"></i> <%= c.get("total") %> Students</p>
                            <p><i class="fas fa-chalkboard-teacher"></i> <%= c.get("class_teacher") != null && !c.get("class_teacher").isEmpty() ? c.get("class_teacher") : "Not Assigned" %></p>
                        </div>
                        <a href="<%=request.getContextPath()%>/admin/students/class?classId=<%= c.get("class_id") %>&className=<%= c.get("class_name") %>" class="view-class-btn">View Students &rsaquo;</a>
                    </div>
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