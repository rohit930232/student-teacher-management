<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "notes");
    request.setAttribute("pageTitle", "Notes");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Notes</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/notes.css">
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
                    <h2><i class="fas fa-book"></i> Study Notes</h2>
                    <div class="search-box"><i class="fas fa-search"></i><input type="text" id="searchInput" placeholder="Search notes..." onkeyup="searchNotes()"></div>
                </div>
                <div class="notes-grid" id="notesGrid">
                    <%
                        List<Map<String,String>> notes = (List<Map<String,String>>) request.getAttribute("notes");
                        if (notes != null && !notes.isEmpty()) {
                            String[] noteColors = {"blue","green","orange","purple","teal"};
                            int ni = 0;
                            for (Map<String,String> n : notes) {
                    %>
                    <div class="note-card <%= noteColors[ni % noteColors.length] %>">
                        <div class="note-card-head">
                            <span class="note-subject"><%= n.get("subject") %></span>
                            <span class="note-date"><%= n.get("created_date") != null ? n.get("created_date").substring(0,10) : "" %></span>
                        </div>
                        <h3 class="note-title"><%= n.get("title") %></h3>
                        <p class="note-teacher"><i class="fas fa-chalkboard-teacher"></i> <%= n.get("teacher_name") != null ? n.get("teacher_name") : "Teacher" %></p>
                        <div class="note-actions">
                            <% if (n.get("link") != null && !n.get("link").isEmpty()) { %>
                            <a href="<%= n.get("link") %>" target="_blank" class="btn-link"><i class="fas fa-external-link-alt"></i> Open Link</a>
                            <% } %>
                            <% if (n.get("file_path") != null && !n.get("file_path").isEmpty()) { %>
                            <a href="<%=request.getContextPath()%>/<%= n.get("file_path") %>" download class="btn-download"><i class="fas fa-download"></i> Download</a>
                            <% } %>
                        </div>
                    </div>
                    <% ni++; } } else { %><div class="empty-state-full"><i class="fas fa-book-open"></i><p>No notes available</p></div><% } %>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
function searchNotes() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    let cards = document.querySelectorAll(".note-card");
    cards.forEach(card => card.style.display = card.innerText.toLowerCase().includes(input) ? "" : "none");
}
</script>
</body>
</html>