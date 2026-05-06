<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "notices");
    request.setAttribute("pageTitle", "Notices");
%>
<!DOCTYPE html>
<html>
jsp<head>
    <meta charset="UTF-8">
    <title>Notices</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/notices.css">
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
                    <h2><i class="fas fa-bullhorn"></i> All Notices</h2>
                    <div class="search-box"><i class="fas fa-search"></i><input type="text" id="searchInput" placeholder="Search notice..." onkeyup="searchList()"></div>
                </div>
                <div class="notice-list" id="noticeList">
                    <%
                        List<Map<String,String>> notices = (List<Map<String,String>>) request.getAttribute("notices");
                        if (notices != null && !notices.isEmpty()) {
                            for (Map<String,String> n : notices) {
                    %>
                    <div class="notice-item">
                        <div class="notice-icon"><i class="fas fa-bullhorn"></i></div>
                        <div class="notice-body">
                            <p class="notice-msg"><%= n.get("message") %></p>
                            <span class="notice-date"><i class="fas fa-calendar"></i> <%= n.get("date") != null ? n.get("date").substring(0,10) : "" %></span>
                        </div>
                    </div>
                    <% } } else { %><div class="empty-state"><i class="fas fa-bullhorn"></i><p>No notices available</p></div><% } %>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
function searchList() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    let items = document.querySelectorAll(".notice-item");
    items.forEach(item => item.style.display = item.innerText.toLowerCase().includes(input) ? "" : "none");
}
</script>
</body>
</html>