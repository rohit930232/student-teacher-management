<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "result");
    request.setAttribute("pageTitle", "Result");
    String className = (String) request.getAttribute("className");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Result</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/result.css">
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
                    <a href="<%=request.getContextPath()%>/admin/result" class="back-btn"><i class="fas fa-arrow-left"></i> Back</a>
                    <h2><i class="fas fa-chart-bar"></i> <%= className %> — Results</h2>
                </div>
                <div class="search-row">
                    <div class="search-box"><i class="fas fa-search"></i><input type="text" id="searchInput" placeholder="Search student..." onkeyup="searchTable()"></div>
                </div>
                <div class="table-wrap">
                    <table class="data-table" id="resultTable">
                        <thead>
                            <tr><th>#</th><th>Student Name</th><th>Roll No</th><th>Subject</th><th>Marks</th><th>Max Marks</th><th>Grade</th><th>Status</th><th>Exam Date</th></tr>
                        </thead>
                        <tbody>
                            <%
                                List<Map<String,String>> results = (List<Map<String,String>>) request.getAttribute("results");
                                if (results != null && !results.isEmpty()) {
                                    int i = 1;
                                    for (Map<String,String> r : results) {
                                        String grade = r.get("grade");
                                        boolean pass = !"F".equals(grade);
                            %>
                            <tr>
                                <td><%= i++ %></td>
                                <td><strong><%= r.get("name") %></strong></td>
                                <td><%= r.get("roll_number") %></td>
                                <td><%= r.get("subject") %></td>
                                <td><%= r.get("marks") %></td>
                                <td><%= r.get("max_marks") %></td>
                                <td><span class="grade-badge grade-<%= grade %>"><%= grade %></span></td>
                                <td><span class="<%= pass ? "pass-badge" : "fail-badge" %>"><%= pass ? "Pass" : "Fail" %></span></td>
                                <td><%= r.get("exam_date") != null ? r.get("exam_date").substring(0,10) : "-" %></td>
                            </tr>
                            <% } } else { %>
                            <tr><td colspan="9" class="empty-row">No results found</td></tr>
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
    document.querySelectorAll("#resultTable tbody tr").forEach(row => row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none");
}
</script>
</body>
</html>