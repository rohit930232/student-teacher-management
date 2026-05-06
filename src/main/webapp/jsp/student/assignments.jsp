<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "assignments");
    request.setAttribute("pageTitle", "Assignments");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Assignments</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/assignments.css">
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
                <div class="page-card-head">
                    <h2><i class="fas fa-tasks"></i> All Assignments</h2>
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchInput" placeholder="Search..." onkeyup="searchCards()">
                    </div>
                </div>
                <div class="assign-list" id="assignList">
                    <%
                        List<Map<String,String>> assignments = (List<Map<String,String>>) request.getAttribute("assignments");
                        if (assignments != null && !assignments.isEmpty()) {
                            for (Map<String,String> a : assignments) {
                                String uploadDate = a.get("upload_date") != null ? a.get("upload_date").substring(0,10) : "-";
                    %>
                    <div class="assign-card">
                        <div class="assign-card-left"><div class="assign-icon-big"><i class="fas fa-file-alt"></i></div></div>
                        <div class="assign-card-body">
                            <h3><%= a.get("title") %></h3>
                            <p><%= a.get("description") != null ? a.get("description") : "" %></p>
                            <div class="assign-meta">
                                <span><i class="fas fa-calendar"></i> Uploaded: <%= uploadDate %></span>
                                <span><i class="fas fa-chalkboard-teacher"></i> <%= a.get("teacher_name") != null ? a.get("teacher_name") : "Teacher" %></span>
                            </div>
                        </div>
                        <div class="assign-card-right">
                            <% if (a.get("file_path") != null && !a.get("file_path").isEmpty()) { %>
                            <a href="<%=request.getContextPath()%>/<%= a.get("file_path") %>" download class="btn-download"><i class="fas fa-download"></i> Download</a>
                            <% } else { %><span class="no-file">No file</span><% } %>
                        </div>
                    </div>
                    <% } } else { %>
                    <div class="empty-state"><i class="fas fa-tasks"></i><p>No assignments yet</p></div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
function searchCards() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    let cards = document.querySelectorAll(".assign-card");
    cards.forEach(card => card.style.display = card.innerText.toLowerCase().includes(input) ? "" : "none");
}
</script>
</body>
</html>