<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "assignments");
    request.setAttribute("pageTitle", "Assignments");
    String className = (String) request.getAttribute("className");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Assignments</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/assignments.css">
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
                    <a href="<%=request.getContextPath()%>/admin/assignments" class="back-btn"><i class="fas fa-arrow-left"></i> Back</a>
                    <h2><i class="fas fa-tasks"></i> <%= className %> — Assignments</h2>
                </div>
                <div class="search-row">
                    <div class="search-box"><i class="fas fa-search"></i><input type="text" id="searchInput" placeholder="Search assignment..." onkeyup="searchTable()"></div>
                </div>
                <div class="table-wrap">
                    <table class="data-table" id="assignTable">
                        <thead>
                            <tr><th>#</th><th>Title</th><th>Subject / Teacher</th><th>Upload Date</th><th>Deadline</th><th>File</th></tr>
                        </thead>
                        <tbody>
                            <%
                                List<Map<String,String>> assignments = (List<Map<String,String>>) request.getAttribute("assignments");
                                if (assignments != null && !assignments.isEmpty()) {
                                    int i = 1;
                                    for (Map<String,String> a : assignments) {
                            %>
                            <tr>
                                <td><%= i++ %></td>
                                <td><strong><%= a.get("title") %></strong><br><small><%= a.get("description") != null ? a.get("description") : "" %></small></td>
                                <td><%= a.get("subject") != null ? a.get("subject") : "-" %><br><small><%= a.get("teacher_name") != null ? a.get("teacher_name") : "-" %></small></td>
                                <td><%= a.get("upload_date") != null ? a.get("upload_date").substring(0,10) : "-" %></td>
                                <td><%= a.get("deadline") != null ? a.get("deadline").substring(0,10) : "-" %></td>
                                <td>
                                    <% if (a.get("file_path") != null && !a.get("file_path").isEmpty()) { %>
                                    <a href="<%=request.getContextPath()%>/<%= a.get("file_path") %>" download class="btn-download"><i class="fas fa-download"></i> Download</a>
                                    <% } else { %>
                                    <span class="no-file">No file</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% } } else { %>
                            <tr><td colspan="6" class="empty-row"><i class="fas fa-tasks"></i> No assignments found</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
function searchTable() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    document.querySelectorAll("#assignTable tbody tr").forEach(row => row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none");
}
</script>
</body>
</html>