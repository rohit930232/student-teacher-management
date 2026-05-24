<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "assignments");
    request.setAttribute("pageTitle", "Assignment Submissions");
    String _assignTitle     = (String) request.getAttribute("assignTitle");
    String _classId         = (String) request.getAttribute("classId");
    int    _submittedCount  = request.getAttribute("submittedCount") != null ? (Integer) request.getAttribute("submittedCount") : 0;
    int    _pendingCount    = request.getAttribute("pendingCount")   != null ? (Integer) request.getAttribute("pendingCount")   : 0;
    if (_classId == null) _classId = "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Submissions</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/assignments.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jsp" %>
    <div class="main">
        <%@ include file="topbar.jsp" %>
        <div class="page-body">

            <div class="back-bar">
                <a href="<%=request.getContextPath()%>/teacher/assignments?class_id=<%= _classId %>" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Back to Assignments
                </a>
            </div>

            <div class="submission-header">
                <h2><i class="fas fa-clipboard-list"></i> <%= _assignTitle != null ? _assignTitle : "Assignment" %> — Submissions</h2>
                <div class="submission-stats">
                    <span class="stat-submitted"><i class="fas fa-check-circle"></i> Submitted: <%= _submittedCount %></span>
                    <span class="stat-pending"><i class="fas fa-clock"></i> Pending: <%= _pendingCount %></span>
                </div>
            </div>

            <div class="page-card">
                <div class="page-card-head">
                    <h2><i class="fas fa-users"></i> Student List</h2>
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchInput" placeholder="Search student..." onkeyup="searchTable()">
                    </div>
                </div>
                <div class="table-wrap">
                    <table class="data-table" id="subTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Photo</th>
                                <th>Name</th>
                                <th>Roll No.</th>
                                <th>Status</th>
                                <th>Submitted On</th>
                                <th>Remarks</th>
                                <th>File</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Map<String,String>> _submissions = (List<Map<String,String>>) request.getAttribute("submissions");
                                if (_submissions != null && !_submissions.isEmpty()) {
                                    int _i = 1;
                                    for (Map<String,String> _sub : _submissions) {
                                        boolean _submitted = "true".equals(_sub.get("submitted"));
                            %>
                            <tr>
                                <td><%= _i++ %></td>
                                <td>
                                    <% if (_sub.get("photo") != null && !_sub.get("photo").isEmpty()) { %>
                                    <img src="<%=request.getContextPath()%>/<%= _sub.get("photo") %>" class="student-photo-sm" alt="photo">
                                    <% } else { %>
                                    <div class="student-photo-placeholder-sm">
                                        <%= _sub.get("name") != null && _sub.get("name").length() > 0 ? _sub.get("name").charAt(0) : "S" %>
                                    </div>
                                    <% } %>
                                </td>
                                <td><strong><%= _sub.get("name") %></strong></td>
                                <td><%= _sub.get("roll_number") %></td>
                                <td>
                                    <% if (_submitted) { %>
                                    <span class="badge-submitted"><i class="fas fa-check"></i> Submitted</span>
                                    <% } else { %>
                                    <span class="badge-pending"><i class="fas fa-clock"></i> Pending</span>
                                    <% } %>
                                </td>
                                <td>
                                    <%= (_sub.get("submitted_date") != null && !_sub.get("submitted_date").isEmpty())
                                        ? _sub.get("submitted_date").substring(0,10) : "-" %>
                                </td>
                                <td>
                                    <%= (_sub.get("remarks") != null && !_sub.get("remarks").isEmpty())
                                        ? _sub.get("remarks") : "-" %>
                                </td>
                                <td>
                                    <% if (_submitted && _sub.get("submitted_file") != null && !_sub.get("submitted_file").isEmpty()) { %>
                                    <a href="<%=request.getContextPath()%>/<%= _sub.get("submitted_file") %>"
                                       target="_blank" class="btn-view-file">
                                        <i class="fas fa-eye"></i> View
                                    </a>
                                    <% } else { %>
                                    <span class="text-muted">-</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% } } else { %>
                            <tr><td colspan="8" class="empty-row">No students found</td></tr>
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
    document.querySelectorAll("#subTable tbody tr").forEach(row => {
        row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none";
    });
}
</script>
</body>
</html>